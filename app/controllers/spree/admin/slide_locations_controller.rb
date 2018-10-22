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
          save_associated_product_slides
        else
          Spree::SlideLocationProduct.where(:slide_location_id => @object.id).destroy_all
        end

        if params.has_key? :slide_location_taxons
          save_associated_taxon_product_slides
        else
          Spree::SlideLocationTaxon.where(:slide_location_id => @object.id).destroy_all
        end

        if params.has_key? :taxon_locations
          save_slide_location_to_taxons
        else
          Spree::Taxon.where(slide_location_id: @object.id).update(slide_location_id: nil)
        end
      end

      def save_associated_product_slides
        request_product_slides = params[:slide_location_products].split(',')
        saved_slide_location_products = @object.products.pluck(:product_id)
        to_destroy_slide_location_products = saved_slide_location_products - request_product_slides
        to_create_slide_location_products = request_product_slides - saved_slide_location_products

        to_destroy_slide_location_products.each do |product_id|
          Spree::SlideLocationProduct.where(:product_id => product_id, :slide_location_id => @object.id).destroy_all
        end

        to_create_slide_location_products.each do |product_id|
          Spree::SlideLocationProduct.create([{:product_id => product_id, :slide_location_id => @object.id }]) 
        end
      end

      def save_associated_taxon_product_slides  
        request_slide_location_taxons = params[:slide_location_taxons].flatten.uniq
        saved_slide_location_taxons = @object.taxons.pluck(:taxon_id)
        to_destroy_slide_location_taxons = saved_slide_location_taxons - request_slide_location_taxons
        to_create_slide_location_taxons = request_slide_location_taxons - saved_slide_location_taxons

        to_destroy_slide_location_taxons.each do |taxon_id| 
          Spree::SlideLocationTaxon.where(:taxon_id => taxon_id, :slide_location_id => @object.id).destroy_all
        end

        to_create_slide_location_taxons.each do |taxon_id| 
          Spree::SlideLocationTaxon.create([{:taxon_id => taxon_id, :slide_location_id => @object.id }]) 
        end
      end

      def save_slide_location_to_taxons  
        request_slide_location_to_taxons = params[:taxon_locations].flatten.uniq
        saved_taxon_slide_locations = Spree::Taxon.where(slide_location_id: @object.id).pluck(:id)
        unassign_slide_location_from_taxons = saved_taxon_slide_locations - request_slide_location_to_taxons
        assign_slide_location_to_taxons = request_slide_location_to_taxons - saved_taxon_slide_locations

        Spree::Taxon.where(id: unassign_slide_location_from_taxons).update(slide_location_id: nil)

        assign_slide_location_to_taxons.each do |taxon_id| 
          Spree::Taxon.find(taxon_id).update(slide_location_id: @object.id)
        end
      end
    end
  end
end
