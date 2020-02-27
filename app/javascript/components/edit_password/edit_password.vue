<template>
  <div class="row">
    <div class="row home-main-div">
      <div class="message-div">
        <span class="user-settings" @click="fnRedirectToProfile()">User Settings</span> > Edit Password
      </div>
      <div
      class="message-div success-message user-sucess"
      :class="{spnHide:DisableSuccess}">
      <div class="btn-close-message-div" @click="fnCloseSuccessMessageDiv()">X</div>
      {{EditPasswordSuccessMessage}}
    </div>
    <div
    class="message-div success-message user-error"
    :class="{spnHide:DisableError}">
    <div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
    {{EditPasswordErrorMessage}}
  </div>
  <div>
    <div class="row">
      <b-col sm="5" class="edit-password-desc-main-div">
        <div class="edit-password-heading-txt">
          Password
        </div>
        <div class="edit-password-desc-text">
          After a successful password update, you will be redirected to the login page where you can login with your new password.
        </div>
      </b-col>
      <b-col sm="7" class="edit-password-form-main-div">
        <div class="edit-password-form-sub-div">
          <div class="edit-password-form-heading">
            Change your password or recover your current one
          </div>
          <div class="edit-password-inputs-div">
            <div class="login-reg-label">
              Current Password
            </div>
            <div class="login-reg-input-div">
              <input type="password" class="default-text-input" name="password" v-model="user.password">
              <p class="edit-password-form-heading">You must provide your current password in order to change it.</p>
              <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:user.password }">Please enter Current Password </p>
              <p class="validation-error" v-if="!fnPasswordLength()">Minimum length is 8 characters.</p>
            </div>
          </div>
          <div class="edit-password-inputs-div">
            <div class="login-reg-label">
              New Password
            </div>
            <div class="login-reg-input-div">
              <input type="password" class="default-text-input" name="newpassword" v-model="user.new_password">
              <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:user.new_password }">Please enter New Password</p>
              <p class="validation-error" v-if="!fnNewPasswordLength()">Minimum length is 8 characters.</p>
            </div>
          </div>
          <div class="edit-password-inputs-div">
            <div class="login-reg-label">
              Password Confirmation
            </div>
            <div class="login-reg-input-div">
              <input type="password" class="default-text-input" name="confirmpassword" v-model="confirm_password">
              <p class="validation-error" v-if="ButtonClicked" :class="{ spnHide:confirm_password }">Please enter Password Confirmation</p>
              <p class="validation-error" v-if="fnComparePasswords()">Password and Confirmation Password should be same</p>
            </div>
          </div>
          <div class="row margin-top-16">
            <b-col sm="6">
              <input type="button" class="default-btn" value="Save Password" @click="fnChangePassword()">
            </b-col>
            <b-col sm="6" class="pad0">
              <span class="anchor-btn-forget-color login-reg-label" @click="fnForgotPassword()">I forgot my password</span>
            </b-col>
          </div>
        </div>
      </b-col>
    </div>
  </div>
</div>
</div>
</template>
<script>
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  export default{
    props:{
      InValidCount:{
        default:0
      },
      confirm_password:{
        default:''
      },
      user: {
        type: Object,
        default: ()=>({
          password: '',
          new_password:''
        }),
      }
    },
    data(){
      return{
        CurrentPassword:'',
        ButtonClicked:'',
        NewPassword:'',
        ConfirmationPassword:'',
        DisableSuccess:true,
        DisableError:true,
        EditPasswordSuccessMessage:'',
        EditPasswordErrorMessage:'',
      }
    },
    created() {
      this.user.password='';
      this.user.new_password='';
      this.confirm_password='';
    },
    methods:{
      fnRedirectToProfile(){
        this.$parent.fnRedirectToProfile();
      },
      fnPasswordLength(){
        if(this.user.password.length<8 && this.user.password!=''){
          return false;
        }
        else{
          return true;
        }
      },
      fnNewPasswordLength(){
        if(this.user.new_password.length<8 && this.user.new_password!=''){
          return false;
        }
        else{
          return true;
        }
      },
      fnComparePasswords(){
        if((this.user.new_password != this.confirm_password) && (this.user.new_password!='') && (this.confirm_password!=''))
        {
          return true;
        }
        else{
          return false;
        }
      },
      fnCloseSuccessMessageDiv(){
        this.DisableSuccess=true;
      },
      fnCloseErrorMessageDiv(){
        this.DisableError=true;
      },
      fnForgotPassword(){
        let loader = this.$loading.show({
          loader:"dots",
          color:"#282697"
        });
        var data={
          'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
        axios.post("users/password/forgot_password", data)
        .then(response => {
          loader.hide();
          if (response.data.status == 201 || response.data.status == 200) {
            this.DisableSuccess = false;
            this.EditPasswordSuccessMessage = response.data.message;
          } else {
            this.DisableError = false;
            this.EditPasswordErrorMessage = response.data.message;
          }
        });
      },
      fnChangePassword(){
        this.ButtonClicked='clicked';
        if(this.user.password=='' || this.user.new_password=='' || this.confirm_password=='' || this.fnComparePasswords() || !this.fnPasswordLength() || !this.fnNewPasswordLength()){
          this.InValidCount=1;
        }
        else{
          this.InValidCount=0;
        }
        if(this.InValidCount==1){
          return false;
        }
        else{
          let loader = this.$loading.show({
            loader:"dots",
            color:"#282697"
          });
          var data={
            'user':this.user,
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
          axios.update("users/password/change_password", data)
          .then(response => {
            loader.hide();
            if (response.data.status == 201 || response.data.status == 200) {
              this.DisableSuccess = false;
              this.EditPasswordSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.EnableSuccess=true;
                location.href = CommonFunctions.url_with_domain("users/sign_in");
              }, 5000);

            } else {
              this.DisableError = false;
              this.EditPasswordErrorMessage = response.data.message;
            }
          });
        }
      },
    }
  }
</script>
