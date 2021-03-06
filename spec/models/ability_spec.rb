require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'admin' do
    let(:user) { create(:user, :admin) }
    it 'allows to manage all resources' do
      expect(ability).to be_able_to(:manage, Competition.new)
      expect(ability).to be_able_to(:manage, Group.new)
      expect(ability).to be_able_to(:manage, Match.new)
      expect(ability).to be_able_to(:manage, Page)
      expect(ability).to be_able_to(:manage, Team.new)
      expect(ability).to be_able_to(:manage, Type.new)
      expect(ability).to be_able_to(:manage, User.new)
      expect(ability).to be_able_to(:manage, WinnerType.new)
    end
  end

  describe 'registered' do
    let(:user) { create(:user, :registered) }
    it 'allows to' do
      expect(ability).to be_able_to(:read, Competition.new)
      expect(ability).to be_able_to(%i[read create join], Group.new)
      expect(ability).to be_able_to(
        %i[update destroy],
        Group.new(owner_id: user.id)
      )
      expect(ability).to be_able_to(:read, Match.new)
      expect(ability).to be_able_to(:read, Page)
      expect(ability).to be_able_to(:read, Team.new)
      expect(ability).to be_able_to(:read, Type.new)
      expect(ability).to be_able_to(
        %i[create update destroy],
        Type.new(user_id: user.id)
      )
      expect(ability).to be_able_to(:read, User.new)
      expect(ability).to be_able_to(:create, WinnerType.new)
      expect(ability).to be_able_to(
        %i[read update],
        WinnerType.new(user_id: user.id)
      )
    end
  end

  describe 'guest' do
    let(:user) { create(:user, :guest) }
    it 'does not allow to get any resource' do
      %i[read create update destroy].each do |method|
        expect(ability).to_not be_able_to(method, Competition.new)
        expect(ability).to_not be_able_to(method, Group.new)
        expect(ability).to_not be_able_to(method, Match.new)
        expect(ability).to_not be_able_to(method, Page)
        expect(ability).to_not be_able_to(method, Team.new)
        expect(ability).to_not be_able_to(method, Type.new)
        expect(ability).to_not be_able_to(method, User.new)
        expect(ability).to_not be_able_to(method, WinnerType.new)
      end
    end
  end
end