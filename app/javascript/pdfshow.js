document.addEventListener('turbo:load', function () {
  // Get references to the PDF embed element and the unblur button
  var pdfEmbedDiv = document.getElementById('pdfEmbed');
  var pdfEmbed = document.getElementById('pdfEmbed1');
  var unblurButton = document.getElementById('unblurButton');

  // Check if the PDF embed element exists
  if (pdfEmbedDiv) {
    // Check if the unblur button exists
    if (unblurButton) {
      // Add a click event listener to the unblur button
      unblurButton.addEventListener('click', function (event) {
        event.preventDefault();

        // Check if the current user is the owner of the PDF
        var isOwner = pdfEmbedDiv.dataset.currentUser == pdfEmbedDiv.dataset.pdfUser;

        if (isOwner) {
          // If the user is the owner, directly unblur the PDF
          pdfEmbed.classList.remove('pdf-viewer');
        } else {
          // If not, make an AJAX request to unlock PDF
          fetch('/pdfs/' + pdfEmbedDiv.dataset.pdfId + '/unlock_pdf', {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({}),
          })
          .then(response => response.json())
          .then(data => {
            if (data.success) {
              // Update the unlocks count on the client side
              var unlocksCountElement = document.getElementById('unlocksCount');
              if (unlocksCountElement) {
                unlocksCountElement.textContent = data.unlocks_count;
              }

              // Unblur the PDF
              pdfEmbed.classList.remove('pdf-viewer');
            } else {
              // Handle the case where the server returns an error
              alert(data.message);
            }
          })
          .catch(error => {
            // Handle any network or unexpected errors
            console.error(error);
            alert('Failed to unlock PDF. Please try again.');
          });
        }
      });
    } else {
      // Check if the PDF is already unlocked, and remove the blur if it is
      if (pdfEmbedDiv.dataset.unlocked === 'true') {
        pdfEmbed.classList.remove('pdf-viewer');
      }
    }
  }
});
