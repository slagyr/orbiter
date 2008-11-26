module Start
  prop_reader :space

  def mouse_clicked(e)
    self.button.enabled = false
    space.start
  end
end