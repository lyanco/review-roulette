require "test_helper"

class EntryTest < ActiveSupport::TestCase
  def entry
    @entry ||= Entry.new
  end

  def setup
    @user = users(:lee)
    @entry = @user.entries.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "user id should be present" do
    @entry.user_id = nil
    assert_not @entry.valid?
  end

  test "content should be present" do
    @entry.content = "    "
    assert_not @entry.valid?
  end

end
