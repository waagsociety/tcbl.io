class LabsController < ApplicationController

  before_filter :require_login, except: [:index, :map, :show]

  def map
    @labs = Lab.with_approved_state
  end

  def index
    all_labs = Lab.search_for(params[:q]).with_approved_state
    @countries = Lab.country_list_for all_labs
    @count = all_labs.size
    @labs = all_labs.order('name ASC').in_country_code(params["country"]).page(params['page']).per(2)

    respond_to do |format|
      format.html
      format.json { render json: @labs }
    end
  end

  def new
    @lab = current_user.created_labs.build
    @lab.links.build
    authorize_action_for @lab
  end

  def create
    @lab = current_user.created_labs.build lab_params
    authorize_action_for @lab
    if @lab.save
      redirect_to labs_path, notice: "Thanks for adding your lab. We shall review your application and be in touch."
    else
      render :new
    end
  end

  def show
    begin
      @lab = Lab.with_approved_state.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return redirect_to root_path, notice: "Lab not found"
    end
    # @people = [@lab.creator]
    @nearby_labs = @lab.nearby_labs false
    authorize_action_for @lab
  end

  def destroy
    @lab = Lab.friendly.find(params[:id])
    authorize_action_for @lab
    @lab.delete
    redirect_to labs_path, notice: "Lab deleted"
  end

  def edit
    @lab = Lab.friendly.find(params[:id])
    @lab.links.build
    authorize_action_for @lab
  end

  def update
    @lab = Lab.friendly.find(params[:id])
    authorize_action_for @lab
    if @lab.update_attributes lab_params
      redirect_to lab_url(@lab), notice: "Lab was successfully updated"
    else
      render :edit
    end
  end

  def manage_admins
    @lab = Lab.friendly.find(params[:id])
    @admins = @lab.admins
    @users = User.all# - User.with_role(:admin) - [current_user]
  end

private

  def lab_params
    params.require(:lab).permit(
      :name,
      :description,
      :slug,
      :avatar_src,
      :header_image_src,
      :address_1,
      :address_2,
      :city,
      :county,
      :postal_code,
      :country_code,
      :latitude,
      :longitude,
      :zoom,
      :address_notes,
      :phone,
      :email,
      :application_notes,
      links_attributes: [ :id, :link_id, :url, '_destroy' ]

    )
  end

end
