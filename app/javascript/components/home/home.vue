<template>
  <div class="row home-main-div">
    <!-- <div class="row home-menu-div">
      {{headingText}}
    </div> -->
    <div class="message-div success-message" v-if="ShowMessageDiv">
      <div class="btn-close-message-div" @click="fnCloseMessageDiv()">X</div>
      <div v-if="fnCheckErrorMessageLength()">
        <div v-for="item in ErrorMessages" :key="item">
          {{item}}
        </div>
      </div>
      <div v-else>
        {{ErrorMessages}}
      </div>
    </div>
    <div class="row home-menu-content">
      <div class="home-menu-desc col-sm-6">
        <div class="message-div success-message message-login-success" :class="{spnHide:EnableSuccess}">
          {{successmessage}}
        </div>
        <div class="message-div success-message message-login-error" :class="{spnHide:EnableError}">
          {{showErrorMessage}}
        </div>
        <div cols="12" class="home-login-header-image-div row">
          <b-col sm="12" class="height100">
           <img v-bind:src="require('images/LoginLogo.png')" class="login-header-image">
         </b-col>       
       </div> 
       <div class="desc-title-div">
        <h3 class="desc-title-heading">Collborative analysis</h3>
      </div>
      <span>
        Manage large-scale business analysis with fine-grained access controls.
      </span>
      <span>
        Enhance collaboration. Share knowledge and insights. Ensure quality and
      </span>
      <span>
        consistency. Complete work faster!
      </span>
    </div>
    <div class="home-menu-login-reg col-sm-6">
      <div class="login-reg-main-div">
        <div class="login-reg-buttons-div">
          <ul class="login-reg-btn-ul" :class="{ btnHide: isLoginHide }">
            <li class="login-reg-btn border-radius-left4" @click="fnLoginReg(Login)" :class="{ btnloginactive: btnLoginActive }">Sign in</li>
            <li class="login-reg-btn border-radius-right4" id="li-register" @click="fnLoginReg(Register)" :class="{ btnloginactive: btnRegisterActive }">Register</li>
          </ul>
          <ul class="forgot-password-heading" :class="{ btnHide: isForgotHide }">
            <li class="forgot-password-li">Reset Password</li>
          </ul>
          <ul class="forgot-password-heading" :class="{ btnHide: isChangePasswordHide }">
            <li class="forgot-password-li">Change Your Password</li>
          </ul>
        </div>
        <div class="login-reg-body-div row">
          <component :is="ViewName" @forgotPassword="forgot-password"  @loginRedirect="forgotPassword" @showErrorMessages="showErrorMessages"></component>
        </div>
      </div>
    </div>
  </div>
</div>
</template>
<script>
  import LayoutDefault from '../layouts/login_layout.vue';
  import LoginPage from '../login/login.vue';
  import RegisterPage from '../register/register.vue';
  import ForgotPassword from '../forgot_password/forgot_password.vue';
  import ChangePassword from '../change_password/change_password.vue';
  export default{
    components: {LayoutDefault,LoginPage,RegisterPage,ForgotPassword,ChangePassword},
    data(){
      return{
        ViewName:'login-page',
        Login:'Login',
        Register:'Register',
        btnLoginActive: true,
        btnRegisterActive:false,
        headingText:'You can sign in here',
        isLoginHide:false,
        isForgotHide:true,
        isChangePasswordHide:true,
        ShowMessageDiv:'',
        ErrorMessages:[],
        EnableSuccess: {
          default: true
        },
        successmessage: {
          default: ""
        },
        showErrorMessage:{
          default:''
        },
        EnableError: {
          default: true
        }
      }
    },
    props:{
      _is_valid_credentials:'',
      _message_type:''
    },
    mounted: function(){
      this.message_type=this._message_type;
      if(this.message_type != '' && this.message_type == 'failure'){
        this.EnableError = false;
        this.showErrorMessage = this._is_valid_credentials;
        var self=this;
        setTimeout(() => {
          self.EnableError=true;
        }, 5000);
      }
      else if(this.message_type != '' && this.message_type == 'success'){
        this.EnableSuccess = false;
        this.successmessage = this._is_valid_credentials;
        var self=this;
        setTimeout(() => {
          self.EnableSuccess=true;
        }, 5000);
      }
      let uri = window.location.href.split('?id');
      if(uri[1] != '' && uri[1] != undefined)
      {
        this.isLoginHide=true;
        this.isForgotHide=false;
        this.isChangePasswordHide=true;
        this.headingText='You can reset password here';
        this.ViewName='forgot-password';
      }
    },
    methods:{
      fnCloseMessageDiv()
      {
        this.ShowMessageDiv='';
      },
      fnCheckErrorMessageLength(){
        if(this.$route.query.message!='')
        {
          return false;
        }
        if(this.ErrorMessages.length>1 && this.ErrorMessages.length<8){
          return true;
        }
        else {
          return false;
        }
      },
      showErrorMessages(errors){
        var self=this;
        self.ShowMessageDiv='show';
        self.ErrorMessages=errors;
        this.fnCheckErrorMessageLength();
      },
      fnLoginReg(PageName){
        if(PageName=='Login'){
          this.btnLoginActive=true;
          this.btnRegisterActive=false;
          this.headingText='You can sign in here';
          this.ViewName='login-page';
        }
        else if(PageName=='Register'){
          this.btnLoginActive=false;
          this.btnRegisterActive=true;
          this.headingText='You can register here';
          this.ViewName='register-page';
        }
      },
      forgotPassword() {
        this.isLoginHide=true;
        this.isForgotHide=false;
        this.isChangePasswordHide=true;
        this.headingText='You can reset password here';
        this.ViewName='forgot-password';
      },
      changePassword(){
        this.isLoginHide=true;
        this.isForgotHide=true;
        this.isChangePasswordHide=false;
        this.headingText='You can change password here';
        this.ViewName='change-password';
      },
      loginRedirect() {
        this.isLoginHide=false;
        this.isForgotHide=true;
        this.btnLoginActive=true;
        this.btnRegisterActive=false;
        this.headingText='You can sign in here';
        this.ViewName='login-page';
      },
      changePasswordRedirect(){
        this.isLoginHide=true;
        this.isForgotHide=true;
        this.isChangePasswordHide=false;
        this.headingText='You can change password here';
        this.ViewName='change-password';
      }
    }
  }
</script>
