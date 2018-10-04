attributes *Spree::SlideLocation.column_names - ["created_at", "updated_at"]

if root_object.products.any?
  node :slides do
    root_object.products.available_now.map { |p| partial('spree/api/v1/products/slide', :object => p) }
  end
elsif root_object.prototypes.any?

  node :slides do 
    products = [];
    number_of_prototypes = root_object.prototypes.count
    number_of_slides = root_object.prototype_slides.nil? ? 1 : root_object.prototype_slides
    # Blastup - This is to get rounded up the value. The code below will return for
    # the case of 11 prototype_slides and 3 prototypes, 4 slides per prototype. 
    # The first 11 out the 12 in the constructed array will be sent to client.
    number_of_slides_per_prototype = (number_of_slides).fdiv(number_of_prototypes).round

    root_object.prototypes.each do |prototype|
      products << prototype.products.available_now.sample(number_of_slides_per_prototype)
    end

    # root_object.prototypes.includes(:products).map(&:products).flatten

    products.flatten.first(number_of_slides).map { |p| partial('spree/api/v1/products/slide', :object => p) }

  end
else
  child :slides => :slides do
    extends 'spree/api/v1/slides/show'
  end
end