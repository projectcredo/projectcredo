<template>
  <div class="add-paper-component" :class="{opened: opened}">
    <div class="btn-apc" @click.prevent="opened = ! opened">Add a Paper</div>
    <div class="apc-collapse">
      <div class="apc-body">
        <div class="apc-form">
          <div class="apc-form-item apc-search"><input type="text" placeholder="Search by topic" class="form-control"></div>
          <label class="apc-form-item"><input type="checkbox"> don't show papers I've already added to boards</label>
          <label class="apc-form-item"><input type="checkbox"> only show papers I've bookmarked</label>
          <div class="apc-form-item apc-from-to">only show papers from <input type="text" class="form-control input-sm"> to <input type="text" class="form-control input-sm"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {

  props: ['listId'],

  data() {
    return {
      opened: false,
    }
  },

  methods: {
    //
  }

}
</script>
