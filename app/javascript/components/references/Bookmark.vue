<template>
  <span>
    <a :class="[{'toggled': this.bookmarkable.bookmarked}, 'bookmark', 'bookmark-icon']"
       @click.prevent="toggleBookmark"
       v-show="!isLoading"
    >
      {{ bookmarkable.bookmarks_count }}
    </a>
    <span class="spinner" v-show="isLoading">
      <span class="double-bounce1"></span>
      <span class="double-bounce2"></span>
    </span>
  </span>
</template>

<script>
import isNumber from 'lodash-es/isNumber'

export default {
  props: {
    bookmarkable: {type: Object},
    signedIn: {type: Boolean},
    // class: {type: String},
  },

  data () {
    return {
      isLoading: false
    }
  },

  computed: {
    classes () {
      const classes = ''
      if (this.class) classes.push(this.class, true)

      return classes
    },
  },

  methods: {

    bookmark () {
      $.ajax({
        url: '/bookmarks.json',
        type: 'POST',
        data: {
          id: this.bookmarkable.id,
          type: this.bookmarkable.type,
        },
        success: () => {
          this.bookmarkable.bookmarked = true
          if (isNumber(this.bookmarkable.bookmarks_count))
            this.bookmarkable.bookmarks_count = this.bookmarkable.bookmarks_count + 1
          this.isLoading = false
        },
      })
    },

    unbookmark () {
      $.ajax({
        url: '/bookmarks.json',
        type: 'DELETE',
        data: {
          id: this.bookmarkable.id,
          type: this.bookmarkable.type,
        },
        success: () => {
          this.bookmarkable.bookmarked = false
          if (isNumber(this.bookmarkable.bookmarks_count))
            this.bookmarkable.bookmarks_count = this.bookmarkable.bookmarks_count - 1
          this.isLoading = false
        },
      })
    },

    toggleBookmark () {
      if (! this.signedIn) {
        window.location.href = '/users/sign_in';
      } else if (! this.isLoading) {
        this.isLoading = true

        if (this.bookmarkable.bookmarked) {
          this.unbookmark()
        } else {
          this.bookmark()
        }
      }
    },
  },
}
</script>