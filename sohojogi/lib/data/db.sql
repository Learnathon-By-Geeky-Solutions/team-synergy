-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Location tables
CREATE TABLE countries (
  id SERIAL NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  code TEXT NOT NULL,
  flag TEXT
);

CREATE TABLE states (
  id SERIAL NOT NULL PRIMARY KEY,
  country_id INTEGER REFERENCES countries(id),
  name TEXT NOT NULL,
  code TEXT
);

CREATE TABLE cities (
  id SERIAL NOT NULL PRIMARY KEY,
  state_id INTEGER REFERENCES states(id),
  name TEXT NOT NULL,
  code TEXT
);

CREATE TABLE areas (
  id SERIAL NOT NULL PRIMARY KEY,
  city_id INTEGER REFERENCES cities(id),
  name TEXT NOT NULL,
  postal_code TEXT
);

-- User related tables
CREATE TABLE profile (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  full_name TEXT,
  email TEXT NOT NULL,
  is_email_verified BOOLEAN DEFAULT false,
  phone_number TEXT,
  gender TEXT,
  profile_photo_url TEXT
);

CREATE TABLE temp_users (
  id UUID NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE user_locations (
  id SERIAL NOT NULL PRIMARY KEY,
  user_id UUID,
  name TEXT,
  country_id INTEGER REFERENCES countries(id),
  state_id INTEGER REFERENCES states(id),
  city_id INTEGER REFERENCES cities(id),
  area_id INTEGER REFERENCES areas(id),
  street_address TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  is_default BOOLEAN DEFAULT false,
  is_saved BOOLEAN DEFAULT true,
  icon TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- Worker related tables
CREATE TABLE work_types (
  id SERIAL NOT NULL PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT
);

CREATE TABLE workers (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  profile_image_url TEXT,
  location TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  service_category TEXT NOT NULL,
  email TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  gender TEXT NOT NULL,
  bio TEXT,
  completion_rate REAL DEFAULT 95.0,
  jobs_completed INTEGER DEFAULT 0,
  years_of_experience INTEGER DEFAULT 1,
  is_verified BOOLEAN DEFAULT false,
  average_rating REAL DEFAULT 0.0,
  review_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_services (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  name TEXT NOT NULL,
  description TEXT,
  price REAL NOT NULL,
  unit TEXT NOT NULL,
  is_popular BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_skills (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  skill_name TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_qualifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  title TEXT NOT NULL,
  issuer TEXT NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE,
  certificate_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_portfolio_items (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  image_url TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_availability (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  day_of_week INTEGER NOT NULL,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE worker_time_slots (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  availability_id UUID REFERENCES worker_availability(id),
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order related tables
CREATE TABLE orders (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL,
  worker_id UUID NOT NULL REFERENCES workers(id),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  total_price NUMERIC NOT NULL,
  service_type TEXT NOT NULL,
  location TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  scheduled_at TIMESTAMPTZ
);

CREATE TABLE order_services (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES orders(id),
  service_id UUID NOT NULL REFERENCES worker_services(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  price NUMERIC NOT NULL,
  subtotal NUMERIC NOT NULL
);

CREATE TABLE order_statuses (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES orders(id),
  status TEXT NOT NULL,
  changed_at TIMESTAMPTZ DEFAULT now(),
  changed_by UUID NOT NULL,
  notes TEXT
);

-- Review related tables
CREATE TABLE worker_reviews (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  worker_id UUID REFERENCES workers(id),
  user_id UUID,
  user_name TEXT NOT NULL,
  user_image TEXT,
  rating INTEGER NOT NULL,
  comment TEXT,
  date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE review_photos (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  review_id UUID REFERENCES worker_reviews(id),
  photo_url TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notification table
CREATE TABLE notifications (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID NOT NULL,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  related_id UUID,
  action_url TEXT,
  is_read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Worker registration table
CREATE TABLE workers_registration (
  id SERIAL NOT NULL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  years_of_experience INTEGER NOT NULL,
  experience_country VARCHAR(100) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE worker_work_types (
  worker_id INTEGER NOT NULL REFERENCES workers_registration(id),
  work_type_id INTEGER NOT NULL REFERENCES work_types(id),
  PRIMARY KEY (worker_id, work_type_id)
);