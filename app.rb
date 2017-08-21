require 'sinatra'
require 'sinatra/flash'
require 'httparty'
require 'json'
require 'dotenv/load'

enable :sessions

class Review
  include HTTParty
  base_uri ENV['REVIEWS_API_BASE_URL']

  def self.fetch
    response = get '/reviews?published=true', format: :plain
    JSON.parse response, symbolize_names: true
  end
end

helpers do
  def json_to_ruby_time(json_date)
    string_elements = json_date.split /[-T:+]+/
    string_elements.pop
    Time.new *(string_elements.map(&:to_i))
  end
end

get '/' do
  redirect '/reviews'
end

get '/reviews' do
  @reviews = Review.fetch
  erb :index
end
