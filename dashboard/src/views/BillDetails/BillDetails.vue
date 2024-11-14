<template>
    <div class="bill-detail">
        <!-- Thông tin chi tiết và danh sách sản phẩm -->
        <div class="info-card">
            <h2 class="centered-title">Chi tiết đơn thuê</h2>
            <div class="info-content">
                <div class="section">
                    <h4>Thông tin đơn thuê</h4>
                    <p><i class="icon-id"></i><strong>ID hóa đơn: </strong> {{ bill.idBill }}</p>
                    <p><i class="icon-sum"></i><strong>Tổng tiền: </strong> {{ formatCurrency(bill.sum) }}</p>
                    <p><i class="icon-downpayment"></i><strong>Đã thanh toán: </strong> {{
                        formatCurrency(bill.downpayment) }}</p>
                    <p><i class="icon-start-date"></i><strong>Ngày thuê: </strong> {{ formatDate(bill.dateStart) }}</p>
                    <p><i class="icon-end-date"></i><strong>Ngày trả: </strong> {{ formatDate(bill.dateEnd) }}</p>
                    <p><i class="icon-status"></i><strong>Trạng thái: </strong> {{ bill.statement }}</p>
                </div>

                <div class="section">
                    <h4>Thông tin người thuê</h4>
                    <p><i class="icon-user"></i><strong>Tên người thuê: </strong> {{ bill.user.userName }}</p>
                    <p><i class="icon-cccd"></i><strong>CCCD: </strong> {{ bill.user.CCCD }}</p>
                    <p><i class="icon-email"></i><strong>Email: </strong> {{ bill.user.email }}</p>
                    <p><i class="icon-phone"></i><strong>Số điện thoại: </strong> {{ bill.user.phoneNumbers }}</p>
                    <p><i class="icon-address"></i><strong>Địa chỉ: </strong> {{ bill.user.address }}</p>
                </div>

                <div class="section">
                    <h4>Thông tin cửa hàng</h4>
                    <p><i class="icon-store"></i><strong>Tên cửa hàng: </strong> {{ bill.store.nameStore }}</p>
                    <p><i class="icon-store-address"></i><strong>Địa chỉ: </strong> {{ bill.store.address }}</p>
                    <p><i class="icon-tax"></i><strong>Mã số thuế: </strong> {{ bill.store.taxCode }}</p>
                    <p><i class="icon-license"></i><strong>Giấy phép kinh doanh: </strong> {{ bill.store.license }}</p>
                </div>
            </div>

            <!-- Danh sách sản phẩm đã thuê -->
            <div class="section">
                <h4>Danh sách sản phẩm đã thuê</h4>
                <div class="products-grid">
                    <div class="product-card" v-for="item in bill.billItems" :key="item.idItem">
                        <img :src="item.clothes.listPicture[0]" alt="product image" class="product-image" />
                        <div class="product-info">
                            <p class="product-name">{{ item.clothes.nameItem }}</p>
                            <p><strong>Kích cỡ: </strong> {{ item.size }}</p>
                            <p><strong>Số lượng: </strong> {{ item.quantity }}</p>
                            <p><strong>Giá thuê: </strong> {{ formatCurrency(item.clothes.price) }}</p>
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
    name: "BillDetails",
    data() {
        return {
            bill: null,
        };
    },
    methods: {
        formatCurrency(value) {
            return new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(value);
        },
        formatDate(date) {
            return new Date(date).toLocaleDateString("vi-VN");
        },
    },
    async created() {
        const idBill = this.$route.params.id;
        try {
            const response = await axiosClient.get(`/bill/${idBill}`);
            this.bill = response.data.data;
        } catch (error) {
            console.error("Error fetching bill detail:", error);
        }
    },
};
</script>

<style scoped>
.bill-detail {
    padding: 20px;
    margin-left: 30px;
    margin-right: 30px;
}

.centered-title {
    text-align: center;
    color: black;
}

.info-card {
    background-color: rgba(255, 255, 255, 0.8);
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.15);
    margin-bottom: 30px;
    width: 100%;
}

.info-content {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.section h4 {
    color: #977364;
    font-size: 1.3rem;
    margin-top: 10px;
    margin-bottom: 10px;
    border-bottom: 1px solid #ccc;
    padding-bottom: 5px;
}

.section p {
    display: flex;
    align-items: center;
    margin: 8px 0;
}

.products-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 20px;
    margin-top: 20px;
}

@media (min-width: 768px) {
    .products-grid {
        grid-template-columns: repeat(4, 1fr);
    }
}

.product-card {
    background-color: #FFF;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0px 6px 18px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s;
    display: flex;
    /* flex-direction: column; */
    align-items: center;
    /* text-align: center; */
}

.product-card:hover {
    transform: translateY(-5px);
}

.product-image {
    width: 140px;
    height: 140px;
    object-fit: cover;
    border-radius: 8px;
    margin-right: 15px;
}

.product-info {
    display: flex;
    flex-direction: column;
}

.product-info p {
    margin:0;
}

.product-name {
    font-weight: bold;
    color: black;
    font-size: 1.1rem;
    margin-bottom: 10px;
}
</style>
