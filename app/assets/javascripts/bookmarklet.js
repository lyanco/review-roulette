function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

function createEntry(post_url, user_id, encrypted_password, content) {
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
            console.log(xmlhttp.responseText);
            alert("Failed to post new entry.");
        }
    };
    xmlhttp.open("POST", post_url);
    xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    xmlhttp.send(JSON.stringify(obj));
}
