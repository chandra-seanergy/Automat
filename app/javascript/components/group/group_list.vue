<template>
  <div class="bv-content">
    <b-row align-v="center" class="bv-header-line">
     <div class="message-div success-message user-sucess" :class="{spnHide:DisableSuccess}">
      <div class="btn-close-message-div" @click="fnCloseSuccessMessageDiv()">X</div>
      {{EditGroupSuccessMessage}}
    </div>
    <div class="message-div success-message user-error"  :class="{spnHide:DisableError}">
      <div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
      {{EditGroupErrorMessage}}
    </div>
    <b-col sm="10"> 
      <h3>Groups</h3> 
    </b-col>
    <b-col class="text-right"> 
      <b-button variant="success" to="/groups/new">New Group</b-button>
    </b-col> 
  </b-row>
  <b-row class="groups-list-heading-div">
    <b-col sm="4">
     <div class="group-list-heading" :class="{GroupListActive : IsYourGroupsActive}" @click="fnShowTabs('YourGroups')">Your groups</div>
     <div class="group-list-heading" :class="{GroupListActive : IsPublicGroupsActive}" @click="fnShowTabs('PublicGroups')">Explore public groups</div>
   </b-col>
   <b-col sm="8" class="text-right">
    <b-form-input placeholder="Search by name" class="group-list-search" @keyup="fnSearchGroupsList()" v-model="name"></b-form-input>
    <select class="group-list-drop" v-model="sort_by" @change="fnSearchGroupsList()">
      <option value="created_at desc">Last created</option>
      <option value="created_at asc">Oldest created   </option>
      <option value="updated_at desc">Last updated</option>
      <option value="updated_at asc">Oldest updated</option>
    </select>
  </b-col>
</b-row>
<b-row>
  <div class="row">   
   <div class="row" :class="{spnGroupHide: !IsYourGroupsActive}">
     <b-row class="group-list-group-item-div" v-for="(group,index) in YourGroups" :key="index">
      <b-col sm="10">
        <b-row @click="fnGetGroupDetails(group.id)">
         <v-icon name="folder" class="folder-img-icon"/>
         <div class="avatar-circle" v-if="!group.avatar">
           <span class="initials upper-case">{{group.name[0]}}</span>
         </div>
         <img :src="group.avatar" v-if="group.avatar" class="group-list-img">
         <div class="groups-list-item-anc">
          <div class="div-inline">
            <span class="dv-span-row group-list-item-title ellipsis-span">{{group.name}}</span> 
            <br>
            <span class="dv-span-row group-list-item-desc group-description">{{group.description}}</span> 
          </div>
          <div class="div-inline">
           <span class="dv-span-row">
             <v-icon name="lock" class="" v-if="group.visibility=='is_private'" />
             <v-icon name="globe" class="" v-else-if="group.visibility=='is_public'"/>
             <v-icon name="shield-alt" v-else />
           </span> 
           <span class="bv-custom-span " v-if="group.owner_id==MyUserId">Owner</span>
         </div>
       </div>
     </b-row>
   </b-col>
   <b-col sm="1" class="bv-custom-col-1">
    <span v-if="group.owner_id==MyUserId" @click="fnRedirectToGroup(group.id)">
      <v-icon name="cog" class="" />
    </span>
  </b-col>
  <b-col sm="1" class="bv-custom-col-1">
   <span @click="fnRedirectToMembers(group.id)">
    <v-icon name="users" class="" />
  </span>
</b-col>
</b-row>
</div>
<div class="row" :class="{spnGroupHide: !IsPublicGroupsActive}">
 <div class="row">
  <b-row class="group-list-group-item-div" v-for="(group,index) in PublicGroups" :key="index">
    <b-col sm="10">
      <b-row @click="fnGetGroupDetails(group.id)">
       <v-icon name="folder" class="folder-img-icon"/>
       <div class="avatar-circle" v-if="!group.avatar">
         <span class="initials upper-case">{{group.name[0]}}</span>
       </div>
       <img :src="group.avatar" v-if="group.avatar" class="group-list-img">
       <div class="groups-list-item-anc">
         <div class="div-inline">
           <span class="dv-span-row group-list-item-title ellipsis-span">{{group.name}}</span> 
           <br>
           <span class="dv-span-row group-list-item-desc group-description">{{group.description}}</span> 
         </div>
         <div class="div-inline">
           <span class="dv-span-row">
             <v-icon name="globe" class=""/>
           </span>
           <span class="bv-custom-span " v-if="group.owner_id==MyUserId">Owner</span>
         </div>
       </div>
     </b-row>
   </b-col>
   <b-col sm="1" class="bv-custom-col-1">
    <span @click="fnRedirectToGroup(group.id)" v-if="group.owner_id==MyUserId">
      <v-icon name="cog" class="" />
    </span>
   </b-col>
   <b-col sm="1" class="bv-custom-col-1">
     <span @click="fnRedirectToMembers(group.id)">
      <v-icon name="users" class=""/>
    </span>                  
  </b-col>
