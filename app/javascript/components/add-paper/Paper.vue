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
      <div><a href="#" @click.prevent="$emit('add-paper')" class="cpcp-save-btn">+</a></div>
      <div><bookmark v-if="paper.source === 'db'" :bookmarkable="{id: paper.id, type: 'Paper', bookmarked: paper.bookmarked}" :signed-in="true" class="add-paper"></bookmark></div>
    </div>
  </li>
</template>

<script>
import Bookmark from '../references/Bookmark.vue'

export default {
  components: {
    Bookmark,
  },

  props: ['paper'],

  data () {
    return {
      abstractMore: false,
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
    }
  },

  methods: {
    shorten(str, maxLen, separator = ' ') {
      if (str.length <= maxLen) return str

      return str.substr(0, str.lastIndexOf(separator, maxLen))
    },

    addPaper () {
      
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
  },
}
</script>
