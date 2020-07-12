<template>
  <v-content>
    <v-container fluid id="container">
      <v-row no-gutters id="row">
        <v-card width="600" class="mx-auto mb-auto" color="green lighten-5">
          <v-card-title>ログイン</v-card-title>
          <v-alert :color="alert_data.type" v-if="alert_data.type">
              {{ alert_data.message }}
          </v-alert>
          <v-form class="signup_form ml-10 mb-10" ref="form">
            <v-text-field
              v-model="user_id"
              label="*ユーザーID 半角英数字 8～16文字"
              :rules="[rules.required, rules.userIdLength, rules.isHalfWidth]"
            ></v-text-field>
            <v-text-field
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              label="*パスワード 半角英数字 8～16文字"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.passwordLength, rules.isHalfWidth]"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
            <div class="login_buttons">
              <div class="login_button">
                <v-btn
                  class="mt-5"
                  color="teal lighten-4"
                  @click="loginUser"
                >
                  ログイン
                </v-btn>
              </div>
              <div class="guest_button">
                <v-btn
                  class="mt-5 guest_button"
                  color="teal lighten-4"
                  @click="loginGuest"
                >
                  ゲストログイン
                </v-btn>
              </div>
            </div>
          </v-form>
        </v-card>
      </v-row>
    </v-container>
  </v-content>
</template>

<script>
import Vue from 'vue'
import Axios from 'axios'
import VueAxios from 'vue-axios'

const axios = Axios
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
Vue.prototype.$axios = axios

Vue.use(VueAxios, Axios)

export default {
  name: 'login',
  data () {
    return {
      user_id: '',
      password: '',
      showPassword: false,
      rules: {
        required: v => !!v || '必須入力です',
        passwordLength: v => (v.length <= 16 && v.length >= 8) || 'パスワードは8～16文字の間です',
        userIdLength: v => (v.length <= 16 && v.length >= 8) || 'ユーザーIDは8～16文字の間です',
        isHalfWidth: v => this.isHalfWidth(v) || '使用できるのは半角英数字のみです',
      },
      user_info: {
        user_id: this.user_id,
        password: this.password,
      },
      guest_info: {
        user_id: '',
        name: 'ゲスト',
        image_name: "/user/default.png",
        password: '',
      },
      alert_data: {
        message: '',
        type: null,
      },
    }
  },
  mounted(){
    this.updateUserInfo()
  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
  },
  methods: {
    isHalfWidth(str) {
      str = (str==null)? "":str
      if(str.match(/^[A-Za-z0-9]*$/)){
        return true
      }else{
        return false
      }
    },
    loginUser(){
      if(this.$refs.form.validate()){
        this.updateUserInfo()

        this.$store.dispatch('auth/login', this.user_info)
        .then(response => this.loginSuccessful(response))
        .catch(error => this.loginFailed(error))
      }
    },
    loginGuest(){
      let formData = new FormData()
      let date_str = this.getDateString()

      fetch(this.guest_info.image_name)
      .then(response => response.blob())
      .then(blob => new File([blob], "default.png"))
      .then(file => {
        this.guest_info.user_id = date_str
        this.guest_info.password = date_str

        formData.append("user_id", this.guest_info.user_id)
        formData.append("name", this.guest_info.name)
        formData.append("image_name", file)
        formData.append("password", this.guest_info.password)

        this.$store.dispatch('auth/create', formData)
        .then(response => {
          this.$store.dispatch('auth/login', this.guest_info)
          .then(response => this.loginSuccessful(response))
          .catch(error => this.loginFailed(error))
        })
        .catch(error => {
          this.loginFailed(error)
        })

      })
    },
    updateUserInfo(){
      this.user_info.user_id = this.user_id
      this.user_info.password = this.password
    },
    showAlert(message, type){
      this.alert_data.message = message
      this.alert_data.type = type
    },
    loginSuccessful(response){
      this.showAlert('ログイン成功', 'success')
      if(this.$store.getters['auth/isLogin'] === true){
        this.$router.push('/startchat')
      }
    },
    loginFailed(error){
      this.showAlert(error.response.data, 'error')
    },
    getDateString(){
      let date = new Date()
      let yyyy = date.getFullYear()
      let mm = this.toDoubleDigits(date.getMonth() + 1)
      let dd = this.toDoubleDigits(date.getDate())
      let hh = this.toDoubleDigits(date.getHours())
      let mi = this.toDoubleDigits(date.getMinutes())
      let ss = this.toDoubleDigits(date.getSeconds())
      let ms = this.toDoubleDigits(date.getMilliseconds(2))

      return "" + yyyy + mm + dd + hh + mi + ss + ms
    },
    toDoubleDigits(num){
      num += ""

      if(num.length === 1){
        num = "0" + num
      }else if(num.length > 2){
        num = num.substr(1, 2)
      }
      return num
    }
  },
}
</script>

<style>
#container {
  width: 100%;
  height: 100%;
}
#row {
  width: 100%;
  height: 100%;
}
#col {
  width: 100%;
  height: 100%;
}
.signup_form{
  width: 400px;
}
.login_buttons{
  display: flex;
}
.guest_button{
  margin: 0 0 0 auto;
}
</style>
