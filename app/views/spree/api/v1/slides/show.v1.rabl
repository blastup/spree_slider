attributes *Spree::Slide.column_names - ["product_id", "created_at", "updated_at"]

if !root_object.product_id.nil?
  child(product: :product) do
    extends 'spree/api/v1/products/slide'
  end
end

child(images: :images) do
  extends 'spree/api/v1/images/show'
end