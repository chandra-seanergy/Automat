import Vue from 'vue';
import TermsPolicyView from 'components/terms/terms_services_privacy_policy';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#terms_policy_view',
    components: {
        'terms_policy_view': TermsPolicyView
    }
});