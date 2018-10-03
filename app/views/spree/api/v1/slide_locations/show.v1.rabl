attributes *Spree::SlideLocation.column_names - ["created_at", "updated_at"]

if root_object.products.any?
  child :products => :slides do
    extends 'spree/api/v1/products/slide'
  end
elsif root_object.prototypes.any?
  child :prototypes => :slides do
    extends 'spree/api/v1/prototypes/show'
  end
else
  child :slides => :slides do
    extends 'spree/api/v1/slides/show'
  end
end