class RegistrationsController < ApplicationController
  # before_action :authenticate_with_token, only: [:oauth]

  def create
    @user = User.new(email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password],
                     city: params[:city],
                     state: params[:state])
    if @user.save
      render 'create.json.jbuilder', status: :created
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

  def login
    @user = User.find_by!(email: params[:email])
    if @user.authenticate(params[:password])
      render 'create.json.jbuilder', status: :ok
    else
      render json: { message: "Incorrect email or password." },
        status: :unauthorized
    end
  end

  def oauth
    if params[:code]
      @api = SoundcloudApi.new.api
      @api.exchange_token(code: params[:code])

      # NOTE: This is the *state* param passed to us from Soundcloud.
      # It should contain an email. Fuck computers.
      @user = User.find_by!(email: params[:state])
      user_data = @api.get('/me')
      @user.update(username: user_data.permalink,
                   soundcloud_id:    user_data.id,
                   soundcloud_token: @api.access_token,
                   refresh_token:    @api.refresh_token,
                   expires_at:       @api.expires_at,
                   artist_name:      user_data.username,
                   avatar_url:       user_data.avatar_url)
      TrackImportJob.perform_later(@user)
      redirect_to "http://localhost:8000/#/home"
    else
      render json: { message: "No authorization code from soundcloud found!" },
        status: :unprocessable_entity
    end
  end
end
