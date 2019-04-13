<template>
  <div class="list-post-form">
    <textarea v-model="content" class="lpf-textarea" placeholder="What are you reading?"></textarea>
    <div>{{ urls }}</div>
    <button class="btn btn-default" :disabled="loadingUrlInfo">Post</button>
  </div>
</template>

<script>
import urlRegex from 'url-regex'
import debounce from 'lodash-es/debounce'
import axios from '../../services/axios';

export default {
  props: ['list'],

  data () {
    return {
      content: '',
      urls: [],
      url: '',
      openGraph: {},
      loadingUrlInfo: false,
    }
  },

  watch: {
    content (val) {
      this.findUrls()
    },

    urls (val) {
      if (val.length && this.url !== val[0]) this.url = val[0]
      else if (! val.length) this.url = ''
    },

    url (val) {
      if (val) this.loadUrlInfo()
    },
  },

  methods: {
    findUrls: debounce(function () {
      this.urls = []
      this.content.replace(urlRegex(), url => {
        this.urls.push(url)
      })
    }, 300),

    loadUrlInfo () {
      this.loadingUrlInfo = true
      axios.post('/posts/load-open-graph', {url: this.url})
        .then(res => {
          console.log(res.data)
        })
        .then(() => {
          this.loadingUrlInfo = false
        })
    },
  },
}
</script>
