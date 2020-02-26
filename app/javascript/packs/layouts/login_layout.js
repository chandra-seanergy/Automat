import Vue from 'vue';
import LoginLayout from 'components/layouts/login_layout';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#layouts-login_layout',
    components: {
        'layouts-login_layout': LoginLayout
    }
});
