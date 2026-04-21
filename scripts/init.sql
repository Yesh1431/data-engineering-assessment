create schema if not exists raw;

drop table if exists raw.shopify_customers_file;
create table raw.shopify_customers_file (
    "ID" text,
    "EMAIL" text,
    "FIRST_NAME" text,
    "LAST_NAME" text,
    "CREATED_AT" text,
    "UPDATED_AT" text,
    "ORDERS_COUNT" integer,
    "STATE" text,
    "TOTAL_SPENT" numeric,
    "VERIFIED_EMAIL" boolean,
    "TAGS" text,
    "_AIRBYTE_RAW_ID" text,
    "_AIRBYTE_EXTRACTED_AT" timestamptz,
    "_AIRBYTE_META" jsonb,
    "_AIRBYTE_GENERATION_ID" bigint
);

drop table if exists raw.shopify_products_file;
create table raw.shopify_products_file (
    "ID" text,
    "TITLE" text,
    "VENDOR" text,
    "PRODUCT_TYPE" text,
    "TAGS" text,
    "STATUS" text,
    "CREATED_AT" bigint,
    "_PORTABLE_EXTRACTED" text,
    "ADMIN_GRAPHQL_API_ID" text,
    "_AIRBYTE_RAW_ID" text,
    "_AIRBYTE_EXTRACTED_AT" timestamptz,
    "_AIRBYTE_META" jsonb,
    "_AIRBYTE_GENERATION_ID" bigint,
    "APP_ID" text,
    "OPTIONS" jsonb,
    "VARIANTS" jsonb
);

drop table if exists raw.shopify_orders_file;
create table raw.shopify_orders_file (
    "ID" text,
    "CUSTOMER_ID" text,
    "EMAIL" text,
    "CREATED_AT" text,
    "UPDATED_AT" text,
    "CANCELLED_AT" text,
    "CLOSED_AT" text,
    "PROCESSED_AT" text,
    "CURRENCY" text,
    "FINANCIAL_STATUS" text,
    "FULFILLMENT_STATUS" text,
    "TOTAL_PRICE" numeric,
    "SUBTOTAL_PRICE" numeric,
    "TOTAL_TAX" numeric,
    "TOTAL_DISCOUNTS" numeric,
    "ORDER_NUMBER" integer,
    "NAME" text,
    "TAGS" text,
    "_AIRBYTE_RAW_ID" text,
    "_AIRBYTE_EXTRACTED_AT" timestamptz,
    "_AIRBYTE_META" jsonb,
    "_AIRBYTE_GENERATION_ID" bigint,
    "CUSTOMER" jsonb,
    "LINE_ITEMS" jsonb
);

insert into raw.shopify_customers_file (
    "ID","EMAIL","FIRST_NAME","LAST_NAME","CREATED_AT","UPDATED_AT",
    "ORDERS_COUNT","STATE","TOTAL_SPENT","VERIFIED_EMAIL","TAGS",
    "_AIRBYTE_RAW_ID","_AIRBYTE_EXTRACTED_AT","_AIRBYTE_META","_AIRBYTE_GENERATION_ID"
) values
('CUST_1001','john@example.com','John','Doe','2025-01-01T10:00:00','2025-01-10T10:00:00',5,'enabled',250.50,true,'vip','raw1',now(),'{}',1),
('CUST_1002','jane@example.com','Jane','Smith','2025-02-01T10:00:00','2025-02-10T10:00:00',2,'disabled',99.99,false,'new','raw2',now(),'{}',1);

insert into raw.shopify_products_file (
    "ID","TITLE","VENDOR","PRODUCT_TYPE","TAGS","STATUS","CREATED_AT",
    "_PORTABLE_EXTRACTED","ADMIN_GRAPHQL_API_ID","_AIRBYTE_RAW_ID",
    "_AIRBYTE_EXTRACTED_AT","_AIRBYTE_META","_AIRBYTE_GENERATION_ID",
    "APP_ID","OPTIONS","VARIANTS"
) values
(
  'PROD_3000','Socks','Umbrella Co','Home','limited, gift','active',1682865451,
  '2025-09-10T14:37:31.213498','gid://shopify/Product/PROD_3000','raw3',
  now(),'{}',1,'app_123','[]'::jsonb,'[]'::jsonb
),
(
  'PROD_3001','T-Shirt','Umbrella Co','Apparel','summer','active',1682865452,
  '2025-09-10T14:37:31.213498','gid://shopify/Product/PROD_3001','raw4',
  now(),'{}',1,'app_123','[]'::jsonb,'[]'::jsonb
);

insert into raw.shopify_orders_file (
    "ID","CUSTOMER_ID","EMAIL","CREATED_AT","UPDATED_AT","CANCELLED_AT","CLOSED_AT","PROCESSED_AT",
    "CURRENCY","FINANCIAL_STATUS","FULFILLMENT_STATUS","TOTAL_PRICE","SUBTOTAL_PRICE",
    "TOTAL_TAX","TOTAL_DISCOUNTS","ORDER_NUMBER","NAME","TAGS",
    "_AIRBYTE_RAW_ID","_AIRBYTE_EXTRACTED_AT","_AIRBYTE_META","_AIRBYTE_GENERATION_ID",
    "CUSTOMER","LINE_ITEMS"
) values
(
  'ORD_5000','CUST_1001','john@example.com','2025-03-01T12:00:00','2025-03-01T12:05:00',null,null,'2025-03-01T12:10:00',
  'USD','paid','fulfilled',120.00,100.00,20.00,0.00,5000,'#5000','vip',
  'raw5',now(),'{}',1,'{}'::jsonb,'[]'::jsonb
),
(
  'ORD_5001','CUST_1002','jane@example.com','2025-03-02T12:00:00','2025-03-02T12:05:00',null,null,'2025-03-02T12:10:00',
  'USD','pending','unfulfilled',80.00,70.00,10.00,0.00,5001,'#5001','new',
  'raw6',now(),'{}',1,'{}'::jsonb,'[]'::jsonb
);