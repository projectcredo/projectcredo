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
Vue.filter('truncate', function(string, length, truncate) {
  if (typeof truncate === 'undefined') { truncate = 'true'; }
  if(truncate) {
    return string.substring(0, length) + (string.length < length ? '' : '...');
  } else{
    return string
  }
});

Vue.filter('cite', function(reference) {
  var mainAuthor  = ''
  var year =  ''
  var seperator = ''
  var pub = reference.publication

  if(reference.authors.length> 0) {
    mainAuthor = reference.authors[0].family_name
  }
  if(reference.paper.published_at != '') {
    year = new Date(reference.paper.published_at).getFullYear()
  }
  var joinedCitation = $.grep([year, mainAuthor, pub], Boolean).join(", ");

  if(pub != '' || year != '') {
    return "[" + joinedCitation + "]"
  }
});

Vue.component("vote", {
  props: ["voteable", "signedIn"],
  data: function() {
  return {
    isLoading: false
    }
  },
  methods: {
    vote: function(voteable) {
      var self = this;
      var params = {
        id: voteable.id,
        type: voteable.type
      };
      $.ajax({
        url: voteable.vote_path + ".json",
        type: 'POST',
        data: params
      })
      .done(function(){
        voteable.voted = true
        voteable.votes = voteable.votes + 1
        self.isLoading = false
      });
    },
    unvote: function(voteable) {
      var self = this;
      var params = {
        id: voteable.id,
        type: voteable.type
      };
      $.ajax({
        url: voteable.vote_path + ".json",
        type: 'DELETE',
        data: params
      })
      .done(function(){
        voteable.voted = false
        voteable.votes = voteable.votes - 1
        self.isLoading = false
      });

    },
    toggleVote: function(voteable) {
      if(!this.signedIn) {
        window.location.href = '/users/sign_in';
      } else if(!this.isLoading) {
        this.isLoading = true
        if(voteable.voted) {
          this.unvote(voteable)
        } else {
          this.vote(voteable)
        }
      }
    },
  },
  template: '#vote'
});

Vue.component("list-card", {
  props: ["list", "signedIn"],
  data: function() {
    return {
      likeIsLoading: false,
      pinIsLoading: false,
      showMore: false
    }
  },
  methods: {
    likeList: function(list) {
      var self = this;
      var params = {
        id: list.id,
        type: "list"
      };
      $.ajax({
        url: list.like_path + ".json",
        type: 'POST',
        data: params
      })
      .done(function(){
        list.liked = true
        list.likes = list.likes + 1
        self.likeIsLoading = false
      })

    },
    unlikeList: function(list) {
      var self = this;
      var params = {
        id: list.id,
        type: "list"
      };
      $.ajax({
        url: list.like_path + ".json",
        type: 'DELETE',
        data: params
      })
      .done(function(){
        list.liked = false
        list.likes = list.likes - 1
        self.likeIsLoading = false
      });

    },
    toggleLike: function(list) {
      if(!this.signedIn) {
        window.location.href = '/users/sign_in';
      } else if(!this.likeIsLoading) {
        this.likeIsLoading = true
        if(list.liked) {
          this.unlikeList(list)
        } else {
          this.likeList(list)
        }
      }
    },
    pinList: function(list) {
      var self = this;
      var params = {
        id: list.slug
      };
      $.ajax({
        url: "/pins.json",
        type: 'POST',
        data: params
      })
      .done(function(){
        list.pinned = true
        list.pins = list.pins + 1
        self.pinIsLoading = false
      })
    },
    unpinList: function(list) {
      var self = this;
      var params = {
        id: list.slug
      };
      $.ajax({
        url: "/pins/" + list.slug  + ".json",
        type: 'DELETE',
        data: params
      })
      .done(function(){
        list.pinned = false
        list.pins = list.pins - 1
        self.pinIsLoading = false
      })
    },
    togglePin: function(list) {
      if(!this.signedIn) {
        window.location.href = '/users/sign_in';
      } else if(!this.pinIsLoading) {
        this.pinIsLoading = true
        if(list.pinned) {
          this.unpinList(list)
        } else {
          this.pinList(list)
        }
      }
    }
  },
  template: '#list-card'
})

var searchLists = new Vue({
  data: {
    signedIn: false,
    allLists: [],
    query: '',
    results: [],
    placeholder: "Search for a list...",
    filterPins: false,
    filterLikes: false
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
    showResults: function() {
      var results = []
      if (this.query === '') {
        results = this.allLists
      } else {
        results = this.fuseResults
      }

      if(this.filterPins) {
        results = results.filter(function(list){
          return list.pinned
        })
      }
      if(this.filterLikes) {
        results = results.filter(function(list){
          return list.liked
        })
      }

      return results

    },
    matchingTags: function() {
      return this.tags.filter(function(tag) {
        return tag.toLowerCase().includes(searchLists.matchQuery)
      }).slice(0,10)
    }
  },
  methods: {
    getResults: function() {
      if (this.query === '') {
        this.results = []
      } else {
        this.results = this.matchingTags
      }
    },
    clearResultsAndQuery: function() {
      this.query = ''
      this.results = []
    },
    clearResults: function() {
      this.results = []
    },
    selectResult: function(result) {
      this.query = result
      this.results = []
    }
  }
});


var activityFeed = new Vue({
  data: {
    signedIn: false,
    allLists: [],
    filterPins: false
  },
  methods: {
    toggleFilterPins: function() {
      if(this.filterPins) {
        this.filterPins = false;
      } else {
        this.filterPins = true;
      }
    }
  }
});
