
<template>
  <div class="row">
    <div
    class="message-div success-message userprimary"
    :class="{spnHide:EnableSuccess}"
    >{{successmessage}}</div>
    <b-col sm="2" class="group-side-menu">
      <div
      class="group-side-menu-item user-settings"
      @click="fnGetGroupDetails(group.id)">
      <div class="avatar-circle" v-if="!group.avatar.url">
        <span class="initials upper-case">{{group.name[0]}}</span>
      </div>
      <img :src="Img" v-if="group.avatar.url" class="group-list-img" />
      <div class="group-side-menu-text group-side-menu-heading-txt ellipsis">{{group.name}}</div>
    </div>
    <div class="group-side-menu-item" @click="fnGetGroupDetails(group.id)">
      <v-icon name="circle-notch" class="group-side-menu-img" />
      <div class="group-side-menu-text">Details</div>
    </div>
    <div class="group-side-menu-item groupSideMenuActive" @click="fnGetGroupMembers(group.id)">
      <v-icon name="users" class="group-side-menu-img" />
      <div class="group-side-menu-text">Members</div>
    </div>
  </b-col>
  <b-col sm="10">
    <div class="bv-content">
      <b-row align-v="center" class="bv-header-line">
        <b-col>
          <h3>Members</h3>
        </b-col>
      </b-row>
      <b-row v-if="IfOwner == OwnerId">
        <b-col>
          <h6><span class="font14">Add new member to</span> {{group.name}}</h6>
        </b-col>
      </b-row>
      <b-row v-if="IfOwner == OwnerId">
        <b-col cols="6">
          <div class="main-search-emp-div">
            <div class="form-control input-search" @click="setFocus()">
              <div class="single-emp-txt" v-for="(item,index) in EmpsListSearch" :key="index">
                {{item.Name}}
                <span
                class="remove-btn"
                @click="fnDeleteItem(item.id)">X</span>
              </div>
              <input
              class="searchuser"
              placeholder="Search for a user"
              type="text"
              @keyup="onInput()"
              v-model="inputTxt"
              ref="search"
              />
            </div>
            <div class="emp-list-main-div" :class="{btnHide:EmpListHide}">
              <div
              class="emp-list-div row"
              @click="fnUpdateEmps(item.name,item.id)"
              v-for="(item,index) in EmpsList"
              :key="index"
              >
              <b-col sm="4"></b-col>
              <b-col sm="8">{{item.name}}</b-col>
            </div>
          </div>
        </div>
        <div
        class="div-search-text"
        >Search for members by name, username, or email, or invite new ones using their email address.</div>
      </b-col>
      <b-col cols="2">
        <b-form-select v-model="Role" variant="light" size="md" class="member-role-drop">
          <option value="0">Guest</option>
          <option value="1">Reporter</option>
          <option value="2">Developer</option>
          <option value="3">Maintainer</option>
          <option value="4">Owner</option>
        </b-form-select>
        <div class="div-search-text"><a href="#" class="anchor-btn-color">Read more</a>
          <span>about role permissions</span></div>
        </b-col>
        <b-col cols="2">
          <DatePicker
          placeholder="Expiration date"
          class="expire-date-txt"
          :disabledDates="disabledDates"
          v-model="ExpireDate"
          ></DatePicker>
          <div
          class="div-search-text"
          >On this date, the member(s) will automatically lose access to this group and all of it's project</div>
        </b-col>
        <b-col cols="2">
          <b-button
          :disabled="EmpsListSearch.length==0 || ExpireDate==''"
          size="sm"
          class="btn-success"
          @click="fnAddUserToGroup()"
          >Add to group</b-button>
        </b-col>
      </b-row>
      <b-row>
        <b-col cols="2">
          <span class="div-existing">Existing</span>
          <span class="div-existing-count">{{MembersList.length}}</span>
        </b-col>
      </b-row>
      <b-row class="member-table-header">
        <b-col cols="4" class="member-text">
          <span>Members with access to</span>
          <span class="member-name">{{group.name}}</span>
        </b-col>
        <b-col cols="4">
          <input
          v-model="searchname"
          type="search"
          name="search"
          id="search"
          placeholder="Search"
          class="form-control"
          @keyup="fnSearchMemberList()"
          />
        </b-col>
        <b-col cols="4">
          <span>Sort by</span>
          <span class="gap"></span>
          <b-form-select
          variant="light"
          size="lg"
          class="member-role-drop"
          v-model="member_sort_by"
          @change="fnSearchMemberList()"
          >
          <option value="last joined">Last joined</option>
          <option value="name ascending">Name, ascending</option>
          <option value="name descending">Name, descending</option>
          <option value="oldest joined">Oldest joined</option>
          <option value="oldest sign-in">Oldest sign in</option>
          <option value="recent sign-in">Recent sign in</option>
        </b-form-select>
      </b-col>
    </b-row>
    <b-row class="member-table-row" v-for="(item,index) in MembersList" :key="index">
      <b-col cols="6">
        <v-icon name="user" class="members-user-icon" />
        <div class="inline-display">
          <div class="member-emp-txt">
            <span class="member-name">{{item.name}}</span>
            <span>@{{item.username}}</span>
            <b-button
            v-if="IfOwner == item.id"
            variant="success"
            class="btn-success-custom"
            >it's you</b-button>
          </div>

          <div v-if="item.roleId != 5">
            <span class="font13">Given access</span>
            <span class="font13">{{ getYearsMonthsDays(item.joined_at) }}</span>
            <span class="font13">ago</span>
            <span class="expmsg font13 " 
            >Expires in about {{getFeatureYearsMonthsDays(item.expiration_date)}}</span>
          </div>
        </div>
      </b-col>
      <b-col class="member-details" cols="2">
        <span v-if="item.roleId == 5" class="bv-custom-span">owner</span>
        <span v-else class="bv-custom-span">{{ item.role }}</span>
      </b-col>
      <b-col v-if="item.roleId != 5" class="member-details" cols="2">
        <span>{{item.expiration_date}}</span>
      </b-col>
      <b-col v-if="item.roleId != 5 && IfOwner == OwnerId" class="member-details" cols="2">
        <b-button
        variant="danger"
        class="btn-delete-member"
        @click="fnDeleteMember(item.id)"
        >Delete</b-button>
      </b-col>
    </b-row>
  </div>
