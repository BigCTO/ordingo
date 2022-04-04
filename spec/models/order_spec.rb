# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  delivery_method    :string           default("pending")
#  discount_price     :decimal(8, 2)
#  fulfillment_status :string           default("pending")
#  slug               :string
#  subtotal_price     :decimal(8, 2)
#  total_price        :decimal(8, 2)
#  transaction_status :string           default("pending")
#  uuid               :string
#  weight             :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :integer
#  address_id         :bigint
#  customer_id        :bigint
#
# Indexes
#
#  index_orders_on_address_id   (address_id)
#  index_orders_on_customer_id  (customer_id)
#  index_orders_on_slug         (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:email) { 'sachin@test.com' }
  let(:fulfillment_status) { 'pending' }
  let(:transaction_status) { 'pending' }
  let(:delivery_method) { 'pending' }
  let(:status) { 'draft' }
  let(:user) { User.create!(name: 'sachin', email:, password: '12345556', terms_of_service: true) }
  let(:account) { Account.create!(owner: user, name: 'sachin') }
  let(:customer) { Customer.create(email:, account:) }
  let(:address) { Address.create!(customer: customer) }

  subject do
    described_class.new(account:, fulfillment_status:, transaction_status:, delivery_method:, customer:, address:)
  end

  context 'when creating with different attributes missing or invalid' do
    context 'when account is nil' do
      it 'object is invalid' do
        subject.account = nil
        expect(subject).to_not be_valid
      end
    end

    context 'when customer is nil' do
      it 'object is invalid' do
        subject.customer = nil
        expect(subject).to_not be_valid
      end
    end

    context 'when address is nil' do
      it 'object is invalid' do
        subject.address = nil
        expect(subject).to_not be_valid
      end
    end

    context 'with invalid fulfillment_status value' do
      let(:fulfillment_status) { 'test' }
      it 'validation error is thrown when trying to save' do
        expect { subject.save! }.to  raise_error(ArgumentError, "'test' is not a valid fulfillment_status")
      end
    end

    context 'with invalid transaction_status value' do
      let(:transaction_status) { 'test' }
      it 'validation error is thrown when trying to save' do
        expect { subject.save! }.to  raise_error(ArgumentError, "'test' is not a valid transaction_status")
      end
    end

    context 'with invalid delivery_method value' do
      let(:delivery_method) { 'test' }
      it 'validation error is thrown when trying to save' do
        expect { subject.save! }.to  raise_error(ArgumentError, "'test' is not a valid delivery_method")
      end
    end
  end

  context 'with valid attribute values' do
    it 'object is valid' do
      expect(subject).to be_valid
    end

    it 'webhook is triggered' do
      expect(subject).to receive(:deliver_webhook).with(:created)
      subject.save!
    end
  end

  context 'when updating the existing record' do
    before { subject.save! }

    it 'webhook is triggered' do
      expect(subject).to receive(:deliver_webhook).with(:updated)
      subject.save!
    end
  end

  context 'when order is deleted' do
    before { subject.save! }

    it 'webhook is triggered' do
      expect(subject).to receive(:deliver_webhook).with(:deleted)
      subject.destroy!
    end
  end
end
