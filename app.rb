# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require_relative 'config/application'
require 'securerandom'

class App < Sinatra::Base
  use Rack::Session::Cookie,
      key: 'app.session',
      path: '/',
      secret: ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) },
      same_site: :lax,
      secure: (ENV['RACK_ENV'] == 'production'),
      httponly: true,
      expire_after: 2_592_000

  use Rack::Protection::AuthenticityToken
  use Rack::Protection::RemoteToken
  use Rack::Protection::SessionHijacking

  configure do
    helpers do
      def csrf_token
        session[:csrf] ||= SecureRandom.base64(32)
      end

      def csrf_tag
        %(<input type="hidden" name="authenticity_token" value="#{h(csrf_token)}">)
      end
    end
    helpers ViewHelpers
    register Sinatra::Flash
    set :erb, layout: :layout
  end

  get '/' do
    erb :index
  end

  post '/' do
    @feedback = params[:feedback] || {}
    qual = (@feedback['qualification'].to_s.strip == '' ? nil : @feedback['qualification'].to_i)
    desc = (@feedback['description'] || '').strip
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
  end

  get '/admin' do
    'Hello world'
  end
end
