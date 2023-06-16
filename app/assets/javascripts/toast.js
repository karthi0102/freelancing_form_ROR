

document.addEventListener("DOMContentLoaded", function(){

    const toastElList = document.querySelectorAll('.toast')
    const toastList = [...toastElList].map(element=>{
            new bootstrap.Toast(element).show()

        });
    })


