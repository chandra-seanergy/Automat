<template>
  <div class="main-header row">
    <div cols="12" class="login-header-image-div row">
      <b-col sm="12" class="height100">
         <img v-bind:src="require('images/LoginLogo.png')" class="login-header-image">
      </b-col>       
    </div>      
    <div class="main-body row">
      <slot/>
      <!-- <router-view/> -->
    </div>
    <div class="main-footer row">
      <div class="margin-auto">
       &#169; Automat. All Rights Reserved.
     </div>
   </div>
 </div>
</template>
<script>
  export default {
  }
</script>