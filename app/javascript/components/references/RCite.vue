<template>
  <span>
    <span class="text-capitalize r-cite" v-if="r" @click="selectReference(r.index)">
      {{ r | cite }}
    </span>
    <span class="text-capitalize r-cite" v-else>
      [filtered]
    </span>
  </span>
</template>

<script>
export default {
  props: ['r'],

  methods:{
    selectReference: function(index) {
      this.$parent.$emit('select-ref', index)
    }
  },
}
</script>