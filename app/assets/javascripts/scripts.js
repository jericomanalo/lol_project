$( document ).ready(function() {
  $('#selected_selection').change(function() {
    console.log(this.value)
    var selected = this.value
  });
  $(function () {
    $('[data-toggle="popover"]').popover({ trigger: "hover"})
  });
  $(function () {
  $('[data-toggle="tooltip"]').tooltip()
});




});
