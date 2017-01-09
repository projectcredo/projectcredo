// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

// debounce stolen from Underscore.js 1.8.3
debounce = function(func, wait, immediate) {
  var timeout, args, context, timestamp, result;

  var later = function() {
    var last = new Date().getTime() - timestamp;

    if (last < wait && last >= 0) {
      timeout = setTimeout(later, wait - last);
    } else {
      timeout = null;
      if (!immediate) {
        result = func.apply(context, args);
        if (!timeout) context = args = null;
      }
    }
  };

  return function() {
    context = this;
    args = arguments;
    timestamp = new Date().getTime();
    var callNow = immediate && !timeout;
    if (!timeout) timeout = setTimeout(later, wait);
    if (callNow) {
      result = func.apply(context, args);
      context = args = null;
    }

    return result;
  };
};

// Temporary location for shared Vue scripts

var searchLists = new Vue({
  data: {
    unpinnedLists: [],
    pinnedLists: [],
    query: '',
    results: [],
    placeholder: "Search for a list..."
  },
  computed: {
    allLists() {
      allLists = this.unpinnedLists.concat(this.pinnedLists)
      return allLists.reduce((memo, list)=>{
        var listId = list.id
        delete list.id
        memo[listId+''] = list
        return memo
      }, {})
    },
    tags() {
      return Object.keys(this.allLists).reduce((memo, listId) => {
        return memo.concat(this.allLists[listId].tag_list)
      }, [])
    },
    matchQuery() {
      return this.query.toLowerCase()
    },
    matchingTags() {
      return this.tags.filter((tag) => {
        return tag.toLowerCase().includes(this.matchQuery)
      }).slice(0,10)
    }
  },
  methods: {
    showList: function(id) {
      if (this.query === '') {return true}

      var list = this.allLists[id]
      var searchablAttrs = list.tag_list.concat(list.name, list.description, list.owner)
      // Only unique values
      searchablAttrs = [...new Set(searchablAttrs)]

      return searchablAttrs.toString().toLowerCase().includes(this.query)
    },
    getResults: function() {
      if (this.query === '') {
        this.results = []
      } else {
        this.results = this.matchingTags
      }
    },
    clearResults: function() {
      this.query = ''
      this.results = []
    },
    selectResult: function(result) {
      this.query = result
      this.results = []
    }
  }
});
