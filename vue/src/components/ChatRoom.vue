<template>
  <v-content class="content">
    <v-container class="room-board" fluid fill-height>
      <v-layout>
        <div class="draw-board">
          <draw ref="draw"></draw>
        </div>
        <div class="chat-board">
          <chat ref="chat"></chat>
        </div>
      </v-layout>
    </v-container>

    <v-dialog v-model="matchingDialog.isShow" persistent max-width="500">
      <v-card>
        <v-card-title class="headline">{{ matchingDialog.title }}</v-card-title>
        <v-card-text>
          {{ matchingDialog.text }}
          <v-progress-circular
            :size="40"
            color="purple"
            indeterminate
          ></v-progress-circular>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="green"
            text
            @click="exitRoom()"
          >
            退室する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="exitDialog.isShow" persistent max-width="300">
      <v-card>
        <v-card-title class="headline">{{ exitDialog.title }}</v-card-title>
        <v-card-text>
          {{ exitDialog.text }}
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="green"
            text
            @click="exitRoom()"
          >
            OK
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

  </v-content>
</template>

<script>
import Vue from 'vue'
import Axios from 'axios'
import VueAxios from 'vue-axios'
import ActionCable from 'actioncable'

const axios = Axios
Vue.prototype.$axios = axios

const cable = ActionCable.createConsumer('ws:192.168.56.102:3000/cable')
Vue.prototype.$cable = cable

Vue.use(VueAxios, Axios)

import Draw from './Draw.vue'
import Chat from './Chat.vue'

function getMessages(){
}
function invalidDialog(){
}
function addMessage(){
}
function drawLine(){
}
function exitConfirm(){
}
function sendMessage(){
}

let username

export default {
  name: 'chatroom',
  props: ['key1'],
  components: {
    Draw,
    Chat
  },
  data () {
    return {
      drawer: null,
      roomChannel: null,
      contents: [
        {title: 'Paint', icon: 'mdi-brush'},
        {title: 'Game', icon: 'mdi-gamepad-variant-outline'},
        {title: 'Video', icon: 'mdi-youtube'}
      ],
      menus: [
        {title: 'Menu1', icon: 'mdi-help-circle-outline'},
        {title: 'Menu2', icon: 'mdi-help-circle-outline'},
        {title: 'Menu3', icon: 'mdi-help-circle-outline'},
        {title: 'Menu4', icon: 'mdi-help-circle-outline'}
      ],
      exitDialog: {
        isShow: false,
        title: 'チャット相手が退室したため、開始画面に戻ります',
        text: '次のチャット相手を探しましょう',
      },
      matchingDialog: {
        isShow: true,
        title: 'チャット相手を探しています',
        text: '相手が見つかるまでしばらく時間がかかる可能性があります',
      },
    }
  },
  computed: {
    userid(){
      return this.$store.getters['auth/getUserId']
    },
    username (){
      return this.$store.getters['auth/getName']
    },
    token(){
      return this.$store.getters['auth/getToken']
    },

  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
    this.key1.updateContents(this.contents)
    this.key1.updateViewNav(true)
  },
  mounted() {
    //this.getMessages()
    //this.getStrokes()
    getMessages = this.getMessages
    invalidDialog = this.invalidDialog
    drawLine = this.drawLine
    addMessage = this.addMessage
    exitConfirm = this.exitConfirm
    sendMessage = this.sendMessage
    username = this.username
    this.createChannel()
  },
  beforeRouteLeave (to, from, next) {
    console.log(to)
    console.log(to.query['skip'])
    console.log(from)

    var answer;

    if(to.query['skip']){
      this.removeChannel()
      next()
    }else{
      answer = window.confirm('退室しますか？\n※退室すると同じチャットルームには戻れません')
    }

    if(answer){
      this.removeChannel()
      next()
    }else{
      next(false)
    }

  },
  methods: {
    createChannel(){
      this.roomChannel = cable.subscriptions.create(
        { channel: "RoomChannel", room_id: this.$route.params['id'], user_id: this.userid},
        {
          connected: function(){
            fetch(getMessages())
            .then(response => {
              sendMessage('[' + username + ']さんが入室しました')
            })
          },
          received: function(data) {

            console.log('received')
            console.log(data)
            if(data['action'] == "start"){
              invalidDialog()
            }
            if(data['action'] == "talk"){
              addMessage(data)
            }
            if(data['action'] == "draw"){
              drawLine(data['user_id'], data['data'].fromx, data['data'].fromy, data['data'].tox, data['data'].toy, data['data'].color, data['data'].width);
            }
            if(data['action'] == "remove"){
              exitConfirm()
            }
          },
        }
      )
    },
    removeChannel(){
      if (this.roomChannel){
        cable.subscriptions.remove(this.roomChannel)
      }
    },
    getMessages(){
      this.$axios.get('http://192.168.56.102:3000/api/v1/getMessages/' + this.$route.params['id'])
      .then(response => {
        this.loadMessages(response.data)
      })
      .catch(error => {
        console.log(error)
      })
    },
    loadMessages(messages){
      messages.forEach(function(value){
        addMessage(value);
      })
    },
    addMessage(value) {
      this.$refs.chat.addMessage(value);
    },
    sendMessage(content) {
      this.$refs.chat.sendMessage(content);
    },
    getStrokes(){
      this.$axios.get('http://192.168.56.102:3000/api/v1/getStroke/' + this.$route.params['id'])
      .then(response => {
        this.loadStrokes(response.data)
      })
      .catch(error => {
        console.log(error)
      })
    },
    loadStrokes(strokes){
      strokes.forEach(function(value){
        drawLine('dummy', value['prevx'], value['prevy'], value['currx'], value['curry'], value['color'], value['width']);
      })
    },
    drawLine(user_id, fromx, fromy, tox, toy, color, width) {
      if(user_id != this.userid){
        this.$refs.draw.drawLine(fromx, fromy, tox, toy, color, width);
      }
    },
    invalidDialog(){
      this.matchingDialog.isShow = false
    },
    exitConfirm(){
      this.exitDialog.isShow = true
    },
    exitRoom(){
      this.$router.push({path: '/startchat', query: { skip : true}})
    },
  },
  name: 'chatroom'
}
</script>

<style>
.content{
  overflow: hidden;
  height: 100vh;
}
.room-board{

}
.draw-board{
  flex: 2;
  //overflow-y:scroll;
  margin: 0 1em 0 1em;
}
.chat-board{
  flex: 1;
}
</style>
