const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const path = require('path');

// Create an instance of Express
const app = express();
app.use(express.static(__dirname + '/public'));

// Parse incoming request bodies in a middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var connection = mysql.createConnection({
    host     : 'database-1.cf7vtfka8jum.eu-west-3.rds.amazonaws.com',
    user     : 'admin',
    password : 'galia-expo-75011!',
    port: '3306'
});

connection.connect(function(err) {
    if (err) {
        console.error('error connecting: ' + err.stack);
        return;
    }
    console.log('connected as id ' + connection.threadId);
});

// Define a route to handle form submission
app.post('/submit-form', (req, res) => {
    const { firstName, lastName, email, address, photograph, size, frame} = req.body;
    
    // Prepare the SQL query to insert form data into a table
    const sql = 'USE; INSERT INTO orders_him (first_name, last_name, email, address, photograph, size, frame) VALUES (?, ?, ?, ?, ?, ?, ?)';
    const values = [firstName, lastName, email, address, photograph, size, frame];
    
    // Execute the SQL query
    connection.query(sql, values, (err) => {
        if (err) {
            console.error('Error inserting data:', err);
            res.status(500).send('Error inserting data');
        } else {
            console.log('Data inserted successfully');
            res.status(200).send('Data inserted successfully');
        }
    });
});

// // Define a route to get the count of IDs from a table
// app.get('/id-count', (req, res) => {
//     // Prepare the SQL query to get the count of IDs
//     const sql = 'SELECT COUNT(id) as idCount FROM your_table_name';

//     // Execute the SQL query
//     connection.query(sql, (err, results) => {
//         if (err) {
//             console.error('Error retrieving ID count:', err);
//             res.status(500).send('Error retrieving ID count');
//         } else {
//             const idCount = results[0].idCount;
//             console.log('ID count:', idCount);
//             res.status(200).json({ count: idCount });
//         }
//     });
// });


// Serve the HTML file as the root URL response
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});


// Start the server
const port = 3000; // Choose the desired port number
app.listen(port, () => {
    console.log(`Server running on port http://localhost:${port}`);
});

