Vue.component('add-by-locator', {
  template: '#add-by-locator',
  data: function() {
    return {
      locatorType: null,
      placeholderFor: {
        doi: "Ex: 10.1038/srep23344",
        pubmed: "Ex: 18365029",
        link: "Ex: http://example.org/article?id=1"
      }
    }
  },
  methods: {
    setLocatorType: function(refType) {
      this.locatorType = refType;
    },
    cancelAdd: function() {
      this.locatorType = null;
    }
  },
  computed: {
    showLocatorFields: function() {
      return !!this.locatorType;
    },
    showTitleField: function() {
      return this.locatorType === 'link'
    },
    locatorIdPlaceholder: function() {
      return this.placeholderFor[this.locatorType]
    }
  }
});