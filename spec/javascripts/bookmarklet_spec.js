describe("createEntry", function(){
    var post_url = "http://example.com/entries/create_api";

    it("should fail when content is empty", function() {
        spyOn(window, "alert");
        expect(createEntry("", "", "", "", "")).toBe(false);
        expect(window.alert).toHaveBeenCalled();
    });


    it("posts an entry object to provided url", function(){

        var obj = {
            "entry": {
                "content": "abcdefg",
                "api_data": {
                    "user_id": 1,
                    "auth_token": "password"
                }
            }
        };

        var xmlhttp = jasmine.createSpyObj('fakeXmlhttp', ['open', 'setRequestHeader', 'send']);

        createEntry(post_url, 1, "password", "abcdefg", xmlhttp);

        expect(xmlhttp.open).toHaveBeenCalledWith("POST", post_url);
        expect(xmlhttp.setRequestHeader).toHaveBeenCalledWith("Content-Type", "application/json;charset=UTF-8");
        expect(xmlhttp.setRequestHeader).toHaveBeenCalledWith("Accept", "application/json");
        expect(xmlhttp.send).toHaveBeenCalledWith(JSON.stringify(obj));
        expect(xmlhttp.onreadystatechange).toEqual(jasmine.any(Function));
    });

    describe("when xmlhttp.onreadystatechange", function(){
        var xmlhttp;

        beforeEach(function(){
            xmlhttp = {
                readyState: 4,
                status: 200,
                responseText: '{"thing": "hi"}',
                open: function () {
                },
                setRequestHeader: function () {
                },
                send: function () {
                }
            };

            createEntry(post_url, 1, "password", "i am the content", xmlhttp);
        });

        it("should succeed when readystate is 4, status is 200, and there is no status on responseText", function() {
            spyOn(console, 'log');
            xmlhttp.onreadystatechange();
            expect(console.log).toHaveBeenCalled();
        });

        it("should fail when status is not 200", function() {
            spyOn(console, 'log');
            xmlhttp.status = "moshe";
            xmlhttp.onreadystatechange();
            expect(console.log).toHaveBeenCalled();
        });

        it("should not do anything when readyState is not 4", function() {
            spyOn(console, 'log');
            xmlhttp.readyState = 3;
            xmlhttp.onreadystatechange();
            expect(console.log).not.toHaveBeenCalled();
        });
    });
});