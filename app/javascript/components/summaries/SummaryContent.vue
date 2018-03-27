<template>
  <span class="newlines">
    <component :is="part.type" v-for="part in contentParts" :r="getReference(part.id)">{{ part.content }}</component>
  </span>
</template>

<script>
import RCite from '../references/RCite.vue'

export default {
  components:{
    RCite,
  },

  props: ['summary', 'citedRefs'],

  computed: {
    contentParts () {
      return this.summary.content.split(/(<r-cite :r='r\(\d+\)'\/>)/gi).map(part => {
        const match = /<r-cite :r='r\((\d+)\)'\/>/gi.exec(part)
        if (match) return {type: 'r-cite', id: match[1]}
        return {type: 'span', content: part}
      })
    },
  },

  methods: {
    getReference (id) {
      if (! id) return null
      return this.citedRefs.filter(function(r){
        return r.id == id;
      })[0]
    }
  }
}
</script>