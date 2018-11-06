<template>
  <div class="form-horizontal">

    <div class="form-group">
      <label for="input_name" class="col-md-2 control-label">Name</label>
      <div class="col-md-10">
        <input id="input_name" type="text" name="list[name]" v-model="form.name" class="form-control">
      </div>
    </div>

    <div class="form-group">
      <label for="input_description" class="col-md-2 control-label">Description</label>
      <div class="col-md-10">
        <textarea name="list[description]" id="input_description" rows="5" class="form-control" v-model="form.description"></textarea>
      </div>
    </div>

    <div class="form-group">
      <div class="col-md-2 control-label">
        <label for="tags_input">Tags</label>
        <p>
          <small>(separated by commas)</small>
        </p>
      </div>
      <div class="col-md-10">
        <input id="tags_input" type="text" name="list[tag_list]" v-model="form.tag_list" class="form-control"
               placeholder="Ex: biology, chemistry, physics">
      </div>
    </div>

    <div class="form-group">
      <label class="col-md-2 control-label">
        Owner
      </label>
      <div class="col-md-3">
        <div class="form-control contributor-list">
          <a :href="'/' + owner">{{ owner }}</a>
        </div>
      </div>
    </div>

    <div class="form-group">
      <div class="col-md-2 control-label">
        <label for="list_access">Board Access</label>
      </div>
      <div class="col-md-3"
           data-toggle="popover"
           data-placement="right"
           data-trigger="hover"
           :data-content="accessDefinition">
        <select name="list[access]"
                id="list_access"
                class="form-control"
                :disabled="! canModerate"
                v-model="form.access"
        >
          <option value="public">🌎 Public</option>
          <option value="contributors">🔒 Contributors</option>
        </select>
      </div>
    </div>

    <div class="form-group" v-if="! isPublic">
      <label class="col-md-2">
        <div class="control-label">Contributors</div>
      </label>

      <div class="col-md-6">
        <multiselect :value="form.contributors"
                     @input="onChangeContributors"
                     :internal-search="false"
                     :limit="8"
                     :limit-text="limitText"
                     track-by="id"
                     label="username"
                     placeholder="Select Contributors"
                     :options="loadedContributors"
                     :multiple="true"
                     :searchable="true"
                     :loading="loadingContributors"
                     @search-change="searchContributors"
        >
          <template slot="option" slot-scope="props">
            <img class="multiselect-avatar" width="30" height="30" :src="props.option.avatar"> {{ props.option.username }}
          </template>
        </multiselect>
        <input type="hidden" name="list[list_members][]" :value="contributor.username" v-for="contributor in form.contributors">
      </div>
    </div>

    <div class="form-group form-image-group">
      <label class="col-md-2 control-label">Cover Image</label>
      <div class="col-md-10">
        <input id="input_cover" type="file" name="list[cover]" class="form-control">
        <div class="form-selected-image" v-if="list.cover_file_name">
          <a class="fancy-box" :href="list.cover">
            <img class="form-image-preview" :src="list.cover_thumb" alt="">
          </a>
          <div><a :href="listUrl + '/remove-attachment/cover'">Remove</a></div>
        </div>
      </div>
    </div>

    <div class="form-group">
      <div class="col-sm-offset-2 col-sm-10">
        <input type="submit"
               class="btn btn-primary"
               name="commit"
               :value="buttonName"
               :data-confirm="currentUserRemovedConfirm"
               data-disable-with="Update Board"
        >
        <a :href="listUrl">cancel</a>
      </div>
    </div>

  </div>
</template>

<script>
import axios from '../../services/axios'
import debounce from 'debounce-promise'
import Multiselect from 'vue-multiselect/src/Multiselect.vue'

export default {

  components: {Multiselect},

  props: ['list', 'buttonName', 'currentUser', 'canModerate', 'owner', 'contributors', 'allUsers', 'listUrl', 'contributorsSearchLink'],

  data() {
    return {
      loadedContributors: [],
      loadingContributors: false,
      form: {
        name: '',
        tag_list: '',
        description: '',
        access: null,
        contributors: [],
      },
    }
  },

  created() {
    this.form = Object.assign({}, this.list);
    this.form.contributors = this.contributors
    this.form.tag_list = this.list.tags.map(t => t.name).join(', ');
  },

  mounted () {
    jQuery('[data-toggle="popover"]').popover();
  },

  computed: {

    isPublic() {
      return this.form.access === 'public'
    },

    accessDefinition() {
      if (this.isPublic) {
        return 'Anyone can add and remove their own references.  Public boards allow the greatest amount of participation and collaboration.'
      } else if (this.form.access === 'contributors') {
        return 'Only assigned contributors can edit or add references to this board.  This gives contributors full control over referenced papers.'
      }
    },

    nonMembers() {
      return this.allUsers.filter(member => member.role == 'nonmember')
    },

    currentUserRemovedConfirm() {
      if (!this.nonMembers.some(member => member.username == this.currentUser) || this.currentUser == this.owner) {
        return null
      } else {
        return 'Are you sure you want to remove yourself as a contributor?'
      }
    },

  },

  methods: {

    searchContributors (query) {
      if (query === '') {
        return
      }
      this.loadingContributors = true;

      // TODO fix debounce, current usage is incorrect
      debounce((query) => axios.get(this.contributorsSearchLink, {params: {query}}), 400)(query)
        .catch((e) => {
          console.error(e)
          return []
        })
        .then(response => {
          this.loadedContributors = response.data
          this.loadingContributors = false
        })
    },

    onChangeContributors (values) {
      this.form.contributors = values
      this.$forceUpdate()
    },

    limitText (count) {
      return `and ${count} other users`
    },

  }
}
</script>