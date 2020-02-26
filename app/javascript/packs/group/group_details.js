import Vue from 'vue';
import GroupDetailsView from 'components/group/group_details';
import BootstrapVue from 'bootstrap-vue';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";

Vue.use(BootstrapVue);
Vue.use(Loading);
Vue.component("v-icon", Icon);

new Vue({
    el: '#group_details_view',
    components: {
        'group_details_view': GroupDetailsView
    }
});
