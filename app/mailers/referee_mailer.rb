class RefereeMailer < ActionMailer::Base

  default from: "TCBL <tcbl@waag.org>"

  %w(submitted approved rejected referee_approved more_info_needed more_info_added).each do |action|
    define_method("lab_#{action}") do |lab_id|
      begin
        @lab = Lab.find(lab_id)
        if @lab.referee_id
          @referee = @lab.referee
          users = (@referee.direct_admins + [@referee.creator]).compact.uniq
          users.each do |user|
            @user = user
            mail(to: user.email_string, subject: "[tcbl.eu] #{@lab} #{action.capitalize}")
          end
        end
      rescue ActiveRecord::RecordNotFound
      end
    end
  end
end
