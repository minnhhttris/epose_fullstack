<template>
    <h2>Chi Tiết Người Dùng</h2>
    <div class="user-details">
        <button class="edit-button" @click="openEditDialog">Chỉnh sửa</button>
        <div v-if="user">
            <img :src="user.avatar" alt="Avatar" class="avatar" />
            <p><strong>Email:</strong> {{ user.email }}</p>
            <p><strong>Tên:</strong> {{ user.userName }}</p>
            <p><strong>Số điện thoại:</strong> {{ user.phoneNumbers }}</p>
            <p><strong>Địa chỉ:</strong> {{ user.address }}</p>
            <p><strong>CCCD:</strong> {{ user.CCCD }}</p>
            <p><strong>CCCD Hình ảnh:</strong></p>
            <div class="cccd-images">
                <img v-for="img in user.CCCD_img" :key="img" :src="img" alt="CCCD Image" class="cccd-image" />
            </div>
            <p><strong>Giới tính:</strong> {{ translateGender(user.gender) }}</p>
            <p><strong>Ngày sinh:</strong> {{ formatDate(user.dateOfBirth) }}</p>
            <p><strong>Vai trò:</strong> {{ translateRole(user.role) }}</p>
            <p><strong>Trạng thái:</strong> {{ translateStatus(user.isActive) }}</p>
            <p><strong>Số coins:</strong> {{ user.coins }}</p>
            <p><strong>Ngày tạo tài khoản:</strong> {{ formatDate(user.createdAt) }}</p>
            <p><strong>Ngày cập nhật cuối:</strong> {{ formatDate(user.updatedAt) }}</p>
        </div>
        <div v-else>
            <p>Không thấy thông tin người dùng...</p>
        </div>

        <div v-if="store" class="store-details">
            <h3>Cửa Hàng</h3>
            <img :src="store.logo" alt="Logo Store" class="store-logo" />
            <p><strong>Tên cửa hàng:</strong> {{ store.nameStore }}</p>
            <p><strong>Mã số thuế:</strong> {{ store.taxCode }}</p>
            <p><strong>Giấy phép kinh doanh:</strong> {{ store.license }}</p>
            <p><strong>Địa chỉ:</strong> {{ store.address }}</p>
            <p><strong>Đánh giá:</strong> {{ store.rate }}</p>
            <p><strong>Trạng thái:</strong> {{ translateStatus(store.status) }}</p>
            <p><strong>Ngày tạo:</strong> {{ formatDate(store.createdAt) }}</p>
            <p><strong>Ngày cập nhật cuối:</strong> {{ formatDate(store.updatedAt) }}</p>
            <p><strong>Vai trò của người dùng:</strong> {{ translateRole(store.user[0].role) }}</p>
        </div>
    </div>

    <!-- Hộp thoại chỉnh sửa -->
    <div v-if="showEditDialog" class="edit-dialog-overlay">
        <div class="edit-dialog">
            <h3>Chỉnh sửa thông tin</h3>
            <div class="form-group">
                <label>Tên:</label>
                <input v-model="editUserData.userName" type="text" />
            </div>
            <div class="form-group">
                <label>Số điện thoại:</label>
                <input v-model="editUserData.phoneNumbers" type="text" />
            </div>
            <div class="form-group">
                <label>Địa chỉ:</label>
                <input v-model="editUserData.address" type="text" />
            </div>
            <div class="form-group">
                <label>CCCD:</label>
                <input v-model="editUserData.CCCD" type="text" />
            </div>
            <div class="form-group">
                <label>Giới tính:</label>
                <select v-model="editUserData.gender">
                    <option value="male">Nam</option>
                    <option value="female">Nữ</option>
                    <option value="other">Khác</option>
                </select>
            </div>
            <div class="form-group">
                <label>Ngày sinh:</label>
                <input v-model="editUserData.dateOfBirth" type="date" :max="maxDate" />
            </div>

            <div class="dialog-buttons">
                <button @click="submitEdit" class="confirm-button">Lưu</button>
                <button @click="cancelEdit" class="cancel-button">Hủy</button>
            </div>
        </div>
    </div>

