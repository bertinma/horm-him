document.getElementById("submit_btn").addEventListener("submit", submitForm);

function submitForm(event){
    event.preventDefault();

    console.log(event);
    const response = fetch('https://pu6djltkbwgnyg25to7crx3sba0skgrr.lambda-url.eu-west-3.on.aws/', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(values)
    })
        .then(response => response.json())
        .then(response => console.log(JSON.stringify(response)))
        .then(response => res.redirect(`/success.html?order=${parseInt(response.body)}`))
};