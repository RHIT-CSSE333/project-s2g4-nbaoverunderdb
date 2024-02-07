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

async function addStats(pointsAvg) {
    try {
        // Open database connection
        await sql.connect(config);

        // Set up the parameters
        const request = new sql.Request();
        request.input('PointsAvg', sql.Decimal(6, 2), pointsAvg);
        request.output('StatsID', sql.Int);

        // Execute the stored procedure
        const result = await request.execute('AddTeamStats');
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

async function addTeam(TName, statsID) {
    try {
        await sql.connect(config);

        const request = new sql.Request();
        request.input('TName', sql.VarChar(255), TName);
        request.input('StatsID', sql.Int, statsID);

        const result = await request.execute('ADDTEAM');

        console.log('Result of ADDTEAM:', result);
    } catch (err) {
        console.error('Error in ADDTEAM:', err);
    } finally {
        sql.close();
    }
}

//const processedPlayers = new Set(); // Set to track processed players

async function processRow(row) {
    try {
        const TName = row['Team'];
        //const FName = PName[0];
        //const LName = PName.slice(1).join(" "); // Join all parts after the first one

        // Skip processing if this player has already been processed
        // const fullName = FName + " " + LName;
        // if (processedPlayers.has(fullName)) {
        //     return;
        // }
        // processedPlayers.add(fullName);

        const ptsAvg = row['PTS'];

        const statsID = await addStats(ptsAvg);

        await addTeam(TName, statsID);
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

processCsvFile('nbaTeamStats.csv');