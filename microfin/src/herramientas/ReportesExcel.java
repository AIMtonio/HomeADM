package herramientas;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReportesExcel {

	// Formato Excel
	public static int tamanioTexto = 10;
	public static String Arial = "Arial";

	// Fuentes para los reportes utilizados en excel
	public static short FUENTE_BOLD 		= XSSFFont.BOLDWEIGHT_BOLD;
	public static short FUENTE_NOBOLD		= XSSFFont.BOLDWEIGHT_NORMAL;
	public static short FUENTE_CENTRADA		= XSSFCellStyle.ALIGN_CENTER;
	public static short FUENTE_IZQUIERDA	= XSSFCellStyle.ALIGN_LEFT;
	public static short FUENTE_DERECHA		= XSSFCellStyle.ALIGN_RIGHT;

	public static interface FormatoEstilosExcel {
		String Moneda			= "$#,##0.00";
		String Decimal			= "0.00";
		String TasaFijaMoneda	= "$#,##0.0000";
		String TasaFija 		= "0.0000";
		String TasaFija8Decimal	= "0.00000000";
	}

	public static String horaSistema(){
		Calendar calendario=new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
		return postFormater.format(calendario.getTime());
	}
	
	//Metodo utilizado en para reportes en excel
	/**
	 * Método que asigna el estilo de Titulo a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloTitulo(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloTitulo(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_BOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setAlignment(FUENTE_CENTRADA);
		return xssfCellStyle;
	}

	// Estilo Centrado Tipografia Arial, Alineacion Centrada, Fuente Negrita
	/**
	 * Método que asigna el estilo de Cabecera a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloCabecera(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloCabecera(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_BOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setAlignment(FUENTE_CENTRADA);
		return xssfCellStyle;
	}

	// Estilo Parametros Tipografia Arial, Alineacion Izquierda, Fuente Negrita
	/**
	 * Método que asigna el estilo de Parámetro a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloParametros(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloParametros(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_BOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setAlignment(FUENTE_IZQUIERDA);
		return xssfCellStyle;
	}

	// Estilo Texto Tipografia Arial, Alineacion Izquierda
	/**
	 * Método que asigna el estilo de texto simple a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloTexto(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloTexto(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setAlignment(FUENTE_IZQUIERDA);
		return xssfCellStyle;
	}

	// Estilo Texto Centrado Tipografia Arial, Alineacion centrada
	/**
	 * Método que asigna el estilo de texto centrado a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloTextoCentrado(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloTextoCentrado(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setAlignment(FUENTE_CENTRADA);
		return xssfCellStyle;
	}

	// Estilo Decimal Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo de Moneda("$#,##0.00") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloMoneda(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloMoneda(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.Moneda));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Decimal sin Comas Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo Decimal("0.00") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloDecimal(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloDecimal(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.Decimal));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Moneda Negrita sin Comas Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo de Moneda Negrita("$#,##0.00") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloMonedaNegrita(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloMonedaNegrita(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_BOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.Moneda));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Decimal sin Comas en Negrita Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo Decimal Negrita("0.00") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloDecimalNegrita(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloDecimalNegrita(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_BOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.Decimal));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Tasa Fija Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo Tasa("$#,##0.0000") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloTasa(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloTasa(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.TasaFija));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	public static XSSFCellStyle estiloTasa8Decimales(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.TasaFija8Decimal));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Tasa Fija Moneda Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo Tasa Decimal ("0.0000") a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloTasaDecimal(libro));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 **/
	public static XSSFCellStyle estiloTasaDecimal(XSSFWorkbook xssfWorkbook){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)tamanioTexto);
		xssfFont.setFontName(Arial);
		xssfFont.setBoldweight(FUENTE_NOBOLD);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
		xssfCellStyle.setFont(xssfFont);
		xssfCellStyle.setDataFormat(formatodecimal.getFormat(FormatoEstilosExcel.TasaFijaMoneda));
		xssfCellStyle.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);

		return xssfCellStyle;
	}

	// Estilo Tasa Fija Moneda Tipografia Arial, Alineacion Derecha
	/**
	 * Método que asigna el estilo personalizado a las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * celda.setCellStyle(Utileria.estiloPersonalizado(libro, "Arial", 10, ReportesExcel.FUENTE_IZQUIERDA, XSSFFont.BOLDWEIGHT_BOLD, "0.00"));
	 * @param xssfWorkbook : libro de Excel al cual se le asigna el estilo
	 * @param fontName : fuente de Excel
	 * @param fontHeightInPoints : número de letra
	 * @param alignment : alineación del estilo. Alineacion Centrada(ReportesExcel.FUENTE_CENTRADA), Alineacion Izquierda (ReportesExcel.FUENTE_IZQUIERDA), Alineacion Derecha (ReportesExcel.FUENTE_DERECHA)
	 * @param boldweight : Texto en Negrita(ReportesExcel.FUENTE_BOLD), Texto Simple (ReportesExcel.BOLDWEIGHT_NORMAL)
	 * @param format : formato asignado a la celda
	 **/
	public static XSSFCellStyle estiloPersonalizado(XSSFWorkbook xssfWorkbook, String fontName, int fontHeightInPoints, short alignment, short boldweight, String format){
		XSSFFont xssfFont = xssfWorkbook.createFont();
		xssfFont.setFontHeightInPoints((short)fontHeightInPoints);
		xssfFont.setFontName(fontName);
		xssfFont.setBoldweight(boldweight);

		XSSFCellStyle xssfCellStyle = xssfWorkbook.createCellStyle();
		xssfCellStyle.setFont(xssfFont);
		if(!format.equals(Constantes.STRING_VACIO) ){
			XSSFDataFormat formatodecimal = xssfWorkbook.createDataFormat();
			xssfCellStyle.setDataFormat(formatodecimal.getFormat(format));
		}
		xssfCellStyle.setAlignment((short)alignment);

		return xssfCellStyle;
	}

	// AutoAjustado de columnas
	/**
	 * Método que realiza el AutoAjuste de las <b>Celdas de Excel</b> usando la librería XSSFWorkbook.<br>
	 * <b>Ejemplo:</b><br>
	 * ReportesExcel.autoAjusteColumnas(Utileria.estiloPersonalizado(libro, 10, XSSFCellStyle.ALIGN_RIGHT));
	 * @param numeroColumnas : número de Columnas a Ajustar
	 * @param xssfSheet : celda a ajustar
	 **/
    public static void autoAjusteColumnas(int numeroColumnas, XSSFSheet xssfSheet) {
    	try{
	        for (int celda = 0; celda <= numeroColumnas; celda++) {
	        	xssfSheet.autoSizeColumn(celda);
	        }
    	}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
    	}
    }

}
