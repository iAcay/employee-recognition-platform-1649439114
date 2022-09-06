require 'rails_helper'

RSpec.describe CreateOrderService do
  context 'when buying a reward with online delivery method' do
    it 'returns true, adds new order to database and assign online code to order when all params are properly set' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      online_code = create(:online_code, reward: reward_with_online_delivery)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      create_order_service = described_class.new(order_params)

      expect(Order.count).to eq 0
      expect(create_order_service.call).to be true
      expect(Order.count).to eq 1
      expect(Order.last.online_code).to eq online_code
      expect(Order.last.online_code.status).to eq 'used'
    end

    it 'sends an email after purchase a reward with online delivery' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      create(:online_code, reward: reward_with_online_delivery)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      create_order_service = described_class.new(order_params)

      expect { create_order_service.call }.to change { ActionMailer::Base.deliveries.count }.by 1
    end

    it 'returns false if there is no available online code for reward' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      create_order_service = described_class.new(order_params)

      expect(create_order_service.call).to be false
      expect(create_order_service.errors.to_s).to include 'Reward is not available now.'
    end
  end

  context 'when buying a reward with post delivery method' do
    it 'returns true, adds new order and adress to database when all params are properly set and does not send email' do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post_delivery')
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = attributes_for(:address)
      create_order_service = described_class.new(order_params.merge(address_params))

      expect(Order.count).to eq 0
      expect(create_order_service.call).to be true
      expect(Order.count).to eq 1
      expect(ActionMailer::Base.deliveries.count).to eq 0
      expect(Order.last.address_snapshot.street).to eq address_params[:street]
      expect(Order.last.address_snapshot.postcode).to eq address_params[:postcode]
      expect(Order.last.address_snapshot.city).to eq address_params[:city]
    end

    it "updates employee's address when address already exists" do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post_delivery')
      first_address = create(:address, employee: employee)
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = attributes_for(:address)
      create_order_service = described_class.new(order_params.merge(address_params))

      expect(Address.count).to eq 1
      expect(employee.address.street).to eq first_address.street
      expect(employee.address.postcode).to eq first_address.postcode
      expect(employee.address.city).to eq first_address.city

      expect { create_order_service.call }.not_to change(Address, :count)

      employee.reload
      expect(employee.address.street).not_to eq first_address.street
      expect(employee.address.postcode).not_to eq first_address.postcode
      expect(employee.address.city).not_to eq first_address.city
      expect(employee.address.street).to eq address_params[:street]
      expect(employee.address.postcode).to eq address_params[:postcode]
      expect(employee.address.city).to eq address_params[:city]
    end

    it 'returns false while address data are not proper' do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post_delivery')
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = {}
      create_order_service = described_class.new(order_params.merge(address_params))

      expect(create_order_service.call).to eq false
      expect(create_order_service.errors.to_s).to include "Street can't be blank"
      expect(create_order_service.errors.to_s).to include "Postcode can't be blank"
      expect(create_order_service.errors.to_s).to include "City can't be blank"
    end
  end
end
