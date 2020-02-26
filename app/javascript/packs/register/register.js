import Vue from 'vue';
import RegisterNewView from 'components/register/register';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#register-new-view',
    components: {
        'register-new-view': RegisterNewView
    }
});
