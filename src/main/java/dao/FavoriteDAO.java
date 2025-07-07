package dao;

import connect.DBContext;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteDAO {

    private final DBContext context = new DBContext();

    // Thêm vào wishlist
    public boolean addFavorite(int userId, int productId) {
        String sql = "INSERT INTO Favorites (User_ID, Product_ID) VALUES (?, ?)";
        try ( Connection conn = context.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa khỏi wishlist
    public boolean removeFavorite(int userId, int productId) {
        String sql = "DELETE FROM Favorites WHERE User_ID = ? AND Product_ID = ?";
        try ( Connection conn = context.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Kiểm tra sản phẩm đã yêu thích chưa
    public boolean isFavorite(int userId, int productId) {
        String sql = "SELECT 1 FROM Favorites WHERE User_ID = ? AND Product_ID = ?";
        try ( Connection conn = context.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách yêu thích
    public List<Product> getFavoriteProducts(int userId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, t.Trademark_Name FROM Products p "
                + "JOIN Favorites f ON p.Product_ID = f.Product_ID "
                + "JOIN Trademark t ON p.Trademark_ID = t.Trademark_ID " // Thêm JOIN với Trademark
                + "WHERE f.User_ID = ?";
        DBContext context = new DBContext();
        try ( Connection conn = context.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                            rs.getInt("Product_ID"),
                            rs.getString("Trademark_Name"), // Lấy từ Trademark thay vì Brand
                            rs.getString("Product_Name"),
                            rs.getDouble("Price"),
                            rs.getInt("Quantity"),
                            rs.getString("Size"),
                            rs.getString("Description"),
                            rs.getString("Image"),
                            rs.getDouble("Rate"),
                            rs.getString("Type")
                    );
                    // Cập nhật các thuộc tính khác nếu cần
                    p.setOriginalPrice(rs.getDouble("Original_Price"));
                    p.setDiscountPercent(rs.getDouble("Discount_Percent"));
                    p.setDiscountStartDate(rs.getDate("Discount_Start_Date"));
                    p.setDiscountEndDate(rs.getDate("Discount_End_Date"));
                    products.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
