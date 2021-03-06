class PhotosController < ApplicationController
  before_action :check_login
  def index
    user = User.find_by(account_id: params[:user_id])
    @photos = user.photos.with_attached_photo.order(created_at: :desc) if user
  end

  def new
    @photo = Photo.new(user_id: params[:user_id])
  end

  def create
    @photo = User.find_by(account_id: params[:user_id]).photos.create(photo_params)
    if @photo.valid?
      redirect_to user_photos_path(user_id: params[:user_id])
    else
      render :new
    end
  end

  private

  def check_login
    redirect_to root_path if session[:user].blank?
  end

  def photo_params
    params.require(:photo).permit(:title, :photo)
  end
end
