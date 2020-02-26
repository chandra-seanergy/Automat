import Vue from 'vue';
import TermsView from 'components/terms/terms';
import BootstrapVue from 'bootstrap-vue';

Vue.use(BootstrapVue);

new Vue({
    el: '#terms_view',
    components: {
        'terms_view': TermsView
    }
});