attributes *Spree::Slide.column_names - ["created_at", "updated_at"]

child(images: :images) do
  extends 'spree/api/v1/images/show'
end