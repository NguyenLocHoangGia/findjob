package com.findjob_tt.findjob_tt.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ErrorPageController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, HttpServletResponse response, Model model) {
        Object statusObj = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        int statusCode = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;

        if (statusObj != null) {
            try {
                statusCode = Integer.parseInt(statusObj.toString());
            } catch (NumberFormatException ignored) {
                statusCode = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
            }
        }

        response.setStatus(statusCode);

        model.addAttribute("statusCode", statusCode);
        model.addAttribute("errorTitle", resolveTitle(statusCode));
        model.addAttribute("errorMessage", resolveMessage(statusCode));

        return "deny";
    }

    private String resolveTitle(int statusCode) {
        return switch (statusCode) {
            case 404 -> "Không tìm thấy trang";
            case 403 -> "Không có quyền truy cập";
            case 400 -> "Yêu cầu không hợp lệ";
            case 500 -> "Lỗi hệ thống";
            default -> "Đã xảy ra lỗi";
        };
    }

    private String resolveMessage(int statusCode) {
        return switch (statusCode) {
            case 404 -> "Trang bạn đang truy cập không tồn tại hoặc đã được di chuyển.";
            case 403 -> "Bạn không có quyền thực hiện thao tác này.";
            case 400 -> "Yêu cầu gửi lên chưa đúng định dạng hoặc thiếu dữ liệu.";
            case 500 -> "Hệ thống đang gặp sự cố tạm thời. Vui lòng thử lại sau.";
            default -> "Đã có lỗi xảy ra trong quá trình xử lý yêu cầu.";
        };
    }
}
