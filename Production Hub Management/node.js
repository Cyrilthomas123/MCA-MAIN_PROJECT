// Import required modules
const express = require('express');
const oracledb = require('oracledb');
const bodyParser = require('body-parser');
const cors = require('cors')

// Create Express app
const app = express();
const port = 3000;

// Middleware
app.use(cors())
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Oracle Database connection configuration
const dbConfig = {
  user: 'PROJECT1',
  password: 'project123',
  connectString: 'ORCL',
};

// Route to handle form submission with image
app.post('/api/post1', async (req, res) => {
  console.log('Received POST request at /api/post1');
  const { COMPANY_ID, COMPANY_NAME, ADDRESS1, ADDRESS2, ADDRESS3, WEBSITE, MAILID, PHNO, COUNTRY_CODE } = req.body;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Check if the company ID already exists
    const existingCompany = await connection.execute(
      `SELECT COMPANY_ID FROM company WHERE COMPANY_ID = :companyId`,
      [COMPANY_ID]
    );

    // If the company ID already exists, send a conflict response
    if (existingCompany.rows.length > 0) {
      await connection.close();
      return res.status(409).json({ error: 'Company ID already exists' });
    }

    // Execute the insert query
    const result = await connection.execute(
      `INSERT INTO company (COMPANY_ID, COMPANY_NAME, ADDRESS1, ADDRESS2, ADDRESS3, WEBSITE, MAILID, PHNO, COUNTRY_CODE) VALUES (:COMPANY_ID, :COMPANY_NAME, :ADDRESS1, :ADDRESS2, :ADDRESS3, :WEBSITE, :MAILID, :PHNO, :COUNTRY_CODE)`,
      {
        COMPANY_ID,
        COMPANY_NAME,
        ADDRESS1,
        ADDRESS2,
        ADDRESS3,
        WEBSITE,
        MAILID,
        PHNO,
        COUNTRY_CODE,
      }
    );

    // Commit the transaction
    await connection.commit();
    console.log('Transaction committed successfully');

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    // Send a success response
    res.status(200).json({ message: 'Data inserted successfully!' });
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Route to retrieve company details by ID
// Route to retrieve company details by ID
app.get('/api/company/:id', async (req, res) => {
  console.log('Received GET request at /api/company/:id');
  const companyId = req.params.id;

  try {
    // Connect to Oracle Database
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    // Execute the query to retrieve company details by ID
    const result = await connection.execute(
      `SELECT * FROM company WHERE COMPANY_ID = :companyId`,
      [companyId]
    );

    // Release the connection
    await connection.close();
    console.log('Connection closed successfully');

    if (result.rows.length > 0) {
      // Construct JSON response with column names and values
      const companyDetails = {};
      const columnNames = result.metaData.map(column => column.name);
      const row = result.rows[0];
      columnNames.forEach((columnName, index) => {
        companyDetails[columnName] = row[index];
      });

      // Send company details as JSON response
      res.status(200).json(companyDetails);
    } else {
      res.status(404).json({ error: 'Company not found' });
    }
  } catch (error) {
    console.error('Error:', error);

    // Send an error response
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/api/update_company', async (req, res) => {
  console.log('Received POST request at /api/update_company');
  
  const {
    COMPANY_ID,
    COMPANY_NAME,
    ADDRESS1,
    ADDRESS2,
    ADDRESS3,
    WEBSITE,
    MAILID,
    PHNO,
    COUNTRY_CODE
  } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);
    console.log('Connected to Oracle Database');

    const result = await connection.execute(
      `UPDATE company 
       SET COMPANY_NAME = :COMPANY_NAME,
           ADDRESS1 = :ADDRESS1,
           ADDRESS2 = :ADDRESS2,
           ADDRESS3 = :ADDRESS3,
           WEBSITE = :WEBSITE,
           MAILID = :MAILID,
           PHNO = :PHNO,
           COUNTRY_CODE = :COUNTRY_CODE
       WHERE COMPANY_ID = :COMPANY_ID`,
      {
        COMPANY_NAME,
        ADDRESS1,
        ADDRESS2,
        ADDRESS3,
        WEBSITE,
        MAILID,
        PHNO,
        COUNTRY_CODE,
        COMPANY_ID
      }
    );

    await connection.commit();
    console.log('Transaction committed successfully');

    await connection.close();
    console.log('Connection closed successfully');

    res.status(200).json({ message: 'Company details updated successfully!' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Start the server
app.listen(port, '192.168.47.197', () => {
  console.log(`Server is running at http://localhost:${port}`);
});
