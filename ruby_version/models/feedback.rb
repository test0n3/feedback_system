# frozen_string_literal: true

class Feedback < ActiveRecord::Base
  STATUSES = { new: 0, reviewed: 1, archived: 2 }.freeze
  scope :new_items, -> { where(status: STATUSES[:new]) }
  scope :reviewed, -> { where(status: STATUSES[:reviewed]) }
  scope :archived, -> { where(status: STATUSES[:archived]) }

  def status_name
    STATUSES.key(status).to_s
  end

  def status_sym
    STATUSES.key(status)&.to_sym
  end

  def status=(val)
    super(STATUSES[val.to_sym] || val.to_i)
  end

  before_validation :normalize_fields

  validates :qualification,
            presence: true,
            numericality: { only_integer: true },
            inclusion: { in: 1..5 }
  validates :description,
            presence: true,
            length: { maximum: 250, too_long: '250 characters is the maximum allowed' }

  private

  def normalize_fields
    self.description = description.to_s.strip
    self.qualification = qualification.to_i if qualification.present?
    self.status = 0 if status.nil?
  end
end

