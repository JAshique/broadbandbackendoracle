CREATE TABLE CUSTLOC (c_area VARCHAR2(20) UNIQUE, c_city VARCHAR2(20));

INSERT INTO CUSTLOC VALUES ('Velachery','Chennai');
INSERT INTO CUSTLOC VALUES ('Thousand Lights','Chennai');
INSERT INTO CUSTLOC VALUES ('Parrys','Chennai');
INSERT INTO CUSTLOC VALUES ('Netaji Nagar','Delhi');
INSERT INTO CUSTLOC VALUES ('Khan Market','Delhi');
INSERT INTO CUSTLOC VALUES ('Siri Fort','Delhi');
INSERT INTO CUSTLOC VALUES ('IC Colony','Mumbai');
INSERT INTO CUSTLOC VALUES ('Huzefa Nagar','Mumbai');
INSERT INTO CUSTLOC VALUES ('Juhu','Mumbai');
INSERT INTO CUSTLOC VALUES ('Ameerpet','Hyderabad');
INSERT INTO CUSTLOC VALUES ('Nampally','Hyderabad');
INSERT INTO CUSTLOC VALUES ('Sanath Nagar','Hyderabad');

CREATE TABLE CUST_DETAILS
(
c_id NUMBER(10),
c_name VARCHAR2(20) NOT NULL,
c_mobile NUMBER(10) NOT NULL,
c_area VARCHAR2(20)
);

ALTER TABLE cust_details ADD CONSTRAINT custid_pk PRIMARY KEY(c_id);
ALTER TABLE CUST_DETAILS ADD CONSTRAINT carea_fk FOREIGN KEY(c_area) REFERENCES CUSTLOC(c_area);

INSERT INTO cust_details VALUES (10001, 'Mani', 9512345678, 'Velachery');
INSERT INTO cust_details VALUES (10002, 'Kumar', 9999999999, 'Thousand Lights');
INSERT INTO cust_details VALUES (10003, 'Lal', 9876543210, 'Parrys');
INSERT INTO cust_details VALUES (10004, 'Jack', 7865789078, 'Netaji Nagar');
INSERT INTO cust_details VALUES (10005, 'Jill', 6789368469, 'Khan Market');
INSERT INTO cust_details VALUES (10006, 'Maryam', 8726450862, 'Siri Fort');
INSERT INTO cust_details VALUES (10007, 'Rohit', 9876789123, 'IC Colony');
INSERT INTO cust_details VALUES (10008, 'Ananya', 8123765901, 'Huzefa Nagar');
INSERT INTO cust_details VALUES (10009, 'Sid', 6712367912, 'Juhu');
INSERT INTO cust_details VALUES (10010, 'Hameed', 6892103726, 'Ameerpet');
INSERT INTO cust_details VALUES (10011, 'Ranjit', 9738013413, 'Nampally');
INSERT INTO cust_details VALUES (10012, 'Anushkha', 9313467572, 'Sanath Nagar');

CREATE TABLE cust_proof 
(
c_id NUMBER(10),
c_proof VARCHAR2(16),
CONSTRAINT cid_fk FOREIGN KEY (c_id) REFERENCES cust_details (c_id)
);

INSERT INTO cust_proof VALUES (10001, 7890);
INSERT INTO cust_proof VALUES (10002, 1123);
INSERT INTO cust_proof VALUES (10003, 4569);
INSERT INTO cust_proof VALUES (10004, 2469);
INSERT INTO cust_proof VALUES (10005, 1111);
INSERT INTO cust_proof VALUES (10006, 4545);
INSERT INTO cust_proof VALUES (10007, 2212);
INSERT INTO cust_proof VALUES (10008, 8898);
INSERT INTO cust_proof VALUES (10009, 1900);
INSERT INTO cust_proof VALUES (10010, 1789);
INSERT INTO cust_proof VALUES (10011, 6290);
INSERT INTO cust_proof VALUES (10012, 5515);

CREATE TABLE subscription
(
s_id NUMBER(5),
s_cost NUMBER(4) NOT NULL,
s_area VARCHAR2(20) NOT NULL,
s_speed NUMBER(4),
CONSTRAINT sid_pk PRIMARY KEY (s_id)
);

