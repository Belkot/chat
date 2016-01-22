class User < ActiveRecord::Base
  has_many :messages
  has_many :chat_items
  has_many :chats, through: :chat_items

  validates :name, presence: true, uniqueness: true, length: { in: 3..20 }

  def messages_count
    messages.count
  end
end
