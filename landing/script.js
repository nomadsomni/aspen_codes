document.querySelector('form').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent the form from submitting

    let name = document.querySelector('#name').value;
    let email = document.querySelector('#email').value;

    if (name && email) {
        alert('Thank you for your message, ' + name + '!');
    } else {
        alert('Please fill in all fields.');
    }
});
