<template>
  <header class="header-admin">
    <div class="left-section">
      <!-- <button @click="$emit('toggle-sidebar')" class="toggle-button">
        ☰
      </button> -->
    </div>
    <div class="center-section">
      <img src="/images/Logo-EPose.png" alt="EPose Logo" class="logo" />
      <span class="brand">EPOSE</span>
    </div>
    <div class="user-info" v-if="user">
      <div class="user-details">
        <p class="user-name">{{ user.userName }}</p>
        <p class="user-role">{{ user.role }}</p>
      </div>
      <img :src="user.avatar" alt="User Avatar" class="avatar" />
    </div>
  </header>
</template>

<script>
import axiosClient from '../../api/axiosClient';

export default {
  name: 'HeaderAdmin',
  data() {
    return {
      user: null,
      breadcrumbs: [],
    };
  },
  async mounted() {
    try {
      const response = await axiosClient.get('/users/me');
      if (response.data.success) {
        this.user = response.data.data;
      }
    } catch (error) {
      console.error('Error fetching user info:', error);
    }
    this.updateBreadcrumb();
  },
  watch: {
    $route() {
      this.updateBreadcrumb();
    },
  },
  methods: {
    updateBreadcrumb() {
      this.breadcrumbs = this.$route.matched.map(route => ({
        path: route.path,
        name: route.meta.breadcrumb || route.name,
      }));
    },
  },
};
</script>

<style src="./HeaderAdmin.scss" scoped></style>
