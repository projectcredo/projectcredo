<template>
  <li>
    <div class="apcp-main-col">
      <div class="apcp-title">{{ paper.title }}</div>
      <div class="apcp-authors">{{ paper.authors.join(', ') }}</div>
      <div class="apcp-score">
        <span class="label" :class="{'label-primary': paper.score, 'label-default': ! paper.score}">{{ score }}</span>
      </div>
      <div class="apcp-abstract" v-if="paper.abstract">
        {{ abstract }}
        <a href="#" @click.prevent="abstractMore = ! abstractMore">
          {{ abstractMore ? 'less' : 'more' }}
        </a>
      </div>
    </div>
    <div class="apcp-action-col">
      <div><a href="#" @click.prevent="addPaper" class="cpcp-save-btn" :disabled="addingPaper">+</a></div>
      <div><bookmark v-if="paper.source === 'db'" :bookmarkable="{id: paper.id, type: 'Paper', bookmarked: paper.bookmarked}" :signed-in="true" class="add-paper"></bookmark></div>
    </div>
    <form ref="form" action="/references" method="post" style="display: none;">
      <input name="authenticity_token" :value="token">
      <input :value="listId" type="hidden" name="reference[list_id]">
      <input :value="locatorType" type="hidden" name="reference[locator][type]">
      <input :value="paper.id || paper.doi || paper.pubmed_id" type="hidden" name="reference[locator][id]">
    </form>
  </li>
</template>

<script>
import Bookmark from '../references/Bookmark.vue'

export default {
  components: {
    Bookmark,
  },

  props: ['paper', 'listId'],

  data () {
    return {
      abstractMore: false,
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
      addingPaper: false,
    }
  },

  methods: {
    shorten(str, maxLen, separator = ' ') {
      if (str.length <= maxLen) return str

      return str.substr(0, str.lastIndexOf(separator, maxLen))
    },

    addPaper () {      
      this.addingPaper = true
      this.$refs.form.submit()
    },
  },

  computed: {
    score () {
      return this.paper.score ? parseFloat(this.paper.score).toFixed(0) : 'unscored'
    },

    abstract () {
      if (! this.paper.abstract) return ''
      if (this.abstractMore || this.paper.abstract.length < 200) return this.paper.abstract

      return this.shorten(this.paper.abstract, 200) + '...'
    },

    locatorType () {
      return this.paper.id ? 'db' : (this.paper.doi ? 'doi' : (this.paper.pubmed_id ? 'pubmed_id' : ''))
    },
  },
}
</script>
