import Vue from 'vue';
import ForgotPasswordView from 'components/forgot_password/forgot_password';
import BootstrapVue from 'bootstrap-vue';
import axios from 'commons/jquery-ajax';

Vue.use(BootstrapVue);
Vue.use(VueCookies);

new Vue({
    el: '#forgot_password-new-view',
    components: {
        'forgot_password-new-view': ForgotPasswordView
    }
});