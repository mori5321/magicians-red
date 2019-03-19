require_relative "../magicians_red"
require_relative "../models/advice"

class SampleController < MagiciansRed::BaseController
  def index
    MagiciansRed::Response.new.tap do |response|
      response.status_code = 200
      response.headers = {"Content-Type" => "application/json"}
      response.body = {
        data: Advice.new.advice_list
      }.to_json
    end
  end

  def create
    body = JSON.parse env["rack.input"].gets
    MagiciansRed::Response.new.tap do |response|
      response.status_code = 201
      response.headers = {"Content-Type" => "application/json"}
      response.body = { message: :created, body: body }.to_json
    end
  end
end