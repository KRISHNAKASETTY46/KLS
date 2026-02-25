CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) CHECK (role IN ('student','teacher','admin')) NOT NULL,
    profile_image TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    project_type VARCHAR(30) CHECK (
        project_type IN ('circuit','robotics','iot')
    ),
    simulation_data JSONB NOT NULL,
    code TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gallery (
    gallery_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id) ON DELETE CASCADE,
    featured BOOLEAN DEFAULT FALSE,
    likes_count INT DEFAULT 0,
    views_count INT DEFAULT 0,
    shared_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE classrooms (
    classroom_id SERIAL PRIMARY KEY,
    teacher_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    class_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE classroom_students (
    id SERIAL PRIMARY KEY,
    classroom_id INT REFERENCES classrooms(classroom_id) ON DELETE CASCADE,
    student_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (classroom_id, student_id)
);

CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    classroom_id INT REFERENCES classrooms(classroom_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE assignment_submissions (
    submission_id SERIAL PRIMARY KEY,
    assignment_id INT REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    student_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    project_id INT REFERENCES projects(project_id),
    grade VARCHAR(10),
    feedback TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, student_id)
);

CREATE TABLE tutorials (
    tutorial_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    level VARCHAR(20) CHECK (
        level IN ('beginner','intermediate','advanced')
    ),
    content TEXT NOT NULL,
    linked_project_id INT REFERENCES projects(project_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resources (
    resource_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    resource_type VARCHAR(30) CHECK (
        resource_type IN ('pdf','lesson_plan','faq','hardware_guide')
    ),
    file_url TEXT NOT NULL,
    uploaded_by INT REFERENCES users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);