require 'rails_helper'

RSpec.describe Appointment, type: :model do

  it 'have valid factory' do
    expect(FactoryGirl.build(:appointment).valid?).to be_truthy
  end

  describe 'validations' do

    it 'should have user' do
      expect(FactoryGirl.build(:appointment, user: nil).valid?).to be_falsey
    end

    describe 'start_at' do

      it 'cannot be blank' do
        expect(FactoryGirl.build(:appointment, start_at: nil).valid?).to be_falsey
      end

      it 'cannot be past' do
        expect(FactoryGirl.build(:appointment, start_at: 1.minutes.ago).valid?).to be_falsey
      end

      it 'cannot be overlap with another appointment' do
        user = FactoryGirl.create(:user)
        existing_appointment = FactoryGirl.create(:appointment, user: user)
        expect(FactoryGirl.build(:appointment, user: user, start_at: existing_appointment.start_at - 50.minutes).valid?).to be_falsey
        expect(FactoryGirl.build(:appointment, user: user, start_at: existing_appointment.start_at + 50.minutes).valid?).to be_falsey
      end

      it 'cannot be overlap with another user appointment' do
        user = FactoryGirl.create(:user)
        existing_appointment = FactoryGirl.create(:appointment, user: user)
        expect(FactoryGirl.build(:appointment, start_at: existing_appointment.start_at - 50.minutes).valid?).to be_truthy
        expect(FactoryGirl.build(:appointment, start_at: existing_appointment.start_at + 50.minutes).valid?).to be_truthy
      end

    end

  end

end
