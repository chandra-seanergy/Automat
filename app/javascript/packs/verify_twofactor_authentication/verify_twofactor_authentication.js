import Vue from 'vue';
import VerifyTwofactorView from 'components/verify_twofactor_authentication/verify_twofactor_authentication';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#verify_twofactor_authentication_view',
    components: {
        'verify_twofactor_authentication_view': VerifyTwofactorView
    }
});
