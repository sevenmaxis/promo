class Market
  include Mongoid::Document
  
  field :email,      			:type => String
  field :mobile, 		 			:type => String
  field :first_name, 			:type => String
  field :last_name,  			:type => String
  field :permission_type,	:type => String # one-time, permanent
  field :channel,					:type => String # sms, email, sms+email
  field :company_name,		:type => String 

  validates_presence_of :email, :mobile, :first_name, :last_name
  validates_presence_of :permission_type, :channel, :company_name

  validates_uniqueness_of :email

  validates_inclusion_of :permission_type, in: ['one-time', 'permanent']
  validates_inclusion_of :channel, in: ['sms', 'email', 'sms+email']
end