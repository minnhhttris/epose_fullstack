import { createRouter, createWebHistory } from "vue-router";

// Layouts
import AdminLayout from "../layouts/AdminLayout.vue";

// Components
import Dashboard from "../views/Dashboard/Dashboard.vue";
import LoginAdmin from "../views/LoginAdmin/LoginAdmin.vue";
import ClothesManager from "../views/ClothesManager/ClothesManager.vue";
import BillsManager from "../views/BillsManager/BillsManager.vue";
import PostsManager from "../views/PostsManager/Posts.vue";
import UsersManager from "../views/UsersManager/UsersManager.vue";
import StoresManager from "../views/StoresManager/StoresManager.vue";


const routes = [
  {
    path: "/",
    name: "LoginAdmin",
    component: LoginAdmin,
    meta: {
      layout: null,
    },
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
    meta: {
      layout: AdminLayout,
    },
  },
  {
    path: "/clothes",
    name: "ClothesManager",
    component: ClothesManager,
    meta: {
      layout: AdminLayout,
    },
  },
  {
    path: "/bills",
    name: "BillsManager",
    component: BillsManager,
    meta: {
      layout: AdminLayout,
    },
  },
  {
    path: "/stores",
    name: "StoresManager",
    component: StoresManager,
    meta: {
      layout: AdminLayout,
    },
  },
  {
    path: "/posts",
    name: "PostsManager",
    component: PostsManager,
    meta: {
      layout: AdminLayout,
    },
  },
  {
    path: "/users",
    name: "UsersManager",
    component: UsersManager,
    meta: {
      layout: AdminLayout,
    },
  },
];

// Create Router
const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition;
    } else {
      return { top: 0 };
    }
  },
});

// Navigation Guard
router.beforeEach((to, from, next) => {
  console.log("Chuyển hướng đến:", to.name);
  next();
});

export default router;
