<template>
  <li class="list-post">
    <div class="list-post-author">
      <a href="#" class="pull-right" v-if="list.can_update" @click.prevent="destroy" :disabled="deleting"><i class="fa fa-trash"></i></a>
      <div class="lpa-avatar"><a :href="post.user.url"><img :src="post.user.avatar_thumb" alt=""></a></div>
      <div class="lpa-name"><a :href="post.user.url">{{ post.user.full_name }}</a></div>
      <div class="lpa-date">{{ post.created_at | date('M/D/YYYY [at] h:mm a') }}</div>
    </div>
    <div class="list-post-content">
      <a href="#" class="pull-right" v-if="list.can_update && ! edit" @click.prevent="edit = true"><i class="fa fa-pencil"></i></a>
      <div v-if="edit">
        <textarea v-model="editContent" class="form-control mb-5" :disabled="updating"></textarea>
        <div class="text-right">
          <a href="#" class="text-small" @click.prevent="edit = false" :disabled="updating">Cancel</a>
          <a href="#" class="btn btn-primary btn-sm" @click.prevent="update" :disabled="updating">Save</a>
        </div>
      </div>
      <div v-if="! edit">{{ post.content }}</div>
    </div>
    <div class="lits-post-article" :class="{empty: ! article.papers.length}" v-for="article in post.articles" :key="article.id">
      <div class="lpar-header">
        <div class="lpar-thumb"><div class="cropped-image"><div><img :src="article.cover_thumb" alt=""></div></div></div>
        <div class="lpar-heading">
          <div class="lpar-title"><a :href="article.url" target="_blank">{{ article.title || 'No article' }}</a></div>
          <div class="lpar-source">{{ article.source }}</div>
          <div class="lpar-bookmarks">
            <bookmark :bookmarkable="article" :type="'Article'" :signed-in="!! currentUser"></bookmark>
          </div>
        </div>
      </div>
      <div class="lpar-papers" v-if="article.papers.length">
        <div class="lpar-papers-title">Research Papers Cited in this Article</div>
        <post-paper v-for="paper in article.papers" :paper="paper" :key="paper.id" :currentUser="currentUser" @select-paper="selectPaper"></post-paper>
      </div>
    </div>
  </li>
</template>

<script>
import axios from 'axios'
import PostPaper from '../papers/PostPaper.vue'
import Bookmark from '../bookmarks/Bookmark.vue'

export default {
  props: ['list', 'post', 'currentUser'],

  components: {
    PostPaper,
    Bookmark,
  },

  data () {
    return {
      edit: false,
      editContent: '',
      updating: false,
      deleting: false,
    }
  },

  mounted () {
    this.editContent = this.post.content
  },

  computed: {
    //
  },

  methods: {
    selectPaper (paper) {
      this.$emit('select-paper', paper)
    },

    update () {
      if (! this.editContent) return

      this.updating = true
      axios.put(`/posts/${this.post.id}`, {
          post: {content: this.editContent},
        })
        .then(res => {
          this.$emit('post-updated', res.data)
          this.content = ''
        })
        .catch(err => {
          alert(err.message)
        })
        .then(() => {
          this.updating = false
          this.edit = false
        })
    },

    destroy () {
      this.deleting = true
      axios.delete(`/posts/${this.post.id}`)
        .then(res => {
          this.$emit('post-deleted', this.post)
        })
        .catch(err => {
          alert(err.message)
        })
        .then(() => {
          this.deleting = false
        })
    },
  },
}
</script>
