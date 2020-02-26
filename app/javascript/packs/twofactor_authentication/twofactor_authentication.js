import Vue from 'vue';
import TwoFactorAuthenticationView from 'components/twofactor_authentication/twofactor_authentication';
import BootstrapVue from 'bootstrap-vue';
import axios from 'commons/jquery-ajax';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";

Vue.use(BootstrapVue);
Vue.use(Loading);

new Vue({
    el: '#twofactor_authentication',
    components: {
        'twofactor_authentication': TwoFactorAuthenticationView
    }
});