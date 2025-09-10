class CustomersController < ApplicationController
  def show
    customer = Customer.find_by(id: params[:id])
    if customer
      render json: {
        customer_name: customer.customer_name,
        address: customer.address,
        orders_count: customer.orders_count
      }
    else
      render json: { error: 'Customer not found' }, status: :not_found
    end
  end
end