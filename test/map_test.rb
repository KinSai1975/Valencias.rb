require File.expand_path('../test_helper', __FILE__)

class RackApp
  def call(env)
    [200, {'Content-Type' => 'text/html'}, ["Hello from RackApp"]]
  end
end

class ValenciasApp < Valencias::Base
  get "/" do
    "Hello from ValenciasApp"
  end
end

class MainApp < Valencias::Base
  get "/" do
    "Hello from MainApp"
  end

  map "/rack_app" do
    run RackApp.new
  end

  map "/valencias_app" do
    run ValenciasApp.new
  end

  map "/lambda_app" do
    run lambda{|env| [200, {'Content-Type' => 'text/html'}, ["Hello from LambdaApp"]]}
  end
end

class MapTest < Minitest::Test
  def setup
    @request = Rack::MockRequest.new(MainApp.new)
  end

  def test_main_app
    response = @request.get('/')
    assert_equal "Hello from MainApp", response.body
  end

  def test_map_with_rack_app
    response = @request.get('/rack_app')
    assert_equal "Hello from RackApp", response.body
  end

  def test_map_with_valencias_app
    response = @request.get('/valencias_app')
    assert_equal "Hello from ValenciasApp", response.body
  end

  def test_map_with_lambda
    response = @request.get('/lambda_app')
    assert_equal "Hello from LambdaApp", response.body
  end
end
