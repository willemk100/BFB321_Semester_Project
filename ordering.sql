
-- Enable foreign key constraints (important for integrity)
PRAGMA foreign_keys = ON;

-----------------------------------------------------
-- Table "user"
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS "user" (
  "user_id" INTEGER PRIMARY KEY,
  "username" VARCHAR(45) NOT NULL,
  "password" VARCHAR(45) NOT NULL,
  "student_number" VARCHAR(45) NULL,
  "name" VARCHAR(45) NOT NULL,
  "surname" VARCHAR(45) NOT NULL,
  "date_of_birth" TEXT NOT NULL,
  "cell_number" VARCHAR(45) NOT NULL,
  "email" VARCHAR(45) NOT NULL,
  "created_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "updated_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "user_type" TEXT NOT NULL CHECK("user_type" IN ('admin', 'user'))
);

-- Index on username (AK)
CREATE UNIQUE INDEX IF NOT EXISTS "idx_user_username" ON "user" ("username");

-----------------------------------------------------
-- Table "vendor"
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS "vendor" (
  "vendor_id" INTEGER PRIMARY KEY,
  "name" VARCHAR(45) NOT NULL,
  "location" VARCHAR(90) NOT NULL,
  "phone_number" VARCHAR(10) NOT NULL,
  "email" VARCHAR(90) NOT NULL,
  "password" VARCHAR(45) NOT NULL,
  "bank_name" VARCHAR(45) NULL,
  "account_number" VARCHAR(45) NULL,
  "branch_code" VARCHAR(45) NULL,
  "created_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "updated_at" TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Index on name (FK)
CREATE INDEX IF NOT EXISTS "idx_vendor_name" ON "vendor" ("name");

-----------------------------------------------------
-- Table "menuItem"
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS "menuItem" (
  "menuItem_id" INTEGER PRIMARY KEY,
  "vendor_id" INT NOT NULL,
  "catagory" VARCHAR(45) NOT NULL,
  "name" VARCHAR(45) NOT NULL,
  "price" NUMERIC(10,2) NOT NULL,
  "created_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "updated_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "cost" NUMERIC(10,2) NOT NULL,
  CONSTRAINT "fk_menuItem_vendor1"
    FOREIGN KEY ("vendor_id")
    REFERENCES "vendor" ("vendor_id")
);

-- Index on vendor_id (FK)
CREATE INDEX IF NOT EXISTS "fk_menuItem_vendor1_idx" ON "menuItem" ("vendor_id");

-----------------------------------------------------
-- Table "order" 
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS "order" (
  "order_id" INTEGER PRIMARY KEY,
  "user_id" INT NOT NULL,
  "order_date" TEXT NOT NULL DEFAULT (datetime('now')),
  "status" TEXT NOT NULL DEFAULT 'Submitted' CHECK("status" IN ('Submitted', 'Preparing', 'Ready', 'Collected', 'Not Collected')),
  "created_at" TEXT NOT NULL DEFAULT (datetime('now')),
  "updated_at" TEXT NOT NULL DEFAULT (datetime('now')),
  CONSTRAINT "fk_order_user1"
    FOREIGN KEY ("user_id")
    REFERENCES "user" ("user_id")
);

-- Index on user_id (FK
CREATE INDEX IF NOT EXISTS "fk_order_user1_idx" ON "order" ("user_id");

-----------------------------------------------------
-- Table "orderItem" 
-----------------------------------------------------
CREATE TABLE IF NOT EXISTS "orderItem" (
  "orderItem_id" INTEGER PRIMARY KEY,
  "order_order_id" INT NOT NULL,
  "menuItem_menuItem_id" INT NOT NULL,
  "quantity" INTEGER NOT NULL DEFAULT 1,
  "price_per_item" NUMERIC(10,2) NOT NULL,
  CONSTRAINT "fk_orderItem_order1"
    FOREIGN KEY ("order_order_id")
    REFERENCES "order" ("order_id"),
  CONSTRAINT "fk_orderItem_menuItem1"
    FOREIGN KEY ("menuItem_menuItem_id")
    REFERENCES "menuItem" ("menuItem_id")
);

-- Indexes for FKs
CREATE INDEX IF NOT EXISTS "fk_orderItem_order1_idx" ON "orderItem" ("order_order_id");
CREATE INDEX IF NOT EXISTS "fk_orderItem_menuItem1_idx" ON "orderItem" ("menuItem_menuItem_id");


-----------------------------------------------------
-- Triggers to make the updated_at field auto-update
-----------------------------------------------------

-- User Table Trigger
CREATE TRIGGER IF NOT EXISTS update_user_updated_at 
AFTER UPDATE ON "user"
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at 
BEGIN
    UPDATE "user" SET updated_at = datetime('now') WHERE user_id = NEW.user_id;
END;

-- Vendor Table Trigger
CREATE TRIGGER IF NOT EXISTS update_vendor_updated_at 
AFTER UPDATE ON "vendor"
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at 
BEGIN
    UPDATE "vendor" SET updated_at = datetime('now') WHERE vendor_id = NEW.vendor_id;
END;

-- MenuItem Table Trigger
CREATE TRIGGER IF NOT EXISTS update_menuitem_updated_at 
AFTER UPDATE ON "menuItem"
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at 
BEGIN
    UPDATE "menuItem" SET updated_at = datetime('now') WHERE menuItem_id = NEW.menuItem_id;
END;

-- Order Table Trigger
CREATE TRIGGER IF NOT EXISTS update_order_updated_at 
AFTER UPDATE ON "order"
FOR EACH ROW
WHEN NEW.updated_at = OLD.updated_at 
BEGIN
    UPDATE "order" SET updated_at = datetime('now') WHERE order_id = NEW.order_id;
END;

-----------------------------------------------------
-- Example Data - Based on TENZ restaurant and its menu.
-----------------------------------------------------


-- 1. "user"
INSERT INTO "user" ("user_id", "username", "password", "student_number", "name", "surname", "date_of_birth", "cell_number", "email", "user_type") VALUES
(1, 'willemk100', 'p@ssword1', 'u04868260', 'Willem', 'Kleynhans', '2004-03-17', '0812345678', 'willem@uni.com', 'admin'),
(2, 'jessM100', 'p@ssword2', 'u23232323', 'Jessica', 'Muller', '2000-11-20', '0729876543', 'jess@uni.com', 'user'),
(3, 'jmk200', 'p@ssword3', 'u01234566', 'Ayden', 'Bouwer', '2004-09-17', '081234567', 'AydenB@uni.com', 'user')
(4, 'saraH400', 'Pa$$w0rd4', 'u12345678', 'Sara', 'Hart', '2005-05-10', '0831112233', 'sara.h@uni.com', 'user'),
(5, 'mikeJ202', 'Pa$$w0rd5', 'u98765432', 'Michael', 'Johnson', '2000-12-01', '0719998877', 'mike.j@uni.com', 'user'),
(6, 'lindaP301', 'Pa$$w0rd6', 'u55544433', 'Linda', 'Peters', '2006-08-25', '0601239876', 'linda.p@uni.com', 'user'),
(7, 'chrisT112', 'Pa$$w0rd7', 'u10101010', 'Christopher', 'Taylor', '2002-04-15', '0725554433', 'chris.t@uni.com', 'user'),
(8, 'emilyB99', 'Pa$$w0rd8', 'u29292929', 'Emily', 'Brown', '2000-07-28', '0736667788', 'emily.b@uni.com', 'user'),
(9, 'davidL45', 'Pa$$w0rd9', 'u88877766', 'David', 'Lewis', '2004-01-05', '0613334455', 'david.l@uni.com', 'user'),
(10, 'amyC76', 'Pa$$w0rd10', 'u40404040', 'Amy', 'Clark', '2001-10-19', '0747778899', 'amy.c@uni.com', 'user'),
(11, 'ryanW23', 'Pa$$w0rd11', 'u67676767', 'Ryan', 'White', '2003-03-03', '0842221100', 'ryan.w@uni.com', 'user'),
(12, 'mariaG55', 'Pa$$w0rd12', 'u31313131', 'Maria', 'Green', '2002-09-12', '0624445566', 'maria.g@uni.com', 'user'),
(13, 'jamesF88', 'Pa$$w0rd13', 'u75757575', 'James', 'Ford', '2000-11-22', '0768889900', 'james.f@uni.com', 'user'),
(14, 'oliviaK14', 'Pa$$w0rd14', 'u91919191', 'Olivia', 'King', '2004-06-08', '0830001122', 'olivia.k@uni.com', 'user'),
(15, 'ethanR09', 'Pa$$w0rd15', 'u15151515', 'Ethan', 'Ross', '2006-02-14', '0795556677', 'ethan.r@uni.com', 'user'),
(16, 'sophiaM67', 'Pa$$w0rd16', 'u24242424', 'Sophia', 'Moore', '2003-12-30', '0607778899', 'sophia.m@uni.com', 'user'),
(17, 'nathanA33', 'Pa$$w0rd17', 'u82828282', 'Nathan', 'Adams', '2001-09-01', '0823334455', 'nathan.a@uni.com', 'user'),
(18, 'isabellaS19', 'Pa$$w0rd18', 'u46464646', 'Isabella', 'Scott', '2005-05-18', '0781112233', 'isabella.s@uni.com', 'user'),
(19, 'joshuaH70', 'Pa$$w0rd19', 'u60606060', 'Joshua', 'Hall', '2000-08-07', '0639990011', 'joshua.h@uni.com', 'user'),
(20, 'chloeD02', 'Pa$$w0rd20', 'u37373737', 'Chloe', 'Davis', '2004-02-28', '0720001122', 'chloe.d@uni.com', 'user'),
(21, 'samuelE58', 'Pa$$w0rd21', 'u73737373', 'Samuel', 'Evans', '2001-06-16', '0816667788', 'samuel.e@uni.com', 'user'),
(22, 'avaN41', 'Pa$$w0rd22', 'u95959595', 'Ava', 'Nelson', '2003-10-11', '0744445566', 'ava.n@uni.com', 'user'),
(23, 'danielP27', 'Pa$$w0rd23', 'u19191919', 'Daniel', 'Parker', '2006-04-24', '0848889900', 'daniel.p@uni.com', 'user'),
(24, 'graceR84', 'Pa$$w0rd24', 'u21212121', 'Grace', 'Rivera', '2002-11-06', '0612223344', 'grace.r@uni.com', 'user'),
(25, 'liamT62', 'Pa$$w0rd25', 'u80808080', 'Liam', 'Turner', '2004-07-03', '0765556677', 'liam.t@uni.com', 'user'),
(26, 'miaV17', 'Pa$$w0rd26', 'u48484848', 'Mia', 'Vargas', '2001-01-09', '0839990011', 'mia.v@uni.com', 'user'),
(27, 'noahZ50', 'Pa$$w0rd27', 'u64646464', 'Noah', 'Zimmerman', '2003-05-27', '0790001122', 'noah.z@uni.com', 'user'),
(28, 'aidenB93', 'Pa$$w0rd28', 'u30303030', 'Aiden', 'Baker', '2002-08-14', '0606667788', 'aiden.b@uni.com', 'user'),
(29, 'harperC36', 'Pa$$w0rd29', 'u77777777', 'Harper', 'Chen', '2000-03-09', '0821112233', 'harper.c@uni.com', 'user'),
(30, 'lucasD71', 'Pa$$w0rd30', 'u90909090', 'Lucas', 'Dixon', '2004-10-21', '0785556677', 'lucas.d@uni.com', 'user'),
(31, 'evelynF05', 'Pa$$w0rd31', 'u14141414', 'Evelyn', 'Fisher', '2001-04-01', '0630001122', 'evelyn.f@uni.com', 'user'),
(32, 'benjaminG49', 'Pa$$w0rd32', 'u25252525', 'Benjamin', 'Gibson', '2003-01-18', '0726667788', 'benjamin.g@uni.com', 'user'),
(33, 'charlotteH86', 'Pa$$w0rd33', 'u81818181', 'Charlotte', 'Hayes', '2002-06-23', '0810001122', 'charlotte.h@uni.com', 'user'),
(34, 'henryI22', 'Pa$$w0rd34', 'u47474747', 'Henry', 'Irvin', '2006-12-15', '0745556677', 'henry.i@uni.com', 'user'),
(35, 'ameliaJ68', 'Pa$$w0rd35', 'u65656565', 'Amelia', 'Jones', '2004-09-04', '0849990011', 'amelia.j@uni.com', 'user'),
(36, 'jacobK07', 'Pa$$w0rd36', 'u38383838', 'Jacob', 'Keller', '2001-03-29', '0621112233', 'jacob.k@uni.com', 'user'),
(37, 'abigailL43', 'Pa$$w0rd37', 'u72727272', 'Abigail', 'Lee', '2003-07-13', '0767778899', 'abigail.l@uni.com', 'user'),
(38, 'williamM89', 'Pa$$w0rd38', 'u94949494', 'William', 'Miller', '2000-05-02', '0832223344', 'william.m@uni.com', 'user'),
(39, 'elizabethN26', 'Pa$$w0rd39', 'u18181818', 'Elizabeth', 'Newman', '2004-11-29', '0794445566', 'elizabeth.n@uni.com', 'user'),
(40, 'alexanderO63', 'Pa$$w0rd40', 'u20202020', 'Alexander', 'Owen', '2001-08-11', '0608889900', 'alexander.o@uni.com', 'user'),
(41, 'averyP04', 'Pa$$w0rd41', 'u83838383', 'Avery', 'Perez', '2006-04-06', '0822223344', 'avery.p@uni.com', 'user'),
(42, 'sebastianQ40', 'Pa$$w0rd42', 'u45454545', 'Sebastian', 'Quinn', '2002-10-28', '0786667788', 'sebastian.q@uni.com', 'user'),
(43, 'scarlettR85', 'Pa$$w0rd43', 'u61616161', 'Scarlett', 'Ramirez', '2000-06-20', '0634445566', 'scarlett.r@uni.com', 'user'),
(44, 'johnS21', 'Pa$$w0rd44', 'u36363636', 'John', 'Schmidt', '2005-12-05', '0728889900', 'john.s@uni.com', 'user'),
(45, 'victoriaT67', 'Pa$$w0rd45', 'u70707070', 'Victoria', 'Thomas', '2001-02-17', '0813334455', 'victoria.t@uni.com', 'user'),
(46, 'leoU03', 'Pa$$w0rd46', 'u92929292', 'Leo', 'Underwood', '2003-09-26', '0741112233', 'leo.u@uni.com', 'user'),
(47, 'madisonV48', 'Pa$$w0rd47', 'u16161616', 'Madison', 'Vance', '2006-08-31', '0845556677', 'madison.v@uni.com', 'user'),
(48, 'gabrielW82', 'Pa$$w0rd48', 'u27272727', 'Gabriel', 'Wallace', '2004-05-13', '0619990011', 'gabriel.w@uni.com', 'user'),
(49, 'penelopeX13', 'Pa$$w0rd49', 'u84848484', 'Penelope', 'Xavier', '2001-11-04', '0760001122', 'penelope.x@uni.com', 'user'),
(50, 'jacksonY59', 'Pa$$w0rd50', 'u49494949', 'Jackson', 'Young', '2003-06-07', '0834445566', 'jackson.y@uni.com', 'user'),
(51, 'lilyZ00', 'Pa$$w0rd51', 'u66666666', 'Lily', 'Zane', '2002-03-25', '00698889900', 'lily.z@uni.com', 'user'),
(52, 'andrewA75', 'Pa$$w0rd52', 'u33333333', 'Andrew', 'Allen', '2000-10-10', '0602223344', 'andrew.a@uni.com', 'user'),
(53, 'zaraB11', 'Pa$$w0rd53', 'u78787878', 'Zara', 'Banda', '2004-01-30', '0827778899', 'zara.b@uni.com', 'user');

-- 2. "vendor"
INSERT INTO "vendor" ("vendor_id", "name", "location", "phone_number", "email", "password", "bank_name", "account_number", "branch_code") VALUES
(101, 'Tenz', 'University of Pretoria, Akanyang Building, 68 Lunnon Rd, Hatfield, Pretoria, 0028', '0662230306', 'tenz@up.com', 'tenzpassword', 'FNB', '62112233445', '250655');

-- 3. "menuItem"
INSERT INTO "menuItem" ("menuItem_id", "vendor_id", "catagory", "name", "price", "cost") VALUES
(1001, 101, 'Tramezini', 'Cheese & Tomato', 43.90, 25.00),
(1002, 101, 'Tramezini', 'Bacon & Cheese', 51.90, 26.90),
(1003, 101, 'Wrap', 'Tika Chicken Roti', 52.90, 30.00),
(1004, 101, 'Wrap', 'Hallomi & Mediteranean', 52.90, 30.00),
(1005, 101, 'Classic Shakes', 'Lime', 32.50, 15.00),
(1006, 101, 'Classic Shakes', 'Chocolate', 32.50, 15.00),
(1007, 101, 'Tramezini', 'Bacon & Avo', 59.90, 32.90),
(1008, 101, 'Tramezini', 'Rib & Mozzerella', 63.90, 26.90),
(1009, 101, 'Tramezini', 'Chicken, Bacon & Cheese', 59.90, 39.90),
(1010, 101, 'Burgers', 'Beef', 34.90, 26.90),
(1011, 101, 'Burgers', 'Chicken', 34.90, 26.90),
(1012, 101, 'Burgers', 'Rib', 34.90, 26.90)
(1013, 101, 'Fries', 'Small', 15.00, 10.00),
(1014, 101, 'Fries', 'Medium', 20.00, 12.00),
(1015, 101, 'Fries', 'Large', 25.00, 15.00);

-- 4. "order"
INSERT INTO "order" ("order_id", "user_id", "status") VALUES
(1001, 2, 'Collected'), 
(1002, 2, 'Submitted');

-- 5. "orderItem" 
INSERT INTO "orderItem" ("order_order_id", "menuItem_menuItem_id", "quantity", "price_per_item") VALUES
(1001, 1001, 1, 43.90),
(1001, 1005, 2, 32.50),
(1002, 1003, 1, 52.90);

