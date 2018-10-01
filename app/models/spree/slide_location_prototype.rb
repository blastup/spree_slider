class Spree::SlideLocationPrototype < ApplicationRecord
  belongs_to :slide_location, class_name: 'Spree::SlideLocation'
  belongs_to :prototype, class_name: 'Spree::Prototype'
end