<template>
	<div class="row">
		<div class="message-div">
			<span class="user-settings" @click="fnRedirectToProfile()">User Settings</span> > Edit Profile
		</div>
		<div
		class="message-div success-message user-sucess"
		:class="{spnHide:DisableSuccess}"
		>
		<div class="btn-close-message-div" @click="fnCloseSuccessMessageDiv()">X</div>
		{{EditProfileSuccessMessage}}
	</div>
	<div
	class="message-div success-message user-error"
	:class="{spnHide:DisableError}"
	>
	<div class="btn-close-message-div" @click="fnCloseErrorMessageDiv()">X</div>
	{{EditProfileErrorMessage}}
</div>
<b-row class="addBottomBorder">
	<b-col cols="4" align="left">
		<h4>Public Avatar</h4>
		<p class="font13">
			You can upload your avatar here or change it at
			<a
			class="anchor-btn-color"
			href="https://en.gravatar.com/"
			target="_blank"
			>gravatar.com</a>
		</p>
	</b-col>
	<b-col clos="2" align="left">
		<div class="inline-display">
			<img :src="Img" class="user-upload-icon" v-if="ShowImg" />
			<v-icon name="user-circle" class="user-upload-icon" v-else />
		</div>
		<div class="inline-display pad-left35">
			<b class="blockDisplay">Upload new avatar</b>
			<div>
				<input @change="fnUploadImage" type="file" id="file" ref="file" accept="image/*" />
			</div>
			<p>The maximum file size allowed is 200 KB</p>
		</div>
	</b-col>
</b-row>
<b-row class="addBottomBorder">
	<b-col cols="4" align="left">
		<h4>Main Settings</h4>
		<p class="font13">The information will appear on your profile.</p>
	</b-col>
	<b-col cols="4" align="left">
		<div class="addBottomPadding">
			<b>Full name</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="name"
			v-model="user.name"
			></b-form-input>
			<p
			class="validation-error"
			v-if="ButtonClicked"
			:class="{ spnHide:user.name }"
			>This field is required</p>
			<small>Enter your name, so people you know can recognize you</small>
		</div>
		<div class="addBottomPadding">
			<b>Email</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="email"
			v-model="user.email"
			></b-form-input>
			<p
			class="validation-error"
			v-if="ButtonClicked"
			:class="{ spnHide:user.email }"
			>This field is required</p>
			<p class="validation-error" v-if="isEmailValid()">Please enter valid Email</p>
			<small>We also use email for avatar detection if no avatar is uploaded</small>
		</div>
		<div class="addBottomPadding">
			<b>Public email</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="public_email"
			v-model="user.public_email"
			></b-form-input>
			<p class="validation-error" v-if="isPublicEmailValid()">Please enter valid Email</p>
			<small>This email will be displayed on your public profile</small>
		</div>
		<div class="addBottomPadding">
			<b>Commit email</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="commit_email"
			v-model="user.commit_email"
			></b-form-input>
			<p class="validation-error" v-if="isCommitEmailValid()">Please enter valid Email</p>
			<small>
				This email will be used for web based operations, such as edits and merges.
				<a
				href="#"
				>Learn more</a>
			</small>
		</div>
		<div class="addBottomPadding">
			<b>Skype</b>
			<b-form-input
			id="input-small"
			placeholder="username"
			class="InputBox"
			name="skype"
			v-model="user.skype"
			></b-form-input>
		</div>
		<div class="addBottomPadding">
			<b>Linkedin</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="linkedin"
			v-model="user.linkedin"
			></b-form-input>
			<small>Your Linked in profile name from linkedin.com/in/profilename</small>
		</div>
		<div class="addBottomPadding">
			<b>Twitter</b>
			<b-form-input
			id="input-small"
			placeholder="@username"
			class="InputBox"
			name="twitter"
			v-model="user.twitter"
			></b-form-input>
		</div>
		<div class="addBottomPadding">
			<b>Website url</b>
			<b-form-input
			id="input-small"
			placeholder="webiste.com"
			class="InputBox"
			name="website_url"
			v-model="user.website_url"
			></b-form-input>
		</div>
		<div class="addBottomPadding">
			<b>Location</b>
			<b-form-input
			id="input-small"
			placeholder="City, country"
			class="InputBox"
			name="location"
			v-model="user.location"
			></b-form-input>
		</div>
		<div class="addBottomPadding">
			<b>Organization</b>
			<b-form-input
			id="input-small"
			placeholder
			class="InputBox"
			name="organization"
			v-model="user.organization"
			></b-form-input>
			<small>Who you represent or work for</small>
		</div>
		<div class="addBottomPadding">
			<b>Bio</b>
			<b-form-textarea
			id="textarea-small"
			size="lg"
			class="InputBox"
			name="bio"
			v-model="user.bio"
			></b-form-textarea>
			<small>Tell us about yourself in fewer than 250 characters</small>
			<hr />
		</div>
		<div class="addBottomPadding">
			<b>Private Profile</b>
			<div class="div-private-profile">
				<input type="checkbox" id="checkbox-1" v-model="user.private_profile" />
				<label
				for="checkbox-1"
				class="chk-inline"
				>Do not display activity-related personal information on your profiles</label>
			</div>
		</div>
		<div class="addBottomPadding">
			<b>Private Contributions</b>
			<div>
				<input type="checkbox" id="checkbox-2" v-model="user.private_contributions" />
				<label
				for="checkbox-2"
				class="chk-inline"
				>Include private contributions in my profile</label>
			</div>
			<div class="div-profile-txt">
				<small>Choose to show contributions of private projects on your public profile without any project,</small>
				<small>repository or organization information</small>
			</div>
		</div>

		<div class="addBottomPadding">
			<b-button
			variant="success"
			class="btn-update-username"
			@click="fnUpdateUserProfile()"
			>Update Profile Settings</b-button>
			<b-button variant="light" class="btn btn-cancel">Cancel</b-button>
		</div>
	</b-col>
	<b-col cols="4" class="user-userid">
		<b>User ID</b>
		<b-form-input
		id="input-small"
		placeholder
		disabled
		class="UserIdInput"
		v-model="user.id"
		></b-form-input>
	</b-col>
