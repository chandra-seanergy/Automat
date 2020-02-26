<template>
  <div class="row home-main-div">
    <div class="row">
      <b-col sm="2" class="group-side-menu">
        <div class="group-side-menu-item">
          <div class="avatar-circle" v-if="!group.avatar.url">
            <span class="initials upper-case">{{group.name[0]}}</span>
          </div>
          <img :src="Img" v-if="group.avatar.url" class="group-list-img">
          <div class="group-side-menu-text group-side-menu-heading-txt ellipsis">
            {{group.name}}
          </div>
        </div>
        <div class="group-side-menu-item groupSideMenuActive" @click="fnGetGroupDetails(group.id)">
          <v-icon name="circle-notch" class="group-side-menu-img"/>
          <div class="group-side-menu-text">
            Details
          </div>
        </div>
        <div class="group-side-menu-item" @click="fnGetGroupMembers(group.id)">
          <v-icon name="users" class="group-side-menu-img"/>
          <div class="group-side-menu-text">
            Members
          </div>
        </div>
      </b-col>
      <b-col sm="10" class="group-content">
        <div class="group-details-group-desc row">
          <div class="group-details-img-div">
            <div class="avatar-circle" v-if="!group.avatar.url">
              <span class="initials upper-case">{{group.name[0]}}</span>
            </div>
            <img :src="Img" v-if="group.avatar.url" class="group-list-img">
          </div>
          <div class="group-details-heading-div">
            <div class="group-name-txt">
              {{group.name}}
            </div>
            <div class="group-id-txt">
              Group ID : {{group.id}}
            </div>
            <div class="group-details-desc">
              {{group.description}}
            </div>
          </div>
        </div>
      </b-col>
    </div>
  </div>

</template>

<script>
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  export default{
    data(){
      return{
        ShowMessageDiv: 'show',
        group: {
          id:'',
          name:'',
          description:'',
          visibility:'is_private',
          avatar:''     
        },       
        ShowImg:false,
        Img:''
      }
    },
    props:{
      _group:{}
    },
    mounted(){
      this.group = this._group;
      if(this.group.avatar.url!=null)
      {
        this.Img= this.group.avatar.url;
        this.ShowImg=true;
      }
    },
    methods:{
      fnGetGroupDetails(id){
        location.href= CommonFunctions.url_with_domain("groups/"+id);
      },
      fnGetGroupMembers(id){
        location.href= CommonFunctions.url_with_domain("members/group_members?group_id="+id);
      }
    }
  }
</script>