<template>
  <tbody>
  <tr>
    <td>
      <vote :voteable="r" :signed-in="signedIn"></vote>
    </td>
    <td align="center">
      <b v-if="r.paper.published_at">{{ r.paper.published_at | age }}</b>
    </td>
    <td>
      <a data-toggle="modal"
         data-target="#referenceModal"
         @click="selectReference(index)"
      >
        {{r.paper.title}}
      </a>
      <mini-bib :r="r"></mini-bib>
    </td>
    <td>
      <a class="hidden-remove"
         v-if="showRemove"
         @click="removeReference(index)"
      ></a>
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

export default {

  props: ['r', 'index', 'signedIn', 'editsAllowed', 'currentUsername'],

  data: function () {
    return {
      recommendIsLoading: false,
      hoverPaperDetails: false,
      showPaperDetails: false,
      truncateAbstract: true
    }
  },

  computed: {
    hasPaperDetails: function () {
      return this.r.notes.length > 0 || this.r.paper.tag_list.length > 0 || this.r.paper.abstract != null
    },
    showRemove: function () {
      return this.editsAllowed || this.r.added_by == this.currentUsername
    }
  },

  methods: {
    filter: function (add) {
      this.$parent.$emit('filter', add)
    },
    selectReference: function (index) {
      this.$parent.$emit('select-ref', index)
    },
    removeReference: function (index) {
      this.$parent.$emit('remove-ref', index)
    }
  },

}
</script>