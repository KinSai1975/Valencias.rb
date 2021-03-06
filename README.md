# Valencias.rb

![Valencias](http://i1208.photobucket.com/albums/cc369/Sboubi/valencias_zpsav6ykilb.png)


## Description

Minimal Ruby microframework for web development inspired in [Sinatra](http://www.sinatrarb.com/) and [Cuba](https://github.com/soveran/cuba)


## Installation

Install the gem:

    $ gem install valencias

or add it to your Gemfile:

    gem "valencias"


## Usage

Here's a simple application:

```ruby
# hello.rb
require "valencias"
require "valencias/render"

class Hello < Valencias::Base
  use Rack::Session::Cookie, secret: ENV['SECRET_TOKEN'] # for sessions
  include Valencias::Render

  get "/" do
    "Hello World"
  end

  get "/hello" do
    response.redirect "/"
  end

  get "/hello/:name" do
    "Hello #{params['name']}"
  end

  post "/hello" do
    "Hello #{params['name']}"
  end

  get "/template" do
    @message = "Hello world"
    render("views/hello.erb")
  end

  post "/login" do
    @user = User.find(params['username'])
    halt 401, "unauthorized" unless @user.authenticate(params['password'])
    session[:authenticated] = true
    render("views/layout.erb") { render("views/welcome.erb") }
  end
  
  before do
    if request.path_info == "/protected" && !session[:authenticated]
      halt 401, "unauthorized"
    end
  end

  get "/protected" do
    "Protected area!!!"
  end
  
  after do
    if request.path_info ~= /\.json$/
      response['Content-Type'] = 'application/json'
    else
      response['Content-Type'] = 'text/html'
    end
  end

  get "/users/:id.json" do
    @user = User.find(params['id'])
    halt 404 unless @user
    UserSerializer.new(@user).to_json
  end

  map "/resque" do
    run Resque::Server
  end

  map "/valencias" do
    run AnotherValenciasApp.new
  end
end
```

To run it, you can create a `config.ru` file:

```ruby
# config.ru
require "./hello"

run Hello.new
```

You can now run `rackup` and enjoy what you have just created.

Check examples folder for a detailed example.


## Features
*  Very fast
*  "Sinatra-like" routes: support for get, post, put, patch, delete, options, head
*  Template rendering and caching through Tilt or ERB from stdlib
*  Set basic filters/callbacks with the before/after methods
*  Include middlewares with the use method
*  Mount rack apps with the map method
*  Sessions through Rack::Session
*  Halt execution at any point using Ruby's throw/catch mechanism
*  Thread-safe


## Version history

### 0.4.0 (unreleased)
*   Added support for basic before/after filters
*   Added Valencias::BasicRender for rendering of templates using ``ERB`` from stdlib
*   Refactored full code to set proper accessors for all methods
*   Removed Valencias::Base.call, only instances can be used to run apps
*   Removed redirect helper, use instead ``response.redirect '/uri'``
*   Valencias::Render is not loaded automatically, "valencias/render" needs to be required
*   Removed ``tilt`` dependency, to use Valencias::Render add it manually to app
*   Valencias::Base#halt can't be used with a ``Rack::Response`` object anymore

### 0.3.0 (Octuber 3, 2012)
*   Removed unneccesary Thread accessors, use simple instance getters instead
*   Refactored Valencias::Base#halt

### 0.2.0 (April 12, 2012)

*   Set PATH INFO to '/' when is blank
*   Fixed session method: Raise error when is used but Rack::Session isn't present
*   Added support for HEAD and OPTIONS HTTP verbs
*   Refactored Base.use to use a Rack::Builder internally
*   Added Base.map to redirect requests to Rack sub-apps

### 0.1.0 (April 4, 2012)

*   Created a new [Github Page](http://guilleiguaran.github.com/valencias) for the project
*   Added env accessor, this add support for [Shield](https://github.com/cyx/shield)
*   Added support for templates caching using Tilt::Cache
*   Moved render method from Valencias::Base to Valencias::Render module
*   Refactored Valencias::Base to evaluate code blocks at instance level
*   Fixed passing of render options to Tilt (thanks to [lporras](https://github.com/lporras))

### 0.0.1 (March 20, 2012)

*   Initial Release


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Copyright (c) 2012-2014 Guillermo Iguaran. See LICENSE for
further details.

