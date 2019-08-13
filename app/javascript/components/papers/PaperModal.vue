<template>
  <modal :value="show" @input="$emit('hide')" ref="modal" size="lg">
    <div slot="title" v-if="paper.id">
      <h4 class="modal-title">
        <vote :voteable="paper" :signed-in="!! currentUser"></vote>
        {{ paper.title }}
        <a class="modal-external-link" :href="paper.direct_link" target="_blank"></a>
      </h4>
      <mini-bib :paper="paper"></mini-bib>
      <div>
        <span v-if="paper.tags == 0 && list.can_update">Add tags</span>
        <a class="tag" v-for="(tag, index) in paper.tags" :key="tag.id">
          {{ tag.name }}
          <button class="tag-remove" v-show="showTagForm" @click="removeTag(index)"></button>
        </a>
        <a class="edit-btn" v-if="list.can_update" @click="showTagForm = ! showTagForm"></a>
        <div v-show="showTagForm">
          <input class="form-control input-sm tag-form"
                  v-model="newTag"
                  placeholder="Hit enter to add a tag"
                  @keyup.enter="addTag"
          />
        </div>
      </div>
    </div>

    <div v-if="paper.id">
      <div class="modal-section">
        <div class="modal-section-header">Notes and Highlights</div>
        <div v-if="list.can_update">
          <div class="form-group">
            <textarea rows="3" v-model="commentField" class="form-control comment-box"
                      placeholder="help summarize this paper, what are some key takeaways?">
            </textarea>
          </div>
          <div class="form-btns form-group">
            <button class="submit-btn" @click="submitComment" v-show="commentField !== ''" :disabled="submittingComment">Submit</button>
          </div>
        </div>
        <div class="nothing-yet" v-if="listComments.length === 0">No notes yet...</div>
        <div :key="comment.id" v-for="comment in listComments.slice(0, showAllComments ? paper.comments.length + 1 : 3)" class="note">
          <div v-if="editCommentId === comment.id">
            <div class="form-group">
              <textarea class="form-control" v-model="editCommentField" :readonly="submittingEditComment"></textarea>
            </div>
            <div class="form-btns">
              <button class="submit-btn" @click.prevent="updateComment" :disabled="submittingEditComment">Submit</button>
              <a href="#" class="cancel-link" @click.prevent="cancelEditComment">Cancel</a>
            </div>
          </div>
          <div v-else>
            <comment :comment="comment"></comment>
          </div>
          <!-- <vote :voteable="note" :signed-in="signedIn"></vote> -->
          <a href="#" v-if="currentUser && currentUser.id === comment.user_id" class="action-link" @click.prevent="editComment(comment)">
            edit
          </a>
          <a href="#" v-if="list.can_update" class="action-link" @click.prevent="deleteComment(comment)" :disabled="deletingComment">delete</a>
        </div>
        <a class="action-link"
            @click="showAllComments = ! showAllComments"
            v-if="listComments.length > 3">{{ showAllComments ? 'hide notes' : 'show all notes' }}</a>
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
          <a href="#" class="edit-btn"
              data-toggle="tooltip"
              data-placement="right"
              v-if="paper.abstract_editable  && list.can_update"
              @click.prevent="editAbstract"
              :title="hasAbstract ? 'Edit this abstract' : 'Add an abstract'"
          ></a>
        </div>
        <div class="nothing-yet" v-if="! hasAbstract" v-show="! showEditAbstract">No abstract was imported...</div>
        <div v-if="list.can_update" v-show="showEditAbstract">
          <div class="form-group">
            <textarea rows="10"
                      class="form-control"
                      placeholder="No abstract was imported.  Submitted abstracts will be labeled as user generated."
                      v-model="abstractField"
                      :disabled="submittingAbstract"
            ></textarea>
          </div>
          <div class="form-btns">
            <button class="submit-btn" @click="submitAbstract" :disabled="submittingAbstract">Submit</button>
            <a class="cancel-link" @click="cancelAbstractForm">Cancel</a>
          </div>
        </div>
        <abstract v-if="hasAbstract" v-show="! showEditAbstract" :abstract="paper.abstract"></abstract>
      </div>

      <div class="modal-section">
        <div class="modal-section-header">Details</div>
        <ul class="list-unstyled">
          <li v-if="paper.doi != null">
            DOI: <a :href="'http://dx.doi.org/'+paper.doi" target="_blank">{{ paper.doi }}</a>
          </li>
          <li v-if="paper.pubmed_id != null">
            Pubmed:
            <a :href="'https://www.ncbi.nlm.nih.gov/pubmed/' + paper.pubmed_id" target="_blank">{{ paper.pubmed_id }}</a>
          </li>
          <div v-if="paper.links && paper.links.length > 0">Direct Links:</div>
          <li v-for="link in paper.links" :key="link.id">
            <a :href="link.url" target="_blank" v-text="link.url"></a>
          </li>
        </ul>
      </div>
    </div>
    <div slot="footer">
      <button type="button" class="btn btn-default" @click="$emit('hide')">Close</button>
    </div>
  </modal>
