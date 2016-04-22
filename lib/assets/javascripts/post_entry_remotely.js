(function() {
    var post_url = "http://localhost:3000/entries/create_api";
    var user_id = 1;
    var encrypted_password = "$2a$10$T3q8kcV31IDFlgTL2cYn4uxHBqzJyQELGLfRCNC3xd8h04eApVt3i";

    var content = document.getElementById("outputbox").innerHTML;

    var obj = {
        "entry": {
            "content": content, "api_data": {
                "user_id": user_id,
                "auth_token": encrypted_password
            }
        }
    };

    var xmlhttp = new XMLHttpRequest();   // new HttpRequest instance
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState === 4 & xmlhttp.status === 200 && !JSON.parse(xmlhttp.responseText).status ) {
            console.log(xmlhttp.responseText);
            alert('Posted a new entry: ' + content);
        } else if (xmlhttp.readyState === 4 & xmlhttp.status !== 200) {
            alert('Failed to post new entry.');
        }
    };
    xmlhttp.open("POST", post_url);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify(obj));
})();