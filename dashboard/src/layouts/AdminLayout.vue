<template>
  <div class="admin-layout">
    <SidebarAdmin :isVisible="showSidebar" />
    <div :class="['content-wrapper', { 'expanded': !showSidebar }]">
      <HeaderAdmin @toggle-sidebar="toggleSidebar" />
      <main>
        <slot>
          
        </slot>
      </main>
      <FooterAdmin />
    </div>
  </div>
</template>

<script>
import HeaderAdmin from '../components/HeaderAdmin/HeaderAdmin.vue';
import SidebarAdmin from '../components/SidebarAdmin/SidebarAdmin.vue';
import FooterAdmin from '../components/FooterAdmin/FooterAdmin.vue';

export default {
  name: 'AdminLayout',
  components: {
    HeaderAdmin,
    SidebarAdmin,
    FooterAdmin
  },
  data() {
    return {
      showSidebar: true,
      activePage: 'dashboard',
      pageTilte: 'Trang chủ'
    };
  },
  methods: {
    toggleSidebar() {
      this.showSidebar = !this.showSidebar;
    },

    navigate(page) {
      this.activePage = page;
      this.pageTilte = this.getPageTitle(page);
    },
    getPageTitle(page) {
      switch (page) {
        case 'posts':
          return 'Quản lý bài viết';
        case 'users':
          return 'Quản lý người dùng';
        case 'clothes':
          return 'Quản lý trang phục';
        case 'stores':
          return 'Quản lý cửa hàng';
        case 'bills':
          return 'Quản lý đơn thuê';
        default:
          return 'Trang chủ quản lý';
      }
    }
  }
};
</script>

<style scoped>
* {
  font-family: 'Roboto', sans-serif;
}

.admin-layout {
  display: flex;
  min-height: 150%;
  background-image: url('/images/background.avif');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.content-wrapper {
  flex-grow: 1;
  margin-left: 80px;
  transition: margin-left 0.3s ease;
}

.content-wrapper.expanded {
  margin-left: 0;
}

main {
  padding: 20px;
  min-height: calc(100vh - 50px);
}
</style>