</template>

<script>
import axiosClient from '../../api/axiosClient';

export default {
    props: ['idUser'],
    data() {
        return {
            user: null,
            store: null,
            showEditDialog: false,
            editUserData: {},
            maxDate: new Date().toISOString().split("T")[0], 
        };
    },

    mounted() {
        this.fetchUserDetails();
        this.fetchUserStore();
    },
    methods: {
        async fetchUserDetails() {
            try {
                const response = await axiosClient.get(`/users/${this.$route.params.idUser}`);
                if (response.data.success) {
                    this.user = response.data.data;
                    // Chuyển đổi dateOfBirth về định dạng 'YYYY-MM-DD' nếu có giá trị
                    this.editUserData = {
                        ...this.user,
                        dateOfBirth: this.user.dateOfBirth
                            ? new Date(this.user.dateOfBirth).toISOString().split("T")[0]
                            : null
                    };
                } else {
                    console.error("Không thể lấy thông tin người dùng:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi lấy thông tin người dùng:", error);
            }
        },
        async fetchUserStore() {
            try {
                const response = await axiosClient.get(`/stores/user/${this.$route.params.idUser}`);
                if (response.data.success) {
                    this.store = response.data.data;
                } else {
                    console.log("Người dùng không có cửa hàng.");
                }
            } catch (error) {
                console.error("Lỗi khi lấy thông tin cửa hàng:", error);
            }
        },
        openEditDialog() {
            this.showEditDialog = true;
        },
        cancelEdit() {
            this.showEditDialog = false;
        },
        removeImage(index) {
            this.editUserData.CCCD_img.splice(index, 1);
        },
        onFileChange(field, event) {
            const files = Array.from(event.target.files);
            if (field === 'CCCD_img') {
                this.editUserData.CCCD_img = this.editUserData.CCCD_img.concat(files);
            }
        },
        async submitEdit() {
            try {
                const formData = new FormData();
                formData.append('userName', this.editUserData.userName);
                formData.append('phoneNumbers', this.editUserData.phoneNumbers);
                formData.append('address', this.editUserData.address);
                formData.append('gender', this.editUserData.gender);
                formData.append('dateOfBirth', new Date(this.editUserData.dateOfBirth).toISOString());

                const response = await axiosClient.post(
                    `/users/updateUserByIdUser/${this.$route.params.idUser}`,
                    formData,
                );

                if (response.data.success) {
                    this.user = { ...this.editUserData };
                    this.showEditDialog = false;
                    alert("Cập nhật thông tin thành công!");
                } else {
                    console.error("Không thể cập nhật thông tin người dùng:", response.data.message);
                }
            } catch (error) {
                alert("Lỗi khi cập nhật thông tin!");
                console.error("Lỗi khi cập nhật thông tin người dùng:", error);
            }
        },

        determineUpdateType() {
            return this.editUserData.CCCD_img && this.editUserData.CCCD_img.length > 0 ? "CCCD_img" : "existing_CCCD_img";
        },

        translateGender(gender) {
            switch (gender) {
                case 'male': return 'Nam';
                case 'female': return 'Nữ';
                case 'other': return 'Khác';
                case 'unisex': return 'Unisex';
                default: return 'Không xác định';
            }
        },
        translateStatus(status) {
            return status ? 'Đang hoạt động' : 'Không hoạt động';
        },
        translateRole(role) {
            switch (role) {
                case 'admin': return 'Quản trị viên';
                case 'owner': return 'Chủ cửa hàng';
                case 'employee': return 'Nhân viên';
                case 'user': return 'Người dùng';
                default: return 'Không có';
            }
        },
        formatDate(date) {
            if (!date) return 'N/A';
            const formattedDate = new Date(date);
            return `${String(formattedDate.getDate()).padStart(2, '0')}/${String(formattedDate.getMonth() + 1).padStart(2, '0')}/${formattedDate.getFullYear()}`;
        },
    },
};
</script>

<style scoped>
@import './UserDetails.scss';
</style>
