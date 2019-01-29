<template>
  <li class="list-post">
    <div class="list-post-author">
      <div class="lpa-avatar"><img src="https://s3-us-east-2.amazonaws.com/project-credo-production/users/avatars/000/000/052/thumb/photo.jpg?1518492843" alt=""></div>
      <div class="lpa-name">Leslie Park</div>
      <div class="lpa-date">7/30/2018 at 3:52pm</div>
    </div>
    <div class="list-post-content">{{ post.content }}</div>
    <div class="lits-post-article">
      <div class="lpar-header" v-if="article">
        <div class="lpar-thumb"><div class="cropped-image"><div><img src="https://s3-us-east-2.amazonaws.com/project-credo-production/users/avatars/000/000/052/thumb/photo.jpg?1518492843" alt=""></div></div></div>
        <div class="lpar-heading">
          <div class="lpar-title">Carrot and Stick: Intermittent Fasting and Bevioral Therapy</div>
          <div class="lpar-source">The New York Times</div>
          <div class="lpar-bookmarks"><i class="fa fa-bookmark-o"></i> bookmarked by 37 people</div>
        </div>
      </div>
      <div class="lpar-papers">
        <div class="lpar-papers-title">Research Papers <span v-if="article">Cited in this Article</span></div>
        <post-paper v-for="paper in post.papers" :paper="paper" :key="paper.id"></post-paper>
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
    article () {
      return this.post.articles[0]
    },
  },
}
</script>
