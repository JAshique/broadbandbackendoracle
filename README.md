# broadbandbackendoracle
Broadband Billing System in Oracle

Hello everyone. This is a personal project I did recently to test my knowledge in Oracle and backend programmming.



This repository consists of a database containing normalized tables: (Refer Diagrams folder for ER table diagrams and contents of the table)


      cust_details        -  Contains all the information about the customer.
      custloc             -  Contains the cusstomer's location that references cust_details.
      cust_proof          -  Holds ID proof data of the customer that references cust_details.
      user_login          -  Contains the login credentials of all customers.
      subscription        -  Contains all the available broadband plans.
      cust_subscription   -  This table tells the customer and what plan are they currently using.
      Bill                -  Consists of customer's invoice details.
      Transaction_details -  Holds every successful transaction a customer has done.

This repository also has PL/SQL procedures which performs various functions such as register a user, login to your account, change subscription plan, generate a bill and keeps record of it's transaction details.


Refer the diagrams folder for Entity Relationship between various tables. The PDF file shows a graphical view of all values present inside the table.

The database.sql file contains all queries required for creating all tables and values inserted to it. The procedures.sql file contains all PL/SQL procedures.


The problem statement is given below.


Broadband provides high-speed data transmission to the Internet and 4G networks were developed to transform broadband technology with higher data rate and enhanced quality of service. The billing system of the broadband network in terms of availability, subscription plans and payment mode is evaluated in the work.



Design the normalized relational database using the following details. You can make appropriate assumptions wherever required. Some of the attributes are given below with the restrictions on data it can contain. Find the required attributes for all the tables and create appropriate constraints on it. (For Ex. Primary key, Foreign key, etc.)



Some of the entities and attributes are as follows (Tables are not normalized):



        Cust_details- Customer id, Customer mobile number, Customer City, Customer area , Customer type, Customer id proof.
        User_login- User id, password, Customer type.
        Transaction_details – Transaction id,  bill no, date of issue, paid amount, pay method.
        Customer_subscription- Customer id, subscription id, subscription area, for month.
        Subscription- Subscription id, subscription cost, subscription details, subscription area, subscription speed.
        Bill- bill number, Customer id, subscription id, month, cost, status.
                  Billing Parameters:
                     Billing will be done at the end of Every month
                     Total plans available: 12

      
      
.         Create a procedure which gets customer name, customer mobile number, id proof, type, city, area and password as inputs and registers the customer for choosing any suitable plan of broadband as per his locality.

·        Create a procedure which gets user id and password as input and login the customer to their respective accounts which shows their currently using subscription plans, if any, and show them total plans available for them.

·        Create a procedure which gives customer all the plans available and customer can choose anyone plan out of them as per his need and locality by taking subscription id, customer id and month as input.

·        Create a procedure which will generate the bill for the customer’s chosen subscription plan by taking subscription id, month, and customer id as inputs.

·        Create a procedure to make transaction for payment for the chose transaction and will show the transaction details of the customer’s payment status.
