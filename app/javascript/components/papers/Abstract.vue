<template>
  <div>
    <span class="newlines" v-html="text"></span>
    <a class="action-link" v-if="abstract.length > 250" @click.stop.prevent="truncateAbstract = ! truncateAbstract">
      {{ truncateAbstract ? 'see more' : 'see less' }}
    </a>
  </div>
</template>

<script>
  import Vue from 'vue'
  export default {
    props: ['abstract'],

    data () {
      return {
        truncateAbstract: true
      }
    },

    computed: {
      text () {
        return Vue.options.filters.truncate(this.abstract, 250, this.truncateAbstract).replace(/(?:\r\n|\r|\n)/g, '<br>')
      },
    },
  }
</script>
