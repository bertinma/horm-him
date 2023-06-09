document.getElementById("submit_btn").addEventListener("submit", submitForm);

async function submitForm(event){
    event.preventDefault();


    const formFields = event.target.elements;

    const firstName = formFields.firstName.value;
    const lastName = formFields.lastName.value;
    const email = formFields.email.value;
    const address = formFields.address.value;
    const photograph = formFields.photograph.value;
    const picture = formFields.picture.value;
    const size = formFields.size.value;

    const values = {
        "first_name" : firstName,
        "last_name" : lastName,
        "email" : email,
        "address" : address,
        "photograph" : photograph,
        "picture" : picture,
        "size" : size
    };
    
    console.log(event);
    const response = await fetch('https://cmvey3howualzox4o4kw3x5kkm0kkykn.lambda-url.eu-west-3.on.aws/', {
        method: 'POST',
        mode: "cors",
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(values)
    })
    const data = await response.json();
    console.log(JSON.parse(data));
    order_id = JSON.parse(data);
    window.location.replace("success.html?order="+order_id);
};