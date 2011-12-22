require 'spec_helper'

describe StackExchange::UserManager do
  let(:api_requestor) do
    double('Rubyflow::Client').as_null_object
  end
  let(:user_manager) do
    StackExchange::UserManager.new api_requestor
  end

  describe '#find_from_country' do
    context 'without reputation filter' do
      it 'should query for all users on SO' do
        api_requestor.should_receive(:users).with({:pagesize => 100}).and_return(nil)
        user_manager.find_from_country 'Minsk'
      end

      it 'should filter all SO user by specified country'
    end

    context 'with reputation filter' do
      it 'should return users from the country with reputation higher or equal to specified one'
    end
  end
end