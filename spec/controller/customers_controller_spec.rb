require 'rails_helper'

RSpec.describe "Customers API", type: :request do
  describe "GET /customers/:id" do
    let!(:customer) { Customer.create!(customer_name: "John Smith", address: "100 Main St", orders_count: 5) }

    it "returns the customer data if found" do
      get "/customers/#{customer.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["customer_name"]).to eq("John Smith")
      expect(json["address"]).to eq("100 Main St")
      expect(json["orders_count"]).to eq(5)
    end

    it "returns not found if customer does not exist" do
      get "/customers/99999"

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Customer not found")
    end
  end
end