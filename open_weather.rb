require 'httparty'
require 'pp'
require 'json'
require 'colorize'
class WeatherForecast
  include HTTParty #Have to include the gem

  #HTTParty::ClassMethods.base_uri method
  base_uri 'api.openweathermap.org/data/2.5/forecast/daily'

  #API Key will be given just before the script is run as an ENV var:
  API_KEY = ENV["OWA_API"]

  attr_accessor :location, :num_days

  def initialize(location = 'Calgary', num_days = '14')
    @location = location
    @num_days = num_days
  end

  def query
    query_uri = "http://api.openweathermap.org/data/2.5/forecast/daily?q=#{location}&mode=json&units=metric&cnt=#{num_days}&APPID=#{API_KEY}"
    @response = HTTParty.get(query_uri)
  end
  
  def forecast
    high_temps = []
    low_temps = []
    extra = []
    @response['list'].each do |day|
      high_temps << day['temp']['max']
      low_temps << day['temp']['min']
      extra << day['temp']['morn']
      extra << day['temp']['eve']
      extra << day['temp']['night']      
    end
    
    puts "The high and low for today are " + "#{high_temps[0]}".light_magenta + ", and " + "#{low_temps[0]}".light_blue + " degrees celcius respectively"
    puts "Today, the temperature in the morning will be " + "#{extra[0]}".light_cyan + " and the temperature in the evening will be " + "#{extra[1]}".light_yellow + " and at night, it will be " + "#{extra[2]}".blue + "."
    puts "The high and low for tomorrow are " + "#{high_temps[1]}".light_magenta + ", and " + "#{low_temps[1]}".light_blue + " degrees celcius respectively"
  end
end

agent = WeatherForecast.new
agent.query
agent.forecast
