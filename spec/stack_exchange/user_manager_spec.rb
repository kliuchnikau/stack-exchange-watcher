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
    def mock_page_call(page_no, total, users_return, pagesize = 100)
      users = mock('Users')
      api_requestor.should_receive(:users).and_return(users)
      users.should_receive(:fetch).with({:pagesize => pagesize, :page => page_no}).and_return(OpenStruct.new({'total' => total, 'page' => page_no, 'pagesize' => pagesize, 'users' => users_return}))
    end

    context 'without reputation filter' do
      it 'should query for all users on SO' do
        mock_page_call(1, 154, Array.new(100))
        mock_page_call(2, 154, Array.new(54))

        users_list = user_manager.find_from_country 'Minsk'

        users_list.should have(154).users
      end

      it 'should filter all SO user by specified country' do

      end
    end

    context 'with reputation filter' do
      it 'should return users from the country with reputation higher or equal to specified one'
    end
  end
end