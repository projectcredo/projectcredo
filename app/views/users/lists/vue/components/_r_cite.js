Vue.component("r-cite", {
  props: ["rId"],
  methods:{
    filter: function(add) {
      this.$parent.$parent.$emit('filter', add)
    }
  },
  template: '#r-cite'
})