Premailer::Rails.config.merge!(link_query_string: 'from=f10m001')

class UserMailer < ActionMailer::Base

  default from: "labs.tcbl.eu <noreply@labs.tcbl.eu>"

  %w(submitted approved rejected removed referee_requested_admin_approval referee_rejected referee_approved requested_more_info more_info_added more_info_needed).each do |action|
    define_method("lab_#{action}") do |lab_id|
      begin
        @lab = Lab.find(lab_id)
        users = (@lab.direct_admins + [@lab.creator]).compact.uniq
        users.each do |user|
          @user = user
          mail(to: @user.email_string, subject: "[#{@lab}] #{action.capitalize}")
        end
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def lab_reset lab
    begin
      users = (lab.direct_admins + [lab.creator]).compact.uniq
      users.each do |user|
        @user = user
        mail(to: @user.email_string, subject: "[#{lab}] Lab has been reset, please read on")
      end
    rescue ActiveRecord::RecordNotFound
    end
  end

  def employee_approved employee_id
    begin
      @employee = Employee.find(employee_id)
      @user = @employee.user
      mail(to: @user.email_string, subject: "[#{@employee.lab}] Employee Application Approval")
    rescue ActiveRecord::RecordNotFound
    end
  end

  def welcome user_id
    begin
      @user = User.find(user_id)
      mail(to: @user.email_string, subject: "Account Confirmation Instructions")
    rescue ActiveRecord::RecordNotFound
    end
  end

  def verification user_id
    begin
      @user = User.find(user_id)
      mail(to: @user.email_string, from: "labs.tcbl.eu <noreply@labs.tcbl.eu>", subject: "Email Verification Instructions")
    rescue ActiveRecord::RecordNotFound
    end
  end

  def account_recovery_instructions user_id
    begin
      @user = User.find(user_id)
      mail(to: @user.email_string, from: "labs.tcbl.eu <noreply@labs.tcbl.eu>", subject: "Account Recovery Instructions")
    rescue ActiveRecord::RecordNotFound
    end
  end

end
