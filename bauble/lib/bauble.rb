# A simple sub-module system.  A bauble is
# a directory structure containing ruby code.
# A bauble named +myBauble+ should live in a
# directory named +myBauble+.  It's source
# code should live in +myBauble/lib+ just like
# a gem.  There should be a +lib/myBauble.rb+ file
# which is the root of the bauble.
#
# Users of the bauble will use it by saying
#
#  Bauble.use("myPath/myBauble")
#
# This will cause +myPath/myBauble/lib+ to be added to
# the +LOAD_PATH+ and will automatically require
# +myPath/myBauble/lib/myBauble.rb+
#

module Bauble
  def self.use(bauble)
    bauble_name = File.basename(bauble)
    ensure_in_path "#{bauble}/lib"
    require bauble_name
  end

  def self.ensure_in_path(path)
    $LOAD_PATH << path unless $LOAD_PATH.include? path
  end
end