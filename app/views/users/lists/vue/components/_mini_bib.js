Vue.component("mini-bib", {
  props: ["r"],
  methods:{
    filter: function(add) {
      this.$parent.$emit('filter', add)
    }
  },
  template: '#mini-bib'
})