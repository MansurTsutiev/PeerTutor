//change incoming_requests from green to regular when clicked
$('nav').on('click', 'ul li#incoming_requests_li', function() {
  if(document.querySelector('nav #incoming_requests_notify').classList.contains('notify')) {
    var ir = document.querySelector('nav #incoming_requests_notify');
    $(ir).removeClass('notify');
  }
});


//change currently_tutoring to green when tutor clicked accept
$('#incoming_requests').on('click','#accept', function(){
  var a = document.querySelector('#currently_tutoring_notify');
  if (a) {
    $(a).addClass('notify');
  }
});

//change currently_tutoring from green to regular when clicked:
$('nav').on('click', 'ul li#currently_tutoring_li', function() {
  if(document.querySelector('nav #currently_tutoring_notify').classList.contains('notify')) {
  var ct = document.querySelector('#currently_tutoring_notify');
  $(ct).removeClass('notify');
  }
});
