class ChatsController < ApplicationController
  respond_to :json

  def index
    @chats = current_user.chats
  end

  def show
    @chat = Chat.find(params[:id])
  end

  def create
    @chat = Chat.new(name: chat_params[:name])
    @chat.users << User.find(chat_params[:user_ids].split(',').map(&:to_i))
    @chat.users << current_user
    if @chat.save
      render :show
    else
      render json: {}, status: 500
    end
  end

  def update
    chat = Chat.find(params[:id])
    chat.user_ids = chat_params[:user_ids].split(',').map(&:to_i).to_a
    chat.name = chat_params[:name]
    render json: {}, status: chat.save ? 200 : 500
  end

  def readall
    ci = ChatItem.find_by(chat_id: params[:id], user: current_user)
    ci.unread_messages_count = 0
    render json: {}, status: ci.save ? 200 : 500
  end

  private

  def chat_params
    params.require(:chat).permit(:name, :user_ids)
  end
end
