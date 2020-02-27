<template>
  <div class="row">
    <div class="message-div"><span class="user-settings" @click="fnRedirectToProfile()">User Settings</span> > Edit Account</div>

    <div
    class="message-div success-message user-sucess"
    :class="{spnHide:DisableSuccess}"
    >{{PasswordSuccessMessage}}</div>

    <b-row class="addBottomBorder">
      <b-col cols="4" align="left">
        <h4>Two-Factor Authentication</h4>
        <p>
          Increase your account's security by enabling
          Two-factor Authentication(2FA)
        </p>
      </b-col>
      <b-col cols="2" align="left"></b-col>
      <b-col clos="4" align="left">
        <p>Status : {{Status}}</p>
        <b-button
        variant="primary"
        @click="fnManageAuth()"
        v-if="ManageTwoAuth"
        >Manage two-factor authentication</b-button>
        <b-button
        variant="success"
        @click="fnRedirectTwoFactorAuth"
        v-if="EnableTwoAuth"
        >Enable two-factor authentication</b-button>
        <b-button
        variant="danger"
        @click="fnDisableAuth()"
        v-if="DisableTwoAuth"
        >Disable Two Factor Authentication</b-button>
      </b-col>
    </b-row>
    <b-row class="addBottomBorder">
      <b-col cols="4" align="left">
        <h3 class="changeUserName">Change user name</h3>
        <p>
          Changing username can have unintended side effects.
          <span>
            <a href="#">Learn more</a>
          </span>
        </p>
      </b-col>
      <b-col cols="2" align="left"></b-col>
      <b-col cols="4" align="left">
        <b-form-input
        id="input-small"
        size="sm"
        placeholder="Username"
        class="userNameInput"
        v-model="user.username"
        v-on:change="IsUserAutheticate"
        @keyup="fnCheckUsername()"
        ></b-form-input>
        <p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:user.username }">Please enter Username</p>
        <p :class="[uservalidation ? 'validation-error' : 'validation-success']" v-if="isUsernameExist">{{IsUserExistField}}</p>
        <b-button
        variant="warning"
        class="btn-update-username"
        @click="fnChangeUsername()"
        :disabled="UsernameDisable"
        >Update UserName</b-button>
      </b-col>
    </b-row>

    <b-row class="addBottomBorder">
      <b-col cols="4" align="left">
        <h3 class="deleteAccountHeader">Delete Account</h3>
      </b-col>
      <b-col cols="2" align="left"></b-col>
      <b-col cols="4" align="left">
        <div  v-if="MyGroups.length>0">
          <p>Your account is currently owner in these groups :
            <span class="item" v-for="(item,index) in MyGroups" :key="index">{{item}} </span>
          </p>
          <p>You must transfer ownership or delete these group before you can delete your account</p>
        </div>
        <div v-else>
          <p>Deleting an account has the following effects:</p>
          <p>Certain user content will be moved to a system-wide "Ghost User" in order to maintain content for posterity. For further information, please refer to the user account deletion documentation.</p>
        </div>
        <b-button
        variant="warning"
        class="btn-update-username btn-delete-member"
        v-if="MyGroups.length==0"
        v-b-modal.modal-1
        >Delete Account</b-button>
      </b-col>
    </b-row>

    <b-modal ref="my-modal" id="modal-1" title="Delete your account?" hide-footer>
      <p
      class="my-4 remove-group-p3 mar-zero"
      >You are about to permanently delete <b>your account</b>, and all of the issues, merge requests, and groups linked to your account. Once you confirm <b>Delete Account</b>, it cannot be undone or recovered.</p>

      <p class="my-4 remove-group-p3 mar-zero">
        Type your
        <span class="group-delete-random-txt">password</span> to confirm:
      </p>

      <input
      type="password"
      class="form-control"
      name="close-modal-txt"
      v-model="Password"
      @keyup="fnComparePassword()"
      />

      <div class="delete-account-error-msg">
        {{this.ErrorMessage}}
      </div>

      <div class="delete-group-modal-footer">
        <b-button @click="fnCloseModal()" variant="light">Cancel</b-button>
        <b-button @click="fnDeleteAccount()" :disabled="ConfirmDisable" variant="danger">Delete account</b-button>
      </div>
    </b-modal>
  </div>
</template>

