class UsersController < ApplicationController
  before_action :authenticate_with_token!

  def show
    @user = User.find(params[:id])
    render 'show.json.jbuilder', status: :ok
  end

  def reset
    @user = User.find(params[:id])
    if @user.authenticate(params[:password])
      @user.regenerate_token!
      render 'show.json.jbuilder', status: :accepted
    else
      render json: { message: "You don't have permission to reset token for: '#{params[:email]}'." },
        status: :unauthorized
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.authenticate(params[:password])
      @user.destroy!
      render json: { message: "User '#{params[:email]}' was destroyed." },
        status: :no_content
    else
      render json: { message: "Incorrect username or password." },
        status: :unauthorized
    end
  end

  def updater
    if @user.authenticate(params[:access_token])
      @api = SoundcloudApi.new.api
      @api.exchange_token(code: params[:code])

      # State = Email Soundcloud is weird
      @user = User.find_by!(email: params[:state])
      #user_data = @api.get('/me')
      @user.update(soundcloud_token: @api.access_token,
                   refresh_token:    @api.refresh_token,
                   expires_at:       @api.expires_at)
                   TrackUpdaterJob.preform_later(@user)
    else         
      render json: { message: "Are you sure you are logged in to Soundcloud?" },
        status: :unprocessable_entity
    end

  end






  end






end
