$(document).ready(function() {
  toggleMenuHighlighting();
  changeRepresentativeListener();
  changeRacesListener();
  voteRaceListener();
  changeInitiativeListener();
  voteInitiativeListener();
  matchVoteListener();
  followListener();
  console.log("Jquery lives!")
});

function toggleMenuHighlighting() {
  $('#window_nav').on("click", "a", function(event) {
    $('#window_nav a').css("background-color", "transparent")
    $(this).css("background-color", "var(--color-patriot-blue-light)")
  });
}

function changeRepresentativeListener() {
  $('#body-content').on("click", ".index-item1", function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response)
      $('#show-data1').replaceWith(response)
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function changeRacesListener() {
  $('#body-content').on("click", ".index-item2", function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response);
      $('.show-container2').html(response);
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function voteRaceListener() {
  $('#body-content').on("submit", "#candidate-form", function(event) {
    console.log("I'm listening");
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      data: $(this).serialize()
    });

    request.done(function(response) {
      console.log(response);
      $('.show-container2').html(response);
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function changeInitiativeListener() {
  $('#body-content').on("click", ".index-item3", function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response);
      $('.show-container3').html(response);
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}


function voteInitiativeListener() {
  $('#body-content').on("submit", "#initiative-form", function(event) {
    console.log("I'm listening");
    event.preventDefault();

    var form = this;

    var request = $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      data: $(this).serialize()
    });

    request.done(function(response) {
      console.log(response);
      $(form).addClass('selected');
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function matchVoteListener() {
  $('#body-content').on("submit", ".list-item-form", function(event) {
    console.log("I'm listening");
    event.preventDefault();

    var form = this;

    var request = $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      data: $(this).serialize()
    });

    request.done(function(response) {
      console.log(response);
      $(form).replaceWith("<p class='list-item-field-end'>Vote recorded</p>");
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function followListener() {
  $('#body-content').on("submit", ".list-item-friend-form", function(event) {
    console.log("I'm listening");
    event.preventDefault();

    var form = this;

    var request = $.ajax({
      url: $(this).attr('action'),
      method: $(this).attr('method'),
      data: $(this).serialize()
    });

    request.done(function(response) {
      console.log(response);
      $(form).replaceWith("<p class='list-item-field-friend gray-back'>Followed</p>");
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}
