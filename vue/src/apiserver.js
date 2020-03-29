const apihost = process.env.APISERVER_HOST || 'localhost'
const apiport = process.env.APISERVER_PORT || '80'

console.log(process.env)

export default {
  host: apihost,
  port: apiport,
  getURL(method){
    return 'http://' + apihost + ':' + apiport + '/api/v1/' + method
  }
}
