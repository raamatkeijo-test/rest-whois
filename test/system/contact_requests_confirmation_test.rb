# encoding: utf-8
require 'application_system_test_case'

class ContactRequestsConfirmationTest < ApplicationSystemTestCase
  def test_link_from_whois_record_page_does_not_exists_for_discarded_domains
    visit("v1/discarded-domain.test")
    refute(has_link?('Contact owner'))
  end

  def test_link_from_whois_record_page_does_not_exists_for_legal_owners
    visit("v1/company-domain.test")
    refute(has_link?('Contact owner'))
  end

  def test_create_a_email_confirmation_delivery
    visit(new_contact_request_path(params: { domain_name: 'privatedomain.test' }))
    fill_in('contact_request[email]', with: 'i-want-to-contact-you@domain.com')
    fill_in('contact_request[name]', with: 'Test User')
    click_link_or_button 'Get a link'

    assert_text('Contact request created. Check your email for a link to the one-time contact form.')

    mail = ActionMailer::Base.deliveries.last
    assert_equal(['no-reply@internet.ee'], mail.from)
    assert_equal(['i-want-to-contact-you@domain.com'], mail.to)
    assert_equal('Email address confirmation', mail.subject)

    friendly_mail_body = mail.body.to_s
    expected_body = 'Please click the link below to confirm your email address and access the contact form.'
    expected_link = 'example.test/contact_request'
    expected_disclaimer = 'Link expires in 24 hours.'

    assert_match(expected_body,       friendly_mail_body)
    assert_match(expected_link,       friendly_mail_body)
    assert_match(expected_disclaimer, friendly_mail_body)
  end

  # Locale tests start here
  def test_en_locale_in_confirmation_form
    visit(new_contact_request_path(params: { domain_name: 'privatedomain.test' }))
    text = begin
      'You will receive an one time link to confirm your email, and then send a message to the owner or administrator ' \
      "of the domain. " \
      'The link expires in 24 hours.'
    end

    assert(has_link?(href: 'https://www.internet.ee/domains/eif-s-data-protection-policy'))
    assert_text(text)
  end

  def test_locale_switch_does_not_break_the_contact_form
    visit(new_contact_request_path(params: { domain_name: 'privatedomain.test' }))
    click_link_or_button('ET')

    assert(page.has_link?(href: 'https://www.internet.ee/domeenid/eis-i-isikuandmete-kasutamise-alused'))
  end

  def test_et_locale_in_confirmation_form
    visit(new_contact_request_path(params: { domain_name: 'privatedomain.test', locale: 'et' }))
    text = <<-TEXT.squish
    Saadame Teie sisestatud e-posti aadressile kinnituskirja, mis sisaldab ühekordset unikaalset
    linki. Link suunab teid kirja vormile, kust saate oma teate saata valitud .ee domeeni
    kontaktidele (domeeni omanik, haldus- ja tehniline kontakt).
    TEXT
    assert(has_link?(href: 'https://www.internet.ee/domeenid/eis-i-isikuandmete-kasutamise-alused'))
    assert_text(text)
  end

  def test_ru_locale_in_confirmation_form
    visit(new_contact_request_path(params: { domain_name: 'privatedomain.test', locale: 'ru' }))
    assert_text I18n.t('contact_requests.new.help', locale: :ru)
    # TODO: Fix the link when correct
    assert(has_link?(href: 'https://www.internet.ee/domains/eif-s-data-protection-policy'))
  end
end
