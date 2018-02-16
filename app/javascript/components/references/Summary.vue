<template>
  <span class="newlines"><%= cleaned_content %></span>
</template>

<script>
export default {
  props: ['citedRefs'],

  methods: {
    r: function(id) {
      return this.citedRefs.filter(function(r){
        return r.id == id;
      })[0]
    }
  }
}
</script>