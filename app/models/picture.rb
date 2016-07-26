class Picture < ActiveRecord::Base
  belongs_to :user

  def upload(tempfile)
    File.open("app/public/images/user_#{user_id}/" + name, "w") do |f|
      f.write(tempfile.read)
    end
    path = "/images/user_#{user_id}/#{name}"
  end

  def self.slugify(string)
    string.gsub(" ", "-")
  end

  def proportional_crop
    ratio = self.ratio.split(":").map{|x| x.to_f}
    current_dimensions = FastImage.size("app/public/images/user_#{user_id}/#{name}")
    unit = current_dimensions[0] / ratio[0]
    new_dimensions = [(ratio[0] * unit), (ratio[1] * unit)]
  end


end
