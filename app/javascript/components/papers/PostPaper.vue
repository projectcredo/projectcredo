<template>
  <div class="lpar-paper">
    <div class="lparp-cover">
      <img :src="paper.cover_thumb" alt="">
    </div>
    <div class="lparp-details">
      <!--<div class="lparp-score"><div class="lparp-score-value" style="width: 97%;">Credo Score: 97%</div></div>-->
      <a class="lparp-title" href="#" @click.prevent="$emit('select-paper', paper)">{{ paper.title }}</a>
      <div class="lparp-source">{{ paper.publication }}</div>
      <div class="lparp-date-authors">
        {{ date }}
        <span v-if="paper.authors.length">- {{ paper.authors.map(a => a.full_name).join(', ') }}</span>
      </div>
      <div class="lparp-bookmarks">
        <bookmark :bookmarkable="paper" :type="'Paper'" :signed-in="!! currentUser"></bookmark>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment-mini'
import Bookmark from '../bookmarks/Bookmark'

export default {
  props: ['paper', 'currentUser'],

  components: {
    Bookmark
  },

  computed: {
    date () {
      return moment(this.paper.published_at).format('D/M/YYYY')
    },
  },
}
</script>
