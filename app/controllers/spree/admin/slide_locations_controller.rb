module Spree
  module Admin
    class SlideLocationsController < ResourceController
      after_action :save_associated_models, :only => [:create, :update]
      respond_to :html

      def index
        @slide_locations = Spree::SlideLocation.order(:name)
      end

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:create, :after)

          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            format.html { redirect_to edit_admin_slide_location_path(@object) }
            format.js   { render :layout => false }
          end
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update
        invoke_callbacks(:update, :before)
        if @object.update_attributes(permitted_resource_params)
          invoke_callbacks(:update, :after)

          respond_with(@object) do |format|
            format.html do
              flash[:success] = flash_message_for(@object, :successfully_updated)
              redirect_to edit_admin_slide_location_path(@object)
            end
            format.js { render layout: false }
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :edit }
            format.js { render layout: false }
          end
        end
      end

      private

      def save_associated_models
        if params.has_key? :slide_location_products
          save_associated_products
        end

        if params.has_key? :slide_location_prototypes
          save_associated_prototypes
        end
      end

      def save_associated_products
        request_slide_location_products = params[:slide_location_products].split(',')
        saved_slide_location_products = @object.products.pluck(:product_id)
        to_destroy_slide_location_products = saved_slide_location_products - request_slide_location_products
        to_create_slide_location_products = request_slide_location_products - saved_slide_location_products

        to_destroy_slide_location_products.each do |product_id| 
          Spree::SlideLocationProduct.where(:product_id => product_id.to_i, :slide_location_id => @object.id).destroy_all
        end

        to_create_slide_location_products.each do |product_id| 
          Spree::SlideLocationProduct.create([{ :product_id => product_id.to_i, :slide_location_id => @object.id }]) 
        end
      end

      def save_associated_prototypes
        request_slide_location_prototypes = params[:slide_location_prototypes].flatten.uniq
        saved_slide_location_prototypes = @object.prototypes.pluck(:prototype_id)
        to_destroy_slide_location_prototypes = saved_slide_location_prototypes - request_slide_location_prototypes
        to_create_slide_location_prototypes = request_slide_location_prototypes - saved_slide_location_prototypes

        to_destroy_slide_location_prototypes.each do |prototype_id| 
          Spree::SlideLocationPrototype.where(:prototype_id => prototype_id.to_i, :slide_location_id => @object.id).destroy_all
        end

        to_create_slide_location_prototypes.each do |prototype_id| 
          Spree::SlideLocationPrototype.create([{ :prototype_id => prototype_id.to_i, :slide_location_id => @object.id }]) 
        end
      end
    end
  end
end
