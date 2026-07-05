# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin_email = ENV.fetch("ADMIN_EMAIL")
admin_password = ENV.fetch("ADMIN_PASSWORD")

admin = User.find_or_initialize_by(email: admin_email)
admin.password = admin_password
admin.role = :admin
admin.save!

puts "Admin user ready: #{admin.email}"

events = [
  {
    title: "Ciclo de Cine Japonés",
    description: "Proyección de clásicos del cine japonés, con conversación abierta al final.",
    event_date: 2.weeks.from_now.change(hour: 18),
    location: "Sala de Cine UC",
    capacity: 40,
    form_url: "https://forms.gle/ejemplo-ciclo-cine",
    status: :published
  },
  {
    title: "Taller de Caligrafía Japonesa (Shodō)",
    description: "Un taller introductorio para aprender los fundamentos del shodō, la caligrafía japonesa.",
    event_date: 3.weeks.from_now.change(hour: 16),
    location: "Patio de Letras, Campus San Joaquín",
    capacity: nil,
    form_url: "https://forms.gle/ejemplo-shodo",
    status: :published
  },
  {
    title: "Conversatorio: Estudiar en Japón",
    description: "Estudiantes de intercambio comparten su experiencia viviendo y estudiando en Japón.",
    event_date: 1.month.from_now.change(hour: 19),
    location: "Auditorio Facultad de Letras",
    capacity: 60,
    form_url: "https://forms.gle/ejemplo-conversatorio",
    status: :published
  },
  {
    title: "Bienvenida Kotonoha 2026",
    description: "Actividad de bienvenida para dar a conocer Kotonoha Nippon Club a la comunidad UC.",
    event_date: 2.weeks.ago.change(hour: 17),
    location: "Plaza San Agustín",
    capacity: nil,
    form_url: nil,
    status: :published
  }
]

events.each do |attrs|
  event = Event.find_or_initialize_by(title: attrs[:title])
  event.assign_attributes(attrs)
  event.save!
end

puts "Seeded #{Event.count} events."

category_names = [
  "Presidente",
  "Vicepresidente",
  "Directorio / Directores",
  "Miembros Coordinadores",
  "SAKURA Staff"
]

categories = category_names.map.with_index do |name, index|
  category = StaffCategory.find_or_initialize_by(name: name)
  category.position = index
  category.save!
  category
end

puts "Seeded #{StaffCategory.count} staff categories."

staff_members = [
  {
    nombre: "Javiera Muñoz",
    cargo: "Presidenta",
    staff_category: categories[0],
    carrera: "Ingeniería Civil",
    birth_date: 22.years.ago.to_date,
    university_start_date: 4.years.ago.to_date,
    kotonoha_start_date: 3.years.ago.to_date,
    correo: "presidencia@kotonoha.cl",
    linkedin_url: "https://www.linkedin.com/in/example-presidenta",
    interests: "Cine japonés, caligrafía, senderismo"
  },
  {
    nombre: "Matías Rojas",
    cargo: "Vicepresidente",
    staff_category: categories[1],
    carrera: "Letras Hispánicas",
    birth_date: 21.years.ago.to_date,
    university_start_date: 3.years.ago.to_date,
    kotonoha_start_date: 3.years.ago.to_date,
    correo: "vicepresidencia@kotonoha.cl",
    linkedin_url: "https://www.linkedin.com/in/example-vicepresidente",
    interests: "Literatura, videojuegos, cocina japonesa"
  },
  {
    nombre: "Sofía Castro",
    cargo: "Directora de Eventos",
    staff_category: categories[2],
    carrera: "Diseño",
    birth_date: 20.years.ago.to_date,
    university_start_date: 2.years.ago.to_date,
    kotonoha_start_date: 2.years.ago.to_date,
    correo: "eventos@kotonoha.cl",
    linkedin_url: "https://www.linkedin.com/in/example-directora",
    interests: "Fotografía, diseño gráfico, animé"
  },
  {
    nombre: "Diego Fuentes",
    cargo: "Coordinador de Idioma",
    staff_category: categories[3],
    carrera: "Ingeniería Comercial",
    birth_date: 19.years.ago.to_date,
    university_start_date: 1.year.ago.to_date,
    kotonoha_start_date: 1.year.ago.to_date,
    correo: "idioma@kotonoha.cl",
    linkedin_url: "https://www.linkedin.com/in/example-coordinador",
    interests: "Idioma japonés, manga, básquetbol"
  },
  {
    nombre: "Camila Vera",
    cargo: "SAKURA Staff",
    staff_category: categories[4],
    carrera: "Psicología",
    birth_date: 19.years.ago.to_date,
    university_start_date: 1.year.ago.to_date,
    kotonoha_start_date: 6.months.ago.to_date,
    correo: "sakura@kotonoha.cl",
    linkedin_url: "https://www.linkedin.com/in/example-sakura",
    interests: "Voluntariado, música, comunidad nikkei"
  }
]

staff_members.each do |attrs|
  staff = Staff.find_or_initialize_by(nombre: attrs[:nombre])
  staff.assign_attributes(attrs)
  staff.save!
end

puts "Seeded #{Staff.count} staff members."
