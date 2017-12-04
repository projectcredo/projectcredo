import Vue from 'vue'
import ListsForm from '../components/lists/Form.vue'
import Multiselect from 'vue-multiselect/src/Multiselect.vue'

Vue.component('multiselect', Multiselect)

document.addEventListener('DOMContentLoaded', () => {
  if (! document.getElementById('lists_form')) return;

  new Vue({
    render: h => h(ListsForm, {props: listsFormProps})
  }).$mount('#lists_form')
})