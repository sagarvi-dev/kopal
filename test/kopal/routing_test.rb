require "#{File.dirname(__FILE__)}/../test_helper" 

class RoutingTest < Test::Unit::TestCase

  def setup
    Kopal.draw_routes '/profile2/'
  end

  def test_kopal_base_route_is_profile2
    assert_equal '/profile2', Kopal.base_route
  end

  def test_kopal_route_root
    assert_equal Kopal.base_route + '/', Kopal.route.root
    ['', '/'].each { |r|
      assert_recognition :get, '', :controller => 'kopal/home', :action => 'index',
        :trailing_slash => true
    }
  end
  
  def test_kopal_route_home
    assert_equal Kopal.base_route + '/', Kopal.route.home
    assert_recognition :get, '/home/', :controller => 'kopal/home',
      :action => 'index', :trailing_slash => true
  end

  def test_kopal_route_profile_comment
    assert_equal Kopal.base_route + '/home/comment/', Kopal.route.profile_comment
    assert_recognition :get, '/home/comment/', :controller => 'kopal/home',
      :action => 'comment', :trailing_slash => true
  end

  def test_kopal_route_stylesheet
    assert_equal Kopal.base_route + '/home/stylesheet/home.css', Kopal.route.stylesheet('home')
    assert_equal Kopal.route.stylesheet('home'), Kopal.route.stylesheet(:id => 'home')
    assert_recognition :get, '/home/stylesheet/home.css', :controller => 'kopal/home',
      :action => 'stylesheet', :id => 'home', :format => 'css', :trailing_slash => false
  end

  def test_kopal_route_profile_image
    assert_equal Kopal.base_route + '/home/profile_image/profile_user.jpeg',
      Kopal.route.profile_image(Kopal::ProfileUser.new)
    assert_recognition :get, '/home/profile_image', :controller => 'kopal/home',
      :action => 'profile_image', :trailing_slash => true #FIXME: trailing slash should come false.
  end

  def test_kopal_route_feed
    assert_equal Kopal.base_route + '/home/feed.kp.xml', Kopal.route.feed
    assert_recognition :get, '/home/feed.kp.xml', :controller => 'kopal/home',
      :action => 'feed', :format => 'xml', :trailing_slash => false
  end

  def test_kopal_route_connect
    assert_equal Kopal.base_route + '/connect/requested_subject/',
      Kopal.route.connect(:action => 'requested_subject')
    assert_recognition :get, '/connect/requested_subject/', :controller => 'kopal/connect',
      :action => 'requested_subject', :trailing_slash => true
  end

  def test_kopal_route_xrds
    assert_equal 'http://test.host' + Kopal.base_route + '/home/xrds/',
      Kopal.route.xrds
    assert_recognition :get, '/home/xrds/', :controller => 'kopal/home',
      :action => 'xrds', :trailing_slash => true
  end

  def test_kopal_route_openid_consumer
    assert_equal Kopal.base_route + '/home/openid/', Kopal.route.openid_consumer
    assert_recognition :get, '/home/openid/', :controller => 'kopal/home',
      :action => 'openid', :trailing_slash => true
  end

  def test_kopal_route_openid_consumer_complete
    assert_equal 'http://test.host' + Kopal.base_route + '/home/openid/',
      Kopal.route.openid_consumer_complete
    #No recognition on this route.
  end

  def test_kopal_route_openid_server
    assert_equal 'http://test.host' + Kopal.base_route + '/home/openid_server/',
      Kopal.route.openid_server
    assert_recognition :get, '/home/openid_server', :controller => 'kopal/home',
      :action => 'openid_server', :trailing_slash => true
  end

  def test_kopal_route_signin
    assert_equal Kopal.base_route + '/home/signin/', Kopal.route.signin
    assert_recognition :get, '/home/signin/', :controller => 'kopal/home',
      :action => 'signin', :trailing_slash => true
  end

  def test_kopal_route_signout
    assert_equal Kopal.base_route + '/home/signout/', Kopal.route.signout
    assert_recognition :get, '/home/signout/', :controller => 'kopal/home',
      :action => 'signout', :trailing_slash => true
  end

  def test_kopal_route_friend
    assert_equal Kopal.base_route + '/home/friend/', Kopal.route.friend
    assert_recognition :get, '/home/friend/', :controller => 'kopal/home',
      :action => 'friend', :trailing_slash => true
  end

  def test_kopal_route_organise
    assert_equal Kopal.base_route + '/organise/', Kopal.route.organise
    assert_recognition :get, '/organise/', :controller => 'kopal/organise',
      :action => 'index', :trailing_slash => true
  end

  def test_kopal_route_organise_friend
    assert_equal Kopal.base_route + '/organise/friend/', Kopal.route.organise_friend
    assert_recognition :get, '/organise/friend/', :controller => 'kopal/organise',
      :action => 'friend', :trailing_slash => true
  end

  def test_kopal_route_edit_identity
    assert_equal Kopal.base_route + '/organise/edit_identity/', Kopal.route.edit_identity
    assert_recognition :get, '/organise/edit_identity/', :controller => 'kopal/organise',
      :action => 'edit_identity', :trailing_slash => true
  end

  def test_kopal_route_change_password
    assert_equal Kopal.base_route + '/organise/change_password/', Kopal.route.change_password
    assert_recognition :get, '/organise/change_password/', :controller => 'kopal/organise',
      :action => 'change_password', :trailing_slash => true
  end
  
private
  
  def assert_recognition(method, path, options)
    result = ActionController::Routing::Routes.recognize_path(Kopal.base_route + path,
      :method => method)
    assert_equal options, result
  end
end
