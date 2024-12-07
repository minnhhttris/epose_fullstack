<template>
    <div class="bills">
        <h2>Quản lý đơn thuê</h2>

        <!-- Search Section -->
        <div class="search-filter">
            <div class="search-box-wrapper">
                <input v-model="searchQuery" class="search-box" placeholder="Tìm kiếm đơn thuê..."
                    @input="searchBills" />
                <i class="bi bi-search search-icon"></i>
            </div>

            <!-- Store Filter -->
            <select v-model="storeFilter" class="filter-select" @change="filterBills">
                <option value="">Tất cả cửa hàng</option>
                <option v-for="store in stores" :key="store.idStore" :value="store.idStore">
                    {{ store.nameStore }}
                </option>
            </select>

            <!-- Status Filter -->
            <select v-model="statusFilter" class="filter-select" @change="filterBills">
                <option value="">Tất cả trạng thái</option>
                <option v-for="status in statusOptions" :key="status.value" :value="status.value">
                    {{ status.label }}
                </option>
            </select>
        </div>

        <!-- Bills List Section -->
        <table>
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên người dùng</th>
                    <th>Tên cửa hàng</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th>Ngày thuê</th>
                    <th>Ngày trả</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(bill, index) in filteredBills" :key="bill.idBill">
                    <td class="center">{{ index + 1 }}</td>
                    <td>{{ bill.user.userName }}</td>
                    <td>{{ bill.store.nameStore }}</td>
                    <td>{{ formatCurrency(bill.sum) }}</td>

                    <!-- Status Update Dropdown -->
                    <td class="center">
                        <select v-model="bill.statement" @change="updateBillStatus(bill.idBill, bill.statement)">
                            <option v-for="status in statusOptions" :key="status.value" :value="status.value">
                                {{ status.label }}
                            </option>
                        </select>
                    </td>

                    <td class="center">{{ new Date(bill.dateStart).toLocaleDateString() }}</td>
                    <td class="center">{{ new Date(bill.dateEnd).toLocaleDateString() }}</td>
                    <td class="center">
                        <span @click="viewBillDetail(bill.idBill)" class="view-details">Xem chi tiết</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
import axiosClient from "../../api/axiosClient";

export default {
    name: "BillsManager",
    data() {
        return {
            bills: [],
            stores: [],
            searchQuery: "",
            statusFilter: "",
            storeFilter: "",
            filteredBills: [],
            statusOptions: [
                { value: "UNPAID", label: "Chưa thanh toán" },
                { value: "PAID", label: "Đã thanh toán" },
                { value: "CONFIRMED", label: "Xác nhận" },
                { value: "PENDING_PICKUP", label: "Chờ lấy hàng" },
                { value: "DELIVERING", label: "Đang giao" },
                { value: "DELIVERED", label: "Đã giao" },
                { value: "RECEIVED", label: "Đã nhận" },
                { value: "CANCELLED", label: "Đã hủy" },
                { value: "RETURNED", label: "Trả hàng" },
                { value: "COMPLETED", label: "Đã hoàn thành" },
                { value: "RATING", label: "Đã đánh giá" },
            ],
        };
    },
    methods: {
        async fetchBills() {
            try {
                const response = await axiosClient.get("/bill/");
                this.bills = response.data.data;
                this.filteredBills = this.bills;
            } catch (error) {
                console.error("Error fetching bills:", error);
            }
        },
        async fetchStores() {
            try {
                const response = await axiosClient.get("/stores/"); 
                this.stores = response.data.data;
            } catch (error) {
                console.error("Error fetching stores:", error);
            }
        },
        formatCurrency(value) {
            return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(value);
        },
        searchBills() {
            const query = this.searchQuery.toLowerCase();
            this.filteredBills = this.bills.filter(
                (bill) =>
                    bill.user.userName.toLowerCase().includes(query) ||
                    bill.user.email.toLowerCase().includes(query) ||
                    bill.user.phoneNumbers.includes(query) ||
                    bill.store.nameStore.toLowerCase().includes(query)
            );
        },
        filterBills() {
            this.filteredBills = this.bills.filter(
                (bill) =>
                    (this.statusFilter ? bill.statement === this.statusFilter : true) &&
                    (this.storeFilter ? bill.store.idStore === this.storeFilter : true)
            );
        },
        viewBillDetail(idBill) {
            this.$router.push({ name: "BillDetails", params: { id: idBill } });
        },
        async updateBillStatus(idBill, newStatus) {
            try {
                await axiosClient.put(`/bill/${idBill}`, { statement: newStatus });
                alert("Trạng thái hóa đơn đã được cập nhật.");
            } catch (error) {
                console.error("Error updating bill status:", error);
            }
        },
    },
    created() {
        this.fetchBills();
        this.fetchStores();
    },
};
</script>

<style scoped>
@import './BillManager.scss';
</style>
