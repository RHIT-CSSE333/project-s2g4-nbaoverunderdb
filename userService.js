const sql = require('mssql');
const fs = require('fs');
const bcrypt = require('bcrypt'); // npm install bcrypt

const config = {
    user: 'nbaoverunderuser',
    password: 'NBAPassword123',
    server: 'golem.csse.rose-hulman.edu', // You can use 'localhost\\instance' to connect to named instance
    database: 'NBAOverUnderDB',
    options: {
        trustServerCertificate: true // This bypasses the SSL certificate validation
    }
};

async function login(username, password) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('Username', sql.VarChar(255), username);

        // Execute the stored procedure
        const result = await request.execute('LoginQuery');
        console.log(result)

        // Store password salt and hash
        const passwordSalt = result.value("PasswordSalt");
        console.log('Password Salt:', passwordSalt);
        const passwordHash = result.value("PasswordHash");
        console.log('Password Hash:', passwordHash);
        
        bcrypt.hash(password, salt, function(err, hash){
            const hashedPassword = hash;
        });
        bcrypt.compare(hashedPassword, PasswordHash, function(err, result) {
            if (result) {
                console.log("Login successful");
                return true;
            }
            else {
                console.log("Invalid login");
                return false;
            }
        });
        
    } catch (err) {
        console.error('Error:', err);
    } finally {
        // Close the database connection
        sql.close();
    }
}

async function register(username, email, password) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('Username', sql.VarChar(255), username);
        request.input('Email', sql.VarChar(255), email);
        bcrypt.genSalt(10, function(err, salt) {  
            bcrypt.hash(password, salt, function(err, hash) {
                request.input('PasswordSalt', sql.VarChar(255), salt);
                request.input('PasswordHash', sql.VarChar(255), hash);
            });
        });

        // Execute the stored procedure
        const result = await request.execute('Register');
        if(result == 0) {
            return true;
        }
        else {
            return false
        }

    } catch (err) {
        console.error('Error:', err);
    } finally {
        // Close the database connection
        sql.close();
    }
}