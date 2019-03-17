<template>
  <div class="list-component">
    <div class="list-cover cropped-image">
      <div class="list-cover-img">
        <img :src="list.cover_url" v-if="list.cover_file_name" alt="Board cover">
      </div>
      <h1 class="list-cover-title">{{ list.name }}</h1>
    </div>
    <div class="list-description">
      {{ list.description }}
    </div>
    <div class="list-tags">
      <a href="#" class="label label-tag" v-for="tag in list.tags" :key="tag.id"><span class="tag-wrap"><span class="tag-name">{{ tag.name }}</span> <span class="tag-count">{{ tag.taggings_count }}</span></span></a>
    </div>
    <div class="list-owner">
      <div class="list-owner-img">
        <a :href="list.owner_short.url"><img :src="list.owner_short.avatar_thumb" alt=""></a>
      </div>
      <div class="list-owner-descr">
        <a :href="list.owner_short.url"><strong>{{ list.owner_short.full_name }}</strong></a><span v-if="list.owner_short.about">, {{ list.owner_short.about }}</span>
      </div>
    </div>
    <div class="list-date">
      asked {{ list.created_at | date('M/D/YYYY') }}, updated {{ list.updated_at | date('M/D/YYYY') }}
    </div>
    <div class="list-post-form">
      <textarea class="lpf-textarea" placeholder="What are you reading?"></textarea>
      <button class="btn btn-default">Post</button>
    </div>
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
          <ul class="dropdown-menu">
            <li class="active"><a href="#">Latest</a></li>
            <li><a href="#">Sort by</a></li>
          </ul>
        </div>
        <div class="lsf-filters">
          <a class="active" href="#">all items</a> |
          <a href="#">research papers only</a>
        </div>
      </div>

      <ul class="list-posts">
        <list-post v-for="post in list.posts" :post="post" :key="post.id" :global="global" @select-paper="selectPaper"></list-post>
      </ul>
    </div>

    <br>
    <br>
    <hr>
    Old:
    <div style="width: 100%; overflow-x: scroll;">
      <div class="list-section">
        <div class="list-section-h1">
          <div class="list-title">{{ list.name }}</div>

          <div class="list-details">
            <span v-if="list.access === 'contributors'" data-toggle="tooltip" data-placement="right" title="Only contibutors may edit or add references to this board"> 🔒 </span>
            <span v-else data-toggle="tooltip" data-placement="right" title="Anyone may edit or add references to this board"> 🌎 </span>
            curated by <a :href="'/' + owner">{{ owner }}</a>

            <span v-if="list.others.length">
              and
              <span tabindex="0"
                    class="action-link"
                    data-container="body"
                    data-toggle="popover"
                    data-placement="top"
                    data-html="true"
                    :data-content="list.others.map(u => `<a href='/${u.username}'>${u.username}</a>`).join(', ')"
                    data-trigger="focus">
                {{ list.others.length | pluralize('other') }}
              </span>
            </span>
            on {{ list.created_at | date('MMMM Do, YYYY') }}
          </div>
          <div class="list-total-bookmarks">Total Bookmarks: {{ list.total_bookmarks }}</div>
          <div v-if="list.tags.length" class="list-tags">
            <a class="tag" v-for="tag in list.tags">{{ tag.name }}</a>
          </div>
          <div v-html="displayedListDesc"></div>
          <a class="action-link" v-if="list.description.length > 350" @click.stop="listDescTruncated = !listDescTruncated">
            {{ listDescTruncated ? 'see more' : 'see less' }}
          </a>
        </div>
      </div>

      <div class="row list-filter list-section">
        <div class="col-xs-12">
          <input class="pull-right form-control" v-model="filterKey" placeholder="Search this board for...">
        </div>
      </div>

      <reference-modal :signed-in="signedIn"
                      :current-user="currentUser"
                      :edits-allowed="editsAllowed"
                      :selected-ref="selectedRef"
                      :reference-index-in-modal="referenceIndexInModal"
                      :ref-count="filteredData.length"
                      v-on:select-ref="selectReference($event)"
      ></reference-modal>

      <div class="list-section">
        <div class="list-section-h2">Summaries</div>
        <div class="nothing-yet" v-if="editsAllowed">
          <a :href="summaryAddPath">Add a summary</a> to help guide readers through the evidence
        </div>
        <div class="nothing-yet" v-if="summaries.length == 0 && ! editsAllowed">
          No summaries written yet.
        </div>
        <table class="summaries-table">
          <tbody>
          <tr v-for="s in summaries.slice(0, summariesShown)" class="summary-row">
            <td class="evidence-rating">
              <div class="icon" :class="s.evidence_rating"></div>
              <div>{{ s.evidence_rating }}</div>
            </td>
            <td class="summary-content">
              <summary-content :summary="s"
                      :cited-refs='citedRefs(s.content)'
                      v-on:select-ref="selectReference($event)"
              ></summary-content>
              <div class="summary-details">
                <vote :voteable="s" :signed-in="signedIn"></vote>
                · {{s.user}} · {{s.time_ago}}
                <span v-if="currentUser == s.user || editsAllowed">
                · <a class="edit-link" :href="s.edit_path">edit</a>
                </span>
              </div>
            </td>
          </tr>
          <tr class="summary-row" v-if="summaries.length > 3">
            <td class="text-center">
              <a class="action-link" @click.stop="summariesShown = (summariesShown == 3 ? 10 : 3)">
                {{ summariesShown == 3 ? 'see more' : 'see less' }}
              </a>
            </td>
          </tr>
          </tbody>
        </table>
      </div>

      <div class="list-section">
        <div class="list-section-h2">Notes and Highlights</div>
        <div class="nothing-yet" v-if="notes.length == 0">No notes yet...</div>
        <table class="notes-table">
          <tbody>
          <tr v-for="n in notes.slice(0, notesShown)" class="note-row">
            <td class="note-vote">
              <vote :voteable="n.note" :signed-in="signedIn"></vote>
            </td>
            <td class="note-content">
              <note :note="n.note" class="note">
                <span class="text-capitalize" slot="citation">
                  ·
                  <span @click="selectReference(n.rIndex)"
                        class='action-link-soft'
                  >{{ n.citation }}</span>
                </span>
              </note>
            </td>
          </tr>
          </tbody>
        </table>
        <a v-if="notes.length > 3" class="action-link" @click.stop="notesShown = (notesShown === 3 ? 10 : 3)">
          {{ notesShown === 3 ? 'see more' : 'see less' }}
        </a>
      </div>
      <div class="list-section">
        <div class="list-section-h2">
          <span v-if="allReferences.length">{{ allReferences.length }} Papers</span>
          <span v-else>No Papers Added</span>
        </div>
        <div class="quick-add">
          <a class="quick-add-toggle" @click="showQuickAdd = !showQuickAdd">
            Quick Add Paper
          </a>
          <div v-show="showQuickAdd">
            <crossref-search :edits-allowed="editsAllowed" :list="list"></crossref-search>
            <add-by-locator :user-can-edit="userCanEdit" :list="list"></add-by-locator>
          </div>
        </div>
        <reference-list
                :signed-in="signedIn"
                :filtered-data="filteredData"
                v-model="filterKey"
                :sort-key="sortKey"
                :sort-orders="sortOrders"
                :edits-allowed="editsAllowed"
                @sort="sortBy($event)"
                @filter="addToFilter($event)"
                @select-ref="selectReference($event)"
                @remove-ref="deleteReference($event)"
        ></reference-list>
      </div>
    </div>
    <paper-modal :paper="selectedPaper" :global="global" :show="showPaperModal" @hide="showPaperModal = false"></paper-modal>
  </div>
