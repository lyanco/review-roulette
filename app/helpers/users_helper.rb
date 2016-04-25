module UsersHelper

  def generate_bookmarklet(user)
    #Note: bookmarklet caps at 4096 chars. this is fine for now, but may need to refactor if we wanna get fancy
    #TODO: make post_url variable
    script = '(function() {

      function getSelectionText() {
          var text = "";
          if (window.getSelection) {
              text = window.getSelection().toString();
          } else if (document.selection && document.selection.type != "Control") {
              text = document.selection.createRange().text;
          }
          return text;
      }

      var post_url = "' + root_url + 'entries/create_api";
      var user_id = ' + user.id.to_s + ';
      var encrypted_password = "' + user.encrypted_password + '";

      var content = getSelectionText();
      if (content === "") {
          alert("Highlight text to create an entry");
          return;
      }

      var obj = {
          "entry": {
              "content": content,
              "api_data": {
                  "user_id": user_id,
                  "auth_token": encrypted_password
              }
          }
      };

      var xmlhttp = new XMLHttpRequest();
      xmlhttp.onreadystatechange = function () {
          if (xmlhttp.readyState === 4 & xmlhttp.status === 200 && !JSON.parse(xmlhttp.responseText).status ) {
              console.log(xmlhttp.responseText);
              alert("Posted a new entry: " + content);
          } else if (xmlhttp.readyState === 4) {
              alert("Failed to post new entry.");
          }
      };
      xmlhttp.open("POST", post_url);
      xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xmlhttp.send(JSON.stringify(obj));
    })()'
    script.squish
  end

end
