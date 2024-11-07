<template>
    <div class="posts-manager">
        <h2>Quản lý bài viết</h2>
        <div class="post-list">
            <div v-for="post in posts" :key="post.idPosts" class="post-card" @click="viewPostDetails(post)">
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

        <!-- Modal chi tiết bài viết -->
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
                    <div class="post-image-slider">
                        <img :src="selectedPost.picture[currentImageIndex]" alt="Post image" />
                        <button v-if="currentImageIndex > 0" @click="prevImage" class="prev-button">←</button>
                        <button v-if="currentImageIndex < selectedPost.picture.length - 1" @click="nextImage"
                            class="next-button">→</button>
                    </div>
                    <div class="post-comments">
                        <h4>Bình luận:</h4>
                        <div v-for="comment in selectedPost.comments" :key="comment.idComment" class="comment">
                            <img :src="comment.user.avatar || defaultAvatar" alt="User avatar" class="comment-avatar" />
                            <div>
                                <p class="comment-user">{{ comment.user.userName || 'Anonymous' }}</p>
                                <p class="comment-text">{{ comment.comment }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axiosClient from "../../api/axiosClient";

export default {
    name: "PostsManager",
    data() {
        return {
            posts: [],
            selectedPost: null,
            currentImageIndex: 0,
            defaultAvatar: "https://example.com/default-avatar.png",
        };
    },
    mounted() {
        this.fetchPosts();
    },
    methods: {
        async fetchPosts() {
            try {
                const response = await axiosClient.get("/posts/");
                if (response.data.success) {
                    this.posts = response.data.posts;
                } else {
                    console.error("Không thể tải bài viết:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi tải bài viết:", error);
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
        }
    },
};
</script>

<style scoped>
.posts-manager {
    padding: 20px;
}

.post-list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}

.post-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    cursor: pointer;
    background-color: #f9f9f9;
    transition: box-shadow 0.3s ease;
}

.post-card:hover {
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
}

.post-header {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.store-logo {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
}

.post-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    aspect-ratio: 1 / 1;
    /* Square images */
    border-radius: 8px;
}

.post-stats {
    display: flex;
    justify-content: space-between;
    font-size: 14px;
    color: #555;
    margin-top: 10px;
}

/* Modal chi tiết bài viết */
.post-details-modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.modal-content {
    background-color: white;
    padding: 20px;
    width: 80%;
    max-width: 600px;
    border-radius: 8px;
    position: relative;
    max-height: 90%;
    overflow-y: auto;
}

.close-button {
    position: absolute;
    top: 15px;
    right: 15px;
    background-color: rgba(200, 200, 200, 0.8);
    color: white;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    font-size: 20px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    transition: background-color 0.3s;
}

.close-button:hover {
    background-color: rgba(255, 0, 0, 1);
}

.post-content {
    margin-top: 20px;
}

.post-image-slider {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
}

.post-image-slider img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    aspect-ratio: 1 / 1;
    /* Square images */
    border-radius: 8px;
}

.prev-button,
.next-button {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background-color: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 16px;
}

.prev-button {
    left: 10px;
}

.next-button {
    right: 10px;
}

.post-comments {
    margin-top: 20px;
}

.comment {
    display: flex;
    align-items: flex-start;
    margin-bottom: 10px;
}

.comment-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    margin-right: 10px;
}

.comment-user {
    font-weight: bold;
    color: #333;
}

.comment-text {
    color: #555;
}
</style>
