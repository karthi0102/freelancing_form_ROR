const elem = document.getElementById('role_role');


client = document.getElementById("client_attributes")
freelancer =document.getElementById("freelancer_attributes")

client.style.display="none"
freelancer.style.display="none"
elem.addEventListener('change',drop)

function drop() {
      console.log(elem.value)
      if (elem.value == 'Client') {
          client.style.display="block"
          freelancer.style.display="none"
      } else if (elem.value == "Freelancer") {
          client.style.display="none"
          freelancer.style.display="block"
      }else{
        client.style.display="none"
        freelancer.style.display="none"
      }

  }


  // document.addEventListener('DOMContentLoaded', function() {
  //   event.preventDefault();
  //   var resetButton = document.getElementById('reset-button');
  //   var fileField = document.querySelector('input[type="file"]');

  //   resetButton.addEventListener('click', function() {
  //     fileField.value = null;
  //     return false;
  //   });
  // });


  // document.addEventListener('DOMContentLoaded', function() {
  //   event.preventDefault();
  //   var resetButton = document.getElementById('reset-button-1');
  //   var fileField = document.getElementById("aadhar_image");

  //   resetButton.addEventListener('click', function() {
  //     console.log("Rider called")

  //     fileField.value = null;
  //     return false;
  //   });
  // });

