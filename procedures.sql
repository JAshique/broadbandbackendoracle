PROCEDURE #1




CREATE OR REPLACE PROCEDURE register_user(
v_name IN cust_details.c_name%TYPE,
v_mobile IN cust_details.c_mobile%TYPE,
v_proof IN cust_proof.c_proof%TYPE,
v_city IN custloc.c_city%TYPE,
v_area IN custloc.c_area%TYPE,
v_username IN user_login.user_id%TYPE,
v_password IN user_login.password%TYPE)
IS
id_number cust_details.c_id%TYPE;
BEGIN
	-- id_number is used to generate a random number for customer id using SEQUENCE cust_seq_val
	id_number := cust_id_seq.NEXTVAL;
	-- The following details are inserted into it's respective tables and registers the user.
	INSERT INTO cust_details VALUES (id_number, v_name, v_mobile, v_area);
	INSERT INTO cust_proof VALUES (id_number, v_proof);
	INSERT INTO user_login VALUES (id_number, v_username, v_password);
	DBMS_OUTPUT.PUT_LINE('---------------User successfully registered---------------------');
	DBMS_OUTPUT.PUT_LINE('Available plans for ' || v_area || ', ' || v_city);
	show_subscription(v_area);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Registration Failed. Incorrect data entered. Please enter proper details');
END register_user;
/



CREATE OR REPLACE PROCEDURE show_subscription(sub_area IN custloc.c_area%TYPE) IS
TYPE t_id IS TABLE OF subscription.s_id%TYPE INDEX BY BINARY_INTEGER;
TYPE t_cost IS TABLE OF subscription.s_cost%TYPE INDEX BY BINARY_INTEGER;
TYPE t_area IS TABLE OF subscription.s_area%TYPE INDEX BY BINARY_INTEGER;
TYPE t_speed IS TABLE OF subscription.s_speed%TYPE INDEX BY BINARY_INTEGER;

v_id t_id;
v_cost t_cost;
v_area t_area;
v_speed t_speed;
total NUMBER;
unavailable_plan EXCEPTION;
BEGIN
	-- This method is used to show all available plans based on the user's location (area). A cursor is used to print all values in the table.
	-- Bulk Collect is also used to reduce the number of context switches.
	SELECT /*+ INDEX_COMBINE(subscription S_AREA_IDX) */ s_id, s_cost, s_area, s_speed BULK COLLECT INTO v_id, v_cost, v_area, v_speed
	FROM subscription WHERE s_area = sub_area;
	IF SQL%ROWCOUNT = 0 THEN
    		RAISE unavailable_plan;
	END IF;
	total := v_id.count;
	FOR i IN 1 .. total LOOP
		DBMS_OUTPUT.PUT_LINE('ID: ' || v_id(i) || ' - ' || 'Cost: ' || v_cost(i) || ' - ' || 'Location: ' || v_area(i) || ' - ' || 'Data rate: ' || v_speed(i));
	END LOOP;
EXCEPTION
	WHEN unavailable_plan THEN
		DBMS_OUTPUT.PUT_LINE('Plans not available for your area or Invalid area. Please try again');
END show_subscription;
/







PROCEDURE #2

CREATE OR REPLACE PROCEDURE login(
v_uname IN user_login.user_id%TYPE,
v_password IN user_login.password%TYPE)
IS
v_username user_login.user_id%TYPE;
v_u1name user_login.c_id%TYPE;
v_custid user_login.password%TYPE;
v_name cust_details.c_name%TYPE;
v_area cust_details.c_area%TYPE;
v_mobile cust_details.c_mobile%TYPE;
v_pass user_login.password%TYPE;
wrong_credentials EXCEPTION;
BEGIN
	-- This method is used to check if the user has given proper login credentials. If yes, the user logs in and shows their customer ID and username.
	SELECT user_id, password, c_id INTO v_username, v_pass, v_u1name FROM user_login WHERE v_uname = user_id;
	IF v_uname = v_username AND v_password = v_pass THEN
		DBMS_OUTPUT.PUT_LINE('---------------Login Successful--------------');
		DBMS_OUTPUT.PUT_LINE('---------------User Profile---------------------');
		SELECT user_id, c_id, c_name, c_area, c_mobile INTO v_username, v_custid, v_name, v_area, v_mobile
		FROM user_login NATURAL JOIN cust_details WHERE c_id = v_u1name;
		DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_custid || ' - ' || 'Name: ' || v_name || ' - ' || 'Username: ' || v_username || ' - ' || 'Location ' || v_area || ' - ' || 'Mobile: ' || v_mobile);
	ELSE
		RAISE wrong_credentials;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('User does not exist. Enter proper credentials');
	WHEN wrong_credentials THEN
		DBMS_OUTPUT.PUT_LINE('Wrong USER ID/PASSWORD. Please try again');
END login;
/








PROCEDURE #3


