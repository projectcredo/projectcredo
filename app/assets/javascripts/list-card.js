
// List Card Component for List Indexes
Vue.component("list-card", {
  props: ["list", "signedIn"],
  filters: {
    truncate(string, length) {
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
  template: `
    <div class="col-md-3 list-card">
      <div class="panel panel-default">
        <div class="panel-body">
          <a :href="list.owner" class="timestamp">
            {{list.owner}} updated {{list.updated_at}} ago
          </a>
          <div><a v-for="tag in list.tag_list" class="tag">
            {{tag}}
          </a></div>

          <div class="list-title"><a :href="list.link">{{list.name}}</a></div>

          <p class="list-body">{{list.description, 300 | truncate }}</p>

          <div class="list-footer">
            <a
              class="list-vote"
              v-bind:class="{'toggled': list.liked}"
              v-on:click="toggleLike(list)"
              remote="true"
            >
              {{list.likes}}
            </a>
            <a
              class="list-pin"
              v-bind:class="{'toggled': list.pinned}"
              v-on:click="togglePin(list)"
              remote="true"
            >
              {{list.pins}}
            </a>
            <span class="comment-count">
              {{list.comments_count}}
            </span>
          </div>
        </div>
      </div>
    </div>
  `
})