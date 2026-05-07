// package com.findjob_tt.findjob_tt.model.dto;
// import java.sql.Connection;
// import java.sql.PreparedStatement;
// import java.sql.ResultSet;

// import com.findjob_tt.findjob_tt.model.User;

// public class UserDAO {

//     // Kịch bản A.1: Tìm user bằng google_id
//     public User findByGoogleId(String googleId) {
//         String sql = "SELECT * FROM Users WHERE google_id = ?";
//         try (Connection conn = DBUtils.getConnection();
//              PreparedStatement ps = conn.prepareStatement(sql)) {
//             ps.setString(1, googleId);
//             try (ResultSet rs = ps.executeQuery()) {
//                 if (rs.next()) {
//                     return extractUserFromResultSet(rs);
//                 }
//             }
//         } catch (Exception e) { e.printStackTrace(); }
//         return null;
//     }

//     // Kịch bản A.2 & B: Tìm user bằng email
//     public User findByEmail(String email) {
//         String sql = "SELECT * FROM Users WHERE email = ?";
//         try (Connection conn = DBUtils.getConnection();
//              PreparedStatement ps = conn.prepareStatement(sql)) {
//             ps.setString(1, email);
//             try (ResultSet rs = ps.executeQuery()) {
//                 if (rs.next()) {
//                     return extractUserFromResultSet(rs);
//                 }
//             }
//         } catch (Exception e) { e.printStackTrace(); }
//         return null;
//     }

//     // Kịch bản A.3: Tạo mới tài khoản đăng nhập qua Google
//     public void insertGoogleUser(String email, String googleId) {
//         // Mặc định: auth_type = 'GOOGLE', role_id = 2 (Sinh viên), status = 1 (Active)
//         String sql = "INSERT INTO Users (email, password, google_id, auth_type, role_id, status) " +
//                      "VALUES (?, NULL, ?, 'GOOGLE', 2, 1)";
//         try (Connection conn = DBUtils.getConnection();
//              PreparedStatement ps = conn.prepareStatement(sql)) {
//             ps.setString(1, email);
//             ps.setString(2, googleId);
//             ps.executeUpdate();
//         } catch (Exception e) { e.printStackTrace(); }
//     }

//     // Hàm phụ trợ map dữ liệu từ DB ra Object User
//     private User extractUserFromResultSet(ResultSet rs) throws Exception {
//         User user = new User();
//         user.setId(rs.getInt("id"));
//         user.setEmail(rs.getString("email"));
//         user.setPassword(rs.getString("password"));
//         user.setGoogleId(rs.getString("google_id"));
//         user.setAuthType(rs.getString("auth_type"));
//         user.setRoleId(rs.getInt("role_id"));
//         user.setStatus(rs.getInt("status"));
//         return user;
//     }
// }
