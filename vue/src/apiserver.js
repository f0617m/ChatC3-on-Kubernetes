const apihost = process.env.APISERVER_HOST || 'chatc3.net'
const apiport = process.env.APISERVER_PORT || '32115'

console.log(process.env)

export default {
  host: apihost,
  port: apiport,
  getURL(method){
    return 'https://' + apihost + ':' + apiport + '/api/v1/' + method
  }
}
