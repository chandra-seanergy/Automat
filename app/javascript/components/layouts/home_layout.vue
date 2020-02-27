<template>
  <div class="welcome-main-header row">
    <div cols="12" class="welcome-header-image-div row height100">
      <div class="col-sm-4 zindex9999">
        <img @click="HomeSelect()" v-bind:src="require('images/InnerLogo.png')" class="welcome-header-image">
        <div
        class="menu-div group-menu-btn"
        :class="{groupButtonActive:IsProjectButtonActive,iconActive:IsProjectButtonActive}"
        @click="fnToggleProjectMenu()"
        >
        Projects
        <v-icon name="angle-down" class="angle-down-img" />
      </div>
        <div
        class="menu-div group-menu-btn"
        :class="{groupButtonActive:IsGroupButtonActive,iconActive:IsGroupButtonActive}"
        @click="fnToggleGrouMenu()"
        >
        Groups
        <v-icon name="angle-down" class="angle-down-img" />
      </div>
      <div class="group-menu row" v-if="ShowGroupMenu" v-click-outside="outside">
        <b-col sm="4" class="group-menu-items-header pad0 group-menu-inner group-menu-items-header">
          <div class="group-menu-items" @click="fnGetGroupsList(0)">Your groups</div>

          <div class="group-menu-items" @click="fnGetGroupsList(1)">Explore groups</div>
        </b-col>
        <b-col sm="8" class>
          <div class="group-menu-body">
            <div class="group-menu-frequency-txt">Frequently visited
              <b-row class="group-list-group-item-div frequent-groups" v-for="(group,index) in FrequentlyVisitedGroups" :key="index">
                <b-col sm="12">
                  <b-row @click="fnGetGroupDetails(group.id)">
                   <div class="avatar-circle" v-if="!group.avatar.url">
                     <span class="initials upper-case">{{group.name[0]}}</span>
                   </div>
                   <img :src="group.avatar.url" v-if="group.avatar.url" class="group-list-img">
                   <div class="groups-list-item-anc">
                    <div class="div-inline">
                      <span class="dv-span-row group-list-item-title frequent-span">{{group.name}}</span> 
                      <span class="dv-span-row group-list-item-desc frequent-span">{{group.description}}</span> 
                    </div>
                  </div>
                </b-row>
              </b-col>
            </b-row>
          </div>
        </div>
      </b-col>
    </div>
  </div >
  <div class="col-sm-8">
    <div class="header-right-menu-main-div">
      <div
      class="header-right-menu-div"
      :class="{rightMenuActive:IsProjectsActive, iconActive:IsProjectsActive}"
      @click="fnShowsProjects()">
      <v-icon name="plus-square" class="angle-down-img right-header-menu-icon" />
      <v-icon name="angle-down" class="angle-down-img" />
      <div
      class="screens-main-div"
      :class="{spnHide: !IsProjectsActive}"
      v-click-outside="outsideitems"
      >
       <div class="screens-text">New project</div>
      <div @click="NewGroup()" class="screens-text">New group</div>
    </div>
  </div>
  <div class="inline-display">
    <div
    class="header-right-menu-div width50 pad1"
    :class="{rightMenuActive:IsUserActive,iconActive:IsUserActive}"
    @click="fnShowUserMenu()"
    >
    <img :src="Img" class="user-header-icon" v-if="ShowImg" />
    <v-icon
    v-else
    name="user-circle"
    class="angle-down-img user-menu-icon right-header-menu-icon"
    />
    <v-icon name="angle-down" class="angle-down-img" />
  </div>
  <div
  class="users-menu-main-div"
  :class="{spnHide:!IsUserActive}"
  v-click-outside="outsideuser"
  >
  <div class="screens-text user-info-div">
    <span class="block-display font-bold">{{FullName}}</span>
    <span class="user-email-spn ellipsis blockDisplay">@{{Username}}</span>
  </div>
  <div class="screens-text"><a class="sign_out-anc buttoned_links" rel="nofollow" data-method="get" href="/settings">Settings</a></div>
  <div class="screens-text">
    <a class="sign_out-anc buttoned_links" rel="nofollow" data-method="delete" href="/users/sign_out">Sign Out</a>
  </div>
</div>
</div>
</div>
</div>
</div>
<div class="row">
  <slot />
</div>
</div>
</template>

