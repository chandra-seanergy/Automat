<template>
  <div class="row home-main-div">
    <div class="message-div success-message" v-if="ShowMessageDiv">
      Welcome! You have been successfully logged in.
    </div>
    <div class="welcome-message-div">
      Welcome to <b>Factz</b>
    </div>

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
