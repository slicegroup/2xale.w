require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    # Begin callbacks area (don't delete)
    # End callbacks area (don't delete)
    include FrontsHelper
    layout 'layouts/keppler_frontend/app/layouts/application'

    # begin keppler
    def index
      @banners = KepplerBanners::Banner.all
      @products = KepplerProducts::Product.latest
      @categories_featureds = KepplerProducts::Category.featureds
    end
    # end keppler

    def product
      @product = KepplerProducts::Product.find(params[:id])
      @products = KepplerProducts::Product.where(category_id: @product.category_id)
    end

    def category
      @category = KepplerProducts::Category.find(params[:id])
      # @products = KepplerProducts::Product.all
    end

    private
    # begin callback user_authenticate
    def user_authenticate
      redirect_to '/' unless user_signed_in?
    end
    # end callback user_authenticate
  end
end
