<template>
  <div class="authors" v-if="r.paper.authors.length > 0">
    by
    <span v-for="(author,index) in r.paper.authors" >
      <span class="action-link-soft" @click="filter(author.full_name)">{{ author.full_name }}</span><span v-if="index+1 < r.paper.authors.length">, </span>
    </span>
    <span class="action-link-soft text-capitalize"> · {{r | cite}}</span>
  </div>
  <div v-else>
    <span v-if="r.paper.publication != null || r.paper.published_at != null" class="action-link-soft text-capitalize">
      {{ r.paper | cite }}
    </span>
  </div>
</template>

<script>
export default {
  props: ['r'],

  methods: {
    filter (add) {
      this.$parent.$parent.$emit('filter', add)
    }
  },
}
</script>