require "prawn"
class FormController < ApplicationController
  
  def privacy
  end
  
  def new
  end
  
  def submit
    form = Prawn::Document.new(:template => "template.pdf")
    form.text_box params[:month_of_claim], :at => [400, 269]
    form.text_box params[:first_name], :at => [90, 390]
    form.text_box params[:surname], :at => [90, 369]
    form.text_box params[:street_address], :at => [90, 345]
    form.text_box params[:suburb], :at => [90, 325]
    form.text_box params[:state], :at => [90, 304]
    if params[:postcode]
      form.text_box params[:postcode][0], :at => [252, 304] if params[:postcode][0]
      form.text_box params[:postcode][1], :at => [276, 304] if params[:postcode][1]
      form.text_box params[:postcode][2], :at => [298, 304] if params[:postcode][2]
      form.text_box params[:postcode][3], :at => [320, 304] if params[:postcode][3]
    end
    if params[:email]
      email_bits =  params[:email].split("@")
      form.text_box email_bits[0], :at => [90, 287] if email_bits[0]
      form.text_box email_bits[1], :at => [298, 287] if email_bits[1]
    end
    form.text_box params[:wk_phone], :at => [165, 269]
    form.text_box params[:hm_phone], :at => [165, 251]
    form.text_box params[:mobile], :at => [165, 234]
    if params[:myki_num]
      x = 90
      params[:myki_num].each_char do |num|
        form.text_box num, :at => [x, 202]
        x = x + 23
      end
    end
    if params[:pass_type_364]
       form.text_box "X", :at => [90, 181]
     end
    if params[:pass_type_365]
      form.text_box "X", :at => [90, 164]
    end
    
    form.image decode_image(params[:output]), :at => [33, 48], :scale => 0.6
    form.text_box Time.now.in_time_zone('Melbourne').strftime("%d/%m/%Y"), :at => [290, 39]
     
    send_data(form.render, :filename => "metrofill.pdf", :type => "application/pdf", :disposition => 'inline')
  end
  
  :private
  def decode_image data
    img = /data:image\/png;base64,(.*)/.match(data)[1]
    img = Base64.decode64(img)
    StringIO.new(img)
  end
end
