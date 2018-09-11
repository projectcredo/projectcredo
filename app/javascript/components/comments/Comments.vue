<template>
  <div>
    Commnets vue
    <comments-list :signed-in="signedIn" :user-id="userId" :comments="comments"></comments-list>
  </div>
</template>

<script>
import CommentsList from './CommentsList.vue'

export default {
  name: 'comments',

  components: {
    CommentsList,
  },

  props: ['commentableType', 'commentableId', 'signedIn', 'userId', 'signUpLink', 'comments'],

  data() {
    return {}
  },

  methods: {
    draw() {

    }
  }

}
</script>
