import Vue from 'vue';
import MembersListView from 'components/members/members_list';
import BootstrapVue from 'bootstrap-vue';
import Loading from "vue-loading-overlay";
import "vue-loading-overlay/dist/vue-loading.css";
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";
import TimeAgo from "vue2-timeago";

Vue.use(BootstrapVue);
Vue.use(Loading);
Vue.component("v-icon", Icon);
Vue.use(require("moment"));
Vue.use(TimeAgo, {
  locale: "en"
});

new Vue({
    el: '#members_list_view',
    components: {
        'members_list_view': MembersListView
    }
});
