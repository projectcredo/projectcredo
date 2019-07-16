<template>
  <div class="list-post-form">
    <textarea v-model="content" ref="textarea" class="lpf-textarea" placeholder="What are you reading?" :disabled="loading"></textarea>
    <url-preview v-if="url" :info="urlInfo" :loading="loadingUrlInfo" @checked="(c) => checkedPapers = c"></url-preview>
    <button class="btn btn-primary" :disabled="loadingUrlInfo || loading || ! this.content" @click="submit">
      <span v-if="loading">Posting...</span>
      <span v-else>Post</span>
    </button>
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
      loading: false,
      checkedPapers: [],
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

  computed: {
    article () {
      if (isEmpty(this.urlInfo)) return null
      return {
        url: this.urlInfo.url,
        title: this.urlInfo.title,
        cover: this.urlInfo.images.length ? this.urlInfo.images[0].src : null,
        papers: this.checkedPapers,
      }
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
        .catch(err => {
          this.url = ''
          console.log(err)
        })
        .then(() => this.loadingUrlInfo = false)
    },

    submit () {
      if (! this.content) return

      this.loading = true
      axios.post('/posts', {
        list_id: this.list.id,
          post: {content: this.content},
          article: this.article,
        })
        .then(res => {
          this.$emit('post-created', res.data)
          this.content = ''
          this.url = ''
        })
        .catch(err => {
          alert(err.message)
        })
        .then(() => this.loading = false)
    },
  },

  mounted () {
    this.$refs.textarea.addEventListener('focus', () => autosize(this.$refs.textarea))
  },
}
</script>
