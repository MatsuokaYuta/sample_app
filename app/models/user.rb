class User < ApplicationRecord
    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true}
    # uniquenessは重複しないように
    validates :password, {presence: true}
end
