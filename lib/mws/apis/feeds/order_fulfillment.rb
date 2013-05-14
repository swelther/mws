module Mws::Apis::Feeds

  class OrderFulfillment

    attr_reader :amazon_order_id, :carrier_code, :shipping_method, :shipping_tracking_number, :fulfillment_date

    def initialize(amazon_order_id, carrier_code, shipping_method, shipping_tracking_number, fulfillment_date = nil)
      @amazon_order_id = amazon_order_id
      @carrier_code = carrier_code
      @shipping_method = shipping_method
      @shipping_tracking_number = shipping_tracking_number
      @fulfillment_date = fulfillment_date

      #ProductBuilder.new(self).instance_eval &block if block_given?
      #raise Mws::Errors::ValidationError, 'Product must have a category when details are specified.' if @details and @category.nil?
    end

    def to_xml(name='Orders/Order', parent=nil)
      Mws::Serializer.tree name, parent do |xml|
        xml.MessageType 'OrderFulfillment'
        xml.Message {
          xml.MessageID '1'
          xml.OrderFulfillment {
            xml.AmazonOrderID @amazon_order_id
            xml.MerchantOrderID @merchent_order_id unless @merchent_order_id.nil?
            xml.FulfillmentDate if @fulfillment_date.nil? ? Time.now.iso8601 : @fulfillment_date
            xml.FulfillmentData {
              xml.CarrierCode @carrier_code unless @carrier_code.nil?
              xml.ShippingMethod @shipping_method unless @shipping_method.nil?
              xml.ShipperTrackingNumber @shipping_tracking_number
            }
#            order_items.each do | item |
#              xml.Item {
#                xml.AmazonOrderItemCode item[:order_item_id]
#                xml.Quantity item[:amount]
#              }
#            end
          }
        }
      end
    end

  end

end
