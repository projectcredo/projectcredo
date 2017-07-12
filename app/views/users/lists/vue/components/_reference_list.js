Vue.component("reference-list", {
  props: ["filteredData", "value","sortKey","sortOrders","signedIn","editsAllowed"],
  template: '#reference-list',
  methods: {
    sort: function (key) {
      this.$emit('sort', key)
    },
    updateFilterKey: function (value) {
      this.$emit('input', value)
    }
  }
});