<template>
  <div>
    <div class="message-div success-message message-forgot-success" :class="{spnHide:EnableSuccess}">
      {{successmessage}}
    </div>
    <div class="message-div success-message message-forgot-error" :class="{spnHide:EnableError}">
      {{errormessage}}
    </div>
    <div class="login-reg-label">
      Email
    </div>
    <div class="login-reg-input-div">
      <input type="text" class="default-text-input" name="email" v-model="user.email">
      <p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:user.email }">Please enter Email</p>
      <p class="validation-error" v-if="isEmailValid()">Please enter valid Email</p>
    </div>
    <div class="row margin-top-16">
      <input type="button" class="default-btn" value="Reset Password" @click="fnResetPassword">
      <div class="text-center loader" v-if="Loader">
        <b-spinner variant="primary" label="Text Centered"></b-spinner>
      </div>
    </div>
    <div class="row margin-top-16">
      <div class="login-reg-label">Already have login and password? <span class="anchor-btn-color"  @click="fnLogin">Sign in</span></div>
    </div>
  </div>
</template>
<script>
  import axios from 'commons/jquery-ajax';

  export default {
    props: {
      Email: {
        default: ''
      },
      ButtonClicked:{
        default:''
      },
      Loader:{
        default:''
      },
      reg:{
        default:/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,24}))$/
      },
      user:{
        default:{
          email : ''
        }
      },
      ErrorMessages:{
        default:null
      },
    },
    data() {
      return {
        EnableSuccess: {
          default: true
        },
        successmessage: {
          default: ""
        },
        EnableError: {
          default: true
        },
        errormessage: {
          default: ""
        },
      };
    },
    mounted(){
      this.user.email='';
    },
    methods:{
      isEmailValid(){
        return (this.user.email == "")? "" : (this.reg.test(this.user.email)) ? '' : 'valid';
      },
      fnLogin() {
        this.$parent.loginRedirect();
      },
      fnResetPassword(){
        if(this.user.email!=''&&this.isEmailValid()==''){
          let loader = this.$loading.show({
            loader:"dots",
            color:"#282697"
          });
          var data={
            'user':this.user,
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
          axios.post('users/password', data)
          .then((response) => {
            loader.hide();
            if(response.data.status==201 || response.data.status==200)
            {
              this.EnableSuccess = false;
              this.successmessage = response.data.message;
              var self=this;
              setTimeout(() => {
                self.EnableSuccess=true;
                this.$parent.loginRedirect();
              }, 5000);
            }
            else{
              this.EnableError = false;
              this.errormessage = response.data.message;
              var self=this;
              setTimeout(() => {
                self.EnableError=true;
                this.$parent.loginRedirect();
              }, 5000);
            }
          })
          .catch((error) => {});
        }
        else
        {
          this.ButtonClicked='clicked';
          event.preventDefault();
        }
      }
    }
  }
</script>
<style type="text/css">
  .loader{
    display: block;
  }
</style>