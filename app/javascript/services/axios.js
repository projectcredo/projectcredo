import axios from 'axios'

const tokenTag = document.getElementsByName('csrf-token')
const token = tokenTag.length ? tokenTag[0].getAttribute('content') : null
if (token) axios.defaults.headers.common['X-CSRF-Token'] = token
axios.defaults.headers.common['Accept'] = 'application/json'

export default axios
