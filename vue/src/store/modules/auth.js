import axios from 'axios'

export default{
  namespaced: true,
  state: {
    user_id: '',
    name: '',
    room_id: '',
    image_name: '',
    token: ''
  },
  getters: {
    isLogin (state) {
      return state.token ? true : false
    },
    getUserId (state) {
      return state.user_id
    },
    getName (state) {
      return state.name
    },
    getRoomId (state) {
      return state.room_id
    },
    getImageName (state) {
      return state.image_name
    },
    getToken (state) {
      return state.token
    },
  },
  mutations: {
    create (state, data) {
      state.user_id = data.data.user_id
      state.room_id = data.data.room_id
      state.name = data.data.name
      state.image_name = data.data.image_name.url
      state.token = data.data.token
    },
    login (state, data) {
      state.user_id = data.data.user_id
      state.room_id = data.data.room_id
      state.name = data.data.name
      state.image_name = data.data.image_name.url
      state.token = data.data.token
    },
    logout (state) {
      state.user_id = ''
      state.room_id = ''
      state.name = ''
      state.image_name = ''
      state.token = ''
    },
    setRoomId (state, roomid) {
      state.room_id = roomid
    },
    setName (state, name){
      state.name = name
    },
    setImageName(state, imagename){
      state.image_name = imagename
    }
  },
  actions: {
    create ({ commit }, data){
      console.log(data)
      return new Promise((resolve, reject) => {
        axios.post('http://192.168.56.102:3000/api/v1/users', data
        ).then(response => {
          console.log(response)
          commit('create', response)
          resolve(response)
        }).catch(error => {
          reject(error)
        });
      })
    },
    login ({ commit }, data){
      return new Promise((resolve, reject) => {
        axios.post('http://192.168.56.102:3000/api/v1/login', data
        ).then(response => {
          commit('login', response)
          resolve(response)
        }).catch(error => {
          console.log(error)
          reject(error)
        });
      })
    },
    tokenLogin ({ commit }, data){
      return new Promise((resolve, reject) => {
        axios.post('http://192.168.56.102:3000/api/v1/tokenLogin', data
        ).then(response => {
          commit('login', response)
          resolve(response)
        }).catch(error => {
          console.log(error)
          reject(error)
        });
      })
    },
    logout ({ commit }){
      commit('logout')
    },
    setRoomId ({ commit }, user_id) {
      commit('setRoomId', user_id)
    },
    setName({ commit }, name){
      commit('setName', name)
    },
    setImageName({ commit }, image_name){
      image_name = decodeURI(image_name)
      commit('setImageName', image_name)
    },
  }
}
