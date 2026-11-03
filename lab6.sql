-- Setup
CREATE TABLE employees (emp_id INT PRIMARY KEY, emp_name VARCHAR(50), dept_id INT, salary DECIMAL(10,2));
CREATE TABLE departments (dept_id INT PRIMARY KEY, dept_name VARCHAR(50), location VARCHAR(50));
CREATE TABLE projects (project_id INT PRIMARY KEY, project_name VARCHAR(50), dept_id INT, budget DECIMAL(10,2));

INSERT INTO employees VALUES
(1,'John Smith',101,50000),(2,'Jane Doe',102,60000),(3,'Mike Johnson',101,55000),
(4,'Sarah Williams',103,65000),(5,'Tom Brown',NULL,45000);
INSERT INTO departments VALUES
(101,'IT','Building A'),(102,'HR','Building B'),(103,'Finance','Building C'),(104,'Marketing','Building D');
INSERT INTO projects VALUES
(1,'Website Redesign',101,100000),(2,'Employee Training',102,50000),(3,'Budget Analysis',103,75000),
(4,'Cloud Migration',101,150000),(5,'AI Research',NULL,200000);

-- 2.1
SELECT e.emp_name, d.dept_name FROM employees e CROSS JOIN departments d;
-- 2.2 a
SELECT e.emp_name, d.dept_name FROM employees e, departments d;
-- 2.2 b
SELECT e.emp_name, d.dept_name FROM employees e INNER JOIN departments d ON TRUE;
-- 2.3
SELECT e.emp_name, p.project_name FROM employees e CROSS JOIN projects p;

-- 3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id;
-- 3.2
SELECT emp_name, dept_name, location FROM employees INNER JOIN departments USING (dept_id);
-- 3.3
SELECT emp_name, dept_name, location FROM employees NATURAL INNER JOIN departments;
-- 3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;

-- 4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id;
-- 4.2
SELECT emp_name, dept_id, dept_name FROM employees LEFT JOIN departments USING (dept_id);
-- 4.3
SELECT e.emp_name, e.dept_id
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
-- 4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;

-- 5.1
SELECT e.emp_name, d.dept_name
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
-- 5.2
SELECT e.emp_name, d.dept_name
FROM departments d LEFT JOIN employees e ON e.dept_id = d.dept_id;
-- 5.3
SELECT d.dept_name, d.location
FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

-- 6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e FULL JOIN departments d ON e.dept_id = d.dept_id;
-- 6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d FULL JOIN projects p ON d.dept_id = p.dept_id;
-- 6.3
SELECT CASE WHEN e.emp_id IS NULL THEN 'Department without employees'
            WHEN d.dept_id IS NULL THEN 'Employee without department'
            ELSE 'Matched' END AS record_status,
       e.emp_name, d.dept_name
FROM employees e FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

-- 7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';
-- 7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
-- 7.3 (ON)
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';
-- 7.3 (WHERE)
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

-- 8.1
SELECT d.dept_name, e.emp_name, e.salary, p.project_name, p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;
-- 8.2
ALTER TABLE employees ADD COLUMN manager_id INT;
UPDATE employees SET manager_id = 3 WHERE emp_id IN (1,2,4,5);
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e LEFT JOIN employees m ON e.manager_id = m.emp_id;
-- 8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;

-- Lab Questions
-- 1. INNER: только совпадения; LEFT: все строки левой таблицы + совпадения справа (иначе NULL)
-- 2. Все комбинации: расписания, матрицы доступности, варианты товаров (размер x цвет)
-- 3. В outer join WHERE удаляет NULL-строки после join, ON - нет; в inner join разницы нет
-- 4. 50
-- 5. По всем столбцам с одинаковыми именами
-- 6. Изменение схемы меняет условие; нет общих имён - получается CROSS JOIN
-- 7. SELECT * FROM B RIGHT JOIN A ON A.id = B.id
-- 8. Когда нужны все строки из обеих таблиц (сверка данных, поиск несовпадений)

-- Challenge 1
SELECT e.emp_name, d.dept_name FROM employees e LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.emp_name, d.dept_name FROM employees e RIGHT JOIN departments d ON e.dept_id = d.dept_id;
-- Challenge 2
SELECT e.emp_name, d.dept_name
FROM employees e JOIN departments d ON d.dept_id = e.dept_id
WHERE d.dept_id IN (SELECT dept_id FROM projects WHERE dept_id IS NOT NULL GROUP BY dept_id HAVING COUNT(*) > 1);
-- Challenge 3
SELECT e.emp_name AS employee, m.emp_name AS manager, mm.emp_name AS managers_manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
LEFT JOIN employees mm ON m.manager_id = mm.emp_id;
-- Challenge 4
SELECT e1.emp_name, e2.emp_name, e1.dept_id
FROM employees e1 JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id < e2.emp_id;


