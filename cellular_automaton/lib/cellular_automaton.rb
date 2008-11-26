require 'helper'
require 'cell_panel.rb'

class CellularAutomaton
  def initialize
    @mutex = Mutex.new
    @swing_is_running = ConditionVariable.new
    @cellPanel = CellPanel.new
  end

  def title(title)
    @title = title
  end

  def world_size(xcells, ycells)
    @xcells = xcells;
    @ycells = ycells;
  end

  def cell_size(cell_size)
    @cell_size = cell_size
  end

  def clear_screen_each_step(clear_screen)
    @clear_screen = clear_screen
  end

  def world(world_class)
    @world_class = world_class
  end

  def makeFrame
    @frame = JFrame.new @title
    @frame.set_size(@xcells*@cell_size, @ycells*@cell_size)
    @frame.default_close_operation = JFrame::EXIT_ON_CLOSE

    @cellPanel.init(@xcells, @ycells, @cell_size, @clear_screen, @world_class)

    @frame.add @cellPanel

    @frame.show
    @swing_is_running.signal
  end

  def wait_for_swing_to_start_running
    @mutex.synchronize do
      @swing_is_running.wait(@mutex)
    end
  end

  def run
    wait_for_swing_to_start_running
    while (true)
      @frame.repaint
      Thread.yield
    end
  end

  def self.start(&proc)
    frame = CellularAutomaton.new
    frame.instance_eval(&proc)
    javax.swing.SwingUtilities.invokeLater(proc {frame.makeFrame})
    frame.run
  end
end

