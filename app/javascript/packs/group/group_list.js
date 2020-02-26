import Vue from 'vue';
import GroupListView from 'components/group/group_list';
import BootstrapVue from 'bootstrap-vue';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";

Vue.use(BootstrapVue);
Vue.use(Loading);
Vue.component("v-icon", Icon);

new Vue({
    el: '#group_list_view',
    components: {
        'group_list_view': GroupListView
    }
});
