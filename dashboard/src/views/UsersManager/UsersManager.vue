<template>
    <div class="users">
        <h2>Quản lý người dùng</h2>
        <div class="table-container">
            <div class="scrollable-table-content">
                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Email</th>
                            <th>Tên Người Dùng</th>
                            <th>Avatar</th>
                            <th>Số Điện Thoại</th>
                            <th>Địa Chỉ</th>
                            <th>CCCD</th>
                            <th>CCCD_img</th>
                            <th>Giới Tính</th>
                            <th>Ngày Sinh</th>
                            <th>Vai Trò</th>
                            <th>Trạng Thái</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(user, index) in users" :key="user.idUser">
                            <td>{{ index + 1 }}</td>
                            <td>{{ user.email }}</td>
                            <td>{{ user.userName || 'Không có' }}</td>
                            <td><img :src="user.avatar" alt="Avatar" class="avatar-thumbnail" /></td>
                            <td>{{ user.phoneNumbers || 'Không có' }}</td>
                            <td>{{ user.address || 'Không có' }}</td>
                            <td>{{ user.CCCD || 'Không có' }}</td>
                            <td>
                                <ul>
                                    <li v-for="img in user.CCCD_img" :key="img">{{ img }}</li>
                                </ul>
                            </td>
                            <td>{{ translateGender(user.gender) }}</td>
                            <td>{{ formatDate(user.dateOfBirth) }}</td>
                            <td>
                                <select v-model="user.role" @change="updateUserRole(user)">
                                    <option value="owner">Chủ cửa hàng</option>
                                    <option value="employee">Nhân viên</option>
                                    <option value="user">Người dùng</option>
                                    <option value="admin">Quản trị viên</option>
                                </select>
                            </td>
                            <td>
                                <select v-model="user.isActive" @change="updateUserStatus(user)">
                                    <option :value=" true">Active</option>
                                    <option :value="false">Unactive</option>
                                </select>
                            </td>
                            <td>
                                <button @click="viewUserDetails(user)">Xem Chi Tiết</button>
                                <button @click="confirmDeleteUser(user.idUser)">Xóa</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Xác nhận xóa -->
        <div v-if="showDeleteDialog" class="delete-dialog-overlay">
            <div class="delete-dialog">
                <p>Bạn có chắc muốn xóa người dùng này không?</p>
                <div class="dialog-buttons">
                    <button @click="cancelDelete" class="cancel-button">Hủy</button>
                    <button @click="deleteUser" class="confirm-button">Xóa</button>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
import axiosClient from '../../api/axiosClient';

export default {
    name: 'UsersManager',
    data() {
        return {
            users: [],
            showDeleteDialog: false,
            userToDelete: null,
        };
    },
    mounted() {
        this.fetchUsers();
    },
    methods: {
        async fetchUsers() {
            try {
                const response = await axiosClient.get('/users/getAllUsers');
                if (response.data.success) {
                    this.users = response.data.data;
                } else {
                    console.error('Failed to fetch users:', response.data.message);
                }
            } catch (error) {
                console.error('Error fetching users:', error);
            }
        },
        viewUserDetails(user) {
            this.$router.push({ name: 'UserDetails', params: { idUser: user.idUser } });
        },
        confirmDeleteUser(idUser) {
            this.showDeleteDialog = true;
            this.userToDelete = idUser;
        },
        async deleteUser() {
            try {
                const response = await axiosClient.delete(`/users/${this.userToDelete}`);
                if (response.data.success) {
                    this.fetchUsers();
                    console.log("User deleted successfully");
                } else {
                    console.error("Không thể xóa người dùng:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi xóa người dùng:", error);
            } finally {
                this.cancelDelete();
            }
        },
        cancelDelete() {
            this.showDeleteDialog = false;
            this.userToDelete = null;
        },
        formatDate(date) {
            if (!date) return 'N/A';
            const formattedDate = new Date(date);
            return `${String(formattedDate.getDate()).padStart(2, '0')}/${String(formattedDate.getMonth() + 1).padStart(2, '0')}/${formattedDate.getFullYear()}`;
        },
        translateRole(role) {
            switch (role) {
                case 'owner': return 'Chủ cửa hàng';
                case 'employee': return 'Nhân viên';
                case 'user': return 'Người dùng';
                case 'admin': return 'Quản trị viên';
                default: return 'Chưa xác định';
            }
        },
        translateGender(gender) {
            switch (gender) {
                case 'male': return 'Nam';
                case 'female': return 'Nữ';
                case 'unisex': return 'Unisex';
                case 'other': return 'Khác';
                default: return 'Chưa xác định';
            }
        },

        async updateUserRole(user) {
            const data = { role: user.role };
            try {
                const response = await axiosClient.post(`/users/updateUserByIdUser/${user.idUser}`, data);
                if (response.data.success) {
                    alert("Cập nhật vai trò thành công!");
                } else {
                    console.error("Cập nhật vai trò thất bại:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi cập nhật vai trò người dùng:", error);
            }
        },
        async updateUserStatus(user) {
            const data = { isActive: user.isActive };
            try {
                const response = await axiosClient.post(`/users/updateUserByIdUser/${user.idUser}`, data);
                if (response.data.success) {
                    alert("Cập nhật trạng thái thành công!");
                } else {
                    console.error("Cập nhật trạng thái thất bại:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi cập nhật trạng thái người dùng:", error);
            }
        },
    },
};
</script>

<style scoped>
@import './UsersManager.scss';
</style>
