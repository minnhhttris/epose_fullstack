<template>
  <div class="login-container">
    <div class="login-box">
      <img src="/images/Logo-EPose.png" alt="E-Pose Logo" class="login-logo" />
      <h2>Đăng nhập Admin EPose</h2>
      <form @submit.prevent="handleLogin">
        <div class="input-group">
          <label for="email">Email:</label>
          <input type="email" id="email" v-model="email" required placeholder="Nhập email của bạn..." />
        </div>
        <div class="input-group">
          <label for="password">Mật khẩu:</label>
          <input type="password" id="password" v-model="password" required placeholder="Nhập mật khẩu của bạn..." />
        </div>
        <button type="submit">Login</button>
        <p v-if="errorMessage" class="error">{{ errorMessage }}</p>
      </form>
    </div>
  </div>
</template>

<script>
import axiosClient from '../../api/axiosClient';
import './LoginAdmin.scss';

export default {
  name: 'LoginAdmin',
  data() {
    return {
      email: '',
      password: '',
      errorMessage: ''
    };
  },
  methods: {
    async handleLogin() {
      try {
        const response = await axiosClient.post('/users/login', {
          email: this.email,
          password: this.password
        });

        if (response.data.success) {
          localStorage.setItem('accessToken', response.data.accessToken);
          this.$router.push('/dashboard');
        } else {
          this.errorMessage = 'Đăng nhập không thành công!';
        }
      } catch (error) {
        console.error('Error logging in:', error);
        this.errorMessage = 'Email hoặc mật khẩu không chính xác!';
      }
    }
  }
};
</script>

<style scoped>
@import './LoginAdmin.scss';
</style>
