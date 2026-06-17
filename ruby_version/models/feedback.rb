# frozen_string_literal: true

class Feedback < ActiveRecord::Base
  validates :qualification,
            presence: true,
            numericality: { only_integer: true },
            inclusion: { in: 1..5 }
  validates :description,
            length: { maximum: 250, too_long: '250 characters is the maximum allowed' }

  enum status: { new: 0, reviewed: 1, archived: 2 }
  before_validation :normalize_fields

  private

  def normalize_fields
    self.description = description.to_s.strip
    self.qualification = qualification.to_i if qualification.present?
  end
end

