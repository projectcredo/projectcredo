Vue.component("note", {
  props: ["note"],
  data: function() {
    return {
      truncateNote: true
    }
  },
  template: '#note'
})