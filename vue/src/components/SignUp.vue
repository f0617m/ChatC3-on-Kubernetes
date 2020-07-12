<template>
  <v-content>
    <v-container fluid id="container">
      <v-row no-gutters id="row">
        <v-card width="600" class="mx-auto mb-auto" color="green lighten-5">
          <v-card-title>新規アカウント登録</v-card-title>
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
              v-model="user_name"
              label="*ユーザー名 1～16文字"
              :rules="[rules.required, rules.userNameLength]"
            ></v-text-field>
            <v-text-field
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              label="*パスワード 半角英数字 8～16文字"
              :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.passwordLength, rules.isHalfWidth]"
              @click:append="showPassword = !showPassword"
            ></v-text-field>
            <v-text-field
              v-model="confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              label="*パスワード(確認用) 半角英数字 8~16文字"
              :append-icon="showConfirmPassword ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.passwordLength, rules.confirmPassword, rules.isHalfWidth]"
              @click:append="showConfirmPassword = !showConfirmPassword"
            ></v-text-field>
            <v-btn
              class="mt-5"
              color="teal lighten-4"
              @click="createUser"
            >
              アカウント作成
            </v-btn>
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
  name: 'signup',
  data () {
    return {
      user_id: '',
      user_name: '',
      password: '',
      confirmPassword: '',
      showPassword: false,
      showConfirmPassword: false,
      image_name: "/user/default.png",
      rules: {
        required: v => !!v || '必須入力です',
        passwordLength: v => (v.length <= 16 && v.length >= 8) || 'パスワードは8～16文字以内に収めてください',
        userIdLength: v => (v.length <= 16 && v.length >= 8) || 'ユーザーIDは8～16文字以内に収めてください',
        userNameLength: v => (v.length <= 16) || 'ユーザー名は16文字以内に収めてください',
        confirmPassword: v => v === this.password || 'パスワードが一致していません',
        isHalfWidth: v => this.isHalfWidth(v) || '使用できるのは半角英数字のみです',
      },
      user_info: {
        user_id: this.user_id,
        name: this.user_name,
        image_name: this.image_name,
        password: this.password,
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
    createUser(){
      if(this.$refs.form.validate()){
        this.updateUserInfo()

        let formData = new FormData()

        fetch(this.image_name)
        .then(response => response.blob())
        .then(blob => new File([blob], "default.png"))
        .then(file => {
          this.user_info.image_name = file

          formData.append("user_id", this.user_info.user_id)
          formData.append("name", this.user_info.name)
          formData.append("image_name", file)
          formData.append("password", this.user_info.password)

          this.$store.dispatch('auth/create', formData)
          .then(response => this.signupSuccessful(response))
          .catch(error => this.signupFailed(error))

        })
      }
    },
    updateUserInfo(){
      this.user_info.user_id = this.user_id
      this.user_info.name = this.user_name
      this.user_info.password = this.password
    },
    showAlert(message, type){
      this.alert_data.message = message
      this.alert_data.type = type
    },
    signupSuccessful(response){
      this.showAlert('アカウント登録完了', 'success')
      if(this.$store.getters['auth/isLogin'] === true){
        this.$router.push('/startchat')
      }
    },
    signupFailed(error){
      this.showAlert(error.response.data[0], 'error')
    },
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
</style>
