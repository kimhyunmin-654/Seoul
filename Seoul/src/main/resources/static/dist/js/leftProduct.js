document.addEventListener("DOMContentLoaded", function () {
    
    
    
    const isProductListPage = window.location.pathname.includes('/product/list') || window.location.pathname.includes('/auction/list') ||
                             document.getElementById('product-grid') !== null || document.getElementById('auction-grid') !== null;
    
    

    // 아코디언 
    document.querySelectorAll('.sidebar-title').forEach(title => {

        title.addEventListener('click', function() {
            const section = this.closest('.sidebar-section');
            const list = section.querySelector('.sidebar-list');
            
            section.classList.toggle('open');
            list.style.display = section.classList.contains('open') ? 'grid' : 'none';

        });
    });

    
    function updateMainFilterChips() {
        
        
        const activeFiltersContainer = document.getElementById('active-filters');
        const chipsContainer = activeFiltersContainer.querySelector('.active-filters-chips');
        
        if (!activeFiltersContainer || !chipsContainer) {
            
            return;
        }
        
        
        chipsContainer.innerHTML = '';
        
        let hasActiveFilters = false;
        
        
        if (window.currentRegionId) {
            const regionElement = document.querySelector(`.sub-region-link[data-region-id="${window.currentRegionId}"]`);
            if (regionElement) {
                const regionText = regionElement.textContent.trim();
                const chipHtml = `
                    <span class="main-filter-chip" data-filter-type="region" data-filter-id="${window.currentRegionId}">
                        <span class="filter-type">지역:</span> ${regionText}
                        <button class="main-clear-chip-btn" data-filter-type="region">&times;</button>
                    </span>
                `;
                chipsContainer.innerHTML += chipHtml;
                hasActiveFilters = true;
            }
        }
        
        
        if (window.currentCategoryId) {
            const categoryElement = document.querySelector(`.category-link[data-category-id="${window.currentCategoryId}"]`);
            if (categoryElement) {
                const categoryText = categoryElement.textContent.trim();
                const chipHtml = `
                    <span class="main-filter-chip" data-filter-type="category" data-filter-id="${window.currentCategoryId}">
                        <span class="filter-type">카테고리:</span> ${categoryText}
                        <button class="main-clear-chip-btn" data-filter-type="category">&times;</button>
                    </span>
                `;
                chipsContainer.innerHTML += chipHtml;
                hasActiveFilters = true;
            }
        }
        
        
        activeFiltersContainer.style.display = hasActiveFilters ? 'flex' : 'none';
        
        
    }
    
    function updateRegion(selectedRegionId) {
        
        
        const regionEl = $('.sub-region-link');
        
        
        regionEl.removeClass('font-bold text-orange-600 active').addClass('text-gray-700');

        let target;
        if (!selectedRegionId) { 
            target = $('.sub-region-link[data-region-id=""]');
        } else {
            target = $('.sub-region-link[data-region-id="' + selectedRegionId + '"]');
        }

        
        
        if (target.length > 0) {
            target.removeClass('text-gray-700').addClass('font-bold text-orange-600 active');
            
        }
        
        
        if (isProductListPage) {
            updateMainFilterChips();
        }
    }
    
    function updateCategory(selectedCategoryId) {
        
        
        const categoryEl = $('.category-link');
        
        
        categoryEl.removeClass('font-bold text-orange-600 active').addClass('text-gray-700');

        let target;
        if (!selectedCategoryId) { 
            target = $('.category-link[data-category-id=""]');
        } else {
            target = $('.category-link[data-category-id="' + selectedCategoryId + '"]');
        }

        
        
        if (target.length > 0) {
            target.removeClass('text-gray-700').addClass('font-bold text-orange-600 active');
            
        }
        
        
        if (isProductListPage) {
            updateMainFilterChips();
        }
    }
    
    function initializeFilters() {
        
        if (window.currentRegionId) {
            updateRegion(window.currentRegionId);
            
            
            const regionSection = document.querySelector('.sidebar-section');
            const regionList = regionSection.querySelector('.sidebar-list');
            regionSection.classList.add('open');
            regionList.style.display = 'grid';
            
        } else {
            
            const regionSection = document.querySelector('.sidebar-section');
            const regionList = regionSection.querySelector('.sidebar-list');
            regionSection.classList.add('open');
            regionList.style.display = 'grid';
            
        }

        if (window.currentCategoryId) {
            updateCategory(window.currentCategoryId);
            
            
            const categorySection = document.querySelectorAll('.sidebar-section')[1];
            const categoryList = categorySection.querySelector('.sidebar-list');
            categorySection.classList.add('open');
            categoryList.style.display = 'grid';
            
        } else {
            
            const categorySection = document.querySelectorAll('.sidebar-section')[1];
            const categoryList = categorySection.querySelector('.sidebar-list');
            categorySection.classList.add('open');
            categoryList.style.display = 'grid';
            
        }
        
        
        if (isProductListPage) {
            updateMainFilterChips();
        }
    }

    //  상품 페이지에서만 AJAX 필터링 적용 
    if (isProductListPage) {
        
        
        
        $(document).on('click', '.sub-region-link', function(e) {
            
            e.preventDefault();
            
            const regionId = $(this).data('region-id') || '';
            
            
            
           
            window.currentRegionId = regionId;
            
            
            updateRegion(regionId);
            
            
            if (typeof window.applyFilter === 'function') {
                
                window.applyFilter();
            }
        });

        
        $(document).on('click', '.category-link[data-category-id]', function(e) {
            
            e.preventDefault();
            
            const categoryId = $(this).data('category-id') || '';
            
            
            
           
            window.currentCategoryId = categoryId;
            
            
            updateCategory(categoryId);
            
           
            if (typeof window.applyFilter === 'function') {
                
                window.applyFilter();
            }
        });

        
        $(document).on('click', '.main-clear-chip-btn', function(e) {
            
            e.preventDefault();
            e.stopPropagation();
            
            const filterType = $(this).data('filter-type');
            
            
            
            if (filterType === 'region') {
                window.currentRegionId = '';
                updateRegion('');
            } else if (filterType === 'category') {
                window.currentCategoryId = '';
                updateCategory('');
            }
            
            
            if (typeof window.applyFilter === 'function') {
                
                window.applyFilter();
            }
        });

        
        $(document).on('click', '.clear-all-filters', function(e) {
            
            e.preventDefault();
            
            
            window.currentRegionId = '';
            window.currentCategoryId = '';
            
            
            updateRegion('');
            updateCategory('');
            
            
            if (typeof window.applyFilter === 'function') {
                
                window.applyFilter();
            }
        });
    } 
 
    // jQuery가 로드된 후에 실행
    if (typeof $ !== 'undefined') {
        initializeFilters();
    } else {
        // jQuery가 없으면 잠시 후 다시 시도
        setTimeout(function() {
            if (typeof $ !== 'undefined') {
                initializeFilters();
            }
        }, 100);
    }
    
    
});