<template>
  <span>
    <span class="newlines">{{note.content, 250, truncateNote | truncate}}</span>
    <a class="action-link"
       v-if="note.content.length > 250"
       @click.stop="truncateNote = ! truncateNote"
    >
      {{ truncateNote ? 'see more' : 'see less' }}
    </a>
    <div class="note-details">
      {{ note.user }} · {{ note.time_ago }}
      <slot name="citation"></slot>
    </div>
  </span>
</template>

<script>
export default {
  props: ['note'],

  data () {
    return {
      truncateNote: true,
    }
  },
}
</script>