class RefereeMailer < ActionMailer::Base

  default from: "TCBL <tcbl@waag.org>"

  %w(submitted approved rejected removed referee_approved referee_requested_admin_approval referee_rejected requested_more_info more_info_added).each do |action|
    define_method("lab_#{action}") do |lab_id|
      begin
        @lab = Lab.find(lab_id)
        if @lab.referee_id
          @referee = @lab.referee
          users = (@referee.direct_admins + [@referee.creator]).compact.uniq
          users.each do |user|
            @user = user
            mail(to: user.email_string, subject: "[labs.tcbl.eu] #{@lab} #{action.capitalize}")
          end
        elsif @lab.referee_approval_processes
          # send 1 email to all refs at the same time
          referees = @lab.referee_approval_processes.map{|process| process.referee_lab}
          users = referees.map{|ref| (ref.direct_admins + [ref.creator]).compact.uniq}.flatten
          recipients = users.map{|user| user.email_string}

          puts "sending lab_#{action} mail to #{recipients.join ','} for lab: #{@lab}"
          mail(to: recipients, subject: "[labs.tcbl.eu] #{@lab} #{action.capitalize}")
        end
      rescue ActiveRecord::RecordNotFound
      end
    end
  end
end
