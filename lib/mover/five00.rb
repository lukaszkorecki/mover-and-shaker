require 'f00px'

class Five00
  def initialize(config)
    @config = config
    @f00 = ::F00px::Client.new

#    @f00.xauth(config.f00px['login'], config.f00px['password'])


  end


end
