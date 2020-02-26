<template>
  <div class="row home-main-div">
    <div
    class="message-div"
    v-if="ShowMessageDiv">
    <span class="user-settings" @click="fnRedirectToProfile()">User Settings></span>
    <span class="user-settings" @click="fnRedirectToAccount()">Account></span>Two-Factor Authentication</div>
    <div
    class="message-div success-message user-sucess"
    :class="{spnHide:EnableSuccess}">
    <div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
  {{successmessage}}</div>
  <div
  class="message-div success-message user-error"
  :class="{spnHide:DisableError}">
  <div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
  {{EditPasswordErrorMessage}}
</div>
<div class="row two-factor-main-div">
  <b-col sm="4">
    <div class="two-factor-heading">Register Two-Factor Authenticator</div>
    <div
    class="two-factor-desc"
    >Use an one time password authenticator on your mobile device or computer to enable two-factor authentication (2FA).</div>
  </b-col>
  <b-col sm="8">
    <div class="two-factor-content">
      <p>Install a soft token authenticator like <a class="anchor-btn-color" href="https://freeotp.github.io/" target="_blank">FreeOTP</a> or Google Authenticator from your application repository and scan this QR code. More information is available in the <a class="anchor-btn-color" href="https://gitlab.com/help/user/profile/account/two_factor_authentication" target="_blank">documentation.</a></p>
      <div class="row append-bottom-10">
        <b-col sm="5" class="">
          <img :src="img2" class="otp-scanner-img" />
        </b-col>
        <b-col sm="7" class="col-otp-scanner">
          <div class="otp-scanner-desc">
            <p>
              Can't scan the code?
              <br />To add the entry manually, provide the following details to the application on your phone.
              <br />
              Account:{{email}}
              <br />
              Key: {{key}}
              <br />Time based: Yes
            </p>
          </div>
        </b-col>
      </div>
      <div>
        <p>Pin code</p>
        <input type="text" name="otp_code" v-model="user.otp_code" class="form-control" />
        <p
        class="validation-error"
        v-if="ButtonClicked"
        :class="{ spnHide:user.otp_code }"
        >Please enter Two Factor Authentication Code</p>

        <b-button
        value="Register with two-factor app"
        class="btn btn-success two-factor-save-btn"
        @click="fnEnableTwoFactorAuth"
        >Register with two-factor app</b-button>
      </div>
    </div>
  </b-col>
</div>
</div>
</template>

<script>
  import PasswordSettings from "../password_settings/password_settings.vue";
  import axios from 'commons/jquery-ajax';
  export default {
    props: {
      user: {
        default: {
          otp_code: ""
        }
      },
      img2: {
        default: ""
      },
      email: {
        default: ""
      },
      key: {
        default: ""
      },
      successmessage: {
        default: ""
      },
      EnableSuccess: {
        default: true
      },
      ButtonClicked:{
        default:""
      }
    },
    components: { PasswordSettings },
    data() {
      return {
        ShowMessageDiv: "show",
        Status: "",
        DisableError:true,
        EditPasswordErrorMessage:''
      };
    },
    mounted() {
      let loader = this.$loading.show({
        loader:"dots",
        color:"#282697"
      });
      this.user.otp_code='';
      axios.get("two_factor_authentications/fetch_qr")
      .then(response => {
        loader.hide();
        if (response.data.status == 201 || response.data.status == 200) {
          var user = JSON.parse(localStorage.getItem("user"));
          this.img2 = response.data.qr;
          this.email = user.email;
          this.key = response.data.key;
        } else {
          this.DisableError = false;
          setTimeout(() => {
            this.DisableError = true;
            this.EditPasswordErrorMessage = response.data.message;
          }, 5000);

        }
      })
      .catch(error => {
        console.log(error.response);
      });
    },
    methods: {
      fnRedirectToProfile(){
        this.$parent.fnRedirectToProfile();
      },
      fnRedirectToAccount()
      {
        this.$parent.fnRedirectToAccount();
      },
      fnCloseErrorMessageDiv(){
        this.DisableError=true;
      },
      fnEnableTwoFactorAuth() {
        this.ButtonClicked='clicked';
        if(this.user.otp_code != ''){
          let loader = this.$loading.show({
            loader:"dots",
            color:"#282697"
          });
          var data = {
            "user": this.user,
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          };
          axios.post("two_factor_authentications/enable_two_factor_authentication",data).then(response => {
            loader.hide();
            this.ButtonClicked="";
            if (response.data.status == 201 || response.data.status == 200) {
              this.user.otp_code = "";
              this.EnableSuccess = false;
              this.successmessage = response.data.message;
              setTimeout(() => {
                this.EnableSuccess = true;
                this.Status = "Enabled";
                this.$parent.passwordSettingsRedirect(this.Status);
              }, 5000);
            } else {
              this.DisableError = false;
              this.EditPasswordErrorMessage = response.data.message;
              setTimeout(() => {
                this.DisableError = true;
              }, 5000);
            }
          })
          .catch(error => {
            console.log(error);
          });
        }
      }
    }
  };
</script>
