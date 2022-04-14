package tesoreria.reporte;

import herramientas.Utileria;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DivisasBean;
import tesoreria.servicio.DivisasServicio;

public class RepHistDivisasControlador extends AbstractCommandController{
	
	DivisasServicio divisasServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		int	EXCEL		= 1;
	}
	
	public RepHistDivisasControlador() {
		setCommandClass(DivisasBean.class);
		setCommandName("divisas");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		DivisasBean bean = (DivisasBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.EXCEL:
				reporteExcel(bean, request, response, tipoReporte);
				break;
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
	
	private List<DivisasBean> reporteExcel(DivisasBean bean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		
		List<DivisasBean> listaReporte = null;
		final String valorVacio = "";
		
		listaReporte = divisasServicio.listaReporte(bean, Enum_Con_TipRepor.EXCEL);
		
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
		String hora = postFormater.format(calendario.getTime());
		
		if (listaReporte != null) {
			try {
				SXSSFSheet hoja = null;
				Workbook libro = null;
				libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10 = libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short) 10);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita10Izq = libro.createFont();
				fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
				fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10Izq.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8 = libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short) 8);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				// Fuente encabezado del reporte
				Font fuenteEncabezado = libro.createFont();
				fuenteEncabezado.setFontHeightInPoints((short) 8);
				fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
				fuenteEncabezado.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente con tamaño 8 para informacion del reporte.
				Font fuente8 = libro.createFont();
				fuente8.setFontHeightInPoints((short) 8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente con tamaño 8 para informacion del reporte.
				Font fuente8izq = libro.createFont();
				fuente8izq.setFontHeightInPoints((short) 8);
				fuente8izq.setFontName(HSSFFont.FONT_ARIAL);
				
				Font fuente8Der = libro.createFont();
				fuente8izq.setFontHeightInPoints((short) 8);
				fuente8izq.setFontName(HSSFFont.FONT_ARIAL);

				Font fuente8Der2 = libro.createFont();
				fuente8Der2.setFontHeightInPoints((short) 8);
				fuente8Der2.setFontName(HSSFFont.FONT_ARIAL);
				
				Font fuente8Cuerpo = libro.createFont();
				fuente8Cuerpo.setFontHeightInPoints((short) 8);
				fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente con tamaño 8 para informacion del reporte.
				Font fuente10 = libro.createFont();
				fuente10.setFontHeightInPoints((short) 10);
				fuente10.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Alineado a la izq
				CellStyle estiloNeg10Izq = libro.createCellStyle();
				estiloNeg10Izq.setFont(fuenteNegrita10Izq);
				estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				// Estilo de datos centrados 
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteEncabezado);
				estiloCentrado.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				CellStyle estilo10 = libro.createCellStyle();
				estilo10.setFont(fuente10);
				
				CellStyle estilo8izq = libro.createCellStyle();
				estilo8izq.setFont(fuente8izq);
				estilo8izq.setAlignment(HSSFCellStyle.ALIGN_LEFT);
				
				CellStyle estilo8Der = libro.createCellStyle();
				estilo8Der.setFont(fuente8Der2);
				estilo8Der.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
				
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
				estiloFormatoDecimal.setFont(fuente8);
				
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
				DataFormat formatTit = libro.createDataFormat();
				estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
				estiloFormatoDecimalTit.setFont(fuenteNegrita8);
				
				// Creacion de hoja					
				hoja = (SXSSFSheet) libro.createSheet("Reporte Histórico de Divisas");
				
				// inicio fecha, usuario,institucion y hora
				Row fila = hoja.createRow(0);
				Cell celdaUsu = fila.createCell(9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg10Izq);
				celdaUsu = fila.createCell(10);
				celdaUsu.setCellValue(bean.getNomUsuario());
				
				fila = hoja.createRow(1);
				String fechaVar = bean.getFechaSistema().toString();
				Cell celdaFec = fila.createCell(9);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg10Izq);
				celdaFec = fila.createCell(10);
				celdaFec.setCellValue(fechaVar);
				
				Cell celdaInst = fila.createCell((short) 1);
				celdaInst.setCellValue(bean.getNomInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				1, //primera fila (0-based)
				1, //ultima fila  (0-based)
				1, //primer celda (0-based)
				8 //ultima celda   (0-based)
				));
				celdaInst.setCellStyle(estiloNeg10);
				
				fila = hoja.createRow(2);
				Cell celdaHora = fila.createCell(9);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg10Izq);
				celdaHora = fila.createCell(10);
				celdaHora.setCellValue(hora);
				
				// fin fecha usuario,institucion y hora
				Cell celda = fila.createCell((short) 1);
				celda.setCellValue("REPORTE HISTÓRICO DE DIVISAS DEL " + bean.getFechaInicio() + " AL " + bean.getFechaFinal());
				celda.setCellStyle(estiloNeg10);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				2, //primera fila (0-based)
				2, //ultima fila  (0-based)
				1, //primer celda (0-based)
				8 //ultima celda   (0-based)
				));
				celda.setCellStyle(estiloNeg10);
				
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short) 1);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Divisa:");
				
				celda = fila.createCell((short) 2);
				celda.setCellStyle(estilo10);
				celda.setCellValue(bean.getMonedaId() + " - " + bean.getDescripcion());
				
				celda = fila.createCell((short) 4);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Fecha de Inicio: ");
				
				celda = fila.createCell((short) 5);
				celda.setCellStyle(estilo10);
				celda.setCellValue(bean.getFechaInicio());
				
				celda = fila.createCell((short) 7);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Fecha Fin: ");
				
				celda = fila.createCell((short) 8);
				celda.setCellStyle(estilo10);
				celda.setCellValue(bean.getFechaFinal());
				
				fila = hoja.createRow(5);
				fila = hoja.createRow(6);
				
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				int numCelda = 0;
				celda = fila.createCell(numCelda);
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Registro");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Divisa");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Descripción");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nVentanilla Compra");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nVentanilla Venta");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nOperaciones Internas Compra");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nOperaciones Internas Venta");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nFix Compra");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio en\nFix Venta");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Cambio\nen DOF");
				hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				int tamanioLista = listaReporte.size();
				int i = 8;
				
				DivisasBean nivelBean = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					nivelBean = listaReporte.get(iter);
					numCelda = 0;
					fila = hoja.createRow(i);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getFechaRegistro());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getMonedaId());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getDescripcion());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamComVen());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamVenVen());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamComInt());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamVenInt());
					celda.setCellStyle(estilo8Der);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamFixCom());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamFixVen());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(nivelBean.getTipCamDof());
					celda.setCellStyle(estilo8Der);
					celda.getCellStyle().setFont(fuente8Der2);
					
					i++;
				}
				
				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				if(listaReporte!=null && listaReporte.size()>1){
				for (int celd = 0; celd <= 9; celd++) {
					hoja.autoSizeColumn(celd, true);
				}
				}
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				if(listaReporte!=null){
				celda.setCellValue(listaReporte.size());
				}
				
				celda.setCellStyle(estilo8);
				
				hoja.setColumnWidth(1,2500);
				
				response.addHeader("Content-Disposition", "inline; filename=HistoricoDivisas.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			
		}
		return listaReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public DivisasServicio getDivisasServicio() {
		return divisasServicio;
	}

	public void setDivisasServicio(DivisasServicio divisasServicio) {
		this.divisasServicio = divisasServicio;
	}

	
}
