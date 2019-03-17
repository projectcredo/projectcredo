<template>
  <modal :value="show" @hide="$emit('hide')" ref="modal" size="lg">
    <div slot="title" v-if="paper.id">
      <h4 class="modal-title">
        <vote :voteable="paper" :signed-in="global.signedIn"></vote>
        {{ paper.title }}
        <a class="modal-external-link" :href="paper.direct_link" target="_blank"></a>
      </h4>
      <mini-bib :paper="paper"></mini-bib>
      <div>
        <span v-if="paper.tag_list == 0 && global.editsAllowed">Add tags</span>
        <a class="tag" v-for="(tag, index) in paper.tag_list" :key="index">
          {{ tag }}
          <button class="tag-remove" v-show="showTagForm" @click="removeTag(index)"></button>
        </a>
        <a class="edit-btn" v-if="global.editsAllowed" @click="showTagForm = !showTagForm"></a>
        <div v-show="showTagForm">
          <input class="form-control input-sm tag-form"
                  v-model="newTag"
                  placeholder="Hit enter to add a tag"
                  @keyup.enter="addTag"
          />
        </div>
      </div>
    </div>

    <div v-if="paper.id"></div>
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
              v-if="paper.abstract_editable  && global.editsAllowed"
              @click="editAbstract = !editAbstract"
              :title="hasAbstract ? 'Edit this abstract' : 'Add an abstract'"
          ></a>
        </div>
        <div class="nothing-yet" v-if="!hasAbstract" v-show="!editAbstract">No abstract was imported...</div>
        <div v-if="global.editsAllowed" v-show="editAbstract">
          <div class="form-group">
            <textarea rows="10"
                      class="form-control"
                      placeholder="No abstract was imported.  Submitted abstracts will be labeled as user generated."
                      v-model="abstractField"
            ></textarea>
          </div>
          <div class="form-btns">
            <button class="submit-btn" @click="submitAbstract()">Submit</button>
            <a class="cancel-link" @click="cancelAbstractForm">Cancel</a>
          </div>
        </div>
        <abstract v-if="hasAbstract" v-show="!editAbstract" :abstract="paper.abstract"></abstract>
      </div>
      <div class="modal-section">
        <div class="modal-section-header">Details</div>
        <ul class="list-unstyled">
          <li v-if="paper.doi != null">
            DOI:
            <a :href="'http://dx.doi.org/'+paper.doi" target="_blank">{{ paper.doi }}</a>
          </li>
          <li v-if="paper.pubmed_id != null">
            Pubmed:
            <a :href="'https://www.ncbi.nlm.nih.gov/pubmed/' + paper.pubmed_id"
                target="_blank">{{ paper.pubmed_id }}</a>
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
import {Modal} from 'uiv'

export default {

  components: {
    Abstract,
    Vote,
    MiniBib,
    Modal,
  },

  props: [
    'paper',
    'global',
    'show',
  ],

  data () {
    return {
      abstractField: '',
      editAbstract: false,
      showTagForm: false,
      truncateAbstract: true,
      newTag: '',
    }
  },

  mounted () {
    this.abstractField = this.paper.abstract
  },

  watch: {
    //
  },

  computed: {
    hasAbstract () {
      return this.paper.abstract != undefined;
    },
    abstractImported () {
      return ! this.paper.abstract_editable && this.hasAbstract
    }
  },

  methods: {
    selectReference (index) {
      this.$emit('select-ref', index)
    },

    cancelAbstractForm () {
      this.editAbstract = false
      this.abstractField = this.paper.abstract
    },

    submitAbstract () {
      var self = this;
      var paper = this.paper
      var params = {
        paper: {
          abstract: this.abstract_form
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
          paper.abstract = this.abstract_form
        })
    },

    submitTags () {
      var tag_list = this.paper.tag_list
      if(this.paper.tag_list.length == 0){ tag_list =[""]}

      var params = {
        paper: {
          tag_list: tag_list
        }
      };
      $.ajax({
        url: `/papers/${this.paper.id}.json`,
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
          self.paper.tag_list.push(t.trim())
        })
        this.newTag = ''
        this.submitTags()
      }
    },

    removeTag (index){
      this.paper.tag_list.splice(index,1)
      this.submitTags()
    },
  }

}
</script>