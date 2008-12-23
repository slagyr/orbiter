toolbar do
  start :id=>"start", :players=>"button", :text=>"Start"
  stop  :players=>"button", :text=>"Stop"
  zoom_in :players=>"button", :text=>"+", :width=>60
  zoom_out :players=>"button", :text=>"-", :width=>40
end

space :id=>"space"