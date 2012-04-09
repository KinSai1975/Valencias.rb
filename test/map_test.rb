require File.expand_path('../test_helper', __FILE__)

class RackApp
  def call(env)
    [200, {'Content-Type' => 'text/html'}, ["Hello from RackApp"]]
  end
end

class NancyApp < Nancy::Base
  get "/" do
    "Hello from NancyApp"
  end
end

class MainApp < Nancy::Base
  get "/" do
    "Hello from MainApp"
  end

  map "/rack_app" do
    run RackApp.new
  end

  map "/nancy_app" do
    run NancyApp
  end

  map "/lambda_app" do
    run lambda{|env| [200, {'Content-Type' => 'text/html'}, ["Hello from LambdaApp"]]}
  end
end

class UseTest < MiniTest::Unit::TestCase
  def setup
    @request = Rack::MockRequest.new(MainApp)
  end

  def test_main_app
    response = @request.get('/')
    assert_equal "Hello from MainApp", response.body
  end

  def test_map_with_rack_app
    response = @request.get('/rack_app')
    assert_equal "Hello from RackApp", response.body
  end

  def test_map_with_nancy_app
    response = @request.get('/nancy_app')
    assert_equal "Hello from NancyApp", response.body
  end

  def test_map_with_lambda
    response = @request.get('/lambda_app')
    assert_equal "Hello from LambdaApp", response.body
  end
end