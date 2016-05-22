here = ::File.dirname(__FILE__)

%w(config flickr five00).map do |l|
  require "#{here}/#{l}"
end

class Core
  def initialize(config_path)
    @config = Config.new(config_path)
    @flickr = Flickr.new(@config)
    @five00 = Five00.new(@config)
  end

  def init!
    @flickr.authorize unless @config.flickr_authorized?
  end
end
