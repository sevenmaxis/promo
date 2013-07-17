require 'spec_helper'

describe Market do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  
  it { should validate_presence_of(:mobile) }
  
  it { should validate_presence_of(:first_name) }
  
  it { should validate_presence_of(:last_name) }
  
  it { should validate_presence_of(:permission_type) }
  it { should validate_inclusion_of(:permission_type).to_allow("one-time", "permanent") }

  it { should validate_presence_of(:channel) }
  it { should validate_inclusion_of(:channel).to_allow('sms', 'email', 'sms+email') }

  it { should validate_presence_of(:company_name) }
 end