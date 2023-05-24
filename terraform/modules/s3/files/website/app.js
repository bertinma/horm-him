document.getElementById("submit_btn").addEventListener("submit", submitForm);

async function submitForm(event){
    event.preventDefault();


    const formFields = event.target.elements;

    const firstName = formFields.firstName.value;
    const lastName = formFields.lastName.value;
    const email = formFields.email.value;
    const address = formFields.address.value;
    const photograph = formFields.photograph.value;
    const size = formFields.size.value;
    const frame = formFields.frame.checked;

    const values = {
        "first_name" : firstName,
        "last_name" : lastName,
        "email" : email,
        "address" : address,
        "photograph" : photograph,
        "size" : size,
        "frame" : frame
    };
    
    console.log(event);
    const response = await fetch('https://pu6djltkbwgnyg25to7crx3sba0skgrr.lambda-url.eu-west-3.on.aws/', {
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