import Vue from 'vue';
import HomeNewView from 'components/home/home';
import BootstrapVue from 'bootstrap-vue';
import VueCookies from 'vue-cookies';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";

Vue.use(VueCookies);
Vue.use(BootstrapVue);
Vue.use(Loading);

new Vue({
    el: '#home-new-view',
    components: {
        'home-new-view': HomeNewView
    }
});
