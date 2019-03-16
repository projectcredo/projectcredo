<template>
  <span>
    <a :class="[{'toggled': this.voteable.voted}, 'vote', 'thumbs-up']"
       @click="toggleVote(voteable)"
       v-show="!isLoading"
    >
      {{ voteable.votes }}
    </a>
    <span class="spinner" v-show="isLoading">
      <span class="double-bounce1"></span>
      <span class="double-bounce2"></span>
    </span>
  </span>
</template>

<script>
export default {
  props: ['voteable', 'signedIn'],

  data () {
    return {
      isLoading: false
    }
  },

  methods: {

    vote (voteable) {
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
        .done(function () {
          voteable.voted = true
          voteable.votes = voteable.votes + 1
          self.isLoading = false
        });
    },

    unvote (voteable) {
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
        .done(function () {
          voteable.voted = false
          voteable.votes = voteable.votes - 1
          self.isLoading = false
        });
    },

    toggleVote (voteable) {
      if (!this.signedIn) {
        window.location.href = '/users/sign_in';
      } else if (!this.isLoading) {
        this.isLoading = true
        if (voteable.voted) {
          this.unvote(voteable)
        } else {
          this.vote(voteable)
        }
      }
    },
  },
}
</script>