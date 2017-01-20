// Form

var protocol = location.protocol == 'https:' ? 'wss://' : 'ws://';
var chat = new Chat(protocol + window.location.host + '/chat');

$(function() {
  $('form').submit(function(event) {
    event.preventDefault();
    var input = $(this).find('input:text');
    var message = input.val();
    if (message.length == 0 || message.length >= 256) {
      return;
    }

    input.val('');
    chat.enableInput(false);
    chat.send(message);
  });

  $('body').on('click', '.chat-replies button:not(.disabled)', function(event) {
    $(this).closest('.chat-replies').find('button').each(function() {
      $(this).addClass('disabled');
    });

    $(this).addClass('selected');
    chat.send($(this).text());
  });
});

// Web sockets

function Chat(url) {
  this.interval = null;
  this.ws = new WebSocket(url);

  this.ws.onopen = function() {
    console.log('Socket is open');
  };

  this.ws.onmessage = function(event) {
    var data = JSON.parse(event.data);
    chat.append(data.message, true);

    if (data.quickReplies) {
      chat.appendQuickReplies(data.quickReplies);
    }
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
      dotsDiv.text(dotsDiv.text() + '.')
      if (dotsDiv.text().length == 4) {
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
    var time = moment().format('h:mm');
    var text = '[' + time + '] ' + message;
    var div = $('<div>').addClass('chat-message');

    if (isAnswer) {
      div.addClass('answer');
    }

    div.text(text);

    $('.chat-panel').append(div);

    this.stopAnimation();

    if (!isAnswer) {
      this.startAnimation();
    } else {
      this.enableInput(this);
    }

    this.scrollToBottom();
  }

  this.appendQuickReplies = function(quickReplies) {
    var div = $('<div>').addClass('chat-replies');
    var ul = $('<ul>');

    for (i = 0; i < quickReplies.length; i++) {
      var button = $('<button/>', {
        text: quickReplies[i]
      });

      ul.append($('<li>').append(button));
    }

    div.append(ul);
    $('.chat-panel').append(div);

    chat.enableInput(false);
    this.scrollToBottom();
  }

  this.enableInput = function(enabled) {
    var input = $('form').find('input:text');
    input.prop('disabled', !enabled);

    if (enabled) {
      input.focus();
    }
  }

  this.scrollToBottom = function(enabled) {
    var firstDiv = $('.chat-panel')[0];
    firstDiv.scrollTop = firstDiv.scrollHeight;
  }
};
