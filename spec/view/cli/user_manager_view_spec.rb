require 'spec_helper'

module View::Cli
  describe UserManagerView do
    let(:output) { double('output').as_null_object }
    let(:users) do
      [OpenStruct.new({"user_id"=>1, "display_name"=>"Alex", "reputation"=>1500}),
      OpenStruct.new({"user_id"=>2, "display_name"=>"John", "reputation"=>230})]
    end
    subject { UserManagerView.new(output) }

    describe '#show_list' do
      context 'when found users' do
        it 'shows found users count' do
          output.should_receive(:puts).with("Found 2 users")
          subject.show_list users
        end
      end

      context 'when found nothing' do
        it 'shows message that nothing was found' do
          output.should_receive(:puts).with("No results found").twice

          subject.show_list nil
          subject.show_list []
        end
      end
    end
  end
end