<script>
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  export default {
    data() {
      return {
        ShowGroupMenu: "",
        IsGroupButtonActive: false,
        IsProjectsActive: false,
        IsProjectButtonActive:false,
        IsHelpActive: false,
        IsUserActive: false,
        IsGroupsToggle: false,
        IsItemsAddToggle: false,
        IsUserMenuToggle: false,
        FrequentlyVisitedGroups:[],
        FullName: "",
        Username: "",
        Img: "",
        ShowImg: ""
      };
    },
    props: {
      _current_user: {},
      _frequent_groups:{
        type: Array,
        default:[]
      }
    },
    mounted() {
      this.FullName = this._current_user.name;
      this.Username = this._current_user.username;
      localStorage.setItem("user",JSON.stringify(this._current_user));
      try{
        if (this._current_user.avatar.url != undefined && this._current_user.avatar.url != null && this._current_user.avatar.url != "") {
          this.Img = this._current_user.avatar.url;
          this.ShowImg = "show";
        }
        else if(this._current_user.profile_pic != null || this._current_user.profile_pic != ""){
            this.Img = this._current_user.profile_pic;
            this.ShowImg = true;
        }
      }catch(e){
        if(this._current_user.profile_pic != null || this._current_user.profile_pic != ""){
            this.Img = this._current_user.profile_pic;
            this.ShowImg = true;
        }
      }
      var frequentGroups = this._frequent_groups;
      if(frequentGroups != '' && frequentGroups != '')
      {
        this.FrequentlyVisitedGroups=frequentGroups;
      }
    },
    methods: {
      HomeSelect() {
        location.href=CommonFunctions.url_with_domain("");
      },
      NewGroup(){
       location.href= CommonFunctions.url_with_domain("groups/new");
     },
     fnGetGroupsList(id) {
      if (id == 1) {
        location.href=CommonFunctions.url_with_domain("group_listing/group_list?is_public="+true);
      } else {
        location.href=CommonFunctions.url_with_domain("group_listing/group_list?is_public="+false);
      }
      this.ShowGroupMenu = "";
    },
    fnGetGroupDetails(id){
      location.href = CommonFunctions.url_with_domain('groups/'+id);
    },
    fnToggleGrouMenu() {
      if (this.ShowGroupMenu == "") {
        this.ShowGroupMenu = "show";
        this.IsGroupButtonActive = true;
        this.IsProjectsActive = false;
        this.IsUserActive = false;
        this.IsGroupsToggle = true;
      } else {
        this.ShowGroupMenu = "";
        this.IsGroupButtonActive = false;
      }
    },
    fnShowsProjects() {
      if (this.IsProjectsActive == true) {
        this.IsProjectsActive = false;
      } else {
        this.IsProjectsActive = true;
        this.IsUserActive = false;
        this.IsGroupButtonActive = false;
        this.ShowGroupMenu = "";
        this.IsItemsAddToggle = true;
      }
    },
    fnShowUserMenu() {
      if (this.IsUserActive == true) {
        this.IsUserActive = false;
      } else {
        this.IsUserActive = true;
        this.IsProjectsActive = false;
        this.IsGroupButtonActive = false;
        this.ShowGroupMenu = "";
        this.IsUserMenuToggle = true;
      }
    },
    outside: function(e) {
      if (this.IsGroupsToggle == false) {
        this.IsGroupButtonActive = false;
        this.ShowGroupMenu = "";
      }
      this.IsGroupsToggle = false;
    },
    outsideitems: function(e) {
      if (this.IsItemsAddToggle == false) {
        this.IsProjectsActive = false;
      }
      this.IsItemsAddToggle = false;
    },
    outsideuser: function(e) {
      if (this.IsUserMenuToggle == false) {
        this.IsUserActive = false;
      }
      this.IsUserMenuToggle = false;
    }
  },
  directives: {
    "click-outside": {
      bind: function(el, binding, vNode) {
        // Provided expression must evaluate to a function.
        if (typeof binding.value !== "function") {
          const compName = vNode.context.name;
          let warn = `[Vue-click-outside:] provided expression '${binding.expression}' is not a function, but has to be`;
          if (compName) {
            warn += `Found in component '${compName}'`;
          }
        }
        // Define Handler and cache it on the element
        const bubble = binding.modifiers.bubble;
        const handler = e => {
          if (bubble || (!el.contains(e.target) && el !== e.target)) {
            binding.value(e);
          }
        };
        el.__vueClickOutside__ = handler;

        // add Event Listeners
        document.addEventListener("click", handler);
      },
      unbind: function(el, binding) {
        // Remove Event Listeners
        document.removeEventListener("click", el.__vueClickOutside__);
        el.__vueClickOutside__ = null;
      }
    }
  }
};
</script>