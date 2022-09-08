require 'rails_helper'

RSpec.describe CreateOrderService do
  context 'when buying a reward with online delivery method' do
    it 'returns true, adds new order to database and assign online code to order when all params are properly set' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      online_code = create(:online_code, reward: reward_with_online_delivery)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      service = described_class.new(order_params)

      result = nil
      expect { result = service.call }.to change(Order, :count).by(1)
      expect(result).to be true
      expect(Order.last.online_code).to eq online_code
      expect(Order.last.online_code.status).to eq 'used'
    end

    it 'sends an email after purchase a reward with online delivery' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      create(:online_code, reward: reward_with_online_delivery)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      service = described_class.new(order_params)

      expect { service.call }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'returns false if there is no available online code for reward' do
      employee = create(:employee, earned_points: 1)
      reward_with_online_delivery = create(:reward)
      order_params = { employee_id: employee.id, reward_id: reward_with_online_delivery.id }
      service = described_class.new(order_params)

      expect(service.call).to be false
      expect(service.errors.to_s).to include 'Reward is not available now.'
    end
  end

  context 'when buying a reward with post delivery method' do
    it 'returns true, adds new order and adress to database when all params are properly set and does not send email' do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post')
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = { street: '221B Baker Street', postcode: 'NW1 6XE', city: 'London' }
      service = described_class.new(order_params.merge(address_params))

      result = nil
      before_call_mail_deliveries_count = ActionMailer::Base.deliveries.count

      expect { result = service.call }.to change(Order, :count).by(1)
      expect(result).to be true
      expect(ActionMailer::Base.deliveries.count).to eq before_call_mail_deliveries_count
      expect(Order.last.address_snapshot).to have_attributes(
        street: '221B Baker Street',
        postcode: 'NW1 6XE',
        city: 'London'
      )
    end

    it "updates employee's address when address already exists" do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post')
      create(:address, employee: employee)
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = { street: '221B Baker Street', postcode: 'NW1 6XE', city: 'London' }
      service = described_class.new(order_params.merge(address_params))

      expect { service.call }.not_to change(Address, :count)

      employee.reload
      expect(employee.address).to have_attributes(
        street: '221B Baker Street',
        postcode: 'NW1 6XE',
        city: 'London'
      )
    end

    it 'returns false while address data are not proper' do
      employee = create(:employee, earned_points: 1)
      reward_with_post_delivery = create(:reward, delivery_method: 'post')
      order_params = { employee_id: employee.id, reward_id: reward_with_post_delivery.id }
      address_params = {}
      service = described_class.new(order_params.merge(address_params))

      expect(service.call).to be false
      expect(service.errors.to_s).to include "Street can't be blank"
      expect(service.errors.to_s).to include "Postcode can't be blank"
      expect(service.errors.to_s).to include "City can't be blank"
    end
  end

  context 'when buying a reward with pick-up delivery method' do
    it 'returns true, adds new order to database when all params are properly set' do
      employee = create(:employee, earned_points: 1)
      reward_with_pick_up_delivery = create(:reward, delivery_method: 'pick_up')
      order_params = { employee_id: employee.id, reward_id: reward_with_pick_up_delivery.id }
      service = described_class.new(order_params)

      result = nil
      expect { result = service.call }.to change(Order, :count).by(1)
      expect(result).to be true
    end

    it 'sends an email with instructions after purchase a reward with pick-up delivery' do
      employee = create(:employee, earned_points: 1)
      reward_with_pick_up_delivery = create(:reward, delivery_method: 'pick_up')
      order_params = { employee_id: employee.id, reward_id: reward_with_pick_up_delivery.id }
      service = described_class.new(order_params)

      expect { service.call }.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq 'Pick-up delivery instructions'
    end
  end
end
