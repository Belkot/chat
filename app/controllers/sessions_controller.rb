class SessionsController < ApplicationController
  respond_to :json

  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      render template: 'users/show'
    else
      render json: {}, status: 500
    end
  end

  def destroy
    sign_out
    render json: {}, status: 200
  end
end
