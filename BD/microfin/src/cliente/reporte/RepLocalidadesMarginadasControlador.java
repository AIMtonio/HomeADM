package cliente.reporte;

import general.bean.ParametrosAuditoriaBean;

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

import credito.bean.CreCastigosRepBean;
import credito.servicio.CastigosCarteraServicio;
import cliente.bean.ReporteLocalidadesMarginadasBean;
import cliente.servicio.LocalidadRepubServicio;


public class RepLocalidadesMarginadasControlador extends AbstractCommandController {

	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	LocalidadRepubServicio localidadRepubServicio = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPDF= 2 ;
			  int  ReporExcel= 3 ;
		}
		public RepLocalidadesMarginadasControlador () {
			setCommandClass(ReporteLocalidadesMarginadasBean.class);
			setCommandName("reporteLocalidadesMarginadasBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors)throws Exception {
			
			ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean = (ReporteLocalidadesMarginadasBean) command;

				int tipoReporte =(request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
								0;
				int tipoLista =(request.getParameter("tipoLista")!=null)?
								Integer.parseInt(request.getParameter("tipoLista")):
								0;
			
				String htmlString= "";
				loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Entra en controlador: "+ tipoReporte);
			switch(tipoReporte){			
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = LocalidadesMarginadasPDF(reporteLocalidadesMarginadasBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = listaReporteLocalidadesMarginadasExcel(tipoLista,reporteLocalidadesMarginadasBean,response);
				break;
			}
			return null;
				
		}
		
		// Reporte de vencimientos en pdf
		public ByteArrayOutputStream LocalidadesMarginadasPDF(ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = localidadRepubServicio.creaRepLocalidadesMarginadasPDF(reporteLocalidadesMarginadasBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteLocalidadesMarginadas.pdf");
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

		// Reporte de Localidades Marginadas
		public List  listaReporteLocalidadesMarginadasExcel(int tipoLista,ReporteLocalidadesMarginadasBean reporteLocalidadesMarginadasBean,  HttpServletResponse response){
			List listaLocalidadesMarginadas=null;
			listaLocalidadesMarginadas = localidadRepubServicio.listaRepLocalidadesMarginadasExcel(tipoLista,reporteLocalidadesMarginadasBean,response); 	
		
			int regExport = 0;
		
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
//			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
//			estiloNeg8.setFont(fuenteNegrita8);
//			
//			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
//			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
//								
//			HSSFCellStyle estiloCentrado = libro.createCellStyle();
//			estiloCentrado.setFont(fuenteNegrita8);
//			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
//			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
//			
			
			

			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloDatosCentrado.setFont(fuenteNegrita10);
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();			
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10);
			
			
			
			
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
			HSSFSheet hoja = libro.createSheet("Reporte Localidades Marginadas");
			
			// inicio usuario,fecha y hora
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celdaUsu=fila.createCell((short)1);
			
			celdaUsu = fila.createCell((short)6);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue((!reporteLocalidadesMarginadasBean.getNombreUsuario().isEmpty())?reporteLocalidadesMarginadasBean.getNombreUsuario(): "TODOS");
			
			String horaVar=reporteLocalidadesMarginadasBean.getHoraEmision();
			String fechaVar=reporteLocalidadesMarginadasBean.getFechaEmision();

			
			int itera=0;
			ReporteLocalidadesMarginadasBean localidadHora = null;
			if(!listaLocalidadesMarginadas.isEmpty()){
				for( itera=0; itera<1; itera ++){
					localidadHora = (ReporteLocalidadesMarginadasBean) listaLocalidadesMarginadas.get(itera);
					horaVar= localidadHora.getHoraEmision();
					fechaVar= localidadHora.getFechaEmision();				
				}
			}
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)6);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue(reporteLocalidadesMarginadasBean.getFechaEmision());
			
			//Nombre Institucion
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(reporteLocalidadesMarginadasBean.getNombreInstitucion());
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				celdaInst.setCellStyle(estiloDatosCentrado);
			
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)6);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)7);
			celdaHora.setCellValue(horaVar);
			
						    
			// Titulo del Reporte
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE LOCALIDADES MARGINADAS ");
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
			 celda.setCellStyle(estiloDatosCentrado);
		 
			
			// Creacion de fila
			fila = hoja.createRow(3); // Fila vacia
			fila = hoja.createRow(4);// Campos
									

			celda = fila.createCell((short)1);
			celda.setCellValue("ESTADO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("MUNICIPIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("LOCALIDAD");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("NOMBRE LOCALIDAD");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("NUM. HABITANTES");
			celda.setCellStyle(estiloNeg8);
			
			// Recorremos la lista para la parte de los datos 
			String nombreHoja="";
			int numHojas=1;
			int i=5,iter=0;
			int tamanioLista = listaLocalidadesMarginadas.size();
			ReporteLocalidadesMarginadasBean localidad = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
			  if(i<65530){
				
				localidad = (ReporteLocalidadesMarginadasBean) listaLocalidadesMarginadas.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short)1);
				celda.setCellValue(localidad.getNombreEstadoMarginadas());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(localidad.getNombreMunicipioMarginadas());
				
				celda=fila.createCell((short)3); 
				celda.setCellValue(localidad.getLocalidadMarginadasID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(localidad.getNombreLocalidadMarginadas()); 
				
				celda=fila.createCell((short)5);
				celda.setCellValue(localidad.getNumHabitantes());
				celda.setCellStyle(estiloDatosCentrado);
				
					 
				i++;
			  }else{
				  for(int celd=0; celd<=15; celd++)
					  hoja.autoSizeColumn((short)celd);	
				   nombreHoja="Reporte Localidades Marginadas"+numHojas;
				   hoja = libro.createSheet(nombreHoja);
				   fila = hoja.createRow(0);
				   i=5;
				   numHojas=numHojas+1;
				// inicio usuario,fecha y hora
					 fila= hoja.createRow(0);
					 celdaUsu=fila.createCell((short)1);
					
					celdaUsu = fila.createCell((short)6);
					celdaUsu.setCellValue("Usuario:");
					celdaUsu.setCellStyle(estiloNeg8);	
					celdaUsu = fila.createCell((short)7);
					celdaUsu.setCellValue((!reporteLocalidadesMarginadasBean.getNombreUsuario().isEmpty())?reporteLocalidadesMarginadasBean.getNombreUsuario(): "TODOS");		
						
					fila = hoja.createRow(1);
					celdaFec=fila.createCell((short)1);
							
					celdaFec = fila.createCell((short)6);
					celdaFec.setCellValue("Fecha:");
					celdaFec.setCellStyle(estiloNeg8);	
					celdaFec = fila.createCell((short)7);
					celdaFec.setCellValue(reporteLocalidadesMarginadasBean.getFechaEmision());
					
					//Nombre Institucion
					celdaInst=fila.createCell((short)1);
					celdaInst.setCellStyle(estiloNeg10);
					celdaInst.setCellValue(reporteLocalidadesMarginadasBean.getNombreInstitucion());
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            1, //primera fila (0-based)
					            1, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            5  //ultima celda   (0-based)
					    ));
						celdaInst.setCellStyle(estiloDatosCentrado);
					
					
					fila = hoja.createRow(2);
					celdaHora=fila.createCell((short)1);
					celdaHora = fila.createCell((short)6);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg8);	
					celdaHora = fila.createCell((short)7);
					celdaHora.setCellValue(horaVar);
					
								    
					// Titulo del Reporte
					 celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE DE LOCALIDADES MARGINADAS ");
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            2, //primera fila (0-based)
					            2, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            5  //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloDatosCentrado);
				 
					
					// Creacion de fila
					fila = hoja.createRow(3); // Fila vacia
					fila = hoja.createRow(4);// Campos
											

					celda = fila.createCell((short)1);
					celda.setCellValue("ESTADO");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("MUNICIPIO");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("LOCALIDAD");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("NOMBRE LOCALIDAD");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("NUM. HABITANTES");
					celda.setCellStyle(estiloNeg8);
			  }
			 }
			 
			i = i+2;
			fila=hoja.createRow(i); // Fila Registros Exportados
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i+1;
			fila=hoja.createRow(i); // Fila Total de Registros Exportados
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			

			for(int celd=0; celd<=15; celd++)
			hoja.autoSizeColumn((short)celd);
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepLocalidadesMarginadas.xls");
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
		//} 
			
			
		return  listaLocalidadesMarginadas;
		
		
		}
	
		
		// getter y setters //
		
		public LocalidadRepubServicio getLocalidadRepubServicio() {
			return localidadRepubServicio;
		}

		public void setLocalidadRepubServicio(
				LocalidadRepubServicio localidadRepubServicio) {
			this.localidadRepubServicio = localidadRepubServicio;
		}


		public String getSuccessView() {
			return successView;
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
