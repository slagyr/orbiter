module ZoomOut
  prop_reader :space

  def mouse_clicked(e)
    space.clear_screen
    space.zoom_out
  end

end