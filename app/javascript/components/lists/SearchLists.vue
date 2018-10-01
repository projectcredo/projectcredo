<template>
  <div id="search-lists">
    <div class="row">
      <div class="col-md-3">
        <div class="form-group">
          <input
            class="form-control query-input"
            v-model="query"
            v-bind:placeholder="placeholder"
            v-on:keyup="getResults"
            v-on:keyup.esc="clearResultsAndQuery"
            v-on:keyup.enter="clearResults"
          >

          <ul class="list-group autocomplete" v-if="results.length">
            <li
              class="list-group-item"
              v-for="result in results"
              v-html="result"
              v-on:click="selectResult(result)"
            >
            </li>
          </ul>
        </div>

        <a v-if="signedIn" href="/lists/new" class="btn panel panel-default new-list">
          <h3>Create a new<br> board</h3>
        </a>

        <div class="index-filters">
          <h4>Filters</h4>

          <button
            class="filter-btn"
            v-bind:class="{active: ! filterPins}"
            @click="filterPins = false"
          >
            All Research Activity
          </button>
          <button
            class="filter-btn"
            v-bind:class="{active: filterPins}"
            @click="filterPins = true"
          >
            Your Pins
          </button>
        </div>
      </div>
      <div class="col-md-9">
        <h1> </h1>
        <list-card
          v-for="list in showResults"
          :key="list.id"
          :list="list"
          :signed-in="signedIn"
        >
        </list-card>
      </div>
    </div>
  </div>
</template>

<script>
import Fuse from 'fuse.js'
import ListCard from './ListCard'

export default {
  props: ['lists', 'signedIn'],

  components: {
    ListCard
  },

  data () {
    return {
      query: '',
      results: [],
      placeholder: 'Search for a list...',
      filterPins: false,
      filterLikes: false,
    }
  },

  beforeMount () {
    this.query = window.location.search.split('&q=')[1]
  },

  computed: {
    tags () {
      var allTags = this.lists.reduce((memo, list) => memo.concat(list.tag_list), [])

      return Array.from(new Set(allTags))
    },

    matchQuery () {
      return this.query.split('+').join(' ')
    },

    fuseResults () {
      var options = {
        tokenize: true,
        shouldSort: true,
        threshold: 0.4,
        maxPatternLength: 32,
        minMatchCharLength: 1,
        keys: ['name', 'owner', 'tag_list', 'description'],
      }

      var fuse = new Fuse(this.lists, options)

      return fuse.search(this.matchQuery)
    },

    showResults () {
      var results = []
      if (this.query === '') {
        results = this.lists
      } else {
        results = this.fuseResults
      }

      if (this.filterPins) {
        results = results.filter(list => list.pinned)
      }
      if (this.filterLikes) {
        results = results.filter(list => list.liked)
      }

      return results
    },

    matchingTags () {
      return this.tags
        .filter(tag => tag.toLowerCase().includes(searchLists.matchQuery))
        .slice(0, 10)
    },
  },

  methods: {
    getResults () {
      if (this.query === '') {
        this.results = []
      } else {
        this.results = this.matchingTags
      }
    },

    clearResultsAndQuery () {
      this.query = ''
      this.results = []
    },

    clearResults () {
      this.results = []
    },

    selectResult (result) {
      this.query = result
      this.results = []
    },
  },
}
</script>
