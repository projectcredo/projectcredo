import Vue from 'vue'
import './filters'
import ListsForm from '../components/lists/Form.vue'
import SimpleChart from '../components/charts/SimpleChart.vue'
import List from '../components/lists/List.vue'
import SummariesForm from '../components/summaries/Form.vue'
import Comments from '../components/comments/Comments.vue'

Vue.prototype.$eventHub = new Vue()

createInstance('lists-form', ListsForm)
createInstance('simple-chart', SimpleChart)
createInstance('list', List)
createInstance('summaries-form', SummariesForm)
createInstance('comments', Comments)

/**
 * Create an Vue instance and attach the component to an element with passed name
 *
 * @param name
 * @param component
 */
function createInstance(name, component) {
  document.addEventListener('DOMContentLoaded', () => {
    const els = document.querySelectorAll('.vue-' + name)
    if (!els.length) return

    els.forEach(el => {
      const props = JSON.parse(el.getAttribute('data-props'))

      new Vue({
        render: h => h(component, { props }),
      }).$mount(el)
    })
  })
}
