import Vue from 'vue';
import EditProfileView from 'components/edit_profile/edit_profile';
import BootstrapVue from 'bootstrap-vue';
import axios from 'commons/jquery-ajax';
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon";


Vue.use(BootstrapVue);
Vue.component("v-icon", Icon);

new Vue({
    el: '#edit_profile-view',
    components: {
        'edit_profile-view': EditProfileView
    }
});