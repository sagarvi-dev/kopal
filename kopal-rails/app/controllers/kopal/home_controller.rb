class Kopal::HomeController < Kopal::ApplicationController

  #Homepage. Displayes User's profile and comments.
  #Also redirects to Kopal::ConnectController or feed if requested.
  #TODO: in place editor for "Status message".
  def index
    unless params[:"kopal.feed"].blank?
      redirect_to @kopal_route.feed
      return
    end
    unless params[:"kopal.connect"].blank?
      render_kopal_error "GET parameter \"kopal.subject\" is blank." and return if
        params[:"kopal.subject"].blank?
      params[:action] = params[:"kopal.subject"].to_s.gsub("-", "_")
      params.delete :controller
      params.delete :"kopal.connect"
      params.delete :"kopal.subject"
      #@kopal_route.connect(params) won't work. Got to change string keys to symbols.
      redirect_to @kopal_route.connect Hash[*(params.map { |k,v| [k.to_sym, v] }.flatten)]
    end
    @comments = Kopal::ProfileComment.find(:all, :limit => 20)
#    @pages_as_cloud = Kopal::ProfilePage.find(:all).map {|p|
#      { :label => p.to_s, :link => Kopal.route.page(p.page_name),
#        :title => "\"#{p}\", profile pages of #{@profile_user}",
#        :weight => p.page_text[:element].size
#      }
#    }
  end
  
  def comment
    ActiveSupport::Deprecation.warn "Do not use this path."
    redirect_to kopal_comments_path
  end


  def friend
    @_page.title <<= 'Friends'
  end

  #Redirects to Visitor's Profile Homepage.
  #TODO: Don't ask if user is signed.
  def foreign
    @_page.title <<= "Foreign Affairs"
    params[:returnurl].blank? || session[:kopal][:returnurl] = params[:returnurl]
    if params[:identity]
      identity = Kopal::Identity.new(params[:identity])
      case params[:subject]
      when 'request-friendship'
        redirect_to identity.request_friendship_url @profile_user.kopal_identity
        return
      when 'signin'
        redirect_to identity.signin_request_url session[:kopal].delete :returnurl
        #TODO: Not yet implemented. Needs that while signing-in using OpenID,
        #profiles know that request comes from a Kopal Identity and so they can
        #manage a list of Kopal Identities which requested signin and then send signout request
        #to all of them.
      when 'signout'
        redirect_to :action => :signout_for_visitor
      else
        flash.now[:notice] = "Unidentified value for <code>subject</code>"
      end
    end
  end

  #Displayes the Kopal Feed for user.
  def feed
    render :layout => false
  end
  
  #Provide more than just Gravatar, including any picture over internet, or 
  #let user upload one if supported gems, RMagick for example are installed.
  def profile_image
    require 'md5'
    if params[:of].blank? #self
      redirect_to gravatar_url @profile_user['feed_email']
    else
      #redirect to url or send raw data
      redirect_to Kopal::Identity.new(params[:of]).profile_image_url
    end
  end

  def signin
    DeprecatedMethod.here "Use sign/in instead."
    redirect_to kopal_sign_in_path
  end

  #Sign-in page for profile user.
  def signin_for_profile_user
    params[:via_kopal_connect].blank? || session[:kopal][:signing_via_kopal_connect] = params[:via_kopal_connect]
    @_page.title <<= "Sign In"

    if request.post?
      case @profile_user[:authentication_method]
      when 'password':
        if Kopal::KopalPreference.verify_password(@profile_user.account.id, params[:password])
          session[:kopal][:signed_kopal_identity] = @profile_user.kopal_identity.to_s
          if session[:kopal].delete :signing_via_kopal_connect
            uri = Kopal::Url.new session[:kopal].delete :return_after_signin
            uri.query_hash.update :"kopal.visitor" => @profile_user.kopal_identity.escaped_uri
            uri.build_query
            redirect_to uri.to_s
            return
          end
          redirect_to session[:kopal].delete :return_after_signin
          return
        end
        flash.now[:notice] = "Wrong password."
      end
    end
    render :signin
  end

  #Signs out user. To sign-out a user, use - +Kopal.route.signout+
  def signout
    session[:kopal][:signed_kopal_identity] = false
    redirect_to(params[:and_return_to] || @kopal_route.root)
  end

  #TODO: Extend OpenID to send/recieve request/response that it comes/serves from a Kopal Identity.
  def signin_for_visiting_user
    if params[:openid_identifier].blank?
      redirect_to @kopal_route.home(:action => 'foreign', :subject => 'signin-request')
      return
    end
    authenticate_with_openid { |result|
      if result.successful?
        session[:kopal][:signed_kopal_identity] = result.identifier
      else
        flash[:notice] = "OpenID verification failed for #{params[:openid_identifier]}"
      end
    }
    redirect_to(params[:return_path] || @kopal_route.root) unless send :'performed?'
  end

  def signout_for_visitor
    session[:kopal].delete :signed_kopal_identity
    session[:kopal].delete :signed_user_name
    redirect_to @kopal_route.root
  end

  def widget_canvas
    render :layout => false
  end

  #TODO: views/siterelated and views/_shared should go to views/kopal
  #ajax-spinner.gif. Credit - http://www.ajaxload.info/
  def stylesheet
    params[:format] ||= 'css'
    if params[:format] == 'js'
      response.content_type = "text/javascript"
    elsif params[:format] == 'css'
      response.content_type = "text/css"
    end
    params[:format] = "#{params[:format]}.erb" if params[:id] == 'dynamic'
    render :template => "siterelated/#{params[:id]}.#{params[:format]}", :layout => false
  end
  alias image stylesheet

  def javascript
    params[:format] ||= 'js'
    stylesheet
  end

  #Displayes the XRDS file for user. Accessible from +Kopal.route.xrds+
  def xrds
    render 'xrds', :content_type => 'application/xrds+xml', :layout => false
  end

  #Authenticates a user's by her OpenID.
  #
  #Usage -
  #  Kopal.route.openid(:openid_identifier => 'http://www.example.net/')
  #
  def openid
    authenticate_with_openid { |result|
      if result.successful?
        redirect_to
      else
        render :text => 'failed. ' + result.message, :status => :bad_request
      end
    }
  end

  #OpenID server for user's OpenID Identifier.
  #TODO: Extend OpenID to send/recieve request/response that it comes/serves from a Kopal Identity.
  def openid_server
    hash = {:signed => @signed, :openid_request => session.delete(:openid_last_request),
      :params => params.dup
    }
    begin
      s = Kopal::OpenID::Server.new hash
      s.begin
      case s.web_response.code
      when 200 #OpenID::Server::HTTP_OK
        render :text => s.web_response.body, :status => 200
      when 302 #OpenID::Server::HTTP_REDIRECT
        redirect_to s.web_response.headers['location']
      else #OpenID::Server::HTTP_ERROR => 400
        render :test => s.web_response.body, :status => 400
      end
    rescue Kopal::OpenID::AuthenticationRequired
      session[:openid_last_request] = s.openid_request
      redirect_to Kopal.route.signin :and_return_to =>
        (Kopal.route.openid_server :only_path => true)
    rescue Kopal::OpenID::OpenIDError => e
      render :text => e.message, :status => 500
    end
  end

  def update_status_message_aj
    #TODO: Write me.
  end

end
