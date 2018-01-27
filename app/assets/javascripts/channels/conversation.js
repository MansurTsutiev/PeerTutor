App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  //search for a specified conversation, based on passed conversation_id,
  //and appended a HTML code within a message to a conversation window
  received: function(data) {
    if (data['command'] == 'tutor_picked') {
      if (document.querySelector('#incoming_requests')) {
        var da = document.querySelector("#incoming_requests .alert");
        da.classList.add('alert-warning');
        var h = document.querySelector("#incoming_requests h4");
        h.innerHTML = "You have a new request!";
        var tb = document.querySelector('#incoming_requests')
        tb.insertAdjacentHTML('afterend', data['tutoring_session']);
      } else {
        var a = document.querySelector('#incoming_requests_notify'); //notification when new request comes in
        a.classList.add('notify');
      }
    } else if (data['command'] == 'tutor_accepted') {

      if (document.querySelector('#waiting_for_tutor')) {
        $link = $('#messenger_link:first');
        $link[0].click();
        //add Location:
        var f = document.querySelector("#frame");
      } else if (document.querySelector('#inside_messenger')) {
        alert("Session is accepted!");
        $link = $('#messenger_link:first');
        $link[0].click();
      } else {
        alert("Session is accepted!");
        var a = document.querySelector('#messenger_notify');
        a.classList.add('notify');
      }

    } else if (data['command'] == 'session_canceled') {
      alert("Session is canceled.");
      location.reload();
    } else if (data['command'] == 'session_completed') {
      alert("Session is completed.");
      $('#frame').replaceWith(data['tips_box']);
    } else if (data['command'] == 'session_declined') {
      alert("Tutor declined request!");
      //display list_of_tutors
      $('#frame').replaceWith(data['partial']);
    } else if (data['command'] == 'new_message') {
      if (document.querySelector('#chat-messages')) {
        var conversation = document.querySelector('#chat-messages');
        conversation.innerHTML += (data['message']);
        var chat_messages = document.querySelector('#chat-messages');
        chat_messages.scrollTop = chat_messages.scrollHeight;
      }
    }

  },
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

//Speak runs the speak method on the back-end
//sending the message object
