Vue.component("reference-row", {
  props: ["r","index","signedIn", "editsAllowed"],
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
    },
    showRemove: function() {
      return this.editsAllowed || this.r.added_by == '<%= current_user.username %>'
    }
  },
  methods:{
    filter: function(add) {
      this.$parent.$emit('filter', add)
    },
    selectReference: function(index) {
      this.$parent.$emit('select-ref', index)
    },
    removeReference: function(index) {
      this.$parent.$emit('remove-ref', index)
    }
  },
  template: '#reference-row'
});
