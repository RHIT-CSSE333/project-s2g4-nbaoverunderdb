const sql = require('mssql');
const fs = require('fs');
// const csv = require('csv-parser');

// Database configuration
const config = {
    user: 'nbaoverunderuser',
    password: 'NBAPassword123',
    server: 'golem.csse.rose-hulman.edu', // You can use 'localhost\\instance' to connect to named instance
    database: 'NBAOverUnderDB',
    options: {
        trustServerCertificate: true // This bypasses the SSL certificate validation
    }
};

async function addFavoritePlayer(fName, lName, user) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('PlayerFName', sql.VarChar(100), fName);
        request.input('PlayerLName', sql.VarChar(100), lName);
        request.input('UserName', sql.VarChar(100),user);
       
        // Execute the stored procedure
        const result = await request.execute('AddFavoritePlayer');
        console.log(result);

        // Access the output parameter
        
        console.log('UserName:', user);

        return true;
    } catch (err) {
        console.error('Error:', err);
        return false;
    } finally {
        // Close the database connection
        sql.close();
    }
}

async function addFavoriteTeam(teamName, user) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('TeamName', sql.VarChar(100), teamName);
        request.input('UserName', sql.VarChar(100),user);
       
        // Execute the stored procedure
        const result = await request.execute('AddFavoriteTeam');
        console.log(result);

        
        console.log('UserName:', user);

        return true;
    } catch (err) {
        console.error('Error:', err);
        return false;
    } finally {
        // Close the database connection
        sql.close();
    }
}

async function addFavorites(fName, lName, teamName, user) {
    let playerAdded = await addFavoritePlayer(fName, lName, user);
    let teamAdded = await addFavoriteTeam(teamName, user);

    if (playerAdded || teamAdded) {
        console.log(' player or team added successfully for user:', user);
        return true;
    } else {
        console.error('Error adding player or team for user:', user);
        return false;
    }
}

// app.post('/add-favorites', async (req, res) => {
//     const { fName, lName, teamName, user } = req.body;
//     const success = await addFavorites(fName, lName, teamName, user);
//     if (success) {
//         res.send('Favorites added successfully!');
//     } else {
//         res.status(500).send('Error adding favorites.');
//     }
// });

addFavoriteTeam('Washington Wizards', 'JohnDoe123');