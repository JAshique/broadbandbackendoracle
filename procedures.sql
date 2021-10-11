PROCEDURE #1




CREATE OR REPLACE PROCEDURE register_user(
v_name cust_details.c_name%TYPE,
v_mobile cust_details.c_mobile%TYPE,
v_proof cust_proof.c_proof%TYPE,
v_city custloc.c_city%TYPE,
v_area custloc.c_area%TYPE,
v_username user_login.user_id%TYPE,
v_password user_login.password%TYPE)
IS
id_number cust_details.c_id%TYPE;
--user_subid		subscription.s_id%TYPE;
BEGIN
	-- id_number is used to generate a random number for customer id using SEQUENCE cust_seq_val
	id_number := cust_id_seq.NEXTVAL;
	-- The following details are inserted into it's respective tables and registers the user.
	INSERT INTO cust_details VALUES (id_number, v_name, v_mobile, v_area);
	INSERT INTO custloc VALUES (v_area, v_city);
	INSERT INTO cust_proof VALUES (id_number, v_proof);
	INSERT INTO user_login VALUES (id_number, v_username, v_password);
	show_subscription(v_area);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Incorrect data entered. Please enter proper details');
END register_user;
/



CREATE OR REPLACE PROCEDURE show_subscription(sub_area custloc.c_area%TYPE) IS
v_id subscription.s_id%TYPE;
v_cost subscription.s_cost%TYPE;
v_area subscription.s_area%TYPE;
v_speed subscription.s_speed%TYPE;
CURSOR subs_cursor IS 
SELECT s_id, s_cost, s_area, s_speed FROM subscription WHERE s_area = sub_area;
BEGIN
	-- This method is used to show all available plans based on the user's location (area). A cursor is used to print all values in the table.
	OPEN subs_cursor;
	LOOP
		FETCH subs_cursor INTO v_id, v_cost, v_area, v_speed;
		EXIT WHEN subs_cursor%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_cost || ' - ' || v_area || ' - ' || v_speed);
	END LOOP;
	CLOSE subs_cursor;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Plans not available for your area or Invalid area. Please try again');
END show_subscription;
/







PROCEDURE #2

CREATE OR REPLACE PROCEDURE login(
v_uname user_login.user_id%TYPE,
v_password user_login.password%TYPE)
IS
c_username user_login.user_id%TYPE;
c_custid user_login.password%TYPE;
BEGIN
	-- This method is used to check if the user has given proper login credentials. If yes, the user logs in and shows their customer ID and username.
	SELECT user_id, c_id "CUSTOMER ID" INTO c_username, c_custid FROM user_login WHERE user_id = v_uname AND password = v_password;
	DBMS_OUTPUT.PUT_LINE('CUSTOMER ID:' || c_custid);
	DBMS_OUTPUT.PUT_LINE('USER ID:' || c_username);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('User does not exist. Enter proper credentials');
END login;
/








PROCEDURE #3


CREATE OR REPLACE PROCEDURE set_subscription(sub_id subscription.s_id%TYPE, cust_id cust_details.c_id%TYPE, c_area custloc.c_area%TYPE) AS
v_id subscription.s_id%TYPE;
v_cost subscription.s_cost%TYPE;
v_area subscription.s_area%TYPE;
v_speed subscription.s_speed%TYPE;
BEGIN
	-- This method is used to set the user's selected broadband plan into the database. This method is used only when the user hasn't selected a plan before.
	--The insert statement assigns a plan to it's customer ID.
	INSERT INTO cust_subscription VALUES (cust_id, sub_id);
	dbms_output.put_line('You have selected the following plan');
	SELECT s_id, s_cost, s_area, s_speed INTO v_id, v_cost, v_area, v_speed FROM subscription WHERE s_id = sub_id;
	DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_cost || ' - ' || v_area || ' - ' || v_speed);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('INVALID customer ID/Subscription ID or area. Try again.');
END set_subscription;
/



CREATE OR REPLACE PROCEDURE change_subscription(sub_id subscription.s_id%TYPE, cust_id cust_details.c_id%TYPE, c_area custloc.c_area%TYPE) AS
v_id subscription.s_id%TYPE;
v_cost subscription.s_cost%TYPE;
v_area subscription.s_area%TYPE;
v_speed subscription.s_speed%TYPE;
BEGIN
	-- This method is called if the user wants to change their broadband plan.
	-- Update statement is used to change subscription ID (s_id) of the customer.
	UPDATE cust_subscription SET s_id = sub_id WHERE c_id = cust_id;
	dbms_output.put_line('You have selected the following plan');
	SELECT s_id, s_cost, s_area, s_speed INTO v_id, v_cost, v_area, v_speed FROM subscription WHERE s_id = sub_id;
	DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_cost || ' - ' || v_area || ' - ' || v_speed);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('INVALID customer ID/Subscription ID or area. Try again.');
END change_subscription;
/





PROCEDURE #4

CREATE OR REPLACE PROCEDURE generate_bill(cust_id cust_details.c_id%TYPE, sub_id subscription.s_id%TYPE, month VARCHAR2) IS
bill_num NUMBER;
v_cid cust_details.c_id%TYPE;
v_sid subscription.s_id%TYPE;
v_billno bill.bill_no%TYPE;
v_month VARCHAR2(10);
v_status bill.status%TYPE;
v_cost subscription.s_cost%TYPE;
BEGIN
	-- bill_num_seq is a user created sequence which generates a random number for bill number.
	-- This method generates a bill and adds it's contents to bill table.
	bill_num := bill_num_seq.NEXTVAL;
	INSERT INTO bill VALUES (cust_id, bill_num, month, 'PENDING', sub_id);
	SELECT s_cost INTO v_cost FROM subscription WHERE s_id = sub_id;
	SELECT c_id, s_id, bill_no, month, status INTO v_cid, v_sid, v_billno, v_month, v_status FROM bill WHERE bill_no = bill_num;
	DBMS_OUTPUT.PUT_LINE(v_cid || ' - ' || v_sid || ' - ' || v_billno || ' - ' || v_month || ' - ' || v_status || ' - ' || v_cost);
END generate_bill;
/	








PROCEDURE #5

CREATE OR REPLACE PROCEDURE transaction(cust_id cust_details.c_id%TYPE, bill_num bill.bill_no%TYPE, sub_id subscription.s_id%TYPE) AS
transaction_num NUMBER(10);
amount NUMBER(5);
sys_doi DATE;
bill_number bill.bill_no%TYPE;
BEGIN
	-- transaction_id_seq is a user created sequence which generates a random number for Transaction ID.
	-- This method is called whenever a user makes a successful payment and updates it's respective tables.
	transaction_num := transaction_id_seq.NEXTVAL;
	SELECT s_cost INTO amount FROM subscription WHERE s_id = sub_id;
	INSERT INTO transaction_details VALUES(transaction_num, bill_num, sysdate, amount);
	SELECT t_id, bill_no, doi, amt_paid INTO transaction_num, bill_number, sys_doi, amount FROM transaction_details WHERE bill_no = bill_num;
	DBMS_OUTPUT.PUT_LINE(transaction_num || ' - ' || bill_num || ' - ' || sysdate || ' - ' || amount);
	UPDATE bill SET status = 'PAID' where bill_no = bill_num;
END transaction;
/



















