<template>
  <v-content>
    <v-container fluid id="container">
      <v-row no-gutters id="row">
        <v-card width="400" class="mx-auto mb-auto" color="green lighten-5">
          <v-card-title>知らない誰かと、チャットしよう</v-card-title>
          <v-img  :src="image_name"/>
          <v-card-text v-if="isLogin">「チャット相手を探す」をクリックすると、知らない誰かとチャットが開始されます。
          </v-card-text>
          <v-card-text v-if="!isLogin">チャットをするにはアカウントにログインする必要があります。
            <br>アカウントを持っていない場合は、ゲストアカウントでログインすることができます。
          </v-card-text>
          <v-card-actions justify-center>
            <v-btn
              class="ma-2"
              color="success"
              @click="findRoom"
              v-if="isLogin"
            >
              チャット相手を探す
            </v-btn>
            <v-btn
              class="ma-2"
              color="success"
              to="/login"
              v-if="!isLogin"
            >
              ログインする
            </v-btn>
          </v-card-actions>
          <div v-if="!isLogin">
            <v-divider class="mx-4"></v-divider>
            <v-card-text>自分のアカウントを作りませんか？アカウント登録をすると、好きな名前やプロフィール画像を設定することができます。
            </v-card-text>
            <v-card-actions justify-center>
              <v-btn
                class="ma-2"
                color="teal lighten-4"
                to="/signup"
              >
                アカウント登録を行う
              </v-btn>
            </v-card-actions>
          </div>
        </v-card>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
export default {
  name: 'startchat',
  data () {
    return {
      image_name: require("@/assets/people001.png")
    }
  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
  },
  computed: {
    isLogin(){
      return this.$store.getters['auth/isLogin']
    },
    token(){
      return this.$store.getters['auth/getToken']
    },
  },
  methods: {
    findRoom(){
      this.$axios.get('http://192.168.56.102:3000/api/v1/getRoom')
      .then(response => {
        if(response.data == null){
          this.createRoom()
        }else{
          this.joinRoom(response.data.id)
        }
      })
      .catch(error => {
        console.log(error)
      })
    },
    createRoom(){
      this.$axios.post('http://192.168.56.102:3000/api/v1/rooms', {
        room: {
          status: 'Waiting'
        }
      })
      .then(response => {
        if(response.data != null){
          this.joinRoom(response.data.id)
        }
      })
      .catch(error => {
        console.log(error)
      })
    },
    joinRoom(roomId){
        this.$axios.post('http://192.168.56.102:3000/api/v1/setRoomId', {
          user_id: this.$store.getters['auth/getUserId'],
          room_id: roomId
        })
        .then(response => {
          this.$store.dispatch('auth/setRoomId', roomId)
          .then(
            response => {
              this.$router.push('/chatroom/' + roomId)
            }
          )
          .catch(
            error => {
              console.log(error)
            }
          )
        })
        .catch(error => {
          console.log(error)
        })
    },
  }
}
</script>

<style>
#container {
  width: 100%;
  height: 100%
}
#row {
  width: 100%;
  height: 100%
}
#col {
  width: 100%;
  height: 100%
}
</style>
