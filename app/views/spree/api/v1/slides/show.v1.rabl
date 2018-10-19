attributes *Spree::Slide.column_names - ["product_id", "created_at", "updated_at"]

node :contents do
  root_object.contents.filter_by_locale(I18n.locale.to_s).map { |c| partial('spree/api/v1/contents/show', :object => c) }
end

if !root_object.product_id.nil?
  child(product: :product) do
    extends 'spree/api/v1/products/slide'
  end
end