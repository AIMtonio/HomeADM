package aportaciones.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import aportaciones.bean.AportacionesBean;
import aportaciones.reporte.RepVencimientoAportacionControlador.Enum_Con_TipRepor;
import aportaciones.servicio.AportacionesServicio;

public class RepAportPorIniciarControlador extends AbstractCommandController{
	
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	AportacionesServicio aportacionesServicio = null;
	String nombreReporte = null;
	String successView   = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF   = 2 ;
		  int  ReporExcel = 3 ;
	}
	
	public RepAportPorIniciarControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesPorIniciar");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		AportacionesBean aportacionesBean=(AportacionesBean) command;
		
		int tipoReporte=(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;	
		
		switch(tipoReporte){
		  case Enum_Con_TipRepor.ReporPDF:
			  ByteArrayOutputStream htmlStringPDF = AportacionesPorIniciar(aportacionesBean, nombreReporte, response,request);
		  break;
			
		  case Enum_Con_TipRepor.ReporExcel:
			  List listaAportPorIniciar= listaReporteAportacionesPorIniciar(tipoLista,aportacionesBean, response);
		  break;
		}
		
		return null;
	}
	
	// MÉTODO PARA CREAR EL REPORTE EN EXCEL
	public List listaReporteAportacionesPorIniciar(int tipoLista,AportacionesBean aportacionesBean, HttpServletResponse response){
		List listaAportPorIniciar=null;
	
		listaAportPorIniciar= aportacionesServicio.lista(tipoLista, aportacionesBean);
	 
		try {
			HSSFWorkbook libro = new HSSFWorkbook();

			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);
			
			//Estilo de datos centrados Encabezado
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

			//Estilo Formato Moneda (0.00)
			HSSFCellStyle estiloMoneda = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloMoneda.setDataFormat(format.getFormat("$#,##0.00"));
			
			//Estilo Formato de Tasa (0.0000)
			HSSFCellStyle estiloTasa = libro.createCellStyle();
			HSSFDataFormat formatTasa = libro.createDataFormat();
			estiloTasa.setDataFormat(formatTasa.getFormat("#,##0.0000"));

			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFCellStyle estiloIzquierda = libro.createCellStyle();
			estiloIzquierda.setFont(fuente10);
			estiloIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloIzquierda.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			HSSFCellStyle estiloCentradoCuerpo = libro.createCellStyle();
			estiloCentradoCuerpo.setFont(fuente10);
			estiloCentradoCuerpo.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentradoCuerpo.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Aportaciones por Iniciar");
			
		  	// inicio fecha, usuario,institucion y hora
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celdaUsu=fila.createCell(1);
			celdaUsu = fila.createCell(11);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell(12);
			celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = parametrosSesionBean.getFechaAplicacion().toString();
		  	HSSFCell celdaFec=fila.createCell(1);
		  	celdaFec = fila.createCell(11);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell(12);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celdaInst=fila.createCell(1);
			celdaInst=fila.createCell(1);
			celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			 celdaInst.setCellStyle(estiloDatosCentrado);	
			 
			 
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm:ss");	
			String horaVar=postFormater.format(calendario.getTime());
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell(1);
			celdaHora = fila.createCell(11);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell(12);
			celdaHora.setCellValue(horaVar);
			// fin fecha usuario,institucion y hora
			
			String fechaIni = aportacionesBean.getFechaInicio().toString();
			String fechaFin = aportacionesBean.getFechaVencimiento().toString();
			
			HSSFCell celda=fila.createCell(1);
			celda = fila.createCell(1);
			celda.setCellValue("REPORTE DE APORTACIONES CON FECHA DE INICIO POSTERIOR DEL " + fechaIni +" AL "+fechaFin);
			celda.setCellStyle(estiloDatosCentrado);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            10 //ultima celda   (0-based)
		    ));
			celda.setCellStyle(estiloDatosCentrado);				

			fila = hoja.createRow(4);

			int numCelda = 1;
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Cliente:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getNombreCliente());

			
			numCelda=numCelda+4;
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell(numCelda++);
			celda.setCellValue(aportacionesBean.getNombreSucursal());
			
			// Creacion de fila
			fila = hoja.createRow(5);
			fila = hoja.createRow(6);

			numCelda = 1;
			// Encabezado de la tabla 
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Aportación");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Promotor");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Número de Cliente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Plazo (Días)");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Fecha Inicio");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Fecha Vencimiento");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Monto Inicial");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tasa");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Interés por Pagar");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("ISR a Retener");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Tipo de Pago");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Capitalizable");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("Motivo");
			celda.setCellStyle(estiloCentrado);
			
			int numFila = 7, iter = 0;
			int tamanioLista = listaAportPorIniciar.size();
			AportacionesBean resultadoAportaciones = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				numCelda = 1;
				resultadoAportaciones = (AportacionesBean) listaAportPorIniciar.get(iter);
				fila=hoja.createRow(numFila);

				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getAportacionID());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getNombrePromotor());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getClienteID());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getNombreCliente());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getPlazo());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getFechaInicio());
				celda.setCellStyle(estiloCentradoCuerpo);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getFechaVencimiento());
				celda.setCellStyle(estiloCentradoCuerpo);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getMonto()));
				celda.setCellStyle(estiloMoneda);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getTasaFija()));
				celda.setCellStyle(estiloTasa);
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getInteresRecibir()));
				celda.setCellStyle(estiloMoneda); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(Utileria.convierteDoble(resultadoAportaciones.getInteresRetener()));
				celda.setCellStyle(estiloMoneda); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getTipoPagoInt());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getCapitaliza()); 
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getEstatus());
				
				celda=fila.createCell(numCelda++);
				celda.setCellValue(resultadoAportaciones.getMotivoCancela());

				numFila ++;
			}
			
			fila=hoja.createRow(numFila++);
			celda = fila.createCell(0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);

			fila=hoja.createRow(numFila++);
			celda=fila.createCell(0);
			celda.setCellValue(tamanioLista);
			
			for(int celd=0; celd<=numCelda; celd++){
				hoja.autoSizeColumn((short)celd); 
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=AportacionesPorIniciar.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		} catch (Exception e){
			e.printStackTrace();
		}
	    
	    return listaAportPorIniciar;
		
	}
	
	//método para crear el reporte en pdf
	private ByteArrayOutputStream AportacionesPorIniciar(AportacionesBean aportacionBean, String nombreReporte, HttpServletResponse response, HttpServletRequest request) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionesServicio.aportacionesPorIniciarPDF(aportacionBean, nombreReporte, request);
			response.addHeader("Content-Disposition","inline; filename=AportacionesPorIniciar.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
}
