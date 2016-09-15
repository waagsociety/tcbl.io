class AdminMailer < ActionMailer::Base

  default from: "TCBL <noreply@labs.tcbl.eu>"

  def lab_submitted lab_id
    begin
      @lab = Lab.find(lab_id)
      mail(subject: "[#{@lab}] submitted", to: User.admin_emails)
    rescue ActiveRecord::RecordNotFound
    end
  end

  def lab_referee_approved lab_id
    begin
      @lab = Lab.find(lab_id)
      mail(subject: "[#{@lab}] approved by reference lab", to: User.admin_emails)
    rescue ActiveRecord::RecordNotFound
    end  
  end

  def employee_applied employee_id
    begin
      @employee = Employee.find(employee_id)
      # @employee.lab.admins.compact.uniq.each do |admin|
      # @admin = admin
      mail(to: @employee.lab.admins.map(&:email).compact.uniq, subject: "[#{@employee.lab}] Employee Application")
      # end
    rescue ActiveRecord::RecordNotFound
    end
  end

end
