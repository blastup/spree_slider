class AddIsMobileToSpreeSlide < ActiveRecord::Migration
  def change
    add_column :spree_slides, :is_mobile, :boolean, :default => false
  end
end
