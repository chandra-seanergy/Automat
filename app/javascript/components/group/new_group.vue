<template>
  <div>
    <b-container class="bv-content" fluid>
      <div
      class="message-div success-message user-sucess"
      :class="{spnHide:DisableSuccess}">
      <div class="btn-close-message-div" @click="fnCloseSuccessMessageDiv()">X</div>
      {{EditGroupSuccessMessage}}
    </div>
    <div
    class="message-div success-message user-error"
    :class="{spnHide:DisableError}">
    <div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
    {{EditGroupErrorMessage}}
  </div>
  <b-row align-v="center" class="bv-header-line">
    <b-col>
      <h3 v-if="ShowSaveButton">New Group</h3>
      <h3 v-else>Edit Group</h3>
    </b-col>
  </b-row>
  <b-row>
    <b-col sm="4">
      <p>
        <a href="#" class="anchor-btn-color">Groups</a> allow you to manage and collaborate across multiple projects.
        Members of a group have access to all of its projects.
      </p>
      <p>Groups can also be nested by creating<a href="#" class="anchor-btn-color gap">sub groups</a></p>
      <p>
        Projects that belong to a group are prefixed with the group namespace.
        Existing projects may be moved into group.
      </p>
    </b-col>
    <b-col sm="8" class="padLeft60">
      <b-form>
        <b-form-group label="Group Name" label-for="input-1">
          <b-form-input
          type="text"
          placeholder
          class="bv-form-control-text"
          v-model="group.name"
          ></b-form-input>
        </b-form-group>
        <p
        class="validation-error"
        v-if="ButtonClicked"
        :class="{ spnHide:group.name }"
        >Please fill in a descriptive name for your group.</p>
        <b-form-group
        id="input-group-3"
        label="Group Description (Optional)"
        label-for="input-1">
        <b-form-textarea
        placeholder
        rows="3"
        max-rows="6"
        class="bv-form-control-text-area"
        v-model="group.description"
        ></b-form-textarea>
      </b-form-group>
      <b-form-group id="input-group-3" label="Group Avatar" label-for="input-1">
        <img :src="Img" class="group-file-img" v-if="ShowImg" />
        <input type="file" id="file" ref="file" @change="selectedFile" accept="image/*" />
        <p>The maximum file size allowed is 200KB</p>
      </b-form-group>
      <b-form-group label class>
        <label class="bold-font">Visibility level</label>
        <p>
          Who will be able to see this group ?
          <a
          class="anchor-btn-color"
          href="#"
          >View the documentation</a>
        </p>
        <input type="radio" name="some-radios" v-model="group.visibility" value="is_private">
        <v-icon name="lock" />Private
        <p>The group and its projects can only be viewed by members.</p>
      </b-form-radio>
      <input type="radio" name="some-radios" v-model="group.visibility" value="is_internal">
      <v-icon name="shield-alt" />Internal
      <p>The group and any internal projects can be viewed by logged in user.</p>
    </b-form-radio>
    <input type="radio" name="some-radios" v-model="group.visibility" value="is_public">
    <v-icon name="globe-asia" />Public
    <p>The group and any public projects can be viewed without any authentication.</p>
  </b-form-radio>
</b-form-group>
<div class="marbottom30">
  <b-button
  class="default-btn bv-create-group-button"
  @click="fnCreateGroup()"
  v-if="ShowSaveButton">Create Group</b-button>
  <b-button
  class="default-btn bv-create-group-button"
  @click="fnCreateGroup()"
  v-if="!ShowSaveButton">Update Group</b-button>
  <b-button class="default-btn bv-cancel-group-button" to="/group_listing/group_list">Cancel</b-button>
  <div class="delete-group-main-div" v-if="ShowDeleteDiv">
    <div class="delete-group-heading">Remove group</div>
    <div class="delete-group-desc">Removed group can not be restored!</div>
    <input
    type="button"
    class="default-btn delete-group-btn"
    value="Remove group"
    v-b-modal.modal-1
    />
  </div>
</div>
</b-form>
</b-col>
</b-row>
</b-container>
<b-modal id="modal-1" title="Confirmation required" hide-footer>
  <p
  class="my-4 remove-group-p1 mar-zero"
  >You are going to remove {{group.name}}. Removed groups CANNOT be restored! Are you ABSOLUTELY sure?</p>
  <p
  class="my-4 remove-group-p2 mar-zero"
  >This action can lead to data loss.To prevent accidental actions we ask you to confirm your intention.</p>
  <p class="my-4 remove-group-p3 mar-zero">
    Please type
    <span class="group-delete-random-txt">{{group.name}}</span> to proceed or close this modal to cancel.
  </p>
  <input
  type="text"
  class="form-control"
  name="close-modal-txt"
  v-model="DeleteAccountTxt"
  @keyup="fnCompareGroupNames()"
  />
  <div class="delete-group-modal-footer">
    <input
    type="button"
    class="default-btn confirm-group-btn"
    value="Confirm"
    :disabled="ConfirmDisable"
    @click="fnDeleteGroup()"
    />
  </div>
</b-modal>
</div>
</template>

