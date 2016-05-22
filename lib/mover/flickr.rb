require 'flickraw'

class Flickr

  def initialize(config)
    @config = config

    ::FlickRaw.api_key = config.flickr['api_key']
    ::FlickRaw.shared_secret = config.flickr['shared_secret']

    @flickr = ::FlickRaw::Flickr.new

    # YEP! Flickraw creates a gloabl variable, `flickr`
    if config.flickr_authorized?
      flickr.access_token = config.flickr['access_token']
      flickr.access_secret = config.flickr['access_secret']
    else
      begin
        puts "[FLICKR] Hi #{@flickr.test.login.username}"
      rescue
        puts "tokens expired?"
      end
    end
  end

  def needs_auth?
    @config.flickr_authorized?
  end

  def authorize
    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'read')

    puts "Open this url in your process to complete the authication process"
    puts auth_url
    puts "Copy here the number given when you complete the process."

    verify = gets.strip

    flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
    login = flickr.test.login

    puts "Hi #{login.username}!"

    @config.update_flickr_tokens!('login' => login.username,
                                  'access_token' => flickr.access_token,
                                  'access_secret' => flickr.access_secret)

    puts "Auth done, your config has been updated!"
  end
end
