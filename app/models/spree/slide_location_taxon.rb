class Spree::SlideLocationTaxon < ApplicationRecord
  belongs_to :slide_location, class_name: 'Spree::SlideLocation'
  belongs_to :taxon, class_name: 'Spree::Taxon'
end