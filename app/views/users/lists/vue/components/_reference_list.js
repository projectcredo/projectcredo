Vue.component("reference-list", {
  props: ["signedIn", "currentUser", "userCanEdit", "filteredData", "filterKey","sortKey","sortOrders"],
  template: '#reference-list',
  methods: {
    sort: function (key) {
      this.$emit('sort', key)
    },
  }
});