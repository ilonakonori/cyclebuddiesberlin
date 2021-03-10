import consumer from "./consumer";

const insertIntoDOM = (messageHTML, currentUserId, messages) => {
  const message = document.createElement('div');
  message.innerHTML = messageHTML;

  if (message.dataset.senderId === currentUserId) {
    message.firstChild.classList.add('message-sent');
    message.firstChild.querySelector(':nth-child(1)').classList.add('msg-sent');

  } else {
    message.firstChild.classList.add('message-received');
    message.firstChild.querySelector(':nth-child(1)').classList.add('msg-received');
  }

  messages.insertAdjacentElement('beforeend', message);
}

const initConversationCable = () => {
  const messagesContainer = document.getElementById('messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.conversationId;
    const currentUserId = messagesContainer.dataset.currentUserId;

    consumer.subscriptions.create({ channel: "ConversationChannel", id: id }, {
      received(messageHTML) {
        console.log(messageHTML);
        insertIntoDOM(messageHTML, currentUserId, messagesContainer);
      },
    });
  }
}

export { initConversationCable };
