#User, whom this application belongs to.
#There should be only one instance of this class accessible from Kopal.profile_user
class Kopal::ProfileUser < Kopal::KopalUser

  def initialize signed = false
    @signed = signed
    @pref_cache = {}
    #Enforce single instance.
    #raise "Only one instance allowed." if @@single_instance
    #@@single_instance = true
  end

  #Indexes KopalPreference
  def [] index
    index = index.to_s
    @pref_cache[index] ||= Kopal::KopalPreference.get_field(index)
  end

  def []= index, value
    index = index.to_s
    @pref_cache[index] = Kopal::KopalPreference.save_field(index, value)
  end

  def reload_preferences!
    @pref_cache = {}
  end

  def to_s
    feed.name
  end

  #If the current visitor is profile user herself? Or in other words,
  #should we enable administrative tasks?
  def signed?
    @signed
  end

  def signed_out!
    @signed = false
  end

  def kopal_identity
    Kopal[:kopal_identity] ||= Kopal.route.root :only_path => false
    Kopal::Identity.new Kopal[:kopal_identity]
  end
  alias profile_identity kopal_identity
  alias profile_homepage kopal_identity
  alias homepage kopal_identity
  alias profile_url kopal_identity

  def kopal_feed_url
    DeprecatedMethod.here "Use .kopal_identity.feed_url() instead."
    kopal_identity.feed_url
  end

  #User has created her Identity?
  #Identity is the core part of user's profile. (not to be confused with
  #kopal_identity.)
  def created_identity?
    !!Kopal[:feed_real_name]
  end

  def feed
    @kopal_feed ||= Kopal::Feed.new preferences_for_feed
  end

  def preferences_for_feed
    r = {}
    Kopal::KopalPreference.find(:all, :conditions => "preference_name LIKE 'feed_%'").
      each { |e|
        r[e.preference_name] = e.preference_text
      }
    r
  end

  #Duplication? !DRY?
  def status_message
    Kopal[:user_status_message]
  end

  def image_path
    Kopal.route.profile_image self, :only_path => false
  end

  #Delegate to Feed and deprecate it.
  def show_dob?
    return false if Kopal[:feed_birth_time_pref] == 'nothing'
    return true
  end

  #Delegate to Feed and deprecate it. rename to dob_has_year?
  def can_show_age?
    return true if Kopal[:feed_birth_time_pref] =~ /^y/
    return false
  end

  #delegate to Feed and deprecate it.
  def dob_string
    unless Kopal[:feed_birth_time].blank?
      year = Kopal[:feed_birth_time].year
      return case Kopal[:feed_birth_time_pref]
      when 'y':
        year.to_s
      when 'md':
        Kopal[:feed_birth_time].to_time.strftime("%d-%b")
      when 'ymd':
        Kopal['feed_birth_time'].to_time.strftime("%d-%b-%Y")
      end
    end
    return ''
  end

  #Returns the date of birth as string, followed by age in brackets.
  #Respects date of birth preference in +Kopal[:feed_birth_time_pref]+
  #delegate to Feed and deprecate it.
  def dob_with_age
    unless feed.birth_time.blank?
      #age_string = " (#{age} #{t(:year, :count => year).downcase})"
      age_string = " (#{feed.age} years)"
      return case Kopal[:feed_birth_time_pref]
      when /y|md/:
        dob_string + age_string
      when /md/:
        dob_string
      end
    end
    return ''
  end

  #USE WITH CAUTION!
  #Returns an instance of OpenSSL::PKey::RSA
  def private_key!
    if Kopal[:kopal_encoded_private_key].blank?
      regenerate_private_key!
    end
    OpenSSL::PKey::RSA.new Base64::decode64(Kopal[:kopal_encoded_private_key])
  end

  def public_key
    private_key!.public_key
  end

  #Default is 2048, recommended by RSA see -
  #http://www.rsa.com/rsalabs/node.asp?id=2004#table1
  #http://www.rsa.com/rsalabs/node.asp?id=2218
  #We don't need to be very future-proof because
  #We ain't encrypting any private data, where eve stores cipher text today, and analyses
  #it when technology becomes feasible.
  #Also, Private key can be changed over time so age of value of a cipher text of today is
  #as long as user changes the Private key.
  #Also note that identity of a user is tied with her Kopal Identity (profile url)
  #and not with her private key.
  def private_key_length
    #Kopal[:kopal_private_key_length] ||
      2048
  end

  #Will invalidate everything done in past!
  #Encode Private key before saving to database. Since private key starts with "--" and
  #value is serialised ActiveRecord screws up and replaces "\n"
  #with " ".
  def regenerate_private_key!
    Kopal[:kopal_encoded_private_key] =
      Base64::encode64(OpenSSL::PKey::RSA.new(private_key_length).to_pem)
  end

  def friends
    Kopal::UserFriend.find_all_by_friendship_state("friend")
  end

  #Returns false if not friend, else the friendship state
  def friend? friend_identity
    f = Kopal::UserFriend.find_by_kopal_identity(normalise_url(friend_identity.to_s))
    return false if f.nil?
    return f.friendship_state == 'friend'
  end

  #Validate the friendship state for all or specific friend.
  #Ends with ! since requires network resource.
  def validate_friendship! specific_friend = nil
    #TODO: Write me
    raise NoMetodError
  end
end
