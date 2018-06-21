<template>
  <div class="add-paper-component" :class="{opened: opened}" v-if="editsAllowed">
    <div class="btn-apc" @click.prevent="opened = ! opened">Add a Paper</div>
    <div class="apc-collapse">
      <div class="apc-body">
        <div class="apc-form">
          <div class="apc-form-item apc-search"><input type="text" placeholder="Search by topic" class="form-control" v-model="query" @keyup="getResults()"></div>
          <label class="apc-form-item"><input type="checkbox" v-model="hideAdded"> don't show papers I've already added to boards</label>
          <label class="apc-form-item"><input type="checkbox" v-model="onlyBookmarked"> only show papers I've bookmarked</label>
          <!-- <div class="apc-form-item apc-from-to">only show papers from <input type="text" class="form-control input-sm"> to <input type="text" class="form-control input-sm"></div> -->
        </div>
        <div class="apc-results">
          <div class="apcr-loading" v-if="loading">
            <scale-loader :loading="loading" color="#1FDEBF"></scale-loader>
          </div>
          <div v-if="query.length < 3">Please type at least 3 letters in the search field.</div>
          <ul class="apc-results-list" v-if=results.length>
            <paper :key="paper.doi" :paper="paper" v-for="paper in results" @add-paper="addPaper(paper)"></paper>
          </ul>
          <div v-if="query.length >= 3 && ! results.length">No results</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import debounce from 'lodash-es/debounce'
import Paper from './Paper.vue'
import ScaleLoader from 'vue-spinner/src/ScaleLoader.vue'

export default {
  components: {
    Paper,
    ScaleLoader
  },

  props: ['listId', 'editsAllowed'],

  data() {
    return {
      opened: false,
      loading: false,
      hideAdded: true,
      onlyBookmarked: false,
      query: '',
      results: [],
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
    }
  },

  methods: {
    clearSearch () {
      this.results = []
      this.query = ''
    },

    getResults: debounce(function (e) {
      if (this.query.length < 3) {
        return this.results = []
      }
      this.loading = true
      axios.get(`/papers/search?query=${this.query}`)
        .then((response) => {
          this.results = response.data
          this.loading = false
        })
        .catch(err => {
          this.loading = false
        })
    }, 500),

    addPaper (paper) {
      // TODO
    },
  }

}
</script>
