import Vue from 'vue'
import SimpleChart from '../components/charts/SimpleChart.vue'

document.addEventListener('DOMContentLoaded', () => {
  const elements = document.getElementsByClassName('simple-chart');
  if (! elements.length) return;

  Array.prototype.forEach.call(elements, el => {
    new Vue({
      render: h => h(SimpleChart, {props: JSON.parse(el.getAttribute('data-props'))})
    }).$mount(el)
  })
})
