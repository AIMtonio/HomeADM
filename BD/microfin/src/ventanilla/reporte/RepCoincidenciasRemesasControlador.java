package ventanilla.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;
import org.apache.log4j.Logger;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
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

import ventanilla.bean.ReporteCoincidenciasRemesasBean;
import ventanilla.servicio.ReporteCoincidenciasRemesasServicio;

public class RepCoincidenciasRemesasControlador extends AbstractCommandController{
	
	ReporteCoincidenciasRemesasServicio reporteCoincidenciasRemesasServicio = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RepCoincidenciasRemesasControlador(){
 		setCommandClass(ReporteCoincidenciasRemesasBean.class);
 		setCommandName("reporteCoincidenciasRemesasBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {

		ReporteCoincidenciasRemesasBean reporteCoincidenciasRemesasBean = (ReporteCoincidenciasRemesasBean) command;

		String htmlString = "";
		List listaReporteCoin;
		try {							
			listaReporteCoin = reporteCoincidenciasExcel(reporteCoincidenciasRemesasBean, response);															
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List  reporteCoincidenciasExcel(ReporteCoincidenciasRemesasBean reporteCoincidenciasRemesasBean,HttpServletResponse response){
		List <ReporteCoincidenciasRemesasBean> listaRepCoin  = null;
		listaRepCoin = reporteCoincidenciasRemesasServicio.listaReporteCoincidencias(reporteCoincidenciasRemesasBean);
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
				SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Coincidencias Remesas");
				
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
				celda.setCellValue("Reporte de Coincidencias en Remesas del " +Utileria.convierteFecha(reporteCoincidenciasRemesasBean.getFechaInicial())
						+" AL "+reporteCoincidenciasRemesasBean.getFechaFinal());
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
 				
 				// Tipo de Coincidencia
				Cell tipo=fila.createCell((short)1);
				tipo.setCellValue("Tipo Coincidencia");
				tipo.setCellStyle(estiloNegro8);	
				tipo = fila.createCell((short)2);
				final String tipoC;// variable para guardar lo que se obtiene del combo de tipoCoincidencia
				tipoC = reporteCoincidenciasRemesasBean.getTipoCoincidencia();
				if(tipoC.equals("0")){
					tipo.setCellValue("TODOS");
				}
				else{
					if(tipoC.equals("1")){
						tipo.setCellValue("RFC");
					}
					else{
						tipo.setCellValue("CURP");
					}
				}				
				
				// QUINTA FILA
				fila = hoja.createRow(4);
				
				// SEXTA FILA SEPARADOR
				fila = hoja.createRow(5);
				
				// Apartado USUARIOS DE SERVICIO BUSCADOS 	
				Cell celdaUsuarioBuscado=fila.createCell((short)1);
				celdaUsuarioBuscado.setCellValue("USUARIOS DE SERVICIO BUSCADOS");
				celdaUsuarioBuscado.setCellStyle(estiloCentrado10);				
				hoja.addMergedRegion(new CellRangeAddress(
		            5, //primera fila 
		            5, //ultima fila 
		            1, //primer celda
		            4 //ultima celda
			    ));	
				
				// Apartado USUARIOS DE SERVICIO COINCIDIDOS
				Cell celdaUsuarioCoincidencia=fila.createCell((short)5);
				celdaUsuarioCoincidencia.setCellValue("USUARIOS DE SERVICIOS COINCIDIDOS");
				celdaUsuarioCoincidencia.setCellStyle(estiloCentrado10);				
				hoja.addMergedRegion(new CellRangeAddress(
		            5, //primera fila 
		            5, //ultima fila 
		            5, //primer celda
		            8 //ultima celda
			    ));	
				
				// SEPTIMA FILA
				fila = hoja.createRow(6);

				celda = fila.createCell((short)1);
				celda.setCellValue("Usuario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nombre");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Usuario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Nombre");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("% Coincidencia");
				celda.setCellStyle(estiloCentrado);				
								
				int i=7, iter=0;
				int tamanioLista = listaRepCoin.size();
				ReporteCoincidenciasRemesasBean beanLis = null;
				
				for(iter=0; iter<tamanioLista; iter ++){
					beanLis = (ReporteCoincidenciasRemesasBean) listaRepCoin.get(iter);
					
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(beanLis.getUsuarioBuscado());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(beanLis.getrFCBuscado());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(beanLis.getcURPBuscado());
					
					celda = fila.createCell((short)4);
					celda.setCellValue(beanLis.getNombreBuscado());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(beanLis.getUsuarioCoincidencia());
					
					celda = fila.createCell((short)6);
					celda.setCellValue(beanLis.getrFCCoincidencia());
					
					celda = fila.createCell((short)7);
					celda.setCellValue(beanLis.getcURPCoincidencia());
					
					celda = fila.createCell((short)8);
					celda.setCellValue(beanLis.getNombreCoincidencia());

					celda = fila.createCell((short)9);
					celda.setCellValue(beanLis.getPorcentajeCoincidencia());
					celda.setCellStyle(estiloCentra);
					celda.setCellStyle(estiloFormatoDecimal);
					
					i++;
				}	
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)1);
				celda.setCellValue("Registros");
				celda.setCellStyle(estiloNegro8);
				celda=fila.createCell((short)2);
				celda.setCellValue(tamanioLista);			

				hoja.setColumnWidth(1, 14 * 256);
				hoja.setColumnWidth(2, 14 * 256);
				hoja.setColumnWidth(3, 16 * 256);
				hoja.setColumnWidth(4, 24 * 256);
				hoja.setColumnWidth(5, 12 * 256);
				hoja.setColumnWidth(6, 14 * 256);
				hoja.setColumnWidth(7, 16 * 256);
				hoja.setColumnWidth(8, 22 * 256);
				hoja.setColumnWidth(9, 15 * 256);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteCoincidenciasRemesas.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte de Coincidencias");
		
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Coincidencias: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
		return  listaRepCoin;	
	}

	public ReporteCoincidenciasRemesasServicio getReporteCoincidenciasRemesasServicio() {
		return reporteCoincidenciasRemesasServicio;
	}

	public void setReporteCoincidenciasRemesasServicio(
			ReporteCoincidenciasRemesasServicio reporteCoincidenciasRemesasServicio) {
		this.reporteCoincidenciasRemesasServicio = reporteCoincidenciasRemesasServicio;
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
