<template>
	<component :is="layout">
		<router-view />
	</component>
</template>

<script>
import AdminLayout from './layouts/AdminLayout.vue';

export default {
	computed: {
		layout() {
			// Kiểm tra meta để áp dụng layout tương ứng
			return this.$route.meta.layout || 'div';
		}
	},
	components: {
		AdminLayout
	}
}
</script>

<style>
/* Thêm các style chung tại đây */
</style>
