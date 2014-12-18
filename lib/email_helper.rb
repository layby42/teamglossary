module EmailHelper
  def self.font_family_style
    %q{font-family: 'Helvetica', 'Arial', 'Verdana', 'Trebuchet MS', sans-serif;}
  end

  def self.title
    %Q{
        #{EmailHelper.font_family_style}
        font-size: 18px;
        font-weight: 600;
        color: #FFFFFF;
        margin: 20px 0 20px 0;
      }
  end

  def self.p_style
    %Q{
        #{EmailHelper.font_family_style}
        font-size: 16px;
        font-weight: 100;
        margin: 20px 0 20px 0;
      }
  end

  def self.h3_style
    %Q{
        #{EmailHelper.font_family_style}
        font-size: 24px;
        line-height: 36px;
        font-weight: bold;
        padding: 0 20px 0 20px;
        margin: 20px 0 20px 0;
    }
  end
end
