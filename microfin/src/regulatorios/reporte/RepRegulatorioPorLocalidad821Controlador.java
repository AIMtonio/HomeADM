package regulatorios.reporte;

import herramientas.Utileria;

import java.text.DecimalFormat;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import regulatorios.bean.RepCaptacionPorLocalidad821Bean;
import regulatorios.servicio.RepRegulatorioCaptacionServicio;

public class RepRegulatorioPorLocalidad821Controlador extends AbstractCommandController{

		RepRegulatorioCaptacionServicio repRegulatorioCaptacionServicio = null;
		String successView = null;
		
		public static interface Enum_Con_TipReporte {
			  int  ReporPantalla= 1;
			  int  ReporPDF= 2;
			  int  ReporExcel= 3;
			  int  ReporExcel13= 4;
			  int  ReporCsv= 5;
		}
		
		public RepRegulatorioPorLocalidad821Controlador () {
			setCommandClass(RepCaptacionPorLocalidad821Bean.class);
			setCommandName("repCaptacionPorLocalidad821Bean");
		}

		protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors)throws Exception {
			
			RepCaptacionPorLocalidad821Bean reporteBean = (RepCaptacionPorLocalidad821Bean) command;
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
							 Integer.parseInt(request.getParameter("tipoReporte")): 0;
							 
			int tipoLista =(request.getParameter("tipoLista")!=null)?
					Integer.parseInt(request.getParameter("tipoLista")):
					0;
														 
								 			
			String htmlString= "";
			
			switch(tipoReporte){	
			case Enum_Con_TipReporte.ReporExcel:		
				 List<RepCaptacionPorLocalidad821Bean>listaReportes = reporteB0821Excel(tipoLista,reporteBean,response);
			break;
			case Enum_Con_TipReporte.ReporExcel13:		
				 List<RepCaptacionPorLocalidad821Bean>listaReportes2 = reporteB08212013Excel(tipoLista,reporteBean,response);
			break;
			case Enum_Con_TipReporte.ReporCsv:		
				repRegulatorioCaptacionServicio.listaReportesCaptacionPorLocalidad821(tipoLista,reporteBean,response);
			break;
			}
			
			if(tipoReporte == RepRegulatorioPorLocalidad821Controlador.Enum_Con_TipReporte.ReporPantalla){				
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
			}else {
				return null;
			}
				
		}

		// Reporte Regulatorio Captacion por Localidad 821 2014
		public List<RepCaptacionPorLocalidad821Bean> reporteB0821Excel(int tipoLista,RepCaptacionPorLocalidad821Bean reporteBean,
									   HttpServletResponse response){
					
			List<RepCaptacionPorLocalidad821Bean> listaB0821Bean = null;
			String negrita = "negrita";	
			
			String mesEnLetras	= "";
			String anio		= "";
			String nombreArchivo = "";
			
			mesEnLetras = repRegulatorioCaptacionServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
			anio	= reporteBean.getFecha().substring(0,4);
			
			nombreArchivo = "R08 B 0821 "+mesEnLetras +" "+anio; 
			
			listaB0821Bean = repRegulatorioCaptacionServicio.listaReportesCaptacionPorLocalidad821(tipoLista,reporteBean,response);
			int contador = 1;
			DecimalFormat formateador = new DecimalFormat("#");
			
			if(listaB0821Bean != null){
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
					
					//Estilo de 8  para Contenido
					HSSFCellStyle estilo8 = libro.createCellStyle();
					estilo8.setFont(fuente8);
					
					//Estilo Texto Derecha
					HSSFCellStyle estiloDerecha = libro.createCellStyle();
					estiloDerecha.setFont(fuente8);	
					estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
					
					// La fuente se mete en un estilo para poder ser usada.
					//Estilo negrita de 10 para el titulo del reporte
					HSSFCellStyle estiloNeg10 = libro.createCellStyle();
					estiloNeg10.setFont(fuenteNegrita10);
					
					//Estilo negrita de 8  para encabezados del reporte
					HSSFCellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					// Creacion de hoja
					HSSFSheet hoja = libro.createSheet("B0821");
					HSSFRow fila = hoja.createRow(0);
					fila = hoja.createRow(1);				
					HSSFCell celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					
					//Encabezados del Reporte
					celda.setCellValue("R08 B0821  REPORTE REGULATORIO DE CAPTACION TRADICIONAL POR LOCALIDAD AL " +
									   reporteBean.getFecha());
					
					fila = hoja.createRow(2);
										
					//Titulos del Reporte
					fila = hoja.createRow(3);
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("SECUENCIA");

					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("CLASIFICACION CONTABLE");
					
					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("CONCEPTO");
					
					celda=fila.createCell((short)4);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("ESTADO");

					celda=fila.createCell((short)5);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("MUNICIPIO");
					
					celda=fila.createCell((short)6);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("LOCALIDAD");

					celda=fila.createCell((short)7);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("NUMERO\nCUENTAS");
					
					celda=fila.createCell((short)8);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("MONTO\nDEPOSITOS");
					
					int i=4;
					for(RepCaptacionPorLocalidad821Bean regB0821Bean : listaB0821Bean ){
												
						fila=hoja.createRow(i);
						celda=fila.createCell((short)1);
						celda.setCellValue(contador);
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(regB0821Bean.getClasificacionContable());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(regB0821Bean.getTipoInstrumento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(regB0821Bean.getEstado());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(regB0821Bean.getMunicipio());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(regB0821Bean.getLocalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteLong(Utileria.eliminaDecimales(regB0821Bean.getNumeroContratos())));
						celda.setCellStyle(estiloDerecha);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(Utileria.convierteLong(Utileria.eliminaDecimales(regB0821Bean.getMonto())));
						celda.setCellStyle(estiloDerecha);
						
						i++;
						contador++;
						
					}
					
					hoja.autoSizeColumn((short)0);
					hoja.autoSizeColumn((short)1);
					hoja.autoSizeColumn((short)2);
					hoja.autoSizeColumn((short)3);
					hoja.autoSizeColumn((short)4);
					hoja.autoSizeColumn((short)5);
					hoja.autoSizeColumn((short)6);
					hoja.autoSizeColumn((short)7);
					hoja.autoSizeColumn((short)8);
					
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
			return listaB0821Bean;
		}
		

		// Reporte Regulatorio Captacion por Localidad 821 2014
		public List<RepCaptacionPorLocalidad821Bean> reporteB08212013Excel(int tipoLista,RepCaptacionPorLocalidad821Bean reporteBean,
									   HttpServletResponse response){
					
			List<RepCaptacionPorLocalidad821Bean> listaB0821Bean = null;
			String negrita = "negrita";	
			
			String mesEnLetras	= "";
			String anio		= "";
			String nombreArchivo = "";
			
			mesEnLetras = repRegulatorioCaptacionServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
			anio	= reporteBean.getFecha().substring(0,4);
			
			nombreArchivo = "R08 B 0821 "+mesEnLetras +" "+anio; 
			
			listaB0821Bean = repRegulatorioCaptacionServicio.listaReportesCaptacionPorLocalidad821(tipoLista,reporteBean,response);
			int contador = 1;
			DecimalFormat formateador = new DecimalFormat("#");
			
			if(listaB0821Bean != null){
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
					
					//Estilo de 8  para Contenido
					HSSFCellStyle estilo8 = libro.createCellStyle();
					estilo8.setFont(fuente8);	
					
					// La fuente se mete en un estilo para poder ser usada.
					//Estilo negrita de 10 para el titulo del reporte
					HSSFCellStyle estiloNeg10 = libro.createCellStyle();
					estiloNeg10.setFont(fuenteNegrita10);
					
					//Estilo negrita de 8  para encabezados del reporte
					HSSFCellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					//Estilo Texto Derecha
					HSSFCellStyle estiloDerecha = libro.createCellStyle();
					estiloDerecha.setFont(fuente8);	
					HSSFDataFormat format = libro.createDataFormat();
					estiloDerecha.setDataFormat(format.getFormat("#,##0"));
					estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
					
					//Estilo negrita tamaño 8 centrado
					HSSFCellStyle estiloEncabezado = libro.createCellStyle();
					estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setFont(fuenteNegrita8);
					
					
					// Creacion de hoja
					HSSFSheet hoja = libro.createSheet("R08 B 0821");
					HSSFRow fila = hoja.createRow(0);
					fila = hoja.createRow(0);				
					HSSFCell celda=fila.createCell((short)1);
										
					//Titulos del Reporte
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("Periodo");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("Clave de la \nFederación");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("Clave de la \nEntidad");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue("Clave de \nNivel de la \nEntidad");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("Número de \nSecuencia");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("Clasificación Contable");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)6);
					celda.setCellValue("Localidad");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("Número de \nCuentas o\nContratos");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("Monto de los \nDepósitos");
					celda.setCellStyle(estiloEncabezado);
					
					int i=1;
					for(RepCaptacionPorLocalidad821Bean regB0821Bean : listaB0821Bean ){
										
						fila=hoja.createRow(i);
						celda=fila.createCell((short)0);
						celda.setCellValue(regB0821Bean.getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(regB0821Bean.getClaveFederacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(regB0821Bean.getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(regB0821Bean.getClaveNivelEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(contador);
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(regB0821Bean.getClasificacionContable());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(regB0821Bean.getLocalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteLong(regB0821Bean.getNumeroContratos()));
						celda.setCellStyle(estiloDerecha);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(Utileria.convierteLong(regB0821Bean.getMonto()));
						celda.setCellStyle(estiloDerecha);
						
						i++;
						contador++;
						
					}
					
					hoja.autoSizeColumn((short)0);
					hoja.autoSizeColumn((short)1);
					hoja.autoSizeColumn((short)2);
					hoja.autoSizeColumn((short)3);
					hoja.autoSizeColumn((short)4);
					hoja.autoSizeColumn((short)5);
					hoja.autoSizeColumn((short)6);
					hoja.autoSizeColumn((short)7);
					hoja.autoSizeColumn((short)8);
					
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
			return listaB0821Bean;
		}
	
		// Setter y Getters
		
		public void setRepRegulatorioCaptacionServicio(
				RepRegulatorioCaptacionServicio repRegulatorioCaptacionServicio) {
			this.repRegulatorioCaptacionServicio = repRegulatorioCaptacionServicio;
		}
				
		public String getSuccessView() {
			return successView;
		}
		
		public void setSuccessView(String successView) {
			this.successView = successView;
		}
		
		
}
