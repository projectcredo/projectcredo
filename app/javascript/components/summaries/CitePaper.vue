<template>
  <span>
    <span class="text-capitalize r-cite" v-if="r" @click="selectReference(r.index)">
      {{ r.paper | cite }}
    </span>
    <span class="text-capitalize r-cite" v-else>
      [filtered]
    </span>
  </span>
</template>

<script>
export default {
  props: ['r'],

  methods: {
    selectReference (index) {
      this.$parent.$emit('select-ref', index)
    },
  },
}
</script>