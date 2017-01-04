// Form

var chat = new Chat(window.location.host + "/chat");

$(function() {
  $("form").submit(function(event) {
    event.preventDefault();
    var input = $(this).find('input');
    var message = input.val();
    if (message.length == 0 || message.length >= 256) {
      return;
    }

    chat.send(message);
    input.val('');
  });
});

// Web sockets

function Chat(host) {
  this.interval = null;
  this.ws = new WebSocket('ws://' + host);
  this.ws.onopen = function() {
    console.log("Socket is open");
  };

  this.ws.onmessage = function(event) {
    var data = JSON.parse(event.data);
    this.append(data.message, true);
  }

  this.send = function(message) {
    this.ws.send(JSON.stringify({
      'message': message
    }));

    this.append(message);
  }

  this.startAnimation = function() {
    var dotsDiv = $('<div>').addClass('chat-message chat-dots');
    $('.chat-panel').append(dotsDiv);

    this.interval = setInterval(function() {
      dotsDiv.text(dotsDiv.text + '.')
      if (dotsDiv.text.length == 4) {
        dotsDiv.text('');
      }
    }, 100);
  }

  this.stopAnimation = function() {
    clearInterval(this.interval);
    $('.chat-panel').find('.chat-dots').remove();
  }

  this.append = function(message, isAnswer) {
    var date = new Date();
    var time = date.format('hh:mm');
    var text = '[' + time + '] ' + message;
    var div = $('<div>').addClass('chat-message');

    if (isAnswer) {
      div.addClass('answer');
    }

    div.text(text);

    $('.chat-panel').append(div);

    this.stopAnimation();

    if (!isAnswer) {
      this.startAnimation()
    }

    var firstDiv = $('.messages')[0];
    objDiv.scrollTop = objDiv.scrollHeight;
  }
};
