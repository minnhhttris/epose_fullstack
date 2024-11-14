<template>
    <h2>Quản lý bài viết</h2>
    <div class="posts-manager">
        <!-- Bảng thông tin bài viết -->
        <table class="posts-table">
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên cửa hàng</th>
                    <th>Caption</th>
                    <th>Lượt yêu thích</th>
                    <th>Số bình luận</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(post, index) in posts" :key="post.idPosts">
                    <td>{{ index + 1 }}</td>
                    <td>{{ post.store.nameStore }}</td>
                    <td>{{ post.caption }}</td>
                    <td>{{ post.favorite }}</td>
                    <td>{{ post.comments.length }}</td>
                    <td>
                        <button @click="editPost(post)" class="edit-button">Chỉnh sửa</button>
                        <button @click="deletePost(post.idPosts)" class="delete-button">Xóa</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Modal chỉnh sửa bài viết -->
        <div v-if="editingPost" class="edit-post-modal">
            <div class="modal-content">
                <button @click="closeEditModal" class="close-button">✕</button>
                <h3>Chỉnh sửa bài viết</h3>
                <form @submit.prevent="updatePost">
                    <label for="post-caption">Caption</label>
                    <textarea v-model="editingPost.caption" id="post-caption" class="caption-textarea"></textarea>

                    <!-- Tải lên ảnh mới hoặc nhập link ảnh -->
                    <label>Hình ảnh mới:</label>
                    <input type="file" @change="handleImageUpload" class="file-input" multiple />

                    <label>Hoặc thêm link ảnh:</label>
                    <div class="image-link-input">
                        <input v-model="newImageLink" placeholder="Nhập link ảnh" class="link-input" />
                        <button type="button" @click="addImageLink" class="add-image-button">Thêm ảnh</button>
                    </div>

                    <!-- Hiển thị danh sách ảnh -->
                    <div class="image-list">
                        <div v-for="(image, index) in editingPost.picture" :key="index" class="image-item">
                            <img :src="image" alt="Hình ảnh bài viết" class="image-preview" />
                            <button type="button" @click="removeImage(index)" class="remove-image-button">Xóa</button>
                        </div>
                    </div>

                    <button type="submit" class="save-button">Lưu</button>
                </form>
            </div>
        </div>


        <!-- Danh sách bài viết dưới dạng thẻ -->
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
        <div v-if="selectedPost && !editingPost" class="post-details-modal">
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
                        <div v-for="comment in selectedPost.comments" :key="comment.idComment" class="comment"
                            @dblclick="confirmDeleteComment(comment.idComment)">
                            <img :src="comment.user.avatar || defaultAvatar" alt="User avatar" class="comment-avatar" />
                            <div>
                                <p class="comment-user">{{ comment.user.userName || comment.user.email }}</p>
                                <p class="comment-text">{{ comment.comment }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div v-if="showDeletePostDialog" class="delete-dialog-overlay">
            <div class="delete-dialog">
                <p>Bạn có chắc muốn xóa bài viết này không?</p>
                <div class="dialog-buttons">
                    <button @click="cancelDeletePost" class="cancel-button">Hủy</button>
                    <button @click="confirmDeletePost" class="confirm-button">Xóa</button>
                </div>
            </div>
        </div>

        <div v-if="showDeleteDialog" class="delete-dialog-overlay">
            <div class="delete-dialog">
                <p>Bạn có chắc muốn xóa bình luận này không?</p>
                <div class="dialog-buttons">
                    <button @click="cancelDelete" class="cancel-button">Hủy</button>
                    <button @click="confirmDelete" class="confirm-button">Xóa</button>
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
            editingPost: null,
            currentImageIndex: 0,
            defaultAvatar: "https://example.com/default-avatar.png",
            newImageLink: "", 
            selectedFiles: [],
            showDeleteDialog: false,
            showDeletePostDialog: false,
            commentToDelete: null,
            postToDelete: null,
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
        editPost(post) {
            this.editingPost = { ...post }; 
            this.selectedFiles = []; // Khởi tạo lại danh sách ảnh
        },
        closeEditModal() {
            this.editingPost = null;
            this.newImageLink = ""; // Reset link ảnh mới
        },
        addImageLink() {
            if (this.newImageLink) {
                this.editingPost.picture.push(this.newImageLink);
                this.newImageLink = "";
            }
        },
        removeImage(index) {
            this.editingPost.picture.splice(index, 1);
        },
        handleImageUpload(event) {
            this.selectedFiles = Array.from(event.target.files);
        },
        async updatePost() {
            try {
                const formData = new FormData();
                formData.append("caption", this.editingPost.caption);

                // Thêm các link ảnh hiện tại vào formData
                this.editingPost.picture.forEach((link, index) => {
                    formData.append(`imageLinks[${index}]`, link);
                });

                // Thêm các file ảnh tải lên vào formData
                this.selectedFiles.forEach((file) => {
                    formData.append("picture", file);
                });

                const response = await axiosClient.post(`/posts/${this.editingPost.idPosts}`, formData, {
                    headers: { "Content-Type": "multipart/form-data" },
                });

                if (response.data.success) {
                    this.fetchPosts(); 
                    this.closeEditModal();
                } else {
                    console.error("Không thể cập nhật bài viết:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi cập nhật bài viết:", error);
            }
        },
        deletePost(postId) {
            this.showDeletePostDialog = true;
            this.postToDelete = postId;
        },

        async confirmDeletePost() {
            try {
                const response = await axiosClient.delete(`/posts/${this.postToDelete}`);
                if (response.data.success) {
                    this.fetchPosts(); 
                    console.log("Xóa bài viết thành công");
                } else {
                    console.error("Không thể xóa bài viết:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi xóa bài viết:", error);
            } finally {
                this.cancelDeletePost();
            }
        },

        cancelDeletePost() {
            this.showDeletePostDialog = false;
            this.postToDelete = null;
        },


        async confirmDelete() {
            try {
                const response = await axiosClient.delete(`/comment/${this.commentToDelete}`);
                if (response.data.success) {
                    this.selectedPost.comments = this.selectedPost.comments.filter(comment => comment.idComment !== this.commentToDelete);
                    console.log("Đã xóa bình luận thành công");
                } else {
                    console.error("Không thể xóa bình luận:", response.data.message);
                }
            } catch (error) {
                console.error("Lỗi khi xóa bình luận:", error);
            } finally {
                this.cancelDelete();
            }
        },

        cancelDelete() {
            this.showDeleteDialog = false;
            this.commentToDelete = null;
        },

        confirmDeleteComment(idComment) {
            this.showDeleteDialog = true;
            this.commentToDelete = idComment;
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
@import './Posts.scss';
</style>
