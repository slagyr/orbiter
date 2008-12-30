toolbar do
  start :id=>"start", :players=>"button", :text=>"Start"
  stop  :players=>"button", :text=>"Stop"
  zoom_in :players=>"button", :text=>"+"
  zoom_out :players=>"button", :text=>"-"
end

space :id=>"space"