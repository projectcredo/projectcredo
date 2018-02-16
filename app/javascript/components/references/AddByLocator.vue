<template>
  <div class="add-reference">
    <%= form_for list.references.build, html: {class: 'form-inline', id: 'add-reference'} do |f| %>
    <%= f.hidden_field :list_id, value: list.id %>

    <%= f.fields_for :locator do |l| %>
    <div class="form-group col-md-12 locator-fields">
      <%= l.hidden_field :type, 'v-bind:value' => 'locatorType' %>
      <i>
        Or add a paper by
        <a @click.prevent="setLocatorType('doi')">DOI</a>,
        <a @click.prevent="setLocatorType('pubmed')">Pubmed ID</a>,
        <a @click.prevent="setLocatorType('link')">URL</a>
      </i>
      <div class="form-group" v-if='showLocatorFields'>
        <%= l.text_field  :id,
        class: "form-control paper-locator input-sm",
        'v-bind:placeholder' => 'locatorIdPlaceholder' %>

        <%= l.text_field  :title,
        placeholder: 'Required - Ex: Regulation of the Neural Circuitry of Emotion',
        class: "form-control paper-title input-sm",
        'v-if' => 'showTitleField' %>
        <%= f.submit "Submit",
        class: "btn btn-primary btn-xs",
        disabled: !(list.accepts_public_contributions? || current_user_can_edit?(list)) %>
        <%= link_to "cancel", '', '@click.prevent' => 'cancelAdd' %>
      </div>
    </div>
    <% end %>
    <% end %>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      locatorType: null,
      placeholderFor: {
        doi: "Ex: 10.1038/srep23344",
        pubmed: "Ex: 18365029",
        link: "Ex: http://example.org/article?id=1"
      }
    }
  },

  methods: {

    setLocatorType: function(refType) {
      this.locatorType = refType;
    },

    cancelAdd: function() {
      this.locatorType = null;
    }
  },

  computed: {

    showLocatorFields: function() {
      return !!this.locatorType;
    },

    showTitleField: function() {
      return this.locatorType === 'link'
    },

    locatorIdPlaceholder: function() {
      return this.placeholderFor[this.locatorType]
    }
  }
}
</script>