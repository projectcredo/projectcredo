<template>
  <span>
    <span class="text-capitalize r-cite" v-if="paper" @click.prevent="$parent.$emit('select-paper', paper)">
      <cite-text :paper="paper"></cite-text>
    </span>
    <span class="text-capitalize r-cite" v-else>
      [filtered]
    </span>
  </span>
</template>

<script>
import CiteText from './CiteText'

export default {
  props: ['paper'],

  components: {
    CiteText
  },
}
</script>
