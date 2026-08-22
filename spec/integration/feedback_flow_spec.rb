# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Feedback submission' do
  describe 'GET /' do
    it 'displays the feedback form' do
      get '/'
      expect(last_response.status).to eq 200
      expect(last_response.body).to include('qualification')
      expect(last_response.body).to include('description')
      expect(last_response.body).to include('authenticity_token')
    end
  end

  describe 'POST /' do
    it 'saves valid feedback and redirects' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '4', description: 'Great!' }, authenticity_token: csrf_token }

      expect(last_response.status).to eq 302
      expect(Feedback.count).to eq 1
      expect(Feedback.first.description).to eq 'Great!'
    end

    it 'shows flash message after save' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '3', description: 'Good' }, authenticity_token: csrf_token }

      follow_redirect!
      expect(last_response.body).to include('Thanks - your feedback was saved')
    end

    it 'shows errors for missing qualification' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '', description: 'No rating' }, authenticity_token: csrf_token }

      expect(last_response.status).to eq 200
      expect(last_response.body).to include('can&#39;t be blank')
      expect(Feedback.count).to eq 0
    end

    it 'shows errors for blank description' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '3', description: '   ' }, authenticity_token: csrf_token }

      expect(last_response.status).to eq 200
      expect(last_response.body).to include('can&#39;t be blank')
      expect(Feedback.count).to eq 0
    end

    it 'preserves user input when showing errors' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '5', description: '' }, authenticity_token: csrf_token }

      expect(last_response.body).to include('value="5"')
    end

    it 'rejects POST without CSRF token' do
      post '/', { feedback: { qualification: '3', description: 'Test' }, authenticity_token: '' }

      expect(last_response.status).to eq 403
    end

    it 'escapes HTML in feedback output' do
      get '/'
      csrf_token = last_request.session[:csrf]

      post '/', { feedback: { qualification: '3', description: '<script> alert("xss")</script>' }, authenticity_token: csrf_token }

      follow_redirect!
      expect(Feedback.last.description).to eq('<script> alert("xss")</script>')
      expect(last_response.body).not_to include('<script> alert("xss")</script>')
    end

    # it 'rejects invalid feedback' do
    # end

    # it 'validates CSRF token' do
    # end
  end
end
