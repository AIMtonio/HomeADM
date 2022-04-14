package ventanilla.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.ReporteRemitentesUsuarioBean;
import ventanilla.servicio.ReporteRemitentesUsuarioServicio;

public class RepRemitentesUsuarioControlador extends AbstractCommandController{
	
	ReporteRemitentesUsuarioServicio reporteRemitentesUsuarioServicio = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RepRemitentesUsuarioControlador(){
 		setCommandClass(ReporteRemitentesUsuarioBean.class);
 		setCommandName("reporteRemitentesUsuarioBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {

		ReporteRemitentesUsuarioBean reporteRemitentesUsuarioBean = (ReporteRemitentesUsuarioBean) command;

		String htmlString = "";
		List listaReporteRemi;
		try {							
			listaReporteRemi = reporteRemitentesExcel(reporteRemitentesUsuarioBean, response);															
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List reporteRemitentesExcel(ReporteRemitentesUsuarioBean reporteRemitentesUsuarioBean,HttpServletResponse response){
		List <ReporteRemitentesUsuarioBean> listaRepRemi  = null;
		listaRepRemi = reporteRemitentesUsuarioServicio.listaReporteRemitentes(reporteRemitentesUsuarioBean);
		Calendar calendario = new GregorianCalendar();
		try {
			Workbook libro = new SXSSFWorkbook();
				// Se crea una Fuente Negrita 	con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNeg8= libro.createFont();
				fuenteNeg8.setFontHeightInPoints((short)8);
				fuenteNeg8.setFontName("Arial");
				fuenteNeg8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Estilo negrita de 10 para encabezados del reporte
				XSSFCellStyle estiloNeg10 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				// Estilo de datos centrado en la información del reporte
				XSSFCellStyle estiloDatosCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER); 
				
				// Estrilo centrado fuente negrita 10
				XSSFCellStyle estiloCentrado10 = (XSSFCellStyle) libro.createCellStyle();			
				estiloCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado10.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado10.setFont(fuenteNegrita10);
				
				// Estilo centrado fuente negrita 8
				XSSFCellStyle estiloCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado.setWrapText(true);
				
				// Estilo centrado fuente  8
				XSSFCellStyle estiloCentra = (XSSFCellStyle) libro.createCellStyle();
				estiloCentra.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentra.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentra.setWrapText(true);
				
				// Estilo derecho fuente  8
				XSSFCellStyle estiloDerecho = (XSSFCellStyle) libro.createCellStyle();
				estiloDerecho.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloDerecho.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloDerecho.setWrapText(true);
				
				// Estilo negrita de 8 para encabezados del reporte
				XSSFCellStyle estiloNeg8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloNegro8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNegro8.setFont(fuenteNeg8);
				
				// Estilo negrita de 8  y color de fondo
				XSSFCellStyle estiloColor = (XSSFCellStyle) libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				// Estilo Formato decimal (00.00)
				XSSFCellStyle estiloFormatoDecimal = (XSSFCellStyle) libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$ ##,##00.00"));
				estiloFormatoDecimal.setAlignment(CellStyle.ALIGN_RIGHT);
				
				//NUEVA HOJA DE EXCEL
				SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Remitentes Usuarios");
				
				//PRIMER FILA
				Row fila = hoja.createRow(0);

				// Nombre Institucion	
				Cell celdaInst=fila.createCell((short)2);
				celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloCentrado10);				
				hoja.addMergedRegion(new CellRangeAddress(
						0, //primera fila 
			            0, //ultima fila 
			            2, //primer celda
			            7 //ultima celda
			    ));	
				
				// Nombre Usuario
				Cell celdaUsu=fila.createCell((short)10);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNegro8);	
				celdaUsu = fila.createCell((short)11);				
				celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());				
					
				// SEGUNDA FILA
				fila = hoja.createRow(1);		
				
				// Titulo del Reporte
				Cell celda=fila.createCell((short)2);
				celda.setCellValue("Reporte de Remitentes por Usuario del " +Utileria.convierteFecha(reporteRemitentesUsuarioBean.getFechaInicial())
						+" AL "+reporteRemitentesUsuarioBean.getFechaFinal());
				celda.setCellStyle(estiloCentrado10);					
				hoja.addMergedRegion(new CellRangeAddress(
					1, //primera fila 
			        1, //ultima fila 
			        2, //primer celda
			        7 //ultima celda
			    ));	
				
				// Fecha en que se genera el reporte
				Cell celdaFec=fila.createCell((short)10);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNegro8);	
				celdaFec = fila.createCell((short)11);
				celdaFec.setCellValue(parametrosSesionBean.getFechaAplicacion().toString());	
				
