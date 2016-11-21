# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

  #----------------------------------#
  # Database Seed File
  # original written by: Wei H, Oct 14 2016
  # major contributions by:
  #             Andy W, Oct 18 2016
  #             Pat M, Nov 3, 2016
  #----------------------------------#
  
#case Rails.env

#  #commented out code in this file is for production seeds! un-comment and use at that time.

#  when "development" 
#  #creates many example activities, donors, gifts, and users
#  #these are only used to development environment purposes
  #create sample activties
  Activity.create!( name: "Golf Outing 2015",
                    start_date: "2016-09-09",
                    end_date: "2016-09-19",
                    description: "Fun",
                    goal: "400",
                    notes: "Contact Jen for more information.")
                    
  Activity.create!( name: "General",
                    start_date: "2016-07-09",
                    end_date: "2016-08-19",
                    description: "The more the better.",
                    goal: "0",
                    notes: "Contact Jen for more information.")
                    
  Activity.create!( name: "Color Marathon",
                    start_date: "2016-07-09",
                    end_date: "2016-07-09",
                    description: "Fun",
                    goal: "5000",
                    notes: "Contact Jen for more information.")
                  
  Activity.create!( name: "Food Truck",
                    start_date: "2016-07-16",
                    end_date: "2016-07-16",
                    description: "Fun",
                    goal: "100",
                    notes: "Contact Jen for more information.")
  
  Activity.create!( name: "Halloween Pumpkin Carving",
                    start_date: "2016-10-16",
                    end_date: "2016-10-31",
                    description: "Fun",
                    goal: "2500",
                    notes: "Donors purchase $5 pumpkin to carve.")
  
  Activity.create!( name: "Chicago Cubs World Series",
                    start_date: "2016-10-31",
                    end_date: "2016-10-31",
                    description: "Fun",
                    goal: "1000",
                    notes: "Contact Bob for more information.")
  99.times do |n|
    name        = Faker::Company.name#"Seed Activity #{n+1}." => "value"
    start_date  = Faker::Date.backward(1825).strftime("%Y-%m-%d").to_datetime
    end_date    = Faker::Date.forward(365).strftime("%Y-%m-%d").to_datetime
    description = Faker::Lorem.sentence(3, true, 4)
    goal        = Faker::Address.building_number
    notes       = Faker::Company.catch_phrase
    
    Activity.create!(
      name:        name,
      start_date:  start_date,
      end_date:    end_date,
      description: description,
      goal:        goal,
      notes:       notes)
  end
  
  #create sample donors                 
  Donor.create!( first_name: "Joe",
                    last_name: "Donor",
                    address: "101 College Lane",
                    address2: "APT 2",
                    city: "Naperville",
                    state: "IL",
                    zip: "60564",
                    phone: "815-555-5551",
                    email: "joe.donor@ncc.edu",
                    notes: "Example donor.")
                    
  Donor.create!( first_name: "Jane",
                    last_name: "Brown",
                    address: "455 Summit Ave",
                    city: "Downers Grove",
                    state: "IL",
                    zip: "60555",
                    phone: "815-555-5552",
                    email: "janeb@hotmail.com",
                    notes: "Example donor #2.")
                    
  Donor.create!( first_name: "Tim",
                    last_name: "Lee",
                    address: "55 Summit Ln",
                    city: "Downers Grove",
                    state: "IL",
                    zip: "60555",
                    phone: "515-555-5552",
                    email: "timlee@hotmail.com",
                    notes: "Example donor #3.")
                    
  Donor.create!( first_name: "Brian",
                    last_name: "Brown",
                    address: "100 Main Ave.",
                    city: "Chicago",
                    state: "IL",
                    zip: "60060",
                    phone: "330-257-6689",
                    email: "bbrown@hotmail.com",
                    notes: "Example donor #4.")
  
  Donor.create!( first_name: "Brian",
                    last_name: "Green",
                    address: "200 Main Ave.",
                    city: "Chicago",
                    state: "IL",
                    zip: "60060",
                    phone: "330-257-5589",
                    email: "bgreen@hotmail.com",
                    notes: "Example donor #5.")
  
  Donor.create!( first_name: "Joe",
                    last_name: "Brown",
                    address: "300 Main Ave.",
                    city: "Chicago",
                    state: "IL",
                    zip: "60060",
                    phone: "330-257-4567",
                    email: "jbrown@hotmail.com",
                    notes: "Example donor #6.")
                    
  #duplicated donor: Joe Donor
  Donor.create!( first_name: "Joe",
                    last_name: "Donor",
                    address: "101 College Lane",
                    address2: "APT 2",
                    city: "Naperville",
                    state: "IL",
                    zip: "60564",
                    phone: "815-555-5551",
                    email: "jodonor@ncc.edu",
                    notes: "Example donor.")
                    
  99.times do |n|
    first_name  = Faker::Name.first_name
    last_name   = Faker::Name.last_name
    address     = Faker::Address.street_address
    city        = Faker::Address.city
    state       = Faker::Address.state
    country     = Faker::Address.country
    zip         = Faker::Address.zip.to_i
    phone       = Faker::PhoneNumber.phone_number
    email       = Faker::Internet.email
    notes       = Faker::Company.bs
    title       = Faker::Name.title
    donor_type  = [:Individual, :Corporation, :Foundation].sample 

    Donor.create!(
      first_name: first_name,
      last_name:  last_name,
      address:    address,
      city:       city,
      state:      state,
      country:    country,
      zip:        zip,
      phone:      phone,
      email:      email,
      notes:      notes,
      title:      title,
      donor_type: donor_type)
  end
                    
  #create sample donations/gifts                 
  Gift.create!( activity_id: 1,
                donor_id: 1,
                donation_date: "2016-09-06",
                amount: 20,
                gift_type: "Cash",
                notes: "First gift.")
                
  Gift.create!( activity_id: 1,
                donor_id: 2,
                donation_date: "2016-09-09",
                amount: 100,
                gift_type: "Cash")
                
                
  Gift.create!( activity_id: 2,
                donor_id: 2,
                donation_date: "2016-07-09",
                amount: 150,
                gift_type: "Cash")
                
                
  Gift.create!( activity_id: 2,
                donor_id: 3,
                donation_date: "2016-10-14",
                amount: 50,
                gift_type: "Cash")
                
                
  Gift.create!( activity_id: 3,
                donor_id: 3,
                donation_date: "2016-09-30",
                amount: 2500,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 3,
                donor_id: 3,
                donation_date: "2016-10-30",
                amount: 600,
                gift_type: "Cash")
  
  Gift.create!( activity_id: 1,
                donor_id: 4,
                donation_date: "2016-04-30",
                amount: 2500,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 2,
                donation_date: "2016-09-15",
                amount: 400,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 4,
                donor_id: 3,
                donation_date: "2016-03-30",
                amount: 700,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 4,
                donor_id: 1,
                donation_date: "2016-09-12",
                amount: 50,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 1,
                donor_id: 3,
                donation_date: "2016-09-04",
                amount: 3000,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 4,
                donor_id: 2,
                donation_date: "2016-09-05",
                amount: 1500,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 3,
                donation_date: "2016-09-06",
                amount: 400,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 1,
                donation_date: "2016-09-09",
                amount: 6500,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 4,
                donation_date: "2016-09-02",
                amount:1200,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 1,
                donation_date: "2016-12-30",
                amount: 900,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 2,
                donor_id: 3,
                donation_date: "2016-01-30",
                amount: 30,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 1,
                donor_id: 1,
                donation_date: "2016-02-13",
                amount:600,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 1,
                donor_id: 3,
                donation_date: "2016-03-27",
                amount: 70,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 1,
                donor_id: 4,
                donation_date: "2016-04-27",
                amount: 50,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 3,
                donor_id: 2,
                donation_date: "2016-05-27",
                amount: 10,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 1,
                donor_id: 3,
                donation_date: "2016-07-12",
                amount: 20,
                gift_type: "Cash")
                
  Gift.create!( activity_id: 3,
                donor_id: 4,
                donation_date: "2016-12-12",
                amount: 20,
                gift_type: "Cash")
  
  99.times do |n|
    Gift.create!( 
      activity_id: Faker::Number.between(1, 100),
      donor_id: Faker::Number.between(1, 100),
      donation_date: Faker::Time.between(DateTime.now - 1825, DateTime.now + 14),
      notes: Faker::Lorem.sentences(1),
      check_number: Faker::Number.number(9),
      check_date: Faker::Time.between(DateTime.now - 1825, DateTime.now + 14),
      anonymous: Faker::Boolean.boolean,
      amount: Faker::Number.between(1, 100000),
      gift_type: [:Cash, :'Credit Card', :Stock, :'In Kind'].sample)
  end
                
  #create sample users; id of 1 is super admin (profbill)
  #permissions are 
  #level 0 = standard user (default)
  #level 1 = admin
  User.create!( email:              "profbill@noctrl.edu",
                username:           "profbill",
                password_digest:    User.digest('password'),
                permission_level:   1)
                
  User.create!( email:              "andyw@noctrl.edu",
                username:           "andyw",
                password_digest:    User.digest('password'),
                permission_level:   1)
                
  User.create!( email:              "jasonk@noctrl.edu",
                username:           "jasonk",
                password_digest:    User.digest('password'),
                permission_level:   1)
                
  User.create!( email:              "miked@noctrl.edu",
                username:           "miked",
                password_digest:    User.digest('password'),
                permission_level:   1)
                
  User.create!( email:              "patm@noctrl.edu",
                username:           "patm",
                password_digest:    User.digest('password'),
                permission_level:   1)
                
  User.create!( email:              "weih@noctrl.edu",
                username:           "weih",
                password_digest:    User.digest('password'),
                permission_level:   1)
  
  9.times do |n|
    email = "example#{n+1}@noctrl.edu"
    username  = "example#{n+1}"
    password_digest = User.digest('password')
    
    User.create!(
      email:            email,
      username:         username,
      password_digest:  password_digest)
  end
#when "production"
#  #creates super admin and general activity
#  #these are ONLY created for the production environment
#  #create super admin user
#  User.create!( email:              "wtkrieger@noctrl.edu",
#                username:           "profbill",
#                password_digest:    User.digest('password'),
#                permission_level:   1)
#                
#  #create general actvity
#  Activity.create!( name:           "General",
#                    activity_type:  "General",
#                    start_date:     "1999-12-31",
#                    end_date:       "2099-12-31",
#                    description:    "General Activity",
#                    goal:           "0")
#end
