$(document).ready(function() {
  bindListeners();
});

function bindListeners() {
  changeRepresentativeListener();
}

function changeRepresentativeListener() {
  $('.body-content').on("click", ".representative",function(event) {
    event.preventDefault();

    request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      $('.show-container').html(response)
    });

    request.fail(function(response) {
      console.log("Failed ajax request for rep show.")
    });

  });
}
