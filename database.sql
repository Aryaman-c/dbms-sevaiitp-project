-- Create the database
CREATE DATABASE IF NOT EXISTS donation_db;
USE donation_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user'
);

-- Create blood_donation_camps table
CREATE TABLE IF NOT EXISTS blood_donation_camps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    required_blood_groups VARCHAR(50) NOT NULL,
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- Create blood_donation_requests table
CREATE TABLE IF NOT EXISTS blood_donation_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    hospital_name VARCHAR(255) NOT NULL,
    hospital_address TEXT NOT NULL,
    required_blood_group VARCHAR(3) NOT NULL,
    units_required INT NOT NULL,
    urgency_level ENUM('urgent', 'normal') NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    additional_notes TEXT,
    request_date DATE NOT NULL,
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Create blood_donations table
CREATE TABLE IF NOT EXISTS blood_donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    camp_id INT,
    request_id INT,
    blood_group VARCHAR(3) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (camp_id) REFERENCES blood_donation_camps(id),
    FOREIGN KEY (request_id) REFERENCES blood_donation_requests(id)
);

-- Create fundraising_campaigns table
CREATE TABLE IF NOT EXISTS fundraising_campaigns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    goal_amount DECIMAL(10,2) NOT NULL,
    current_amount DECIMAL(10,2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    category ENUM('medical', 'education', 'disaster', 'social', 'other') NOT NULL,
    image_url VARCHAR(255),
    organizer_id INT,
    status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
    FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- Create fundraising_donations table
CREATE TABLE IF NOT EXISTS fundraising_donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    campaign_id INT,
    amount DECIMAL(10,2) NOT NULL,
    donation_date DATE NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'upi', 'net_banking') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    transaction_id VARCHAR(100),
    anonymous BOOLEAN DEFAULT FALSE,
    message TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (campaign_id) REFERENCES fundraising_campaigns(id)
);

-- Create item_donation_campaigns table
CREATE TABLE IF NOT EXISTS item_donation_campaigns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    category ENUM('clothing', 'food', 'books', 'toys', 'furniture', 'electronics', 'other') NOT NULL,
    organizer_id INT,
    FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- Create item_donations table
CREATE TABLE IF NOT EXISTS item_donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    campaign_id INT,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    `condition` ENUM('new', 'like_new', 'good', 'fair', 'poor') NOT NULL,
    description TEXT,
    donation_date DATE NOT NULL,
    collection_address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (campaign_id) REFERENCES item_donation_campaigns(id)
);


-- Insert sample data

INSERT INTO users (username, password, email, full_name, phone, role) VALUES
('admin', 'admin123', 'admin@donation.com', 'Admin User', '1234567890', 'admin'),
('john_doe', 'john123', 'john@example.com', 'John Doe', '9876543210', 'user'),
('jane_smith', 'jane123', 'jane@example.com', 'Jane Smith', '8765432109', 'user');



INSERT INTO blood_donation_camps (title, description, location, date, start_time, end_time, required_blood_groups, organizer_id) VALUES
('Blood Donation Drive - City Hospital', 'Annual blood donation drive at City Hospital', 'City Hospital, Main Street', '2025-08-25', '09:00:00', '17:00:00', 'A+,B+,O+,AB+', 1),
('Emergency Blood Camp', 'Emergency blood donation camp for accident victims', 'Red Cross Center, Park Avenue', '2025-08-20', '10:00:00', '16:00:00', 'A-,B-,O-,AB-', 1);


INSERT INTO blood_donation_requests (patient_name, hospital_name, hospital_address, required_blood_group, units_required, urgency_level, contact_person, contact_number, additional_notes, request_date, created_by) VALUES
('Robert Wilson', 'City General Hospital', '123 Hospital Road', 'B+', 2, 'urgent', 'Dr. Sarah Brown', '9876543210', 'Patient needs immediate surgery', '2025-08-21', 1),
('Maria Garcia', 'St. Mary Hospital', '456 Medical Center', 'O-', 3, 'normal', 'Nurse John Smith', '8765432109', 'Regular blood transfusion required', '2025-08-22', 2);


INSERT INTO fundraising_campaigns (title, description, goal_amount, current_amount, start_date, end_date, category, organizer_id) VALUES
('Help Build a School', 'We are raising funds to build a primary school in a rural area.', 500000.00, 150000.00, '2025-08-20', '2025-11-01', 'education', 1),
('Medical Treatment Fund', 'Support cancer treatment for underprivileged patients.', 300000.00, 75000.00, '2025-08-21', '2025-10-01', 'medical', 2);


INSERT INTO fundraising_donations (user_id, campaign_id, amount, donation_date, payment_method, payment_status, transaction_id, anonymous, message) VALUES
(2, 1, 5000.00, '2025-09-10', 'credit_card', 'completed', 'TXN123456', FALSE, 'Happy to help!'),
(3, 1, 3000.00, '2025-09-11', 'upi', 'completed', 'TXN123457', TRUE, 'Best wishes'),
(2, 2, 2000.00, '2025-09-12', 'net_banking', 'completed', 'TXN123458', FALSE, 'Get well soon');


INSERT INTO item_donation_campaigns (title, description, location, start_date, end_date, category, organizer_id) VALUES
('Winter Clothing Drive', 'Collecting warm clothes for the homeless', 'Community Center, Downtown', '2025-09-01', '2025-09-30', 'clothing', 1),
('School Supplies Collection', 'Gathering school supplies for underprivileged children', 'City Library, Main Branch', '2025-09-15', '2025-09-15', 'books', 2);

INSERT INTO item_donations (user_id, campaign_id, item_name, quantity, `condition`, description, donation_date, collection_address) VALUES
(2, 1, 'Winter Jackets', 5, 'good', 'Gently used winter jackets in various sizes', '2025-09-05', '123 Main St, Apt 4B'),
(3, 1, 'Blankets', 3, 'new', 'New fleece blankets', '2025-09-06', '456 Park Ave'),
(2, 2, 'Textbooks', 10, 'good', 'High school textbooks', '2025-09-16', '123 Main St, Apt 4B');