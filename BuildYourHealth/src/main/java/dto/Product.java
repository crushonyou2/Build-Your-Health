package dto;

import java.io.Serializable;

public class Product implements Serializable {

    private static final long serialVersionUID = -4274700572038677000L;

    private String productId;           // 상품 ID
    private String productName;         // 상품 이름
    private int regularPrice;           // 정가
    private int discountPrice;          // 할인 가격
    private String manufacturer;        // 제조사
    private String shippingInfo;        // 배송 정보 (예: 무료배송)
    private String imageFile;           // 상품 이미지 파일 이름
    private String productOptions;      // 옵션 정보 (JSON 형식)
    private String expectedDeliveryDate; // 예상 도착 날짜
    private int quantity;               // 장바구니에 담은 개수

    public Product() {
        super();
    }

    public Product(String productId, String productName, int regularPrice, int discountPrice) {
        this.productId = productId;
        this.productName = productName;
        this.regularPrice = regularPrice;
        this.discountPrice = discountPrice;
    }

    // Getters and Setters
    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getRegularPrice() {
        return regularPrice;
    }

    public void setRegularPrice(int regularPrice) {
        this.regularPrice = regularPrice;
    }

    public int getDiscountPrice() {
        return discountPrice;
    }

    public void setDiscountPrice(int discountPrice) {
        this.discountPrice = discountPrice;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getShippingInfo() {
        return shippingInfo;
    }

    public void setShippingInfo(String shippingInfo) {
        this.shippingInfo = shippingInfo;
    }

    public String getImageFile() {
        return imageFile;
    }

    public void setImageFile(String imageFile) {
        this.imageFile = imageFile;
    }

    public String getProductOptions() {
        return productOptions;
    }

    public void setProductOptions(String productOptions) {
        this.productOptions = productOptions;
    }

    public String getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(String expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
