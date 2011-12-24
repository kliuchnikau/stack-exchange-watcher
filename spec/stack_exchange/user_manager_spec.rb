require 'spec_helper'
require 'ostruct'



describe StackExchange::UserManager do
  let(:api_requestor) do
    double('Rubyflow::Client').as_null_object
  end
  let(:user_manager) do
    StackExchange::UserManager.new api_requestor
  end
  def mock_page_call(page_no, users_return, total = users_return.count, pagesize = 100)
    users = mock('Users')
    api_requestor.should_receive(:users).and_return(users)
    users.should_receive(:fetch).with({:pagesize => pagesize, :page => page_no}).and_return(OpenStruct.new({'total' => total, 'page' => page_no, 'pagesize' => pagesize, 'users' => users_return}))
  end

  describe '#all_users' do
    it 'should query for all users on SO' do
      mock_page_call(1, Array.new(100), 154)
      mock_page_call(2, Array.new(54), 154)

      users_list = user_manager.all_users

      users_list.should have(154).users
    end
  end

  describe '#find_from_country' do
    context 'without reputation filter' do
      it 'should filter all SO user by specified country' do
        users = Array.new(100) {|i| i % 2 == 0 ? OpenStruct.new(location: 'From minsk, Belarus') : OpenStruct.new(location: 'monsk')}
        mock_page_call(1, users)

        users_list = user_manager.find_from_country 'Minsk'

        users_list.should have(50).users
        users_list.all? {|u| u.location =~ /Minsk/i}
      end
    end

    context 'with reputation filter' do
      it 'should return users from the country with reputation higher or equal to specified one'
    end
  end
end