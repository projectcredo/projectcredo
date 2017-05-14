Vue.component("reference-row", {
  props: ["r","index","signedIn"],
  data: function() {
    return {
      recommendIsLoading: false,
      hoverPaperDetails: false,
      showPaperDetails: false,
      truncateAbstract: true
    }
  },
  computed: {
    hasPaperDetails: function() {
      return this.r.notes.length > 0 || this.r.paper.tag_list.length > 0 || this.r.paper.abstract != null
    }
  },
  methods:{
    filter: function(add) {
      this.$emit('filter', add)
    }
  },
  template: '#reference-row'
});