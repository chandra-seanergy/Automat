import Vue from 'vue';
import ResendConfirmationView from 'components/register/resend_confirmation';
import BootstrapVue from 'bootstrap-vue';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";

Vue.use(BootstrapVue);
Vue.use(Loading);

new Vue({
    el: '#resend-confirmation-view',
    components: {
        'resend-confirmation-view': ResendConfirmationView
    }
});
