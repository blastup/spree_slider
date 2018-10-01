class Spree::SlideLocationProduct < ApplicationRecord
  belongs_to :slide_location, class_name: 'Spree::SlideLocation'
  belongs_to :product, class_name: 'Spree::Product'
end