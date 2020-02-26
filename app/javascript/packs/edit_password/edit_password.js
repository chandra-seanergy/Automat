import Vue from 'vue';
import EditPasswordView from 'components/edit_password/edit_password';
import BootstrapVue from 'bootstrap-vue';
import axios from 'commons/jquery-ajax';
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.css';

Vue.use(BootstrapVue);
Vue.use(Loading);
Vue.use(Loading);

new Vue({
    el: '#edit_password',
    components: {
        'edit_password': EditPasswordView
    }
});