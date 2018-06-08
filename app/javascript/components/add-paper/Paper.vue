<template>
  <li>
    <div class="apc-paper-title">{{ paper.title }}</div>
    <div class="apc-paper-authors">{{ paper.authors.join(', ') }}</div>
    <div class="apc-paper-score">
      <span class="label" :class="{'label-primary': paper.score, 'label-default': ! paper.score}">{{ score }}</span>
    </div>
    <div class="apc-paper-abstract" v-if="paper.abstract">
      {{ abstract }}
      <a href="#" @click.prevent="abstractMore = ! abstractMore">
        {{ abstractMore ? 'less' : 'more' }}
      </a>
    </div>
  </li>
</template>

<script>
export default {
  props: ['paper'],

  data () {
    return {
      abstractMore: false,
    }
  },

  methods: {
    shorten(str, maxLen, separator = ' ') {
      if (str.length <= maxLen) return str

      return str.substr(0, str.lastIndexOf(separator, maxLen))
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
