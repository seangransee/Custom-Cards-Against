var initial = {

  "gamename": "Custom Cards Against Humanity",

  "white": [
    "Your best friend.",
    "An inside joke.",
    "Something that happened recently.",
    "The funniest thing you can think of."
  ],

  "black": [
    "What is the meaning of life?",
    "I ran out of _____, so I _____.",
    "Why am I still ____?",
    "Let's get together and _____."
  ]
};

$.fn.serializeObject = function()
{
   var o = {};
   var a = this.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           console.log(this);
           o[this.name] = this.value || $('[name="'+this.name+'"]').attr('placeholder') || '';
       }
   });
   return o;
};

function updatePreview() {
  $.post('/cards.html', $('#cardsform').serializeObject(), function(d){ $('.preview').html(d); });
}

function resizePreview() {
  $('.right').height($(window).height()*1.25);
}

$('textarea').keypress(function(e) {
  if (e.keyCode == 13)
    updatePreview();
});

$('textarea').on('blur change paste', updatePreview);

$('input').on('blur change paste', function() {
  updatePreview();
});

$(document).ready(function() {

  var gamename = initial.gamename;
  var whitecards = initial.white.join('\n');
  var blackcards = initial.black.join('\n');

  $('[name="gamename"]').data('placeholder', gamename);
  $('[name="white_cards"]').data('placeholder', whitecards);
  $('[name="black_cards"]').data('placeholder', blackcards);

  $('.placeholder').each(function() {
    var placeholder = $(this).data('placeholder');
    $(this).val(placeholder);

    $(this).on('focus blur', function() {
      $(this).removeClass('placeholder');
      if ($(this).val() == placeholder) {
        $(this).val('').removeClass('placeholder');
      } else if ($(this).val() == '') {
        $(this).val(placeholder).addClass('placeholder');
      }
    })

  });


  $('textarea').keypress(function(e) {
    if (e.keyCode == 13)
      updatePreview();
  });

  $('textarea').on('blur change paste', updatePreview);

  $('input').on('blur change paste', function() {
    updatePreview();
  });

  updatePreview();
  resizePreview();

  $('.name').keypress(
    function(event){
     if (event.which == '13') {
        event.preventDefault();
      }
  });

});

$(window).resize(resizePreview);

$('.name').keypress(
    function(event){
     if (event.which == '13') {
        event.preventDefault();
      }
});