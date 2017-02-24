class Spree::Slide < ActiveRecord::Base
  has_many :asset_assignments, :as => :viewable
  has_many :images, :source => :asset, :foreign_key => "asset_id", :through => :asset_assignments, :class_name => "Spree::Image"

  has_and_belongs_to_many :slide_locations,
                          class_name: 'Spree::SlideLocation',
                          join_table: 'spree_slide_slide_locations'

  scope :published, -> { where(published: true).order('position ASC') }
  scope :location, -> (location) { joins(:slide_locations).where('spree_slide_locations.name = ?', location) }

  belongs_to :product, touch: true

  def initialize(attrs = nil)
    attrs ||= { published: true }
    super
  end

  def slide_name
    name.blank? && product.present? ? product.name : name
  end

  def slide_link
    link_url.blank? && product.present? ? product : link_url
  end

  def slide_image
    slide_image = self.images.first
    image = nil
    if product.present? && product.images.any?
      image = product.images
    elsif slide_image
      image = slide_image
    end
  end

  def slide_image_url
    slide_image ? slide_image.large_url : nil
  end
end
