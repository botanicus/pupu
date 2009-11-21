require_relative "spec_helper"

describe "Simle example" do
  before(:each) do
    @response = get("/examples/simple")
  end

  it "should be successful" do
    @response.should be_successful
  end

  it "should be successful" do
    @response.should be_successful
  end

  it "should link to"
end

describe "Examples with arguments" do
  before(:each) do
    @response = get("/examples/arguments")
  end

  it "should be successful" do
    @response.should be_successful
  end
end

describe "Examples with dependencies" do
  before(:each) do
    @response = get("/examples/dependencies")
  end

  it "should be successful" do
    @response.should be_successful
  end
end
