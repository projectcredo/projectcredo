<template>
  <div class="list-summary">
    <div class="list-summary-title">Summary</div>
    <a href="#" class="pull-right" v-if="list.can_update && ! editing" @click.prevent="edit" :disabled="submitting"><i class="fa fa-pencil"></i></a>
      <div v-if="editing" class="clearfix">
        <textarea ref="content" v-model="editContent" class="form-control mb-5" :disabled="submitting"></textarea>
        <a href="#" class="btn btn-success btn-sm" @click.prevent="showCitePaper = true">Cite Paper</a>
        <div class="pull-right">
          <a href="#" class="text-small" @click.prevent="editing = false" :disabled="submitting">Cancel</a>
          <a href="#" class="btn btn-primary btn-sm" @click.prevent="submit" :disabled="submitting">Save</a>
        </div>
      </div>
    <div class="list-summary-body" v-if="summary">
      <summary-content v-show="! editing" :summary="summary" :list="list" @select-paper="paper => $emit('select-paper', paper)"></summary-content>
    </div>
    <div class="list-summary-body" v-else>No summaries written yet.</div>
    <cite-paper-modal :list="list" :show="showCitePaper" @hide="showCitePaper = false" @selected="citePaper"></cite-paper-modal>
  </div>
</template>

<script>
import axios from 'axios'
import SummaryContent from '../summaries/SummaryContent'
import CitePaperModal from '../summaries/CitePaperModal'

export default {
  props: ['summary', 'list'],

  components: {
    SummaryContent,
    CitePaperModal,
  },

  data () {
    return {
      editContent: '',
      editing: false,
      submitting: false,
      showCitePaper: false,
    }
  },

  methods: {
    edit () {
      this.editContent = this.summary.content
      this.editing = true
    },

    citePaper (paper) {
      const startPos = this.$refs.content.selectionStart

      // Insert shortcode in the current cursor position
      this.editContent = this.editContent.substring(0, startPos)
        + `[cite_paper id=${paper.id}]`
        + this.editContent.substring(startPos, this.editContent.length)

      this.showCitePaper = false
    },

    submit () {
      if (this.submitting) return false
      this.submitting = true

      const data = {
        list_id: this.list.id,
        summary: {content: this.editContent},
      }

      ;(this.summary ? axios.put(`/summaries/${this.summary.id}`, data) : axios.post('/summaries', data))
        .then(res => {
          this.summary ? this.$emit('summary-updated', res.data) : this.$emit('summary-created', res.data)
        })
        .catch(err => {
          alert(err.message)
        })
        .then(() => {
          this.submitting = false
          this.editing = false
        })
    },
  },

}
</script>
