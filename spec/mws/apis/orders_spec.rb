require 'spec_helper'

module Mws::Apis

  describe Orders do

    let(:defaults) {
      {
        merchant: 'GSWCJ4UBA31UTJ',
        access: 'AYQAKIAJSCWMLYXAQ6K3',
        secret: 'Ubzq/NskSrW4m5ncq53kddzBej7O7IE5Yx9drGrX'
      }
    }

    let(:connection) {
      Mws.connect(defaults)
    }

    let(:orders) { connection.orders }

    context 'status' do

      it 'should return a status code' do
        ['GREEN', 'YELLOW', 'RED'].should include orders.status(:market => 'ATVPDKIKX0DER')
      end

    end

    context 'send_fullfillment_data' do

      it 'should require an amazon_order_id' do
        expect {
          orders.send_fulfillment_data(Hash.new, [{}])
        }.to raise_error Mws::Errors::ValidationError, 'An amazon_order_id is needed'
      end

      it 'should require an amazon_order_id' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'An amazon_order_id is needed'
      end

      it 'should require an carrier_code' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123'}])
        }.to raise_error Mws::Errors::ValidationError, 'A carrier_code is needed'
      end

      it 'should require an carrier_code' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '12', :carrier_code => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'A carrier_code is needed'
      end

      it 'should not require a shipping_method' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12'}])
        }.to_not raise_error Mws::Errors::ValidationError, 'A shipping_method is needed'
      end

      it 'should not require a shipping_method' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12', :shipping_method => ''}])
        }.to_not raise_error Mws::Errors::ValidationError, 'A shipping_method is needed'
      end

      it 'should not require a shipping_tracking_number' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12', :shipping_method => '12'}])
        }.to_not raise_error Mws::Errors::ValidationError, 'A shipping_tracking_number is needed'
      end

      it 'should not require a shipping_tracking_number' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12', :shipping_method => '12', :shipping_tracking_number => ''}])
        }.to_not raise_error Mws::Errors::ValidationError, 'A shipping_tracking_number is needed'
      end

      it 'should require order_items as a array' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '111', :order_items => '', :carrier_code => '12', :shipping_method => '123', :shipping_tracking_number => '12'}])
        }.to raise_error Mws::Errors::ValidationError, 'order_items must be a array.'
      end

    end

  end

end
