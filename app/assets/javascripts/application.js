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

var SingleList = {
  props: ['id', 'pinned', 'slug', 'voted', 'votes', 'editable', 'owner', 'tagList', 'description', 'updatedAt', 'commentsCount', 'name'],
  template: `
    <div class="col-md-3 list-card">
      <div class="panel panel-default">
        <div class="panel-body">
          <div class="row">
            <div class="col-md-12">
              <toggle-pin :initial-pin="pinned" list-slug="slug"></toggle-pin>
              <span :id="'list-vote-' + id">
                <toggle-vote
                  :initial-like="voted"
                  :vote-url="'lists/' + slug + '/vote'"
                  votable-class="list"
                  :initial-vote-count="votes"
                ></toggle-vote>
              </span>
              <small class="pull-right" v-if="editable">
                <a :href="owner + '/' + slug + '/edit'">Edit</a>
              </small>
            </div>
          </div>
          <h2>
            <a :href="owner + '/' + slug + '/'">{{ name }}</a> <br>
            <small> by <a :href="owner + '/'">{{ owner }}</a></small>
          </h2>

          <a v-for="tag in tagList" class="btn btn-default btn-xs">{{ tag }}</a>

          <p>{{ description }}</p>

          <small><i>
            Last Update: {{ updatedAt.readable }}
            <span class="pull-right">{{ commentsCount }} comments</span>
          </i></small>
        </div>
      </div>
    </div>
  `,
  components: {
    'toggle-vote': ToggleVote,
    'toggle-pin': TogglePin
  }
}

var searchLists = {
  data: {
    allLists: [],
    query: '',
    results: [],
    placeholder: "Search for a list..."
  },
  computed: {
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
        return memo.concat(list.tagList)
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
    },
    pinnedLists: function() {
      return this.allLists.filter(function(list) {
        return list.pinned
      })
    },
    unpinnedLists: function() {
      return this.allLists.filter(function(list) {
        return !list.pinned
      })
    }
  },
  methods: {
    showList: function(list) {
      if (this.query === '') {return true}

      var searchablAttrs = list.tagList.concat(list.name, list.description, list.owner)
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
  mounted: function() {
    var searchLists = this
    $.get('/lists.json')
      .done(function(data) {
        searchLists.allLists = data
      })
  },
  components: {
    'single-list': SingleList
  }
}
