Vue.component('crossref-search', {
  template: '#crossref-search',
  props: ['userCanEdit'],
  data: function() {
    return {
      query: '',
      results: [],
      doi: '',
      submitted: false,
      placeholder: 'Search for a paper'
    }
  },
  methods: {
    clearSearch: function() {
      this.results = [];
      this.query = '';
    },
    getResults: debounce(
      function() {
        if (this.query === '') { return this.results = [] }

        $.get('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.query).done(function(data) {
          if (data.length > 0) {
            searchApp.results = data;
          } else {
            searchApp.results = [{fullCitation: 'No results found.', doi: ''}];
          };
        });
      },
      200
    ),
    selectResult: function(result) {
      this.doi = result.doi;
      this.submitted = true;
      this.searchDisabled = true;
      this.placeholder = result.fullCitation;
      this.clearSearch();
      // This is to give Vue time to update the doi above. It doesn't need much.
      window.setTimeout(function() { searchApp.$refs.form.submit() }, 50);
    }
  },
  filters: {
    stripUrl(doiUrl) {
      return doiUrl.replace('http://dx.doi.org/', '')
    }
  }
});