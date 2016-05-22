require 'yaml'

class Config
  def initialize(path)
    @path = ::File.expand_path(path)
  end

  def valid?
    begin
      config
    rescue => e
      puts "No config file in this location: #{@path}"
      false
    end

    # TODO: more checks for values
  end

  def flickr
    config['flickr']
  end

  def to_s
    config.to_yaml
  end

  def flickr_authorized?
    !(
      (flickr['access_token'].nil? || flickr['access_token'].empty?) &&
      (flickr['access_secret'].nil? || flickr['access_secret'].empty?) )
  end

  def update_flickr_tokens!(tokens)
    flickr_settings = @config['flickr'].merge(tokens)
    @config['flickr'] = flickr_settings

    ::File.write(@path, YAML.dump(@config))
  end

  def f00px
    config['500px']
  end

  def include_private?
    @config['include_private']
  end

  private
  def config
    @config ||= ::YAML.load_file(@path)
  end
end
