<template>
    <h2>Dashboard</h2>
    <div class="dashboard">

        <!-- Thống kê tổng quan -->
        <div class="summary">
            <div class="summary-item user-count">
                <i class="fas fa-users icon"></i>
                <h3>Tổng người dùng</h3>
                <p>{{ totalUsers }}</p>
            </div>
            <div class="summary-item bill-count">
                <i class="fas fa-file-invoice-dollar icon"></i>
                <h3>Tổng đơn thuê</h3>
                <p>{{ totalBills }}</p>
            </div>
            <div class="summary-item store-count">
                <i class="fas fa-store icon"></i>
                <h3>Tổng cửa hàng</h3>
                <p>{{ totalStores }}</p>
            </div>
            <div class="summary-item clothes-count">
                <i class="fas fa-tshirt icon"></i>
                <h3>Tổng quần áo</h3>
                <p>{{ totalClothes }}</p>
            </div>
            <div class="summary-item post-count">
                <i class="fas fa-clipboard icon"></i>
                <h3>Tổng bài viết</h3>
                <p>{{ totalPosts }}</p>
            </div>
        </div>

        <!-- Two-column layout for Top 5 Stores and Top 5 Posts -->
        <div class="top-content">
            <!-- Top 5 Stores -->
            <div class="top-stores">
                <h3>Top các cửa hàng có đánh giá cao</h3>
                <div class="store-list">
                    <div v-for="(store, index) in topRatedStores" :key="index" class="store-card"
                        @click="goToStoreDetails(store.idStore)">
                        <img :src="store.logo" alt="Logo Store" class="store-logo" />
                        <div class="store-info">
                            <h4>{{ store.nameStore }}</h4>
                            <p>Đánh giá: {{ store.rate }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Top 5 Posts with Most Interactions -->
            <div class="top-posts">
                <h3>Top các bài viết có lượt tương tác tốt nhất</h3>
                <div class="post-list">
                    <div v-for="post in topInteractedPosts" :key="post.idPosts" class="post-card"
                        @click="viewPostDetails(post)">
                        <div class="post-header">
                            <img :src="post.store.logo" alt="Logo cửa hàng" class="store-logo" />
                            <div>
                                <h3>{{ post.store.nameStore }}</h3>
                            </div>
                        </div>
                        <div class="post-image">
                            <img :src="post.picture[0]" alt="Post image" />
                        </div>
                        <div class="post-stats">
                            <span>{{ post.favorite }} yêu thích</span>
                            <span>{{ post.comments.length }} bình luận</span>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="selectedPost" class="post-details-modal">
                <div class="modal-content">
                    <button @click="closePostDetails" class="close-button">✕</button>
                    <div class="post-header">
                        <img :src="selectedPost.store.logo" alt="Logo cửa hàng" class="store-logo" />
                        <div>
                            <h3>{{ selectedPost.store.nameStore }}</h3>
                        </div>
                    </div>
                    <div class="post-content">
                        <div class="post-caption">
                            <p>{{ selectedPost.caption }}</p>
                        </div>
                        <div class="post-image-slider">
                            <img :src="selectedPost.picture[currentImageIndex]" alt="Post image" />
                            <button v-if="currentImageIndex > 0" @click="prevImage" class="prev-button">←</button>
                            <button v-if="currentImageIndex < selectedPost.picture.length - 1" @click="nextImage"
                                class="next-button">→</button>
                        </div>
                        <div class="post-comments">
                            <h4>Bình luận:</h4>
                            <div v-for="comment in selectedPost.comments" :key="comment.idComment" class="comment">
                                <img :src="comment.user.avatar || defaultAvatar" alt="User avatar"
                                    class="comment-avatar" />
                                <div>
                                    <p class="comment-user">{{ comment.user.userName || comment.user.email }}</p>
                                    <p class="comment-text">{{ comment.comment }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
import axiosClient from '../../api/axiosClient';

export default {
    name: 'Dashboard',
    data() {
        return {
            totalUsers: 0,
            totalBills: 0,
            totalStores: 0,
            totalClothes: 0,
            totalPosts: 0,
            topRatedStores: [],
            topInteractedPosts: [],
            selectedPost: null,
            currentImageIndex: 0,
            defaultAvatar: "https://example.com/default-avatar.png"
        };
    },
    mounted() {
        this.fetchDashboardData();
    },
    methods: {
        async fetchDashboardData() {
            try {
                const usersResponse = await axiosClient.get('/users/getAllUsers');
                if (usersResponse.data.success) {
                    this.totalUsers = usersResponse.data.data.length;
                }

                const billsResponse = await axiosClient.get('/bill');
                if (billsResponse.data.success) {
                    this.totalBills = billsResponse.data.data.length;
                }

                const storesResponse = await axiosClient.get('/stores');
                if (storesResponse.data.success) {
                    this.totalStores = storesResponse.data.stores.length;
                    this.topRatedStores = storesResponse.data.stores
                        .sort((a, b) => b.rate - a.rate)
                        .slice(0, 6);
                }

                const clothesResponse = await axiosClient.get('/clothes');
                if (clothesResponse.data.success) {
                    this.totalClothes = clothesResponse.data.data.length;
                }

                const postsResponse = await axiosClient.get('/posts');
                if (postsResponse.data.success) {
                    this.totalPosts = postsResponse.data.posts.length;
                    this.topInteractedPosts = postsResponse.data.posts
                        .sort((a, b) => b.favorite - a.favorite)
                        .slice(0, 6);
                }
            } catch (error) {
                console.error('Lỗi khi lấy dữ liệu cho dashboard:', error);
            }
        },
        viewPostDetails(post) {
            this.selectedPost = post;
            this.currentImageIndex = 0;
        },
        closePostDetails() {
            this.selectedPost = null;
        },
        prevImage() {
            if (this.currentImageIndex > 0) {
                this.currentImageIndex--;
            }
        },
        nextImage() {
            if (this.currentImageIndex < this.selectedPost.picture.length - 1) {
                this.currentImageIndex++;
            }
        },
        goToStoreDetails(idStore) {
            this.$router.push({ name: 'StoreDetails', params: { id: idStore } });
        }
    }
};
</script>

<style scoped>
@import './Dashboard.scss';
</style>
