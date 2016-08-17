$(document).ready(function() {
  toggleMenuHighlighting();
  changeRepresentativeListener();
  changeRacesListener();
  changeInitiativeListener();
  console.log("Jquery lives!")
});

function toggleMenuHighlighting() {
  $('#window_nav').on("click", "a", function(event) {
    $('#window_nav a').css("background-color", "transparent")
    $(this).css("background-color", "var(--color-patriot-blue-light)")
  });
}

function changeRepresentativeListener() {
  $('#body-content').on("click", ".index-item1",function(event) {
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
  $('#body-content').on("click", ".index-item2",function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response)
      $('.show-container2').html(response)
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}

function changeInitiativeListener() {
  $('#body-content').on("click", ".index-item3",function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response)
      $('.show-container3').html(response)
    });

    request.fail(function(response) {
      console.log(response);
      console.log("Failed ajax request for rep show.");
    });

  });
}
