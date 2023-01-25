HTMLWidgets.widget({

  name: 'rplatemap',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    var platemap = $(el);


    // TODO: code to render the widget, e.g.
    
    return {
      renderValue: function(x) {
        let attributes = 
        platemap.plateMap({
          numRows: x.nrow,
          numCols: x.ncol,
          readOnly: x.readOnly,
          attributes: x.attributes,
          updateWells: function(event, data) {
            Shiny.setInputValue(el.id, data.getPlate());
          },
          selectedWells: function(event, selectedWell) {
            console.log('selected: ' + selectedWell.selectedAddress);
          }
        });
        platemap.plateMap("loadPlate", x.data);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
