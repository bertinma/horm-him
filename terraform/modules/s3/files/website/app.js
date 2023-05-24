// // Create an instance of Express
// const app = express();
// app.use(express.static(__dirname + '/public'));

// // Parse incoming request bodies in a middleware
// app.use(bodyParser.urlencoded({ extended: true }));
// app.use(bodyParser.json());

// // Define a route to handle form submission
// app.post('/submit-form', (req, res) => {
//     const { firstName, lastName, email, address, photograph, size, frame} = req.body;
    
//     const values = {
//         "first_name" : firstName, 
//         "last_name" : lastName, 
//         "email" : email, 
//         "adddress" : address, 
//         "photograph" : photograph, 
//         "size" : size, 
//         "frame" : (String(frame).toLowerCase() == "true")
//     }



document.getElementById("submit_btn").addEventListener("submit", submitForm);

function submitForm(event){
    event.preventDefault();

    console.log(event);
    // const response = fetch('', {
    //     method: 'POST',
    //     headers: {
    //         'Accept': 'application/json',
    //         'Content-Type': 'application/json'
    //     },
    //     body: JSON.stringify(values)
    // })
    //     .then(response => response.json())
    //     .then(response => console.log(JSON.stringify(response)))
    //     .then(response => res.redirect(`/success.html?order=${parseInt(response.body)}`))
};