<script>
  import axios from 'commons/jquery-ajax';
  export default {
    data() {
      return {
        userAvatar: undefined,
        EnableTwoAuth: false,
        DisableTwoAuth: false,
        DisableSuccess: true,
        PasswordSuccessMessage: "",
        ManageTwoAuth: false,
        ConfirmDisable:true,
        uservalidation:"",
        Status: "",
        MyGroups:[],
        ButtonClicked:''
      };
    },
    props: {
      Email: {
        default: ""
      },
      user: {
        default: {
          username: ""
        }
      },
      isUsernameExist:{
        default:''
      },
      UsernameDisable: {
        default: true
      },
      Password:{
        default:''
      },
      ErrorMessage:{
        default:''
      }
    },
    mounted(){
      axios.get('groups/owned_groups')
      .then((response) => {
        this.MyGroups=response.data.owned_groups;
      })
      .catch((error) => {

      });
    },
    created() {
      var user = JSON.parse(localStorage.getItem("user"));
      this.user.username = user.username;
      if (this.Status == "Enabled" || user.otp_module == "Enabled" || user.otp_module == "enabled") {
        this.ManageTwoAuth = true;
        this.EnableTwoAuth = false;
        this.Status = "Enabled";
      } else {
        this.ManageTwoAuth = false;
        this.EnableTwoAuth = true;
        this.Status = "disabled";
      }
    },
    methods: {
      fnComparePassword(){
        if(this.Password.length > 0){
          this.ConfirmDisable = false;
        }
        else{
          this.ConfirmDisable = true;
        }
      },
      fnCloseModal(){
        this.$refs['my-modal'].hide()
      },
      fnDisableAuth() {
        var result = confirm(
          "Are you sure? This will invalidate your registered applications and U2F devices!"
          );
        if (result) {
          var data = {
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          };
          axios.post(
            "two_factor_authentications/disable_two_factor_authentication",data
            )
          .then(response => {
            if (response.data.status == 201 || response.data.status == 200) {
              this.Status = "Disabled";
              this.EnableTwoAuth = true;
              this.DisableTwoAuth = false;
              this.ManageTwoAuth = false;
              this.PasswordSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.DisableSuccess = true;
              }, 5000);
            } else {
              this.DisableSuccess = false;
              this.PasswordSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.DisableSuccess = true;
              }, 5000);
            }
          })
          .catch(error => {
            console.log(error.response);
          });
        }
      },
      fnManageAuth() {
        this.ManageTwoAuth = false;
        this.DisableTwoAuth = true;
        if (this.Status == "enabled" || this.Status == "Enabled") {
          this.EnableTwoAuth = false;
          this.DisableTwoAuth = true;
        } else {
          this.EnableTwoAuth = true;
          this.DisableTwoAuth = false;
        }
      },
      fnChangeUsername() {
        this.ButtonClicked='clicked';
        if(this.user.username !=''){
          var data = {
            "user": this.user,
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          };
          axios.patch("accounts/change_username", data)
          .then(response => {
            if (response.data.status == 201 || response.data.status == 200) {
              this.DisableSuccess = false;
              this.PasswordSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.DisableSuccess = true;
              }, 5000);
            } else {
              this.DisableSuccess = false;
              this.PasswordSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.DisableSuccess = true;
              }, 5000);
            }
          })
          .catch(error => {
            console.log(error.response);
          });
        }
        else{
          event.preventDefault();
        }
      },
      fnDeleteAccount() {
        var data={
          "user": {
            "password": this.Password
          },
          'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
        axios.post("accounts/delete_account",data)
        .then(response => {
          if (response.data.status == 201 || response.data.status == 200) {
            this.$refs['my-modal'].hide();
            this.DisableSuccess = false;
            this.PasswordSuccessMessage = response.data.message;
            var self = this;
            setTimeout(() => {
              self.DisableSuccess = true;
              localStorage.clear();
              location.href="/users/login";
            }, 5000);
          } else {
            this.ErrorMessage = response.data.message;
          }
        })
        .catch(error => {
          console.log(error.response);
        });
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
        .catch((error) => {
          console.log(error.response);
        });
      },
      fnRedirectTwoFactorAuth(){
        this.$parent.redirectTwoFactorAuth();
      },
      fnCheckUsername(){
        if (this.user.username != '') {
          if (JSON.parse(localStorage.getItem("user")).username == this.user.username) {
            this.UsernameDisable = true;
          } else {
            this.UsernameDisable = false;
          }
        }
      }
    },
  }
</script>
