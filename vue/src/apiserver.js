const apihost = process.env.VUE_APP_APISERVER_HOST
const apiport = process.env.VUE_APP_APISERVER_PORT

console.log(process.env)

export default {
  host: apihost,
  port: apiport,
  getURL(method){
    return 'https://' + apihost + ':' + apiport + '/api/v1/' + method
  }
}
