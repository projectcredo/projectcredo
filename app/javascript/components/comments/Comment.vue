<template>
  <div class="comment" :id="'comment-' + comment.id">
    <p class="text-muted">
      <span v-if="comment.created_at == comment.updated_at">Added by </span>
      <span v-else>Updated by </span>
      <strong><a :href="comment.user.url">{{ comment.user.username }}</a></strong>
      on {{ formatDate(comment.updated_at) }}
    </p>
    <span class="content"><p>{{ comment.content }}</p></span>

    <ul>
      <li id="comment-vote-55">
        <form class="like-form" action="/comments/55/vote" accept-charset="UTF-8" data-remote="true" method="post">
          <input name="utf8" type="hidden" value="✓">
          <input type="hidden" name="_method" value="delete">
          <input type="hidden" name="authenticity_token" value="KsRvx8K29hu2uCGieUKyjPZR/lPPKKSOm6W8uMyQ+u3rTdm9LJi/3ICF6zlOjBxyuWry3j4TpO3aId8LXOjgAw==">
          <input type="text" name="id" id="id" value="55" hidden="hidden">
          <input type="text" name="type" id="type" value="comment" hidden="hidden">
          <button name="button" type="submit" class="comment-vote clicked">1</button>
        </form>
      </li>
      <li><a class="toggle-reply active-link btn-xs" data-parent-comment-id="55" href="#">reply</a></li>
      <li><a class="active-link btn-xs" data-remote="true" href="/comments/55/edit">edit</a></li>
      <li><a class="text-danger small" data-remote="true" rel="nofollow" data-method="delete" href="/comments/55">delete</a></li>
      <li></li>
    </ul>

    <comments-list :signed-in="signedIn" :user-id="userId" :comments="comment.nested_comments"></comments-list>
  </div>
</template>

<script>
import moment from 'moment-mini'
import CommentsList from './CommentsList.vue'

export default {
  name: 'comment',

  components: {
    CommentsList,
  },

  props: ['signedIn', 'userId', 'comment'],

  methods: {
    formatDate (date) {
      return moment(date).format('MMMM Do YYYY hh:mm:ss')
    },
  }

}
</script>
