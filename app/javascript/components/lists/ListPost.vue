<template>
  <li class="list-post">
    <div class="list-post-author">
      <div class="lpa-avatar"><a :href="post.user_short.url"><img :src="post.user_short.avatar_thumb" alt=""></a></div>
      <div class="lpa-name"><a :href="post.user_short.url">{{ post.user_short.full_name }}</a></div>
      <div class="lpa-date">{{ post.created_at | date('M/D/YYYY [at] h:mm a') }}</div>
    </div>
    <div class="list-post-content">{{ post.content }}</div>
    <div class="lits-post-article" v-for="article in post.articles" :key="article.id">
      <div class="lpar-header">
        <div class="lpar-thumb"><div class="cropped-image"><div><img :src="article.cover_thumb" alt=""></div></div></div>
        <div class="lpar-heading">
          <div class="lpar-title">{{ article.title || 'No article' }}</div>
          <div class="lpar-source">{{ article.source }}</div>
          <div class="lpar-bookmarks"><i class="fa fa-bookmark-o"></i> bookmarked by {{ article.bookmarks_count }} people</div>
        </div>
      </div>
      <div class="lpar-papers">
        <div class="lpar-papers-title">Research Papers Cited in this Article</div>
        <post-paper v-for="paper in article.papers" :paper="paper" :key="paper.id"></post-paper>
      </div>
    </div>
  </li>
</template>

<script>
import PostPaper from './PostPaper.vue'

export default {
  props: ['post'],

  components: {
    PostPaper,
  },

  computed: {
    //
  },
}
</script>
