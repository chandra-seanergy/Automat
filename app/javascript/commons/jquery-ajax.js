import Axios from "axios";
import CommonFunctions from 'commons/common_functions.js';

export default{
  getAll(url) {
    return Axios.get(CommonFunctions.url_with_domain(url), {
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  get(url) {
    return Axios.get(CommonFunctions.url_with_domain(url), {
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  post(url, data) {
    return Axios.post(CommonFunctions.url_with_domain(url), data, {
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  postMultipart(url, data) {
    return Axios.post(CommonFunctions.url_with_domain(url), data, {
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  updateMultipart(url,data){
    return Axios.put(CommonFunctions.url_with_domain(url),data,{
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  update(url,data){
    return Axios.put(CommonFunctions.url_with_domain(url),data,{
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  delete(url,data) {
    return Axios.delete(CommonFunctions.url_with_domain(url),data, {
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  },

  patch(url,data){
    return Axios.patch(CommonFunctions.url_with_domain(url),data,{
      headers: {
        authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    });
  }
}