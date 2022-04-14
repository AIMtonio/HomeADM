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

import cliente.bean.ClienteExMenorBean;
import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.servicio.ClienteExMenorServicio;


   
public class ClienteExMenorRepControlador  extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;	
	ClienteExMenorServicio clienteExMenorServicio = null;
	
	String nombreReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF  = 1 ;		
		  int  reportePDF1 = 2 ;
		  int  reportExcel = 3 ;
		}
	
	
	public ClienteExMenorRepControlador () {
		setCommandClass(ClienteExMenorBean.class);
		setCommandName("clienteExMenorBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ClienteExMenorBean clienteExMenorBean = (ClienteExMenorBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
	
	switch(tipoReporte){	
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = reportePDF(clienteExMenorBean, nombreReporte, response);
		break;
		case Enum_Con_TipRepor.reportePDF1:
			ByteArrayOutputStream htmlStringPDF1 = reporteCanceladosPDF(clienteExMenorBean, nombreReporte, response);
		break;
		case Enum_Con_TipRepor.reportExcel:
			 List listaReportes = listaRepExMenoresCanceladosExcel(3,clienteExMenorBean,response);
		break;
	}	
		return null;	
	}

	
	/* Reporte PDF de haberes ExMenor */
	public ByteArrayOutputStream reportePDF(ClienteExMenorBean clienteExMenorBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = clienteExMenorServicio.reporteHaberesExMenor(clienteExMenorBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteHaberesEsMenor.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF
	
	/* Reporte PDF de Menores Cancelados*/
	public ByteArrayOutputStream reporteCanceladosPDF(ClienteExMenorBean clienteExMenorBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF1 = null;
		try {
			htmlStringPDF1 = clienteExMenorServicio.reporteExMenoresCancelados(clienteExMenorBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteMenoresCancelados.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF1.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF1;
	}// reporte PDF
	
	// Reporte de ExMenores Cancelados Automaticamente
			public List  listaRepExMenoresCanceladosExcel(int tipoLista,ClienteExMenorBean clienteExMenorBean,  HttpServletResponse response){
				List listaExMenoresCancelados=null;
				listaExMenoresCancelados = clienteExMenorServicio.listaRepExMenoresCanceladosExcel(tipoLista,clienteExMenorBean,response); 	
				
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
				HSSFSheet hoja = libro.createSheet("Reporte MenoresCanceladosAutomaticamente");
				HSSFRow fila= hoja.createRow(0);
			
				// inicio usuario,fecha y hora
			
				HSSFCell celdaUsu=fila.createCell((short)1);
				
				celdaUsu = fila.createCell((short)11);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)12);
				
				celdaUsu.setCellValue((!clienteExMenorBean.getNombreUsuario().isEmpty())?clienteExMenorBean.getNombreUsuario(): "TODOS");
				String horaVar=clienteExMenorBean.getHoraEmision();
				String fechaVar=clienteExMenorBean.getFechaEmision();

				
				int itera=0;
				ClienteExMenorBean clientedHora = null;
				if(!listaExMenoresCancelados.isEmpty()){
					for( itera=0; itera<1; itera ++){
						clientedHora = (ClienteExMenorBean) listaExMenoresCancelados.get(itera);
						horaVar= clientedHora.getHoraEmision();			
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
				celdaInst.setCellValue(clienteExMenorBean.getNombreInstitucion());
									
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
							celda.setCellValue("REPORTE DE EXMENORES CANCELADOS AUTOMATICAMENTE POR MAYORIA DE EDAD DEL "+clienteExMenorBean.getFechaInicial()+" AL "+clienteExMenorBean.getFechaFinal());
											
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
				celda.setCellValue("Sucursal Inicial:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)2);
				celda.setCellValue((!clienteExMenorBean.getNomSucursalInicial().equals("")? clienteExMenorBean.getNomSucursalInicial():"TODAS"));
				
				celda = fila.createCell((short)4);
				celda.setCellValue("ExMenor:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)5);
				celda.setCellValue((!clienteExMenorBean.getNombreCompleto().equals("")? clienteExMenorBean.getNombreCompleto():"TODOS"));
				
				
				fila = hoja.createRow(5);
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal Final:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)2);
				celda.setCellValue((!clienteExMenorBean.getNomSucursalFinal().equals("")? clienteExMenorBean.getNomSucursalFinal():"TODAS"));
				
				
				// Creacion de fila
				fila = hoja.createRow(6); // Fila vacia
				fila = hoja.createRow(7);// Campos
										

				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				 
				celda = fila.createCell((short)2);
				celda.setCellValue("Nombre Sucursal");
				celda.setCellStyle(estiloNeg8);
				 
				celda = fila.createCell((short)3);
				celda.setCellValue("Exmenor");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Haberes");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);

				celda = fila.createCell((short)5);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				 
				celda = fila.createCell((short)6);
				celda.setCellValue("Fecha Cancelación");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
				 
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha Entrega");
				celda.setCellStyle(estiloNeg8);
				celda.setCellStyle(estiloCentrado);
			
			
				// Recorremos la lista para la parte de los datos 	
				int i=8,iter=0;
				int tamanioLista = listaExMenoresCancelados.size();
				ClienteExMenorBean clienteloc = null;
				
				for( iter=0; iter<tamanioLista; iter ++){					
					clienteloc = (ClienteExMenorBean) listaExMenoresCancelados.get(iter);
					String aplicado="";
					if(clienteloc.getFechaRetiro().equals("1900-01-01"))
						aplicado="";
					else 
						aplicado=clienteloc.getFechaRetiro();
					
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(clienteloc.getSucursalID());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(clienteloc.getNombreSucursal());
					
					celda=fila.createCell((short)3); 
					celda.setCellValue(clienteloc.getClienteID() + " - " + clienteloc.getNombreCompleto());
										
					celda=fila.createCell((short)4);
					celda.setCellValue(Double.parseDouble(clienteloc.getSaldoAhorro()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)5);
					celda.setCellValue(clienteloc.getEstatusRetiro());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(clienteloc.getFechaCancela());
					celda.setCellStyle(estiloCentrado2);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(aplicado);
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
				response.addHeader("Content-Disposition","inline; filename=RepExMenoresCancelados.xls");
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
				
				
			return  listaExMenoresCancelados;
			
			
			}
	


	

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}



	public void setClienteExMenorServicio(
			ClienteExMenorServicio clienteExMenorServicio) {
		this.clienteExMenorServicio = clienteExMenorServicio;
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