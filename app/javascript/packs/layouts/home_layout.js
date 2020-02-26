import Vue from 'vue';
import HomeLayout from 'components/layouts/home_layout';
import BootstrapVue from 'bootstrap-vue';
import "vue-awesome/icons";
import Icon from "vue-awesome/components/Icon.vue";

Vue.component("v-icon", Icon);

Vue.use(BootstrapVue);
new Vue({
    el: '#layouts-home_layout',
    components: {
        'layouts-home_layout': HomeLayout
    }
});