-- ===================== LECTURE TASKS =====================

-- I1
SELECT s.section_id, c.code, c.title, COALESCE(i.full_name, 'TBA') AS instructor
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN instructors i ON i.instr_id = s.instr_id
WHERE s.semester = '2026-FALL'
ORDER BY c.code;

-- I2
SELECT d.name FROM departments d
LEFT JOIN courses c ON c.dept_id = d.dept_id
WHERE c.course_id IS NULL;
SELECT d.name FROM departments d
WHERE NOT EXISTS (SELECT 1 FROM courses c WHERE c.dept_id = d.dept_id);

-- I3
SELECT e.full_name AS instructor, m.full_name AS manager, e.salary, m.salary AS manager_salary
FROM instructors e LEFT JOIN instructors m ON m.instr_id = e.manager_id;
SELECT e.full_name, e.salary, m.full_name AS manager, m.salary
FROM instructors e JOIN instructors m ON m.instr_id = e.manager_id
WHERE e.salary > m.salary;

-- I4
SELECT s.section_id, c.code, COUNT(e.student_id) AS enrolled, s.capacity
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN enrollments e ON e.section_id = s.section_id
WHERE s.semester = '2026-FALL'
GROUP BY s.section_id, c.code;
SELECT s.section_id, c.code, COUNT(e.student_id) AS enrolled, s.capacity
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN enrollments e ON e.section_id = s.section_id
WHERE s.semester = '2026-FALL'
GROUP BY s.section_id, c.code
HAVING COUNT(e.student_id) > s.capacity;

-- I5
SELECT st.full_name, e.score
FROM students st
LEFT JOIN (enrollments e
           JOIN sections s ON s.section_id = e.section_id
           JOIN courses c ON c.course_id = s.course_id)
       ON e.student_id = st.student_id
      AND c.code = 'CSE2101'
      AND s.semester = '2026-FALL';

-- I6
SELECT st.full_name, c.code, e.score, g.letter
FROM enrollments e
JOIN students st USING (student_id)
JOIN sections s USING (section_id)
JOIN courses c USING (course_id)
LEFT JOIN grade_scale g ON e.score BETWEEN g.min_score AND g.max_score;

-- I7
SELECT i.full_name, s.section_id
FROM (SELECT * FROM instructors
      WHERE dept_id = (SELECT dept_id FROM departments WHERE name = 'Computer Science')) i
FULL JOIN (SELECT * FROM sections WHERE semester = '2026-FALL') s
       ON s.instr_id = i.instr_id
WHERE i.instr_id IS NULL OR s.section_id IS NULL;

-- I8
SELECT st.full_name, i.full_name AS advisor, c.code
FROM students st
JOIN enrollments e ON e.student_id = st.student_id
JOIN sections s ON s.section_id = e.section_id AND s.instr_id = st.advisor_id
JOIN instructors i ON i.instr_id = st.advisor_id
JOIN courses c ON c.course_id = s.course_id
WHERE s.semester = '2026-FALL';

-- A1
SELECT i.full_name, COALESCE(s.cnt, 0) AS sections, COALESCE(a.cnt, 0) AS advisees
FROM instructors i
LEFT JOIN (SELECT instr_id, COUNT(*) AS cnt FROM sections GROUP BY instr_id) s ON s.instr_id = i.instr_id
LEFT JOIN (SELECT advisor_id, COUNT(*) AS cnt FROM students GROUP BY advisor_id) a ON a.advisor_id = i.instr_id;

-- A2
SELECT c.code, t.full_name, t.score
FROM courses c
LEFT JOIN LATERAL (
    SELECT st.full_name, e.score
    FROM sections s
    JOIN enrollments e ON e.section_id = s.section_id
    JOIN students st ON st.student_id = e.student_id
    WHERE s.course_id = c.course_id AND e.score IS NOT NULL
    ORDER BY e.score DESC
    FETCH FIRST 3 ROWS WITH TIES
) t ON true
ORDER BY c.code, t.score DESC;

-- A3
SELECT st.full_name, c.code AS course, pc.code AS missing_prereq
FROM enrollments e
JOIN sections s ON s.section_id = e.section_id
JOIN students st ON st.student_id = e.student_id
JOIN courses c ON c.course_id = s.course_id
JOIN prerequisites p ON p.course_id = s.course_id
JOIN courses pc ON pc.course_id = p.prereq_id
WHERE s.semester = '2026-FALL'
  AND NOT EXISTS (
      SELECT 1
      FROM enrollments e2
      JOIN sections s2 ON s2.section_id = e2.section_id
      WHERE e2.student_id = e.student_id
        AND s2.course_id = p.prereq_id
        AND s2.starts_on < s.starts_on
        AND e2.score >= 50);

