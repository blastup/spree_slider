module Spree
  module Api
    module V1
      class SlideLocationsController < Spree::Api::BaseController

        def index
          if params[:id] && !params[:id].blank?
            @slide_locations = Spree::SlideLocation.where(id: params[:id])
          else
            # Blastup - Partial Refactor
            # Respond only with the slide_locations that are selected.
            keys_to_select = ["product_list_top_slide_location_id", "product_page_top_slide_location_id", "login_slider_location_id"]
            selected_slide_locations = Spree::ExtraSetting.where(key: keys_to_select).pluck(:value).uniq
            @slide_locations = Spree::SlideLocation.where(id: selected_slide_locations).order(:name)
          end
          respond_with(@slide_locations)
        end
      end
    end
  end
end