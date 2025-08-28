package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartException;

import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;
import com.sp.app.admin.service.ManagerProductService;
import com.sp.app.common.PaginateUtil;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/admin/product/*")
@RequiredArgsConstructor
@Slf4j
public class ManagerProductController {

    private final ManagerProductService service;
    private final PaginateUtil paginateUtil;

    private String uploadBase(HttpServletRequest req) {
        return req.getServletContext().getRealPath("/uploads/product");
    }

    @GetMapping("main")
    public String handleHome() {
        return "admin/product/main";
    }

    @GetMapping("list")
    public String list(
            @RequestParam(value = "page", defaultValue = "1") int current_page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "schType", required = false) String schType,
            @RequestParam(value = "kwd", required = false) String kwd,
            @RequestParam(value = "parentNum", required = false) Long parentNum,
            @RequestParam(value = "categoryNum", required = false) Long categoryNum,
            @RequestParam(value = "productShow", required = false) Integer productShow,
            HttpServletRequest req,
            Model model) {

        try {
            if ("GET".equalsIgnoreCase(req.getMethod())) {
                kwd = kwd != null ? kwd.trim() : kwd;
            }

            Map<String, Object> map = new HashMap<>();
            map.put("schType", schType);
            map.put("kwd", kwd);
            map.put("parentNum", parentNum);
            map.put("categoryNum", categoryNum);
            map.put("productShow", productShow);

            int dataCount = service.dataCount(map);
            int total_page = paginateUtil.pageCount(dataCount, size);
            if (current_page > total_page) current_page = total_page == 0 ? 1 : total_page;

            int offset = (current_page - 1) * size;
            if (offset < 0) offset = 0;
            map.put("offset", offset);
            map.put("size", size);

            List<ManagerProduct> list = service.listProduct(map);

            String cp = req.getContextPath();
            String listUrl = cp + "/admin/product/list";

            String query = "";
            if (StringUtils.hasText(kwd)) query += "&kwd=" + kwd;
            if (StringUtils.hasText(schType)) query += "&schType=" + schType;
            if (parentNum != null) query += "&parentNum=" + parentNum;
            if (categoryNum != null) query += "&categoryNum=" + categoryNum;
            if (productShow != null) query += "&productShow=" + productShow;

            String paging = paginateUtil.paging(current_page, total_page, listUrl + "?" + (query.startsWith("&") ? query.substring(1) : query));

            model.addAttribute("list", list);
            model.addAttribute("page", current_page);
            model.addAttribute("size", size);
            model.addAttribute("dataCount", dataCount);
            model.addAttribute("total_page", total_page);
            model.addAttribute("paging", paging);

            model.addAttribute("parentNum", parentNum);
            model.addAttribute("categoryNum", categoryNum);
            model.addAttribute("productShow", productShow);

            model.addAttribute("schType", schType);
            model.addAttribute("kwd", kwd);

            // 수정된 부분:
            model.addAttribute("categoryList", service.listCategory());
            // 부모 카테고리가 선택되었을 때만 하위 카테고리 목록을 가져옵니다.
            if(parentNum != null) {
                model.addAttribute("listSubCategory", service.listSubCategory(parentNum));
            }

        } catch (Exception e) {
            log.info("list : ", e);
        }

        return "admin/product/list";
    }
    
    @GetMapping("list2")
    public String list2(
            @RequestParam(value = "page", defaultValue = "1") int current_page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "schType", required = false) String schType,
            @RequestParam(value = "kwd", required = false) String kwd,
            @RequestParam(value = "parentNum", required = false) Long parentNum,
            @RequestParam(value = "categoryNum", required = false) Long categoryNum,
            @RequestParam(value = "productShow", required = false) Integer productShow,
            HttpServletRequest req,
            Model model) {

        try {
            if ("GET".equalsIgnoreCase(req.getMethod())) {
                kwd = kwd != null ? kwd.trim() : kwd;
            }

            Map<String, Object> map = new HashMap<>();
            map.put("schType", schType);
            map.put("kwd", kwd);
            map.put("parentNum", parentNum);
            map.put("categoryNum", categoryNum);
            map.put("productShow", productShow);

            int dataCount = service.dataCount(map);
            int total_page = paginateUtil.pageCount(dataCount, size);
            if (current_page > total_page) current_page = total_page == 0 ? 1 : total_page;

            int offset = (current_page - 1) * size;
            if (offset < 0) offset = 0;
            map.put("offset", offset);
            map.put("size", size);

            List<ManagerProduct> list = service.listProduct(map);

            String cp = req.getContextPath();
            String listUrl = cp + "/admin/product/list";

            String query = "";
            if (StringUtils.hasText(kwd)) query += "&kwd=" + kwd;
            if (StringUtils.hasText(schType)) query += "&schType=" + schType;
            if (parentNum != null) query += "&parentNum=" + parentNum;
            if (categoryNum != null) query += "&categoryNum=" + categoryNum;
            if (productShow != null) query += "&productShow=" + productShow;

            String paging = paginateUtil.paging(current_page, total_page, listUrl + "?" + (query.startsWith("&") ? query.substring(1) : query));

            model.addAttribute("list", list);
            model.addAttribute("page", current_page);
            model.addAttribute("size", size);
            model.addAttribute("dataCount", dataCount);
            model.addAttribute("total_page", total_page);
            model.addAttribute("paging", paging);

            model.addAttribute("parentNum", parentNum);
            model.addAttribute("categoryNum", categoryNum);
            model.addAttribute("productShow", productShow);

            model.addAttribute("schType", schType);
            model.addAttribute("kwd", kwd);

            // 수정된 부분:
            model.addAttribute("categoryList", service.listCategory());
            // 부모 카테고리가 선택되었을 때만 하위 카테고리 목록을 가져옵니다.
            if(parentNum != null) {
                model.addAttribute("listSubCategory", service.listSubCategory(parentNum));
            }

        } catch (Exception e) {
            log.info("list : ", e);
        }

        return "admin/product/list2";
    }
    
    
    @GetMapping("category/sub")
    @ResponseBody
    public List<ManagerProduct> subCategories(@RequestParam("parentNum") long parentNum) {
        return service.listSubCategory(parentNum);
    }

    @GetMapping("write")
    public String writeForm(@RequestParam(value = "parentNum", required = false) Long parentNum, Model model) {
        model.addAttribute("mode", "write");
        model.addAttribute("categoryList", service.listCategory());
        if (parentNum != null) {
            model.addAttribute("listSubCategory", service.listSubCategory(parentNum));
            model.addAttribute("parentNum", parentNum);
        }
        return "admin/product/write";
    }

    @PostMapping("write")
    public String writeSubmit(ManagerProduct dto, HttpServletRequest req, Model model) {
    	 System.out.println("★ writeSubmit 도착");
        String uploadPath = uploadBase(req);
        try {
            if (dto.getDelivery() < 0) dto.setDelivery(0);
            service.insertProduct(dto, uploadPath);
            return "redirect:/admin/product/list";
        } catch (MultipartException me) {
            log.info("writeSubmit(multipart) : ", me);
            model.addAttribute("message", "파일 업로드 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.info("writeSubmit : ", e);
            model.addAttribute("message", "상품 등록 중 오류가 발생했습니다.");
        }
        model.addAttribute("mode", "write");
        model.addAttribute("categoryList", service.listCategory());
        return "admin/product/write";
    }

    @GetMapping("detail/{productNum}")
    public String detail(@PathVariable("productNum") long productNum,
                         @RequestParam(name="page", defaultValue="1") int page,
                         @RequestParam(name="size", defaultValue="10") int size,
                         Model model) {
        ManagerProduct dto = service.findById(productNum);
        if (dto == null) return "redirect:/admin/product/list";

        try {
            model.addAttribute("dto", dto);
            model.addAttribute("files", service.listProductFile(productNum));
            model.addAttribute("options", service.listProductOption(productNum));
        } catch (Exception e) {
            log.info("detail : ", e);
        }

        model.addAttribute("page", page);
        model.addAttribute("size", size);
        return "admin/product/detail";
    }

    @GetMapping("update/{productNum}")
    public String updateForm(@PathVariable("productNum") long productNum,
                             @RequestParam(name = "page", defaultValue = "1") int page,
                             @RequestParam(name = "size", defaultValue = "10") int size,
                             Model model) {
        ManagerProduct dto = service.findById(productNum);
        if (dto == null) return "redirect:/admin/product/list";

        // 부모 카테고리 번호 가져오기
        ManagerProduct parentCategory = service.findByCategory(dto.getCategoryNum());
        if (parentCategory != null && parentCategory.getParentNum() != 0) {
            model.addAttribute("listSubCategory", service.listSubCategory(parentCategory.getParentNum()));
            model.addAttribute("parentNum", parentCategory.getParentNum());
        }

        model.addAttribute("mode", "update");
        model.addAttribute("dto", dto);
        model.addAttribute("files", service.listProductFile(productNum));
        model.addAttribute("options", service.listProductOption(productNum));
        model.addAttribute("categoryList", service.listCategory());
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        return "admin/product/write";
    }

    @PostMapping("update")
    public String updateSubmit(ManagerProduct dto,
                               @RequestParam(name = "page", defaultValue = "1") int page,
                               @RequestParam(name = "size", defaultValue = "10") int size,
                               HttpServletRequest req,
                               Model model) {
        String uploadPath = uploadBase(req);
        try {
            service.updateProduct(dto, uploadPath);
            return "redirect:/admin/product/list";
        } catch (Exception e) {
            log.info("updateSubmit : ", e);
        }
        model.addAttribute("mode", "update");
        model.addAttribute("dto", service.findById(dto.getProductNum()));
        model.addAttribute("files", service.listProductFile(dto.getProductNum()));
        model.addAttribute("options", service.listProductOption(dto.getProductNum()));
        model.addAttribute("categoryList", service.listCategory());
        model.addAttribute("message", "상품 수정 중 오류가 발생했습니다.");
        return "admin/product/write";
    }

    @GetMapping("delete/{productNum}")
    public String delete(@PathVariable("productNum") long productNum,
                         @RequestParam(name="page", defaultValue="1") int page,
                         @RequestParam(name="size", defaultValue="10") int size,
                         HttpServletRequest req) {
        String uploadPath = uploadBase(req);
        try {
            service.deleteProduct(productNum, uploadPath);
        } catch (Exception e) {
            log.info("delete : ", e);
        }
        return "redirect:/admin/product/list?page=" + page + "&size=" + size;
    }

    @PostMapping("stock/update")
    @ResponseBody
    public Map<String, Object> updateStock(@RequestBody ManagerProductStock dto) {
        Map<String, Object> map = new HashMap<>();
        try {
            service.updateProductStock(dto);
            map.put("status", "success");
        } catch (Exception e) {
            log.info("updateStock : ", e);
            map.put("status", "error");
        }
        return map;
    }
    
    @GetMapping("listProductStock")
    public String listProductStock(@RequestParam("productNum") long productNum, Model model) {
        List<ManagerProductStock> list = service.listProductStock(productNum);
        model.addAttribute("listStock", list);
        return "admin/product/listStock";
    }

    @PostMapping("file/delete")
    @ResponseBody
    public Map<String, Object> deleteFile(@RequestParam("fileNum") long fileNum,
                                          @RequestParam("pathString") String pathString) {
        Map<String, Object> map = new HashMap<>();
        try {
            service.deleteProductFile(fileNum, pathString);
            map.put("status", "success");
        } catch (Exception e) {
            log.info("fileDelete : ", e);
            map.put("status", "error");
        }
        return map;
    }

    @PostMapping("option/detail/delete")
    @ResponseBody
    public Map<String, Object> deleteOptionDetail(@RequestParam("detailNum") long detailNum) {
        Map<String, Object> map = new HashMap<>();
        try {
            service.deleteOptionDetail(detailNum);
            map.put("status", "success");
        } catch (Exception e) {
            log.info("optionDetailDelete : ", e);
            map.put("status", "error");
        }
        return map;
    }
}