-- A4 (v1)
SELECT st.student_id, st.full_name
FROM students st
JOIN enrollments e ON e.student_id = st.student_id AND e.score >= 50
JOIN sections s ON s.section_id = e.section_id
JOIN courses c ON c.course_id = s.course_id
JOIN departments d ON d.dept_id = c.dept_id
WHERE d.name = 'Computer Science'
GROUP BY st.student_id, st.full_name
HAVING COUNT(DISTINCT c.course_id) = (
    SELECT COUNT(*) FROM courses c2 JOIN departments d2 USING (dept_id)
    WHERE d2.name = 'Computer Science');
-- A4 (v2)
SELECT st.full_name
FROM students st
WHERE NOT EXISTS (
    SELECT 1 FROM courses c JOIN departments d USING (dept_id)
    WHERE d.name = 'Computer Science'
      AND NOT EXISTS (
          SELECT 1 FROM enrollments e JOIN sections s USING (section_id)
          WHERE e.student_id = st.student_id
            AND s.course_id = c.course_id
            AND e.score >= 50));

-- A5
WITH RECURSIVE chain AS (
    SELECT p.prereq_id, 1 AS depth, ARRAY[p.course_id, p.prereq_id] AS path
    FROM prerequisites p JOIN courses c ON c.course_id = p.course_id
    WHERE c.code = 'CSE4101'
    UNION ALL
    SELECT p.prereq_id, ch.depth + 1, ch.path || p.prereq_id
    FROM chain ch JOIN prerequisites p ON p.course_id = ch.prereq_id
    WHERE p.prereq_id <> ALL (ch.path)
)
SELECT c.code, c.title, MIN(ch.depth) AS depth
FROM chain ch JOIN courses c ON c.course_id = ch.prereq_id
GROUP BY c.code, c.title
ORDER BY depth, c.code;

-- A6
SELECT d.name, i.full_name, i.salary
FROM instructors i
JOIN departments d ON d.dept_id = i.dept_id
JOIN (SELECT dept_id, MAX(salary) AS max_sal FROM instructors GROUP BY dept_id) m
  ON m.dept_id = i.dept_id AND m.max_sal = i.salary;
SELECT DISTINCT ON (i.dept_id) d.name, i.full_name, i.salary
FROM instructors i JOIN departments d USING (dept_id)
ORDER BY i.dept_id, i.salary DESC;
SELECT name, full_name, salary
FROM (SELECT d.name, i.full_name, i.salary,
             RANK() OVER (PARTITION BY i.dept_id ORDER BY i.salary DESC) AS rnk
      FROM instructors i JOIN departments d ON d.dept_id = i.dept_id) t
WHERE rnk = 1;

-- A7
UPDATE instructors i
SET salary = salary * 1.05
FROM (SELECT s.instr_id
      FROM sections s JOIN enrollments e ON e.section_id = s.section_id
      WHERE s.semester = '2026-SPRING' AND e.score IS NOT NULL
      GROUP BY s.instr_id
      HAVING AVG(e.score) >= 85) top
WHERE top.instr_id = i.instr_id
RETURNING i.full_name, i.salary;

DELETE FROM enrollments e
USING sections s
WHERE s.section_id = e.section_id
  AND s.semester = '2026-FALL'
  AND s.instr_id IS NULL
  AND e.score IS NULL;

-- A8
EXPLAIN ANALYZE
SELECT s.section_id, c.code, COUNT(e.student_id) AS enrolled, s.capacity
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN enrollments e ON e.section_id = s.section_id
WHERE s.semester = '2026-FALL'
GROUP BY s.section_id, c.code
HAVING COUNT(e.student_id) > s.capacity;

CREATE INDEX ON enrollments(section_id);
EXPLAIN ANALYZE
SELECT s.section_id, c.code, COUNT(e.student_id) AS enrolled, s.capacity
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN enrollments e ON e.section_id = s.section_id
WHERE s.semester = '2026-FALL'
GROUP BY s.section_id, c.code
HAVING COUNT(e.student_id) > s.capacity;

SET enable_hashjoin = off;
EXPLAIN ANALYZE
SELECT s.section_id, c.code, COUNT(e.student_id) AS enrolled, s.capacity
FROM sections s
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN enrollments e ON e.section_id = s.section_id
WHERE s.semester = '2026-FALL'
GROUP BY s.section_id, c.code
HAVING COUNT(e.student_id) > s.capacity;
RESET enable_hashjoin;

-- A8 discussion
-- 1.PK (student_id, section_id) is sorted first by student_id, searching only by section_id does not use it
-- 2.Only PRIMARY KEY and UNIQUE are indexed automatically; an index on a FK slows down writing and is not always needed.