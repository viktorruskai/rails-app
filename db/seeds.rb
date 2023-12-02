# Create a admin user.
User.create!(name: "Admin User",
             email: "admin@example.com",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Create a student.
User.create!(name: "Student User",
             email: "user@example.com",
             password: "123456",
             password_confirmation: "123456",
             admin: false,
             activated: true,
             activated_at: Time.zone.now)