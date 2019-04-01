<template>
  <div id="activity-feed">
    <div class="row">
      <div class="col-md-3">
        <div v-if="signedIn">
          <a href="/lists/new" class="btn panel panel-default new-list">
            <h3>Create a new<br> board</h3>
          </a>
          <div class="index-filters">
            <h4>Filters</h4>
            <button class="filter-btn" :class="{active: ! filterPins}" @click="filterPins = false">
              All Research Activity
            </button>
            <button class="filter-btn" :class="{active: filterPins}"  @click="filterPins = true">
              Your Pins
            </button>
          </div>
        </div>
      </div>
      <div class="col-md-9">
        <h4>Recent Board Activity</h4>
        <list-card
          v-for="list in lists"
          v-if="list.pinned || ! filterPins"
          :key="list.id"
          :list="list"
          :signed-in="signedIn"
        >
        </list-card>
      </div>
    </div>
  </div>
</template>

<script>
import ListCard from './ListCard'

export default {
  props: ['lists', 'signedIn'],

  components: {
    ListCard,
  },

  data () {
    return {
      filterPins: false,
    }
  },

  methods: {
    //
  },

}
</script>
