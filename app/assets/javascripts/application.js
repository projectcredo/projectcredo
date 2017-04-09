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

// List Card Component for List Indexes
Vue.component("list-card", {
  props: ["list", "signedIn"],
  filters: {
    truncate: function(string, length) {
      return string.substring(0, length) + (string.length < length ? '' : '...');
    }
  },
  methods: {
    likeList: function(list) {
      var params = {
        id: list.id,
        type: "list"
      };
      $.ajax({
        url: list.like_path,
        type: 'POST',
        data: params,
      })
      .done(function(){
        list.liked = true
        list.likes = list.likes + 1
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
        data: params,
      })
      .done(function(){
        list.liked = false
        list.likes = list.likes - 1
      })
    },
    toggleLike: function(list) {
      if(this.signedIn) {
        if(list.liked) {
          this.unlikeList(list)
        } else {
          this.likeList(list)
        }
      } else {
        window.location.href = '/users/sign_in';
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
      .done(function(){
        list.pinned = true
        list.pins = list.pins + 1
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
      .done(function(){
        list.pinned = false
        list.pins = list.pins - 1
      })
    },
    togglePin: function(list) {
      if(this.signedIn) {
        if(list.pinned) {
          this.unpinList(list)
        } else {
          this.pinList(list)
        }
      } else {
        window.location.href = '/users/sign_in';
      }
    }
  },
  template: '#list-card'
})

var searchLists = new Vue({
  data: {
    unpinnedLists: [],
    pinnedLists: [],
    query: '',
    results: [],
    placeholder: "Search for a list..."
  },
  computed: {
    allLists: function () {
      return this.unpinnedLists.concat(this.pinnedLists)
    },
    allListsById: function() {
      return this.allLists.reduce(function(memo, list) {
        var listId = list.id
        delete list.id
        memo[listId+''] = list
        return memo
      }, {})
    },
    tags: function() {
      var allTags = this.allLists.reduce(function(memo, list) {
        return memo.concat(list.tag_list)
      }, [])

      return Array.from(new Set(allTags))
    },
    matchQuery: function() {
      return this.query.toLowerCase()
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

      var list = this.allListsById[id]
      var searchablAttrs = list.tag_list.concat(list.name, list.description, list.owner)
      // Only unique values
      searchablAttrs = Array.from(new Set(searchablAttrs))

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

