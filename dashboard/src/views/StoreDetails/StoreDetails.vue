<template>
    <h2>Chi tiết cửa hàng</h2>

    <div class="store-details">
        <!-- Thông tin cửa hàng -->
        <div class="store-info-row">
            <!-- Thông tin cửa hàng -->
            <div class="store-info">
                <img :src="store.logo" alt="Logo cửa hàng" class="store-logo" />
                <div class="info-text">
                    <p><strong>Tên cửa hàng:</strong> {{ store.nameStore }}</p>
                    <p><strong>Địa chỉ:</strong> {{ store.address }}</p>
                    <p><strong>Mã số thuế:</strong> {{ store.taxCode }}</p>
                    <p><strong>Giấy phép:</strong> {{ store.license }}</p>
                    <div class="rating-container">
                        <strong>Đánh giá:</strong>
                        <div class="store-rating">
                            <div class="stars">
                                <span v-for="n in 5" :key="n" class="star"
                                    :class="{ filled: n <= Math.floor(store.rate), half: n > Math.floor(store.rate) && n <= Math.ceil(store.rate) }"></span>
                            </div>
                            <span class="rate-value">({{ store.rate.toFixed(1) }})</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông tin chủ cửa hàng -->
            <div v-if="owner" class="owner-info">
                <img :src="owner.avatar" alt="Avatar chủ cửa hàng" class="owner-avatar" />
                <div class="info-text">
                    <p><strong>Tên chủ cửa hàng:</strong> {{ owner.userName }}</p>
                    <p><strong>Email:</strong> {{ owner.email }}</p>
                    <p><strong>Số điện thoại:</strong> {{ owner.phoneNumbers }}</p>
                    <p><strong>Địa chỉ:</strong> {{ owner.address }}</p>
                    <p><strong>Căn cước công dân:</strong> {{ owner.CCCD}}</p>
                </div>
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
            owner: null,
        };
    },
    methods: {
        async fetchStoreDetails() {
            const idStore = this.$route.params.id;
            try {
                const response = await axiosClient.get(`/stores/${idStore}`);
                if (response.data.success) {
                    this.store = response.data.data;
                    this.fetchOwnerInfo(this.store.user[0].idUser);
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

        async fetchOwnerInfo(idUser) {
            try {
                const response = await axiosClient.get(`/users/${idUser}`);
                if (response.data.success) {
                    this.owner = response.data.data;  
                } else {
                    console.error("Không thể tải thông tin chủ cửa hàng:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi tải thông tin chủ cửa hàng:", error);
            }
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
.store-info,
.owner-info {
    width: 49%;

    padding: 10px;
}

.store-info-row {
    display: flex;
    justify-content: space-between;
    gap: 20px;
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

.owner-info {
    display: flex;
    align-items: center;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 30px;
}

.owner-avatar {
    width: 120px;
    height: 120px;
    object-fit: cover;
    height: auto;
    border-radius: 50%;
    margin-right: 20px;
}

.owner-info .info-text {
    font-size: 14px;
}

.owner-info .info-text p {
    margin-bottom: 10px;
}

.owner-info h3 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 15px;
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

.store-rating {
    margin-top: 5px;
    font-size: 14px;
    color: #666;
    display: flex;
    align-items: center;
    gap: 5px;
}


.stars {
    display: flex;
    gap: 2px;
}

.star {
    width: 20px;
    height: 20px;
    background-color: #ccc;
    clip-path: polygon(50% 0%, 61% 35%, 98% 35%, 68% 57%, 79% 91%, 50% 70%, 21% 91%, 32% 57%, 2% 35%, 39% 35%);
}

.star.filled {
    background-color: #fbc02d;
}

.star.half {
    background: linear-gradient(to right, #fbc02d 50%, #ccc 50%);
}

.rating-container {
    display: flex;
    align-items: center;
    gap: 5px;
}

</style>
