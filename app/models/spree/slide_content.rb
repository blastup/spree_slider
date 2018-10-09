class Spree::SlideContent < ActiveRecord::Base
  belongs_to :content, class_name: 'Spree::Content'
  belongs_to :slide, class_name: 'Spree::Slide'
end