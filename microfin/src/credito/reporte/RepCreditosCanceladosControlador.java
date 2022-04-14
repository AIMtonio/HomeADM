package credito.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;
import credito.bean.CartasFiniquitoBean;
import credito.bean.CreditosBean;
import credito.reporte.RepSaldosCartAvalesRefControlador.Enum_Con_TipRepor;
import credito.servicio.CreditosServicio;

public class RepCreditosCanceladosControlador extends AbstractCommandController {
	
	CreditosServicio		creditosServicio		= null;
	String					successView				= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	
	public RepCreditosCanceladosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		
		switch (tipoReporte) {
			case Enum_Con_TipRepor.ReporExcel :
				reporteExcel(tipoLista, creditosBean, response);
				break;
		}
		return null;
	}
	
	private List<CreditosBean> reporteExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		
		List listaCreditos = null;
		listaCreditos = creditosServicio.listaReportesCreditos(tipoLista, creditosBean, response);
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		
		String safilocaleCliente = "safilocale.cliente";
		safilocaleCliente = Utileria.generaLocale(safilocaleCliente, parametrosSisBean.getNombreCortoInst());
		
		if (listaCreditos != null) {
			try {
				
				SXSSFWorkbook libro = new SXSSFWorkbook(100);
				
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10 = libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short) 10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8 = libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short) 8);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita82 = libro.createFont();
				fuenteNegrita82.setFontHeightInPoints((short) 8);
				fuenteNegrita82.setFontName("Arial");
				fuenteNegrita82.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short) CellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				CellStyle estiloNeg8Left = libro.createCellStyle();
				estiloNeg8Left.setFont(fuenteNegrita82);
				
				//Estilo negrita de 8  y color de fondo
				CellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
				
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
				
				// Creacion de hoja
				Sheet hoja = null;
				hoja = libro.createSheet("Reporte Analítico Cartera");
				
				Row fila = hoja.createRow(0);
				
				Cell celdaini = fila.createCell((short) 1);
				celdaini = fila.createCell((short) 11);
				celdaini.setCellValue("Usuario:");
				celdaini.setCellStyle(estiloNeg8Left);
				celdaini = fila.createCell((short) 12);
				celdaini.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
				
				String fechaVar = creditosBean.getParFechaEmision();
				
				Calendar calendario = new GregorianCalendar();
				SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
				String horaVar = postFormater.format(calendario.getTime());
				
				fila = hoja.createRow(1);
				
				Cell celdafin = fila.createCell((short) 11);
				celdafin.setCellValue("Fecha:");
				celdafin.setCellStyle(estiloNeg8Left);
				celdafin = fila.createCell((short) 12);
				celdafin.setCellValue(fechaVar);
				
				Cell celdaInst = fila.createCell((short) 0);
				celdaInst.setCellValue(creditosBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				1, //primera fila (0-based)
				1, //ultima fila  (0-based)
				0, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaInst.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(2);
				Cell celda = fila.createCell((short) 1);
				celda = fila.createCell((short) 11);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8Left);
				celda = fila.createCell((short) 12);
				celda.setCellValue(horaVar);
				
				Cell celdaR = fila.createCell((short) 0);
				celdaR.setCellValue("REPORTE DE CRÉDITOS CANCELADOS DEL " + creditosBean.getFechaInicio() + " AL " + creditosBean.getFechaFinal());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				2, //primera fila (0-based)
				2, //ultima fila  (0-based)
				0, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaR.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(3); // Fila vacia
				fila = hoja.createRow(4);// Campos
				celda = fila.createCell((short) 1);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNeg8Left);
				celda = fila.createCell((short) 2);
				celda.setCellValue((!creditosBean.getNombreSucursal().equals("0") ? creditosBean.getNombreSucursal() : "TODAS"));
				
				celda = fila.createCell((short) 4);
				celda.setCellValue("Producto Crédito:");
				celda.setCellStyle(estiloNeg8Left);
				celda = fila.createCell((short) 5);
				celda.setCellValue((!creditosBean.getNombreProducto().equals("0") ? creditosBean.getNombreProducto() : "TODOS"));
				
				// Creacion de fila
				fila = hoja.createRow(6);
				fila = hoja.createRow(7);
				int numCelda = 0;
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Crédito");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Grupo");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre Grupo");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Número Cliente");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Producto Crédito");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre del Producto");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto Crédito Cancelado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha de Cancelación");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Motivo de Cancelación");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Póliza de Cancelación");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Usuario de Cancelación");
				celda.setCellStyle(estiloNeg8);
				
				/*Auto Ajusto las Comulmnas*/
				Utileria.autoAjustaColumnas(12, hoja);
				
				int i = 8, iter = 0;
				int tamanioLista = listaCreditos.size();
				CreditosBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					credito = (CreditosBean) listaCreditos.get(iter);
					fila = hoja.createRow(i);
					numCelda = 0;
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteLong(credito.getCreditoID()));
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getGrupoID());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreGrupo());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getClienteID());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreCliente());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getProducCreditoID());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreProducto());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreSucursal());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaCancel());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getMotivoCancel());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getPolizaID());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreUsuario());
					
					i++;
				}
				
				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i + 1;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue(tamanioLista);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition", "inline; filename=RepCancelacionesCredito-" + creditosBean.getFechaInicio() + "_" + creditosBean.getFechaFinal() + ".xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return listaCreditos;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
}
