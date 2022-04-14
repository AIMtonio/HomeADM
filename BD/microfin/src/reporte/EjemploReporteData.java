package reporte;

import javax.swing.table.AbstractTableModel;

public class EjemploReporteData extends AbstractTableModel {
	  private static String[] COLUMN_NAMES = new String[] { "fruit", "number", "fruit" };

	  private static String[][] DATA = new String[][] { new String[] { "Apple", "One", "Apple" },
	      new String[] { "Apple", "Two", "Apple" }, new String[] { "Apple", "Three", "Apple" },
	      new String[] { "Orange", "Four", "Orange" }, new String[] { "Orange", "Five", "Orange" }, };

	  public int getRowCount() {
	    return DATA.length;
	  }

	  public int getColumnCount() {
	    return DATA[0].length;
	  }

	  public Object getValueAt(int rowIndex, int columnIndex) {
	    if (rowIndex >= 0 && rowIndex < DATA.length) {
	      if (columnIndex >= 0 && columnIndex < DATA[rowIndex].length) {
	        return DATA[rowIndex][columnIndex];
	      }
	    }
	    return null;
	  }

	  public String getColumnName(final int column) {
	    if (column >= 0 && column < COLUMN_NAMES.length) {
	      return COLUMN_NAMES[column];
	    }
	    return null;
	  }
}	  