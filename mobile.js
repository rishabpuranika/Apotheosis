// mobile.js
document.addEventListener('DOMContentLoaded', () => {
    // Find the container and the button
    const container = document.querySelector('.fab-container');
    const toggleBtn = document.querySelector('.fab-toggle');

    if (container && toggleBtn) {
        toggleBtn.addEventListener('click', (e) => {
            // Stop the click from bubbling up (optional)
            e.stopPropagation();
            // Toggle the 'expanded' class on the container
            container.classList.toggle('expanded');
            
            // Toggle the Icon between Hamburger (☰) and Close (+)
            if (container.classList.contains('expanded')) {
                toggleBtn.innerHTML = "+"; // Using + as a close X (rotated via CSS)
            } else {
                toggleBtn.innerHTML = "☰";
            }
        });

        // Close menu if clicking anywhere else on the page
        document.addEventListener('click', (e) => {
            if (!container.contains(e.target)) {
                container.classList.remove('expanded');
                toggleBtn.innerHTML = "☰";
            }
        });
    }
});