</b-row>
</div> 
</div>
</div>
</b-row>
</div>
</template>

<script>
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  export default {
    components: {},
    data(){
      return {  
        IsYourGroupsActive:true,
        IsPublicGroupsActive:false,
        DisableError: true,
        EditGroupErrorMessage:'',
        DisableSuccess: true,
        EditGroupSuccessMessage: '',
        APIURL:process.env.ROOT_API,
        YourGroups:[],
        ActualYourGroups:[],
        PublicGroups:[],
        ActualPublicGroups:[],
        Search:'',
        TabName:'YourGroups',
        MyUserId:'',
        name:'',
        sort_by:'created_at desc'
      }
    },
    props:{
      _is_public:''
    },
    mounted(){
      var user = JSON.parse(localStorage.getItem("user"));
      this.MyUserId = user.id;
      if(this._is_public == 'true')
      {
        this.IsYourGroupsActive=false;
        this.IsPublicGroupsActive=true;

        axios.get('group_listing/public_groups').
        then((response) => {
          this.PublicGroups=response.data.groups;
          this.ActualPublicGroups=response.data.groups;
        }).
        catch((error) => {
          console.log(error.data);
        });
      }
      else{
        this.IsYourGroupsActive=true;
        this.IsPublicGroupsActive=false;
      }
      axios.get('group_listing/your_groups').
      then((response) => {
        this.YourGroups=response.data.groups;
        this.ActualYourGroups=response.data.groups;
      }).
      catch((error) => {
        console.log(error.data);
      });
    },
    created() {
    },
    methods:{
      fnRedirectToMembers(id){
        location.href = CommonFunctions.url_with_domain('members/group_members?group_id='+id);
      },
      fnGetGroupDetails(id){
        location.href = CommonFunctions.url_with_domain('groups/'+id);
      },
      fnCloseSuccessMessageDiv(){
        this.DisableSuccess=true;
      },
      fnCloseErrorMessageDiv(){
        this.DisableError=true;
      },
      fnRedirectToGroup(id){
        location.href = CommonFunctions.url_with_domain("groups/edit?id="+id);
      },
      fnSearchGroupsList(){
        if(this.TabName=='YourGroups'){
          var self=this;

          axios.get('group_listing/your_groups?name='+this.name+'&sort_by='+this.sort_by).
          then((response) => {
            this.YourGroups=response.data.groups;
            this.ActualYourGroups=response.data.groups;
          }).
          catch((error) => {
            console.log(error.data);
          });
        }
        else if(this.TabName=='PublicGroups'){
          var self=this;
          axios.get('group_listing/public_groups?name='+this.name+'&sort_by='+this.sort_by).
          then((response) => {
            this.PublicGroups=response.data.groups;
            this.ActualPublicGroups=response.data.groups;
          }).
          catch((error) => {
            console.log(error.data);
          });
        }
      },
      fnShowTabs(tabName){
        this.TabName=tabName;
        if(tabName=='YourGroups'){
          this.IsYourGroupsActive=true;
          this.IsPublicGroupsActive=false;
        }
        else if(tabName=='PublicGroups'){
          this.IsYourGroupsActive=false;
          this.IsPublicGroupsActive=true;

          axios.get('group_listing/public_groups').
          then((response) => {
            this.PublicGroups=response.data.groups;
            this.ActualPublicGroups=response.data.groups;
          }).
          catch((error) => {
            console.log(error.data);
          });
        }
      }
    }
  }
</script>
<style type="text/css">
  .spnGroupHide{
    display: none;
  }
</style> 