App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  //search for a specified conversation, based on passed conversation_id,
  //and appended a HTML code within a message to a conversation window
  received: function(data) {
    if (data['command'] == 'tutor_picked')
    {
      if (document.querySelector('#incoming_requests'))
      {
        var da = document.querySelector("#incoming_requests .alert");
        da.classList.add('alert-warning');
        var h = document.querySelector("#incoming_requests h4");
        h.innerHTML = "You have a new request!";
        var tb = document.querySelector('#incoming_requests')
        tb.insertAdjacentHTML('afterend', data['tutoring_session']);
      }
      else
      {
        var a = document.querySelector('#incoming_requests_notify'); //notification when new request comes in
        a.classList.add('notify');
      }
    }
    else if (data['command'] == 'tutor_accepted') {

      if (document.querySelector('#waiting_for_tutor')) {
        //var outer_frame = document.querySelector('#outer_frame');
        //var frame = document.querySelector('#frame');
        //frame.remove();
        //outer_frame.innerHTML = data['being_tutored'];

        $link = $('#messenger_link:first');
        $link[0].click();
        //add Location:
        var f = document.querySelector("#frame");
        //f.insertAdjacentHTML('beforebegin', data['tutor_response']);
      } else if (document.querySelector('#inside_messenger')) {
        alert("Session is accepted!");
        $link = $('#messenger_link:first');
        $link[0].click();
      } else {
        alert("Session is accepted!");
        var a = document.querySelector('#messenger_notify');
        a.classList.add('notify');
      }

    }
    else if (data['command'] == 'session_canceled') {
      alert("Session is canceled.");
      // var value = data['tutee_id'];
      // var a = $('*[data-tutee_id=' + value + "]")[0];
      // a.parentNode.removeChild(a);
      location.reload();


      //var row = document.querySelector("[data-tutee_id='" + data['tutee_id'] + "']");    //find and delete the row
      //var table = document.querySelector('#table');
      //if (table != null && table.contains(row)) { row.parentNode.removeChild(row); }

      // ??Refresh incoming_requests??

    }
    else if (data['command'] == 'session_completed') {
      alert("Session is completed.");
      $('#frame').replaceWith(data['tips_box']);
    }
    else if (data['command'] == 'session_declined')
    {
      alert("Tutor declined request!");
      //display list_of_tutors
      $('#frame').replaceWith(data['partial']);
    } else if (data['command'] == 'new_message')
    {
      //alert("New Message");
      var conversation = document.querySelector("#messages_list");
          //alert(data['message']);
      // check if under the data[‘window’] we pass a partial.
          conversation.innerHTML += (data['message']);
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
