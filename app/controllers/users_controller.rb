class UsersController < ApplicationController
    before_action :authorized, only: [:stay_logged_in]

    def index
        users = User.all

        render json: users
    end

    def show
        user = User.find(params[:id])

        render json: user
    end

    def login
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            wristband = encode_token({user_id: user.id})
            render json: {
                user: UserSerializer.new(user),
                token: wristband
            }
        else
            render json: {error: "Wrong username or password"}
        end
    end

    def stay_logged_in
        wristband = encode_token({user_id: @user.id})
        render json: {
            user: UserSerializer.new(@user),
            token: wristband
        }
    end

    def create
        user = User.create(user_params)
        if user.valid?
            wristband = encode_token({user_id: user.id})
            render json: {
                user: UserSerializer.new(user),
                token: wristband
            }
        else
            render json: {errors: "Username has been taken"}
        end
    end

    def update
        user = User.find(params[:id])
        user.update(user_params)

        render json: user
    end

    private
    def user_params
        params.permit(:username, :password, :manageable_fund)
    end

end
