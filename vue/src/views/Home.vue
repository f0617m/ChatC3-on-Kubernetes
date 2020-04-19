<template>
  <v-app id="inspire">
    <v-navigation-drawer
      v-if="isViewNav"
      v-model="drawer"
      app
      clipped
    >
      <v-list dense nav>
        <v-list-item
          v-for="content in contents"
          :key="content.title"
          link
          :to="content.link"
        >
          <v-list-item-icon>
            <v-icon>{{ content.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ content.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar
      app
      clipped-left
      color="orange lighten-1"
      dark
    >
      <v-app-bar-nav-icon v-if="isViewNav" @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <router-link id="routerLink" to="/">
        <v-toolbar-title class="white--text">Chat-C3</v-toolbar-title>
      </router-link>
      <div class="flex-grow-1"></div>
      <router-link v-if="isLogin" id="routerLink" to="/setting" class="white--text">
        {{ username }}さん
      </router-link>
      <router-link v-if="!isLogin" id="routerLink" to="/login" class="white--text">
        <v-icon>mdi-login</v-icon>
        ログイン
      </router-link>
      <v-menu
        left
        bottom
      >
        <template v-slot:activator="{ on }">
          <v-btn icon v-on="on">
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list dense nav>
          <v-list-item
            v-for="menu in menus"
            :key="menu.title"
            link
            @click="SelectMethods(menu.event)"
          >
            <v-list-item-icon>
              <v-icon>{{ menu.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ menu.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>

    <router-view :key1="this"></router-view>

  </v-app>
</template>

<script>
import Vue from 'vue'
import Axios from 'axios'
import VueAxios from 'vue-axios'
import Apiserver from '../apiserver.js'

const axios = Axios
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
Vue.prototype.$axios = axios

const api = Apiserver
Vue.prototype.$api = api

Vue.use(VueAxios, Axios)

export default {
  data () {
    return {
      isLogin: this.$store.getters['auth/isLogin'],
      drawer: null,
      isViewNav: false,
      originalcontents: [
        {title: 'チャット相手を探す', icon: 'mdi-chat', link: '/chatroom'},
        {title: 'チャット相手を探す2', icon: 'mdi-chat',},
      ],
      contents: [],
      menus: [
        {title: 'ユーザ設定', icon: 'mdi-face', event: 'setting'},
        {title: 'ログアウト', icon: 'mdi-logout', event: 'logout'}
      ]
    }
  },
  created () {
    this.$vuetify.theme.light = true
    this.contents = this.originalcontents
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
    console.log(process.env)
  },
  beforeRouteUpdate (to, from, next) {
    //再描画前のアクション
    next();
    //再描画後のアクション
    this.updateContents(this.originalcontents)
    this.updateViewNav(false)
    this.isLogin = this.$store.getters['auth/isLogin']
    this.userName = this.$store.getters['auth/getName']
  },
  computed: {
    username(){
      return this.$store.getters['auth/getName']
    },
    token(){
      return this.$store.getters['auth/getToken']
    },
  },
  methods: {
    updateContents(contents) {
      this.contents = contents
    },
    updateViewNav(isView) {
      this.isViewNav = isView
    },
    SelectMethods(method){
      if(method == 'logout'){
        this.logout()
      }else if(method == 'setting'){
        this.setting()
      }
    },
    setting(){
      this.$router.push('/setting')
    },
    logout(){
      this.$store.dispatch('auth/logout')
      this.$router.push('/login')
    },
  },
}
</script>

<style>
#routerLink {
  text-decoration: none;
}
</style>
