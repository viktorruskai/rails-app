# Create a main Admin user.
User.create!(name:  "Admin User",
             email: "admin@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

# Create a normal user.
User.create!(name:  "Normal User",
             email: "user@example.com",
             password:              "123456",
             password_confirmation: "123456",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)