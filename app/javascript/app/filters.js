import Vue from 'vue'
import moment from 'moment-mini'

Vue.filter('date', function (value, format) {
  if (typeof value === 'undefined') {
    return 'undefined'
  }

  if (typeof format === 'undefined') {
    format = 'D MMM'
  }

  return moment(value).format(format)
})
