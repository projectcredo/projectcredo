<template>
  <div class="add-paper-component" :class="{opened: opened}" v-if="editsAllowed">
    <div class="btn-apc" @click.prevent="opened = ! opened">Add a Paper</div>
    <div class="apc-collapse">
      <div class="apc-body">
        <div class="apc-form">
          <div class="apc-form-item apc-search"><input type="text" placeholder="Search by topic" class="form-control" v-model="query"></div>
          <label class="apc-form-item"><input type="checkbox"> don't show papers I've already added to boards</label>
          <label class="apc-form-item"><input type="checkbox"> only show papers I've bookmarked</label>
          <div class="apc-form-item apc-from-to">only show papers from <input type="text" class="form-control input-sm"> to <input type="text" class="form-control input-sm"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import debounce from 'lodash-es/debounce'

export default {

  props: ['listId', 'editsAllowed'],

  data() {
    return {
      opened: false,
      query: '',
      results: [],
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
      axios.get(`/papers/search?query=${this.query}`)
        .then((response) => {
          if (response.data.length > 0) {
            this.results = response.data
          } else {
            this.results = [{fullCitation: 'No results found.', doi: ''}]
          }
        })
    }, 500),
  }

}
</script>
