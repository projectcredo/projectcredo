import '@fancyapps/fancybox'
import '@fancyapps/fancybox/dist/jquery.fancybox.css'
import 'bootstrap-sass'

/*
 * Lightbox
 */
jQuery(function($) {
  $('.fancy-box').fancybox()
})

/*
 * Image preview on profile edit page
 */
jQuery(function($) {
  $('.form-image-group input').change(function() {
    if (!this.files || !this.files[0]) return
    var $group = $(this).closest('.form-image-group')
    var $image = $group.find('.form-image-preview')
    var $link = $image.parent('a')

    console.log($group, $image)

    var reader = new FileReader()
    reader.onload = e => {
      $image.attr('src', e.target.result).show()
      if ($link.length) $link.attr('href', e.target.result)
    }
    reader.readAsDataURL(this.files[0])
  })
})
