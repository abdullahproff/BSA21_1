CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    fio TEXT NOT NULL
);

CREATE TABLE "image" (
    id SERIAL PRIMARY KEY,
    upload_date DATE NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES "user"(id) ON DELETE CASCADE
);

CREATE TABLE "tag" (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE "image_tag" (
    image_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (image_id, tag_id),
    CONSTRAINT fk_image FOREIGN KEY (image_id) REFERENCES "image"(id) ON DELETE CASCADE,
    CONSTRAINT fk_tag FOREIGN KEY (tag_id) REFERENCES "tag"(id) ON DELETE CASCADE
);
