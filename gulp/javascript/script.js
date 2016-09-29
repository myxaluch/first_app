    var mainTitle = document.querySelector(".main__title");

    all_images = new Array (
      url("../img/bg-1.jpg"),
      url("../img/bg-2.jpg"),
      url("../img/bg-3.jpg"),
      url("../img/bg-4.jpg"),
      url("../img/bg-5.jpg"),
      url("../img/bg-6.jpg"),
      url("../img/bg-7.jpg"),
      url("../img/bg-8.jpg"));

    var ImgNum = 0;
    var ImgLength = all_images.length - 1;
    var delay = 2500;
    var lock = false;
    var run;

    function chgImg(direction) {
      ImgNum = ImgNum + direction;
      if (ImgNum > ImgLength) { ImgNum = 0; }
      if (ImgNum < 0) { ImgNum = ImgLength; }
      main__title.style.backgroundImage = all_images[ImgNum];
    }

   function auto() {
     if (lock == true) {
       lock = false;
       window.clearInterval(run);
     }
     else if (lock == false) {
       lock = true;
       run = setInterval("chgImg(1)", delay);
     }
    }
