var crossrefSearch = Vue.component('crossref-search', {
  template: '#crossref-search',
  props: ['editsAllowed'],
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
        self = this
        $.get('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.query).done(function(data) {
          if (data.length > 0) {
            self.results = data;
          } else {
            self.results = [{fullCitation: 'No results found.', doi: ''}];
          };
        });
      },
      200
    ),
    selectResult: function(result) {
      self = this
      this.doi = result.doi;
      this.submitted = true;
      this.searchDisabled = true;
      this.placeholder = result.fullCitation;
      this.clearSearch();
      // This is to give Vue time to update the doi above. It doesn't need much.
      window.setTimeout(function() { self.$refs.form.submit() }, 50);
    }
  },
  filters: {
    stripUrl: function (doiUrl) {
      return doiUrl.replace('http://dx.doi.org/', '')
    }
  }
});