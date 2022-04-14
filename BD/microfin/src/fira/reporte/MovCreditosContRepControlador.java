package fira.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.servicio.ParametrosSisServicio;
import credito.bean.CreditosBean;
import credito.bean.ReporteMovimientosCreditosBean;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;
import fira.servicio.CreditosAgroServicio;
import fira.servicio.CreditosAgroServicio.Enum_Lis_CredRep;

public class MovCreditosContRepControlador extends AbstractCommandController {
	
	ParametrosSisServicio	parametrosSisServicio	= null;
	CreditosAgroServicio	creditosAgroServicio	= null;
	MonedasServicio monedasServicio = null;
	String					nomReporte				= null;
	String					nomReporteSum			= null;
	String					successView				= null;
	
	
	public static interface Enum_Con_TipRepor {
		int	ReporPDF		= 1;
		int	ReporExcel		= 2;
	}
	public static interface Enum_Con_NivelDetall{
		int detallado = 1;
		int sumarizado = 2;
	}
	
	public MovCreditosContRepControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors){
		try {
			CreditosBean creditosBean = (CreditosBean) command;
			
			int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
			int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
			int nivelDetalle = Utileria.convierteEntero(request.getParameter("nivelDetalle"));
			switch (tipoReporte) {
				case Enum_Con_TipRepor.ReporPDF :
					reportePDFMovCredCont(request, response, creditosBean, nivelDetalle);
					break;
				case Enum_Con_TipRepor.ReporExcel :
					switch (nivelDetalle) {
						case Enum_Con_NivelDetall.detallado :
							movimientosCreditoExcel(tipoLista,creditosBean,response,request);
							break;
						case Enum_Con_NivelDetall.sumarizado :
							movimientosCreditosumExcel(tipoLista,creditosBean,response,request);
							break;
					}
					
					break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public ByteArrayOutputStream reportePDFMovCredCont(HttpServletRequest request, HttpServletResponse response, CreditosBean creditos, int nivelDetalle) {
		String reporteFinal = "";
		ByteArrayOutputStream htmlString = null;
		try {
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal, creditos.getMonedaID());
			creditos.setMonedaID(monedaBean.getDescriCorta());
			switch (nivelDetalle) {
				case Enum_Con_NivelDetall.detallado :
					reporteFinal = nomReporte;
					break;
				case Enum_Con_NivelDetall.sumarizado :
					reporteFinal = nomReporteSum;
					break;
			}
			htmlString = creditosAgroServicio.reporMovsCreditoPDF(creditos, reporteFinal);
			
			response.addHeader("Content-Disposition", "inline; filename=ReporteCreditosContMov.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlString.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return htmlString;
	}
	
	public List movimientosCreditosumExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response, HttpServletRequest request) {
		List listaCreditosSum = null;
		try {
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal, creditosBean.getMonedaID());
			creditosBean.setMonedaID(monedaBean.getDescriCorta());
			listaCreditosSum = creditosAgroServicio.listaReportesCreditos(Enum_Lis_CredRep.movimientosCredContSum, creditosBean, response);
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Rep_Movimientos_Credito_Contingente");
			HSSFRow fila = hoja.createRow(0);
			
			HSSFCell celdaUsu = fila.createCell((short) 0);
			celdaUsu.setCellStyle(estiloCentrado);
			celdaUsu.setCellValue(request.getParameter("nombreInstitucion"));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			0, //primera fila (0-based)
			0, //ultima fila  (0-based)
			0, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celdaUsu.setCellStyle(estiloCentrado);
			
			celdaUsu = fila.createCell((short) 9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);
			celdaUsu = fila.createCell((short) 10);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
			
			String fechaVar = creditosBean.getParFechaEmision();
			String numCuenta = "";
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String horaVar = postFormater.format(calendario.getTime());
			
			int itera = 0;
			ReporteMovimientosCreditosBean creditoHora = null;
			if (listaCreditosSum!= null && !listaCreditosSum.isEmpty()) {
				for (itera = 0; itera < 1; itera++) {
					creditoHora = (ReporteMovimientosCreditosBean) listaCreditosSum.get(itera);
					fechaVar = creditosBean.getParFechaEmision();
					numCuenta = creditoHora.getCuentaID();
				}
			}
			fila = hoja.createRow(1);
			HSSFCell celdaFec = fila.createCell((short) 1);
			celdaFec = fila.createCell((short) 9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short) 10);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celda = fila.createCell((short) 1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE MOVIMIENTOS DE PAGO POR CRÉDITO CONTINGENTE DEL " + creditosBean.getFechaInicio() + " AL " + creditosBean.getFechaVencimien());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			1, //primer celda (0-based)
			7 //ultima celda   (0-based)
			));
			celda.setCellStyle(estiloCentrado);
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora = fila.createCell((short) 1);
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(3);
			// celda titulo
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Crédito:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(creditosBean.getCreditoID());
			
			// Creacion de fila
			fila = hoja.createRow(4);
			//celda titulo
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Cuenta:");
			
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(numCuenta);
			
			celdaHora = fila.createCell((short) 3);
			celdaHora.setCellValue("Fecha Desembolso:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 4);
			celdaHora.setCellValue(request.getParameter("fechaMinistrado"));
			
			celdaHora = fila.createCell((short) 5);
			celdaHora.setCellValue("Monto Otorgado:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 6);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getMontoCredito()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			celdaHora = fila.createCell((short) 7);
			celdaHora.setCellValue("Moneda:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			
			celdaHora = fila.createCell((short) 8);
			celdaHora.setCellValue(creditosBean.getMonedaID());
			
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Producto:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(request.getParameter("producCreditoID"));
			celdaHora = fila.createCell((short) 11);
			celdaHora.setCellValue(request.getParameter("nombreProducto"));
			
			fila = hoja.createRow(5);
		
			//celda titulo 			
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Cliente:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(request.getParameter("clienteID"));
			celdaHora = fila.createCell((short) 3);
			celdaHora.setCellValue(request.getParameter("nombreCliente"));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			5, //primera fila (0-based)
			5, //ultima fila  (0-based)
			3, //primer celda (0-based)
			5 //ultima celda   (0-based)
			));
			
			celdaHora = fila.createCell((short) 7);
			celdaHora.setCellValue("Estatus:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 8);
			celdaHora.setCellValue(request.getParameter("estatus"));
			
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Saldo:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getAdeudoTotal()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			// Creacion de fila
			fila = hoja.createRow(7);
			//Inicio en la celda 1 con los encabezados
			celda = fila.createCell((short) 1);
			
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 2);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 3);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 4);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 5);
			celda.setCellValue("Interés Normal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 6);
			celda.setCellValue("IVA Interés Normal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 7);
			celda.setCellValue("Interés Moratorio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 8);
			celda.setCellValue("IVA Interés Moratorio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 9);
			celda.setCellValue("Comisión Falta Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 10);
			celda.setCellValue("IVA Comisiones");
			celda.setCellStyle(estiloNeg8);

			int tamanioLista = 0;
			int i = 8, iter = 0;
			if (listaCreditosSum != null) {
				tamanioLista = listaCreditosSum.size();
				ReporteMovimientosCreditosBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					
					credito = (ReporteMovimientosCreditosBean) listaCreditosSum.get(iter);
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short) 1);
					celda.setCellValue(credito.getFecha());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short) 2);
					celda.setCellValue(credito.getDescripcions());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short) 3);
					celda.setCellValue(credito.getMonto());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 4);
					celda.setCellValue(credito.getCapital());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getInteresNormal());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 6);
					celda.setCellValue(credito.getIvainteresNormal());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 7);
					celda.setCellValue(credito.getInteresMoratorio());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 8);
					celda.setCellValue(credito.getIvainteresMoratorio());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 9);
					celda.setCellValue(credito.getComisionFaltapago());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 10);
					celda.setCellValue(credito.getIvaComisiones());
					celda.setCellStyle(estiloFormatoDecimal);
					
					i++;
				}
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
			
			for (int celd = 0; celd <= 21; celd++)
				hoja.autoSizeColumn((short) celd);
			
			response.addHeader("Content-Disposition", "inline; filename=ReporteMovsCreditosContSum.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaCreditosSum;
		
	}
	public List movimientosCreditoExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response, HttpServletRequest request) {
		List listaCreditos = null;
		
		try {
			listaCreditos = creditosAgroServicio.listaReportesCreditos(Enum_Lis_CredRep.movCreditosCont, creditosBean, response);
			
			int regExport = 0;
			MonedasBean monedaBean = null;
			monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal, creditosBean.getMonedaID());
			creditosBean.setMonedaID(monedaBean.getDescriCorta());
			
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Rep_Movimientos_Credito_Contingente");
			HSSFRow fila = hoja.createRow(0);
			HSSFCell celdaUsu = fila.createCell((short) 1);
			celdaUsu.setCellValue(request.getParameter("nombreInstitucion"));
			celdaUsu.setCellStyle(estiloCentrado);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					0, //primera fila (0-based)
					0, //ultima fila  (0-based)
					1, //primer celda (0-based)
					7 //ultima celda   (0-based)
					));
			
			celdaUsu = fila.createCell((short) 9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);
			celdaUsu = fila.createCell((short) 10);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
			
			String fechaVar = creditosBean.getParFechaEmision();
			String numCuenta = "";
			
			int itera = 0;
			ReporteMovimientosCreditosBean creditoHora = null;
			if (listaCreditos != null && !listaCreditos.isEmpty()) {
				for (itera = 0; itera < 1; itera++) {
					creditoHora = (ReporteMovimientosCreditosBean) listaCreditos.get(itera);
					fechaVar = creditosBean.getParFechaEmision();
					numCuenta = creditoHora.getCuentaID();
				}
			}
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String horaVar = postFormater.format(calendario.getTime());
			fila = hoja.createRow(1);
			HSSFCell celdaFec = fila.createCell((short) 1);
			celdaFec = fila.createCell((short) 9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);
			celdaFec = fila.createCell((short) 10);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celda = fila.createCell((short) 1);
			celda.setCellStyle(estiloCentrado);
			celda.setCellValue("REPORTE DE MOVIMIENTOS POR CREDITO CONTINGENTE DEL " + creditosBean.getFechaInicio() + " AL " + creditosBean.getFechaVencimien());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			1, //primer celda (0-based)
			7 //ultima celda   (0-based)
			));
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora = fila.createCell((short) 1);
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(3);
			// celda titulo
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Cuenta:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(numCuenta);
			
			// Creacion de fila
			fila = hoja.createRow(4);
			//celda titulo
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Crédito:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(creditosBean.getCreditoID());
			
			celdaHora = fila.createCell((short) 3);
			celdaHora.setCellValue("Fecha Desembolso:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 4);
			celdaHora.setCellValue(request.getParameter("fechaMinistrado"));
			
			celdaHora = fila.createCell((short) 5);
			celdaHora.setCellValue("Monto Otorgado:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 6);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getMontoCredito()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			celdaHora = fila.createCell((short) 7);
			celdaHora.setCellValue("Moneda:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			
			celdaHora = fila.createCell((short) 8);
			celdaHora.setCellValue(creditosBean.getMonedaID());
			
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Producto:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(request.getParameter("producCreditoID"));
			celdaHora = fila.createCell((short) 11);
			celdaHora.setCellValue(request.getParameter("nombreProducto"));
			
			fila = hoja.createRow(5);
			//celda titulo 			
			celdaHora = fila.createCell((short) 1);
			celdaHora.setCellValue("No. Cliente:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 2);
			celdaHora.setCellValue(request.getParameter("clienteID"));
			celdaHora = fila.createCell((short) 3);
			celdaHora.setCellValue(request.getParameter("nombreCliente"));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			5, //primera fila (0-based)
			5, //ultima fila  (0-based)
			3, //primer celda (0-based)
			5 //ultima celda   (0-based)
			));
			
			celdaHora = fila.createCell((short) 7);
			celdaHora.setCellValue("Estatus:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 8);
			celdaHora.setCellValue(request.getParameter("estatus"));
			
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue("Saldo:");
			celdaHora.setCellStyle(estiloNeg8);
			// valor
			celdaHora = fila.createCell((short) 10);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getAdeudoTotal()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			// Creacion de fila
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			//Inicio en la celda 1 con los encabezados
			celda = fila.createCell((short) 1);
			
			celda.setCellValue("Amorti.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 2);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 3);
			celda.setCellValue("Hora");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 4);
			celda.setCellValue("Naturaleza");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 5);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 6);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 7);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 8);
			celda.setCellValue("Referencia");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) 9);
			celda.setCellValue("No. Transacción");
			celda.setCellStyle(estiloNeg8);
			
			int i = 8, iter = 0;
			int tamanioLista = 0;
			if (listaCreditos != null) {
				tamanioLista = listaCreditos.size();
				ReporteMovimientosCreditosBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					
					credito = (ReporteMovimientosCreditosBean) listaCreditos.get(iter);
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short) 1);
					celda.setCellValue(credito.getAmortiCreID());
					
					celda = fila.createCell((short) 2);
					celda.setCellValue(credito.getFechaOperacion());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short) 3);
					celda.setCellValue(credito.getHoraMov());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda = fila.createCell((short) 4);
					celda.setCellValue(credito.getNatMovimiento());
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Double.parseDouble(credito.getCantidad()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) 6);
					celda.setCellValue(credito.getTipoMov());
					
					celda = fila.createCell((short) 7);
					celda.setCellValue(credito.getDescripcion());
					
					celda = fila.createCell((short) 8);
					celda.setCellValue(credito.getReferencia());
					
					celda = fila.createCell((short) 9);
					celda.setCellValue(credito.getTransaccion());
					i++;
				}
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
			
			for (int celd = 0; celd <= 21; celd++)
				hoja.autoSizeColumn((short) celd);
			
			response.addHeader("Content-Disposition", "inline; filename=ReporteMovsCreditosCont.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaCreditos;
		
	}
	
	public String getNomReporte() {
		return nomReporte;
	}
	
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}
	
	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public CreditosAgroServicio getCreditosAgroServicio() {
		return creditosAgroServicio;
	}
	
	public void setCreditosAgroServicio(CreditosAgroServicio creditosAgroServicio) {
		this.creditosAgroServicio = creditosAgroServicio;
	}

	public String getNomReporteSum() {
		return nomReporteSum;
	}

	public void setNomReporteSum(String nomReporteSum) {
		this.nomReporteSum = nomReporteSum;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}
	
}