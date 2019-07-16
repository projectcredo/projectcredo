<template>
  <div class="url-preview">
    <div v-if="loading">Fetching preview...</div>
    <div v-else>
      <div class="urlp-image cropped-image cropped-image-3by1" v-if="info.images.length"><div><img :src="info.images[0].src" alt=""></div></div>
      <div class="urlp-title">{{ info.title }}</div>
      <div class="urlp-descr">{{ info.description }}</div>
      <div class="urlp-papers" v-if="info.papers && info.papers.length">
        <div class="urlp-papers-header" @click="showPapers = ! showPapers">
          <span v-if="! showPapers">Show</span><span v-else>Hide</span>
          {{ info.papers.length }} found papers
        </div>
        <ul class="urlp-papers-list" :class="{show: showPapers}">
          <li v-for="paper in info.papers" v-if="paper.title" :title="paper.title">
            <input type="checkbox" v-model="checked" :value="paper.id">
            {{ paper.title }}
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['info', 'loading'],

  data () {
    return {
      showPapers: false,
      checked: [],
    }
  },

  watch: {
    info () {
      this.checked = this.info.papers.map(p => p.id)
    },

    checked () {
      this.$emit('checked', this.checked)
    },
  }
}
</script>
