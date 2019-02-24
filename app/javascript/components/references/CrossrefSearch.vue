<template>
  <div>
    <div class="input-group input-group-sm crossref">
      <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
      <input class="form-control"
             :placeholder="placeholder"
             :disabled="!editsAllowed"
             v-model="query"
             @keydown.esc="clearSearch"
             @keyup="getResults"
      >
      <span class="input-group-addon" v-if="loading"><i class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></i></span>
      <form ref="form" action="/references" accept-charset="UTF-8" method="post" class="hidden">
        <input type="hidden" name="authenticity_token" :value="token">
        <input :value="list.id" type="hidden" name="reference[list_id]">
        <input value="doi" type="hidden" name="reference[locator][type]">
        <input :value="doi | stripUrl" type="hidden" name="reference[locator][id]">
      </form>
    </div>
    <ul class="list-group autocomplete" v-if="this.results.length">
      <li class="list-group-item"
          v-for="result in results"
          @click="selectResult(result)"
          v-html="result.fullCitation"
      >
      </li>
    </ul>
  </div>
</template>

<script>
import debounce from 'lodash-es/debounce'
import axios from '../../services/axios'

export default {
  props: ['editsAllowed', 'list'],

  data () {
    return {
      query: '',
      results: [],
      doi: '',
      submitted: false,
      placeholder: 'Search for a paper',
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
      loading: false,
    }
  },

  methods: {

    clearSearch () {
      this.results = []
      this.query = ''
    },

    getResults: debounce(function (e) {
      if (this.query === '') {
        return this.results = []
      }

      this.loading = true

      jQuery.getJSON('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.query)
      // axios.get('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.query)
        .then((response) => {
          if (response.length > 0) {
            this.results = response
          } else {
            this.results = [{fullCitation: 'No results found.', doi: ''}]
          }
          this.loading = false
        })
        .catch(err => {
          console.error(err)
          this.loading = false
        })
    }, 500),

    selectResult (result) {
      this.doi = result.doi;
      this.submitted = true;
      this.placeholder = result.fullCitation;
      this.clearSearch();
      // This is to give Vue time to update the doi above. It doesn't need much.
      window.setTimeout(() => {
        this.$refs.form.submit()
      }, 50)
    }
  },

  filters: {
    stripUrl  (doiUrl) {
      return doiUrl.replace('http://dx.doi.org/', '')
    }
  },
}
</script>