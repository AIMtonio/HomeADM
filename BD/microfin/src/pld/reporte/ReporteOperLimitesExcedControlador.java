package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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

import pld.bean.OperLimExcedidosRepBean;
import pld.servicio.OperLimExcedidosRepServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ReporteOperLimitesExcedControlador extends AbstractCommandController {
	
	OperLimExcedidosRepServicio	operLimExcedidosRepServicio	= null;
	ParametrosSesionBean		parametrosSesionBean		= null;
	ParametrosSisServicio		parametrosSisServicio		= null;
	String						nomReporte					= null;
	String						successView					= null;
	protected final Logger		loggerSAFI					= Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		int	reportePDF		= 1;
		int	reporteExcel	= 2;
	}
	
	public ReporteOperLimitesExcedControlador() {
		setCommandClass(OperLimExcedidosRepBean.class);
		setCommandName("operLimExcedidosRepBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		OperLimExcedidosRepBean operLimExcedidosRepBean = (OperLimExcedidosRepBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		switch (tipoReporte) {
			case Enum_Con_TipRepor.reportePDF :
				ByteArrayOutputStream htmlStringPDF = limitesExcedidosRepPDF(tipoReporte, operLimExcedidosRepBean, nomReporte, response);
				break;
			case Enum_Con_TipRepor.reporteExcel :
				List listaReportes = limitesExcedidosRepExcel(tipoLista, operLimExcedidosRepBean, response);
				break;
		}
		
		return null;
	}
	
	/* Reporte de cuentas limite excento en PDF */
	public ByteArrayOutputStream limitesExcedidosRepPDF(int tipoReporte, OperLimExcedidosRepBean operLimExcedidosRepBean, String nomReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = operLimExcedidosRepServicio.reporteLimitesExced(tipoReporte, operLimExcedidosRepBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteOperacionesLimitesExcedidos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}// reporte PDF
	
	/* Reporte de cuentas limite excento en Excel */
	public List limitesExcedidosRepExcel(int tipoLista, OperLimExcedidosRepBean operLimExcedidosRepBean, HttpServletResponse response) {
		List listaLimitesExced = null;
		listaLimitesExced = operLimExcedidosRepServicio.listaReporte(tipoLista, operLimExcedidosRepBean, response);
		
		try {
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocaleCliente = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
			HSSFWorkbook libro = new HSSFWorkbook();
			HSSFFont fuente10 = libro.createFont();
			fuente10.setFontHeightInPoints((short) 10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short) HSSFCellStyle.ALIGN_RIGHT);
			
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
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			
			/* Crea la hoja y el nombre cuando se descar */
			HSSFSheet hoja = libro.createSheet("Reporte de Operaciones con Límites Excedidos");
			
			HSSFRow fila = hoja.createRow(0);
			HSSFCell celda1 = fila.createCell((short) 2);
			celda1.setCellValue(operLimExcedidosRepBean.getNombreInstitucion());
			celda1.setCellStyle(estiloDatosCentrado);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			0, //primera fila (0-based)
			0, //ultima fila  (0-based)
			2, //primer celda (0-based)
			7 //ultima celda   (0-based)
			));
			
			//HSSFCell celdaFec=fila.createCell((short)1);
			celda1 = fila.createCell((short) 8);
			celda1.setCellValue("Usuario:");
			celda1.setCellStyle(estiloNeg8);
			celda1 = fila.createCell((short) 9);
			celda1.setCellValue(operLimExcedidosRepBean.getNombreUsuario().toUpperCase());
			
			fila = hoja.createRow(1);
			HSSFCell celda = fila.createCell((short) 2);
			celda.setCellValue("REPORTE DE OPERACIONES CON LÍMITES EXCEDIDOS DEL " + operLimExcedidosRepBean.getFechaInicio() + " al " + operLimExcedidosRepBean.getFechaFin());
			celda.setCellStyle(estiloDatosCentrado);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			2, //primer celda (0-based)
			7 //ultima celda   (0-based)
			));
			celda = fila.createCell((short) 8);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short) 9);
			celda.setCellValue(operLimExcedidosRepBean.getFechaSistema());
			
			fila = hoja.createRow(2);
			Calendar calendario = new GregorianCalendar();
			int hora, minutos;
			hora = calendario.get(Calendar.HOUR_OF_DAY);
			minutos = calendario.get(Calendar.MINUTE);
			operLimExcedidosRepBean.setHoraEmision(hora + ":" + minutos);
			
			HSSFCell celdaHora = fila.createCell((short) 1);
			celdaHora = fila.createCell((short) 8);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short) 9);
			celdaHora.setCellValue(operLimExcedidosRepBean.getHoraEmision());
			
			fila = hoja.createRow(4);
			
			String monto = String.valueOf(operLimExcedidosRepBean.getMontoOp());
			String periodo = String.valueOf(operLimExcedidosRepBean.getPeriodo());
			if (periodo.equals("01")) {
				periodo = "ENERO";
			}
			if (periodo.equals("02")) {
				periodo = "FEBRERO";
			}
			if (periodo.equals("03")) {
				periodo = "MARZO";
			}
			if (periodo.equals("04")) {
				periodo = "ABRIL";
			}
			if (periodo.equals("05")) {
				periodo = "MAYO";
			}
			if (periodo.equals("06")) {
				periodo = "JUNIO";
			}
			if (periodo.equals("07")) {
				periodo = "JULIO";
			}
			if (periodo.equals("08")) {
				periodo = "AGOSTO";
			}
			if (periodo.equals("09")) {
				periodo = "SEPTIEMBRE";
			}
			if (periodo.equals("10")) {
				periodo = "OCTUBRE";
			}
			if (periodo.equals("11")) {
				periodo = "NOVIEMBRE";
			}
			if (periodo.equals("12")) {
				periodo = "DICIEMBRE";
			}
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short) 1);
			celda.setCellValue("Periodo:");
			celda.setCellStyle(estiloDatosCentrado);
			celda = fila.createCell((short) 2);
			celda.setCellValue(periodo);
			
			celda = fila.createCell((short) 3);
			celda.setCellValue("Monto Límite:");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short) 4);
			if(operLimExcedidosRepBean.getTipoPersona().equals("F")){
				operLimExcedidosRepBean.setMontoDes("FÍSICA");
			}else if(operLimExcedidosRepBean.getTipoPersona().equals("T")){
				operLimExcedidosRepBean.setMontoDes("FÍSICA_MORAL");
			}
			
			celda.setCellValue(operLimExcedidosRepBean.getMontoDes() + " - $" + monto);
			
			fila = hoja.createRow(7);//NUEVA FILA	
			celda = fila.createCell((short) 1);
			celda.setCellValue("Nombre del "+safilocaleCliente);
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short) 2);
			celda.setCellValue("No. Cuenta");
			celda.setCellStyle(estiloDatosCentrado);
			
			celda = fila.createCell((short) 3);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Descripción");
			
			celda = fila.createCell((short) 4);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Cargos");
			
			celda = fila.createCell((short) 5);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Abonos");
			
			celda = fila.createCell((short) 6);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Saldo Mensual");
			
			celda = fila.createCell((short) 7);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Sucursal");
			
			celda = fila.createCell((short) 8);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Fecha");
			
			celda = fila.createCell((short) 9);
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellValue("Número de Transacción");
			
			int i = 8, iter = 0;
			int tamanioLista = listaLimitesExced != null ? listaLimitesExced.size() : 0;
			OperLimExcedidosRepBean limitesExcedBean = null;
			for (iter = 0; iter < tamanioLista; iter++) {
				
				limitesExcedBean = (OperLimExcedidosRepBean) listaLimitesExced.get(iter);
				fila = hoja.createRow(i);
				
				celda = fila.createCell((short) 1);
				celda.setCellValue(limitesExcedBean.getNombreCliente());
				celda.setCellStyle(estilo10);
				
				celda = fila.createCell((short) 2);
				celda.setCellValue(limitesExcedBean.getCuentaAhoID());
				celda.setCellStyle(estilo10);
				
				celda = fila.createCell((short) 3);
				celda.setCellValue(limitesExcedBean.getDescripcionOp());
				celda.setCellStyle(estilo10);
				
				celda = fila.createCell((short) 4);
				celda.setCellValue("$" + limitesExcedBean.getCargo());
				celda.setCellStyle(estiloFormatoDecimal);
				celda.setCellStyle(estiloDatosDerecha);
				
				celda = fila.createCell((short) 5);
				celda.setCellValue("$" + limitesExcedBean.getAbono());
				celda.setCellStyle(estiloFormatoDecimal);
				celda.setCellStyle(estiloDatosDerecha);
				
				celda = fila.createCell((short) 6);
				celda.setCellValue("$" + limitesExcedBean.getSaldoMes());
				celda.setCellStyle(estiloFormatoDecimal);
				celda.setCellStyle(estiloDatosDerecha);
				
				celda = fila.createCell((short) 7);
				celda.setCellValue(limitesExcedBean.getNombreSucurs());
				celda.setCellStyle(estilo10);
				
				celda = fila.createCell((short) 8);
				celda.setCellValue(limitesExcedBean.getFecha());
				celda.setCellStyle(estilo10);
				
				celda = fila.createCell((short) 9);
				celda.setCellValue(limitesExcedBean.getNumTransaccion());
				celda.setCellStyle(estilo10);
				
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
			
			for (int celd = 0; celd <= 18; celd++)
				hoja.autoSizeColumn((short) celd);
			hoja.setColumnWidth(1, 12000); 
			hoja.setColumnWidth(3, 12000); 
			hoja.setColumnWidth(7, 9000); 
			//Crea la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteOperacionesLimiteExcedido.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return listaLimitesExced;
	}// reporte Excel
	
	public String getNomReporte() {
		return nomReporte;
	}
	
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public OperLimExcedidosRepServicio getOperLimExcedidosRepServicio() {
		return operLimExcedidosRepServicio;
	}
	
	public void setOperLimExcedidosRepServicio(OperLimExcedidosRepServicio operLimExcedidosRepServicio) {
		this.operLimExcedidosRepServicio = operLimExcedidosRepServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
}