</b-col>
</div>
</template>

<script>
  import DatePicker from "vuejs-datepicker";
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  import TimeAgo from "vue2-timeago";
  import moment from "moment";
  export default {
    components: { DatePicker, TimeAgo, moment },
    data() {
      return {
        EnableSuccess: {
          default: true
        },
        successmessage: {
          default: ""
        },
        groupid: "",
        member_sort_by: "name ascending",
        IfOwner: "",
        Role: "0",
        OwnerId: "",
        ExpireDate: "",
        disabledDates: {
          to: new Date(Date.now() - 8640000)
        },
        GroupBtnDisabled: true,
        inputTxt: "",
        selection: "",
        EmpListHide: "hide",
        EmpsList: [],
        EmpsListSearch: [],
        MembersList: [],
        GroupUserList: [],
        GroupId: "",
        group: {
          id: "",
          name: "",
          description: "",
          visibility: "is_private",
          avatar: ""
        },
        ShowImg: false,
        Img: "",
        searchname: ""
      };
    },
    props:{
      _group:{},
      user: {
        type: Object,
        default: ()=>({
          credential: '',
          password: ''
        }),
      }
    },
    mounted() {
      if (this._group != undefined) {
        this.GroupId = this._group.id;
        var data = JSON.parse(localStorage.getItem("user"));
        this.IfOwner = data.id; 
        this.OwnerId = this._group.owner_id;      
        if (this._group.avatar.url != null) {
          this.Img = this._group.avatar.url;
          this.ShowImg = true;
        }
        this.group = this._group;
        axios.get("members/member_list?group_member[group_id]=" +this.GroupId)
        .then(response => {
          if (response != null) {
            this.groupid = this.GroupId;
            this.MembersList = response.data.members;
          }
        })
        .catch(error => {
          console.log(error.data);
        });
      }
    },
    created() {
      this.time = Date.now();
    },
    methods: {
      fnSearchMemberList() {
        axios.get(
          "members/member_list?group_member[group_id]=" +
          this.groupid +
          "&group_member[credential]=" +
          this.searchname +
          "&group_member[sort_by]=" +
          this.member_sort_by
          )
        .then(response => {
          this.MembersList = response.data.members;
        })
        .catch(error => {
          console.log(error.data);
        });
      },
      getFeatureYearsMonthsDays(date) {
        date=date+" 23:59:59";
        var currentDate = new Date();
        const expiration = moment(date);
        const diff = expiration.diff(currentDate);
        const diffDuration = moment.duration(diff);
        let years = diffDuration.years();
        let months = diffDuration.months();
        let days = diffDuration.days();
        let hours = diffDuration.hours();
        let minutes = diffDuration.minutes();
        if (years > 0) {
          var Ys = years == 1 ? years + " year and " : years + " years and ";
          var Ms = months == 1 ? months + " month" : months + " months";
          return Ys + Ms;
        }
        if (months > 0) {
          return months == 1 ? months + " month" : months + " months";
        }
        if (days > 0) {
          return days == 1 ? days + " day" : days + " days";
        }
        if (hours > 0) {
          return hours == 1 ? hours + " hour" : hours + " hours";
        } else {
          return minutes == 1 ? minutes + " minute" : minutes + " minutes";
        }

      },
      getYearsMonthsDays(date) {
        let fromTime = moment(date).diff(moment(), "milliseconds");
        let duration = moment.duration(fromTime);
        let years = duration.years() / -1;
        let months = duration.months() / -1;
        let days = duration.days() / -1;
        let hours = duration.hours() / -1;
        let minutes = duration.minutes() / -1;
        if (years > 0) {
          var Ys = years == 1 ? years + " year and " : years + " years and ";
          var Ms = months == 1 ? months + " month" : months + " months";
          return Ys + Ms;
        }
        if (months > 0) {
          return months == 1 ? months + " month" : months + " months";
//else return days == 1 ? days + " day" : days + " days";
}
if (days > 0) {
  return days == 1 ? days + " day" : days + " days";
}
if (hours > 0) {
  return hours == 1 ? hours + " hour" : hours + " hours";
} else {
  return minutes == 1 ? minutes + " minute" : minutes + " minutes";
}
},
setFocus: function() {
  this.$refs.search.focus();
},
fnDeleteItem(id) {
  this.EmpsListSearch = this.EmpsListSearch.filter(function(item) {
    return item.id !== id;
  });
},
fnDeleteMember(Id) {
  var result = confirm("Are you sure you want to delete Member!");
  if (result) {
    let loader = this.$loading.show({
      loader: "dots",
      color: "#282697"
    });
    var data = {
      group_member: {
        group_id: this.GroupId,
        user_id: Id
      },
      'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    };
    axios.post("members/delete_member", data)
    .then(response => {
      loader.hide();
      if (response.data.status == 201 || response.data.status == 200) {
        this.EnableSuccess = false;
        this.successmessage = response.data.message;
        var self = this;
        setTimeout(() => {
          self.EnableSuccess = true;
          location.href= CommonFunctions.url_with_domain("members/group_members?group_id="+this.GroupId);
        }, 5000);
      } 
    })
    .catch(error => {
      console.log(error.data);
    });
  }
},
fnAddUserToGroup() {
  let loader = this.$loading.show({
    loader: "dots",
    color: "#282697"
  });
  var groupUserIds = this.GroupUserList;
  this.EmpsListSearch.filter(function(el) {
    groupUserIds.push(el.id);
  });
  var data = {
    group_member: {
      group_id: this.GroupId,
      user_id: groupUserIds,
      member_type: this.Role,
      expiration_date: this.ExpireDate
    },
    'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  };
  axios.post("members", data)
  .then(response => {
    if (response.data.status == 201 || response.data.status == 200) {
      loader.hide();
      this.EnableSuccess = false;
      this.successmessage = response.data.message;
      setTimeout(() => {
        location.href= CommonFunctions.url_with_domain("members/group_members?group_id="+this.GroupId);
      }, 1000);
    }
  })
  .catch(error => {
    console.log(error.data);
  });
},
fnGetGroupDetails(id) {
  location.href = CommonFunctions.url_with_domain('groups/'+id);
},
fnGetGroupMembers(id) {
  location.href= CommonFunctions.url_with_domain("members/group_members?group_id="+this.GroupId);
},
fnUpdateEmps(name, id) {
  {
    this.EmpsListSearch.push({ Name: name, id: id });
    this.EmpListHide = "hide";
    this.inputTxt = "";
  }
},
onInput() {
  if (this.inputTxt == "") {
    this.EmpListHide = "hide";
  } else {
    this.EmpListHide = "";
    if (this.inputTxt.length < 3) {
      return false;
    } else {
      this.EmpListHide = "";
      let loader = this.$loading.show({
        loader: "dots",
        color: "#282697"
      });
      axios.get("members/user_list?credential=" + this.inputTxt)
      .then(response => {
        loader.hide();
        this.EmpsList = response.data.members;
      })
      .catch(error => {
        console.log(error.data);
      });
    }
  }
}
}
};
</script>