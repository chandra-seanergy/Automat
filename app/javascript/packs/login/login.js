import Vue from 'vue';
import LoginNewView from 'components/login/login';
import BootstrapVue from 'bootstrap-vue';
import VueCookies from 'vue-cookies';

Vue.use(BootstrapVue);
Vue.use(VueCookies);
Vue.use(Loading);

new Vue({
    el: '#login-new-view',
    components: {
        'login-new-view': LoginNewView
    }
});
