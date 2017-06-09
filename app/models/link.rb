class HttpUrlValidator < ActiveModel::EachValidator

	def self.compliant?(value)
		uri = URI.parse(value)
		uri.is_a?(URI::HTTP) && !uri.host.nil?
	rescue URI::InvalidURIError
		false
	end

	def validate_each(record, attribute, value)
		unless value.present? && self.class.compliant?(value)
			record.errors.add(attribute, "is not a valid HTTP URL")
		end
	end

end

class Link < ActiveRecord::Base
	belongs_to :linkable, polymorphic: true, touch: true
	# validates_presence_of :lab
	validates_presence_of :url
	validates_uniqueness_of :url, scope: [:linkable_id, :linkable_type]
	validates :url, http_url: true
	#validates_format_of :url, with: URI::regexp(%w(http https))
	before_validation :add_http

	scope :twitter_urls, -> { where("url ~* 'twitter.com/'").map(&:url) }

	private

	def add_http
		self.url = "http://#{url}" if url.present? and !url.match(/^http/) and !url.match(/^https/)
	end

end
