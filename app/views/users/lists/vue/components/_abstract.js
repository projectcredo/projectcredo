Vue.component("abstract", {
  props: ["abstract"],
  data: function() {
    return {
      truncateAbstract: true
    }
  },
  template: '#abstract'
})