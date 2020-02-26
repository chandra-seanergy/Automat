<template>
  <div>
    <form method="post" action="/users">
      <input type="hidden" name="authenticity_token" :value="csrf">
      <div class="login-reg-label">
        Full name
      </div>
      <div class="login-reg-input-div">
        <input type="text" class="default-text-input" name="user[name]" v-model="user.name">
        <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:user.name }">This field is required.</p>
      </div>
      <div class="login-reg-label">
        Username
      </div>
      <div class="login-reg-input-div">
        <input type="text" class="default-text-input" name="user[username]" v-model="user.username" v-on:change="IsUserAutheticate">
        <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:user.username }">Please enter username.</p>
        <p class="validation-error" v-if="isUserNameValid()">Please create a username with only alphanumeric characters.</p>
        <p :class="[uservalidation ? 'validation-error' : 'validation-success']" v-if="isUsernameExist">{{IsUserExistField}}</p>
      </div>
      <div class="login-reg-label">
        Email
      </div>
      <div class="login-reg-input-div">
        <input type="text" class="default-text-input" name="user[email]" v-model="user.email" v-on:change="IsEmailAutheticate">
        <p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:user.email }">Please provide a valid email address.</p>
        <p class="validation-error" v-if="isEmailValid()">Please enter valid Email.</p>
        <p :class="[emailvalidation ? 'validation-error' : 'validation-success']" v-if="isEmailExist">{{IsEmailExistField}}</p>
      </div>
      <div class="login-reg-label">
        Email confirmation
      </div>
      <div class="login-reg-input-div">
        <input type="text" class="default-text-input" name="user[confirmemail]" v-model="confirmemail">
        <p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:confirmemail }">Please retype the email address.</p>
        <p class="validation-error" v-if="isConfirmationEmailValid()">Please enter valid Email.</p>
        <p class="validation-error" v-if="fnCompareEmails()">Email and Confirmation Email should be same.</p>
      </div>
      <div class="login-reg-label">
        Password
      </div>
      <div class="login-reg-input-div">
        <input type="password" class="default-text-input" name="user[password]" v-model="user.password">
        <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:user.password }">Please enter Password.</p>
        <p class="validation-error" v-if="!fnPasswordLength()">Minimum length is 8 characters.</p>
      </div>
      <div class="row">
        <input type="checkbox" name="RememberMe" v-model="termsandconditions">
        <span class="login-reg-label mar-left6">I accept the <a href="/terms/terms"><span class="anchor-btn-color" >Terms of Service and Privacy Policy.
        </span></a></span>
        <p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:termsandconditions }">Please check Terms of Service and Privacy Policy.</p>
      </div>
      <div class="row margin-top-16">
        <button class="default-btn" v-on:click="submit">Register</button>
      </div>
    </form>
  </div>
</template>
<script>
  import axios from 'commons/jquery-ajax';
  export default {
    data: function() {
      return ({
        csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        user:{
          default:{
            email: '',
            password: '',
            name: '',
            username: '',
            IsUserExistField:'',
            IsEmailExistField:'',
            uservalidation:{
              type: Boolean,
              default:''
            },
            emailvalidation:{
              type: Boolean,
              default:''
            }
          }
        }
      })
    },
    components: {  },
    props: {
      confirmemail:{
        default:''
      },
      termsandconditions:{
        default:''
      },
      isUsernameExist:{
        default:''
      },
      isEmailExist:{
        default:''
      },
      IsEmailExistField:{
        default:''
      },
      IsUserExistField:{
        default:''
      },
      InValidCount:{
        default:0
      },
      ButtonClicked:{
        default:''
      },
      reg:{
        default:/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,24}))$/
      },
      regx :{
        default: /^[A-Za-z0-9 _.-]+$/
      },
      user: {
        type: Object,
        default: ()=>({
          email: '',
          password: '',
          name: '',
          username: ''
        })
      },
      ErrorMessages:{
        default:null
      }
    },
    methods:{
      submit:function(){
        this.ButtonClicked='clicked';
        if(this.user.name=='' || this.user.username==''|| this.user.email=='' || this.confirmemail=='' || this.user.password=='' || this.termsandconditions=='' 
          || this.isUserNameValid()!='' || this.isEmailValid()!='' || this.isConfirmationEmailValid()!='' || this.fnCompareEmails() || !this.fnPasswordLength()){  
          event.preventDefault();
      }
      else{
        this.$ref.form.submit();
      }
    },
    fnPasswordLength(){
      if(this.user.password.length<8 && this.user.password!=''){
        return false;
      }
      else{
        return true;
      }
    },
    fnCompareEmails(){
      if((this.user.email != this.confirmemail) && (this.user.email!='') && (this.confirmemail!=''))
      {
        return true;
      }
      else{
        return false;
      }
    },
    isEmailValid(){
      return (this.user.email == "")? "" : (this.reg.test(this.user.email)) ? '' : 'valid';
    },
    IsEmailAutheticate:function(){
      this.isEmailExist='clicked';
      this.IsEmailExistField = '';
      var data={
        'user':this.user,
        'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
      axios.post('users/email_exist', data)
      .then((response) => {
        if(response.data.status==200)
        {
          this.emailvalidation = false;
          this.IsEmailExistField = response.data.message;
        }
        else{
          this.emailvalidation = true;
          this.IsEmailExistField = response.data.message;
        }
      })
      .catch((error) => {});

    },
    IsUserAutheticate:function(){
      this.isUsernameExist='clicked';
      this.IsUserExistField = '';
      var data={
        'user':this.user,
        'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
      axios.post('users/username_exist', data)
      .then((response) => {
        if(response.data.status==200)
        {
          this.uservalidation = false;
          this.IsUserExistField = response.data.message;
        }
        else{
          this.uservalidation = true;
          this.IsUserExistField = response.data.message;
        }
      })
      .catch((error) => {});
    },
    isUserNameValid(){
      return (this.user.username == "")? "" : (this.regx.test(this.user.username)) ? '' : 'valid';
    },
    isConfirmationEmailValid(){
      return (this.confirmemail == "")? "" : (this.reg.test(this.confirmemail)) ? '' : 'valid';
    }
  }
}
</script>