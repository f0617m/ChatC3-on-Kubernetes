<template>
  <v-content>
    <v-container fluid id="container">
      <v-row no-gutters id="row">
        <v-card width="700" class="mx-auto mb-auto" color="green lighten-5">
          <v-card-title>プロフィール設定</v-card-title>
          <v-alert :color="alert_data.type" v-if="alert_data.type">
              {{ alert_data.message }}
          </v-alert>
          <v-divider :inset="inset"></v-divider>

          <div class="forms">
            <v-form class="setting_form ml-10 mb-1" ref="form">
              プロフィール画像
              <div class="user_image">
                <div>
                  <img id="user-image" :src="be_imagename" width="130" height="130"/>
                </div>
                <div class="image_buttons">
                  <label class="file_button">ファイルを選択
                    <input type="file" accept="image/*" @change="onFileChange" style="display:none;" />
                  </label>
                  <button type="button" class="reset_button" @click="resetImage" >プロフィール画像を初期化する</button>
                </div>
              </div>
            </v-form>

            <v-form class="confirm_form" ref="form">
                  <button type="button" class="confirm_button" @click="updateImage" :disabled="!imageButton">内容を更新</button>
            </v-form>
          </div>

          <v-divider :inset="inset"></v-divider>

          <div class="forms">
            <v-form class="setting_form ml-10 mb-1" ref="nameform" @submit.prevent>
              ユーザ名
              <div class="user_name">
                <v-text-field
                  v-model="username"
                  label="*1～16文字"
                  :rules="[rules.required, rules.userNameLength]"
                  @change="onNameChange"
                ></v-text-field>
              </div>
            </v-form>

            <v-form class="confirm_form" ref="form">
                  <button type="button" class="confirm_button" @click="updateName" :disabled="!nameButton">内容を更新</button>
            </v-form>
          </div>

          <v-divider :inset="inset"></v-divider>

          <div class="forms">
            <v-form class="setting_form ml-10 mb-1" ref="passwdform" @submit.prevent>
              現在のパスワード
              <div class="user_password">
                <v-text-field
                  v-model="be_password"
                  :type="be_showPassword ? 'text' : 'password'"
                  label="*半角英数字 8～16文字"
                  :append-icon="be_showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.passwordLength, rules.isHalfWidth]"
                  @click:append="be_showPassword = !be_showPassword"
                  @change="onPasswordChange"
                ></v-text-field>
              </div>

                新しいパスワード
              <div class="user_password">
                <v-text-field
                  v-model="af_password"
                  :type="af_showPassword ? 'text' : 'password'"
                  label="*半角英数字 8~16文字"
                  :append-icon="af_showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[rules.required, rules.passwordLength, rules.isHalfWidth]"
                  @click:append="af_showPassword = !af_showPassword"
                  @change="onPasswordChange"
                ></v-text-field>
              </div>

              新しいパスワード(確認用)
            <div class="user_password">
              <v-text-field
                v-model="af_confirmPassword"
                :type="af_showConfirmPassword ? 'text' : 'password'"
                label="*半角英数字 8~16文字"
                :append-icon="af_showConfirmPassword ? 'mdi-eye' : 'mdi-eye-off'"
                :rules="[rules.required, rules.passwordLength, rules.confirmPassword, rules.isHalfWidth]"
                @click:append="af_showConfirmPassword = !af_showConfirmPassword"
                @change="onPasswordChange"
              ></v-text-field>
            </div>
            </v-form>

            <v-form class="confirm_form" ref="form">
                  <button type="button" class="confirm_button" @click="updatePassword" :disabled="!passwordButton">内容を更新</button>
            </v-form>
          </div>
        </v-card>

        <v-dialog v-model="updateDialog.isShow" persistent max-width="300">
          <v-card>
            <v-card-title class="headline">{{ updateDialog.title }}</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn
                color="green"
                text
                @click="updateDialog.isShow = false"
              >
                OK
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
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
  name: 'setting',
  data () {
    return {
      be_password: '',
      af_password: '',
      af_confirmPassword: '',
      be_showPassword: false,
      af_showPassword: false,
      af_showConfirmPassword: false,
      inset: false,
      imageButton: false,
      nameButton: false,
      passwordButton: false,
      rules: {
        required: v => !!v || '必須入力です',
        passwordLength: v => (v.length <= 16 && v.length >= 8) || 'パスワードは8～16文字以内に収めてください',
        userIdLength: v => (v.length <= 16 && v.length >= 8) || 'ユーザーIDは8～16文字以内に収めてください',
        userNameLength: v => (v.length <= 16) || 'ユーザー名は16文字以内に収めてください',
        confirmPassword: v => v === this.af_password || 'パスワードが一致していません',
        isHalfWidth: v => this.isHalfWidth(v) || '使用できるのは半角英数字のみです',
      },
      af_username: '',
      af_imagename: '',
      updateDialog: {
        isShow: false,
        title: '更新に成功しました',
      },
      alert_data: {
        message: '',
        type: null,
      },
    }
  },
  mounted(){
  },
  created(){
    this.$axios.defaults.headers.common['Authorization'] = "Token " + this.token;
  },
  computed: {
    be_username (){
      return this.$store.getters['auth/getName']
    },
    username: {
      get: function () {
        if(this.af_username){
          return this.af_username
        }else{
          return this.be_username
        }
      },
      set: function (val) {
        this.af_username = val
      }
    },
    userid(){
      return this.$store.getters['auth/getUserId']
    },
    be_imagename(){
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
    defaultimage(){
      return "/user/default.png"
    },
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
    onFileChange(e){
      let files = e.target.files || e.dataTransfer.files

      let reader = new FileReader()
      reader.readAsDataURL(files[0])
      reader.onload = (e) => {
        var img = document.getElementById('user-image')
        img.src = reader.result
        this.imageButton = true
        this.af_imagename = files[0]
      }
    },
    onNameChange(e){
      if(this.be_username != e && this.$refs.nameform.validate()){
        this.nameButton = true
      }else{
        this.nameButton = false
      }
    },
    onPasswordChange(){
      if(this.$refs.passwdform.validate()){
        this.passwordButton = true
      }else{
        this.passwordButton = false
      }
    },
    resetImage(){
      let answer = window.confirm('プロフィール画像を初期化してもよいですか？')
      let reader = new FileReader()

      if(answer){
        fetch(this.defaultimage)
        .then(response => response.blob())
        .then(blob => new File([blob], "default.jpg"))
        .then(file => {

          reader.readAsDataURL(file)
          reader.onload = (e) => {
            var img = document.getElementById('user-image')
            img.src = reader.result
            this.imageButton = true;
            this.af_imagename = file
          }

        })
      }
    },
    uploadImage(file){
      let formData = new FormData()

      formData.append("user_id", this.userid)
      formData.append("image_name", file)
      this.$axios.post(this.$api.getURL('uploadImage'),formData)
      .then(response => {
        this.imageButton = false;
        this.setImage(response.data.image_name.url)
        this.updateDialog.isShow = true
      })
      .catch(error => {
      });
    },
    setImage(image_url){
      this.$store.dispatch('auth/setImageName', image_url)
      .then(
        response => {
        }
      )
      .catch(
        error => {
        }
      )
    },
    setName(name){
      this.$store.dispatch('auth/setName', name)
      .then(
        response => {
        }
      )
      .catch(
        error => {
        }
      )
    },
    updateImage(){
      let answer = window.confirm('プロフィール画像を更新してもよいですか？')

      if(answer){
        this.uploadImage(this.af_imagename)
      }
    },
    updateName(){
      let answer = window.confirm('ユーザ名を更新してもよいですか？')

      if(answer){
        this.$axios.post(this.$api.getURL('updateName'),{
          user_id: this.userid,
          name: this.af_username
        })
        .then(response => {
          this.nameButton = false;
          this.setName(response.data.name)
          this.updateDialog.isShow = true
        })
        .catch(error => {
        });
      }
    },
    updatePassword(){
      let answer = window.confirm('パスワードを更新してもよいですか？')

      if(answer){
        this.$axios.post(this.$api.getURL('checkPassword'),{
          user_id: this.userid,
          password: this.be_password
        })
        .then(response => {
          this.$axios.post(this.$api.getURL('updatePassword'),{
            user_id: this.userid,
            password: this.af_password
          })
          .then(response => {
            this.passwordButton = false
            this.be_password = ''
            this.af_password = ''
            this.af_confirmPassword = ''
            this.updateDialog.isShow = true
          })
          .catch(error => {
          });
        })
        .catch(error => {
          this.showAlert('現在のパスワードが異なっています', 'error')
        });
      }
    },
    showAlert(message, type){
      this.alert_data.message = message
      this.alert_data.type = type
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
.forms{
  display: flex;
}
.setting_form{
  width: 420px;
  margin: 1em 0em 0em 0em;
}
.confirm_form{
  width: 150px;
  margin: 0 0 0 auto;
}
.user_image{
  display: flex;
  margin: 0.5em 0em 2em 1em;
}
.image_buttons{
}
.file_button{
  margin: 0.5em;
  padding: 0.3em;
  text-align: center;
  border: 0.1px solid #ccc;
  box-shadow: 1px 1px 2px #ccc;
  background: #e0e0e0;
}
.reset_button{
  font-size: 12px;
  margin: 2em 0em 0em 0.5em;
  padding: 0.3em;
  text-align: center;
  border: 0.1px solid #ccc;
  box-shadow: 1px 1px 2px #ccc;
  background: #e0e0e0;
}
.user_name{
  margin: 0.5em 0em 2em 1em;
}
.user_password{
  margin: 0.5em 0em 2em 1em;
}
.confirm_button{
  margin: 0.5em;
  padding: 0.3em;
  text-align: center;
  border: 0.1px solid #ccc;
  box-shadow: 1px 1px 2px #ccc;
  background: #e0e0e0;
}
button[type="button"][disabled]{
    background:#808080;
    color: #a9a9a9;
}
</style>
