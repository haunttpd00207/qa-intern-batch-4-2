$( document ).on('turbolinks:load', function() {
  $('#myModal').on('shown.bs.modal', function () {
    $('#myInput').trigger('focus')
  });

  $(".btn-signup-form").click(function() {
    $(".signin-form").modal('hide');
    $('body').css('overflow-y', 'hidden')
    $('.signup-form').css('overflow-y', 'auto');
  });

  $(".btn-signin-form").click(function() {
    $(".signup-form").modal('hide');
    $('body').css('overflow-y', 'hidden')
    $('.signin-form').css('overflow-y', 'auto');
  });

  $(".btn-password-reset-form").click(function() {
    $(".signin-form").modal('hide');
    $('body').css('overflow-y', 'hidden')
    $('.signup-form').css('overflow-y', 'auto');
  });

  $('.tag-multiple').select2({
    theme: 'bootstrap',
    placeholder: 'Tags'
  });

  $('.select-category').select2({
    theme: 'bootstrap',
  });
});
