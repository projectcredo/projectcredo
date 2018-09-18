<template>
  <div>
    <comment-form :signed-in="signedIn"
                  :commentable-type="commentableType"
                  :commentable-id="commentableId"
                  :parent-id="null"
    ></comment-form>
    <comments-list :signed-in="signedIn"
                   :user-id="userId"
                   :comments="dataComments"
                   :commentable-type="commentableType"
                   :commentable-id="commentableId"
    ></comments-list>
    <p><br></p>
    <p>Commnets orig:</p>
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
  },

  beforeMount () {
    this.dataComments = merge([], this.comments)
  },

  methods: {
    newComment (comment) {
      if (! comment.parent_id) {
        return this.dataComments.unshift(comment)
      } else {
        const parent = this.findParent(this.dataComments, comment.parent_id)
        if (parent) parent.nested_comments.unshift(comment)
      }
    },

    findParent (comments, id) {
      let found = null

      comments.some(c => {
        if (c.id === id) {
          found = c
          return true
        }
        if (c.nested_comments.length) {
          found = this.findParent(c.nested_comments, id)
          if (found) return true
        }
      })

      return found
    },
  },

}
</script>
