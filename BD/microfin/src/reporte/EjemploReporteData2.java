package reporte;

import javax.swing.table.AbstractTableModel;

public class EjemploReporteData2 extends AbstractTableModel {
	  private static String[] COLUMN_NAMES = new String[] { "fruit", "number", "fruit" };

	  private static String[][] DATA = new String[][] { new String[] { "Apple", "NOL", "Apple" },
	      new String[] { "Apple", "DBA", "Apple" }, new String[] { "Apple", "TRI", "Apple" },
	      new String[] { "Orange", "CHITIRIE", "Orange" }, new String[] { "Orange", "PIAT", "Orange" }, };

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
