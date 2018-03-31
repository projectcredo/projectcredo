<template>
  <div>
    <div class="col-md-offset-6">
      <input ref="input"
             class="ref-table-filter"
             :value="value"
             @input="updateFilterKey($event.target.value)"
             placeholder="Filter this board for..."
      />
    </div>
    <table class="table">
      <thead>
      <tr>
        <th width="60" @click="sort('bookmarks_count')" :class="{ active: sortKey == 'bookmarks_count' }">
          Bookmarks
          <span class="table-sort" :class="sortOrders['votes'] > 0 ? 'asc' : 'dsc'"></span>
        </th>
        <th width="50" @click="sort('age')" :class="{ active: sortKey == 'age' }">
          Age
          <span class="table-sort" :class="sortOrders['age'] < 0 ? 'asc' : 'dsc'"></span>
        </th>
        <th>Paper</th>
        <th width="30"></th>
        <th width="50"></th>
      </tr>
      </thead>
      <tbody is="reference-row"
             v-for="(reference, index) in filteredData"
             :index="index"
             :r="reference"
             :signed-in="signedIn"
             :edits-allowed="editsAllowed"
             :current-username="currentUsername"
      >
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from '../../services/axios'
import debounce from 'debounce-promise'
import ReferenceRow from './ReferenceRow.vue'

export default {

  components: {ReferenceRow},

  props: ['filteredData', 'value', 'sortKey', 'sortOrders', 'signedIn', 'editsAllowed', 'currentUsername'],

  methods: {
    sort (key) {
      this.$emit('sort', key)
    },

    updateFilterKey (value) {
      this.$emit('input', value)
    }
  }
}
</script>