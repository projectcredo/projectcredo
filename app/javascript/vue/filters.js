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

Vue.filter('cite', function (paper) {
  let mainAuthor = ''
  let year = ''
  let pub = ''

  if (paper.authors.length > 0) {
    mainAuthor = paper.authors[0].family_name
    if (mainAuthor.length > 50) {
      mainAuthor = mainAuthor.substring(0, 50) + '...'
    }
  }
  if (paper.published_at != null) {
    year = new Date(paper.published_at).getFullYear()
  }
  if (paper.publication != null) {
    pub = paper.publication
    if (pub.length > 50) {
      pub = pub.substring(0, 50) + '...'
    }
  }
  const joinedCitation = $.grep([year, mainAuthor, pub], Boolean).join(', ');

  if (pub != '' || year != '') {
    return "[" + joinedCitation + "]"
  }
})

Vue.filter('age', function (date) {
  if (date) {
    const now = new Date();
    date = new Date(date)
    const age = now.getFullYear() - date.getFullYear() - ((now.getMonth() > date.getMonth() || (now.getMonth() == date.getDate())) ? 0 : 1)

    return age < 1 ? '< 1' : age
  }
})

Vue.filter('truncate', function (string, length, truncate) {
  if (typeof truncate === 'undefined') {
    truncate = 'true';
  }
  if (truncate && string && string.length > length) {
    var s = string.substring(0, length);
    var openLinkCount = (s.match('<a target') || []).length;
    var closeLinkCount = (s.match('</a>') || []).length;
    if (openLinkCount != closeLinkCount) {
      s = s.substring(0, string.lastIndexOf('<a target'));
    }
    return s + '...'
  } else {
    return string
  }
})

Vue.filter('pluralize', function () {
  const [value, ...args] = arguments
  return args.length > 1
    ? (args[value % 10 - 1] || args[args.length - 1])
    : (args[0] + (value === 1 ? '' : 's'))
})
