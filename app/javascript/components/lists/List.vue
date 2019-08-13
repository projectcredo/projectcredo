<template>
  <div class="list-component">
    <div class="list-cover cropped-image">
      <div class="list-cover-img">
        <img :src="list.cover_url" v-if="list.cover_url" alt="Board cover">
      </div>
      <h1 class="list-cover-title">
        <div class="list-title-text">{{ list.name }}</div>
        <div class="list-title-star" v-if="currentUser">
          <i title="Pin / unpin the list" class="fa" :class="{'fa-star': list.pinned, 'fa-star-o': ! list.pinned}"
            v-if="! pinIsLoading" @click="togglePin"></i>
          <span class="spinner" v-if="pinIsLoading">
              <span class="double-bounce1"></span>
              <span class="double-bounce2"></span>
            </span>
        </div>
      </h1>
    </div>
    <div class="list-description">
      {{ list.description }}
    </div>
    <div class="list-tags">
      <a href="#" class="label label-tag" v-for="tag in list.tags" :key="tag.id"><span class="tag-wrap"><span class="tag-name">{{ tag.name }}</span> <span class="tag-count">{{ tag.taggings_count }}</span></span></a>
    </div>
    <div class="list-owner">
      <div class="list-owner-img">
        <a :href="list.owner.url"><img :src="list.owner.avatar_thumb" alt=""></a>
      </div>
      <div class="list-owner-descr">
        <a :href="list.owner.url"><strong>{{ list.owner.full_name }}</strong></a><span v-if="list.owner.about">, {{ list.owner.about }}</span>
      </div>
    </div>
    <div class="list-date">
      asked {{ list.created_at | date('M/D/YYYY') }}, updated {{ list.updated_at | date('M/D/YYYY') }}
    </div>
    <post-form @post-created="postCreated" :list="list" v-if="list.can_update"></post-form>

    <list-summary :summary="summaries[0]" :list="list"
      @summary-updated="summaryUpdated"
      @summary-created="summaryCreated"
      @select-paper="selectPaper"
    ></list-summary>

    <div class="list-sources">
      <div class="list-sources-title">Sources</div>
      <div class="list-sources-filters">
        <div class="lsf-sort dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">sort <span class="caret"></span></a>
          <ul class="dropdown-menu dropdown-menu-right">
            <li :class="{active: sortDir === 'desc'}"><a href="#" @click.prevent="sortDir = 'desc'">Latest</a></li>
            <li :class="{active: sortDir === 'asc'}"><a href="#" @click.prevent="sortDir = 'asc'">Oldest</a></li>
          </ul>
        </div>
        <div class="lsf-filters">
          <a class="active" href="#">all items</a> |
          <a href="#">research papers only</a>
        </div>
      </div>

      <ul class="list-posts">
        <list-post v-for="post in orderedPosts"
          :list="list"
          :post="post"
          :key="post.id"
          :currentUser="currentUser"
          @select-paper="selectPaper"
          @post-updated="postUpdated"
          @post-deleted="postDeleted"
        ></list-post>
      </ul>
    </div>

    <paper-modal :paper="selectedPaper" :list="list" :current-user="currentUser" :show="showPaperModal" @hide="showPaperModal = false"></paper-modal>
  </div>
</template>

<script>
import Vue from 'vue'
import uniq from 'lodash-es/uniq'
import axios from 'axios'
import SummaryContent from '../summaries/SummaryContent.vue'
import Vote from '../votes/Vote.vue'
import ListPost from '../posts/ListPost.vue'
import PaperModal from '../papers/PaperModal'
import PostForm from './PostForm'
import ListSummary from './ListSummary'
import Fuse from 'fuse.js'
import pick from 'lodash-es/pick'

export default {
  components: {
    SummaryContent,
    Vote,
    ListPost,
    PaperModal,
    PostForm,
    ListSummary,
  },

  props: ['list', 'currentUser'],

  data () {
    return {
      selectedPaper: {},
      showPaperModal: false,

      pinIsLoading: false,
      sortBy: 'created_at',
      sortDir: 'desc',
      posts: [],
      summaries: [],
    }
  },

  mounted () {
    $('[data-toggle="popover"]').popover({
      container: 'body',
      placement: 'auto top',
      html: true,
    })
    this.posts = this.list.posts.slice()
    this.summaries = this.list.summaries.slice()
  },

  computed: {
    displayedListDesc () {
      return this.$options.filters.truncate(this.list.description, 350, this.listDescTruncated)
    },

    orderedPosts () {
      return this.posts.slice().sort((a, b) => {
        if (this.sortDir === 'desc') return new Date(b[this.sortBy]) - new Date(a[this.sortBy])
        else return new Date(a[this.sortBy]) - new Date(b[this.sortBy])
      })
    },
  },

  methods: {

    selectPaper (paper) {
      this.selectedPaper = paper
      this.showPaperModal = true
    },

    togglePin () {
      this.pinIsLoading = true
      let request
      if (this.list.pinned) {
        request = axios.delete(`/pins/${this.list.slug}.json`, {id: this.list.slug})
      } else {
        request = axios.post('/pins.json', {id: this.list.slug})
      }
      request.then(() => {
        this.list.pins = this.list.pins + (this.list.pinned ? -1 : 1)
        this.list.pinned = ! this.list.pinned
        this.pinIsLoading = false
      })
    },

    postCreated (post) {
      this.posts.unshift(post)
    },

    postUpdated (post) {
      const idx = this.posts.findIndex(p => p.id === post.id)
      if (idx !== -1) Object.assign(this.posts[idx], post)
    },

    postDeleted (post) {
      const idx = this.posts.findIndex(p => p.id === post.id)
      if (idx !== -1) this.posts.splice(idx, 1)
    },

    summaryCreated (summary) {
      this.summaries.unshift(summary)
    },

    summaryUpdated (summary) {
      const idx = this.summaries.findIndex(s => s.id === summary.id)
      if (idx !== -1) Object.assign(this.summaries[idx], summary)
    },

  },
}
</script>
