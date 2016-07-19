require 'httparty'
require 'pry'

class MyApi
  include HTTParty
  base_uri "https://json-party.herokuapp.com"

  def initialize email, password
    @email = email
    @password = password
  end

  def login
    resp = MyApi.post "/users/sign_in.json", #headers: headers,
    body: {
      user: {
        email: @email,
        password: @password,
        remember_me: 1
          }
        }
    binding.pry
  end

  def signup
    resp = MyApi.post "/users.json", #headers: headers,
    body: {
      user: {
        email: @email,
        password: @password,
        password_confirmation: @password,
        first_name: "David",
        last_name: "Grayboff",
        screen_name: "json"
          }
        }

    r = JSON.parse(resp.body)
    binding.pry
  end

  private

  def headers
    {
      "Authorization" => "#{@email}:#{@password}",
      "Accept"        => "application/json"
    }
  end
end


# print "What's your email? > "
email = "jtjordan13@gmail.com"

# print "What's your password? > "
password = "hunter2"

api = MyApi.new email, password
api.signup
