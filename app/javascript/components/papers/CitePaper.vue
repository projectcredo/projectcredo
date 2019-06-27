<template>
  <span>
    <span class="text-capitalize r-cite" v-if="paper" @click.prevent="$parent.$emit('select-paper', paper)">
      {{ text }}
    </span>
    <span class="text-capitalize r-cite" v-else>
      [filtered]
    </span>
  </span>
</template>

<script>
import {citeText} from './helpers'

export default {
  props: ['paper'],

  computed: {
    text () {
      return citeText(this.paper)
    },
  },
}
</script>
