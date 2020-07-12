<template>
  <div class="chat-board">
    <div class="chat-container">
      <div class="item" v-for="message in messages">
        <div class="ownerMessage" v-if="isOwner(message.user_id)">
          <div class="message_detail_left">
            <div class="user_message_left">
              {{message.message}}
            </div>
          </div>
          <div class="user_detail">
            <div class="user_icon"><img :src="message.image_name" width="40" height="40"/></div>
            <div class="user_name">{{message.user_name}}</div>
          </div>
        </div>
        <div class="partnerMessage" v-if="!isOwner(message.user_id)">
          <div class="user_detail">
            <div class="user_icon"><img :src="message.image_name" width="40" height="40"/></div>
            <div class="user_name">{{message.user_name}}</div>
          </div>
          <div class="message_detail_right">
            <div class="user_message_right">
              {{message.message}}
            </div>
          </div>
        </div>
      </div>
    </div>

    <v-form class="typer">
      <v-textarea
        v-model="content"
        :rules="[rules.messageLength]"
        class="pa-10"
        rows="1"
        append-icon="mdi-send"
        @click:append="sendMessage(content)"
        v-on:keydown.enter.exact.prevent="sendMessage(content)"
        >
      </v-textarea>
    </v-form>

  </div>
</template>

<script>
export default {
  data () {
    return {
      content: '',
      chatMessages: [],
      rules: {
        messageLength: v => (v.length <= 100) || 'メッセージは100文字以内に収めてください',
      },
    }
  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
  },
  computed: {
    username (){
      return this.$store.getters['auth/getName']
    },
    userid(){
      return this.$store.getters['auth/getUserId']
    },
    imagename(){
      let url = this.$store.getters['auth/getImageName']
      if(url){
        let index = url.indexOf('/public')
        url = url.substring(index)
        url = decodeURI(url)
        return url
      }
    },
    token(){
      return this.$store.getters['auth/getToken']
    },
    messages(){
      return this.chatMessages
    },
  },
  methods: {
    sendMessage(content){
      if(this.content.length > 100){
        return
      }

      if(content.trim() == ''){
        return
      }

      this.$axios.post(this.$api.getURL('sendMessage'), {
        message: content,
        user_id: this.userid,
        user_name: '',
        image_name: '',
        room_id: this.$route.params['id']
      })
      .then(response => {
        this.content = ''
      })
      .catch(error => {
      });
    },
    addMessage(message){
      let url = message.image_name.url
      if(url){
        let index = url.indexOf('/user')
        url = url.substring(index)
        url = decodeURI(url)
        message.image_name = url
      }
      this.chatMessages.push(message)
      this.scrollToEnd()
    },
    isOwner(user_id){
      if(user_id == this.userid){
        return true
      }else{
        return false
      }
    },
    scrollToEnd () {
        this.$nextTick(() => {
          var container = this.$el.querySelector('.chat-container')
          container.scrollTop = container.scrollHeight
        })
    },
  }
}
</script>

<style>
.chat-board{
  width: 400px;
}
.chat-container{
  box-sizing: border-box;
  height: calc(100vh - 12rem);
  width: 400px;
  overflow-y: auto;
  padding: 10px;
  background-color: #f2f2f2;
}
.item{
  position:relative;
  display: flex;
  align-items: flex-end;
  margin-bottom: 0.8em;
}
.ownerMessage{
  margin:0 0 0 auto;
  display: flex;
}
.partnerMessage{
  margin:0 auto 0 0;
  display: flex;
}
.user_icon img{
  border-radius: 20px;
  vertical-align: top;
}
.message_detail_right{
  margin: 0 0 0 1.4em;
}
.message_detail_left{
  margin: 0 1.4em 0 0;

}
.user_name{
  font-size: 70%;
}
.user_message_right,
.user_message_left{
  position: relative;
  padding: 0.8em;
  background: #deefe8;
  border-radius: 4px;
  line-height: 1.2em;
  word-break: break-all;
}
.user_message_right::before {
  position: absolute;
  content: " ";
  left: -16px;
  top: 14px;
  border: 4px solid transparent;
  border-right: 12px solid #deefe8;
}
.user_message_left::before {
  position: absolute;
  content: " ";
  display: block;
  right: -16px;
  top: 14px;
  border: 4px solid transparent;
  border-left: 12px solid #deefe8;
}
.typer{
  box-sizing: border-box;
  display: flex;
  align-items: center;
  bottom: 0;
  height: 4.9rem;
  width: 100%;
  background-color: #ffcce8;
}

</style>
