App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    console.log(data['message']); //after sending a message we received it here
  },
  //Speak runs the speak method on the back-end inside conversation_cahnnel.rb
  speak: function(message) {
    return this.perform('speak', {
      message: message
    });
  }
});


$(document).on('submit', '.new_message', function(e) {
  e.preventDefault();
  var values = $(this).serializeArray();
  App.conversation.speak(values);
  $(this).trigger('reset');
});
