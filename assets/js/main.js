const toggleSidebar = () => {
    let sidebar = document.querySelector(".sidebar-overlay");
    sidebar.classList.toggle("-translate-x-full");
}

const toggleMobileMenu = () => {
    document.querySelector('#mobile-menu').classList.toggle('hidden');
}

const scrollToTop = () => {
    document.querySelector("main").scrollTo(0,0);
}
