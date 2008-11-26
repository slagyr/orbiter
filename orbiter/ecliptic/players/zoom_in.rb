module ZoomIn
  prop_reader :space

  def mouse_clicked(e)
    space.clear_screen
    space.zoom_in
  end

end