</template>

<script>
import axios from '../../services/axios'
import debounce from 'debounce-promise'
import Abstract from './Abstract.vue'
import Vote from '../votes/Vote.vue'
import MiniBib from './MiniBib.vue'
import Comment from './Comment.vue'
import {Modal} from 'uiv'

export default {

  components: {
    Abstract,
    Vote,
    MiniBib,
    Modal,
    Comment,
  },

  props: [
    'list',
    'paper',
    'show',
    'currentUser',
  ],

  data () {
    return {
      abstractField: '',
      showEditAbstract: false,
      submittingAbstract: false,
      truncateAbstract: true,

      showTagForm: false,
      newTag: '',

      commentField: '',
      showAllComments: false,
      submittingComment: false,
      editCommentId: null,
      editCommentField: '',
      submittingEditComment: false,
      deletingComment: false,
    }
  },

  mounted () {
    this.abstractField = this.paper.abstract
  },

  watch: {
    //
  },

  computed: {
    listComments () {
      return this.paper.comments.filter(c => c.list_id === this.list.id)
    },

    hasAbstract () {
      return this.paper.abstract != undefined;
    },
    abstractImported () {
      return ! this.paper.abstract_editable && this.hasAbstract
    }
  },

  methods: {
    editAbstract () {
      this.showEditAbstract = true
      this.abstractField = this.paper.abstract
    },

    cancelAbstractForm () {
      this.showEditAbstract = false
    },

    submitAbstract () {
      this.submittingAbstract = true

      axios.patch(`/papers/${this.paper.id}.json`, {
        paper: {
          abstract: this.abstractField
        }
      }).then(res => {
        this.submittingAbstract = false
        this.showEditAbstract = false
        this.paper.abstract = this.abstractField
      })
    },

    submitTags (tags) {
      let tag_list = this.paper.tags.map(t => t.name)
      if (this.paper.tags.length === 0) tag_list = ['']
      tag_list = tag_list.concat(tags).filter(t => t)
      axios.patch(`/papers/${this.paper.id}.json`, {
        paper: {
          tag_list: tag_list
        }
      }).then(res => {
        this.paper.tags = res.data.tags
      })
    },

    addTag () {
      if (this.newTag !== '') {
        const tags = this.newTag.split(',')
        this.newTag = ''
        this.submitTags(tags)
      }
    },

    removeTag (index) {
      this.paper.tags.splice(index, 1)
      this.submitTags()
    },

    submitComment () {
      this.submittingComment = true

      axios.post('/comments.json', {comment: {
        content: this.commentField,
        commentable_type: 'Paper',
        commentable_id: this.paper.id,
        list_id: this.list.id,
      }}).then(res => {
        this.submittingComment = false
        this.commentField = ''
        this.paper.comments.unshift(res.data)
      }).catch(err => {
        this.submittingComment = false
        alert(err)
      })
    },

    editComment (comment) {
      this.editCommentId = comment.id
      this.editCommentField = comment.content
    },

    cancelEditComment () {
      this.editCommentId = null
      this.editCommentField = ''
    },

    updateComment () {
      this.submittingEditComment = true

      axios.patch(`/comments/${this.editCommentId}.json`, {comment: {
        content: this.editCommentField,
        commentable_type: 'Paper',
      }}).then(res => {
        this.submittingEditComment = false
        this.paper.comments.find(comment => {
          if (comment.id === this.editCommentId) {
            comment.content = this.editCommentField
            return true
          }
        })
        this.editCommentId = null
        this.editCommentField = ''
      }).catch(err => {
        this.submittingEditComment = false
        alert(err)
      })
    },

    deleteComment (comment) {
      this.deletingComment = true

      axios.delete(`/comments/${comment.id}.json`).then(res => {
        this.deletingComment = false
        this.paper.comments.splice(this.paper.comments.findIndex(c => c.id = comment.id), 1)
      }).catch(err => {
        this.deletingComment = false
        alert(err)
      })
    },
  },

}
</script>