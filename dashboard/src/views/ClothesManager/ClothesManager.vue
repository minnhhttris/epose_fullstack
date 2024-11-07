<template>
    <div class="clothes">
        <h2>Quản lý quần áo</h2>
        <div class="clothes-list">
            <div v-for="clothes in clothesList" :key="clothes.idItem" class="clothes-card"
                @click="viewDetails(clothes)">
                <div class="store-info">
                    <img :src="clothes.store.logo" alt="Logo Store" class="store-logo" />
                    <p class="store-name">{{ clothes.store.nameStore }}</p>
                </div>
                <div class="clothes-image-container">
                    <img :src="clothes.listPicture[0]" alt="Clothes Image" class="clothes-image" />
                </div>
                <h4>{{ clothes.nameItem }}</h4>
                <p><strong>Giá:</strong> {{ formatPrice(clothes.price) }} VND</p>
                <div class="tags">
                    <span v-for="tag in clothesTags(clothes)" :key="tag" class="tag">{{ tag }}</span>
                </div>
            </div>
        </div>

        <!-- Modal chi tiết sản phẩm -->
        <div v-if="selectedClothes" class="details-modal" @click.self="closeDetails">
            <div class="details-content">
                <span class="close-button" @click="closeDetails">&times;</span>
                <div class="details-header">
                    <img :src="selectedClothes.store.logo" alt="Logo Store" class="details-store-logo" />
                    <p class="details-store-name">{{ selectedClothes.store.nameStore }}</p>
                </div>
                <h3 class="details-product-name">{{ selectedClothes.nameItem }}</h3>
                <p><strong>Mô tả:</strong> {{ selectedClothes.description }}</p>
                <p><strong>Giá:</strong> {{ formatPrice(selectedClothes.price) }} VND</p>
                <p><strong>Màu:</strong> {{ selectedClothes.color }}</p>
                <p><strong>Kiểu dáng:</strong> {{ selectedClothes.style }}</p>
                <p><strong>Size có sẵn:</strong> {{ availableSizes(selectedClothes) }}</p>
                <div v-for="(picture, index) in selectedClothes.listPicture" :key="index">
                    <img :src="picture" alt="Clothes Image" class="modal-image" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axiosClient from '../../api/axiosClient';

export default {
    name: 'ClothesManager',
    data() {
        return {
            clothesList: [],
            selectedClothes: null,
        };
    },
    mounted() {
        this.fetchClothes();
    },
    methods: {
        async fetchClothes() {
            try {
                const response = await axiosClient.get('/clothes');
                if (response.data.success) {
                    this.clothesList = response.data.data;
                } else {
                    console.error('Không thể tải quần áo:', response.data.message);
                }
            } catch (error) {
                console.error('Lỗi khi tải quần áo:', error);
            }
        },
        viewDetails(clothes) {
            this.selectedClothes = clothes;
        },
        closeDetails() {
            this.selectedClothes = null;
        },
        formatPrice(price) {
            return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
        },
        clothesTags(clothes) {
            return [clothes.color, clothes.style];
        },
        availableSizes(clothes) {
            return clothes.itemSizes.map(size => `${size.size} (${size.quantity})`).join(', ');
        }
    }
};
</script>

<style scoped>
.clothes {
    padding: 20px;
}

.clothes-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
}

.clothes-card {
    width: 200px;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    text-align: center;
    cursor: pointer;
    transition: transform 0.2s;
    background-color: #ffffff;
}

.clothes-card:hover {
    transform: scale(1.05);
}

.store-info {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
}

.store-logo {
    width: 30px;
    height: 30px;
    border-radius: 50%;
}

.store-name {
    font-weight: bold;
    font-size: 14px;
    color: #555;
}

.clothes-image-container {
    width: 100%;
    height: 150px;
    overflow: hidden;
    margin-bottom: 10px;
    border-radius: 5px;
}

.clothes-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.tags {
    margin-top: 10px;
}

.tag {
    display: inline-block;
    background-color: #eee;
    color: #555;
    padding: 3px 8px;
    border-radius: 12px;
    font-size: 12px;
    margin-right: 5px;
}

/* Modal chi tiết sản phẩm */
.details-modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.6);
    display: flex;
    align-items: center;
    justify-content: center;
}

.details-content {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    width: 400px;
    max-height: 90vh;
    overflow-y: auto;
    position: relative;
    text-align: left;
}

.close-button {
    position: absolute;
    top: 10px;
    right: 10px;
    font-size: 24px;
    cursor: pointer;
}

.details-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 15px;
}

.details-store-logo {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.details-store-name {
    font-size: 16px;
    font-weight: bold;
    color: #555;
}

.details-product-name {
    font-size: 18px;
    font-weight: bold;
    color: #977364;
    margin-bottom: 10px;
}

.modal-image {
    width: 100%;
    margin-top: 10px;
    border-radius: 5px;
}
</style>
