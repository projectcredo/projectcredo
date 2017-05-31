Vue.component("r-cite", {
  props: ["r"],
  methods:{
    filter: function(add) {
      this.$parent.$parent.$emit('filter', add)
    }
  },
  template: '#r-cite'
})