const apihost = process.env.APISERVER_HOST || '192.168.56.102'
const apiport = process.env.APISERVER_PORT || '30080'

console.log(process.env)

export default {
  host: apihost,
  port: apiport,
  getURL(method){
    return 'http://' + apihost + ':' + apiport + '/api/v1/' + method
  }
}