				// TERCER FILA
				fila = hoja.createRow(2);
								
				// Hora en que se genera el reporte
				Cell celdaHora=fila.createCell((short)10);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNegro8);	
				celdaHora = fila.createCell((short)11);
				
				String horaVar=""; 
 				int hora = calendario.get(Calendar.HOUR_OF_DAY);
 				int minutos = calendario.get(Calendar.MINUTE);
 				
 				String h = "";
 				String m = "";
 		
 				if(hora<10)h="0"+Integer.toString(hora); else h=Integer.toString(hora);
 				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
 							 
 				horaVar= h+":"+m;
 				
 				celdaHora.setCellValue(horaVar);	
				
				// CUARTA FILA SEPARADOR
 				fila = hoja.createRow(3);
 				
 				// Usuario del servicio
				Cell usuario=fila.createCell((short)1);
				usuario.setCellValue("Usuario");
				usuario.setCellStyle(estiloNegro8);	
				usuario = fila.createCell((short)2);
				usuario.setCellValue(reporteRemitentesUsuarioBean.getDescripcion());						
				
				// QUINTA FILA
				fila = hoja.createRow(4);
				
				// SEXTA FILA SEPARADOR
				fila = hoja.createRow(5);
				
				// SEPTIMA FILA
				fila = hoja.createRow(6);

				celda = fila.createCell((short)1);
				celda.setCellValue("Usuario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Nombre Completo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nombre Completo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo Persona");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Domicilio");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Tipo Identificación");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Núm. Identificación");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Nacionalidad");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)12);
				celda.setCellValue("País Residencia");
				celda.setCellStyle(estiloCentrado);	
								
				int i=7, iter=0;
				int tamanioLista = listaRepRemi.size();
				ReporteRemitentesUsuarioBean beanLis = null;
				
				for(iter=0; iter<tamanioLista; iter ++){
					beanLis = (ReporteRemitentesUsuarioBean) listaRepRemi.get(iter);
					
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(beanLis.getUsuario());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(beanLis.getNombreCompletoUsuario());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(beanLis.getRemitente());
					
					celda = fila.createCell((short)4);
					celda.setCellValue(beanLis.getNombreCompletoRemitente());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(beanLis.getTipoPersona());
					
					celda = fila.createCell((short)6);
					celda.setCellValue(beanLis.getcURP());
					
					celda = fila.createCell((short)7);
					celda.setCellValue(beanLis.getrFC());
					
					celda = fila.createCell((short)8);
					celda.setCellValue(beanLis.getDomicilio());

					celda = fila.createCell((short)9);
					celda.setCellValue(beanLis.getTipoIdentificacion());
					
					celda = fila.createCell((short)10);
					celda.setCellValue(beanLis.getNumIdentificacion());
					
					celda = fila.createCell((short)11);
					celda.setCellValue(beanLis.getNacionalidad());
					
					celda = fila.createCell((short)12);
					celda.setCellValue(beanLis.getPaisResidencia());									
					
					i++;
				}	
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)1);
				celda.setCellValue("Registros");
				celda.setCellStyle(estiloNegro8);
				celda=fila.createCell((short)2);
				celda.setCellValue(tamanioLista);			

				hoja.setColumnWidth(1, 12 * 256);
				hoja.setColumnWidth(2, 22 * 256);
				hoja.setColumnWidth(3, 12 * 256);
				hoja.setColumnWidth(4, 22 * 256);
				hoja.setColumnWidth(5, 12 * 256);
				hoja.setColumnWidth(6, 16 * 256);
				hoja.setColumnWidth(7, 16 * 256);
				hoja.setColumnWidth(8, 22 * 256);
				hoja.setColumnWidth(9, 15 * 256);
				hoja.setColumnWidth(10, 16 * 256);
				hoja.setColumnWidth(11, 14 * 256);
				hoja.setColumnWidth(12, 14 * 256);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteRemitentesUsuario.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte de Remitentes por Usuario");
		
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Remitentes: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
		return  listaRepRemi;	
	}

	public ReporteRemitentesUsuarioServicio getReporteRemitentesUsuarioServicio() {
		return reporteRemitentesUsuarioServicio;
	}

	public void setReporteRemitentesUsuarioServicio(
			ReporteRemitentesUsuarioServicio reporteRemitentesUsuarioServicio) {
		this.reporteRemitentesUsuarioServicio = reporteRemitentesUsuarioServicio;
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
