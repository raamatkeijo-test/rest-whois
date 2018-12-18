require 'test_helper'

class ContactRequestsIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    super

    @private_domain = whois_records(:privately_owned)
    @valid_contact_request = contact_requests(:valid)
    @expired_contact_request = contact_requests(:expired)
  end

  def test_request_replay_fails
    # Visit the page once
    visit(contact_request_path(@valid_contact_request.secret))

    check(option: 'admin_contacts')
    body = 'Old mail body'
    fill_in('Message', with: body) # Fill in all the form fields
    click_link_or_button 'Send'
    assert_text('Your email has been sent.') # Successfully send an email

    # Visit the page again, and get an error code
    assert_raise ActiveRecord::RecordNotFound do
      get(contact_request_path(@valid_contact_request.secret))
      assert_equal(404, page.status_code)
    end
  end

  def test_request_fails_when_whois_record_was_deleted
    @private_domain.destroy

    # Visit the page after the corresponding whois_record was deleted
    assert_raise ActiveRecord::RecordNotFound do
      get(contact_request_path(@valid_contact_request.secret))
      assert_equal(404, page.status_code)
    end
  end
end
