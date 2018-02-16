<template>
  <div>
    <div class="input-group input-group-sm crossref">
      <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
      <input class="form-control"
             v-bind:placeholder="placeholder"
             v-bind:disabled="!editsAllowed"
             v-model="query"
             v-on:keydown.esc="clearSearch"
             v-on:keyup="getResults"
      >
      <%= form_for list.references.build, html: {class: 'hidden', 'ref' => "form"} do |f| %>
      <%= f.hidden_field :list_id, value: list.id %>
      <%= f.fields_for :locator do |l| %>
      <%= l.text_field :type, value: 'doi' %>
      <%= l.text_field :id, 'v-bind:value' => 'doi | stripUrl' %>
      <% end %>
      <% end %>
    </div>
    <ul class="list-group autocomplete" v-if="this.results.length">
      <li class="list-group-item"
          v-for="result in results"
          v-on:click="selectResult(result)"
          v-html="result.fullCitation"
      >
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  props: ['editsAllowed'],

  data: function() {
    return {
      query: '',
      results: [],
      doi: '',
      submitted: false,
      placeholder: 'Search for a paper'
    }
  },

  methods: {

    clearSearch: function() {
      this.results = [];
      this.query = '';
    },

    getResults: debounce(
      function() {
        if (this.query === '') { return this.results = [] }
        self = this
        $.get('https://search.crossref.org/dois?sort=score&type=Journal+Article&rows=10&q=' + this.query).done(function(data) {
          if (data.length > 0) {
            self.results = data;
          } else {
            self.results = [{fullCitation: 'No results found.', doi: ''}];
          };
        });
      },
      200
    ),

    selectResult: function(result) {
      self = this
      this.doi = result.doi;
      this.submitted = true;
      this.searchDisabled = true;
      this.placeholder = result.fullCitation;
      this.clearSearch();
      // This is to give Vue time to update the doi above. It doesn't need much.
      window.setTimeout(function() { self.$refs.form.submit() }, 50);
    }
  },

  filters: {
    stripUrl: function (doiUrl) {
      return doiUrl.replace('http://dx.doi.org/', '')
    }
  }
}
</script>