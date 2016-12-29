$(document).ready(function() {
  $('a.delete-reference').on('click', function(e) {
    e.preventDefault();
    $(e.target).siblings('form').submit();
  });

  $(document).on('click', 'a.edit-abstract', function(e) {
    e.preventDefault();
    abstractDiv = $(e.target).closest("div.edit-abstract");
    abstractForm = abstractDiv.next('div.abstract-form');
    cancelLink = abstractForm.find("a.cancel-abstract-form")
    abstractForm.toggleClass('hidden', false);
    cancelLink.toggleClass('hidden', false);
    abstractDiv.toggleClass('hidden', true);
  });

  $(document).on('click', 'a.cancel-abstract-form', function(e) {
    e.preventDefault();
    abstractForm = $(e.target).closest("div.abstract-form");
    abstractDiv = abstractForm.prev('div.edit-abstract');
    abstractForm.toggleClass('hidden', true);
    abstractDiv.toggleClass('hidden', false);
  });

  $('a.add-tag').on('click', function(e) {
    e.preventDefault();

    tagsList = $(e.target).closest('.tags-list');
    tagsForm = tagsList.next('.tags-form');

    tagsList.toggleClass('hidden', true);
    tagsForm.toggleClass('hidden', false);
  });

  $('a.cancel-add-tag').on('click', function(e) {
    e.preventDefault();

    tagsForm = $(e.target).closest('.tags-form');
    tagsList = tagsForm.prev('.tags-list');

    tagsList.toggleClass('hidden', false);
    tagsForm.toggleClass('hidden', true);
  });
});
