require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  describe "password encryption" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end
      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end
      
      describe "has_password? method" do

            it "should be true if the passwords match" do
              @user.has_password?(@attr[:password]).should be_true
            end    

            it "should be false if the passwords don't match" do
              @user.has_password?("invalid").should be_false
            end 
          end
      
          describe "authenticate method" do

                it "should return nil on email/password mismatch" do
                  wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
                  wrong_password_user.should be_nil
                end

                it "should return nil for an email address with no user" do
                  nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
                  nonexistent_user.should be_nil
                end

                it "should return the user on email/password match" do
                  matching_user = User.authenticate(@attr[:email], @attr[:password])
                  matching_user.should == @user
                end
              end
      
    end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
  
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end


    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  describe "admin attribute" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should respond to admin" do
        @user.should respond_to(:admin)
      end

      it "should not be an admin by default" do
        @user.should_not be_admin
      end

      it "should be convertible to an admin" do
        @user.toggle!(:admin)
        @user.should be_admin
      end
    end
    describe "micropost associations" do

        before(:each) do
          @user = User.create(@attr)
          @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
          @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
        end

        it "should have a microposts attribute" do
          @user.should respond_to(:microposts)
        end

        it "should have the right microposts in the right order" do
          @user.microposts.should == [@mp2, @mp1]
        end
      end
      
      describe "micropost associations" do

          before(:each) do
            @user = User.create(@attr)
            @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
            @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
          end
          .
          .
          .
          it "should destroy associated microposts" do
            @user.destroy
            [@mp1, @mp2].each do |micropost|
              Micropost.find_by_id(micropost.id).should be_nil
            end
          end
        end
end
