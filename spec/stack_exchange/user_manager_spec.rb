require 'spec_helper'

describe StackExchange::UserManager do
  let(:api_requestor) do
    double('Rubyflow::Client').as_null_object
  end
  let(:user_manager) do
    StackExchange::UserManager.new api_requestor
  end
  def mock_page_call(page_no, users_return, total = users_return.count, pagesize = 100)
    users = double('Users')
    api_requestor.should_receive(:users).and_return(users)
    res = fake_users_result(users_return, total, page_no, pagesize)
    users.should_receive(:fetch).with({:pagesize => pagesize, :page => page_no}).and_return(res)
  end
  def mock_users_call_with_reputation(reputation, returns)
    users = double('User')
    api_requestor.should_receive(:users).and_return(users)
    users.should_receive(:fetch).with(pagesize: 100, page: 1, min: reputation).and_return(returns)
  end
  def fake_users_result users = Array.new(100), total = users.count, page = 1, pagesize = 100
    OpenStruct.new({'total' => total, 'page' => page, 'pagesize' => pagesize, 'users' => users})
  end

  describe '#all_users' do
    it 'should query for all users on SO' do
      mock_page_call(1, Array.new(100), 154)
      mock_page_call(2, Array.new(54), 154)

      users_list = user_manager.all_users

      expect(users_list.count).to eq 154
    end

    context 'when reputation filter provided' do
      it 'should query for all users with reputation higher than specified' do
        mock_users_call_with_reputation(1000, fake_users_result)

        user_manager.all_users 1000
      end
    end
  end

  describe '#find_from_country' do
    let(:minsk_users) do
      Array.new(100) {|i| i % 2 == 0 ? OpenStruct.new(location: 'From minsk, Belarus') : OpenStruct.new(location: 'monsk')}
    end

    context 'without reputation filter' do
      it 'should filter all SO user by specified country' do
        mock_page_call(1, minsk_users)

        users_list = user_manager.find_from_country 'Minsk'

        expect(users_list.count).to eq 50
        expect(users_list.all? {|u| u.location =~ /Minsk/i}).to be_truthy
      end
    end

    context 'with reputation filter' do
      it 'should return users from the country with reputation higher or equal to specified one' do
        mock_users_call_with_reputation(1000, fake_users_result(minsk_users))

        user_manager.find_from_country 'Minsk', 1000
      end
    end
  end
end
