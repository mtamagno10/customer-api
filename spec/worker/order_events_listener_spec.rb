require 'rails_helper'

RSpec.describe OrderEventsListener do
  describe ".run" do
    let(:channel) { double("Channel") }
    let(:exchange) { double("Exchange") }
    let(:queue) { double("Queue") }
    let(:customer) { Customer.create!(customer_name: "John Doe", address: "123 Main St", orders_count: 2) }

    before do
      bunny_connection = double("Bunny", start: true, create_channel: channel, close: true)
      allow(Bunny).to receive(:new).and_return(bunny_connection)
      allow(channel).to receive(:direct).with('orders_events').and_return(exchange)
      allow(channel).to receive(:queue).with('customer_orders', durable: true).and_return(queue)
      allow(queue).to receive(:bind).with(exchange, routing_key: 'order.created')
    end

    it "increments orders_count when an OrderCreated event is received" do
      event_payload = {
        event: "OrderCreated",
        customer_id: customer.id,
        order_id: 999
      }.to_json

      # Simula la suscripción y el manejo del mensaje
      expect(queue).to receive(:subscribe).with(block: true).and_yield(nil, nil, event_payload)

      expect {
        described_class.run
      }.to change { customer.reload.orders_count }.by(1)
    end

    it "does nothing if customer does not exist" do
      event_payload = {
        event: "OrderCreated",
        customer_id: 99999,
        order_id: 888
      }.to_json

      expect(queue).to receive(:subscribe).with(block: true).and_yield(nil, nil, event_payload)
      expect {
        described_class.run
      }.not_to change { Customer.count }
    end
  end
end