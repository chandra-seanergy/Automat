import Vue from 'vue';
import WelcomeView from 'components/welcome/welcome';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#welcome_view',
    components: {
        'welcome_view': WelcomeView
    }
});