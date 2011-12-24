require 'spec_helper'
require 'ostruct'

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
        users1 = mock('Users')
        api_requestor.should_receive(:users).and_return(users1)
        users1.should_receive(:fetch).with({:pagesize => 100, :page => 1})
          .and_return(OpenStruct.new({'total' => 154, 'page' => 1, 'pagesize' => 100, 'users' => Array.new(100)}))

        users2 = mock('Users')
        api_requestor.should_receive(:users).and_return(users2)
        users2.should_receive(:fetch).with({:pagesize => 100, :page => 2})
          .and_return(OpenStruct.new({'total' => 154, 'page' => 2, 'pagesize' => 100, 'users' => Array.new(54)}))

        users_list = user_manager.find_from_country 'Minsk'

        users_list.should have(154).users
      end

      it 'should filter all SO user by specified country'
    end

    context 'with reputation filter' do
      it 'should return users from the country with reputation higher or equal to specified one'
    end
  end
end