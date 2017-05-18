Vue.component("reference-list", {
  props: ["filteredData", "filterKey","sortKey","sortOrders","signedIn"],
  template: '#reference-list',
  methods: {
    sort: function (key) {
      this.$emit('sort', key)
    },
  }
});