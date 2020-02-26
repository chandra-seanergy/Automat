import Vue from 'vue';
import PasswordSettingsView from 'components/password_settings/password_settings';
import BootstrapVue from 'bootstrap-vue';
import axios from 'commons/jquery-ajax';

Vue.use(BootstrapVue);

new Vue({
    el: '#password_settings-view',
    components: {
        'password_settings-view': PasswordSettingsView
    }
});