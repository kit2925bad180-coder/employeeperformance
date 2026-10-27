# Employee Performance Management System (EPMS)

> **College Java Project** built with **Java 21**, **Spring Boot 3**, **Spring JDBC (JdbcTemplate)**, **MySQL**, **ArrayList**, **HashMap**, and a clean **Single Page Application Dashboard (HTML/CSS/JS)**.

---

## 1. Project Description

The **Employee Performance Management System (EPMS)** is a web-based management information system designed to track employee records, monitor assigned tasks, record qualitative and quantitative performance reviews, and generate automated monthly performance reports.

The project is built specifically to demonstrate **fundamental Java Software Engineering principles** and **Java Collections Framework (ArrayList, HashMap)** alongside database interaction using **Spring JdbcTemplate** with parameterized SQL queries—completely avoiding complex ORM frameworks like JPA/Hibernate so that every query is explicit, transparent, and easy to explain in a viva examination.

---

## 2. Technologies Used

- **Backend Language:** Java 21 (LTS)
- **Framework:** Spring Boot 3.3.4 (REST API, Dependency Injection)
- **Data Access:** Spring JDBC / `JdbcTemplate` (RowMapper, Parameterized Queries)
- **Database:** MySQL 8+ / 9+ (`employee_performance_db`)
- **Core Collections:** `java.util.ArrayList`, `java.util.HashMap`
- **Build Tool:** Apache Maven 3.9+
- **Frontend:** Modern Single Page Application (HTML5, Vanilla CSS3, JavaScript ES6 `fetch()`)
- **Testing:** JUnit 5, Spring Boot Test, H2 In-Memory DB (for unit/integration testing)

> **IMPORTANT ARCHITECTURAL NOTE:**  
> This project **DOES NOT USE JPA, Hibernate, EntityManager, or JpaRepository**.  
> All database access is implemented strictly using **Spring JdbcTemplate** and SQL parameterized queries to protect against SQL Injection.

---

## 3. Features & Modules

### 🔐 Module 0: Manager Authentication (Login & Logout)
- **First Page Display:** When opening the system (`http://localhost:8080`), the Manager Login screen opens first.
- **Session-Based Client Authentication:** No Spring Security overhead or unnecessary database tables required.
- **Demo Credentials:**
  - **Username:** `manager`
  - **Password:** `manager123`
- **Validation:**
  - Correct credentials unlock the administrative dashboard.
  - Incorrect credentials display a clear inline alert: *"Invalid username or password."*
- **Logout Action:** A prominent **Logout** button on the dashboard top bar and sidebar safely clears the session and returns to the login screen.

### 👤 Module 1: Employee Management
- **Add Employee:** Create a new employee with Name, Department, Designation, and unique Email.
- **View All Employees:** List all employees with their department, designation, and calculated average performance score.
- **Find Employee by ID:** Quick retrieval of employee details.
- **Update Employee:** Modify employee details.
- **Delete Employee:** Delete employee (cascades to tasks and performance entries).
- **Employee HashMap Lookup:** Maps `employee_id` &rarr; `Employee` for $O(1)$ constant-time lookup.

### 📋 Module 2: Task Management
- **Add Task:** Assign a task to an employee with task name, status, assigned date, and optional completion date.
- **Task Statuses Supported:**
  - `Pending` (⏳ Awaiting action)
  - `In Progress` (⚙️ Currently being worked on)
  - `Completed` (✅ Finished; automatically stamps completion date)
- **View All Tasks / Filter:** View all tasks, filter by Status or Employee.
- **Update Task & Quick Status Switch:** Switch statuses directly from table dropdown or full edit modal.
- **Delete Task:** Remove task records.

### ⭐ Module 3: Performance Management
- **Add Performance Entry:** Log performance score (scale 0.0 to 10.0), supervisor feedback comments, and review date.
- **View All Performance Reviews:** Chronological history of evaluations with score indicators.
- **Filter by Employee:** Review historical appraisals per employee.
- **Average Performance Score HashMap:** Computes average score per employee using `HashMap<Integer, Double>`.

