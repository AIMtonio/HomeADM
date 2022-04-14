package fira.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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
import credito.bean.CreditosBean;
import fira.servicio.CreditosAgroServicio;

public class SaldosTotalesRepControlador extends AbstractCommandController {
	
	ParametrosSisServicio	parametrosSisServicio	= null;
	CreditosAgroServicio	creditosAgroServicio	= null;
	String					nomReporte				= null;
	String					successView				= null;
	
	public static interface Enum_Con_TipRepor {
		int	ReporPantalla	= 1;
		int	ReporPDF		= 2;
		int	ReporExcel		= 3;
	}
	
	public SaldosTotalesRepControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		String htmlString = "";
		
		switch (tipoReporte) {
		
			case Enum_Con_TipRepor.ReporPantalla :
				htmlString = creditosAgroServicio.reporteSaldosTotalesCredito(creditosBean, nomReporte);
				break;
			
			case Enum_Con_TipRepor.ReporPDF :
				ByteArrayOutputStream htmlStringPDF = SaldosTotalesCreditoPDF(creditosBean, nomReporte, response);
				break;
			
			case Enum_Con_TipRepor.ReporExcel :
				List<CreditosBean> listaReportes = SaldosTotalesCreditoExcel(tipoLista, creditosBean, response);
				break;
		}
		
