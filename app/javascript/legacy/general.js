import '@fancyapps/fancybox'
import '@fancyapps/fancybox/dist/jquery.fancybox.css'
import 'bootstrap-sass'


/*
 * Lightbox
 */
jQuery(function ($) {
  $('.fancy-box').fancybox()
})

/*
 * Image preview on profile edit page
 */
jQuery(function ($) {
  $('#user_avatar').change(function () {
    if (! this.files || ! this.files[0]) return;

    var reader = new FileReader()
    reader.onload = (e) => $('#user_avatar_preview').attr('src', e.target.result).show();
    reader.readAsDataURL(this.files[0]);
  });
})
