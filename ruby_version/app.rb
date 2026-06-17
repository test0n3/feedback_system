# frozen_string_literal: true

require 'sinatra'
# require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'sinatra/flash'
# require_relative 'helpers/helpers'
require_relative 'config/application'
require 'securerandom'

# enable :sessions

class App < Sinatra::Base
  configure do
    enable :sessions
    register Sinatra::Flash
    # set :json_encoder, :to_json
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
    # @feedback = {}
    # @errors = []
    erb :index
  end

  helpers ViewHelpers

  post '/' do
    @feedback = params[:feedback] || {}
    # @errors = []

    qual = (@feedback['qualification'].to_s.strip == '' ? nil : @feedback['qualification'].to_i)
    desc = (@feedback['description'] || '').strip

    # puts "qual: #{qual}, desc: #{desc}"
    # if qual.nil?
    #   @errors << 'You must select a qualification rating.'
    # end
    #
    # if desc.nil? || desc.empty?
    #   @errors << 'Description cannot be blank.'
    # end

    feedback = Feedback.new(qualification: qual, description: desc)

    if feedback.save
      flash[:notice] = 'Thanks - your feedback was saved.'
      redirect '/'
    else
      # Surface model errors to the view and repopulate the form
      @errors = feedback.errors.full_messages
      @feedback = { 'qualification' => qual, 'description' => desc }
      erb :index
    end

    # Check if validations passed
    # if @errors.empty?
      # Logic to save to database goes here (e.g., Feedback.create(@feedback))
      # feedback = Feedback.new(qualification: qual, description: desc)
      # if feedback.save
      #   flash[:notice] = "Thanks - your feedback has been saved."
      #   redirect '/'
      # end
      # "Feedback saved successfully! Rating: #{@feedback['qualification']}, Description: #{@feedback['description']}"
    # else
      # Halt and re-render the form.
      # @feedback and @errors are passed back to the view to show the user's input and errors.
      # @errors = feedback.errors.full_messages
      # @feedback = { 'qualification' => qual, 'description' => desc }
      # erb :index
    # end
  end

  get '/admin' do
    "Hello world"
  end
end