		if (tipoReporte == CreditosBean.ReporPantalla) {
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		} else {
			return null;
		}
		
	}
	
	// Reporte de saldos totales de credito en pdf
	public ByteArrayOutputStream SaldosTotalesCreditoPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosAgroServicio.reporteSaldosTotalesCreditoPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=analiticoCartera.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	
	// Reporte de saldos totales de credito en excel
	public List SaldosTotalesCreditoExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		listaCreditos = creditosAgroServicio.listaReportesCreditos(tipoLista, creditosBean, response);
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		
		String safilocaleCliente = "safilocale.cliente";
		safilocaleCliente = Utileria.generaLocale(safilocaleCliente, parametrosSisBean.getNombreCortoInst());
		boolean mostrarSeguroCuota = false;
		if (listaCreditos.size() > 0) {
			CreditosBean cre = (CreditosBean) listaCreditos.get(0);
			mostrarSeguroCuota = cre.getCobraSeguroCuota().equals("S");
		}
		
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
				celdaini = fila.createCell((short) 15);
				celdaini.setCellValue("Usuario:");
				celdaini.setCellStyle(estiloNeg8);
				celdaini = fila.createCell((short) 16);
				celdaini.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
				
				String horaVar = "";
				String fechaVar = creditosBean.getParFechaEmision();
				
				int itera = 0;
				CreditosBean creditoHora = null;
				if (!listaCreditos.isEmpty()) {
					for (itera = 0; itera < 1; itera++) {
						
						creditoHora = (CreditosBean) listaCreditos.get(itera);
						horaVar = creditoHora.getHora();
						fechaVar = creditoHora.getFecha();
					}
				}
				
				fila = hoja.createRow(1);
				
				Cell celdafin = fila.createCell((short) 15);
				celdafin.setCellValue("Fecha:");
				celdafin.setCellStyle(estiloNeg8);
				celdafin = fila.createCell((short) 16);
				celdafin.setCellValue(fechaVar);
				
				Cell celdaInst = fila.createCell((short) 1);
				celdaInst = fila.createCell((short) 7);
				celdaInst.setCellValue(creditosBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				1, //primera fila (0-based)
				1, //ultima fila  (0-based)
				7, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaInst.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(2);
				Cell celda = fila.createCell((short) 1);
				celda = fila.createCell((short) 15);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 16);
				celda.setCellValue(horaVar);
				
				Cell celdaR = fila.createCell((short) 2);
				celdaR = fila.createCell((short) 7);
				celdaR.setCellValue("REPORTE ANALÍTICO CARTERA DEL " + creditosBean.getFechaInicio());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				2, //primera fila (0-based)
				2, //ultima fila  (0-based)
				7, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaR.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(3); // Fila vacia
				fila = hoja.createRow(4);// Campos
				celda = fila.createCell((short) 1);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 2);
				celda.setCellValue((!creditosBean.getNombreSucursal().equals("0") ? creditosBean.getNombreSucursal() : "TODAS"));
				
				celda = fila.createCell((short) 4);
				celda.setCellValue("Producto Crédito:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 5);
				celda.setCellValue((!creditosBean.getNombreProducto().equals("0") ? creditosBean.getNombreProducto() : "TODOS"));
				
				celda = fila.createCell((short) 7);
				celda.setCellValue("Género:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 8);
				celda.setCellValue((!creditosBean.getNombreGenero().equals("0") ? creditosBean.getNombreGenero() : "TODOS"));
				
				celda = fila.createCell((short) 10);
				celda.setCellValue("Municipio:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 11);
				celda.setCellValue((!creditosBean.getNombreMuni().equals("") ? creditosBean.getNombreMuni() : "TODOS"));
				
				celda = fila.createCell((short) 13);
				celda.setCellValue("Días de Atraso Inicial:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 14);
				celda.setCellValue((!creditosBean.getAtrasoInicial().isEmpty()) ? creditosBean.getAtrasoInicial() : "0");
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short) 1);
				celda.setCellValue("Moneda:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 2);
				celda.setCellValue((!creditosBean.getNombreMoneda().equals("0") ? creditosBean.getNombreMoneda() : "TODAS"));
				
				celda = fila.createCell((short) 4);
				celda.setCellValue("Promotor:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 5);
				celda.setCellValue((!creditosBean.getNombrePromotorI().equals("") ? creditosBean.getNombrePromotorI() : "TODOS"));
				
				celda = fila.createCell((short) 7);
				celda.setCellValue("Estado:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 8);
				celda.setCellValue((!creditosBean.getNombreEstado().equals("") ? creditosBean.getNombreEstado() : "TODOS"));
				
				celda = fila.createCell((short) 10);
				celda.setCellValue("Clasificación:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 11);
				celda.setCellValue((!creditosBean.getClasificacion().equals("0") ? creditosBean.getClasificacion() : "TODAS"));
				
				celda = fila.createCell((short) 13);
				celda.setCellValue("Días de Atraso Final:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 14);
				celda.setCellValue((!creditosBean.getAtrasoFinal().isEmpty()) ? creditosBean.getAtrasoFinal() : "99999");
				
				// Creacion de fila
				fila = hoja.createRow(6);
				fila = hoja.createRow(7);
				int numCelda = 0;
				//Inicio en la segunda f
				celda = fila.createCell(numCelda++);//0
				celda.setCellValue("ID Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Producto de crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Descripción de Producto");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue(safilocaleCliente + " ID");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre " + safilocaleCliente);
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Destino");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Crédito Pasivo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fuente de Fondeo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Acreditado FIRA");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Crédito Fondeador");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Garantía");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Clase de Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Rama");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha de Otorgamiento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha próximo vencimiento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto próximo vencimiento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Actividad");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cadena");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Programa Especial");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo Persona");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Porcentaje Comisión por Apertura");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Concepto de inversión (principal)");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Número de Unidades");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Unidad de Medida");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Grupo Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre Grupo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Desembolso");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Último Abono Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto del Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Periodicidad Capital");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Periodicidad Interés");//10
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//
				celda.setCellValue("Formula");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//
				celda.setCellValue("Tasa");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fuente de fondeo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);// Folio Fondeo
				celda.setCellValue("Folio Fondeo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Días de Atraso");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Disponible Cuenta");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//15
				celda.setCellValue("Saldo Bloqueado Cuenta");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha de Último Depósito Cuenta");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("No Gestor de Cobranza");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre Gestor de Cobranza");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Vigente");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Capital Vigente Exigible");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Atrasado");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Vencido");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.VenNoExi");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Provision");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//25
				celda.setCellValue("Int.Atrasado");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Vencido");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.NoCont.");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Moratorios");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Com.Fal.Pag");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//30
				celda.setCellValue("OtrasComis");
				celda.setCellStyle(estiloNeg8);
				
				if (mostrarSeguroCuota) {
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Monto Seg.Cuota");
					celda.setCellStyle(estiloNeg8);
				}
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto Total Exigible");//
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA.Int.Pagado");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA.Mora.Pagado");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVACom.Fal.Pag");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//35
				celda.setCellValue("IVA Otras.Com.Pagada");
				celda.setCellStyle(estiloNeg8);
				
				if (mostrarSeguroCuota) {
					celda = fila.createCell(numCelda++);
					celda.setCellValue("IVA Seg.Cuota");
					celda.setCellStyle(estiloNeg8);
				}
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Atras.Hoy");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Venc.Hoy");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.VNE.Hoy");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Atras.Hoy");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//40
				celda.setCellValue("Int.Venc.Hoy");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cap.Regular.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Ord.Dev.");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Mor.Dev");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Com.Fal.Pag.Dev");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//45
				celda.setCellValue("PagoCap.Vig.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoCap.Atras.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoCap.Venc.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoCap.VNE.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoInt.Ord.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//50
				celda.setCellValue("PagoInt.Atras.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoInt.Venc.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoInt.NCont.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoInt.Comis.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("PagoMorat.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//55
				celda.setCellValue("PagoIVA.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Int.Condonado.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Morat.Condonado.Día");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IntDevCtaOrden");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("CapCondonadoDia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);//60
				celda.setCellValue("ComAdmonPagDia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ComCondonadoDia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("DesembolsosDia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Moratorio Vencido");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++); //64
				celda.setCellValue("Moratorio Car.Vencida");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Cap.Vigente Pasivo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Cap. Atrasado Pasivo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Interés Vigente Pasivo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Interés Atrasado Pasivo");
				celda.setCellStyle(estiloNeg8);
				if(Utileria.convierteEntero(creditosBean.getSucursal())==0){
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Sucursal");
					celda.setCellStyle(estiloNeg8);
				}
				
				/*Auto Ajusto las Comulmnas*/
				Utileria.autoAjustaColumnas(63, hoja);
				
				int i = 8, iter = 0;
				int tamanioLista = listaCreditos.size();
				CreditosBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					credito = (CreditosBean) listaCreditos.get(iter);
					if (iter == 0) {
						mostrarSeguroCuota = credito.getCobraSeguroCuota().contentEquals("S");
					}
					fila = hoja.createRow(i);
					numCelda = 0;
					
					celda = fila.createCell(numCelda++);//0
					celda.setCellValue(Utileria.convierteLong(credito.getCreditoID()));
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getProducCreditoID());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getDescripcion());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getClienteID());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreCliente());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getDesDestino());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoFondeoID());

					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFuenteFondeo());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getAcreditadoIDFIRA());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoIDFIRA());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getTipoGarantia());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getClaseCredito());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getDescripcionRamaFIRA());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaOtorgamiento());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaProxVenc());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoProxVenc()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getActividadDes());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNomCadenaProdSCIAN());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getEstatus());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getSubPrograma());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getTipoPersona());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPorcComision()));
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getConceptoInv());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNumeroUnidades());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getUnidadesMedida());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getGrupoID());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreGrupo());
					

					celda = fila.createCell(numCelda++);//5
					celda.setCellValue(credito.getFechaInicio());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaVencimiento());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaUltAbonoCre());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFrecuenciaCap());
					
					celda = fila.createCell(numCelda++);//10
					celda.setCellValue(credito.getFrecuenciaInt());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFormula());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getTasaFija());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFuenteFondeo());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFolioFondeo());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getDiasAtraso());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoDispon()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//15
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoBloq()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaUltDepCta());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getPromotorID());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombrePromotor());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapVigent()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//20
					celda.setCellValue(Utileria.convierteDoble(credito.getCapVigenteExi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapAtrasad()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldCapVenNoExi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInterProvi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInterAtras()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInterVenc()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoIntNoConta()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoMoratorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoComFaltPago()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//30
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoOtrasComis()));
					celda.setCellStyle(estiloFormatoDecimal);
					if (mostrarSeguroCuota) {
						celda = fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(credito.getMontoSeguroCuota()));
						celda.setCellStyle(estiloFormatoDecimal);
					}
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoTotalExi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoIVAInteres()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoIVAMorator()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalIVAComFalPag()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//35
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoIVAComisi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					if (mostrarSeguroCuota) {
						celda = fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(credito.getiVASeguroCuota()));
						celda.setCellStyle(estiloFormatoDecimal);
					}
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPasoCapAtraDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPasoCapVenDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPasoCapVNEDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPasoIntAtraDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//40
					celda.setCellValue(Utileria.convierteDoble(credito.getPasoIntVenDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getCapRegularizado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIntOrdDevengado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIntMorDevengado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getComisiDevengado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//45
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoCapVigDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoCapAtrDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoCapVenDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoCapVenNexDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoIntOrdDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//50
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoIntAtrDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoIntVenDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoIntCalNoCon()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoComisiDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoMoratorios()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//55
					celda.setCellValue(Utileria.convierteDoble(credito.getPagoIvaDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIntCondonadoDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMorCondonadoDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIntDevCtaOrden()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getCapCondonadoDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);//60
					celda.setCellValue(Utileria.convierteDoble(credito.getComAdmonPagDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getComCondonadoDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getDesembolsosDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMoraVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMoraCarVen()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapVigentePas()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapAtrasadPas()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInteresProPas()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInteresAtraPas()));
					celda.setCellStyle(estiloFormatoDecimal);
					if(Utileria.convierteEntero(creditosBean.getSucursal())==0){
						celda = fila.createCell(numCelda++);
						celda.setCellValue(credito.getNombreSucursal());
					}
					
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
				response.addHeader("Content-Disposition", "inline; filename=RepAnaliticoCarteraAgro-" + creditosBean.getFechaInicio() + ".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				//	log.info("Termina Reporte");
			} catch (Exception e) {
				//	log.info("Error al crear el reporte: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
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
	
}