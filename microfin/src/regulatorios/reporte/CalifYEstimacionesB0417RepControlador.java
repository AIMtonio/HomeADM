package regulatorios.reporte;

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

import regulatorios.bean.CalificacionYEstimacionB0417Bean;
import regulatorios.servicio.CalificacionYEstimacionB0417Servicio;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

public class CalifYEstimacionesB0417RepControlador extends AbstractCommandController  {


	public static interface Enum_Con_TipReporte {
		  int  ReporPantalla= 1;
		  int  ReporPDF= 2;
		  int  ReporExcel= 3;
		  int  ReporCsv= 4;
	}
	
	CalificacionYEstimacionB0417Servicio calificacionYEstimacionB0417Servicio = null;
	String successView = null;
	
	public CalifYEstimacionesB0417RepControlador () {
		setCommandClass(CalificacionYEstimacionB0417Bean.class);
		setCommandName("B0417Bean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,Object command, BindException errors)throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		CalificacionYEstimacionB0417Bean b0417Bean = (CalificacionYEstimacionB0417Bean) command;
		
		calificacionYEstimacionB0417Servicio.getCalificacionYEstimacionB0417DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")): 0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		int version=(request.getParameter("version")!=null)?Integer.parseInt(request.getParameter("version")):2014;	
		int tipoEntidad = (request.getParameter("tipoEntidad") != null)
				? Integer.parseInt(request.getParameter("tipoEntidad"))
				: 0;
		
			switch(tipoReporte){
				
				case Enum_Con_TipReporte.ReporExcel:
					switch(version){
						case 2014:	List<CalificacionYEstimacionB0417Bean>listaReportes = reporteB0417Excel(tipoLista,b0417Bean,response);
							break;
						case 2015: 	calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417Version2015(tipoLista,tipoEntidad,b0417Bean,response);
							break;
						case 2017: 	calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417Version2015(tipoLista,tipoEntidad,b0417Bean,response);
						break;
					}
				break;
				case Enum_Con_TipReporte.ReporCsv:	
					switch(version){
						case 2014:	calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417(tipoLista,b0417Bean,response);
							break;
						case 2015:  calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417Version2015(tipoLista,tipoEntidad,b0417Bean,response);
							break;
						case 2017:  calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417Version2015(tipoLista,tipoEntidad,b0417Bean,response);
						break;
					}
				break;
				}
			return null;	
		}

	// Reporte de Calificacion y Estimaciones a Excell
	public List<CalificacionYEstimacionB0417Bean>reporteB0417Excel(int tipoLista,CalificacionYEstimacionB0417Bean b0417Bean, 
									HttpServletResponse response){
		List<CalificacionYEstimacionB0417Bean> listaB0417Bean = null;
		String negrita = "negrita";
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		
		mesEnLetras = calificacionYEstimacionB0417Servicio.descripcionMes(b0417Bean.getFecha().substring(5,7));
		anio	= b0417Bean.getFecha().substring(0,4);
		
		nombreArchivo = "R04_B_0417_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaB0417Bean = calificacionYEstimacionB0417Servicio.consultaRegulatorioB0417(tipoLista,b0417Bean,response); 	
		
		if(listaB0417Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estilo8 = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estilo8.setFont(fuente8);
				estilo8.setDataFormat(format.getFormat("#,##0.00"));
				
				//Estilo de 8  para la Nota
				HSSFCellStyle estiloNota = libro.createCellStyle();
				estiloNota.setFont(fuente8);
				estiloNota.setAlignment((short)HSSFCellStyle.ALIGN_JUSTIFY);
				
				//Estilo negrita de 8  y color de fondo
				HSSFCellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				
				
				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat formato = libro.createDataFormat();
				estiloFormatoDecimal.setFont(fuenteNegrita8);
				estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
				estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo tamaño 8 alineado a la derecha
				HSSFCellStyle estiloTitulo = libro.createCellStyle();
				estiloTitulo.setFont(fuenteNegrita8);
				estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				
				//Estilo tamaño 8 alineado a la izquierda
				HSSFCellStyle estiloSubtitulo = libro.createCellStyle();
				estiloSubtitulo.setFont(fuenteNegrita8);
				estiloSubtitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				
				//Estilo para una celda sin dato con color de fondo gris
				HSSFCellStyle celdaGris = libro.createCellStyle();
				HSSFDataFormat formato2 = libro.createDataFormat();
				celdaGris.setFont(fuenteNegrita8);
				celdaGris.setDataFormat(formato2.getFormat("#,##0.00"));
				celdaGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGris.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Calif Cartera R 04 B 0417");
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
				celda.setCellValue("Reporte Regulatorio de Calificación de la Cartera de Crédito y Estimación Preventiva para Riesgos Crediticios");
				celda.setCellStyle(estiloTitulo);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(1);
				celda = fila.createCell((short)0);
				celda.setCellValue("Subreporte: Calificación de la Cartera de Crédito y Estimación Preventiva para Riesgos Crediticios");
				celda.setCellStyle(estiloTitulo);	
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(2);
				celda = fila.createCell((short)0);
				celda.setCellValue("R04 B 0417");
				celda.setCellStyle(estiloTitulo);	
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(4);
				celda = fila.createCell((short)0);
				celda.setCellValue("Subreporte: Calificación de la Cartera de Crédito y Estimación Preventiva para Riesgos Crediticios");
				celda.setCellStyle(estiloSubtitulo);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(5);
				celda = fila.createCell((short)0);
				celda.setCellValue("Incluye: Moneda Nacional y Udis Valorizadas en Pesos");
				celda.setCellStyle(estiloSubtitulo);	
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(6);
				celda = fila.createCell((short)0);
				celda.setCellValue("Cifras en Pesos");
				celda.setCellStyle(estiloSubtitulo);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            6, //primera fila (0-based)
			            6, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));

				fila = hoja.createRow(8);
				celda = fila.createCell((short)0);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            8, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            0  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Cartera Base de Calificación 1/");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            8, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            1  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Estimaciones Preventivas \nPara Riesgos  Crediticios \nY Estimaciones Adicionales 2/");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            8, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            2, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				int i=10;		
				for(CalificacionYEstimacionB0417Bean regB0417Bean : listaB0417Bean ){
		
					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(regB0417Bean.getConcepto());
					if(regB0417Bean.getEstilo().equalsIgnoreCase(negrita)){
						celda.setCellStyle(estiloNeg8);
					}else{
						celda.setCellStyle(estilo8);	
					}
					
					celda=fila.createCell((short)1);
					if(regB0417Bean.getColorCelda().equalsIgnoreCase("S") ){
						celda.setCellStyle(celdaGris);
						celda.setCellValue(Double.parseDouble(regB0417Bean.getCarteraBase()));
					}else{
						if(regB0417Bean.getCarteraBase()!=null && !regB0417Bean.getCarteraBase().isEmpty()){
						celda.setCellValue(Double.parseDouble(regB0417Bean.getCarteraBase()));
						celda.setCellStyle(estiloFormatoDecimal);
						}else{
						celda.setCellStyle(estilo8);
						}
					}
				
					celda=fila.createCell((short)2);
					if(regB0417Bean.getColorCelda().equalsIgnoreCase("S") ){
						celda.setCellStyle(celdaGris);
						celda.setCellValue(Double.parseDouble(regB0417Bean.getMontoEstimacion()));
					}else{
						if(regB0417Bean.getMontoEstimacion()!=null && !regB0417Bean.getMontoEstimacion().isEmpty()){
						celda.setCellValue(Double.parseDouble(regB0417Bean.getMontoEstimacion()));
						celda.setCellStyle(estiloFormatoDecimal);
						}else{
						celda.setCellStyle(estilo8);	
						}
					}
					i++;
				}
				
