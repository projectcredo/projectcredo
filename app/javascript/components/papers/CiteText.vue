<template>
  <span>{{ content }}</span>
</template>

<script>
export default {
  props: ['paper'],

  computed: {
    content () {
      let mainAuthor = ''
      let year = ''
      let pub = ''

      if (this.paper.authors.length > 0) {
        mainAuthor = this.paper.authors[0].family_name
        if (mainAuthor.length > 50) {
          mainAuthor = mainAuthor.substring(0, 50) + '...'
        }
      }
      if (this.paper.published_at != null) {
        year = new Date(this.paper.published_at).getFullYear()
      }
      if (this.paper.publication != null) {
        pub = this.paper.publication
        if (pub.length > 50) {
          pub = pub.substring(0, 50) + '...'
        }
      }
      const joinedCitation = $.grep([year, mainAuthor, pub], Boolean).join(', ');

      if (pub != '' || year != '') {
        return "[" + joinedCitation + "]"
      }
    },
  },
}
</script>
