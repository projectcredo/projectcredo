<template>
  <div class="like-form">
    <button name="button" class="comment-vote" :class="{clicked: comment.voted}" @click.prevent="submit">&nbsp;{{ comment.cached_votes_up }}</button>
  </div>
</template>

<script>
import axios from '../../services/axios'

export default {
  name: 'upvote',

  props: ['comment'],

  methods: {
    submit () {
      const url = `/comments/${this.comment.id}/vote`
      let request

      if (this.comment.voted) {
        request = axios.delete(url, {data: {id: this.comment.id}})
      } else {
        request = axios.post(url, {id: this.comment.id})
      }

      request.then(response => {
          this.$eventHub.$emit('vote-comment', Object.assign({}, response.data))
        })
        .catch((e) => (console.error(e)))
    },
  },

}
</script>
