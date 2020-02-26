<template>
  <div>
    <form method="post" action="/users/login">
      <input type="hidden" name="authenticity_token" :value="csrf">
      <div class="login-reg-label">Username or email</div>
      <div class="login-reg-input-div">
        <input type="text" class="default-text-input" name="user[login]" v-model="user.login" />
        <p
        class="validation-error"
        v-if="ButtonClicked"
        :class="{ spnHide:user.login }"
        >Please enter Username or email</p>
      </div>
      <div class="login-reg-label">Password</div>
      <div class="login-reg-input-div">
        <input type="password" class="default-text-input" name="user[password]" v-model="user.password" />
        <p
        class="validation-error"
        v-if="ButtonClicked"
        :class="{ spnHide:user.password }"
        >Please enter Password</p>
      </div>
      <div class="row">
        <b-col sm="6" class="pad0">
          <input type="checkbox" name="RememberMe" ref="rolesSelected" />
          <span class="login-reg-label">Remember Me</span>
        </b-col>
        <b-col sm="6" class="pad0 text-right">
          <span class="anchor-btn-color login-reg-label" @click="fnForgotPassword">Forgot Password?</span>
        </b-col>
      </div>
      <div class="row margin-top-16">
        <button class="default-btn" v-on:click="submit">Sign In</button>
      </div>
    </form>
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
        EnableError: {
          default: true
        }
      })
    },
    props:{
      user: {
        type: Object,
        default: ()=>({
          login: '',
          password: ''
        }),
      },
      ButtonClicked:{
        default:""
      }
    },
    mounted(){
      if (this.$cookies.isKey("username") && this.$cookies.isKey("password")) {
        this.user.login = this.$cookies.get("username");
        this.user.password = this.$cookies.get("password");
        this.$refs.rolesSelected.checked = true;
      } else {
        this.user.login = "";
        this.user.password = "";
        this.$refs.rolesSelected.checked = false;
      }
    },
    methods: {
      submit:function(){
        if (this.$refs.rolesSelected.checked) {
          this.$cookies.set("username", this.user.login, Infinity);
          this.$cookies.set("password", this.user.password, Infinity);
        }
        this.ButtonClicked='clicked';
        if (this.user.login == "" || this.user.password == "") {
          event.preventDefault();
        } else {
          this.$ref.form.submit();
        }
      },

      fnForgotPassword(){
        this.$parent.forgotPassword();
      },
    },
  }
</script>



