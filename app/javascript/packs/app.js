/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'app' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import '../stylesheets/application.scss'
import Rails from 'rails-ujs'
// import Turbolinks from 'turbolinks'
import '../legacy'
import '../vue/instances'

Rails.start()
// Turbolinks.start()

// require.context('../../assets/images', true, /\.(svg | png)$/im)
