<template>
    <div class="stores">
        <h2>Quản lý cửa hàng</h2>
        <div class="tabs">
            <button :class="{ active: activeTab === 'active' }" @click="activeTab = 'active'">Hoạt động</button>
            <button :class="{ active: activeTab === 'pending' }" @click="activeTab = 'pending'">Chờ duyệt</button>
        </div>

        <div v-if="filteredStores.length === 0" class="no-store-message">
            Không có cửa hàng nào ở trạng thái này.
        </div>

        <div class="store-list">
            <div v-for="store in filteredStores" :key="store.idStore" class="store-card">
                <img :src="store.logo" alt="Logo cửa hàng" class="store-logo" />
                <h3>{{ store.nameStore }}</h3>
                <p><strong>Địa chỉ:</strong> {{ store.address }}</p>
                <p><strong>Mã số thuế:</strong> {{ store.taxCode }}</p>
                <p><strong>Trạng thái:</strong> {{ store.status === 'active' ? 'Hoạt động' : 'Chờ duyệt' }}</p>
                <button v-if="store.status !== 'active'" @click="approveStore(store)" class="approve-button">Duyệt cửa
                    hàng</button>
                <button @click="viewClothes(store)" class="view-clothes-button">Xem quần áo</button>
            </div>
        </div>

        <div v-if="selectedStore" class="clothes-list">
            <h3>Danh sách quần áo của {{ selectedStore.nameStore }}</h3>
            <div class="clothes-grid">
                <div v-for="clothes in selectedStore.clothes" :key="clothes.idItem" class="clothes-card">
                    <div class="clothes-image-container">
                        <img :src="clothes.listPicture[activeImage[clothes.idItem] || 0]" alt="Hình ảnh quần áo"
                            class="clothes-image" />
                        <div class="image-controls">
                            <button @click="prevImage(clothes.idItem)">‹</button>
                            <button @click="nextImage(clothes.idItem, clothes.listPicture.length)">›</button>
                        </div>
                    </div>
                    <h4>{{ clothes.nameItem }}</h4>
                    <p><strong>Mô tả:</strong> {{ clothes.description }}</p>
                    <p><strong>Giá:</strong> {{ clothes.price }} VND</p>
                    <p><strong>Màu:</strong> {{ clothes.color }}</p>
                    <p><strong>Kiểu dáng:</strong> {{ clothes.style }}</p>
                    <p><strong>Số lượng:</strong> {{ clothes.number }}</p>
                </div>
            </div>
            <button @click="closeClothesList" class="close-button">Đóng</button>
        </div>
    </div>
</template>

<script>
import axiosClient from '../../api/axiosClient';

export default {
    name: 'StoresManager',
    data() {
        return {
            stores: [],
            selectedStore: null,
            activeTab: 'active',
            activeImage: {},
        };
    },
    computed: {
        filteredStores() {
            return this.stores.filter(store => store.status === this.activeTab);
        },
    },
    mounted() {
        this.fetchStores();
    },
    methods: {
        async fetchStores() {
            try {
                const response = await axiosClient.get('/stores/getAllStores');
                if (response.data.success) {
                    this.stores = response.data.stores;
                } else {
                    console.error('Không thể tải cửa hàng:', response.data.message);
                }
            } catch (error) {
                console.error('Lỗi khi tải cửa hàng:', error);
            }
        },
        async approveStore(store) {
            try {
                const response = await axiosClient.post('/stores/approveStore', {
                    idStore: store.idStore,
                    idUser: store.idUser,
                });
                if (response.data.success) {
                    store.status = 'active';
                    alert('Cửa hàng đã được duyệt thành công');
                } else {
                    console.error('Không thể duyệt cửa hàng:', response.data.error);
                }
            } catch (error) {
                console.error('Lỗi khi duyệt cửa hàng:', error);
            }
        },
        viewClothes(store) {
            this.selectedStore = store;
            this.activeImage = {};
        },
        closeClothesList() {
            this.selectedStore = null;
        },
        nextImage(id, length) {
            this.activeImage[id] = (this.activeImage[id] + 1 || 1) % length;
        },
        prevImage(id) {
            this.activeImage[id] = (this.activeImage[id] - 1 + length) % length;
        }
    },
};
</script>

<style scoped>
.stores {
    padding: 20px;
    background-color: rgb(255, 255, 255, 0.8);
    min-height: 100vh;
}

.tabs {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
    justify-content: center;
    /* Canh giữa các nút */
}

.tabs button {
    background: none;
    border: none;
    padding: 8px 0;
    font-size: 18px;
    cursor: pointer;
    color: #555;
    /* Màu chữ mặc định */
    transition: color 0.3s, border-bottom 0.3s;
}

.tabs button.active {
    color: #977364;
    /* Màu chữ khi tab được chọn */
    border-bottom: 2px solid #977364;
    /* Gạch chân tab đang hoạt động */
}

.tabs button:hover {
    color: #977364;
    /* Đổi màu khi di chuột qua */
}

.no-store-message {
    margin-top: 20px;
    text-align: center;
    color: #977364;
}

.store-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}

.store-card {
    width: 220px;
    border: 1px solid #ddd;
    padding: 20px;
    border-radius: 12px;
    background-color: #ffffff;
    text-align: center;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.store-card:hover {
    transform: scale(1.05);
}

.store-logo {
    width: 80px;
    height: 80px;
    object-fit: cover;
    border-radius: 50%;
    margin-bottom: 15px;
    border: 2px solid #977364;
}

.approve-button,
.view-clothes-button {
    background-color: #513a31;
    color: #fff;
    padding: 8px 12px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    margin-top: 10px;
    font-weight: bold;
    transition: background-color 0.3s;
    width: 80%;
}

.approve-button:hover,
.view-clothes-button:hover {
    background-color: #977364;
}

.clothes-list {
    margin-top: 40px;
}

.clothes-grid {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 15px;
    justify-content: center;
}

.clothes-card {
    border: 1px solid #ddd;
    padding: 10px;
    border-radius: 8px;
    background-color: #ffffff;
    text-align: center;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s;
}

.clothes-card:hover {
    transform: scale(1.05);
}

.clothes-image-container {
    position: relative;
    height: 180px;
    overflow: hidden;
    border-radius: 8px;
    margin-bottom: 10px;
}

.clothes-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: opacity 0.3s;
}

.image-controls {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 100%;
    display: flex;
    justify-content: space-between;
    padding: 0 10px;
}

.image-controls button {
    background: rgba(0, 0, 0, 0.5);
    color: white;
    border: none;
    cursor: pointer;
    padding: 5px;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background-color 0.3s;
}

.image-controls button:hover {
    background-color: rgba(0, 0, 0, 0.7);
}

.close-button {
    background-color: #dc3545;
    color: #fff;
    padding: 10px 15px;
    border: none;
    cursor: pointer;
    margin-top: 20px;
    font-weight: bold;
    border-radius: 8px;
    transition: background-color 0.3s;
    width: 100px;
}

.close-button:hover {
    background-color: #b02a37;
}
</style>
