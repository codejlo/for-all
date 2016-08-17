$(document).ready(function() {
  toggleMenuHighlighting();
  showContainerListener(".index-item1", '.show-container1');
  showContainerListener(".index-item2", '.show-container2');
  showContainerListener(".index-item3", '.show-container3');
  console.log("Jquery lives!")
});

function toggleMenuHighlighting() {
  $('#window_nav').on("click", "a", function(event) {
    $('#window_nav a').css("background-color", "transparent")
    $(this).css("background-color", "var(--color-patriot-blue-light)")
  });
}

function showContainerListener(delegated_tag, show_container_tag) {
  $('#body-content').on("click", delegated_tag,function(event) {
    console.log("I'm listening")
    event.preventDefault();

    $.get($(this).attr('href'))
     .done(function(response) { $(show_container_tag).html(response); })
     .fail(function(response) { console.log("Failed ajax request for rep show."); });
  });
}

