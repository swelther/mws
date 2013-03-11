class Mws::Apis::Orders

  def initialize(connection, overrides={})
    @connection = connection
    @param_defaults = {
      market: 'ATVPDKIKX0DER'
    }.merge overrides
    @option_defaults = {
      version: '2011-01-01',
      list_pattern: '%{key}.%{ext}.%<index>d'
    }
  end

  def status(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'GetServiceStatus'
    doc = @connection.get "/Orders/#{options[:version]}", params, options
    doc.xpath('Status').first.text # return the status text
  end

  def list(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'ListOrders'
    doc = @connection.get "/Orders/#{options[:version]}", params, options

    doc.xpath('Orders/Order').map do | node |
      {
        :AmazonOrderId => node.xpath('AmazonOrderId').text,
        :TotalAmount => node.xpath('OrderTotal/Amount').text,
        :CurrencyCode => node.xpath('OrderTotal/CurrencyCode').text,
        :BuyerName => node.xpath('BuyerName').text,
        :BuyerEmail => node.xpath('BuyerEmail').text,
        :OrderStatus => node.xpath('OrderStatus').text,
        :PaymentMethod => node.xpath('PaymentMethod').text,
        :PurchaseDate => node.xpath('PurchaseDate').text.to_time,

        :shipping_address =>
        {
          :name => node.xpath('ShippingAddress/Name').text,
          :street => node.xpath('ShippingAddress/AddressLine2').text,
          :post_code => node.xpath('ShippingAddress/PostalCode').text,
          :city => node.xpath('ShippingAddress/City').text,
          :country_code => node.xpath('ShippingAddress/CountryCode').text,
          :phone => node.xpath('ShippingAddress/Phone').text
        },

        :order_items => {}
      }
    end
  end

  def list_items(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'ListOrderItems'
    doc = @connection.get "/Orders/#{options[:version]}", params, options
    doc
  end

end
