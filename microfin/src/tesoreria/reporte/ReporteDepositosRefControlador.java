package tesoreria.reporte;

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

import cliente.bean.ClienteExMenorBean;
import cliente.bean.ReporteClienteLocMarginadasBean;
import tesoreria.bean.RepDepositosRefBean;
import tesoreria.servicio.RepDepositosRefServicio;


public class ReporteDepositosRefControlador extends AbstractCommandController {

	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	RepDepositosRefServicio repDepositosRefServicio = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPDF= 1 ;
			  int  ReporExcel= 2 ;
		}
		public ReporteDepositosRefControlador () {
			setCommandClass(RepDepositosRefBean.class);
			setCommandName("repDepositosRefBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors)throws Exception {
			
			RepDepositosRefBean repDepositosRefBean = (RepDepositosRefBean) command;

				int tipoReporte =(request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
								0;
				int tipoLista =(request.getParameter("tipoLista")!=null)?
								Integer.parseInt(request.getParameter("tipoLista")):
								0;
			
				String htmlString= "";
				
			switch(tipoReporte){			
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = depositosReferefenciadosPDF(repDepositosRefBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:					
					 List listaReportes = listaRepDepositosRefExcel(tipoLista,repDepositosRefBean,response);
				break;
			}
			return null;
				
		}
		
		// Reporte de Depositos Referenciados pdf
		public ByteArrayOutputStream depositosReferefenciadosPDF(RepDepositosRefBean repDepositosRefBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = repDepositosRefServicio.reporteDepositosRefPDF(repDepositosRefBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteDepositosReferenciados.pdf");
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
		public List  listaRepDepositosRefExcel(int tipoLista,RepDepositosRefBean repDepositosRefBean,  HttpServletResponse response){
			List listaRepDepositosRef=null;
			listaRepDepositosRef = repDepositosRefServicio.listaRepoteDepositosRefExcel(tipoLista,repDepositosRefBean,response); 	
		
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
				estiloCentrado.setFont(fuenteNegrita8);
				
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
				HSSFSheet hoja = libro.createSheet("Reporte Depositos Referenciados");
				HSSFRow fila= hoja.createRow(0);
			
				// inicio usuario,fecha y hora
			
				HSSFCell celdaUsu=fila.createCell((short)1);
				
				celdaUsu = fila.createCell((short)11);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)12);
				
				celdaUsu.setCellValue((!repDepositosRefBean.getNombreUsuario().isEmpty())?repDepositosRefBean.getNombreUsuario(): "TODOS");
				String horaVar=repDepositosRefBean.getHoraEmision();
				String fechaVar=repDepositosRefBean.getFechaEmision();

				
				int itera=0;
				RepDepositosRefBean depositosHora = null;
				if(!listaRepDepositosRef.isEmpty()){
					for( itera=0; itera<1; itera ++){
						depositosHora = (RepDepositosRefBean) listaRepDepositosRef.get(itera);
						horaVar= depositosHora.getHoraEmision();			
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
				celdaInst.setCellValue(repDepositosRefBean.getNombreInstitucion());
									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda   (0-based)
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
							celda.setCellValue("REPORTE DEPOSITOS REFERENCIADOS "+repDepositosRefBean.getFechaInicial()+" AL "+repDepositosRefBean.getFechaFinal());
											
							 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
							            2, //primera fila (0-based)
							            2, //ultima fila  (0-based)
							            1, //primer celda (0-based)
							            10  //ultima celda   (0-based)
							    ));
							 
							 celda.setCellStyle(estiloCentrado);
							 
								
				// Creacion de fila
				fila = hoja.createRow(3); // Fila vacia
				fila = hoja.createRow(4);// Campos

				celda = fila.createCell((short)1);
				celda.setCellValue("Institución:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)2);
				celda.setCellValue(repDepositosRefBean.getDesnombreInstitucion());
								
				celda = fila.createCell((short)3);
				celda.setCellValue("Cuenta:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)4);
				celda.setCellValue((!repDepositosRefBean.getCuentaBancaria().equals("0")? repDepositosRefBean.getCuentaBancaria():"TODAS"));

				celda = fila.createCell((short)5);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)6);
				celda.setCellValue(repDepositosRefBean.getDessucursalID());
					
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Socio:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)8);
				celda.setCellValue((!repDepositosRefBean.getClienteID().equals("0")? repDepositosRefBean.getClienteID():"TODOS"));
					
				celda = fila.createCell((short)9);
				celda.setCellValue("Estado:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)10);
				celda.setCellValue(repDepositosRefBean.getDescestado());
			
				
				// Creacion de fila
				fila = hoja.createRow(5); // Fila vacia
				fila = hoja.createRow(6);// Campos
										

				celda = fila.createCell((short)1);
				celda.setCellValue("Socio");
				celda.setCellStyle(estiloNeg8);				
				 
				celda = fila.createCell((short)2);
				celda.setCellValue("Nombre del Cliente");
				celda.setCellStyle(estiloNeg8);	
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNeg8);				
				
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Metodo de Pago");
				celda.setCellStyle(estiloNeg8);	
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo de Movimiento");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Descripción Movimiento");
				celda.setCellStyle(estiloNeg8);				

				celda = fila.createCell((short)7);
				celda.setCellValue("Banco");
				celda.setCellStyle(estiloNeg8);				
				 
				celda = fila.createCell((short)8);
				celda.setCellValue("Cuenta Bancaria");
				celda.setCellStyle(estiloNeg8);				
				 
				celda = fila.createCell((short)9);
				celda.setCellValue("Estado");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Tipo de Carga ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Fecha de Carga ");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Fecha Aplicación");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNeg8);				
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Monto Aplicado");
				celda.setCellStyle(estiloNeg8);		
	
			
				// Recorremos la lista para la parte de los datos 	
				int i=7,iter=0;
				int tamanioLista = listaRepDepositosRef.size();
				RepDepositosRefBean depositosref = null;
				
				for( iter=0; iter<tamanioLista; iter ++){					
					depositosref = (RepDepositosRefBean) listaRepDepositosRef.get(iter);
//										
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(depositosref.getClienteID());
										
					celda=fila.createCell((short)2);
					celda.setCellValue(depositosref.getNombreCompleto());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(depositosref.getReferencia());
					
					celda=fila.createCell((short)4);
					celda.setCellValue((depositosref.getTipoDeposito().equals("E")) ? "Efectivo" : (depositosref.getTipoDeposito().equals("T")) ? "Transferencia" : "Cheque");
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)5); 
					celda.setCellValue(depositosref.getTipoMovimiento());
										
					celda=fila.createCell((short)6);
					celda.setCellValue(depositosref.getDescripcionMov());
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)7);
					celda.setCellValue(depositosref.getBanco());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(depositosref.getCuentaBancaria());
										
					celda=fila.createCell((short)9);
					celda.setCellValue(depositosref.getEstado());
					
					celda=fila.createCell((short)10);
					celda.setCellValue(depositosref.getTipoCarga());
					
					celda=fila.createCell((short)11);
					celda.setCellValue(depositosref.getFechaCarga());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(depositosref.getFechaAplicacion());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)13);				
					celda.setCellValue(depositosref.getMonto());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(depositosref.getMontoAplicado());
					celda.setCellStyle(estiloFormatoDecimal);

					
					i++;
				}
				 
				i = i+2;
				fila=hoja.createRow(i); // Fila Registros Exportados
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				celda=fila.createCell((short)13);
				celda.setCellValue("Procedure:");
				celda.setCellStyle(estiloNeg8);
				
				celda=fila.createCell((short)14);
				celda.setCellValue("DEPOSITOSREFEREP");
				
				i = i+1;
				fila=hoja.createRow(i); // Fila Total de Registros Exportados
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				

				for(int celd=0; celd<=15; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=RepDepositosRef.xls");
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
				
				
			return  listaRepDepositosRef;
			
			
			}

	
		
		// getter y setters //
		public RepDepositosRefServicio getRepDepositosRefServicio() {
			return repDepositosRefServicio;
		}

		public void setRepDepositosRefServicio(
				RepDepositosRefServicio repDepositosRefServicio) {
			this.repDepositosRefServicio = repDepositosRefServicio;
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
