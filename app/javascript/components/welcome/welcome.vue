<template>
  <div class="row home-main-div">
    <div class="message-div error-message" v-if="ShowMessageDiv">
      You are already signed in.
    </div>
    <div class="welcome-message-div">
      Welcome to Automat!
    </div>
    <p class="welcome-sub-message">
    Analyze and solve problems together
    </p>
  </div>
</template>

<script>
  export default{
    data(){
      return{
        ShowMessageDiv: ''
      }
    },
    props: {
      _sign_in_count: 0
    },
    mounted() {
      if (this._sign_in_count == 1) {
        this.ShowMessageDiv =  "show";
      }
    }
  }
</script>
