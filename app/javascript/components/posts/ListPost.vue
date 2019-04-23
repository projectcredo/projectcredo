<template>
  <li class="list-post">
    <div class="list-post-author">
      <div class="lpa-avatar"><a :href="post.user.url"><img :src="post.user.avatar_thumb" alt=""></a></div>
      <div class="lpa-name"><a :href="post.user.url">{{ post.user.full_name }}</a></div>
      <div class="lpa-date">{{ post.created_at | date('M/D/YYYY [at] h:mm a') }}</div>
    </div>
    <div class="list-post-content">{{ post.content }}</div>
    <div class="lits-post-article" :class="{empty: ! article.papers.length}" v-for="article in post.articles" :key="article.id">
      <div class="lpar-header">
        <div class="lpar-thumb"><div class="cropped-image"><div><img :src="article.cover_thumb" alt=""></div></div></div>
        <div class="lpar-heading">
          <div class="lpar-title"><a :href="article.url" target="_blank">{{ article.title || 'No article' }}</a></div>
          <div class="lpar-source">{{ article.source }}</div>
          <div class="lpar-bookmarks">
            <bookmark :bookmarkable="article" :type="'Article'" :signed-in="global.signedIn"></bookmark>
          </div>
        </div>
      </div>
      <div class="lpar-papers" v-if="article.papers.length">
        <div class="lpar-papers-title">Research Papers Cited in this Article</div>
        <post-paper v-for="paper in article.papers" :paper="paper" :key="paper.id" :global="global" @select-paper="selectPaper"></post-paper>
      </div>
    </div>
  </li>
</template>

<script>
import PostPaper from '../papers/PostPaper.vue'
import Bookmark from '../bookmarks/Bookmark.vue'

export default {
  props: ['post', 'global'],

  components: {
    PostPaper,
    Bookmark,
  },

  computed: {
    //
  },

  methods: {
    selectPaper (paper) {
      this.$emit('select-paper', paper)
    },
  },
}
</script>
