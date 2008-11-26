module Stop
  prop_reader :space, :start

  def mouse_clicked(e)
    start.button.enabled = true
    space.stop
  end

end
