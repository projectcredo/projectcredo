<template>
  <div class="modal fade" id="referenceModal" tabindex="-1" role="dialog" aria-labelledby="referenceModal" :reference="selectedRef">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content" v-if="selectedRef.paper">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                  aria-hidden="true">&times;</span></button>

          <h4 class="modal-title">
            <vote :voteable="selectedRef" :signed-in="signedIn"></vote>
            {{selectedRef.paper.title}}
            <a class="modal-external-link" :href="selectedRef.paper.direct_link" target="_blank"></a>
          </h4>
          <mini-bib :r="selectedRef"></mini-bib>
          <div>
            <span v-if="selectedRef.paper.tag_list == 0 && editsAllowed">Add tags</span>
            <a class="tag" v-for="(tag,index) in selectedRef.paper.tag_list">
              {{tag}}
              <button class="tag-remove"
                      v-show="showTagForm"
                      @click="removeTag(index)"
              >
              </button>
            </a>
            <a class="edit-btn" v-if="editsAllowed" @click="showTagForm = !showTagForm"></a>
            <div v-show="showTagForm">
              <input class="form-control input-sm tag-form"
                     v-model="newTag"
                     placeholder="Hit enter to add a tag"
                     @keyup.enter="addTag"
              />
            </div>
          </div>
        </div>
        <div class="modal-body">
          <div class="modal-section">
            <div class="modal-section-header">Notes and Highlights</div>
            <div v-if="editsAllowed">
              <div class="form-group">
                <textarea rows="3"
                          v-model="selectedRef.note_form"
                          class='form-control comment-box'
                          placeholder='help summarize this paper, what are some key takeaways?'
                >
                </textarea>
              </div>
              <div class="form-btns form-group">
                <button class="submit-btn"
                        @click="submitNote"
                        v-show="selectedRef.note_form !=''"
                >
                  Submit
                </button>
              </div>
            </div>
            <div class="nothing-yet" v-if="selectedRef.notes.length == 0">No notes yet...</div>
            <div v-for="(note,index) in selectedRef.notes.slice(0,showAllNotes ? selectedRef.notes.length + 1 : 3)" class="note">
              <div v-if="!note.editNote">
                <note :note="note"></note>
              </div>
              <div v-else>
                <div class="form-group">
                  <textarea class="form-control" v-model="note.edit_form"></textarea>
                </div>
                <div class="form-btns">
                  <button class="submit-btn" @click="updateNote(note)">Submit</button>
                  <a class="cancel-link" @click="cancelEditNote(note)">Cancel</a>
                </div>
              </div>
              <vote :voteable="note" :signed-in="signedIn"></vote>
              <span v-if="currentUser == note.user"
                    class="action-link"
                    @click="note.editNote = !note.editNote"
              >
                edit
              </span>
              <span v-if="editsAllowed"
                    class="action-link"
                    @click="deleteNote(note,index)"
              >
                delete</span>
            </div>
            <a class="action-link"
               @click="showAllNotes = !showAllNotes"
               v-text="showAllNotes ? 'hide notes' : 'show all notes'"
               v-if="selectedRef.notes.length > 3"
            >
            </a>
          </div>
          <div class="modal-section">
            <div class="modal-section-header">
              Abstract
              <span v-if="hasAbstract"
                    data-toggle="tooltip"
                    data-placement="right"
                    :title="abstractImported ? 'this abstract was imported from a validated source' : 'this abstract was user generated and not validated'"
                    v-text="abstractImported ? ' - imported' : ' - user generated' "
              ></span>
              <a class="edit-btn"
                 data-toggle="tooltip"
                 data-placement="right"
                 v-if="selectedRef.paper.abstract_editable  && editsAllowed"
                 @click="editAbstract = !editAbstract"
                 :title="hasAbstract ? 'Edit this abstract' : 'Add an abstract'"
              ></a>
            </div>
            <div class="nothing-yet" v-if="!hasAbstract" v-show="!editAbstract">No abstract was imported...</div>
            <div v-if="editsAllowed" v-show="editAbstract">
              <div class="form-group">
                <textarea rows="10"
                          class="form-control"
                          placeholder="No abstract was imported.  Submitted abstracts will be labeled as user generated."
                          v-model="selectedRef.abstract_form"
                ></textarea>
              </div>
              <div class="form-btns">
                <button class="submit-btn" @click="submitAbstract(selectedRef)">Submit</button>
                <a class="cancel-link" @click="cancelAbstractForm">Cancel</a>
              </div>
            </div>
            <abstract v-if="hasAbstract" v-show="!editAbstract" :abstract="selectedRef.paper.abstract"></abstract>
          </div>
          <div class="modal-section">
            <div class="modal-section-header">Details</div>
            <ul class="list-unstyled">
              <li v-if="selectedRef.paper.doi != null">
                DOI:
                <a :href="'http://dx.doi.org/'+selectedRef.paper.doi" target="_blank">{{selectedRef.paper.doi}}</a>
              </li>
              <li v-if="selectedRef.paper.pubmed_id != null">
                Pubmed:
                <a :href="'https://www.ncbi.nlm.nih.gov/pubmed/'+selectedRef.paper.pubmed_id"
                   target="_blank">{{selectedRef.paper.pubmed_id}}</a>
              </li>
              <div v-if="selectedRef.paper.links.length > 0">Direct Links:</div>
              <li v-for="link in selectedRef.paper.links">
                <a :href="link.url" target="_blank" v-text="link.url"></a>
              </li>
            </ul>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-primary"
                  @click="selectReference(referenceIndexInModal - 1)"
                  v-show="referenceIndexInModal != 0"
          >Previous
          </button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button class="btn btn-primary"
                  @click="selectReference(referenceIndexInModal + 1)"
                  v-show="referenceIndexInModal != (refCount -1)"
          >Next
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from '../../services/axios'
import debounce from 'debounce-promise'
import Abstract from './Abstract.vue'
import Vote from '../votes/Vote.vue'
import MiniBib from './MiniBib.vue'
import Note from './Note.vue'

