require 'spec_helper'

describe HomworksController do

  #Delete these examples and add some real ones
  it "should use HomworksController" do
    controller.should be_an_instance_of(HomworksController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
end
