class Spree::Slide < ActiveRecord::Base
  has_many :slide_contents, class_name: 'Spree::SlideContent'
  has_many :contents, through: :slide_contents, class_name: 'Spree::Content'

  has_and_belongs_to_many :slide_locations,
                          class_name: 'Spree::SlideLocation',
                          join_table: 'spree_slide_slide_locations'

  scope :published, -> { where(published: true).order('position ASC') }
  scope :location, -> (location) { joins(:slide_locations).where('spree_slide_locations.name = ?', location) }

  before_destroy :destroy_associations

  belongs_to :product, required: false, touch: true

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

  private

  def destroy_associations
    self.contents.each { |content| content.destroy }
    self.asset_assignments.each { |asset_assignment| asset_assignment.destroy }

    Spree::SlideSlideLocation.where(slide_id: self.id).destroy_all
  end
end
