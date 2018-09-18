<template>
  <div class="comment-reply">
    <div v-if="signedIn" class="comment-form">
      <div class="form-group">
        <textarea class="form-control comment-box" v-model="content" placeholder="Write a reply..." :disabled="loading"></textarea>
      </div>
      <div class="form-group">
        <input type="submit" value="Submit" class="btn btn-primary btn-xs" @click.prevent="submit" :disabled="loading">
      </div>
    </div>
    <h4 v-else>
      <a href="/users/sign_in">Sign in</a> or <a href="/users/sign_up">Sign up</a> to comment
    </h4>
  </div>
</template>

<script>
import moment from 'moment-mini'
import axios from '../../services/axios'

export default {
  name: 'comment-form',

  props: ['commentableType', 'commentableId', 'parentId', 'signedIn'],

  data () {
    return {
      loading: false,
      content: '',
      errors: {},
    }
  },

  methods: {
    submit () {
      this.loading = true

      axios.post('/comments', {
        comment: {
          commentable_type: this.commentableType,
          commentable_id: this.commentableId,
          parent_id: this.parentId,
          content: this.content,
        },
      })
        .then(response => {
          this.$eventHub.$emit('new-comment', response.data)
          this.content = ''
        })
        .catch((e) => (console.error(e)))
        .then(response => (this.loading = false))
    },
  },

}
</script>
