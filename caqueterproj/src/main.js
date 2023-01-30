import Vue from 'vue'
import VueSession from 'vue-session'
import BootstrapVue from 'bootstrap-vue'
import App from './App.vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'




Vue.config.productionTip = true

Vue.use(BootstrapVue)
Vue.use(VueSession)

new Vue({
  render: h => h(App),
}).$mount('#app')
