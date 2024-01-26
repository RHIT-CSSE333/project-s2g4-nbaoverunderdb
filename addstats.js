const sql = require('mssql');
const fs = require('fs');
const csv = require('csv-parser');

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

async function addStats(fName, lName, pointsAvg, reboundsAvg, blocksAvg, stealsAvg, assistsAvg) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('FName', sql.VarChar(255), fName);
        request.input('LName', sql.VarChar(255), lName);
        request.input('PointsAvg', sql.Decimal(5, 2), pointsAvg);
        request.input('ReboundsAvg', sql.Decimal(5, 2), reboundsAvg);
        request.input('BlocksAvg', sql.Decimal(5, 2), blocksAvg);
        request.input('StealsAvg', sql.Decimal(5, 2), stealsAvg);
        request.input('AssistsAvg', sql.Decimal(5, 2), assistsAvg);
        request.output('StatsID', sql.Int);

        // Execute the stored procedure
        const result = await request.execute('AddStats');
        console.log(result)

        // Access the output parameter
        const statsID = result.output.StatsID;
        console.log('Stats ID:', statsID);

        return statsID;
    } catch (err) {
        console.error('Error:', err);
    } finally {
        // Close the database connection
        sql.close();
    }
}

async function addPlayer(fName, lName, statsID) {
    try {
        await sql.connect(config);

        const request = new sql.Request();
        request.input('FName', sql.VarChar(255), fName);
        request.input('LName', sql.VarChar(255), lName);
        // Assuming the third parameter is not used in your procedure and is nullable
        request.input('TeamID', sql.VarChar(255), null);
        request.input('StatsID', sql.Int, statsID);

        const result = await request.execute('ADDPLAYER');

        console.log('Result of ADDPLAYER:', result);
    } catch (err) {
        console.error('Error in ADDPLAYER:', err);
    } finally {
        sql.close();
    }
}

const processedPlayers = new Set(); // Set to track processed players

async function processRow(row) {
    try {
        const PName = row['Player'].split(" ");
        const FName = PName[0];
        const LName = PName.slice(1).join(" "); // Join all parts after the first one

        // Skip processing if this player has already been processed
        const fullName = FName + " " + LName;
        if (processedPlayers.has(fullName)) {
            return;
        }
        processedPlayers.add(fullName);

        const ptsAvg = row['PTS'];
        const rebAvg = row['TRB'];
        const assistAvg = row['AST'];
        const blkAvg = row['BLK'];
        const stlAvg = row['STL'];

        const statsID = await addStats(FName, LName, ptsAvg, rebAvg, blkAvg, stlAvg, assistAvg);
        await addPlayer(FName, LName, statsID);
    } catch (err) {
        console.error('Error processing row:', err);
    }
}

async function processCsvFile(filePath) {
    const rows = [];

    fs.createReadStream(filePath)
        .pipe(csv())
        .on('data', (row) => rows.push(row))
        .on('end', async () => {
            for (let row of rows) {
                await processRow(row);
            }
            console.log('CSV file processed successfully.');
        });
}

// Replace 'nbadata.csv' with the path to your CSV file
processCsvFile('nbadata.csv');