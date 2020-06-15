class SpotsController < ApplicationController
  require "open-uri"

  def index
    if params[:query].present?
      @spots = Spot.geocoded
      @spots = Spot.search_by_name_location_and_category(params[:query])
    else
      @spots = Spot.geocoded
    end

    @spots = @spots.near(params[:query_location], 5) if (params[:query_location].present? && !@spots.empty?)
    # spots.near(location search)
    @markers = @spots.map do |spot| {
      icon: spot.category.icon,
      lat: spot.latitude,
      lng: spot.longitude,
      infoWindow: { content: render_to_string(partial: "info_window", locals: { spot: spot }) }
      # image_url: helpers.asset_url('icon.png')
    }
    end
  end

  def show
    @spot = Spot.find(params[:id])
    @stories = @spot.stories
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    @user = current_user
    # @spot.photo = spot_params[:photos]
    spot_photo = Photo.new
    file = URI.open(params[:no_model_fields][:photo_url])
    spot_photo.file.attach(io: file, filename: "#{@spot.name}", content_type: 'image/jpg')
    @spot.photos = [spot_photo]
    if @spot.save
      redirect_to spot_path(@spot)
    else
      render 'new'
    end
  end
    # @spot = Spot.new(spot_params)
    # @user = current_user
    # file = URI.open(spot_params[:photos])
    # @spot.photo.attach(io: file, filename: "#{spot.name}", content_type: 'image/png')
    #   if @spot.save
    #     redirect_to spot_path(@spot)
    #   else
    #     render 'new'
    #   end


  def destroy
    @spot.destroy
    redirect_to spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:location, :name, :category_id)
  end

end
