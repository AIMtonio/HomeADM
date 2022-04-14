package inversiones.reporte;

import general.bean.ParametrosAuditoriaBean;
import inversiones.bean.RepRetensionISRBean;
import inversiones.servicio.RepRetensionISRServicio;

import java.io.ByteArrayOutputStream;
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

import cliente.bean.ReporteLocalidadesMarginadasBean;

public class ReporteRetensionISRControlador extends AbstractCommandController {
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	RepRetensionISRServicio reporteRetensionISR = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPDF= 1 ;
			  int  ReporExcel= 2 ;
		}
		public ReporteRetensionISRControlador () {
			setCommandClass(RepRetensionISRBean.class);
			setCommandName("repRetensionISRBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors)throws Exception {
			
			RepRetensionISRBean repRetensionISRBean = (RepRetensionISRBean) command;

				int tipoReporte =(request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
								0;
				int tipoLista =(request.getParameter("tipoLista")!=null)?
								Integer.parseInt(request.getParameter("tipoLista")):
								0;
			
				String htmlString= "";			
			switch(tipoReporte){			
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = retensionISRPDF(repRetensionISRBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:	
					
					 List listaReportes = listaRetensionISRExcel(tipoLista,repRetensionISRBean,response);
				break;
			}
			return null;
				
		}
		
		// Reporte de Depositos Referenciados pdf
		public ByteArrayOutputStream retensionISRPDF(RepRetensionISRBean repRetensionISRBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = reporteRetensionISR.reporteRetensionISRPDF(repRetensionISRBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteRetensionISR.pdf");
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
		
		
		// Reporte de Depositos Referenciados en excel
		public List  listaRetensionISRExcel(int tipoLista,RepRetensionISRBean repRetensionISRBean,  HttpServletResponse response){
			List listaReporteRetensionISR=null;
			listaReporteRetensionISR = reporteRetensionISR.listaReporteRetensionISRExcel(tipoLista,repRetensionISRBean,response); 	
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Negrita");
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);		
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
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
				estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
				
				HSSFCellStyle estiloCentrado = libro.createCellStyle();			
				estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado.setFont(fuenteNegrita10);
				
				//estilo centrado para id y fechas
				HSSFCellStyle estiloCentrado2 = libro.createCellStyle();			
				estiloCentrado2.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				
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
				HSSFSheet hoja = libro.createSheet("Reporte Retension ISR");
				HSSFRow fila= hoja.createRow(0);
			
				// inicio usuario,fecha y hora
			
				HSSFCell celdaUsu=fila.createCell((short)1);
				
				celdaUsu = fila.createCell((short)10);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)11);
				
				celdaUsu.setCellValue((!repRetensionISRBean.getNombreUsuario().isEmpty())?repRetensionISRBean.getNombreUsuario(): "TODOS");
				String horaVar=repRetensionISRBean.getHoraEmision();				
		
				// obteniendo la hora
				int itera=0;
				RepRetensionISRBean hora = null;
				if(!listaReporteRetensionISR.isEmpty()){
					for( itera=0; itera<1; itera ++){
						hora = (RepRetensionISRBean) listaReporteRetensionISR.get(itera);
						horaVar= hora.getHoraEmision();									
					}
				}
				
				fila = hoja.createRow(1);
				HSSFCell celdaFec=fila.createCell((short)1);
						
				celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)11);
				celdaFec.setCellValue(repRetensionISRBean.getFechaEmision());
				
				// Nombre Institucion	
				HSSFCell celdaInst=fila.createCell((short)1);			
				celdaInst.setCellValue(repRetensionISRBean.getNombreInstitucion());
									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            9  //ultima celda   (0-based)
				    ));
						
					 celdaInst.setCellStyle(estiloCentrado);	
					
					fila = hoja.createRow(2);
					HSSFCell celdaHora=fila.createCell((short)1);
					celdaHora = fila.createCell((short)10);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg8);	
					celdaHora = fila.createCell((short)11);
					celdaHora.setCellValue(horaVar);
							
				// Titulo del Reporte
							HSSFCell celda=fila.createCell((short)1);					
							celda.setCellValue("Reporte de ISR Retenido sobre Inversiones ");
							hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
							            2, //primera fila (0-based)
							            2, //ultima fila  (0-based)
							            1, //primer celda (0-based)
							            9  //ultima celda   (0-based)
							    ));
							 
							 celda.setCellStyle(estiloCentrado);
							 
							 fila = hoja.createRow(3); 
								HSSFCell celdat=fila.createCell((short)1);
								celdat.setCellValue("del "+repRetensionISRBean.getFechaInicial()+" AL "+repRetensionISRBean.getFechaFinal());
								hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
							            3, //primera fila (0-based)
							            3, //ultima fila  (0-based)
							            1, //primer celda (0-based)
							            9  //ultima celda   (0-based)
							    ));
								 celdat.setCellStyle(estiloCentrado);
								
				// Creacion de fila
				fila = hoja.createRow(4); // Fila vacia
				fila = hoja.createRow(5);// Campos
		
				celda = fila.createCell((short)1);
				celda.setCellValue("No Socio");
				celda.setCellStyle(estiloNeg8);
								 
				celda = fila.createCell((short)2);
				celda.setCellValue("Nombre Completo");
				celda.setCellStyle(estiloNeg8);
				 
				celda = fila.createCell((short)3);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloNeg8);			
				
				celda = fila.createCell((short)4);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloNeg8);			

				celda = fila.createCell((short)5);
				celda.setCellValue("Monto de la Inversión");
				celda.setCellStyle(estiloNeg8);				
				 
				celda = fila.createCell((short)6);
				celda.setCellValue("Plazo de la Inversión");
				celda.setCellStyle(estiloNeg8);				
				 
				celda = fila.createCell((short)7);
				celda.setCellValue("ISR Retenido");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(estiloNeg8);			
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNeg8);				
						
				// Recorremos la lista para la parte de los datos 	
				int i=6,iter=0;
				int tamanioLista = listaReporteRetensionISR.size();
				RepRetensionISRBean retensionisr = null;
				
				for( iter=0; iter<tamanioLista; iter ++){					
					retensionisr = (RepRetensionISRBean) listaReporteRetensionISR.get(iter);
								
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(retensionisr.getClienteID());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(retensionisr.getNombrecompleto());
					
					celda=fila.createCell((short)3); 
					celda.setCellValue(retensionisr.getRfc());
										
					celda=fila.createCell((short)4);
					celda.setCellValue(retensionisr.getCurp());				

					celda=fila.createCell((short)5);
					celda.setCellValue(retensionisr.getMontoinversion());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(retensionisr.getPlazoinversion());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(retensionisr.getInteresretenido());					
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(retensionisr.getFechaInicial());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(retensionisr.getFechaVencimiento());
					celda.setCellStyle(estiloCentrado2);
								
					i++;
				}
				 
				i = i+2;
				fila=hoja.createRow(i); // Fila Registros Exportados
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				celda=fila.createCell((short)10);
				celda.setCellValue("Procedure:");
				celda.setCellStyle(estiloNeg8);
				
				celda=fila.createCell((short)11);
				celda.setCellValue("RETENSIONISRREP");
				
				i = i+1;
				fila=hoja.createRow(i); // Fila Total de Registros Exportados
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				

				for(int celd=0; celd<=15; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteRetensionISR.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
				}catch(Exception e){
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
					e.printStackTrace();
				}//Fin del catch
						
			return  listaReporteRetensionISR;
			
			
			}	
		
		// getter y setters //		

		public String getSuccessView() {
			return successView;
		}		

		public RepRetensionISRServicio getReporteRetensionISR() {
			return reporteRetensionISR;
		}

		public void setReporteRetensionISR(RepRetensionISRServicio reporteRetensionISR) {
			this.reporteRetensionISR = reporteRetensionISR;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		public String getNombreReporte() {
			return nombreReporte;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}

		public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
			return parametrosAuditoriaBean;
		}

		public void setParametrosAuditoriaBean(
				ParametrosAuditoriaBean parametrosAuditoriaBean) {
			this.parametrosAuditoriaBean = parametrosAuditoriaBean;
		}	
		

}
