<template>
  <div class="row home-main-div">
    <div
    class="message-div success-message message-error"
    :class="{spnHide:EnableError}"
    >{{showErrorMessage}}</div>
    <div class="row home-menu-content">
      <b-col sm="12" class="home-menu-login-reg">
        <div class="twofactor-reg-main-div">
          <div class="login-reg-buttons-div">
            <ul class="forgot-password-heading">
              <li
              class="forgot-password-li li-forgot-border"
              >Two-Factor Authentication</li>
            </ul>
          </div>
          <form method="post" action="/users/verify_otp">
            <input type="hidden" name="authenticity_token" :value="csrf">
            <input type="hidden" name="user[login]" :value="current_user.email">
            <div class="login-reg-body-div row">
              <div class="login-reg-label">Two-factor authentication code</div>
              <div class="login-reg-input-div">
                <input
                type="text"
                class="default-text-input"
                name="user[otp_code]"
                v-model="user.otp_code"
                />
                <p
                class="validation-error"
                v-if="ButtonClicked"
                :class="{ spnHide:user.otp_code }"
                >Please enter Two Factor Authentication Code</p>
                <p
                class="form-text text-muted hint"
                >Enter the code from the two-factor app on your mobile device. If you've lost your device, you may enter one of your recovery codes.</p>
              </div>

              <div class="row margin-top-16">
                <button class="default-btn btn-verify-twofactor" v-on:click="submit">Verify code</button>
              </div>
            </div>
          </form>
        </div>
      </b-col>
    </div>
  </div>
</template>
<script>
  export default {
    data: function() {
      return ({
        csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
        showErrorMessage:{
          default:''
        },
        current_user: {},
        message: '',
        message_type: '',
        user: {
          default: {
            login: "",
            otp_code: ""
          }
        },
        EnableError: {
          default: true
        }
      })
    },
    props: {
      _current_user: {
        type: Object,
      },
      _message: '',
      _message_type: '',
      ButtonClicked:{
        default:""
      }
    },
    mounted: function(){
      this.current_user=this._current_user;
      this.message=this._message;
      this.message_type=this._message_type;
      if(this.message != '' && this.message_type == 'failure'){
        this.EnableError = false;
        this.showErrorMessage = this.message;
        var self=this;
        setTimeout(() => {
          self.EnableError=true;
        }, 5000);
      }
    },
    methods: {
      submit:function(){
        this.ButtonClicked='clicked';
        if (this.user.otp_code == "" || this.user.otp_code == undefined) {
          event.preventDefault();
        } else {
          this.$ref.form.submit();
        }
      }
    }
  }
</script>
