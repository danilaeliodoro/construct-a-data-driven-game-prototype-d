require 'json'
require 'gtk3'

class OxrsConstructADat < Gtk::Window
  def initialize
    super('Data-Driven Game Prototype Dashboard')

    set_default_size(800, 600)
    set_window_position(Gtk::WindowPosition::CENTER)

    @dashboard_view = Gtk::Box.new(Gtk::Orientation::VERTICAL, 0)
    add(@dashboard_view)

    @games_list = Gtk::ListStore.new(String)
    @games_treeview = Gtk::TreeView.new(@games_list)
    @games_treeview.selection.signal_connect('changed') do |selection|
      selected_game = selection.selected
      if selected_game
        game_data = load_game_data(selected_game[0].text)
        update_dashboard(game_data)
      end
    end

    @dashboard_view.pack_start(@games_treeview, expand: true, fill: true, padding: 0)

    @game_properties = Gtk::Table.new(2, 2, homogeneous: true)
    @dashboard_view.pack_start(@game_properties, expand: false, fill: true, padding: 0)

    populate_games_list

    signal_connect('destroy') do
      Gtk.main_quit
    end

    show_all
  end

  private

  def populate_games_list
    games = %w[Game1 Game2 Game3]
    games.each do |game|
      iter = @games_list.append
      iter[0] = game
    end
  end

  def load_game_data(game_name)
    data = {
      'Game1' => {
        name: 'Game 1',
        description: 'This is Game 1',
        genres: %w[Action Adventure],
        rating: 4.5
      },
      'Game2' => {
        name: 'Game 2',
        description: 'This is Game 2',
        genres: %w[Strategy Simulation],
        rating: 4.2
      },
      'Game3' => {
        name: 'Game 3',
        description: 'This is Game 3',
        genres: %w[RPG Sports],
        rating: 4.8
      }
    }[game_name]

    data
  end

  def update_dashboard(game_data)
    @game_properties.foreach_child do |child|
      child.destroy
    end

    row = 0
    game_data.each do |key, value|
      label = Gtk::Label.new(key.to_s)
      @game_properties.attach(label, 0, 1, row, row + 1, 0, 0, 0, 0)
      label = Gtk::Label.new(value.to_s)
      @game_properties.attach(label, 1, 2, row, row + 1, 0, 0, 0, 0)
      row += 1
    end
  end
end

Gtk.init
OxrsConstructADat.new
Gtk.main