<template>
  <div>
    <div class="summary-content newlines" :class="{truncate: truncate}" @click="truncate = false">
      <component :is="part.type" v-for="part in contentParts" :paper="getPaper(part.id)">{{ part.content }}</component>
    </div>
    <a href="#" class="action-link" v-if="summary.content.length > 250" @click.stop.prevent="truncate = ! truncate">
      {{ truncate ? 'see more' : 'see less' }}
    </a>
  </div>
</template>

<script>
import CitePaper from '../papers/CitePaper.vue'

export default {
  props: ['summary', 'list'],

  components: {
    CitePaper,
  },

  data () {
    return {
      truncate: true,
    }
  },

  computed: {
    contentParts () {
      return this.summary.content.split(/(\[cite_paper id=\d+\])/gi).map(part => {
        const match = /\[cite_paper id=(\d+)\]/gi.exec(part)
        if (match) return {type: 'cite-paper', id: match[1]}
        return {type: 'span', content: part}
      })
    },
  },

  methods: {
    getPaper (id) {
      if (! id || ! this.list) return null
      id = parseInt(id)
      let paper

      this.list.posts.find((post) => {
        return post.articles.find(article => {
          return article.papers.find(p => {
            if (p.id === id) {
              paper = p
              return p
            }
          })
        })
      })

      return paper
    }
  }
}
</script>
