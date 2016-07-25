# RAILS_ENV=production bundle exec rake admin:migrate
require 'open-uri'
namespace :admin do 
  desc "migrate users avatar_src from filestack.io to local carrier wave"
  task :migrate => :environment do
	User.all.each do | user |
	  migrate_user user['avatar_src'], user unless user['avatar_src'].blank?
	end

	Lab.all.each do | lab |
	  migrate_lab lab['avatar_src'], lab['header_image_src'], lab
	end

	Document.all.each do | document |
		migrate_document document.image.url, document
	end
  end
end

def migrate_document image_url, document
	if(image_url.blank? == false) && (image_url.start_with? 'http://tcbl2.s3-us-west-1.amazonaws.com')
		open('migrated.jpg', 'wb') do | file |
			file << open(image_url).read
		    
		    #upload the file to the document
		    attachment = ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "migrated_document_image" , type: "image/jpg")
			document.image_src = attachment
			document.save!
		end
	end
end

def migrate_lab avatar_url, header_url, lab
  
  if (avatar_url.blank? == false) && (avatar_url.start_with? 'https://cdn.filepicker.io')
	open('migrated.jpg', 'wb') do |file|
     
     		file << open(avatar_url).read
     
     		#upload the file to the lab 
     		attachment = ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "migrated_lab_avatar", type: "image/jpg")
     		lab.avatar_src = attachment
     		lab.save!	
  	end
  end

  if (header_url.blank? == false) && (header_url.start_with? 'https://cdn.filepicker.io')
	open('migrated.jpg', 'wb') do |file|
     
     		file << open(header_url).read
     
     		#upload the file to the lab 
     		attachment = ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "migrated_lab_avatar", type: "image/jpg")
     		lab.header_image_src = attachment
     		lab.save!	
  	end
  end

end

# migrate the image of one user, by downloading the url
# and uploading it back to the user
def migrate_user url, user
 
  # make sure the url contains file stack
  return unless url.start_with? 'https://cdn.filepicker.io'

  open('migrated.jpg', 'wb') do |file|
     
     file << open(url).read
     
     #upload the file to the user
     attachment = ActionDispatch::Http::UploadedFile.new(tempfile: file, filename: "migrated", type: "image/jpg")
     user.avatar_src = attachment
     user.save!	
  end
end
