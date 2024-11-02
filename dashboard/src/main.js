// import { dom, library } from "@fortawesome/fontawesome-svg-core"
// import { fab } from "@fortawesome/free-brands-svg-icons"
// import { far } from "@fortawesome/free-regular-svg-icons"
// import { fas } from "@fortawesome/free-solid-svg-icons"
// import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome"
// import Antd, { Button, Drawer, List, Menu } from 'ant-design-vue'

// import "bootstrap-vue-next/dist/bootstrap-vue-next.css";
// import 'bootstrap/dist/css/bootstrap.min.css'
// import 'bootstrap/dist/js/bootstrap.bundle.min.js';
// import '@fortawesome/fontawesome-free/css/all.min.css';

// import { createApp } from 'vue'
// import App from './App.vue'
// import router from './router'
// import VueToast from 'vue-toast-notification';
// import 'vue-toast-notification/dist/theme-sugar.css';


// library.add(fas, far, fab);
// dom.watch();
// const app = createApp(App)
// app.component("font-awesome-icon", FontAwesomeIcon);
// app.use(store)
// app.use(router)
// app.use(Antd)
// app.use(List);
// app.use(Menu);
// app.use(Button);
// app.use(Drawer);
// app.use(VueToast);

// app.mount('#app')

import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import "bootstrap/dist/css/bootstrap.css";

const app = createApp(App);
app.use(router);
app.mount("#app");
