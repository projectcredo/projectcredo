<template>
  <span class="deemphasized">
    {{ remainingCount }}/{{ max }} left
  </span>
</template>

<script>
export default {

  props: ['currentLength', 'max'],

  computed: {
    remainingCount () {
      return this.max - this.currentLength
    },
  },

}
</script>