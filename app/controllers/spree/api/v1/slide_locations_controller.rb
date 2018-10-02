module Spree
  module Api
    module V1
      class SlideLocationsController < Spree::Api::BaseController

        def index
          @slide_locations = Spree::SlideLocation.order(:name)
          respond_with(@slide_locations)
        end
      end
    end
  end
end