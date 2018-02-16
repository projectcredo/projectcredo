<template>
  <span>
    <a :class="[{'toggled': this.voteable.voted}, 'vote', 'thumbs-up']"
       @click="toggleVote(voteable)"
       v-show="!isLoading"
    >
      {{voteable.votes}}
    </a>
    <span class="spinner" v-show="isLoading">
      <span class="double-bounce1"></span>
      <span class="double-bounce2"></span>
    </span>
  </span>
</template>

<script>
  export default {
    props: ['abstract'],

    data: function() {
      return {
        truncateAbstract: true
      }
    },
  }
</script>