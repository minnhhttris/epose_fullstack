<template>
  <transition name="slide">
    <aside v-if="isVisible" class="sidebar-admin">
      <nav>
        <ul>
          <li :class="{ active: activePage === 'dashboard' }" @click="navigate('dashboard','Dashboard')">
            <i class="fas fa-home"></i>
          </li>
          <li :class="{ active: activePage === 'posts' }" @click="navigate('posts', 'PostsManager')">
            <i class="fas fa-newspaper"></i>
          </li>
          <li :class="{ active: activePage === 'users' }" @click="navigate('users', 'UsersManager')">
            <i class="fas fa-users"></i>
          </li>
          <li :class="{ active: activePage === 'clothes' }" @click="navigate('clothes', 'ClothesManager')">
            <i class="fas fa-tshirt"></i>
          </li>
          <li :class="{ active: activePage === 'stores' }" @click="navigate('stores', 'StoresManager')">
            <i class="fas fa-store"></i>
          </li>
          <li :class="{ active: activePage === 'bills' }" @click="navigate('bills', 'BillsManager')">
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
      default: "dashboard"
    }
  },
  methods: {
    navigate(page, routeName) {
      this.$emit('navigate', page); 
      this.$router.push({ name: routeName }); 
      localStorage.setItem('activePage', page); 
    },
    logout() {
      localStorage.removeItem('authToken');
      localStorage.removeItem('activePage');
      this.$router.push({ name: 'Login' });
    }
  }
};
</script>


<style src="./SidebarAdmin.scss" scoped></style>
