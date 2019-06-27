<template>
  <div class="list-summary">
    <div class="list-summary-title">Summary</div>
    <a href="#" class="pull-right" v-if="list.can_update && ! editing" @click.prevent="edit" :disabled="submitting"><i class="fa fa-pencil"></i></a>
      <div v-if="editing" class="clearfix">
        <div ref="content" contenteditable="true"
             class="form-control mb-5 list-summary-textarea"
             :disabled="submitting"
             @blur="saveNewValue"
             @keydown="editKeydown"
             @focus="caretToEnd"
             v-html="editContentParsed"
        ></div>
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
import {citeText, getPaper} from '../papers/helpers'

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

  computed: {
    editContentParsed () {
      const text = this.editContent.replace(/\n/gi, '<br>')

      return text.replace(/\[cite_paper id=(\d+)\]/gi, (match, id) => {
        const paper = getPaper(this.list, id)

        return '<span class="text-capitalize r-cite cite_paper-' + (paper ? paper.id : id) + '" contenteditable="false">' + citeText(paper) + '</span>'
      })
    },
  },

  methods: {
    saveNewValue () {
      let text = this.$refs.content.innerHTML
      text = text.replace(/(<span[^>]+cite_paper-([\w\d_+-]+)[^>]+>[^<]*<\/span>)/gi, (match, tag, id) => {
        return `[cite_paper id=${id}]`
      })
      text = text.replace(/(<([^>]+)>)/gi ,'')
      text = this.replaceHtmlEntites(text)

      this.editContent = text
    },

    edit () {
      this.editContent = this.summary ? this.summary.content : ''
      this.editing = true
    },

    citePaper (paper) {
      this.editContent = this.editContent + `[cite_paper id=${paper.id}]`

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

    editKeydown (e) {
      if (e.keyCode === 13) {
        // insert 2 br tags (if only one br tag is inserted the cursor won't go to the next line)
        document.execCommand('insertHTML', false, '<br><br>')
        // prevent the default behaviour of return key pressed
        e.preventDefault()
      }
    },

    caretToEnd () {
      const el = this.$refs.content
      el.focus()
      if (typeof window.getSelection !== 'undefined' && typeof document.createRange !== 'undefined') {
        const range = document.createRange()
        range.selectNodeContents(el)
        range.collapse(false)
        const sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange(range)
      } else if (typeof document.body.createTextRange !== 'undefined') {
        const textRange = document.body.createTextRange()
        textRange.moveToElementText(el)
        textRange.collapse(false)
        textRange.select()
      }
    },

    replaceHtmlEntites (s) {
      const translateRe = /&(nbsp|amp|quot|lt|gt);/g
      const translate = {
        'nbsp': ' ',
        'amp': '&',
        'quot': '\"',
        'lt': '<',
        'gt': '>'
      }

      return (s.replace(translateRe, function(match, entity) {
        return translate[entity]
      }))
    },
  },
}
</script>
