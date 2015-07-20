class RegistrationsController < ApplicationController
  before_action :authenticate_with_token, only: [:oauth]

  def create
    @user = User.new(email: params[:email],
                     username: params[:username],
                     password: params[:password],
                     password_confirmation: params[:password])
    if @user.save
      render :create, status: :created
    else
      render json: { errors: @user.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  def oauth_test
    # Purely for experimenting with Soundcloud gem.
    binding.pry
    # Sure enough, just calling exchange token once we have the code is easy as pie.
    # Unfortunately, the Soundcloud gem is a bit odd and this destructively
    # modifies the client instance we have. So I need a fuckin factory now. :-/
  end

  def oauth
    if params[:code]
      @api = SoundcloudApi.new.api
      @api.exchange_token(code: params[:code])
      current_user.update!(soundcloud_token: @api.access_token,
                           refresh_token:    @api.refresh_token)
    end

    render json: { message: "Soundcloud account access granted for '#{@user.username}'!" },
      status: :created
  end

  def reset
    @user = User.find_by!(username: params[:username])
    if @user.authenticate(params[:password])
      @user.regenerate_token!
      render :create, status: :accepted
    else
      render json: { message: "You don't have permission to reset token for: '#{params[:username]}'." },
        status: :unauthorized
    end
  end

  def destroy
    @user = User.find_by!(username: params[:username])
    if @user.authenticate(params[:password])
      @user.destroy!
      render json: { message: "User '#{params[:username]}' was destroyed." },
        status: :no_content
    else
      render json: { message: "Incorrect username or password." },
        status: :unauthorized
    end
  end
end