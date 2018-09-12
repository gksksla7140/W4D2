require 'date'

class CatRentalRequest < ApplicationRecord
  STATUS = ['PENDING', 'APPROVED', 'DENIED']
  validates :status, inclusion: { in: STATUS, message: 'Invalid Status!' }, presence: true
  validates :cat_id, :start_date, :end_date, presence: true
  validate :does_not_overlap_approved_requests

  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Cat',
    dependent: :destroy

  def overlapping_requests
    CatRentalRequest.where(cat_id: cat_id).where("? BETWEEN start_date AND end_date AND ? BETWEEN start_date AND end_date", start_date, end_date).distinct
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def does_not_overlap_approved_requests
    errors[:date] << "Dates are overlapping!" if overlapping_approved_requests.exists?
  end
end
