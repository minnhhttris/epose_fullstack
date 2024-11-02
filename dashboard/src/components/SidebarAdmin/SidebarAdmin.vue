<template>
  <transition name="slide">
    <aside v-if="isVisible" class="sidebar-admin">
      <nav>
        <ul>
          <li :class="{ active: activePage === 'dashboard' }" @click="navigate('Dashboard')">
            <i class="fas fa-home"></i>
          </li>
          <li :class="{ active: activePage === 'posts' }" @click="navigate('PostsManager')">
            <i class="fas fa-newspaper"></i>
          </li>
          <li :class="{ active: activePage === 'users' }" @click="navigate('UsersManager')">
            <i class="fas fa-users"></i>
          </li>
          <li :class="{ active: activePage === 'clothes' }" @click="navigate('ClothesManager')">
            <i class="fas fa-tshirt"></i>
          </li>
          <li :class="{ active: activePage === 'stores' }" @click="navigate('StoresManager')">
            <i class="fas fa-store"></i>
          </li>
          <li :class="{ active: activePage === 'bills' }" @click="navigate('BillsManager')">
            <i class="fas fa-file-invoice"></i>
          </li>
        </ul>
      </nav>
      <div class="logout" @click="logout">
        <i class="fas fa-sign-out-alt"></i>
      </div>
    </aside>
  </transition>
</template>

<script>
export default {
  name: 'SidebarAdmin',
  props: {
    isVisible: {
      type: Boolean,
      default: true
    },
    activePage: {
      type: String,
      default: "dashboard",
    },
  },
  mounted() {
    // Lấy trang hoạt động từ localStorage
    const storedPage = localStorage.getItem('activePage');
    if (storedPage) {
      this.$emit('navigate', storedPage); 
    }
  },
  methods: {
    navigate(page) {
      this.$emit('navigate', page); 
      this.$router.push({ name: page }); 
      localStorage.setItem('activePage', page); 
    },

    logout() {
      console.log('Logging out');
    }
  }
}
</script>

<style src="./SidebarAdmin.scss" scoped></style>
