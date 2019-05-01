<template>
  <div class="list-component">
    <div class="list-cover cropped-image">
      <div class="list-cover-img">
        <img :src="list.cover_url" v-if="list.cover_file_name" alt="Board cover">
      </div>
      <h1 class="list-cover-title">
        <div class="list-title-text">{{ list.name }}</div>
        <div class="list-title-star">
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
    <post-form @post-created="postCreated" :list="list" v-if="userCanEdit"></post-form>
    <div class="list-summary">
      <div class="list-summary-title">Summary</div>
      <div class="list-summary-body" v-if="list.summaries.length">
        <summary-content :summary="list.summaries[0]" :list="list" @select-paper="selectPaper"></summary-content>
      </div>
      <div class="list-summary-body" v-else>No summaries written yet.</div>
    </div>

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
          :post="post"
          :key="post.id"
          :global="global"
          @select-paper="selectPaper"
          @post-updated="postUpdated"
          @post-deleted="postDeleted"
        ></list-post>
      </ul>
    </div>

    <paper-modal :paper="selectedPaper" :list="list" :global="global" :show="showPaperModal" @hide="showPaperModal = false"></paper-modal>
  </div>
</template>

<script>
import Vue from 'vue'
import uniq from 'lodash-es/uniq'
import axios from 'axios'
import ReferenceModal from '../references/ReferenceModal.vue'
import ReferenceList from '../references/ReferenceList.vue'
import SummaryContent from '../summaries/SummaryContent.vue'
import Vote from '../votes/Vote.vue'
import Note from '../references/Note.vue'
import CrossrefSearch from '../references/CrossrefSearch.vue'
import AddByLocator from '../references/AddByLocator.vue'
import MiniBib from '../references/MiniBib.vue'
import ListPost from '../posts/ListPost.vue'
import PaperModal from '../papers/PaperModal'
import PostForm from './PostForm'
import Fuse from 'fuse.js'
import pick from 'lodash-es/pick'

export default {
  components: {
    ReferenceModal,
    ReferenceList,
    SummaryContent,
    Vote,
    Note,
    CrossrefSearch,
    AddByLocator,
    MiniBib,
    ListPost,
    PaperModal,
    PostForm,
  },

  props: ['list', 'owner', 'signedIn', 'currentUser', 'currentUserId', 'userCanEdit', 'summaryAddPath'],

  data () {
    return {
      selectedPaper: {},
      showPaperModal: false,

      pinIsLoading: false,
      sortBy: 'created_at',
      sortDir: 'desc',
      posts: [],
    }
  },

  mounted () {
    $('[data-toggle="popover"]').popover({
      container: 'body',
      placement: 'auto top',
      html: true,
    })
    this.posts = this.list.posts.slice()
  },

  computed: {

    global () {
      return pick(this, ['signedIn', 'userCanEdit', 'editsAllowed', 'currentUser', 'currentUserId']);
    },

    displayedListDesc () {
      return this.$options.filters.truncate(this.list.description, 350, this.listDescTruncated)
    },

    editsAllowed () {
      return this.signedIn && this.userCanEdit
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

  },
}
</script>
