import Vue from 'vue';
import ChangePasswordView from 'components/change_password/change_password';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);
new Vue({
    el: '#change_password-view',
    components: {
        'change_password-view': ChangePasswordView
    }
});