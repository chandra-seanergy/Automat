import Vue from 'vue';
import SettingsView from 'components/user_settings/settings';
import BootstrapVue from 'bootstrap-vue';
import Loading from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/vue-loading.css';
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";

Vue.use(Loading);
Vue.use(BootstrapVue);
Vue.component("v-icon", Icon);

new Vue({
    el: '#settings-view',
    components: {
        'settings-view': SettingsView
    }
});
