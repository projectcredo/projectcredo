<template>
  <span>
    <span class="newlines">{{ comment.content, 250, truncateComment | truncate }}</span>
    <a class="action-link" v-if="comment.content.length > 250" @click.stop="truncateComment = ! truncateComment">
      {{ truncateComment ? 'see more' : 'see less' }}
    </a>
    <div class="note-details">
      {{ comment.user.username }} · {{ timeAgo }}
      <slot name="citation"></slot>
    </div>
  </span>
</template>

<script>
import moment from 'moment-mini'

export default {
  props: ['comment'],

  data () {
    return {
      truncateComment: true,
    }
  },

  computed: {
    timeAgo () {
      return moment(this.comment.created_at).fromNow()
    },
  },
}
</script>
