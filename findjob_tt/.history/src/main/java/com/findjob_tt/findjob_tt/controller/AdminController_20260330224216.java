package com.findjob_tt.findjob_tt.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.findjob_tt.findjob_tt.model.Category;
import com.findjob_tt.findjob_tt.model.CompanyProfile;
import com.findjob_tt.findjob_tt.model.Job;
import com.findjob_tt.findjob_tt.model.Role;
import com.findjob_tt.findjob_tt.model.User;
import com.findjob_tt.findjob_tt.repository.ApplicationRepository;
import com.findjob_tt.findjob_tt.repository.CategoryRepository;
import com.findjob_tt.findjob_tt.repository.CompanyProfileRepository;
import com.findjob_tt.findjob_tt.repository.JobRepository;
import com.findjob_tt.findjob_tt.repository.RoleRepository;
import com.findjob_tt.findjob_tt.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

@Controller
@RequestMapping("/admin") // Đã có tiền tố /admin ở đây
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private CompanyProfileRepository companyProfileRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private org.springframework.security.core.session.SessionRegistry sessionRegistry;

    @GetMapping("/dashboard")
    public String showAdminDashboard(Model model) {
        long totalUsers = userRepository.count();
        long totalJobs = jobRepository.count();
        long totalApplications = applicationRepository.count();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalJobs", totalJobs);
        model.addAttribute("totalApplications", totalApplications);

        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String manageUsers(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 5; // Số lượng hiển thị trên 1 trang
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<User> userPage = userRepository.findAll(pageable);

        model.addAttribute("users", userPage.getContent()); // Chỉ lấy danh sách của trang hiện tại
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        return "admin/manage-users";
    }

    @GetMapping("/users/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") Long id, Principal principal,
            RedirectAttributes redirectAttributes) {

        User currentAdmin = userRepository.findByEmail(principal.getName());
        User targetUser = userRepository.findById(id).orElse(null);

        if (targetUser != null) {
            if (targetUser.getId().equals(currentAdmin.getId())) {
                redirectAttributes.addFlashAttribute("errorMsg", "Bạn không thể tự khóa tài khoản của chính mình!");
                return "redirect:/admin/users";
            }

            targetUser.setActive(!targetUser.isActive());
            userRepository.save(targetUser);

            if (!targetUser.isActive()) {
                List<Object> loggedInUsers = sessionRegistry.getAllPrincipals();
                for (Object loggedUser : loggedInUsers) {
                    if (loggedUser instanceof org.springframework.security.core.userdetails.User) {
                        org.springframework.security.core.userdetails.User springUser = (org.springframework.security.core.userdetails.User) loggedUser;
                        if (springUser.getUsername().equals(targetUser.getEmail())) {
                            List<SessionInformation> sessions = sessionRegistry.getAllSessions(loggedUser, false);
                            for (SessionInformation session : sessions) {
                                session.expireNow();
                            }
                        }
                    }
                }
            }

            String action = targetUser.isActive() ? "Mở khóa" : "Khóa";
            redirectAttributes.addFlashAttribute("successMsg", "Đã " + action + " tài khoản: " + targetUser.getEmail());
        }

        return "redirect:/admin/users";
    }

    // --- CÁC HÀM QUẢN LÝ DOANH NGHIỆP ---

    @GetMapping("/companies")
    public String manageCompanies(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 5;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<CompanyProfile> companyPage = companyProfileRepository.findAll(pageable);

        model.addAttribute("companies", companyPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", companyPage.getTotalPages());
        return "admin/manage-companies";
    }

    @PostMapping("/companies/{id}/approve") // Bỏ chữ /admin ở đây đi
    public String approveCompany(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        CompanyProfile company = companyProfileRepository.findById(id).orElse(null);
        if (company != null) {
            company.setStatus("APPROVED");

            User user = company.getUser();
            Role recruiterRole = roleRepository.findByName("ROLE_RECRUITER");
            if (recruiterRole != null && !user.getRoles().contains(recruiterRole)) {
                user.getRoles().add(recruiterRole);
            }

            userRepository.save(user);
            redirectAttributes.addFlashAttribute("successMsg", "Đã phê duyệt công ty: " + company.getCompanyName());
        }
        return "redirect:/admin/companies"; // Chú ý: Ở lệnh redirect thì VẪN PHẢI GIỮ chữ /admin nhé
    }

    @PostMapping("/companies/{id}/reject")
    public String rejectCompany(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        CompanyProfile company = companyProfileRepository.findById(id).orElse(null);
        if (company != null) {
            // 1. Đổi trạng thái thành REJECTED
            company.setStatus("REJECTED");

            // 2. BỔ SUNG LỆNH TƯỚC QUYỀN (REVOKE ROLE)
            User user = company.getUser();
            Role recruiterRole = roleRepository.findByName("ROLE_RECRUITER");

            // Nếu user đang có quyền Recruiter thì gỡ quyền đó ra
            if (recruiterRole != null && user.getRoles().contains(recruiterRole)) {
                user.getRoles().remove(recruiterRole);
                userRepository.save(user); // Lưu lại thay đổi vào DB
            }

            companyProfileRepository.save(company);
            redirectAttributes.addFlashAttribute("errorMsg", "Đã từ chối công ty: " + company.getCompanyName());
        }
        return "redirect:/admin/companies";
    }

    @GetMapping("/categories")
    public String manageCategories(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 5;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Category> categoryPage = categoryRepository.findAll(pageable);

        model.addAttribute("categories", categoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", categoryPage.getTotalPages());
        return "admin/manage-categories";
    }

    @PostMapping("/categories/add")
    public String addCategory(@RequestParam("name") String name,
            RedirectAttributes redirectAttributes) {
        try {
            Category category = new Category();
            category.setName(name); // Chỉ lưu mỗi tên
            categoryRepository.save(category);
            redirectAttributes.addFlashAttribute("successMsg", "Thêm danh mục thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", "Lỗi: Danh mục này có thể đã tồn tại!");
        }
        return "redirect:/admin/categories";
    }

    @PostMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            categoryRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("successMsg", "Đã xóa danh mục!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg",
                    "Không thể xóa danh mục này vì đang có tin tuyển dụng sử dụng nó!");
        }
        return "redirect:/admin/categories";
    }

    @GetMapping("/jobs")
    public String manageJobs(Model model, @RequestParam(defaultValue = "0") int page) {
        int pageSize = 10; // Hiển thị 10 tin trên 1 trang

        // Nhớ import org.springframework.data.domain.Sort nếu file chưa có nhé
        Pageable pageable = PageRequest.of(page, pageSize,
                org.springframework.data.domain.Sort.by("createdAt").descending());
        Page<Job> jobPage = jobRepository.findAll(pageable);

        model.addAttribute("jobs", jobPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", jobPage.getTotalPages());

        return "admin/manage-jobs";
    }

    // 1. DUYỆT TIN
    @PostMapping("/jobs/approve")
    public String approveJob(@RequestParam("jobId") Long jobId) {
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job != null) {
            job.setStatus("APPROVED");
            job.setIsActive(true); // Bật hiển thị cho Candidate thấy
            jobRepository.save(job);
        }
        return "redirect:/admin/jobs";
    }

    // 2. TỪ CHỐI / ĐÓNG TIN
    @PostMapping("/jobs/reject")
    public String rejectJob(@RequestParam("jobId") Long jobId) {
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job != null) {
            job.setStatus("REJECTED");
            job.setIsActive(false); // Ẩn khỏi trang của Candidate
            jobRepository.save(job);
        }
        return "redirect:/admin/jobs";
    }

}