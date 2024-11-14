<template>
    <div class="stores">
        <h2>Quản lý cửa hàng</h2>
        <div class="content-background">
            <div class="tabs">
                <button :class="{ active: activeTab === 'active' }" @click="activeTab = 'active'">Hoạt động</button>
                <button :class="{ active: activeTab === 'pending' }" @click="activeTab = 'pending'">Chờ duyệt</button>
            </div>

            <div v-if="filteredStores.length === 0" class="no-store-message">
                Không có cửa hàng nào ở trạng thái này.
            </div>

            <!-- Bảng hiển thị danh sách cửa hàng -->
            <table v-else class="store-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên cửa hàng</th>
                        <th>Địa chỉ</th>
                        <th>Mã số thuế</th>
                        <th>Giấy phép</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(store, index) in filteredStores" :key="store.idStore">
                        <td>{{ index + 1 }}</td>
                        <td>{{ store.nameStore }}</td>
                        <td>{{ store.address }}</td>
                        <td>{{ store.taxCode }}</td>
                        <td>{{ store.license }}</td>
                        <td>{{ store.status === 'active' ? 'Hoạt động' : 'Chờ duyệt' }}</td>
                        <td>
                            <button class="view-detail-button" @click="viewStoreDetail(store.idStore)">
                                Xem chi tiết
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>

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
            activeTab: 'active',
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
                const response = await axiosClient.get('/stores/');
                if (response.data.success) {
                    this.stores = response.data.stores;
                } else {
                    console.error('Không thể tải cửa hàng:', response.data.message);
                }
            } catch (error) {
                console.error('Lỗi khi tải cửa hàng:', error);
            }
        },
        viewStoreDetail(idStore) {
            this.$router.push({ name: "StoreDetails", params: { id: idStore } });
        },

    },
};
</script>

<style scoped>
.stores {
    padding: 5px;
}


.content-background {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 20px;
    border-radius: 8px;
}

.store-table {
    width: 100%;
    border-collapse: collapse;
    background-color: rgba(255, 255, 255, 0.9);
    margin-top: 15px;
}

.tabs {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
    justify-content: center;
}

.tabs button {
    background: none;
    border: none;
    padding: 8px 0;
    font-size: 18px;
    cursor: pointer;
    color: #555;
    transition: color 0.3s, border-bottom 0.3s;
}

.tabs button.active {
    color: #977364;
    border-bottom: 2px solid #977364;
}

.store-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th,
td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: center;
}

th {
    background-color: rgba(200, 200, 200, 0.8);
    font-weight: bold;
}

.view-detail-button {
    background: none;
    color: #007bff;
    padding: 0;
    border: none;
    cursor: pointer;
    font-style: italic;
    font-weight: normal;
    text-decoration: underline;
}

.view-detail-button:hover {
    color: #0056b3;
    text-decoration: none;
}

</style>
