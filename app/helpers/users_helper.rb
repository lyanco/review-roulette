module UsersHelper

  def generate_bookmarklet(user)
    #Note: bookmarklet caps at 4096 chars. this is fine for now, but may need to refactor if we wanna get fancy

    variables = '
      var post_url = "' + root_url + 'entries/create_api";
      var user_id = ' + user.id.to_s + ';
      var encrypted_password = "' + user.encrypted_password + '";
      '

    script = '(function() { ' +
      variables +
      File.read(Rails.root + 'app/assets/javascripts/bookmarklet.js') +
      'createEntry(post_url, user_id, encrypted_password); ' +
      '})()'

    script.squish
  end

end






