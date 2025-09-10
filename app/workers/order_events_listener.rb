require 'bunny'
require 'json'

class OrderEventsListener
  def self.run
    connection = Bunny.new(
      host: ENV['RABBITMQ_HOST'] || 'localhost',
      port: (ENV['RABBITMQ_PORT'] || 5672).to_i,
      user: ENV['RABBITMQ_USER'] || 'guest',
      password: ENV['RABBITMQ_PASSWORD'] || 'guest'
    )
    connection.start
    channel = connection.create_channel
     
    exchange = channel.direct('orders_events')

    queue = channel.queue('customer_orders', durable: true)

    queue.bind(exchange, routing_key: 'order.created')

    puts "Customer Service listening for order events..."

    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      event = JSON.parse(body)
      if event['event'] == 'OrderCreated'
        customer = Customer.find_by(id: event['customer_id'])
        customer.increment!(:orders_count) if customer
        puts "Updated orders_count for customer #{event['customer_id']}"
      end
    end
  end
end