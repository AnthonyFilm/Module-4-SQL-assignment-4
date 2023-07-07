create or replace table customer (
	customer_id SERIAL primary key,
	customer_first varchar(100),
	customer_last varchar(100),
	customer_address varchar(150),
	customer_city varchar(100),
	customer_state char(2),
	customer_zip varchar(10),
	customer_email varchar(150),
	customer_phone varchar(15)
);

create table mechanic (
	mechanic_id SERIAL primary key,
	mechanic_first varchar(100),
	mechanic_last varchar(100),
	mechanic_address varchar(150),
	mechanic_city varchar(100),
	mechanic_state char(2),
	mechanic_zip varchar(10),
	mechanic_email varchar(150),
	mechanic_phone varchar(15)
);

create table salesperson (
	salesperson_id SERIAL primary key,
	salesperson_first varchar(100),
	salesperson_last varchar(100),
	salesperson_address varchar(150),
	salesperson_city varchar(100),
	salesperson_state char(2),
	salesperson_zip varchar(10),
	salesperson_email varchar(150),
	salesperson_phone varchar(15)
);

create table car (
	car_VIN	varchar(17) primary key,
	customer_id INTEGER,
	car_make varchar(100), 
	car_model varchar(100),
	car_year INTEGER,
	car_trim varchar(50),
	car_new boolean,
	car_sold boolean,
	foreign key(customer_id) references customer(customer_id)
);

create table carInvoice (
	carinvoice_id SERIAL primary key,
	carinvoice_sale_date TIMESTAMP default current_timestamp,
	customer_id INTEGER not null,
	salesperson_id INTEGER not null,
	car_VIN VARCHAR(17) not null,
	carinvoice_sale_price DECIMAL(9,2),
	foreign key(car_VIN) references car(car_VIN),
	foreign key(salesperson_id) references salesperson(salesperson_id),
	foreign key(customer_id) references customer(customer_id)
);

-- The serviceTicket table would reference the list of charges 
--- from the partscharges table  and services charges table 
-- in order to accomodate charges from multiple services and parts in a 
-- service ticket.

create table serviceTicket (
	serviceticket_id SERIAL primary key,
	service_date TIMESTAMP default current_timestamp,
	service_services_total DECIMAL(8,2),
	service_parts_total DECIMAL(8,2),
	service_total_charge DECIMAL(8,2)
);

create table part (
	part_id SERIAL primary key,
	part_name VARCHAR(150),
	part_price DECIMAL(8,2)
);
  
create table service (
	service_id SERIAL primary key,
	service_name VARCHAR(100),
  	service_price DECIMAL(8,2)
);

create table partCharge (
	partcharge_id SERIAL primary key,
	serviceticket_id INTEGER not null,
	part_id INTEGER not null,
	partcharge_quantity INTEGER,
	foreign key(serviceticket_id) references serviceTicket(serviceticket_id),
	foreign key(part_id) references part(part_id)
);

create table serviceCharge (
	servicecharge_id SERIAL primary key,
	service_id INTEGER not null,
	serviceticket_id INTEGER not null,
	foreign key(serviceticket_id) references serviceTicket(serviceticket_id),
	foreign key(service_id) references service(service_id)
);

create table mechanicWork (
	mechanic_work_id SERIAL primary key,
	mechanic_id INTEGER not null,
	servicecharge_id INTEGER not null,
	foreign key(servicecharge_id) references serviceCharge(servicecharge_id),
	foreign key(mechanic_id) references mechanic(mechanic_id)
);

CREATE OR REPLACE FUNCTION add_customer(cus_first VARCHAR(100),cus_last VARCHAR(100), cus_address VARCHAR(150), cus_city VARCHAR(100), cus_state VARCHAR(2), cus_zip VARCHAR(10), cus_email VARCHAR(150), cus_phone VARCHAR)
RETURNS void 
AS $MAIN$
BEGIN
	INSERT INTO customer(customer_first, customer_last, customer_address, customer_city, customer_state, customer_zip, customer_email, customer_phone)
	VALUES(cus_first, cus_last, cus_address, cus_city, cus_state, cus_zip, cus_email, cus_phone);
END;
$MAIN$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_salesperson(sales_first VARCHAR(100), sales_last VARCHAR(100))
RETURNS void 
AS $MAIN$
BEGIN
	INSERT INTO salesperson(salesperson_first, salesperson_last )
	VALUES(sales_first, sales_last);
END;
$MAIN$
LANGUAGE plpgsql;

select add_customer('Happy', 'Gilmore', '123 Heppy Street', 'Martinsville', 'FL', '34234', 'email@email.com', '941-222-2222');
select add_customer('Everey', 'Mastery', '123 Milk Street', 'Hapers Ferry', 'FL', '33212', 'email2@email.com', '941-222-2223');
select * from customer c 

select add_salesperson('Happy', 'Gilmore');
select add_salesperson('Depressed', 'Worker');
select * from salesperson s

insert into car(car_vin, customer_id, car_make, car_model, car_year)
values('ERBER12324234', 1, 'Honda', 'Accord', 2024);

insert into car(car_vin, customer_id, car_make, car_model, car_year)
values('ERBER12324232', 2, 'Toyota', 'Carolla', 2024);
select * from car

insert into carinvoice(customer_id, salesperson_id, car_vin, carinvoice_sale_price) 
values(1, 1, 'ERBER12324234', 20000);

insert into carinvoice(customer_id, salesperson_id, car_vin, carinvoice_sale_price) 
values(2, 2, 'ERBER12324232', 30000);

select * from carinvoice c 


insert into mechanic(mechanic_first, mechanic_last, mechanic_email)
values('Roberta', 'Smith', 'smith@amail.com');

insert into mechanic(mechanic_first, mechanic_last, mechanic_email)
values('Albert', 'Assenator', 'assenator@amail.com');

select * from mechanic m 

insert into part(part_name, part_price)
values('alternator', 50.25);

insert into part(part_name, part_price)
values('light bulb', 25.50);

insert into serviceticket(service_services_total, service_parts_total, service_total_charge)
values(23.00, 40.00, 63.00);

insert into serviceticket(service_services_total, service_parts_total, service_total_charge)
values(50.00, 40.00, 90.00);

select * from serviceticket s 

insert into service(service_name, service_price)
values('oil change', 23.00);

insert into service(service_name, service_price)
values('alignment', 50.00);

insert into servicecharge(service_id, serviceticket_id) 
values(1, 1);

insert into servicecharge(service_id, serviceticket_id) 
values(2, 2);

insert into mechanicwork(mechanic_id, servicecharge_id) 
values(1, 1);

insert into mechanicwork(mechanic_id, servicecharge_id) 
values(2, 1);

insert into partcharge(serviceticket_id, part_id, partcharge_quantity) 
values(1, 1, 1);

insert into partcharge(serviceticket_id, part_id, partcharge_quantity) 
values(1, 2, 1);



  