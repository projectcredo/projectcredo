<template>
  <div>
    <span class="newlines">{{ abstract | truncate(250, truncateAbstract) }}</span>
    <a class="action-link"
       v-if="abstract.length > 250"
       @click.stop.prevent="truncateAbstract = ! truncateAbstract"
    >
      {{ truncateAbstract ? 'see more' : 'see less' }}
    </a>
  </div>
</template>

<script>
  export default {
    props: ['abstract'],

    data () {
      return {
        truncateAbstract: true
      }
    },
  }
</script>