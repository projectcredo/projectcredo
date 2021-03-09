<template>
  <div class="comments" :class="commentableType">
    <comment class="comment"
             :key="comment.id"
             v-for="comment in comments"
             :comment="comment"
             :signed-in="signedIn"
             :user-id="userId"
             :commentable-type="commentableType"
             :commentable-id="commentableId"
             @deleted="() => onDeleted(comment)"
    ></comment>
  </div>
</template>

<script>
import Comment from './Comment.vue'

export default {
  name: 'comments-list',

  components: {
    Comment,
  },

  props: ['commentableType', 'commentableId', 'signedIn', 'userId', 'comments'],

  methods: {
    onDeleted (comment) {
      const idx = this.comments.findIndex(c => c.id === comment.id)
      if (idx !== -1) {
        this.comments.splice(idx, 1)
      }
    }
  },
}
</script>
