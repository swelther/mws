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

  # Status for the order api. 'GREEN', 'YELLOW', 'RED'
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
      }
    end
  end

  # Call with :Amazon_Order_Id => 'xxyyzz' (from result of function list) to get the order items
  def list_items(params={})
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact
    options = @option_defaults.merge action: 'ListOrderItems'
    doc = @connection.get "/Orders/#{options[:version]}", params, options

    doc.xpath('OrderItems/OrderItem').map do | node |
      {
      }
    end
  end

  # Sends order fullfillment details to amazon
  # Needed: amazon_order_id, carrier_code, shipping_method, shipping_tracking_number
  # Optional: merchant_order_id, fulfillment_date
  def send_fullfillment_data(params, order_items)
    raise Mws::Errors::ValidationError.new('An amazon_order_id is needed') if !params.has_key?(:amazon_order_id) || params[:amazon_order_id].empty?
    raise Mws::Errors::ValidationError.new('A carrier_code is needed') if !params.has_key?(:carrier_code) || params[:carrier_code].empty?
    raise Mws::Errors::ValidationError.new('A shipping_method is needed') if !params.has_key?(:shipping_method) || params[:shipping_method].empty?
    raise Mws::Errors::ValidationError.new('A shipping_tracking_number is needed') if !params.has_key?(:shipping_tracking_number) || params[:shipping_tracking_number].empty?
    raise Mws::Errors::ValidationError.new('order_items must be a array.') if !order_items.is_a?(Array)
    params[:markets] ||= [ params.delete(:markets) || params.delete(:market) || @param_defaults[:market] ].flatten.compact

    order_xml = Nokogiri::XML::Builder.new do | xml |
      xml.AmazonEnvelope('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:noNamespaceSchemaLocation' => 'amznenvelope.xsd') {
        xml.Header {
          xml.DocumentVersion '1.01'
          xml.MerchantIdentifier 'lichtspot'
        }
        xml.MessageType 'OrderFulfillment'
        xml.Message {
          xml.MessageID '1'
          xml.OrderFulfillment {
            xml.AmazonOrderID params[:amazon_order_id]
            xml.MerchantOrderID params[:merchent_order_id] if params.has_key?(:merchent_order_id)
            xml.FulfillmentDate params.has_key?(:fulfillment_date) ? params[:fulfillment_date] : Time.now.iso8601
            xml.FulfillmentData {
              xml.CarrierCode params[:carrier_code]
              xml.ShippingMethod params[:shipping_method]
              xml.ShipperTrackingNumber params[:shipping_tracking_number]
            }
            order_items.each do | item |
              xml.Item {
                xml.AmazonOrderItemCode item[:order_item_id]
                xml.Quantity item[:amount]
              }
            end
          }
        }
      }
    end.to_xml

    #binding.pry

    @connection.feeds.submit order_xml, {:feed_type => :order_fulfillment}

  end

end
