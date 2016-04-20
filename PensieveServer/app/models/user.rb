class User < ActiveRecord::Base

  enum role: { patient: 0, family: 1 }
end