### 📈 Module 4: Monthly Performance Report & Dashboard
- **Monthly Report Generation:** Select employee and month (e.g. `2026-09`) to generate:
  - Employee profile & contact info
  - Total tasks assigned in the month
  - Completed tasks count & completion rate percentage (%)
  - Pending / In Progress workload count
  - Average performance score for the month
  - Automated qualitative assessment summary (e.g., *"Outstanding Performer"*, *"Commendable"*, *"Needs Improvement"*)
  - Full breakdown tables of tasks and reviews in that month
  - **Print / PDF Export:** Formatted layout ready for printing or saving as PDF
- **Executive Dashboard:** Live cards showing total employees, total tasks, completed tasks, active work items, and overall score averages.

---

## 4. Database Setup

### Step 1: Create Database in MySQL
Log in to MySQL using MySQL Workbench, Command Line, or phpMyAdmin:
```sql
CREATE DATABASE IF NOT EXISTS employee_performance_db;
USE employee_performance_db;
```

### Step 2: Configure Database Credentials
Open `src/main/resources/application.properties` and update your username and password:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/employee_performance_db?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

### Step 3: Automatic Schema & Data Initialization
The application automatically executes `src/main/resources/schema.sql` on startup (`spring.sql.init.mode=always`), creating all tables and seeding realistic initial sample data.

If you prefer to run it manually in MySQL:
```sql
-- 1. Employees Table
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    designation VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

-- 2. Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    task_name VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    assigned_date DATE NOT NULL,
    completion_date DATE DEFAULT NULL,
    CONSTRAINT fk_tasks_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 3. Performance Table
CREATE TABLE IF NOT EXISTS performance (
    performance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    performance_score DOUBLE NOT NULL,
    comments TEXT,
    review_date DATE NOT NULL,
    CONSTRAINT fk_performance_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id) ON DELETE CASCADE
);
```

---

## 5. How to Run

### Option A: Using Maven Wrapper (Included)
In your terminal (PowerShell or Command Prompt) from the project root directory:
```powershell
.\mvnw.cmd spring-boot:run
```

### Option B: Using Installed Maven
```bash
mvn spring-boot:run
```

