#----------------------------------#
# Donors Edit Integration Test
# original written by: 
# major contributions by: Andy W, Wei H
#
#----------------------------------#
require 'test_helper'

class DonorsEditTest < ActionDispatch::IntegrationTest

  def setup
    @donor = donors(:andy)
  end
  
  test "successful edit" do
    get edit_donor_path(@donor)
    assert_template 'donors/edit'
    first_name = "Joe"
    last_name = "Brown"
    address = "100 Main St"
    city = "Aurora"
    state = "MI"
    zip = 45021
    phone = "259-987-9999"
    email = "joeb@hotmail.com"
    notes = "new notes"
    patch donor_path(@donor), params: {donor: { first_name: first_name,
                                                last_name: last_name,
                                                address: address,
                                                address2: "",
                                                city: city,
                                                state: state,
                                                zip: zip,
                                                phone: phone,
                                                email: email,
                                                notes: notes } }
    assert_redirected_to donors_path
    @donor.reload
    assert_equal first_name, @donor.first_name
    assert_equal last_name, @donor.last_name
    assert_equal address, @donor.address
    assert_equal "", @donor.address2
    assert_equal city, @donor.city
    assert_equal state, @donor.state
    assert_equal zip, @donor.zip
    assert_equal phone, @donor.phone
    assert_equal email, @donor.email
    assert_equal notes, @donor.notes
  end
  
  test "unsuccessful edit" do
    get edit_donor_path(@donor)
    assert_template 'donors/edit'
    patch donor_path(@donor), params: { donor: { first_name:  "Joe",
                                                last_name: "White",
                                                address: "101 College Lane",
                                                address2: "APT 63",
                                                city: "Naperville",
                                                state: "IL",
                                                zip: "60606",
                                                phone: "815-963-8521",
                                                email: "foo@invalid",
                                                notes:"Bad email" } }

    assert_template 'donors/edit'
    assert_select "div.alert", true
  end
end
