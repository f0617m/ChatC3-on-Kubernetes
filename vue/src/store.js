import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from "vuex-persistedstate"

import auth from './store/modules/auth'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    auth,
  },
  plugins: [createPersistedState({
        key: 'ChatC3',
        paths: ['auth.token'],
        storage: window.localStorage
  })]
})