</template>

<script>
import Vue from 'vue'
import uniq from 'lodash-es/uniq'
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
  },

  props: ['list', 'owner', 'signedIn', 'currentUser', 'summaries', 'userCanEdit', 'references', 'summaryAddPath'],

  data () {
    return {
      allReferences: [],
      referenceIndexInModal: 0,
      selectedRef: {},

      selectedPaper: {},
      showPaperModal: false,

      filterKey: '',
      sortKey: '',
      sortOrders: {'age': 1, 'votes': -1},
      notesShown: 3,
      summariesShown: 3,
      listDescTruncated: true,
      showQuickAdd: false,
    }
  },

  beforeMount () {
    this.allReferences = this.references
  },

  mounted () {
    this.allReferences.forEach(function (reference) {
      Vue.set(reference, 'abstract_form', reference.paper.abstract)
      Vue.set(reference, 'note_form', '')
      reference.notes.forEach(function (note) {
        Vue.set(note, 'editNote', false)
        Vue.set(note, 'edit_form', note.content)
      })
    })

    $('[data-toggle="popover"]').popover({
      container: 'body',
      placement: 'auto top',
      html: true,
    });
  },

  computed: {

    global () {
      return pick(this, ['signedIn', 'userCanEdit', 'editsAllowed']);
    },

    displayedListDesc () {
      return this.$options.filters.truncate(this.list.description, 350, this.listDescTruncated)
    },

    editsAllowed () {
      return this.signedIn && this.userCanEdit
    },

    filteredData () {
      var sortKey = this.sortKey
      var filterKey = this.filterKey
      var order = this.sortOrders[sortKey]
      var data = this.allReferences
      var fuseOptions = {
        tokenize: true,
        shouldSort: true,
        threshold: 0.4,
        maxPatternLength: 32,
        minMatchCharLength: 1,
        keys: [
          'paper.title',
          'paper.authors.full_name',
          'paper.tag_list',
          'paper.abstract',
        ],
      };
      if (filterKey) {
        var fuse = new Fuse(data, fuseOptions);
        data = fuse.search(this.filterKey);
      }
      if (sortKey) {
        data = data.slice().sort(function (a, b) {
          if (sortKey == 'age') {
            a = a.paper['published_at']
            b = b.paper['published_at']
          } else {
            a = a[sortKey]
            b = b[sortKey]
          }
          return (a === b ? 0 : a > b ? 1 : -1) * order
        })
      }
      return data
    },

    notes () {
      var self = this
      var notes = this.filteredData.map(function (r, index) {
        var citation = self.$options.filters.cite(r.paper);
        var notes = r.notes.map(function (n) {
          return {'note': n, 'citation': citation, 'rIndex': index}
        })
        return notes
      });
      notes = [].concat.apply([], notes)
      notes = notes.sort(function (a, b) {
        if (b.note.votes < a.note.votes) return -1;
        if (b.note.votes > a.note.votes) return 1;
        if (b.note.created_at < a.note.created_at) return -1;
        if (b.note.created_at > a.note.created_at) return 1;
        return 0;
      })
      return notes
    }
  },

  methods: {

    selectPaper (paper) {
      this.selectedPaper = paper
      this.showPaperModal = true
    },

    selectReference (index) {
      this.referenceIndexInModal = index;
      this.selectedRef = this.filteredData[index];
      $('#referenceModal').modal('show')
    },

    citedRefs (content) {
      var data = this.filteredData
      var myRegexp = /(?:\[r-cite\sid=(\d+)\])/mg;
      var match = myRegexp.exec(content);
      var refIds = [];
      while (match !== null) {
        refIds.push(match[1])
        match = myRegexp.exec(content);
      }
      refIds = uniq(refIds)

      var citedRefs = refIds.map(function (id) {
        return data.filter(function (r, index) {
          r.index = index
          return r.id == id;
        })
      })

      return [].concat.apply([], citedRefs)
    },

    addToFilter (add) {
      if (!this.filterKey.match(add)) {
        if (this.filterKey) {
          this.filterKey += ' ' + add
        } else {
          this.filterKey = add
        }
      }
    },

    sortBy (key) {
      this.sortKey = key;
      this.sortOrders[key] = this.sortOrders[key] * -1;
    },

    deleteReference (index) {
      if (confirm('Are you sure you want to remove this paper?')) {
        const id = this.filteredData[index].id
        $.ajax({
          url: `/references/${id}.json`,
          type: 'DELETE',
          data: {
            reference: {id},
          },
        })
          .done(() => {
            this.allReferences = this.allReferences.filter(r => r.id !== id)
          })
      }
    },
  },
}
</script>