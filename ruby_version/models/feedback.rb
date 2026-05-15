# frozen_string_literal: true

class Feedback < ActiveRecord::Base
  validates :qualification, presence: true
  validates :description, length: { maximum: 250,
                                    too_long: '250 characters is the maximum allowed' }
end

