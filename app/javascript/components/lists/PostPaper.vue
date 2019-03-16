<template>
  <div class="lpar-paper">
    <div class="lparp-cover">
      <img :src="paper.cover_thumb" alt="">
    </div>
    <div class="lparp-details">
      <div class="lparp-score"><div class="lparp-score-value" style="width: 97%;">Credo Score: 97%</div></div>
      <a class="lparp-title" href="#" @click.prevent="showModal = true">{{ paper.title }}</a>
      <div class="lparp-source">{{ paper.publication }}</div>
      <div class="lparp-date-authors">
        {{ date }}
        <span v-if="paper.authors.length">- {{ paper.authors.map(a => a.title).join(', ') }}</span>
      </div>
      <div class="lparp-bookmarks"><i class="fa fa-bookmark-o"></i> bookmarked by {{ paper.bookmarks_count }} people</div>
    </div>
    <paper-modal :paper="paper" :global="global" :show="showModal" @hide="showModal = false"></paper-modal>
  </div>
</template>

<script>
import moment from 'moment-mini'
import PaperModal from '../papers/PaperModal'

export default {
  props: ['paper', 'global'],

  components: {
    PaperModal,
  },

  data() {
    return {
      showModal: false,
    }
  },

  computed: {
    date () {
      return moment(this.paper.created_at).format('D/M/YYYY')
    },
  },
}
</script>
