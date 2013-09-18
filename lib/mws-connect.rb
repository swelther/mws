require 'base64'
require 'openssl'

module Mws

  autoload :Apis, 'mws/apis'
  autoload :Connection, 'mws/connection'
  autoload :Enum, 'mws/enum'
  autoload :EnumEntry, 'mws/enum'
  autoload :Errors, 'mws/errors'
  autoload :Query, 'mws/query'
  autoload :Serializer, 'mws/serializer'
  autoload :Signer, 'mws/signer'
  autoload :Utils, 'mws/utils'
  autoload :VERSION, 'mws/version'

  Utils.alias self, Apis::Feeds, 
    :Distance,
    :Feed,
    :ImageListing,
    :Inventory,
    :Money,
    :PriceListing,
    :Product,
    :OrderFulfillment,
    :Shipping,
    :Weight

  def self.connect(options)
    Connection.new options
  end

end
