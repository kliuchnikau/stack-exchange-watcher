require 'spec_helper'

module StackExchange
  describe Questions do
    let(:requestor) { double('Rubyflow::Client').as_null_object }
    before(:each) { @manager = StackExchange::Questions.new(requestor) }

    describe '#set_last_tag_check' do
      it 'should set last tag check date' do
        unixtime = Time.now.to_i
        @manager.set_last_tag_check 'ruby', unixtime
        @manager.get_last_tag_check('ruby').should == unixtime
      end
    end

    describe '#get_last_tag_check' do
      it 'should return nil if no time were set for this tag before' do
        @manager.get_last_tag_check('c++').should be_nil
      end
    end

    describe '#get_new_questions' do
      it 'should receive '
    end
  end
end