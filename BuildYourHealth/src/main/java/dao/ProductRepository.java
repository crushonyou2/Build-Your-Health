package dao;

import dto.Product;
import mvc.database.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductRepository {

    private static ProductRepository instance = new ProductRepository();

    public static ProductRepository getInstance() {
        return instance;
    }

    // 모든 상품 반환
    public ArrayList<Product> getAllProducts() {
        ArrayList<Product> products = new ArrayList<>();
        String query = "SELECT * FROM product";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Product product = new Product(
                    rs.getString("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("regular_price"),
                    rs.getInt("discount_price")
                );
                product.setManufacturer(rs.getString("manufacturer"));
                product.setShippingInfo(rs.getString("shipping_info"));
                product.setImageFile(rs.getString("image_file"));
                product.setProductOptions(rs.getString("product_options"));
                product.setExpectedDeliveryDate(rs.getString("arrival_date"));

                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    // ID로 상품 조회
    public Product getProductById(String productId) {
        Product product = null;
        String sql = "SELECT product_id, product_name, regular_price, discount_price, " +
                     "manufacturer, shipping_info, image_file, product_options, arrival_date " +
                     "FROM product WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    product = new Product();
                    product.setProductId(rs.getString("product_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setRegularPrice(rs.getInt("regular_price"));
                    product.setDiscountPrice(rs.getInt("discount_price"));
                    product.setManufacturer(rs.getString("manufacturer"));
                    product.setShippingInfo(rs.getString("shipping_info"));
                    product.setImageFile(rs.getString("image_file"));
                    product.setProductOptions(rs.getString("product_options"));
                    product.setExpectedDeliveryDate(rs.getDate("arrival_date").toString()); // String으로 변환
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }



    // 상품 추가
    public void addProduct(Product product) {
        String query = "INSERT INTO product (product_id, product_name, regular_price, discount_price, manufacturer, shipping_info, image_file, product_options, arrival_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, product.getProductId());
            pstmt.setString(2, product.getProductName());
            pstmt.setInt(3, product.getRegularPrice());
            pstmt.setInt(4, product.getDiscountPrice());
            pstmt.setString(5, product.getManufacturer());
            pstmt.setString(6, product.getShippingInfo());
            pstmt.setString(7, product.getImageFile());
            pstmt.setString(8, product.getProductOptions());
            pstmt.setString(9, product.getExpectedDeliveryDate());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 리뷰 조회
    public List<Map<String, String>> getReviewsByProductId(String productId) {
        List<Map<String, String>> reviews = new ArrayList<>();
        String sql = "SELECT review_id, user_id, review, created_at FROM reviews WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> review = new HashMap<>();
                    review.put("reviewId", String.valueOf(rs.getInt("review_id")));
                    review.put("userId", rs.getString("user_id"));
                    review.put("review", rs.getString("review"));
                    review.put("createdAt", rs.getString("created_at"));
                    reviews.add(review);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reviews;
    }


}
