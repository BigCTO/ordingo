# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  slug        :string
#  status      :integer
#  type_of     :integer
#  uuid        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_products_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:email) { 'sachin@test.com' }
  let(:type_of) { 'single' }
  let(:status) { 'draft' }
  let(:user) { User.create!(name: 'sachin', email:, password: '12345556', terms_of_service: true) }
  let(:account) { Account.create!(owner: user, name: 'sachin') }

  subject do
    described_class.new(account:, type_of:, status:)
  end

  context 'when creating with different attributes missing or invalid' do
    context 'when account is nil' do
      it 'object is invalid' do
        subject.account = nil
        expect(subject).to_not be_valid
      end
    end

    context 'with invalid type_of value' do
      let(:type_of) { 'test' }
      it 'validation error is thrown when trying to save' do
        expect { subject.save! }.to  raise_error(ArgumentError, "'test' is not a valid type_of")
      end
    end

    context 'with invalid status value' do
      let(:status) { 'test' }
      it 'validation error is thrown when trying to save' do
        expect { subject.save! }.to  raise_error(ArgumentError, "'test' is not a valid status")
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

  context 'when product is deleted' do
    before { subject.save! }

    it 'webhook is triggered' do
      expect(subject).to receive(:deliver_webhook).with(:deleted)
      subject.destroy!
    end
  end
end
