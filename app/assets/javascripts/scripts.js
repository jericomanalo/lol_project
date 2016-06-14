$( document ).ready(function() {
  $('#selected_selection').change(function() {
    console.log(this.value)
    var selected = this.value
    // perform actions on the page with javascript
  });
  $(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

});
