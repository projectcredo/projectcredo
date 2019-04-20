<template>
  <div class="list-post-form">
    <textarea v-model="content" ref="textarea" class="lpf-textarea" placeholder="What are you reading?"></textarea>
    <url-preview v-if="url" :info="urlInfo" :loading="loadingUrlInfo"></url-preview>
    <button class="btn btn-primary" :disabled="loadingUrlInfo">Post</button>
    <a v-if="url" class="lpf-clear" href="#" @click.prevent="url = ''">clear</a>
  </div>
</template>

<script>
import urlRegex from 'url-regex'
import debounce from 'lodash-es/debounce'
import isEmpty from 'lodash-es/isEmpty'
import axios from '../../services/axios';
import UrlPreview from './UrlPreview'
import autosize from 'autosize'

export default {
  props: ['list'],

  components: {
    UrlPreview,
  },

  data () {
    return {
      content: '',
      url: '',
      urlInfo: {},
      loadingUrlInfo: false,
    }
  },

  watch: {
    content (val) {
      if (! this.url) this.findUrl()
    },

    url (val) {
      if (val) this.loadUrlInfo()
      else this.urlInfo = {}
    },
  },

  methods: {
    findUrl: debounce(function () {
      this.content.replace(urlRegex(), url => {
        if (! this.url) this.url = url
      })
    }, 300),

    loadUrlInfo () {
      this.loadingUrlInfo = true
      axios.post('/posts/load-open-graph', {url: this.url})
        .then(res => {
          this.urlInfo = res.data
        })
        .then(() => {
          this.loadingUrlInfo = false
        })
    },
  },

  mounted () {
    this.$refs.textarea.addEventListener('focus', () => autosize(this.$refs.textarea))
  },
}
</script>
