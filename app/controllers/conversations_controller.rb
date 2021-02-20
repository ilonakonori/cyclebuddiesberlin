class ConversationsController < ApplicationController
  def index
    @conversations = policy_scope(Conversation).where(recipient_id: current_user) + policy_scope(Conversation).where(sender_id: current_user)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
    authorize @conversation
  end

  def create
    @request = Request.find(params[:request_id])
    @conversation = Conversation.new(conversation_params)
    @request.update(accepted: true, friend: true)
    authorize @conversation
    if @conversation.save
      c = Conversation.find(@conversation.id)
      message = Message.create!(conversation_id: c.id, sender_id: c.sender_id, recipient_id: c.recipient_id, content: @request.first_message)

      #ConversationChannel.broadcast_to(@conversation, render_to_string(partial: "message", locals: { message: @message }))
      #redirect_to conversation_path(@conversation) #, anchor: "message-#{@message.id}")

      redirect_to conversation_path(@conversation), notice: "Request accepted, start conversation :)"
    else
      render 'requests/show'
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:request_id, :sender_id, :recipient_id)
  end
end
