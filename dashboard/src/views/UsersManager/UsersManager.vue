<template>
    <div class="users">
        <h2>Quản Lý Người Dùng</h2>
        <table>
            <thead>
                <tr>
                    <th class="stt-column">STT</th>
                    <th class="email-column">Email</th>
                    <th>Tên Người Dùng</th>
                    <th class="status-column">Trạng Thái</th>
                    <th class="actions-column">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(user, index) in users" :key="user.idUser">
                    <td class="center-text">{{ index + 1 }}</td>
                    <td>{{ user.email }}</td>
                    <td>{{ user.userName || 'Không có' }}</td>
                    <td class="center-text">{{ user.isActive ? 'Active' : 'unActive' }}</td>
                    <td class="center-text">
                        <button @click="toggleDetails(user)">
                            {{ selectedUser && selectedUser.idUser === user.idUser ? 'Thu Gọn' : 'Xem Chi Tiết' }}
                        </button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Bảng Chi Tiết Người Dùng -->
        <div v-if="selectedUser" class="detail-panel">
            <span class="close" @click="closeModal">&times;</span>
            <h3>Chi Tiết Người Dùng</h3>
            <div v-if="selectedUser.avatar">
                <img :src="selectedUser.avatar" alt="Ảnh Đại Diện" class="avatar" />
            </div>
            <p><strong>Email:</strong> {{ selectedUser.email }}</p>
            <p><strong>Tên Người Dùng:</strong> {{ selectedUser.userName || 'Không có' }}</p>
            <p><strong>Số Điện Thoại:</strong> {{ selectedUser.phoneNumbers || 'Không có' }}</p>
            <p><strong>Địa Chỉ:</strong> {{ selectedUser.address || 'Không có' }}</p>
            <p><strong>CCCD:</strong> {{ selectedUser.CCCD || 'Không có' }}</p>
            <p><strong>Giới Tính:</strong> {{ selectedUser.gender || 'Không có' }}</p>
            <p><strong>Ngày Sinh:</strong> {{ formatDate(selectedUser.dateOfBirth) }}</p>
            <p><strong>Ngày Tạo:</strong> {{ formatDateTime(selectedUser.createdAt) }}</p>
            <p><strong>Ngày Cập Nhật:</strong> {{ formatDateTime(selectedUser.updatedAt) }}</p>
            <p><strong>Vai Trò:</strong> {{ selectedUser.role }}</p>
            <p><strong>Trạng Thái:</strong> {{ selectedUser.isActive ? 'active' : 'unActive' }}</p>
            <p><strong>Số Xu:</strong> {{ selectedUser.coins }}</p>
            <div v-if="selectedUser.CCCD_img && selectedUser.CCCD_img.length">
                <h4 class="cccd-title">Ảnh CCCD:</h4>
                <div class="cccd-img-container">
                    <img v-for="img in selectedUser.CCCD_img" :src="img" :key="img" alt="Ảnh CCCD" class="cccd-img" />
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
            selectedUser: null,
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
        toggleDetails(user) {
            if (this.selectedUser && this.selectedUser.idUser === user.idUser) {
                this.selectedUser = null;
            } else {
                this.selectedUser = user;
            }
        },
        closeModal() {
            this.selectedUser = null;
        },
        formatDate(date) {
            if (!date) return 'N/A';
            const formattedDate = new Date(date);
            return `${String(formattedDate.getDate()).padStart(2, '0')}/${String(formattedDate.getMonth() + 1).padStart(2, '0')
                }/${formattedDate.getFullYear()}`;
        },
        formatDateTime(dateTime) {
            if (!dateTime) return 'N/A';
            const formattedDateTime = new Date(dateTime);
            return `${String(formattedDateTime.getHours()).padStart(2, '0')}:${String(formattedDateTime.getMinutes()).padStart(2, '0')
                } ${String(formattedDateTime.getDate()).padStart(2, '0')}/${String(formattedDateTime.getMonth() + 1).padStart(2, '0')
                }/${formattedDateTime.getFullYear()}`;
        },
    },
};
</script>

<style scoped>
.users {
    padding: 5px;
}

table {
    width: 100%;
    border-collapse: collapse;
    background-color: rgba(255, 255, 255, 0.8);
}

th {
    padding: 8px;
    text-align: center;
    border: 1px solid #cac9c9;
    background-color: rgba(200, 200, 200, 0.8);
}

td {
    padding: 8px;
    border: 1px solid #cac9c9;
    text-align: left;
}

.stt-column {
    width: 8%;
}

.email-column {
    width: 26%;
}

.status-column,
.actions-column {
    width: 20%;
}

.center-text {
    text-align: center;
}

button {
    padding: 5px 10px;
    cursor: pointer;
    background: none;
    font-style: italic;
    border: none;
    color: #6d4c41;
}

.detail-panel {
    margin-top: 10px;
    position: fixed;
    bottom: 10px;
    right: 25px;
    width: 500px;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.8);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    border-radius: 5px;
    max-height: 70vh;
    overflow-y: auto;
    text-align: left;
    z-index: 1000;
}

.close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
    font-size: 20px;
}

.avatar {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 50%;
    margin-bottom: 15px;
}

.cccd-title {
    font-size: 14px;
    font-weight: bold;
    margin-top: 10px;
}

.cccd-img-container {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.cccd-img {
    width: 160px;
    height: 120px;
    border-radius: 5px;
}
</style>
