<template>
  <div class="row">
    <b-col sm="2" class="group-side-menu">
      <div
      class="group-side-menu-item group-header-side-menu"
      @click="fnRedirectUserSettings('edit-profile')">
      <v-icon name="user" class="group-side-menu-img" />
      <div class="group-side-menu-text group-side-menu-heading-txt">User Settings</div>
    </div>
    <div
    class="group-side-menu-item"
    :class="{groupSideMenuActive:IsProfileActive}"
    @click="fnRedirectUserSettings('edit-profile')"
    >
    <v-icon name="user-circle" class="group-side-menu-img" />
    <div class="group-side-menu-text">Profile</div>
  </div>
  <div
  class="group-side-menu-item"
  :class="{groupSideMenuActive:IsAccountActive}"
  @click="fnRedirectUserSettings('password-settings')"
  >
  <v-icon name="box" class="group-side-menu-img" />
  <div class="group-side-menu-text">Account</div>
</div>
<div
class="group-side-menu-item"
:class="{groupSideMenuActive:IsPasswordActive}"
@click="fnRedirectUserSettings('edit-password')"
>
<v-icon name="lock" class="group-side-menu-img" />
<div class="group-side-menu-text">Password</div>
</div>
</b-col>

<b-col sm="10" class="pad0">
  <component
  :is="ViewName"
  @redirectTwoFactorAuth="redirectTwoFactorAuth"
  @passwordSettingsRedirect="passwordSettingsRedirect"
  @fnRedirectToProfile="fnRedirectToProfile"
  @fnRedirectToAccount="fnRedirectToAccount"
  :Status="this.Status"
  ></component>
</b-col>
</div>
</template>

<script>
  import EditProfile from "../edit_profile/edit_profile.vue";
  import PasswordSettings from "../password_settings/password_settings.vue";
  import EditPassword from "../edit_password/edit_password.vue";
  import TwoFactorAuthentication from "../twofactor_authentication/twofactor_authentication.vue";
  export default {
    components: {
      EditProfile,
      PasswordSettings,
      EditPassword,
      TwoFactorAuthentication
    },
    data() {
      return {
        ViewName: "edit-profile",
        IsProfileActive: true,
        IsAccountActive: false,
        IsPasswordActive: false,
        Status: ""
      };
    },
    created() {
    },
    methods: {
      fnRedirectToProfile(){
        this.IsProfileActive = true;
        this.IsAccountActive = false;
        this.IsPasswordActive = false;
        this.ViewName = "edit-profile";
      },
      fnRedirectToAccount(){
        this.IsProfileActive = false;
        this.IsAccountActive = true;
        this.IsPasswordActive = false;
        this.ViewName = "password-settings";
      },
      fnRedirectUserSettings(viewName) {
        if (viewName == "edit-profile") {
          this.IsProfileActive = true;
          this.IsAccountActive = false;
          this.IsPasswordActive = false;
        } else if (viewName == "password-settings") {
          this.IsProfileActive = false;
          this.IsAccountActive = true;
          this.IsPasswordActive = false;
        } else if (viewName == "edit-password") {
          this.IsProfileActive = false;
          this.IsAccountActive = false;
          this.IsPasswordActive = true;
        }
        this.ViewName = viewName;
      },
      passwordSettingsRedirect(Status) {
        this.Status = Status;
        this.ViewName = "password-settings";
      },
      redirectTwoFactorAuth() {
        this.ViewName = "two-factor-authentication";
      }
    }
  };
</script>