				hoja.autoSizeColumn((short)0);
				hoja.autoSizeColumn((short)1);
				hoja.autoSizeColumn((short)2);
				hoja.autoSizeColumn((short)3);
				
				fila=hoja.createRow(91);			
				celda=fila.createCell((short)0);
				celda.setCellValue("Notas:");	
				celda.setCellStyle(estiloNeg8);
				
				fila=hoja.createRow(92);			
				celda=fila.createCell((short)0);
				celda.setCellValue("1/ El monto sujeto a la calificación no deberá incluir los intereses devengados no cobrados registrados" +
						" en balance, de créditos que estén en cartera vencida.");	
				celda.setCellStyle(estiloNota);
				hoja.addMergedRegion(new CellRangeAddress(
			            92, //primera fila (0-based)
			            92, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila=hoja.createRow(93);			
				celda=fila.createCell((short)0);
				celda.setCellValue("2/ Los datos correspondientes a la columna de estimaciones preventivas para riesgos crediticios y " +
						"estimaciones adicionales deberán presentarse con signo negativo");
				celda.setCellStyle(estiloNota);
				hoja.addMergedRegion(new CellRangeAddress(
			            93, //primera fila (0-based)
			            93, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila=hoja.createRow(94);			
				celda=fila.createCell((short)0);
				celda.setCellValue("3/ El resultado correspondiente al exceso o insuficiencia en estimaciones se calculará considerando" +
						" que las  cifras serán presentadas con signo negativo.");	
				celda.setCellStyle(estiloNota);
				hoja.addMergedRegion(new CellRangeAddress(
			            94, //primera fila (0-based)
			            94, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila=hoja.createRow(95);			
				celda=fila.createCell((short)0);
				celda.setCellValue("4/ La cartera de crédito total se refiere a la suma de los créditos comerciales, de consumo y de vivienda.");	
				celda.setCellStyle(estiloNota);
				hoja.addMergedRegion(new CellRangeAddress(
			            95, //primera fila (0-based)
			            95, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				fila=hoja.createRow(96);			
				celda=fila.createCell((short)0);
				celda.setCellValue("Las celdas sombreadas representan celdas invalidadas para las cuales no aplica la información solicitada.");	
				celda.setCellStyle(estiloNota);
				hoja.addMergedRegion(new CellRangeAddress(
			            96, //primera fila (0-based)
			            96, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaB0417Bean;
	}



	// Setter y Getters
	
	
	public String getSuccessView() {
		return successView;
	}
	
	public CalificacionYEstimacionB0417Servicio getCalificacionYEstimacionB0417Servicio() {
		return calificacionYEstimacionB0417Servicio;
	}

	public void setCalificacionYEstimacionB0417Servicio(
			CalificacionYEstimacionB0417Servicio calificacionYEstimacionB0417Servicio) {
		this.calificacionYEstimacionB0417Servicio = calificacionYEstimacionB0417Servicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
