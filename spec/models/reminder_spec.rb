require 'rails_helper'

RSpec.describe Reminder, type: :model do

  it 'have valid factory' do
    expect(FactoryGirl.build(:reminder).valid?).to be_truthy
  end

  describe 'validations' do

    it 'should have appointment' do
      expect(FactoryGirl.build(:reminder, appointment: nil).valid?).to be_falsey
    end

    describe 'remind_at' do

      it 'cannot be blank' do
        expect(FactoryGirl.build(:reminder, remind_at: nil).valid?).to be_falsey
      end

      it 'cannot be past' do
        expect(FactoryGirl.build(:reminder, remind_at: 1.minutes.ago).valid?).to be_falsey
      end

      it 'cannot be later than appointment start time' do
        appointment = FactoryGirl.create(:appointment)
        expect(FactoryGirl.build(:reminder, appointment: appointment, remind_at: appointment.start_at + 1.minutes).valid?).to be_falsey
      end

    end

  end
end
