<template>
    <div class="clothes">
        <h2>Quản lý quần áo</h2>

        <!-- Bảng quản lý chung -->
        <table class="clothes-table">
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên quần áo</th>
                    <th>Giá</th>
                    <th>Màu</th>
                    <th>Kiểu dáng</th>
                    <th>Giới tính</th>
                    <th>Số lượng</th>
                    <th>Cửa hàng</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(clothes, index) in clothesList" :key="clothes.idItem">
                    <td>{{ index + 1 }}</td> <!-- STT -->
                    <td>{{ clothes.nameItem }}</td>
                    <td>{{ formatPrice(clothes.price) }} VND</td>
                    <td>{{ translateColor(clothes.color) }}</td>
                    <td>{{ translateStyle(clothes.style) }}</td>
                    <td>{{ translateGender(clothes.gender) }}</td>
                    <td>{{ clothes.number }}</td>
                    <td>{{ clothes.store.nameStore }}</td>
                </tr>
            </tbody>
        </table>

        <!-- Danh sách thẻ quần áo -->
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
                <p><strong>Màu:</strong> {{ translateColor(selectedClothes.color) }}</p>
                <p><strong>Kiểu dáng:</strong> {{ translateStyle(selectedClothes.style) }}</p>
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
            return [this.translateColor(clothes.color), this.translateStyle(clothes.style)];
        },
        availableSizes(clothes) {
            return clothes.itemSizes.map(size => `${size.size} (${size.quantity})`).join(', ');
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
        translateColor(color) {
            const colorMap = {
                red: 'Đỏ',
                blue: 'Xanh dương',
                green: 'Xanh lá',
                yellow: 'Vàng',
                black: 'Đen',
                white: 'Trắng',
                pink: 'Hồng',
                purple: 'Tím',
                orange: 'Cam',
                brown: 'Nâu',
                gray: 'Xám',
                beige: 'Be',
                colorfull: 'Nhiều màu',
            };
            return colorMap[color] || 'Không xác định';
        },
        translateStyle(style) {
            const styleMap = {
                ao_dai: 'Áo dài',
                tu_than: 'Áo tứ thân',
                co_phuc: 'Cổ phục',
                ao_ba_ba: 'Áo bà ba',
                da_hoi: 'Dạ hội',
                nang_tho: 'Nàng thơ',
                hoc_duong: 'Học đường',
                vintage: 'Vintage',
                ca_tinh: 'Cá tính',
                sexy: 'Sexy',
                cong_so: 'Công sở',
                dan_toc: 'Dân tộc',
                do_doi: 'Đồ đôi',
                hoa_trang: 'Hóa trang',
                cac_nuoc: 'Các nước',
            };
            return styleMap[style] || 'Không xác định';
        },
    }
};
</script>

<style scoped>
@import './ClothesManager.scss';
</style>
