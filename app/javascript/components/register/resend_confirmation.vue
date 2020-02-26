  <template>
    <div class="row resend_confirmation_row">
      <div class="message-div success-message message-forgot-successs" :class="{spnHide:EnableSuccess}">
        {{successmessage}}
      </div>
      <div class="message-div success-message message-error" :class="{spnHide:EnableError}">
        {{showErrorMessage}}
      </div>
      <div class="col-sm-6"></div>
      <div class="col-sm-6 order-1 order-sm-12 new-session-forms-container confirmation-new-session-forms-container">
        <div>
          <ul class="forgot-password-heading">
            <li class="forgot-password-li">
              Resend confirmation instructions
            </li>
          </ul>
        </div>
        <div class="login-box">
          <div class="login-body confirmation-login-body">
            <div class="form-group">
              <label for="user_email">Email</label>
              <input
              class="form-control"
              required="required"
              title="Please provide a valid email address."
              type="email"
              value
              name="email"
              id="email"
              v-model="user.email"
              />
              <p class="validation-error" v-if="ButtonClicked"  :class="{spnHide:user.email}">Please enter Email</p>
              <p class="validation-error" v-if="isEmailValid()">Please enter valid Email</p>
            </div>
            <div class="clearfix">
              <input
              type="button"
              name="commit"
              value="Resend"
              class="btn btn-success btn-Resend"
              data-disable-with="Resend"
              @click="fnResend"
              />
            </div>
            <div class="clearfix prepend-top-20 confirmation-sign-in-link">
              <p class="text-center">
                <span class="light confirmation-sign-in-link-text">
                  Already have login and password?
                  <a href="/users/sign_in">Sign in</a>
                </span>
              </p>
            </div>      
          </div>
        </div>
      </div>
    </div>
  </template>
  <script>
    import axios from 'commons/jquery-ajax';
    import CommonFunctions from 'commons/common_functions.js';
    export default {
      props: {
        reg: {
          default: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,24}))$/
        },
        user: {
          default: {
            email: ""
          }
        },
        ButtonClicked:{
          default:false
        }
      },
      data() {
        return {
          EnableSuccess: {
            default: true
          },
          ShowMessageDiv: "show",
          successmessage: {
            default: ""
          },
          showErrorMessage:{
            default:''
          },
          EnableError: {
            default: true
          },
        };
      },
      methods: {
        isEmailValid() {
          return this.user.email == ""
          ? ""
          : this.reg.test(this.user.email)
          ? ""
          : "valid";
        },
        fnResend() {
          this.ButtonClicked=true;
          if(this.user.email=='')
          {
            this.ButtonClicked='clicked';
            event.preventDefault();
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
            axios.post('users/confirmation', data)
            .then((response) => {
              loader.hide();
              if(response.data.status==201 || response.data.status==200)
              { 
                this.EnableSuccess = false;
                this.successmessage = response.data.message;
                setTimeout(() => {
                  self.EnableSuccess=true;
                  location.href = CommonFunctions.url_with_domain("users/sign_in");
                }, 5000);
              }
              else{
                this.EnableSuccess = false;
                this.successmessage = response.data.message;
                setTimeout(() => {
                  self.EnableSuccess=true;
                  location.href = CommonFunctions.url_with_domain("users/sign_in");
                }, 5000);
              }
            })
            .catch((error) => {
            });
          }
        }
      }
    };
  </script>