require 'spec_helper'
describe CurrencyHelper do
	
	before(:each) do
    @current_firm = mock_model("Firm")
    
  end
	it 'returns kr 12 001.50' do
		@current_firm.stub(:currency){"NOK"}
		helper.currency_converter("12001.50").should eq "12 001,50 kr"
	end
	it 'returns kr 12 001.00' do
		@current_firm.stub(:currency){"USD"}
		helper.currency_converter("12001.0").should eq "$12,001.00"
	end
	it 'returns kr 12 001.00' do
		@current_firm.stub(:currency){"EUR"}
		helper.currency_converter("12001.0").should eq "12.001,00 €"
	end
end      