export default {

  components: {
    Abstract,
    Vote,
    MiniBib,
    Note,
  },

  props: [
    'signedIn',
    'currentUser',
    'editsAllowed',
    'selectedRef',
    'referenceIndexInModal',
    'refCount',
  ],

  data () {
    return {
      editAbstract: false,
      showTagForm: false,
      truncateAbstract: true,
      showAllNotes: false,
      newTag: ''
    }
  },

  watch: {
    selectedRef () {
      this.editAbstract = false
      this.showTagForm = false
    }
  },

  computed: {
    hasAbstract () {
      return this.selectedRef.paper.abstract != undefined;
    },
    showNoteSubmit () {
      return this.selectedRef.note_form != ''
    },
    abstractImported () {
      return ! this.selectedRef.paper.abstract_editable && this.hasAbstract
    }
  },

  methods: {
    selectReference (index) {
      this.$emit('select-ref', index)
    },
    cancelAbstractForm () {
      this.editAbstract = false
      this.selectedRef.abstract_form = this.selectedRef.abstract
    },
    submitAbstract (reference) {
      var self = this;
      var paper = reference.paper
      var params = {
        paper: {
          abstract: reference.abstract_form
        }
      };
      $.ajax({
        url: `/papers/${paper.id}.json`,
        type: 'PATCH',
        data: params
      })
        .done(function(){
          // self.hasAbstract = true
          self.editAbstract = false
          reference.paper.abstract = reference.abstract_form
        })
    },
    submitTags () {
      var tag_list = this.selectedRef.paper.tag_list
      if(this.selectedRef.paper.tag_list.length == 0){ tag_list =[""]}

      var params = {
        paper: {
          tag_list: tag_list
        }
      };
      $.ajax({
        url: `/papers/${this.selectedRef.paper.id}.json`,
        type: 'PATCH',
        data: params
      })
        .done(function(){
        })
    },
    addTag () {
      var self = this
      if(this.newTag != '') {
        var tags = this.newTag.split(',')
        tags.forEach(function(t){
          self.selectedRef.paper.tag_list.push(t.trim())
        })
        this.newTag = ''
        this.submitTags()
      }
    },
    removeTag (index){
      this.selectedRef.paper.tag_list.splice(index,1)
      this.submitTags()
    },
    submitNote () {
      var self = this
      var params = {
        comment: {
          content: this.selectedRef.note_form,
          commentable_type: 'Reference',
          commentable_id: this.selectedRef.id,
        }
      };
      $.ajax({
        url: "/comments.json",
        type: 'POST',
        data: params,
      })
        .done(function(newNote){
          self.selectedRef.note_form = ''
          newNote.voted = false
          newNote.votes = 0
          newNote.type = 'comment'
          newNote.vote_path = `/comments/${newNote.id}/vote`
          newNote.time_ago = 'now'
          newNote.user = self.currentUser
          newNote.edit_form = newNote.content
          newNote.editNote = false
          self.selectedRef.notes.unshift(newNote)
        })
    },
    deleteNote (note,index) {
      var self = this
      $.ajax({
        url: `/comments/${note.id}.json`,
        type: 'DELETE',
      })
        .done(function(res){
          self.selectedRef.notes.splice(index,1)
        })
    },
    cancelEditNote (note) {
      note.edit_form = note.content
      note.editNote = false
    },
    updateNote (note) {
      var params = {
        comment: {
          content: note.edit_form,
          commentable_type: 'Reference',
        }
      };
      $.ajax({
        url: `/comments/${note.id}.json`,
        type: 'PATCH',
        data: params,
      })
        .done(function(res){
          note.content = note.edit_form
          note.editNote = false
        })
    }
  }

}
</script>