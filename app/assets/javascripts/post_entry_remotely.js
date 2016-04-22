
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
        if (xmlhttp.readyState == 4) {
            console.log(xmlhttp.responseText);
        }
    };
    xmlhttp.open("POST", post_url);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify(obj));
})();