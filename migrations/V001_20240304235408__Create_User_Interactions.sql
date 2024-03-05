CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS users_interactions;

CREATE TABLE IF NOT EXISTS users_interactions.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    is_admin BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS users_interactions.follows (
    follower_id UUID NOT NULL,
    followee_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users_interactions.users (id),
    FOREIGN KEY (followee_id) REFERENCES users_interactions.users (id)
);

CREATE TABLE IF NOT EXISTS users_interactions.artists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    genre VARCHAR(255) NOT NULL,
    albums INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users_interactions.venues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users_interactions.shows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    artist_id UUID NOT NULL,
    venue_id UUID NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES users_interactions.artists (id),
    FOREIGN KEY (venue_id) REFERENCES users_interactions.venues (id)
);

CREATE TABLE IF NOT EXISTS users_interactions.reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    show_id UUID NOT NULL,
    rating DECIMAL(3, 1) NOT NULL CHECK (rating >= 1 AND rating <= 10),
    notes TEXT,
    pictures JSONB,
    favorite_songs TEXT[],
    labels TEXT[],
    other_users UUID[],
    visit_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users_interactions.users (id),
    FOREIGN KEY (show_id) REFERENCES users_interactions.shows (id)
);