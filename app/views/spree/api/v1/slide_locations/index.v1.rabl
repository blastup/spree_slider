object false
child(@slide_locations => :slide_locations) do
  extends 'spree/api/v1/slide_locations/show'
end
# node(:count) { @slide_locations.count }
# node(:current_page) { params[:page].try(:to_i) || 1 }
# node(:pages) { @slide_locations.total_pages }