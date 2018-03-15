<template>
  <div class="add-reference">

    <form ref="form" action="/references" accept-charset="UTF-8" method="post" class="form-inline">
      <input type="hidden" name="authenticity_token" :value="token">
      <input :value="list.id" type="hidden" name="reference[list_id]">

      <input :value="locatorType" type="hidden" name="reference[locator][type]">

      <div class="form-group col-md-12 locator-fields">
        <i>
          Or add a paper by
          <a @click.prevent="setLocatorType('doi')">DOI</a>,
          <a @click.prevent="setLocatorType('pubmed')">Pubmed ID</a>,
          <a @click.prevent="setLocatorType('link')">URL</a>
        </i>
        <div class="form-group" v-if="showLocatorFields">
          <input class="form-control paper-locator input-sm" type="text" name="reference[locator][id]" :placeholder="locatorIdPlaceholder">
          <input v-if="showTitleField" class="form-control paper-title input-sm" type="text" name="reference[locator][title]" placeholder="Required - Ex: Regulation of the Neural Circuitry of Emotion">

          <input type="submit" name="commit" value="Submit" :disabled="list.accepts_public_contributions && userCanEdit" data-disable-with="Submit" class="btn btn-primary btn-xs">
          <a href="#" @click.prevent="cancelAdd">cancel</a>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  props: ['userCanEdit', 'list'],

  data () {
    return {
      locatorType: null,
      placeholderFor: {
        doi: 'Ex: 10.1038/srep23344',
        pubmed: 'Ex: 18365029',
        link: 'Ex: http://example.org/article?id=1',
      },
      token: document.getElementsByName('csrf-token')[0].getAttribute('content'),
    }
  },

  methods: {

    setLocatorType (refType) {
      this.locatorType = refType;
    },

    cancelAdd () {
      this.locatorType = null;
    },
  },

  computed: {

    showLocatorFields () {
      return !!this.locatorType;
    },

    showTitleField () {
      return this.locatorType === 'link'
    },

    locatorIdPlaceholder () {
      return this.placeholderFor[this.locatorType]
    },
  },
}
</script>