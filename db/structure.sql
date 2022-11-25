CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "customers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" text, "phone" text, "email" text, "address" text, "zip" text, "city" text, "country" text, "deleted_at" datetime(6), "invoices_count" integer DEFAULT 0, "firm_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX "index_customers_on_firm_id" ON "customers" ("firm_id");
CREATE TABLE IF NOT EXISTS "logs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "event" text, "customer_id" integer, "user_id" integer NOT NULL, "firm_id" integer NOT NULL, "project_id" integer, "employee_id" integer, "invoice_id" integer DEFAULT 0, "credit_note_id" integer DEFAULT 0, "todo_id" integer, "tracking" boolean, "begin_time" datetime(6), "end_time" datetime(6), "log_date" date, "hours" float DEFAULT 0.0, "rate" float DEFAULT 0.0, "tax" float, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_logs_on_firm_id" ON "logs" ("firm_id");
CREATE INDEX "index_logs_on_invoice_id" ON "logs" ("invoice_id");
CREATE INDEX "index_logs_on_user_id" ON "logs" ("user_id");
CREATE INDEX "index_logs_on_project_id" ON "logs" ("project_id");
CREATE INDEX "index_logs_on_employee_id" ON "logs" ("employee_id");
CREATE INDEX "index_logs_on_todo_id" ON "logs" ("todo_id");
CREATE INDEX "index_logs_on_customer_id" ON "logs" ("customer_id");
CREATE TABLE IF NOT EXISTS "firms" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" text, "subdomain" text, "address" text, "phone" text, "currency" text, "language" text DEFAULT 'en', "time_zone" text, "tax" float, "reminder_fee" float, "days_to_due" integer DEFAULT 14, "invoice_email" text, "invoice_email_subject" text, "invoice_email_message" text, "on_invoice_message" text, "reminder_email_subject" text, "reminder_email_message" text, "on_reminder_message" text, "bank_account" text, "vat_number" text, "last_sign_in_at" datetime(6), "closed" boolean, "time_format" integer, "date_format" integer, "clock_format" integer, "plan_id" integer, "starting_invoice_number" integer DEFAULT 1, "customers_count" integer DEFAULT 0, "users_count" integer DEFAULT 0, "projects_count" integer DEFAULT 0, "logs_count" integer DEFAULT 0, "invoices_count" integer DEFAULT 0, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "logo_file_name" varchar, "logo_content_type" varchar, "logo_file_size" integer, "logo_updated_at" datetime(6), "background" varchar, "color" varchar);
CREATE INDEX "index_firms_on_plan_id" ON "firms" ("plan_id");
CREATE INDEX "index_firms_on_subdomain" ON "firms" ("subdomain");
CREATE TABLE IF NOT EXISTS "todos" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" text, "user_id" integer, "firm_id" integer NOT NULL, "project_id" integer, "customer_id" integer, "done_by_user_id" integer, "prior" integer, "due" date, "completed" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_todos_on_firm_id" ON "todos" ("firm_id");
CREATE INDEX "index_todos_on_user_id" ON "todos" ("user_id");
CREATE INDEX "index_todos_on_project_id" ON "todos" ("project_id");
CREATE INDEX "index_todos_on_customer_id" ON "todos" ("customer_id");
CREATE INDEX "index_todos_on_done_by_user_id" ON "todos" ("done_by_user_id");
CREATE TABLE IF NOT EXISTS "projects" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" text, "description" text, "active" boolean, "budget" float, "hour_price" float, "firm_id" integer NOT NULL, "customer_id" integer, "invoices_count" integer DEFAULT 0, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_projects_on_firm_id" ON "projects" ("firm_id");
CREATE INDEX "index_projects_on_customer_id" ON "projects" ("customer_id");
CREATE TABLE IF NOT EXISTS "milestones" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "goal" text, "due" date, "firm_id" integer NOT NULL, "completed" boolean, "project_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_milestones_on_firm_id" ON "milestones" ("firm_id");
CREATE INDEX "index_milestones_on_project_id" ON "milestones" ("project_id");
CREATE TABLE IF NOT EXISTS "employees" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" text, "phone" text, "email" text, "customer_id" integer NOT NULL, "firm_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_employees_on_customer_id" ON "employees" ("customer_id");
CREATE INDEX "index_employees_on_firm_id" ON "employees" ("firm_id");
CREATE TABLE IF NOT EXISTS "memberships" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer, "user_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_memberships_on_project_id_and_user_id" ON "memberships" ("project_id", "user_id");
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "role" text, "phone" text, "name" text, "firm_id" integer NOT NULL, "hourly_rate" float DEFAULT 0.0, "loginable_type" varchar(40), "loginable_id" integer, "loginable_token" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "avatar_file_name" varchar, "avatar_content_type" varchar, "avatar_file_size" integer, "avatar_updated_at" datetime(6), "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime(6), "remember_created_at" datetime(6), "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime(6), "last_sign_in_at" datetime(6), "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "confirmation_token" varchar, "confirmed_at" datetime(6), "confirmation_sent_at" datetime(6), "unconfirmed_email" varchar, "failed_attempts" integer DEFAULT 0 NOT NULL, "unlock_token" varchar, "locked_at" datetime(6));
CREATE INDEX "index_users_on_firm_id" ON "users" ("firm_id");
CREATE TABLE IF NOT EXISTS "admin_users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime(6), "remember_created_at" datetime(6), "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime(6), "last_sign_in_at" datetime(6), "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_admin_users_on_email" ON "admin_users" ("email");
CREATE UNIQUE INDEX "index_admin_users_on_reset_password_token" ON "admin_users" ("reset_password_token");
CREATE TABLE IF NOT EXISTS "admin_notes" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "resource_id" varchar NOT NULL, "resource_type" varchar NOT NULL, "admin_user_type" varchar, "admin_user_id" integer, "body" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_admin_notes_on_admin_user" ON "admin_notes" ("admin_user_type", "admin_user_id");
CREATE INDEX "index_admin_notes_on_resource_type_and_resource_id" ON "admin_notes" ("resource_type", "resource_id");
CREATE INDEX "index_admin_notes_on_admin_user_type_and_admin_user_id" ON "admin_notes" ("admin_user_type", "admin_user_id");
CREATE TABLE IF NOT EXISTS "subscriptions" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "plan_id" integer, "email" text, "name" text, "firm_id" integer, "paymill_id" text, "paymill_client_id" text, "card_zip" text, "last_four" text, "card_type" text, "next_bill_on" date, "card_expiration" text, "card_holder" text, "active" boolean, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_subscriptions_on_plan_id_and_firm_id" ON "subscriptions" ("plan_id", "firm_id");
CREATE TABLE IF NOT EXISTS "statistics" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "firms" integer, "users" integer, "free" integer, "bronze" integer, "silver" integer, "gold" integer, "platinum" integer, "logs" integer, "customers" integer, "projects" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "plans" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "paymill_id" text, "name" text, "price" float, "customers" integer, "logs" integer, "projects" integer, "users" integer, "invoices" integer, "firms_count" integer DEFAULT 0, "subscriptions_count" integer DEFAULT 0, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "currency" varchar);
CREATE TABLE IF NOT EXISTS "guides" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" text, "content" text, "guides_category_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "guides_categories" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "blogs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "author" text, "title" text, "content" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "payments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "firm_id" integer, "amount" float, "plan_name" text, "card_type" text, "last_four" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "currency" varchar);
CREATE TABLE IF NOT EXISTS "invoices" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "number" integer, "content" text, "project_id" integer, "customer_id" integer NOT NULL, "invoice_id" integer, "reminder_on_id" integer, "firm_id" integer NOT NULL, "status" integer, "reminder_sent" datetime(6), "reminder_fee" float, "sent" datetime(6), "paid" datetime(6), "due" datetime(6), "last_due" datetime(6), "total" float, "receivable" float, "invoice_receivable" float, "date" datetime(6), "lost" float, "currency" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "paid_amount" float);
CREATE INDEX "index_invoices_on_firm_id" ON "invoices" ("firm_id");
CREATE INDEX "index_invoices_on_project_id" ON "invoices" ("project_id");
CREATE INDEX "index_invoices_on_invoice_id" ON "invoices" ("invoice_id");
CREATE INDEX "index_invoices_on_reminder_on_id" ON "invoices" ("reminder_on_id");
CREATE INDEX "index_invoices_on_customer_id" ON "invoices" ("customer_id");
CREATE TABLE IF NOT EXISTS "invoice_lines" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "quantity" float, "description" text, "price" float, "amount" float, "tax" float, "invoice_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "emails" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "address" varchar, "subject" text, "content" text, "invoice_id" integer, "firm_id" integer, "sent" date, "status" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE TABLE IF NOT EXISTS "active_admin_comments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "namespace" varchar, "body" text, "resource_type" varchar, "resource_id" integer, "author_type" varchar, "author_id" integer, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_active_admin_comments_on_resource" ON "active_admin_comments" ("resource_type", "resource_id");
CREATE INDEX "index_active_admin_comments_on_author" ON "active_admin_comments" ("author_type", "author_id");
CREATE INDEX "index_active_admin_comments_on_namespace" ON "active_admin_comments" ("namespace");
INSERT INTO "schema_migrations" (version) VALUES
('20100608185738'),
('20100608190022'),
('20100912092851'),
('20101020122814'),
('20101029105953'),
('20101029201134'),
('20101029201135'),
('20101029201137'),
('20101029201138'),
('20101029201139'),
('20101029201140'),
('20101029201142'),
('20101029201143'),
('20101029201144'),
('20101029201145'),
('20101029201146'),
('20101029201147'),
('20101029201148'),
('20101029201149'),
('20101029201150'),
('20101029201151'),
('20101029201153'),
('20101029201155'),
('20101029201156'),
('20101029201157'),
('20101029201159'),
('20101029201160'),
('20101029201161'),
('20101029201162'),
('20101029201163');


