require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:email) { 'sachin@test.com' }
  let(:user) { User.create!(name: 'sachin', email:, password: '12345556', terms_of_service: true) }
  let(:account) { Account.create!(owner: user, name: 'sachin') }

  subject do
    described_class.new(email:, account:)
  end

  context 'when creating with different attributes missing or invalid' do
    context 'with different email value' do
      context 'when email is nil' do
        it 'object is invalid' do
          subject.email = nil
          expect(subject).to_not be_valid
        end
      end

      context 'when email already exist' do
        before { subject.save! }
        it 'validation error is thrown when trying to save' do
          customer = Customer.new(email:, account:)
          expect do
            customer.save!
          end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email has already been taken')
        end
      end
    end

    context 'when account is nil' do
      it 'object is invalid' do
        subject.account = nil
        expect(subject).to_not be_valid
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

  context 'when customer is deleted' do
    before { subject.save! }

    it 'webhook is triggered' do
      expect(subject).to receive(:deliver_webhook).with(:deleted)
      subject.destroy!
    end
  end
end
