import Vue from 'vue'
import ListsForm from '../components/lists/Form.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    render: h => h(ListsForm, {props: listsFormProps})
  }).$mount('#lists_form')
})
