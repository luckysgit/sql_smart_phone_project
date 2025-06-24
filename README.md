# sql_smart_phone_project
# 📱 Smart Phone Data Analysis

This project provides SQL-based data cleaning and exploratory analysis on a smartphone specifications dataset. It is designed for data engineering or data analytics learners who want hands-on experience with querying real-world structured data.

---
## Dataset
https://www.kaggle.com/datasets/chaudharisanika/smartphones-dataset/data

---
## 📂 Project Structure

- `SmartPhone_Documentation.docx` - A Word document containing:
  - ER Diagram (text-based)
  - SQL queries for data cleaning
  - SQL queries for data exploration
- `SmartPhone_Documentation.pdf` *(optional)* - Same content as the DOCX, in PDF format for quick reference.
- `README.md` - Documentation for project overview and usage.

---

## 🧱 ER Diagram

The dataset contains one main table: `smart_phone`. It includes attributes such as:

- **Brand & Model**: `brand_name`, `model`
- **Performance**: `processor_brand`, `processor_speed`, `num_cores`, `ram_capacity`
- **Camera**: `primary_camera_rear`, `primary_camera_front`, `num_rear_cameras`, `num_front_cameras`
- **Features**: `has_5g`, `has_nfc`, `has_ir_blaster`, `fast_charging_available`
- **Display & Battery**: `screen_size`, `refresh_rate`, `battery_capacity`, `fast_charging`
- **Storage**: `internal_memory`, `extended_memory_available`, `extended_upto`
- **Resolution**: `resolution_width`, `resolution_height`
- **OS**: `os`
- **Other**: `price`, `rating`

---

## 🧹 Data Cleaning Queries

Includes SQL queries to:
- Count total records
- Identify NULL values across all fields
- Prepare data for analysis by validating key fields

---

## 📊 Data Exploration Queries

Explore various aspects of the smartphone data:
- Brand diversity and uniqueness
- Price filters and high-end models
- Feature-based filtering (e.g., NFC + 5G + IR Blaster)
- Ranking by processor speed
- Fast charging support analysis
- Model counts per brand and processor

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/luckysgit/smart-phone-analysis.git
   cd smart-phone-analysis
