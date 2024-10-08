const sql = require('mssql');
const fs = require('fs');
const csv = require('csv-parser');

// Database configuration
const config = {
    user: 'nbaoverunderuser',
    password: 'NBAPassword123',
    server: 'golem.csse.rose-hulman.edu',
    database: 'NBAOverUnderDB5',
    options: {
        trustServerCertificate: true 
    }
};

let pool = null; // Global variable to hold the connection pool

async function getPool() {
    if (pool) return pool; // Use existing pool if already created
    pool = await sql.connect(config); // Create a new pool if one does not exist
    return pool;
}

async function addStats(fName, lName, pointsAvg, reboundsAvg, blocksAvg, stealsAvg, assistsAvg) {
    try {
        // Open database connection
        const pool = await getPool(); // Use the global connection pool
        const request = pool.request();
        // await sql.connect(config);

        // Set up the parameters
        // const request = new sql.Request();
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
        // sql.close();
    }
}

async function addTeamStats(pointsAvg) {
    try {
        // Open database connection
        const pool = await getPool(); // Use the global connection pool
        const request = pool.request();
        // await sql.connect(config);

        // Set up the parameters
        // const request = new sql.Request();
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
        // sql.close();
    }
}

async function addPlayer(fName, lName, statsID) {
    try {
        // await sql.connect(config);
        const pool = await getPool(); // Use the global connection pool
        const request = pool.request();

        // const request = new sql.Request();
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
        // sql.close();
    }
}

async function addTeam(TName, statsID) {
    try {
        // await sql.connect(config);
        const pool = await getPool(); // Use the global connection pool
        const request = pool.request();

        // const request = new sql.Request();
        request.input('TName', sql.VarChar(255), TName);
        request.input('StatsID', sql.Int, statsID);

        const result = await request.execute('ADDTEAM');

        console.log('Result of ADDTEAM:', result);
    } catch (err) {
        console.error('Error in ADDTEAM:', err);
    } finally {
        // sql.close();
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

async function processTeamRow(row) {
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

        const statsID = await addTeamStats(ptsAvg);

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

async function processCsvTeamFile(filePath) {
    const rows = [];

    fs.createReadStream(filePath)
        .pipe(csv())
        .on('data', (row) => rows.push(row))
        .on('end', async () => {
            for (let row of rows) {
                await processTeamRow(row);
            }
            console.log('CSV file processed successfully.');
        });
}

// Replace 'nbadata.csv' with the path to your CSV file
async function main() {
    try {
        await processCsvFile('nbadata.csv');
        await processCsvTeamFile('nbaTeamStats.csv');
        // Any other operations...
    } catch (err) {
        console.error('Error during main execution:', err);
    } finally {
        if (pool) await pool.close(); // Close the pool only once at the end of all operations
    }
}

main(); // Kick off the process