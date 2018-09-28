<template>
  <div class="comment" :id="'comment-' + comment.id">
    <p class="text-muted">
      <span v-if="comment.created_at == comment.updated_at">Added by </span>
      <span v-else>Updated by </span>
      <strong><a :href="comment.user.url">{{ comment.user.username }}</a></strong>
      on {{ formatDate(comment.updated_at) }}
    </p>
    <comment-form :signed-in="signedIn"
                  :commentable-type="commentableType"
                  :commentable-id="commentableId"
                  :parent-id="comment.id"
                  :comment="comment"
                  type="edit"
                  @cancel="showEdit = false"
                  v-if="showEdit"
    ></comment-form>
    <span class="content" v-else><p>{{ comment.content }}</p></span>

    <ul v-if="signedIn">
      <li>
        <upvote :comment="comment"></upvote>
      </li>
      <li><a class="toggle-reply active-link btn-xs" @click.prevent="showReply = ! showReply" href="#">reply</a></li>
      <li v-if="comment.user_id === userId"><a class="active-link btn-xs" data-remote="true" @click.prevent="showEdit = ! showEdit">edit</a></li>
      <li v-if="comment.user_id === userId"><a class="text-danger small" data-remote="true" rel="nofollow" data-method="delete" href="/comments/55">delete</a></li>
      <li></li>
    </ul>

    <comment-form :signed-in="signedIn"
                  :commentable-type="commentableType"
                  :commentable-id="commentableId"
                  :parent-id="comment.id"
                  type="reply"
                  @cancel="showReply = false"
                  v-if="showReply"
    ></comment-form>

    <comments-list :signed-in="signedIn" :user-id="userId" :comments="comment.nested_comments"></comments-list>
  </div>
</template>

<script>
import moment from 'moment-mini'
import CommentForm from './CommentForm.vue'
import Upvote from './Upvote.vue'

export default {
  name: 'comment',

  props: ['commentableType', 'commentableId', 'signedIn', 'userId', 'comment'],

  components: {
    CommentForm,
    Upvote,
  },

  data () {
    return {
      showReply: false,
      showEdit: false,
    }
  },

  beforeCreate () {
    // https://vuejs.org/v2/guide/components-edge-cases.html#Circular-References-Between-Components
    this.$options.components.CommentsList = require('./CommentsList.vue').default
  },

  created () {
    this.$eventHub.$on('reply-comment', () => this.showReply = false)
  },

  methods: {
    formatDate (date) {
      return moment(date).format('MMMM Do YYYY hh:mm:ss')
    },
  },

}
</script>
