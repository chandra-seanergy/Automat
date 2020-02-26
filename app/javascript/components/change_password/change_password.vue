	<template>
		<div>
			<div class="row home-main-div">
				<div class="row home-menu-div">
					You can change password here
				</div>
				<div class="row home-menu-content">
					<b-col sm="6" class="home-menu-desc">
						<div class="desc-welcome-div">
							<h2 class="desc-welcome-heading">Welcome to</h2>
						</div>
						<div class=desc-company-div>
							<h2 class="desc-company-heading">Factz</h2>
						</div>
						<div class="desc-title-div">
							<h3 class="desc-title-heading">Research & Collaboration  Tool</h3>
						</div>
					</b-col>
					<b-col sm="6" class="home-menu-login-reg">
						<div class="login-reg-main-div">
							<div class="login-reg-buttons-div">
								<ul class="forgot-password-heading">
									<li class="forgot-password-li">Change Your Password</li>
								</ul>
							</div>
							<div class="login-reg-body-div row">
								<form method="post" action="/users/password/update">
									<input type="hidden" name="authenticity_token" :value="csrf">
									<input type="hidden" name="user[reset_password_token]" v-model="reset_password_token"/>
									<div>
										<div class="login-reg-label">
											New Password
										</div>
										<div class="login-reg-input-div">
											<input type="password" class="default-text-input" name="user[password]" v-model="password">
											<p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:password }">Please enter Password</p>
											<p class="validation-error" v-if="!fnPasswordLength()">Minimum length is 8 characters.</p>
										</div>
										<div class="login-reg-label">
											Confirm New Password
										</div>
										<div class="login-reg-input-div">
											<input type="password" class="default-text-input" name="user[password_confirmation]" v-model="password_confirmation">
											<p class="validation-error" v-if="ButtonClicked"  :class="{ spnHide:password_confirmation }">Please enter Confirm Password</p>
											<p class="validation-error" v-if="!ComparePasswords()">New Password and Confirm Password should be same</p>
										</div>
										<div class="row margin-top-16">
											<input type="submit" class="default-btn" v-on:click="submit" value="Change Your Password">
										</div>
										<div class="row margin-top-16">
											<div class="login-reg-label">Didn't receive a confirmation email? <span class="anchor-btn-color" @click="fnResendConfirmEmail">Request a new one</span></div>
											<div class="login-reg-label">Already have login and password? <a class="anchor-btn-color" rel="nofollow" data-method="delete"  href="/users/sign_in">Sign in</a></div>
										</div>
									</div>
								</form>
							</div>
						</div>
					</b-col>
				</div>
			</div>
		</div>
	</template>
	<script>
		import axios from 'commons/jquery-ajax';
		import CommonFunctions from 'commons/common_functions.js';
		export default {
			data: function() {
				return ({
					csrf: document.querySelector('meta[name="csrf-token"]').getAttribute('content')
				})
			},
			props: {
				password: {
					default: ''
				},
				password_confirmation:{
					default:''
				},
				reset_password_token:{
					default:''
				},
				ButtonClicked:{

					default:''
				},
				Token:{
					default:''
				}
			},
			mounted () {
				let uri = window.location.href.split('=');
				this.reset_password_token = uri[1];
			},
			methods:{
				fnResendConfirmEmail() {
					location.href = CommonFunctions.url_with_domain("users/sign_in?id="+1);
				},
				fnPasswordLength(){
					if(this.password.length<8 && this.password!=''){
						return false;
					}
					else{
						return true;
					}
				},
				ComparePasswords(){
					if(this.password!=this.password_confirmation && this.password_confirmation!=''){
						return false;
					}
					return true;
				},
				submit:function(){
					this.ButtonClicked='clicked';
					if(this.password!='' && this.password_confirmation!='' && this.ComparePasswords() && this.fnPasswordLength()){
						this.$refs.form.submit();
					}
					else{
						event.preventDefault();
					}
				}
			}
		}
	</script>
</script>