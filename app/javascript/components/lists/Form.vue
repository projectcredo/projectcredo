<template>
  <div class="form-horizontal">

    <div class="form-group">
      <label for="input_name" class="col-md-2 control-label">Name</label>
      <div class="col-md-10">
        <input id="input_name" type="text" name="name" :value="list.name" class="form-control">
      </div>
    </div>

    <input type="hidden" :value="contributor.username" :name="'list[list_members][]'" v-for="contributor in contributors">

    <div class="form-group">
      <label for="input_description" class="col-md-2 control-label">Description</label>
      <div class="col-md-10">
        <textarea name="description" id="input_description" rows="5" class="form-control">{{ list.description }}</textarea>
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
        <input id="tags_input" type="text" name="tags" :value="list.tags" class="form-control"
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

      <div class="col-md-3">
        <select class="form-control contributor-list"
                :disabled="! canModerate || isPublic"
                @change="addMember"
                v-if="canModerate"
        >
          <option value="">Add Contributor</option>
          <option v-for="nonMember in nonMembers"
                  :value="nonMember.username"
                  v-text="nonMember.username"
          >
          </option>
        </select>

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
        <a :href="cancelLink">cancel</a>
      </div>
    </div>

  </div>
</template>

<script>
  export default {

    props: ['list', 'buttonName', 'currentUser', 'canModerate', 'owner', 'allUsers', 'cancelLink'],

    data() {
      return {
        form: {
          access: null,
        },
      }
    },

    created() {
      this.form = this.list;
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

      contributors() {
        return this.allUsers.filter(member => member.role == 'contributor')
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

      addMember() {
        // Todo
      },

      removeMember(member) {
        // Todo
      },

    }
  }
</script>