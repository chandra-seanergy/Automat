import Vue from 'vue';
import EmailConfirmationView from 'components/register/email_confirmation';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#email-confirmation-view',
    components: {
        'email-confirmation-view': EmailConfirmationView
    }
});
