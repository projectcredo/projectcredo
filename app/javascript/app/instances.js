import Vue from 'vue'
import Vue2Filters from 'vue2-filters'
import './filters'
import ListsForm from '../components/lists/Form.vue'
import SimpleChart from '../components/charts/SimpleChart.vue'
import List from '../components/list/List.vue'

Vue.use(Vue2Filters)

createInstance('lists-form', ListsForm)
createInstance('simple-chart', SimpleChart)
createInstance('list', List)

/**
 * Create an Vue instance and attach the component to an element with passed name
 *
 * @param name
 * @param component
 */
function createInstance(name, component) {
  document.addEventListener('DOMContentLoaded', () => {
    const els = document.querySelectorAll('.vue-' + name)
    if (! els.length) return

    els.forEach(el => {
      const props = JSON.parse(el.getAttribute('data-props'))

      new Vue({
        render: h => h(component, {props})
      }).$mount(el)
    })
  })
}
