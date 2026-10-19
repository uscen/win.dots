local function setup()
  Header.redraw = function() return {} end

  local old_root_layout = Root.layout
  Root.layout = function(self)
    local tabs = Tabbar or Tabs

    self._chunks = ui.Layout()
        :direction(ui.Layout.VERTICAL)
        :constraints({
          ui.Constraint.Length(0),
          ui.Constraint.Length(tabs.height()),
          ui.Constraint.Fill(1),
          ui.Constraint.Length(1),
        })
        :split(self._area)
  end

  if Tabbar then
    local old_tabbar_redraw = Tabbar.redraw
    Tabbar.redraw = function(self)
      if #cx.tabs == 1 then return {} end
      return old_tabbar_redraw(self)
    end
  end
end

return { setup = setup }
