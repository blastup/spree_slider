module Spree
  module Admin
    class SlidesController < ResourceController
      after_action :generate_content, :only => [:create]
      respond_to :html

      def index
        @slides = Spree::Slide.order(:position)
      end

      def new
      end

      def edit
      end

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:create, :after)

          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            format.html { redirect_to edit_admin_slide_path(@object) }
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
      end

      protected

      def generate_content
        # Blastup - When a new product is created generate associated mobile and desktop content records for each locale.
        SpreeI18n::Config.available_locales.map do |locale| 
          is_mobile = Spree::Content.create({locale: locale, is_mobile: true})
          is_desktop = Spree::Content.create({locale: locale, is_mobile: false})
          Spree::SlideContent.create({content_id: is_mobile.id, slide_id: @object.id})
          Spree::SlideContent.create({content_id: is_desktop.id, slide_id: @object.id})
        end
      end

      private

      def location_after_save
        if @slide.created_at == @slide.updated_at
          edit_admin_slide_url(@slide)
        else
          admin_slides_url
        end
      end

      def slide_params
        params.require(:slide).permit(:name, :body, :link_url, :published, :image, :position, :product_id)
      end
    end
  end
end
