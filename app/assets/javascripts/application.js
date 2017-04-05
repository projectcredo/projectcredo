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
// Also needs to be pre-ES6 for asset pipeline compatibility

var searchLists = new Vue({
  data: {
    allLists: [],
    unpinnedLists: [],
    pinnedLists: [],
    query: '',
    results: [],
    placeholder: "Search for a list..."
  },
  filters: {
    truncate(string, length) {
      return string.substring(0, length) + (string.length < length ? '' : '...');
    }
  },
  computed: {
    tags: function() {
      var allTags = this.allLists.reduce(function(memo, list) {
        return memo.concat(list.tag_list)
      }, [])

      return Array.from(new Set(allTags))
    },
    matchQuery: function() {
      return this.query.split('+').join(' ');
    },
    fuseResults: function() {
      if (this.query === '') {return this.allLists}
      var options = {
        tokenize: true,
        shouldSort: true,
        threshold: 0.4,
        maxPatternLength: 32,
        minMatchCharLength: 1,
        keys: [
          "name",
          "owner",
          "tag_list",
          "description"
        ]
      };

      var fuse = new Fuse(this.allLists, options);
      return fuse.search(this.matchQuery);
    },
    matchingTags: function() {
      return this.tags.filter(function(tag) {
        return tag.toLowerCase().includes(searchLists.matchQuery)
      }).slice(0,10)
    }
  },
  methods: {
    showList: function(id) {
      if (this.query === '') {return true}

      return this.fuseResults.includes(id)
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
    },
    likeList: function(list) {
      var params = {
        id: list.id,
        type: "list"
      };
      $.ajax({
        url: list.like_path,
        type: 'POST',
        data: params
      })
    },
    unlikeList: function(list) {
      var params = {
        id: list.id,
        type: "list"
      };
      $.ajax({
        url: list.like_path,
        type: 'DELETE',
        data: params
      })
    },
    toggleLike: function(list) {
      if(list.liked) {
        this.unlikeList(list)
        list.liked = false
        list.likes = list.likes - 1
      } else {
        this.likeList(list)
        list.liked = true
        list.likes = list.likes + 1
      }
    },
    pinList: function(list) {
      var params = {
        id: list.slug
      };
      $.ajax({
        url: "/pins",
        type: 'POST',
        data: params
      })
    },
    unpinList: function(list) {
      var params = {
        id: list.slug
      };
      $.ajax({
        url: "/pins/" + list.slug,
        type: 'DELETE',
        data: params
      })
    },
    togglePin: function(list) {
      if(list.pinned) {
        this.unpinList(list)
        list.pinned = false
        list.pins = list.pins - 1
      } else {
        this.pinList(list)
        list.pinned = true
        list.pins = list.pins + 1
      }
    }
  }
});
