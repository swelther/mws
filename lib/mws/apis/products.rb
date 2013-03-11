class Mws::Apis::Products

  def initialize(connection, overrides={})
    @connection = connection
    @param_defaults = {
      market: 'ATVPDKIKX0DER'
    }.merge overrides
    @option_defaults = {
      version: '2011-10-01',
      list_pattern: '%{key}.%{ext}.%<index>d'
    }
  end

  def status(params={})
    options = @option_defaults.merge action: 'GetServiceStatus'
    doc = @connection.get "/Products/#{options[:version]}", params, options
    doc
  end

  def list_matching_products(params={})
    options = @option_defaults.merge action: 'ListMatchingProducts'
    doc = @connection.get "/Products/#{options[:version]}", params, options
    doc
  end

  def get_competitive_pricing_for_sku(params={})
    params[:Seller_SKU_List] ||= [ params.delete(:SellerSKUList) || [] ].flatten.compact
    options = @option_defaults.merge action: 'GetCompetitivePricingForSKU'
    doc = @connection.get "/Products/#{options[:version]}", params, options
    doc
  end

end
