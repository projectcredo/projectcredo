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

var TogglePin = {
  props: ['initialPin', 'listSlug'],
  data: function() {
    return {pinned: this.initialPin}
  },
  template: `
    <button class="btn btn-default btn-sm pull-left pin" :class="{active: pinned}" @click="submitTogglePin">
      {{ pinned ? 'Unpin' : 'Pin' }}
    </button>
  `,
  methods: {
    submitTogglePin: function () {
      var toggler = this
      $.ajax({
        type: (this.pinned ? 'DELETE' : 'POST'),
        url: toggler.pinPath,
        dataType: 'json'
      })
        .done(function() {toggler.pinned = !toggler.pinned})
    }
  },
  computed: {
    pinPath: function() {
      return '/lists/' + this.listSlug + '/pin'
    }
  }
}

var ToggleVote = {
  props: ['initialLike', 'voteUrl', 'votableClass', 'initialVoteCount'],
  data: function() {
    return {
      liked: this.initialLike,
      voteCount: this.initialVoteCount
    }
  },
  template: `
    <button :class="computedClasses" @click="submitToggleVote">
      {{ voteCount }}
    </button>
  `,
  methods: {
    toggleVote: function() {
      this.liked = !this.liked
      if (this.liked) {
        this.voteCount++
      } else {
        this.voteCount--
      }
    },
    submitToggleVote: function() {
      var toggler = this
      $.ajax({
        type: (this.liked ? 'DELETE' : 'POST'),
        url: toggler.voteUrl,
        dataType: 'json'
      })
        .done(toggler.toggleVote)
    }
  },
  computed: {
    computedClasses: function() {
      var classes = {
        vote: true,
        active: this.liked
      }
      classes[this.votableClass+'-vote'] = true
      return classes
    }
  }
}

var searchLists = {
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
  },
  components: {
    'toggle-vote': ToggleVote,
    'toggle-pin': TogglePin
  }
}