<script>
  import axios from 'commons/jquery-ajax';
  import CommonFunctions from 'commons/common_functions.js';
  export default {
    components: {},
    data() {
      return {
        image: {
          size: ""
        },
        group: {
          id: "",
          name: "",
          description: "",
          visibility: "is_private",
          avatar: ""
        },
        ButtonClicked: "",
        DisableError: true,
        EditGroupErrorMessage: "",
        DisableSuccess: true,
        EditGroupSuccessMessage: "",
        DeleteAccountTxt: "",
        ConfirmDisable: true,
        ShowDeleteDiv: false,
        ShowImg: false,
        Img: "",
        ShowSaveButton:true
      };
    },
    props:{
      _group: {}
    },
    mounted() {
      if (this._group != undefined) {
        this.ShowSaveButton=false;
        var groupData = this._group;
        this.group.id = groupData.id;
        this.group.name = groupData.name;
        this.group.description = groupData.description;   
        this.group.visibility = groupData.visibility;
        var user = JSON.parse(localStorage.getItem("user"));
        if(this._group.owner_id == user.id){
          this.ShowDeleteDiv = true;
        }
      }
      else{
        this.ShowSaveButton=true;
    }
    },
    methods: {
      selectedFile() {
        this.file = this.$refs.file.files[0];
        if(this.file!=undefined)
        {
          if(this.file.size>200*1024){
            this.DisableError=false;
            this.EditGroupErrorMessage="The file size shouldn't exceed 200 KB";
            document.documentElement.scrollTop = 0;
            var self = this;
            setTimeout(() => {
              self.DisableError=true;
            }, 2000);
            return false;
          }
        }
      },
      fnCompareGroupNames() {
        if (this.group.name == this.DeleteAccountTxt) {
          this.ConfirmDisable = false;
        } else {
          this.ConfirmDisable = true;
        }
      },
      fnCloseSuccessMessageDiv() {
        this.DisableSuccess = true;
      },
      fnCloseErrorMessageDiv() {
        this.DisableError = true;
      },
      fnDeleteGroup() {
        var idparam = this.group.id;
        if(idparam != '' || idparam != undefined){
          this.$root.$emit('bv::hide::modal','modal-1');
          let loader = this.$loading.show({
            loader: "dots",
            color: "#282697"
          });
          var data={
            'id': idparam,
            'authenticity_token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
          axios.post("groups/delete_group", data)
          .then(response => {
            if (response.data.status == 201 || response.data.status == 200) {
              this.DisableSuccess = false;
              this.EditGroupSuccessMessage = response.data.message;
              var self = this;
              setTimeout(() => {
                self.DisableSuccess=true;
                location.href = CommonFunctions.url_with_domain("group_listing/group_list");
              }, 5000);
            } else {
              this.DisableError = false;
              this.EditGroupErrorMessage =
              "An error occured while processing your request";
            }
          })
          .catch(error => {
            console.log(error.data);
          });
        }
      },
      fnCreateGroup() {
        this.ButtonClicked = "clicked";
        if (this.group.name == "") {
          this.InValidCount = 1;
        } else {
          this.InValidCount = 0;
        }
        if (this.InValidCount == 1) {
          return false;
        } else {
          var data = {
            user: this.user
          };
          this.file = this.$refs.file.files[0];
          if(this.file!=undefined)
          {
            if(this.file.size>200*1024){
              this.DisableError=false;
              this.EditGroupErrorMessage="The file size shouldn't exceed 200 KB";
              document.documentElement.scrollTop = 0;
              return false;
            }
          }
          let formData = new FormData();
          formData.append("group[avatar]", this.file);
          formData.append("group[name]", this.group.name);
          formData.append("group[description]", this.group.description);
          formData.append("group[visibility]", this.group.visibility);
          formData.append('authenticity_token', document.querySelector('meta[name="csrf-token"]').getAttribute('content'));
          var idparam = this.group.id;
          if (idparam == "") {
            let loader = this.$loading.show({
              loader: "dots",
              color: "#282697"
            });
            axios.postMultipart("groups", formData)
            .then(response => {
              if (response.data.status == 201 || response.data.status == 200) {
                this.DisableSuccess = false;
                this.EditGroupSuccessMessage = response.data.message;
                var self = this;
                setTimeout(() => {
                  self.DisableSuccess=true;
                  location.href = CommonFunctions.url_with_domain("group_listing/group_list");
                }, 5000);
              } else {
                this.DisableError = false;
                this.EditGroupErrorMessage = response.data.message;
              }
              document.documentElement.scrollTop = 0;
            })
            .catch(error => {
              console.log(error.data);
            });
          } else {
            let loader = this.$loading.show({
              loader: "dots",
              color: "#282697"
            });
            axios.updateMultipart("groups/" + idparam, formData)
            .then(response => {
              loader.hide();
              if (response.data.status == 201 || response.data.status == 200) {
                this.DisableSuccess = false;
                this.EditGroupSuccessMessage = response.data.message;
                var self = this;
                setTimeout(() => {
                  self.DisableSuccess=true;
                }, 5000);
              } else {
                this.DisableError = false;
                this.EditGroupErrorMessage = response.data.message;
                var self = this;
                setTimeout(() => {
                  self.DisableError=true;
                }, 5000);
              }
              document.documentElement.scrollTop = 0;
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