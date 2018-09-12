require 'date'
require 'action_view'
require 'action_view/helpers'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper
  COLORS = ['red', 'orange', 'yellow', 'green', 'blue', 'black']
  validates :color, inclusion: { in: COLORS , message: 'Color doesn\'t exist!' }, presence: true
  validates :sex, inclusion: { in: %w(M F), message: 'That is an invalid sex!' }, presence: true
  validates :birth_date, :name, :description, presence: true

  has_many :cat_rental_requests,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'CatRentalRequest'

  def age
    distance_of_time_in_words(DateTime.now, self.birth_date)
  end

end
