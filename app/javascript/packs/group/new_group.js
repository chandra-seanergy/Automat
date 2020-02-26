import Vue from 'vue';
import NewGroupView from 'components/group/new_group';
import BootstrapVue from 'bootstrap-vue';
import VueCookies from 'vue-cookies';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";

Vue.use(BootstrapVue);
Vue.use(VueCookies);
Vue.use(Loading);
Vue.component("v-icon", Icon);

new Vue({
    el: '#new_group_view',
    components: {
        'new_group_view': NewGroupView
    }
});
