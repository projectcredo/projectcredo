<template>
  <div class="comments" :class="commentableType">
    <comment class="comment" :key="comment.id" v-for="comment in comments" :comment="comment"></comment>
  </div>
</template>

<script>
import Comment from './Comment.vue'

export default {
  name: 'comments-list',

  components: {
    Comment,
  },

  props: ['commentableType', 'signedIn', 'userId', 'comments'],

  methods: {
    
  },
}
</script>
