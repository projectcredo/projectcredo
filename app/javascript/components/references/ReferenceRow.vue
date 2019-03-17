<template>
  <tbody>
  <tr>
    <td>
      <bookmark :bookmarkable="r.paper" :signed-in="signedIn"></bookmark>
    </td>
    <td align="center">
      <b v-if="r.paper.published_at">{{ r.paper.published_at | age }}</b>
    </td>
    <td>
      <a href="#" @click.prevent="selectReference(index)">
        {{ r.paper.title }}
      </a>
      <mini-bib :r="r"></mini-bib>
    </td>
    <td>
      <a href="#" class="hidden-remove" v-if="showRemove" @click.prevent="removeReference(index)"></a>
    </td>
    <td>
      <a class="show-details"
         :class="{'toggled': showPaperDetails}"
         v-if="hasPaperDetails"
         @click="showPaperDetails = !showPaperDetails"
      ></a>
    </td>
  </tr>

  <tr v-if="showPaperDetails" class="ref-details">
    <td colspan="4">
      <div class="section" v-if="r.paper.tag_list.length > 0">
        <a class="tag" v-for="tag in r.paper.tag_list" v-text="tag" @click="filter(tag)"></a>
      </div>
      <div v-if="r.notes.length > 0">
        <div class="header">Notes and Highlights</div>
        <div v-for="note in r.notes.slice(0,3)" class="note">
          <vote :voteable="note" :signed-in="signedIn"></vote>
          <note :note="note"></note>
        </div>
      </div>
      <div v-if="r.paper.abstract != null">
        <span class="header">Abstract</span>
        <abstract :abstract="r.paper.abstract"></abstract>
      </div>
    </td>
  </tr>
  </tbody>
</template>

<script>
import axios from '../../services/axios'
import debounce from 'debounce-promise'
import Vote from '../votes/Vote.vue'
import Bookmark from '../bookmarks/Bookmark.vue'
import MiniBib from './MiniBib.vue'
import Note from './Note.vue'
import Abstract from './Abstract.vue'

export default {

  components: {
    Vote,
    Bookmark,
    MiniBib,
    Note,
    Abstract,
  },

  props: ['r', 'index', 'signedIn', 'editsAllowed', 'currentUsername'],

  data () {
    return {
      recommendIsLoading: false,
      hoverPaperDetails: false,
      showPaperDetails: false,
      truncateAbstract: true
    }
  },

  computed: {
    hasPaperDetails () {
      return this.r.notes.length > 0 || this.r.paper.tag_list.length > 0 || this.r.paper.abstract != null
    },
    showRemove () {
      return this.editsAllowed || this.r.added_by == this.currentUsername
    },
  },

  methods: {
    filter (add) {
      this.$parent.$emit('filter', add)
    },
    selectReference (index) {
      this.$parent.$emit('select-ref', index)
    },
    removeReference (index) {
      this.$parent.$emit('remove-ref', index)
    },
  },
}
</script>