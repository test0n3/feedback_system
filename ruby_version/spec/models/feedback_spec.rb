# frozen_string_literal: true

require_relative '../spec_helper'

describe Feedback do
  describe 'validations' do
    it 'validates presence of qualification' do
      feedback = Feedback.new(qualification: nil, description: 'Great service')
      expect(feedback.save).to be false
      expect(Feedback.count).to eq 0
    end

    it 'validates presence of description' do
      feedback = Feedback.new(qualification: '3')
      expect(feedback.save).to be false
      expect(Feedback.count).to eq 0
    end

    it 'validates max length of description' do
      feedback = Feedback.new(qualification: '3',
                              description: 'x' * 251)
      expect(feedback.save).to be false
      expect(Feedback.count).to eq 0
    end

    it 'validates state of feedback' do
      feedback = Feedback.new(qualification: 3, description: 'nice food, great ambient')
      expect(feedback.save).to be true
      expect(feedback.status).to be 0
    end
  end

  describe 'scopes' do
    it 'returns new_items (status 0)' do
      Feedback.create(qualification: 3, description: 'New')
      Feedback.create(qualification: 4, description: 'New 2')

      new_feedback = Feedback.new_items
      expect(new_feedback.count).to eq 2
    end

    it 'returns reviewed feedback (status 1)' do
      Feedback.create(qualification: 3, description: 'New', status: 0)
      Feedback.create(qualification: 4, description: 'Reviewed', status: 1)

      reviewed = Feedback.reviewed
      expect(reviewed.count).to eq 1
      expect(reviewed.first.description).to eq 'Reviewed'
    end
  end
end