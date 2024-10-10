# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_09_06_123133) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branch_governments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_categorys", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_sub_categorys", force: :cascade do |t|
    t.string "name"
    t.bigint "diary_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diary_category_id"], name: "index_diary_sub_categorys_on_diary_category_id"
  end

  create_table "entitys", force: :cascade do |t|
    t.string "cnpj"
    t.string "phone"
    t.bigint "type_entity_id", null: false
    t.bigint "user_id", null: false
    t.string "name_entity"
    t.string "uf"
    t.string "city"
    t.string "cep"
    t.string "street"
    t.string "number_address"
    t.string "complement"
    t.string "slug"
    t.string "law"
    t.string "name_diary"
    t.string "logo"
    t.boolean "status"
    t.integer "number_edition"
    t.text "diary_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type_entity_id"], name: "index_entitys_on_type_entity_id"
    t.index ["user_id"], name: "index_entitys_on_user_id"
  end

  create_table "entitys_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entity_id", null: false
    t.index ["entity_id"], name: "index_entitys_users_on_entity_id"
    t.index ["user_id"], name: "index_entitys_users_on_user_id"
  end

  create_table "file_sections", force: :cascade do |t|
    t.string "file"
    t.bigint "section_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_file_sections_on_section_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "official_diarys", force: :cascade do |t|
    t.integer "edition"
    t.string "slug"
    t.string "certificate"
    t.string "combined_file"
    t.boolean "published", default: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_official_diarys_on_entity_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "content_type", default: 0
    t.bigint "branch_government_id", null: false
    t.bigint "diary_category_id", null: false
    t.bigint "diary_sub_category_id"
    t.bigint "official_diary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_section"
    t.string "combined_pdf"
    t.string "responsavel_nome"
    t.string "responsavel_cpf"
    t.index ["branch_government_id"], name: "index_sections_on_branch_government_id"
    t.index ["diary_category_id"], name: "index_sections_on_diary_category_id"
    t.index ["diary_sub_category_id"], name: "index_sections_on_diary_sub_category_id"
    t.index ["official_diary_id"], name: "index_sections_on_official_diary_id"
  end

  create_table "type_entitys", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "slug"
    t.string "avatar"
    t.string "cpf"
    t.string "rg"
    t.date "date_birth"
    t.integer "sex"
    t.string "functional_registration"
    t.string "cep"
    t.string "uf"
    t.string "city"
    t.string "street"
    t.string "neighborhood"
    t.string "number_address"
    t.string "complement"
    t.string "phone"
    t.integer "logged"
    t.boolean "super_user", default: false
    t.boolean "admin_user", default: false
    t.boolean "common_user", default: false
    t.boolean "register", default: false
    t.boolean "read", default: false
    t.boolean "publish", default: false
    t.boolean "status", default: true
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "office_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "diary_sub_categorys", "diary_categorys"
  add_foreign_key "entitys", "type_entitys"
  add_foreign_key "entitys", "users"
  add_foreign_key "entitys_users", "entitys"
  add_foreign_key "entitys_users", "users"
  add_foreign_key "file_sections", "sections"
  add_foreign_key "official_diarys", "entitys"
  add_foreign_key "sections", "branch_governments"
  add_foreign_key "sections", "diary_categorys"
  add_foreign_key "sections", "diary_sub_categorys"
  add_foreign_key "sections", "official_diarys"
  add_foreign_key "users", "offices"
end
