# frozen_string_literal: true

require 'sinatra'
# require 'sinatra/reloader'
require 'sinatra/activerecord'
require './helpers'
require 'securerandom'

class App < Sinatra::Base
  configure do
    set :json_encoder, :to_json
    set :erb, layout: :layout
  end
  before do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
  end

  options '*' do
    response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
    response.headers['Access-Control-Allow-Headers'] =
      'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  end

  get '/' do
    @feedback = {}
    @errors = []
    erb :index
  end

  post '/' do
    @feedback = params[:feedback] || {}
    @errors = []

    if @feedback['qualification'].nil? || @feedback['qualification'].empty?
      @errors << "You must select a qualification rating."
    end

    if @feedback['description'].nil? || @feedback['description'].strip.empty?
      @errors << "Description cannot be blank."
    end

    # Check if validations passed
    if @errors.empty?
      # Logic to save to database goes here (e.g., Feedback.create(@feedback))
      "Feedback saved successfully! Rating: #{@feedback['qualification']}, Description: #{@feedback['description']}"
    else
      # Halt and re-render the form.
      # @feedback and @errors are passed back to the view to show the user's input and errors.
      erb :index
    end
  end

  get '/admin' do
    "Hello world"
  end
end
