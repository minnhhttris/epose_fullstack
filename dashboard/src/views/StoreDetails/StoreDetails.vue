<template>
    <h2>Chi tiết cửa hàng</h2>

    <div class="store-details">
        <!-- Thông tin cửa hàng -->
        <div class="store-info">
            <img :src="store.logo" alt="Logo cửa hàng" class="store-logo" />
            <div class="info-text">
                <p><strong>Tên cửa hàng:</strong> {{ store.nameStore }}</p>
                <p><strong>Địa chỉ:</strong> {{ store.address }}</p>
                <p><strong>Mã số thuế:</strong> {{ store.taxCode }}</p>
                <p><strong>Giấy phép:</strong> {{ store.license }}</p>
                <p><strong>Đánh giá:</strong> {{ store.rate }}⭐</p>
            </div>
        </div>

        <!-- Bài viết của cửa hàng -->
        <h3>Bài viết của cửa hàng</h3>
        <div class="posts-grid">
            <div v-for="post in store.posts" :key="post.idPosts" class="post-card">
                <img :src="post.picture[0]" alt="Ảnh bài viết" class="post-image" />
                <div class="post-info">
                    <span>{{ post.favorite }} yêu thích</span>
                    <span>{{ post.comments.length }} bình luận</span>
                </div>
            </div>
        </div>

        <!-- Danh sách quần áo -->
        <h3>Danh sách quần áo của cửa hàng</h3>
        <div class="clothes-grid">
            <div v-for="clothes in store.clothes" :key="clothes.idItem" class="clothes-card">
                <img :src="clothes.listPicture[0]" alt="Ảnh quần áo" class="clothes-image" />
                <div class="clothes-info">
                    <p><strong>{{ clothes.nameItem }}</strong></p>
                    <p><strong>Màu:</strong> {{ clothes.color }}</p>
                    <p><strong>Giá:</strong> {{ formatCurrency(clothes.price) }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axiosClient from "../../api/axiosClient";

export default {
    name: "StoreDetails",
    data() {
        return {
            store: null,
        };
    },
    methods: {
        async fetchStoreDetails() {
            const idStore = this.$route.params.id;
            try {
                const response = await axiosClient.get(`/stores/${idStore}`);
                if (response.data.success) {
                    this.store = response.data.data;
                } else {
                    console.error("Không thể tải thông tin cửa hàng:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi tải thông tin cửa hàng:", error);
            }
        },
        formatCurrency(value) {
            return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(value);
        },
    },
    created() {
        this.fetchStoreDetails();
    },
};
</script>

<style scoped>
.store-details {
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.8);
    min-height: 100vh;
}

h2 {
    font-size: 2rem;
    margin-bottom: 20px;
}

.store-info {
    display: flex;
    align-items: center;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 30px;
}

.store-logo {
    width: 120px;
    height: 120px;
    object-fit: cover;
    border-radius: 50%;
    margin-right: 20px;
    border: 2px solid #4a56cc;
}

.info-text p {
    margin: 5px 0;
    color: #333;
    font-size: 1.1rem;
}

h3 {
    font-size: 1.6rem;
    color: #977364;
    margin-top: 20px;
    margin-bottom: 20px;
}

.posts-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
}

.post-card {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    overflow: hidden;
    background-color: #fff;
}

.post-image {
    width: 100%;
    height: 300px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 5px;
}

.post-info {
    display: flex;
    justify-content: space-between;
    font-size: 0.9rem;
    color: #555;
    padding-left: 30px;
    padding-right: 30px;
}

.clothes-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 20px;
}

.clothes-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 15px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s;
    cursor: pointer;
}

.post-card:hover,
.clothes-card:hover {
    transform: translateY(-5px);
    box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.15);
}

.clothes-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 10px;
}

.clothes-info {
    color: #333;
    font-size: 1rem;
}
</style>
