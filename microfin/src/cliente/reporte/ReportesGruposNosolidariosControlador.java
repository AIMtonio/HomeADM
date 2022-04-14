package cliente.reporte;

import herramientas.Constantes;
import herramientas.Utileria;
import java.io.ByteArrayOutputStream;
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
import org.apache.poi.hssf.util.HSSFColor;import org.apache.poi.ss.util.CellRangeAddress;

import contabilidad.bean.ReporteBalanzaContableBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.GruposNosolidariosBean;
import cliente.servicio.GruposNosolidariosServicio;



	public class ReportesGruposNosolidariosControlador  extends AbstractCommandController{
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPDF= 1 ;
			  int  ReporExcel= 2 ;
		}
		
		GruposNosolidariosServicio gruposNosolidariosServicio = null;
		String nombreReporte = null;
		String successView = null;		   
		
		public ReportesGruposNosolidariosControlador() {
			setCommandClass(GruposNosolidariosBean.class);
			setCommandName("gruposNosolidariosBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

			GruposNosolidariosBean gruposNosolidariosBean = (GruposNosolidariosBean) command;
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
					Integer.parseInt(request.getParameter("tipoReporte")):
				0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
					Integer.parseInt(request.getParameter("tipoLista")):
			0;
					
			String htmlString= "";
			
			switch(tipoReporte){
				
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reportePDF(gruposNosolidariosBean, getNombreReporte(),  response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List<GruposNosolidariosBean>listaReportes = reporteExcel(gruposNosolidariosBean,response);
				break;
			}
			
			
			return null;	
		}
		
		// Reporte  de balanza contable en PDF
				public ByteArrayOutputStream reportePDF(GruposNosolidariosBean gruposNosolidariosBean, String nomRep, HttpServletResponse response){
					ByteArrayOutputStream htmlStringPDF = null;
					try {
						htmlStringPDF = gruposNosolidariosServicio.reportePDF(gruposNosolidariosBean, nomRep);
						response.addHeader("Content-Disposition","inline; filename=GruposNoSolidarios.pdf");
						
						response.setContentType("application/pdf");
						byte[] bytes = htmlStringPDF.toByteArray();
						response.getOutputStream().write(bytes,0,bytes.length);
						response.getOutputStream().flush();
						response.getOutputStream().close();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				return htmlStringPDF;
				}		
				
				// Reporte de balanza contable en Excel
				public List <GruposNosolidariosBean> reporteExcel(GruposNosolidariosBean gruposNosolidariosBean,  HttpServletResponse response){
				int tipoLista=1;
				List<GruposNosolidariosBean> listaIntegrantes=null;
				listaIntegrantes = gruposNosolidariosServicio.listaReporte(tipoLista, gruposNosolidariosBean,  response); 	
				
				int regExport = 0;


				
				
				if(listaIntegrantes != null){
			
					// Creacion de Libro
					
						try {
							HSSFWorkbook libro = new HSSFWorkbook();
					//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
					HSSFFont fuenteNegrita10= libro.createFont();
					fuenteNegrita10.setFontHeightInPoints((short)10);
					fuenteNegrita10.setFontName("Negrita");
					fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
					
					HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
					estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					estiloDatosCentrado.setFont(fuenteNegrita10);
					
				
				
					
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
					HSSFSheet hoja = libro.createSheet("Grupos No Solidarios");
					HSSFRow fila= hoja.createRow(0);
					HSSFCell celda=fila.createCell((short)1);
					
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Grupos No Solidarios");
					
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(gruposNosolidariosBean.getNombreInstitucion());
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            11  //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)12);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Usuario: "+gruposNosolidariosBean.getNombreUsuario());
					
					fila = hoja.createRow(1);
					celda=fila.createCell((short)12);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha: "+gruposNosolidariosBean.getFechaEmision());
					
					fila = hoja.createRow(2);
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE DE GRUPOS NO SOLIDARIOS ");
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            2, //primera fila (0-based)
					            2, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            11  //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloDatosCentrado);
					String hora = listaIntegrantes.get(0).getHoraEmision();

					celda=fila.createCell((short)12);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Hora: "+hora);
					
				
													
					fila = hoja.createRow(3);
					fila = hoja.createRow(4);
					
					//Variable para recibir el valor del Bean  
				
					String sucursal=gruposNosolidariosBean.getSucursalDes();
					String grupoIni=gruposNosolidariosBean.getGrupoIniDes();
					String grupoFin=gruposNosolidariosBean.getGrupoFinDes();
					String promotorIni=gruposNosolidariosBean.getPromotorIniDes();
					String promotorFin=gruposNosolidariosBean.getPromotorFinDes();
				
					 //Condiciones para cambiar el valor de las variables
				
					 
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Sucursal: "+sucursal);
					
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Grupo Inicial: "+grupoIni);
					
					celda=fila.createCell((short)4);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Grupo Final: "+grupoFin);
					
					celda=fila.createCell((short)6);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Promotor Inicial: "+promotorIni);
					
					celda=fila.createCell((short)8);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Promotor Final: "+promotorFin);
					
					// Creacion de fila
					fila = hoja.createRow(5);
					fila = hoja.createRow(6);
					
					//Inicio en la segunda fila y que el fila uno tiene los encabezados
					celda = fila.createCell((short)0);
					celda.setCellValue("No. Sucursal");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)1);
					celda.setCellValue("Nombre Sucursal");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Promotor");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre Promotor");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("No. Grupo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Nombre Grupo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("No. Socio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Nombre de Socio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Menor");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("Tipo Integrante");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Ahorros");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Exigible");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)12);
					celda.setCellValue("Total Adeudo");
					celda.setCellStyle(estiloNeg8);
					
					int i=8;
				
				
					for(GruposNosolidariosBean integrante : listaIntegrantes ){

							fila=hoja.createRow(i);

							celda=fila.createCell((short)0);
							celda.setCellValue(integrante.getSucursalID());
							
							
							celda=fila.createCell((short)1);
							celda.setCellValue(integrante.getNombreSucursal());
							
							
							celda=fila.createCell((short)2);
							celda.setCellValue(integrante.getPromotorID());
							
							
							
							celda=fila.createCell((short)3);
							celda.setCellValue(integrante.getNombrePromotor());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(integrante.getGrupoID());
							
							
							celda=fila.createCell((short)5);
							celda.setCellValue(integrante.getNombreGrupo());
							
							
							celda=fila.createCell((short)6);
							celda.setCellValue(integrante.getClienteID());
						
							
							celda=fila.createCell((short)7);
							celda.setCellValue(integrante.getNombreCompleto());
							
							String menor=integrante.getEsMenorEdad();
							
							 if(menor==null ){
								 menor="NO";
							 }else{
								if(menor.equals("S")){
									menor="SI";
								}else{
									menor="NO";
								}
							 }
							
							celda=fila.createCell((short)8);
							celda.setCellValue(menor);
							
							String tipoInt = integrante.getTipoIntegrante();
							if (tipoInt.equals("1")){
								tipoInt="PRESIDENTE";
							}
							if (tipoInt.equals("2")){
								tipoInt="TESORERO";
							}
							if (tipoInt.equals("3")){
								tipoInt="VOCAL";
							}
							if (tipoInt.equals("4")){
								tipoInt="INTEGRANTE";
							}
							celda=fila.createCell((short)9);
							celda.setCellValue(tipoInt);
							
							celda=fila.createCell((short)10);
							celda.setCellValue(Double.parseDouble(integrante.getAhorro()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)11);
							celda.setCellValue(Double.parseDouble(integrante.getExigibleDia()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)12);
							celda.setCellValue(Double.parseDouble(integrante.getTotalDia()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							
						i++;
					}
					
					i = i+2;
					fila=hoja.createRow(i);
				
					for(GruposNosolidariosBean Bean : listaIntegrantes ){			
						regExport 		= regExport + 1;
					}
					
					i = i+2;
					fila=hoja.createRow(i); // Fila Registros Exportados
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					
					celda=fila.createCell((short)11);
					celda.setCellValue("Procedure:");
					celda.setCellStyle(estiloNeg8);
					
					celda=fila.createCell((short)12);
					celda.setCellValue("GRUPOSNOSOLREP");
					
					i = i+1;
					fila=hoja.createRow(i); // Fila Registros Exportados
					celda=fila.createCell((short)0);
					celda.setCellValue(regExport);
					
				
					
					
					

					for(int celd=0; celd<=15; celd++)
					hoja.autoSizeColumn((short)celd);
											
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=GruposNoSolidarios.xls");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
					
				//	log.info("Termina Reporte");
					}catch(Exception e){
					//	log.info("Error al crear el reporte: " + e.getMessage());
						e.printStackTrace();
					}//Fin del catch
				}
				return  listaIntegrantes;
				
				}

		public GruposNosolidariosServicio getGruposNosolidariosServicio() {
					return gruposNosolidariosServicio;
		}
		public void setGruposNosolidariosServicio(
						GruposNosolidariosServicio gruposNosolidariosServicio) {
		this.gruposNosolidariosServicio = gruposNosolidariosServicio;
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
		
	}