INSERT INTO subscription VALUES (101, 1100, 'Velachery', 50);
INSERT INTO subscription VALUES (102, 1400, 'Thousand Lights', 100);
INSERT INTO subscription VALUES (103, 1750, 'Parrys', 200);
INSERT INTO subscription VALUES (104, 1500, 'Netaji Nagar', 50);
INSERT INTO subscription VALUES (105, 1700, 'Khan Market', 100);
INSERT INTO subscription VALUES (106, 1950, 'Siri Fort', 200);
INSERT INTO subscription VALUES (107, 1200, 'IC Colony', 50);
INSERT INTO subscription VALUES (108, 1350, 'Huzefa Nagar', 100);
INSERT INTO subscription VALUES (109, 1500, 'Juhu', 200);
INSERT INTO subscription VALUES (110, 1150, 'Ameerpet', 50);
INSERT INTO subscription VALUES (111, 1350, 'Nampally', 100);
INSERT INTO subscription VALUES (112, 1600, 'Sanath Nagar', 200);
INSERT INTO subscription VALUES (113, 1200, 'Velachery', 100);
INSERT INTO subscription VALUES (114, 1100, 'Thousand Lights', 50);
INSERT INTO subscription VALUES (115, 1400, 'Parrys', 100);
INSERT INTO subscription VALUES (116, 1500, 'Thousand Lights', 200);
INSERT INTO subscription VALUES (117, 1300, 'Velachery', 200);
INSERT INTO subscription VALUES (118, 1750, 'Netaji Nagar', 150);
INSERT INTO subscription VALUES (119, 1900, 'Khan Market', 50);
INSERT INTO subscription VALUES (120, 950, 'Khan Market', 50);
INSERT INTO subscription VALUES (121, 700, 'Siri Fort', 50);
INSERT INTO subscription VALUES (122, 1900, 'IC Colony', 150);
INSERT INTO subscription VALUES (123, 2200, 'Huzefa Nagar', 250);
INSERT INTO subscription VALUES (124, 850, 'Juhu', 75);
INSERT INTO subscription VALUES (125, 1850, 'Ameerpet', 200);
INSERT INTO subscription VALUES (126, 1900, 'Nampally', 200);
INSERT INTO subscription VALUES (127, 1100, 'Sanath Nagar', 50);

CREATE TABLE cust_subscription
(
c_id NUMBER(10),
s_id NUMBER(5),
CONSTRAINT cust_cid FOREIGN KEY (c_id) REFERENCES cust_details (c_id),
CONSTRAINT cust_sid FOREIGN KEY (s_id) REFERENCES subscription (s_id)
);

INSERT INTO cust_subscription VALUES (10001,101);
INSERT INTO cust_subscription VALUES (10002,102);
INSERT INTO cust_subscription VALUES (10003,103);
INSERT INTO cust_subscription VALUES (10004,104);
INSERT INTO cust_subscription VALUES (10005,105);
INSERT INTO cust_subscription VALUES (10006,106);
INSERT INTO cust_subscription VALUES (10007,107);
INSERT INTO cust_subscription VALUES (10008,108);
INSERT INTO cust_subscription VALUES (10009,109);
INSERT INTO cust_subscription VALUES (10010,110);
INSERT INTO cust_subscription VALUES (10011,111);
INSERT INTO cust_subscription VALUES (10012,112);

CREATE TABLE user_login
(
c_id NUMBER(10) NOT NULL,
user_id VARCHAR2(10) UNIQUE,
password VARCHAR2(20) NOT NULL,
CONSTRAINT user_cid FOREIGN KEY (c_id) REFERENCES cust_details (c_id)
);

INSERT INTO user_login VALUES (10001, 'asdf123', '12345');
INSERT INTO user_login VALUES (10002, 'hgjm125', '12345');
INSERT INTO user_login VALUES (10003, 'hrthrt126', '12345');
INSERT INTO user_login VALUES (10004, 'QWEW127', '12345');
INSERT INTO user_login VALUES (10005, 'fef7128', '12345');
INSERT INTO user_login VALUES (10006, 'jgfvhyr129', '12345');
INSERT INTO user_login VALUES (10007, 'trhyhty130', '12345');
INSERT INTO user_login VALUES (10008, 'hgjm131', '12345');
INSERT INTO user_login VALUES (10009, 'hgjm132', '12345');
INSERT INTO user_login VALUES (10010, 'hgjm133', '12345');
INSERT INTO user_login VALUES (10011, 'hgjm134', '12345');
INSERT INTO user_login VALUES (10012, 'hgjm135', '12345');

CREATE TABLE bill 
(
c_id NUMBER(10) NOT NULL,
bill_no NUMBER(10) UNIQUE,
month VARCHAR2(10) NOT NULL,
status VARCHAR2(10),
s_id VARCHAR2(5) NOT NULL,
CONSTRAINT bill_cid FOREIGN KEY (c_id) REFERENCES cust_details (c_id),
CONSTRAINT bill_sid FOREIGN KEY (s_id) REFERENCES subscription (s_id)
);

CREATE TABLE transaction_details
(
t_id NUMBER(10) UNIQUE,
bill_no NUMBER(10) NOT NULL,
doi DATE NOT NULL,
amt_paid NUMBER(5),
CONSTRAINT transaction_billno FOREIGN KEY (bill_no) REFERENCES bill (bill_no)
);
