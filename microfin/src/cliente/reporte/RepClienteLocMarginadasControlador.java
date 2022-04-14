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
import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.servicio.DireccionesClienteServicio;

public class RepClienteLocMarginadasControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	DireccionesClienteServicio direccionesClienteServicio = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPDF= 2 ;
			  int  ReporExcel= 3 ;
		}
		public RepClienteLocMarginadasControlador () {
			setCommandClass(ReporteClienteLocMarginadasBean.class);
			setCommandName("reporteClienteLocMarginadasBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors)throws Exception {
			
			ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean = (ReporteClienteLocMarginadasBean) command;

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
					ByteArrayOutputStream htmlStringPDF = ClienteLocMarginadasPDF(reporteClienteLocMarginadasBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = listaRepClienteLocMarginExcel(tipoLista,reporteClienteLocMarginadasBean,response);
				break;
			}
			return null;
				
		}
		
		// Reporte de Clientes que viven en localidades marginadas en pdf
		public ByteArrayOutputStream ClienteLocMarginadasPDF(ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = direccionesClienteServicio.creaRepClienteLocMarginPDF(reporteClienteLocMarginadasBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteClienteLocMargin.pdf");
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

		// Reporte de Localidades Marginadas en Excel
		public List  listaRepClienteLocMarginExcel(int tipoLista,ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean,  HttpServletResponse response){
			List listaClienteLocMarginadas=null;
			listaClienteLocMarginadas = direccionesClienteServicio.listaRepClienteLocMarginExcel(tipoLista,reporteClienteLocMarginadasBean,response); 	
		
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
			HSSFSheet hoja = libro.createSheet("Reporte ClienteLocalidadesMarginadas");
			HSSFRow fila= hoja.createRow(0);
		
			// inicio usuario,fecha y hora
		
			HSSFCell celdaUsu=fila.createCell((short)1);
			
			celdaUsu = fila.createCell((short)11);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)12);
			celdaUsu.setCellValue((!reporteClienteLocMarginadasBean.getNombreUsuario().isEmpty())?reporteClienteLocMarginadasBean.getNombreUsuario(): "TODOS");
			
			String horaVar=reporteClienteLocMarginadasBean.getHoraEmision();
			String fechaVar=reporteClienteLocMarginadasBean.getFechaEmision();

			
			int itera=0;
			ReporteClienteLocMarginadasBean clientedHora = null;
			if(!listaClienteLocMarginadas.isEmpty()){
				for( itera=0; itera<1; itera ++){
					clientedHora = (ReporteClienteLocMarginadasBean) listaClienteLocMarginadas.get(itera);
					horaVar= clientedHora.getHoraEmision();
					//fechaVar= clientedHora.getFechaEmision();				
				}
			}
				
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
					
			celdaFec = fila.createCell((short)11);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)12);
			celdaFec.setCellValue(fechaVar);
			 
			// Nombre Institucion	
			HSSFCell celdaInst=fila.createCell((short)1);
			//celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(reporteClienteLocMarginadasBean.getNombreInstitucion());
								
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
			  
			 celdaInst.setCellStyle(estiloCentrado);	
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)11);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)12);
			celdaHora.setCellValue(horaVar);
			
			// Titulo del Reporte
						HSSFCell celda=fila.createCell((short)1);					
						celda.setCellValue("REPORTE DE SOCIOS CON VIVIENDA EN LOCALIDADES MARGINADAS");
										
						 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						            2, //primera fila (0-based)
						            2, //ultima fila  (0-based)
						            1, //primer celda (0-based)
						            6  //ultima celda   (0-based)
						    ));
						 
						 celda.setCellStyle(estiloCentrado);
			
			
			// Creacion de fila
			fila = hoja.createRow(3); // Fila vacia
			fila = hoja.createRow(4);// Campos
									

			celda = fila.createCell((short)1);
			celda.setCellValue("SUCURSAL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("NOMBRE SUCURSAL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("No SOCIO/CLIENTE");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("NOMBRE SOCIO");
			celda.setCellStyle(estiloNeg8);
				
			celda = fila.createCell((short)5);
			celda.setCellValue("DIRECCION COMPLETA");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("ESTATUS SOCIO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("CURP");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("FECHA INGRESO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("CODIGO LOCALIDAD");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("ESTADO CIVIL");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("CODIGO GRUPO");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("ES MENOR");
			celda.setCellStyle(estiloNeg8);

			// Recorremos la lista para la parte de los datos 	
			int i=5,iter=0;
			int tamanioLista = listaClienteLocMarginadas.size();
			ReporteClienteLocMarginadasBean clienteloc = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				clienteloc = (ReporteClienteLocMarginadasBean) listaClienteLocMarginadas.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short)1);
				celda.setCellValue(clienteloc.getSucursalID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(clienteloc.getNombreSucursal());
				
				celda=fila.createCell((short)3); 
				celda.setCellValue(clienteloc.getClienteID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(clienteloc.getNombreCliente()); 
				
				celda=fila.createCell((short)5);
				celda.setCellValue(clienteloc.getDireccionCompleta());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(clienteloc.getEstatus());
				
				celda=fila.createCell((short)7);
				celda.setCellValue(clienteloc.getCURP());
				
				celda=fila.createCell((short)8);
				celda.setCellValue(clienteloc.getFechaAlta());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(clienteloc.getLocalidadMarginadasID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(clienteloc.getDesEstadoCivil());
				
				celda=fila.createCell((short)11);
				celda.setCellValue(clienteloc.getGrupoID());
				celda.setCellStyle(estiloCentrado2);
				
				celda=fila.createCell((short)12);
				celda.setCellValue(clienteloc.getDesEsMenorEdad());
				celda.setCellStyle(estiloCentrado2);
							 
				i++;
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
			response.addHeader("Content-Disposition","inline; filename=RepClienteLocMarginadas.xls");
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
			
			
		return  listaClienteLocMarginadas;
		
		
		}
	
		
		// getter y setters //
		
	


		public String getSuccessView() {
			return successView;
		}

		public DireccionesClienteServicio getDireccionesClienteServicio() {
			return direccionesClienteServicio;
		}

		public void setDireccionesClienteServicio(
				DireccionesClienteServicio direccionesClienteServicio) {
			this.direccionesClienteServicio = direccionesClienteServicio;
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

