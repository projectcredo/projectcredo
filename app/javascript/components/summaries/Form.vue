<template>
  <div class="list-section" id="summary-form">
    <form class="edit_summary" :action="formUrl" accept-charset="UTF-8" method="post">
      <input type="hidden" name="_method" :value="summary.id ? 'patch' : 'post'" />
      <input type="hidden" name="authenticity_token" :value="token" />
      <div class="form-horizontal">
        <div class="form-group">
          <label class="col-md-2 control-label">Evidence rating</label>
          <div class="col-md-10">
            <div class="row">
              <div class="col-md-2">
                <select
                        name="summary[evidence_rating]"
                        id="summary_evidence_rating"
                        class="form-control"
                        v-model="form.evidence_rating"
                >
                  <option :value="value" v-for="value in evidenceRatings">{{ value }}</option>
                </select>
              </div>
              <div class="col-md-6">
                  <span class=' evidence-rating'>
                    <span class='icon' :class="form.evidence_rating"></span>
                    {{ ratingDesc }}
                  </span>
              </div>
            </div>
          </div>
        </div>
        <div class="form-group">
          <label class="col-md-2 control-label">Summary</label>
          <div class="col-md-8">
              <textarea
                      class='form-control'
                      placeholder='Help summarize the evidence for this topic.  A good summary begins with a major headline - "Smoking causes lung cancer".  It then provides the major supporting information.  You can cite papers from this board by clicking the paper titles below.  Be brief and concise to help communicate this information.'
                      rows='12'
                      name="summary[content]"
                      id="summary_content"
                      v-model="form.content"
              ></textarea>
            <div class="pull-right">
              <countdown :max="2500" :current-length="form.content.length"></countdown>
            </div>
          </div>
        </div>

        <div class="form-group">
          <div class="col-md-offset-2 col-sm-8">
            <input type="submit" name="commit" value="Submit" method="patch" data-disable-with="Submit" class="btn btn-primary">
            <a href="/" class="action-link">cancel</a>
            <a v-if="summary.id" data-confirm="Are you sure you want to delete your summary?" rel="nofollow" :href="formUrl" class="btn btn-danger pull-right">Delete this summary</a>
          </div>
        </div>

        <div class="row">
          <div class="divider-small col-md-10"></div>
        </div>
        <div class="form-group">
          <label class="col-md-2 control-label">Click paper to add a citation to your summary</label>
          <div class="col-md-8">
            <reference-list
                    :signed-in="signedIn"
                    :filtered-data="filteredData"
                    v-model="filterKey"
                    :sort-key="sortKey"
                    :sort-orders="sortOrders"
                    @sort="sortBy($event)"
                    @filter="addToFilter($event)"
                    @select-ref="selectReference($event)"
            ></reference-list>
          </div>

        </div>
      </div>
    </form>
  </div>
</template>

<script>
import Countdown from './Countdown.vue'
import ReferenceList from '../references/ReferenceList.vue'

export default {

  components: {
    Countdown,
    ReferenceList,
  },

  props: ['formUrl', 'deleteUrl', 'signedIn', 'list', 'summary', 'allReferences', 'evidenceRatings'],

  data () {
    return {
      filterKey: '',
      sortKey:'',
      sortOrders: {'age': 1, 'votes': -1},
      form: {},
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
    }
  },

  beforeMount () {
    this.form = this.summary
  },

  computed: {

    ratingDesc () {
      if(this.summary.evidence_rating == 'too early') {
        return 'The evidence is too sparse to determine a conclusion.';
      } else if(this.summary.evidence_rating == 'mixed') {
        return 'The evidence is contradictory.';
      } else if(this.summary.evidence_rating == 'conclusive') {
        return 'There is an extensive body of evidence pointing to a conclusion.';
      }
    },

    filteredData  () {
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
          "paper.title",
          "paper.authors.full_name",
          "paper.tag_list",
          "paper.abstract"
        ]
      };
      if(filterKey) {
        var fuse = new Fuse(data, fuseOptions);
        data = fuse.search(this.filterKey);
      }
      if (sortKey) {
        data = data.slice().sort(function (a, b) {
          if(sortKey == 'age'){
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
    }
  },

  methods: {

    selectReference (index) {
      this.summary.content += `[r-cite id=${this.filteredData[index].id}]`;
    },

    addToFilter (add) {
      if(!this.filterKey.match(add)) {
        if(this.filterKey) {
          this.filterKey += ' ' + add
        } else {
          this.filterKey = add
        }
      }
    },

    sortBy (key) {
      this.sortKey = key;
      this.sortOrders[key] = this.sortOrders[key] * -1;
    }
  },
}
</script>
