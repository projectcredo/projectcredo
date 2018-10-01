<template>
  <div>
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
</template>

<script>
import Vue from 'vue'
import uniq from 'lodash-es/uniq'
import ReferenceModal from '../references/ReferenceModal.vue'
import ReferenceList from '../references/ReferenceList.vue'
import SummaryContent from '../summaries/SummaryContent.vue'
import Vote from '../references/Vote.vue'
import Note from '../references/Note.vue'
import CrossrefSearch from '../references/CrossrefSearch.vue'
import AddByLocator from '../references/AddByLocator.vue'
import MiniBib from '../references/MiniBib.vue'

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
  },

  props: ['list', 'owner', 'signedIn', 'currentUser', 'summaries', 'userCanEdit', 'references', 'summaryAddPath'],

  data () {
    return {
      allReferences: [],
      referenceIndexInModal: 0,
      selectedRef: {},
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
        var citation = self.$options.filters.cite(r);
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