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
            format.html { render :edit }
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
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:update, :after)

          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            format.html { render :edit }
            format.js   { render :layout => false }
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      protected

      def generate_content
        slide_default_content = Spree::Content.create({locale: I18n.default_locale.to_s, is_mobile: false, source_type: @object.class.name, source_id: @object.id})
        Spree::SlideContent.create({content_id: slide_default_content.id, slide_id: @object.id})
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
