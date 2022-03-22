const swiper = new Swiper(".swiper", {
    
    autoplay: {
        delay: 2000,
    },
    
    pagination: {
    el: ".swiper-pagination"
    },
    loop: true,
    effect: "coverflow",
    grabCursor: true,
    centeredSlides: true,
    slidesPerView: "2",
    speed: 1000,

    coverflowEffect: {
    rotate: 50,
    stretch: 0,
    depth: 100,
    modifier: 1,
    slideShadows: true
    },


    // ナビボタンが必要なら追加
    navigation: {
    nextEl: ".swiper-button-next",
    prevEl: ".swiper-button-prev"
    }
});