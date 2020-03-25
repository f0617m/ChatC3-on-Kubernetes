const apihost = process.env.APISERVER_HOST || 'rails'
const apiport = process.env.APISERVER_PORT || '3000'

export default {
  host: apihost,
  port: apiport,
  getURL(method){
    return 'http://' + apihost + ':' + apiport + '/api/v1/' + method
  }
}
