import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'
import StartChat from './components/StartChat.vue'
import SignUp from './components/SignUp.vue'
import Login from './components/Login.vue'
import Setting from './components/Setting.vue'
import ChatRoom from './components/ChatRoom.vue'

import Store from './store.js'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      redirect: '/startchat',
      name: 'home',
      component: Home,
      children: [
        {
          path: '/startchat',
          name: 'startchat',
          component: StartChat,
          meta: {
            isPublic: true,
            afterAuth: true
          }
        },
        {
          path: '/signup',
          name: 'signup',
          component: SignUp,
          meta: {
            isPublic: true
          }
        },
        {
          path: '/login',
          name: 'login',
          component: Login,
          meta: {
            isPublic: true
          }
        },
        {
          path: '/setting',
          name: 'setting',
          component: Setting
        },
        {
          path: '/chatroom/:id',
          name: 'chatroom',
          component: ChatRoom
        }
      ]
    }
  ]
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(page => page.meta.isPublic)) {
    if (to.matched.some(page => page.meta.afterAuth)) {
      next()
    }else if(Store.getters['auth/isLogin'] === true){
      next('/startchat')
    }else{
      next()
    }
  } else {
    if(Store.getters['auth/isLogin'] === false) {
      next('/login')
    }else{
      next()
    }
  }
  if(to.path == '/chatroom/' + to.params.id){
    if(to.params.id == Store.getters['auth/getRoomId']){
      next()
    }else{
      next('/startchat')
    }
  }
})

export default router
