<template>
  <div class="authors" v-if="paper.authors.length > 0">
    by
    <span v-for="(author, index) in paper.authors" :key="author.id">
      <span class="action-link-soft" @click="filter(author.full_name)">{{ author.full_name }}</span><span v-if="index+1 < paper.authors.length">, </span>
    </span>
    <span class="action-link-soft text-capitalize"> · <cite-text :paper="paper"></cite-text></span>
  </div>
  <div v-else>
    <span v-if="paper.publication != null || paper.published_at != null" class="action-link-soft text-capitalize">
      <cite-text :paper="paper"></cite-text>
    </span>
  </div>
</template>

<script>
import CiteText from './CiteText'

export default {
  props: ['paper'],

  components: {
    CiteText,
  },

  methods: {
    filter (add) {
      this.$parent.$parent.$emit('filter', add)
    }
  },
}
</script>