Vue.component("r-cite", {
  props: ["r"],
  methods:{
    selectReference: function(index) {
      this.$parent.$emit('select-ref', index)
    }
  },
  template: '#r-cite'
})