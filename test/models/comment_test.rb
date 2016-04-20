require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def comment
    comment ||= Comment.new
  end

  def setup
    @user = users(:lee)
    @entry = entries(:entry2)
    @comment = @entry.comments.build(content: "Lorem ipsum", user_id: @user.id)
  end

  test 'should be valid' do
    assert @comment.valid?
  end

  test 'user id should be present' do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test 'entry id should be present' do
    @comment.entry_id = nil
    assert_not @comment.valid?
  end

  test 'content should be present' do
    @comment.content = '    '
    assert_not @comment.valid?
  end
end
