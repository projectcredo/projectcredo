window.jQuery = require('jquery')
require('@fancyapps/fancybox')
require('@fancyapps/fancybox/dist/jquery.fancybox.css')
require('bootstrap-sass')

/*
 * Lightbox
 */
jQuery(function($) {
  $('.fancy-box').fancybox()
})

/*
 * Tooltips
 */
jQuery(function($) {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
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

/*
 * Read notifications
 */
jQuery(function($) {
  $(document).on('show.bs.dropdown', function() {
    if ($('a.dropdown-toggle').hasClass('unread-notifications')) {
      $.ajax({
        type: 'GET',
        url: '/read_notifications.js',
      })
    }
  })
})

/*
 * References
 */
jQuery(function($) {
  $('a.delete-reference').on('click', function(e) {
    e.preventDefault()
    $(e.target)
      .siblings('form')
      .submit()
  })

  $(document).on('click', 'a.edit-abstract', function(e) {
    e.preventDefault()
    abstractDiv = $(e.target).closest('div.edit-abstract')
    abstractForm = abstractDiv.next('div.abstract-form')
    cancelLink = abstractForm.find('a.cancel-abstract-form')
    abstractForm.toggleClass('hidden', false)
    cancelLink.toggleClass('hidden', false)
    abstractDiv.toggleClass('hidden', true)
  })

  $(document).on('click', 'a.cancel-abstract-form', function(e) {
    e.preventDefault()
    abstractForm = $(e.target).closest('div.abstract-form')
    abstractDiv = abstractForm.prev('div.edit-abstract')
    abstractForm.toggleClass('hidden', true)
    abstractDiv.toggleClass('hidden', false)
  })

  $('a.add-tag').on('click', function(e) {
    e.preventDefault()

    tagsList = $(e.target).closest('.tags-list')
    tagsForm = tagsList.next('.tags-form')

    tagsList.toggleClass('hidden', true)
    tagsForm.toggleClass('hidden', false)
  })

  $('a.cancel-add-tag').on('click', function(e) {
    e.preventDefault()

    tagsForm = $(e.target).closest('.tags-form')
    tagsList = tagsForm.prev('.tags-list')

    tagsList.toggleClass('hidden', false)
    tagsForm.toggleClass('hidden', true)
  })
})

/*
 * Papers
 */
jQuery(function($) {
  $('.paper-detail-tab').on('click', function(e) {
    e.preventDefault()

    var detailId = $(e.target).data('detail-id')

    paperDetail = $('#' + detailId)

    paperDetail.siblings('.paper-detail').each(function(i, sibling) {
      $(sibling).collapse('hide')
    })

    paperDetail.collapse('toggle')
  })
})