</b-row>
</div>
</template>

<script>
	import axios from 'commons/jquery-ajax';
	export default {
		components: { },
		data() {
			return {
				userAvatar: undefined,
				reg:/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,24}))$/,
				ShowImg:false,
				Img:"",
				DisableError: true,
				EditProfileErrorMessage:  "",
				DisableSuccess:true,
				EditProfileSuccessMessage:"",
				ButtonClicked:"",
				file: "", 	
			};
		},
		props: {
			Email: {
				type: String,
				default: ""
			},
			ImgPreview: {
				type: String,
				default: ""
			},
			user: {	
				type: Object,
				default: ()=>({
					bio: "",
					commit_email: "",
					email: "",
					id: "",
					linkedin: "",
					location: "",
					name: "",
					organization: "",
					otp_module: "",
					private_contributions: false,
					private_profile: false,
					public_email: "",
					skype: "",
					twitter: "",
					unique_user_id: "",
					website_url: "",
					avatar: "",
					avatarurl: ""
				}),
			}
		},
		mounted() {
			axios.get("profiles/my_profile")
			.then(response => {
				try{
					if (response.data.user.avatar.url != null && response.data.user.avatar.url != undefined) {
						this.Img = response.data.user.avatar.url;
						this.ShowImg = true;
					}
					else if(response.data.user.profile_pic != null || response.data.user.profile_pic != ""){
						this.Img = response.data.user.profile_pic;
						this.ShowImg = true;
					}
				}catch(e){
					if(response.data.user.profile_pic != null || response.data.user.profile_pic != ""){
						this.Img = response.data.user.profile_pic;
						this.ShowImg = true;
					}
				}
				this.user = response.data.user;
			})
			.catch(error => {
				console.log(error.data);
			});
		},
		methods: {
			fnUploadImage(e) {
				this.file = this.$refs.file.files[0];
				const fileName = e.target.files[0];
				this.ShowImg = true;
				this.Img = URL.createObjectURL(fileName);
			},
			fnRedirectToProfile() {
				this.$emit("fnRedirectToProfile");
			},
			fnCloseSuccessMessageDiv() {
				this.DisableSuccess = true;
			},
			fnCloseErrorMessageDiv() {
				this.DisableError = true;
			},
			isEmailValid() {
				return this.user.email == ""
				? ""
				: this.reg.test(this.user.email)
				? ""
				: "valid";
			},
			isPublicEmailValid() {
				return this.user.public_email == null || this.user.public_email == ""
				? ""
				: this.reg.test(this.user.public_email)
				? ""
				: "valid";
			},
			isCommitEmailValid() {
				return this.user.commit_email == null || this.user.commit_email == ""
				? ""
				: this.reg.test(this.user.commit_email)
				? ""
				: "valid";
			},
			fnLogin() {
				this.$emit("loginRedirect");
			},
			fnResetPassword() {
				this.ButtonClicked = "clicked";
				if (this.Email != "") {
				}
			},
			fnUpdateUserProfile() {
				this.ButtonClicked = "clicked";
				if (
					this.user.name == "" ||
					this.user.email == "" ||
					this.isEmailValid() != "" ||
					this.isPublicEmailValid() != "" ||
					this.isCommitEmailValid() != ""
					) {
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
				if (this.file != undefined) {
					if (this.file.size > 200 * 1024) {
						this.DisableError = false;
						this.EditProfileErrorMessage =
						"The file size shouldn't exceed 200 KB";
						document.documentElement.scrollTop = 0;
						return false;
					}
				}
				let loader = this.$loading.show({
					loader: "dots",
					color: "#282697"
				});
				let formData = new FormData();
				formData.append("user[avatar]", this.file);
				formData.append("user[name]", this.user.name);
				formData.append("user[email]", this.user.email);
				formData.append(
					"user[public_email]",
					this.user.public_email == null ? "" : this.user.public_email
					);
				formData.append(
					"user[commit_email]",
					this.user.commit_email == null ? "" : this.user.commit_email
					);
				formData.append(
					"user[skype]",
					this.user.skype == null ? "" : this.user.skype
					);
				formData.append(
					"user[linkedin]",
					this.user.linkedin == null ? "" : this.user.linkedin
					);
				formData.append(
					"user[twitter]",
					this.user.twitter == null ? "" : this.user.twitter
					);
				formData.append(
					"user[website_url]",
					this.user.website_url == null ? "" : this.user.website_url
					);
				formData.append(
					"user[location]",
					this.user.location == null ? "" : this.user.location
					);
				formData.append(
					"user[organization]",
					this.user.organization == null ? "" : this.user.organization
					);
				formData.append(
					"user[bio]",
					this.user.bio == null ? "" : this.user.bio
					);
				formData.append("user[private_profile]", this.user.private_profile);
				formData.append(
					"user[private_contributions]",
					this.user.private_contributions
					);
				formData.append('authenticity_token', document.querySelector('meta[name="csrf-token"]').getAttribute('content'));
				axios.postMultipart("profiles/update_profile", formData)
				.then(response => {
					if (response.data.status == 200) {
						loader.hide();
						this.DisableSuccess = false;
						this.EditProfileSuccessMessage = response.data.message;
						if ((response.data.avatar != null) & (response.data.avatar != "")) {
							this.Img = response.data.avatar;
						}
						var self = this;
						setTimeout(() => {
							self.DisableSuccess = true;
						}, 5000);
					}
					else {
						this.DisableError = false;
						this.EditProfileErrorMessage = response.data.message;
					}
					document.documentElement.scrollTop = 0;
				})
				.catch(error => {
					console.log(error.data);
				});
			}
		}
	}
};
</script>
