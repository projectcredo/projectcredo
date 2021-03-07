<template>
  <div>
    <div class="list-card">
      <div class="panel panel-default">
        <div class="panel-body">
          <div class="list-title">
            <a :href="list.link">{{ list.name }}</a>
            <a :href="list.owner" class="timestamp">created by {{ list.owner }}</a>
          </div>
          <div>
            {{ list.description, 300 | truncate }}
          </div>
          <div v-if="list.last_activities && list.last_activities.length">
            <div class="list-activity-row" v-for="(activity, index) in list.last_activities"
              v-show="showMore ? true : index < 3" :key="activity.id">
              <div class="col-md-1" :class="activity.type"></div>
              <div class="col-md-11">
                <a :href="activity.addable_href" v-if="activity.type === 'added'">{{ activity.addable, 150 | truncate }}</a>
                <span v-if="activity.type == 'commented'">"{{ activity.addable, 150 | truncate }}"</span>
                <span v-if="activity.type == 'created'">This board was created!</span>
                <div class="timestamp">
                  {{ activity.user }}
                  {{ activity.type }}
                  {{ activity.updated_at }} ago
                </div>
              </div>
            </div>
            <a
              v-if="list.last_activities.length > 3"
              v-text="showMore ? 'see less...' : 'see more..'"
              @click="showMore = ! showMore"
            >
            </a>
          </div>
          <div class="list-footer">
            <a class="list-vote" :class="{'toggled': list.liked}" @click="toggleLike(list)" v-show="! likeIsLoading">
              {{ list.likes }}
            </a>
            <span class="spinner" v-show="likeIsLoading">
              <span class="double-bounce1"></span>
              <span class="double-bounce2"></span>
            </span>
            <a class="list-pin" :class="{'toggled': list.pinned}" @click="togglePin(list)" v-show="! pinIsLoading">
              {{ list.pins }}
            </a>
            <span class="spinner" v-show="pinIsLoading">
              <span class="double-bounce1"></span>
              <span class="double-bounce2"></span>
            </span>
            <span class="comment-count">{{ list.comments_count }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: ['list', 'signedIn'],

  data () {
    return {
      likeIsLoading: false,
      pinIsLoading: false,
      showMore: false
    }
  },

  methods: {
    likeList (list) {
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

    unlikeList (list) {
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

    toggleLike (list) {
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

    pinList (list) {
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

    unpinList (list) {
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

    togglePin (list) {
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
}
</script>
