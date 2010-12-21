require 'spec_helper'

describe HomeworksController do

  #Delete these examples and add some real ones
  it "should use HomeworksController" do
    controller.should be_an_instance_of(HomeworksController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
end
