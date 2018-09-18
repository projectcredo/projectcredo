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
    //
  },
}
</script>