### Accessing the Application:
- **Frontend Dashboard:** [http://localhost:8080](http://localhost:8080)
- **API Base URL:** [http://localhost:8080/api](http://localhost:8080/api)

---

## 6. REST API Endpoints

### 👥 Employees (`/api/employees`)
| Method | Endpoint | Description | Return Type |
|---|---|---|---|
| `GET` | `/api/employees` | View all employees | `ArrayList<Employee>` |
| `GET` | `/api/employees/{id}` | Find employee by ID | `Employee` |
| `POST` | `/api/employees` | Add a new employee | `Employee` (201 Created) |
| `PUT` | `/api/employees/{id}` | Update existing employee | `Employee` |
| `DELETE` | `/api/employees/{id}` | Delete employee | `Map<String, String>` |
| `GET` | `/api/employees/map` | Lookup map (`employee_id` &rarr; `Employee`) | `HashMap<Integer, Employee>` |

### 📋 Tasks (`/api/tasks`)
| Method | Endpoint | Description | Return Type |
|---|---|---|---|
| `GET` | `/api/tasks` | View all tasks | `ArrayList<Task>` |
| `GET` | `/api/tasks/{id}` | Find task by ID | `Task` |
| `GET` | `/api/tasks/employee/{employeeId}` | Find tasks by employee | `ArrayList<Task>` |
| `POST` | `/api/tasks` | Add a new task | `Task` (201 Created) |
| `PUT` | `/api/tasks/{id}` | Update task details | `Task` |
| `PATCH` | `/api/tasks/{id}/status` | Update task status | `Task` |
| `DELETE` | `/api/tasks/{id}` | Delete task | `Map<String, String>` |

### ⭐ Performance (`/api/performance`)
| Method | Endpoint | Description | Return Type |
|---|---|---|---|
| `GET` | `/api/performance` | View all performance evaluations | `ArrayList<Performance>` |
| `GET` | `/api/performance/{id}` | Find evaluation by ID | `Performance` |
| `GET` | `/api/performance/employee/{employeeId}` | Find evaluations by employee | `ArrayList<Performance>` |
| `POST` | `/api/performance` | Add performance evaluation | `Performance` (201 Created) |
| `GET` | `/api/performance/average-map` | Average scores map (`employee_id` &rarr; `avgScore`) | `HashMap<Integer, Double>` |
| `DELETE` | `/api/performance/{id}` | Delete evaluation | `Map<String, String>` |

### 📈 Reports (`/api/reports`)
| Method | Endpoint | Description | Return Type |
|---|---|---|---|
| `GET` | `/api/reports/monthly/{employeeId}/{month}` | Generate monthly report | `MonthlyReport` |
| `GET` | `/api/reports/dashboard` | Dashboard analytics | `HashMap<String, Object>` |
| `GET` | `/api/reports/all/{month}` | Generate reports for all employees | `ArrayList<MonthlyReport>` |

---

## 7. Where JDBC is Used

**Spring `JdbcTemplate`** is used across all DAO / Repository classes in `com.employee.employee_performance.repository`:

1. **`EmployeeRepository.java`**:
   - `INSERT`: Uses `jdbcTemplate.update(PreparedStatementCreator, KeyHolder)` with `Statement.RETURN_GENERATED_KEYS` to insert and capture the auto-generated `employee_id`.
   - `SELECT`: `jdbcTemplate.query("SELECT ... FROM employees WHERE employee_id = ?", employeeRowMapper, employeeId)` with `RowMapper<Employee>`.
   - `UPDATE`: `jdbcTemplate.update("UPDATE employees SET name=?, department=?, designation=?, email=? WHERE employee_id=?", ...)`.
   - `DELETE`: `jdbcTemplate.update("DELETE FROM employees WHERE employee_id = ?", employeeId)`.
2. **`TaskRepository.java`**:
   - Uses `jdbcTemplate.query(...)` with parameterized SQL queries joining `tasks` and `employees` to fetch employee names alongside tasks.
   - Status update: `jdbcTemplate.update("UPDATE tasks SET status = ?, completion_date = ? WHERE task_id = ?", ...)`
3. **`PerformanceRepository.java`**:
   - Uses parameterized `INSERT INTO performance ...` and `SELECT AVG(performance_score) ... WHERE employee_id = ?`.
4. **`ReportRepository.java`**:
   - Executes aggregation SQL queries (`COUNT(*)`, `AVG(performance_score)`) with parameterized `?` placeholders.

---

## 8. Where ArrayList is Used

The project explicitly uses **`java.util.ArrayList`** in model, repository, service, and controller layers:

1. **`ArrayList<Employee>`**:
   - `EmployeeRepository.findAll()` returns `new ArrayList<>(list)`.
   - `EmployeeService.getAllEmployees()` returns `ArrayList<Employee>`.
   - `EmployeeController.getAllEmployees()` returns `ResponseEntity<ArrayList<Employee>>`.
2. **`ArrayList<Task>`**:
   - `TaskRepository.findAll()`, `TaskRepository.findByEmployeeId(int empId)`, and `TaskRepository.findByEmployeeIdAndMonth(...)` return `ArrayList<Task>`.
   - Stored in `MonthlyReport.java` as `private ArrayList<Task> tasks`.
3. **`ArrayList<Performance>`**:
   - `PerformanceRepository.findAll()` and `findByEmployeeId(int empId)` return `ArrayList<Performance>`.
   - Stored in `MonthlyReport.java` as `private ArrayList<Performance> performanceReviews`.
4. **`ArrayList<MonthlyReport>`**:
   - `ReportService.generateAllMonthlyReports(String month)` returns `ArrayList<MonthlyReport>`.

---

## 9. Where HashMap is Used

The project prominently uses **`java.util.HashMap`** to demonstrate key-value hashing and metric aggregation:

1. **`HashMap<Integer, Employee>`** in `EmployeeService.getEmployeeMap()`:
   - **Key:** `employee_id` (`Integer`)
   - **Value:** `Employee` object
   - **Purpose:** Enables $O(1)$ constant-time lookup for employee details during batch processing and report synthesis without repeated SQL queries.
   - Exposed via: `GET /api/employees/map`.

2. **`HashMap<Integer, Double>`** in `PerformanceService.getAveragePerformanceScoreMap()`:
   - **Key:** `employee_id` (`Integer`)
   - **Value:** Calculated Average Performance Score (`Double`)
   - **Purpose:** Iterates through all review evaluations, accumulates sum and count per employee, and calculates the exact average score.
   - Exposed via: `GET /api/performance/average-map`.

3. **`HashMap<String, Object>`** in `ReportService.getDashboardStatistics()`:
   - **Key:** Statistic Name (`"totalEmployees"`, `"totalTasks"`, `"completedTasks"`, `"averagePerformanceScore"`, etc.)
   - **Value:** Computed metric value.
   - Exposed via: `GET /api/reports/dashboard`.

---

## 10. College Viva Q&A Guide

### Q1: What is the difference between JDBC and JPA/Hibernate? Why did you use JDBC?
> **Answer:**  
> JPA/Hibernate is an Object-Relational Mapping (ORM) framework that generates SQL queries automatically and manages entity lifecycles.  
> In this project, we specifically used **Spring JdbcTemplate (JDBC)** because it provides full transparency over SQL queries, eliminates ORM caching/lazy-loading overhead, and gives complete control over SQL execution using **parameterized queries** (`?`) to prevent SQL Injection.

### Q2: Why did you use `ArrayList`? What are its advantages?
> **Answer:**  
> `ArrayList` is a resizable-array implementation of the `List` interface in Java Collections Framework.  
> We used `ArrayList<Employee>`, `ArrayList<Task>`, and `ArrayList<Performance>` because:
> 1. It provides fast $O(1)$ random access by index.
> 2. It dynamically grows as database records are fetched.
> 3. It maintains insertion order, which preserves the SQL `ORDER BY` sorting.

### Q3: Why did you use `HashMap`? Where is it implemented?
> **Answer:**  
> A `HashMap` stores data in key-value pairs using hashing, providing $O(1)$ average time complexity for `get()` and `put()` operations.  
> We implemented `HashMap` in two prominent places:
> 1. In `EmployeeService.getEmployeeMap()`: Maps `employee_id` &rarr; `Employee` object for instant profile lookup.
> 2. In `PerformanceService.getAveragePerformanceScoreMap()`: Maps `employee_id` &rarr; `averageScore` (`Double`), aggregating all review scores.
> This prevents inefficient $O(N)$ repeated loops and avoids executing redundant SQL JOIN queries.

### Q4: How do you prevent SQL Injection in your project?
> **Answer:**  
> We use **parameterized queries** with Spring's `JdbcTemplate` (using `?` placeholders or `PreparedStatement`). The database driver pre-compiles the SQL command and treats user inputs strictly as parameters, preventing malicious SQL code injection.

### Q5: How does the frontend communicate with the backend?
> **Answer:**  
> The frontend is a Single Page Application (SPA) built with HTML, CSS, and Vanilla JavaScript. It uses the asynchronous JavaScript `fetch()` API to make HTTP requests (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) to Spring Boot `@RestController` endpoints and dynamically updates the DOM without reloading the page.
