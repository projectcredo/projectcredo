<template>
  <div class="list-summary">
    <div class="list-summary-title">Summary</div>
    <div class="list-summary-body" v-if="summary">
      <a href="#" class="pull-right" v-if="list.can_update && ! editing" @click.prevent="editing = true" :disabled="updating"><i class="fa fa-pencil"></i></a>
      <div v-if="editing">
        <textarea v-model="editSummary" class="form-control mb-5" :disabled="updating"></textarea>
        <div class="text-right">
          <a href="#" class="text-small" @click.prevent="editing = false" :disabled="updating">Cancel</a>
          <a href="#" class="btn btn-primary btn-sm" @click.prevent="update" :disabled="updating">Save</a>
        </div>
      </div>
      <summary-content v-show="! editing" :summary="summary" :list="list" @select-paper="paper => $emit('select-paper', paper)"></summary-content>
    </div>
    <div class="list-summary-body" v-else>No summaries written yet.</div>
  </div>
</template>

<script>
import SummaryContent from '../summaries/SummaryContent'

export default {
  props: ['summary', 'list'],

  components: {
    SummaryContent,
  },

  data () {
    return {
      editSummary: '',
      editing: false,
      updating: false,
    }
  },

  mounted () {
    this.editSummary = this.summary ? this.summary.content : ''
  },

  methods: {
    update () {
      this.updating = true

      // TODO
    },
  },

}
</script>
