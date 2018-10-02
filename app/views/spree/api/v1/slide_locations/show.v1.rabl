attributes *Spree::SlideLocation.column_names - ["created_at", "updated_at"]

child(products: :products) do
  extends 'spree/api/v1/products/slide'
end

child(prototypes: :prototypes) do
  extends 'spree/api/v1/prototypes/show'
end

child(slides: :slides) do
  extends 'spree/api/v1/slides/show'
end