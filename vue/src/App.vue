<template>
  <v-app>
    <router-view/>
  </v-app>
</template>

<script>

export default {
  name: 'App',

  mounted(){

  },
  created(){
    this.loadLocalStorage()
  },

  methods: {
    loadLocalStorage(){
      if (localStorage.getItem('ChatC3')) {
          const strageData = JSON.parse(localStorage.getItem('ChatC3'));
          if (strageData.auth.token) {
              this.$axios.defaults.headers.common['Authorization'] = "Token " + strageData.auth.token;
              this.$store.dispatch('auth/tokenLogin', {
                token: strageData.auth.token
              })
              .then(response => {
                console.log(response)
              })
              .catch(error => {
                //console.log(error)
              })
          }
      }
    }
  },

}
</script>
