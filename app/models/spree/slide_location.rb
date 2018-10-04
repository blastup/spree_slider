class Spree::SlideLocation < ActiveRecord::Base
  has_many :slide_location_prototypes
  has_many :prototypes, through: :slide_location_prototypes, source: :prototype

  has_many :slide_location_products
  has_many :products, through: :slide_location_products, source: :product

  has_and_belongs_to_many :slides,
                          class_name: 'Spree::Slide',
                          join_table: 'spree_slide_slide_locations'

  validates :name, presence: true
  validates :speed, presence: true, numericality: { only_integer: true }
  validates :auto, inclusion: { in: [ true, false ] }
  validates :dots, inclusion: { in: [ true, false ] }
  validates :infinite, inclusion: { in: [ true, false ] }
  validates :slides_to_scroll, presence: true, numericality: { only_integer: true }
  validates :prototype_slides, numericality: { less_than_or_equal_to: 15, only_integer: true }
  validates :slider_type, presence: true, inclusion: { in: [ 'default', 'custom' ] }

end
