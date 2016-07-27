class Picture < ActiveRecord::Base
  belongs_to :user

  def upload(tempfile)
    File.open("app/public/images/user_#{user_id}/#{name}", "w") do |f|
      f.write(tempfile.read)
    end
  end

  def self.slugify(string)
    string.gsub(" ", "-")
  end

  def proportional_crop
    ratio = self.ratio.split(":").map{|x| x.to_f}
    current_dimensions = FastImage.size("app/public/images/user_#{user_id}/#{name}")
    if ratio[0] < ratio[1]
      new_dimensions = [((ratio[0]/ratio[1]) * current_dimensions[1]), current_dimensions[1]]
    else new_dimensions = [current_dimensions[0], ((ratio[1]/ratio[0]) * current_dimensions[0])]
    end
  end

  def remove
    File.delete("app/public/images/user_#{user_id}/#{name}")
    Picture.find(id).delete
  end


end
