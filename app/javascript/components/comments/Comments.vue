<template>
  <div>
    <comment-form :signed-in="signedIn"
                  :commentable-type="commentableType"
                  :commentable-id="commentableId"
                  :parent-id="null"
                  type="new"
    ></comment-form>
    <comments-list :signed-in="signedIn"
                   :user-id="userId"
                   :comments="dataComments"
                   :commentable-type="commentableType"
                   :commentable-id="commentableId"
    ></comments-list>
  </div>
</template>

<script>
import CommentsList from './CommentsList.vue'
import CommentForm from './CommentForm.vue'
import merge from 'lodash-es/merge'

export default {
  name: 'comments',

  components: {
    CommentsList,
    CommentForm,
  },

  props: ['commentableType', 'commentableId', 'signedIn', 'userId', 'comments'],

  data() {
    return {
      dataComments: []
    }
  },

  created () {
    this.$eventHub.$on('new-comment', this.newComment)
    this.$eventHub.$on('reply-comment', this.newComment)
    this.$eventHub.$on('edit-comment', this.editComment)
    this.$eventHub.$on('vote-comment', this.editComment)
  },

  beforeMount () {
    this.dataComments = merge([], this.comments)
  },

  methods: {
    newComment (comment) {
      if (! comment.parent_id) {
        return this.dataComments.unshift(comment)
      } else {
        const parent = this.findComment(this.dataComments, comment.parent_id)
        if (parent) parent.nested_comments.unshift(comment)
      }
    },

    editComment (comment) {
      const found = this.findComment(this.dataComments, comment.id)
      if (found) {
        Object.assign(found, comment)
      } else {
        console.error('Could not find a comment', comment)
      }
    },

    findComment (comments, id) {
      let found = null

      comments.some(c => {
        if (c.id === id) {
          found = c
          return true
        }
        if (c.nested_comments.length) {
          found = this.findComment(c.nested_comments, id)
          if (found) return true
        }
      })

      return found
    },
  },

}
</script>
