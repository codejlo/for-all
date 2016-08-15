$(document).ready(function() {
  changeRepresentativeListener();
  console.log("Jquery lives!")
});

function changeRepresentativeListener() {
  $('#body-content').on("click", "a",function(event) {
    console.log("I'm listening")
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr('href'),
      method: "GET"
    });

    request.done(function(response) {
      console.log(response)
      $('#show-data').replaceWith(response)
    });

    request.fail(function(response) {
      console.log("Failed ajax request for rep show.")
    });

  });
}
