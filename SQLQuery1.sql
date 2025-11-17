-- Create database
CREATE DATABASE electronics_inventory
USE electronics_inventory;

-- Create tables using SQL  

-- 1) USERS
-- Store only password hashes (bcrypt). Never store plaintext passwords.
-- role: start with 'admin' and 'clerk' (you can extend later).
CREATE TABLE IF NOT EXISTS users (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username      VARCHAR(50)     NOT NULL,
  password_hash VARCHAR(255)    NOT NULL,
  role          ENUM('admin','clerk') NOT NULL DEFAULT 'clerk',
  created_at    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY ux_users_username (username)
) ENGINE=InnoDB;

-- 2) ITEMS
-- Inventory master. current_stock is UNSIGNED to prevent negative values.
-- sku is unique; you can enforce a pattern at the app layer (e.g., EL-00001).
CREATE TABLE IF NOT EXISTS items (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku             VARCHAR(32)     NOT NULL,
  name            VARCHAR(120)    NOT NULL,
  brand           VARCHAR(80)     NULL,
  model           VARCHAR(80)     NULL,
  category        VARCHAR(80)     NULL,
  unit            ENUM('pcs','box','pack','kg','g','l','ml') NOT NULL DEFAULT 'pcs',
  warranty_months TINYINT UNSIGNED NULL,
  reorder_level   INT UNSIGNED    NOT NULL DEFAULT 0,
  current_stock   INT UNSIGNED    NOT NULL DEFAULT 0,
  created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY ux_items_sku (sku),
  KEY ix_items_name (name),
  KEY ix_items_category (category)
) ENGINE=InnoDB;

-- 3) TRANSACTIONS (immutable audit log)
-- type = IN (add to stock) or OUT (subtract).
-- qty UNSIGNED. Prevents negative movements at the row level;
-- the "no negative resulting stock" rule is enforced in Flask before insert.
CREATE TABLE IF NOT EXISTS transactions (
  id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  item_id    BIGINT UNSIGNED NOT NULL,
  user_id    BIGINT UNSIGNED NOT NULL,
  type       ENUM('IN','OUT') NOT NULL,
  qty        INT UNSIGNED     NOT NULL,
  note       VARCHAR(255)     NULL,
  created_at TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY ix_txn_item (item_id),
  KEY ix_txn_user (user_id),
  CONSTRAINT fk_txn_item FOREIGN KEY (item_id) REFERENCES items(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_txn_user FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;



/* NO NEED THIS FOR NOW...


-- 4) Seed data (optional for demo)
-- Replace this dummy bcrypt hash with a real one from your Flask app later.
-- It won't allow login until your app uses the same hashing (bcrypt) to verify.
INSERT INTO users (username, password_hash, role)
VALUES ('admin', '$2b$12$DUMMYDUMMYDUMMYDUMMYDUMMYDUMMYaYkz3vT4qR5o7bap4L9yKkJwZ2wE.', 'admin')
ON DUPLICATE KEY UPDATE username = VALUES(username);

INSERT INTO items (sku, name, brand, model, category, unit, warranty_months, reorder_level, current_stock)
VALUES
('EL-00001', 'HDMI Cable 1.5m', 'Generic', 'HDMI-1.5', 'Cables', 'pcs', 0, 10, 25),
('EL-00002', 'SSD 512GB',       'Samsung', '980',      'Storage','pcs',24,  5,  8)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ==========================================================
-- Notes / How to customize later:
-- • Add more roles: ALTER TABLE users MODIFY role ENUM('admin','clerk','manager') NOT NULL;
-- • Add units: ALTER TABLE items MODIFY unit ENUM('pcs','box','pack','kg','g','l','ml','m') NOT NULL;
-- • Add columns (e.g., location, supplier_id): ALTER TABLE items ADD COLUMN location VARCHAR(80);
-- • Change foreign key behavior: adjust ON DELETE/UPDATE rules above.
-- • Index more fields if search is slow (e.g., brand): CREATE INDEX ix_items_brand ON items(brand);
-- ==========================================================
*/