CREATE OR REPLACE PROCEDURE set_subscription
(sub_id 	IN 	subscription.s_id%TYPE, 
cust_id 	IN 	cust_details.c_id%TYPE) AS
v_id subscription.s_id%TYPE;
v_cost subscription.s_cost%TYPE;
v_area subscription.s_area%TYPE;
v_speed subscription.s_speed%TYPE;
wrong_id EXCEPTION;
BEGIN
	-- This method is used to set the user's selected broadband plan into the database. This method is used only when the user hasn't selected a plan before.
	--The insert statement assigns a plan to it's customer ID.
	INSERT INTO cust_subscription VALUES (cust_id, sub_id);
	dbms_output.put_line('------You have selected the following plan---------');
	SELECT s_id, s_cost, s_area, s_speed INTO v_id, v_cost, v_area, v_speed FROM subscription WHERE s_id = sub_id;
	IF SQL%ROWCOUNT = 0 THEN
    		RAISE wrong_id;
	END IF;
	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - ' || 'Cost: ' || v_cost || ' - ' || 'Location: ' || v_area || ' - ' || 'Data rate: ' || v_speed);
	COMMIT;
EXCEPTION
	WHEN wrong_id THEN
		DBMS_OUTPUT.PUT_LINE('INVALID customer ID/Subscription ID or area. Try again.');
END set_subscription;
/





CREATE OR REPLACE PROCEDURE change_subscription
(sub_id 	IN 	subscription.s_id%TYPE, 
cust_id 	IN 	cust_details.c_id%TYPE) AS
v_id subscription.s_id%TYPE;
v_cost subscription.s_cost%TYPE;
v_area subscription.s_area%TYPE;
v_speed subscription.s_speed%TYPE;
wrong_id EXCEPTION;
BEGIN
	-- This method is called if the user wants to change their broadband plan.
	-- Update statement is used to change subscription ID (s_id) of the customer.
	UPDATE cust_subscription SET s_id = sub_id WHERE c_id = cust_id;
	dbms_output.put_line('---------You have changed to the following plan---------');
	SELECT s_id, s_cost, s_area, s_speed INTO v_id, v_cost, v_area, v_speed FROM subscription WHERE s_id = sub_id;
	IF SQL%ROWCOUNT = 0 THEN
    		RAISE wrong_id;
	END IF;
	DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ' - ' || 'Cost: ' || v_cost || ' - ' || 'Location: ' || v_area || ' - ' || 'Data rate: ' || v_speed);
	COMMIT;
EXCEPTION
	WHEN wrong_id THEN
		DBMS_OUTPUT.PUT_LINE('INVALID customer ID/Subscription ID or area. Try again.');
END change_subscription;
/







PROCEDURE #4

CREATE OR REPLACE PROCEDURE generate_bill
(cust_id IN cust_details.c_id%TYPE, 
sub_id 	IN subscription.s_id%TYPE, 
month 	IN 	VARCHAR2) IS
bill_num NUMBER;
v_cid cust_details.c_id%TYPE;
v_sid subscription.s_id%TYPE;
v_billno bill.bill_no%TYPE;
v_month VARCHAR2(20);
v_status bill.status%TYPE;
v_cost subscription.s_cost%TYPE;
BEGIN
	-- bill_num_seq is a user created sequence which generates a random number for bill number.
	-- This method generates a bill and adds it's contents to bill table.
	bill_num := bill_num_seq.NEXTVAL;
	INSERT INTO bill VALUES (cust_id, bill_num, month, 'PENDING', sub_id);
	SELECT /*+ USE_NL_WITH_INDEX(bill, subscription)*/ c_id, s_id, bill_no, month, status, s_cost INTO v_cid, v_sid, v_billno, v_month, v_status, v_cost 
	FROM bill NATURAL JOIN subscription WHERE bill_no = bill_num AND s_id = sub_id;
	DBMS_OUTPUT.PUT_LINE('ID: ' || v_cid || ' - ' || 'Plan ID: ' || v_sid || ' - ' || 'Bill No: ' || v_billno || ' - ' || 'Month: ' || v_month || ' - ' || 'Current status: ' || v_status || ' - ' || 'Total amount: ' || v_cost);
	COMMIT;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Unable to generate bill. INVALID customer ID/Subscription ID.');
END generate_bill;
/	








PROCEDURE #5

CREATE OR REPLACE PROCEDURE transaction
(cust_id 	IN 	cust_details.c_id%TYPE, 
bill_num 	IN 	bill.bill_no%TYPE, 
sub_id 		IN 	subscription.s_id%TYPE) AS
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
	SELECT /*+ INDEX(transaction_details)*/ t_id, bill_no, doi, amt_paid INTO transaction_num, bill_number, sys_doi, amount FROM transaction_details WHERE bill_no = bill_num;
	DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || transaction_num || ' - ' || 'Bill No: ' || bill_num || ' - ' || 'Date: ' ||  sysdate || ' - ' || 'Paid amount: ' || amount);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('TRANSACTION FAILED!!! INVALID bill number or customer ID. Please try again.');
END transaction;
/



PROCEDURE #6


CREATE OR REPLACE PROCEDURE update_bill(bill_num IN NUMBER)
IS PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	--Procedure called from update_transaction trigger. Sets the bill status to PAID and commits the changes.
	DBMS_OUTPUT.PUT_LINE('------------TRIGGER FIRED. UPDATING BILL STATUS--------------');
	UPDATE bill SET status = 'PAID' where bill_no = bill_num;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('------------PAYMENT SUCCESSFUL. STATUS UPDATED.--------------');
END update_bill;
/




CREATE OR REPLACE TRIGGER update_transaction
AFTER INSERT ON transaction_details FOR EACH ROW
BEGIN
	-- calls a procedure update_bill() to update bill status and commit the changes using autonomous transaction pragma.
	update_bill(:new.bill_no);
END update_transaction;
/
