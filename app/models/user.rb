class User < ApplicationRecord
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	VALID_PHONE_REGEX = /\d[0-9]\)*\z/
	
	validates :name, presence: true, length:{maximum: 50}
  	validates :email, 
		  			presence: true, 
		  			length: { maximum: 255 },
		            format: { with: VALID_EMAIL_REGEX },
		            uniqueness: { case_sensitive: false }
  	validates :phone, 
		  			presence: true, 
		  			length: { minimum: 10, maximum: 11 },
		            uniqueness: { case_sensitive: false },
					format: { with: VALID_PHONE_REGEX , message: "only positive number without spaces are allowed"}
	validates :address, presence: true, length:{maximum: 255}
	validates :password, presence: true, length: { minimum: 6 }
	#callbacks
	before_save   :downcase_email

	mount_uploader :picture, PictureUploader
	has_secure_password
	
	private

	def downcase_email
		self.email = email.downcase
	end
end
