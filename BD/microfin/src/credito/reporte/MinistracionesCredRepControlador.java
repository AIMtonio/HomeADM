package credito.reporte;
    
import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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

import contabilidad.bean.ReporteBalanzaContableBean;

import credito.bean.CreditosBean;
import credito.bean.ReporteCreditosBean;
import credito.servicio.CreditosServicio;
import credito.bean.ReporteMinistraBean;

public class MinistracionesCredRepControlador extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	
	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public MinistracionesCredRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	CreditosBean creditosBean = (CreditosBean) command;
	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
	0;
			
			creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = creditosServicio.reporteMinistracionesCredito(creditosBean, nomReporte); 
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteMinistracionesCreditoPDF(creditosBean, nomReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = reporteMinistracionesCreditoExcel(tipoLista,creditosBean,response);
				break;
			}
				
				if(tipoReporte == CreditosBean.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
					
			}
			
			// Reporte  de  ministraciones  en PDF
					public ByteArrayOutputStream reporteMinistracionesCreditoPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
						ByteArrayOutputStream htmlStringPDF = null;
						try {
							htmlStringPDF = creditosServicio.reporteMinistracionesCreditoPDF(creditosBean, nomReporte);
							response.addHeader("Content-Disposition","inline; filename=ReporteMinistracionesCredito.pdf");
							response.setContentType("application/pdf");
							byte[] bytes = htmlStringPDF.toByteArray();
							response.getOutputStream().write(bytes,0,bytes.length);
							response.getOutputStream().flush();
							response.getOutputStream().close();
						} catch (Exception e) {
							e.printStackTrace();
							// TODO Auto-generated catch block
							e.printStackTrace();
						}		
					return htmlStringPDF;
					}
					
					
				
					// Reporte de saldos capital de credito en excel
					public List  reporteMinistracionesCreditoExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
					List listaMinistraciones=null;
					//List listaCreditos = null;
					listaMinistraciones = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
					
					int regExport = 0;
					
					//if(listaMinistraciones != null){

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
						
						//Estilo negrita de 8  y color de fondo
						HSSFCellStyle estiloColor = libro.createCellStyle();
						estiloColor.setFont(fuenteNegrita8);
						estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
						estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
						
						
						//Estilo Formato decimal (0.00)
						HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
						HSSFDataFormat format = libro.createDataFormat();
						estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
						
						//centrado
						HSSFCellStyle estiloCentrado = libro.createCellStyle();
						estiloCentrado.setFont(fuenteNegrita8);
						estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
						estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
						
						// Creacion de hoja
						HSSFSheet hoja = libro.createSheet("Reporte de Ministraciones de Crédito");
						HSSFRow fila= hoja.createRow(0);
						HSSFCell celdaUsu=fila.createCell((short)1);
						
												
						//USUARIO
						celdaUsu = fila.createCell((short)13);
						celdaUsu.setCellValue("Usuario:");
						celdaUsu.setCellStyle(estiloNeg8);	
						celdaUsu = fila.createCell((short)14);
						celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						
						String horaVar="";
						String fechaVar=creditosBean.getParFechaEmision();
						
						int itera=0;
						if(!listaMinistraciones.isEmpty()){
						ReporteMinistraBean reporteMinistraBeanHora =null;
							for( itera=0; itera<1; itera ++){

								reporteMinistraBeanHora = (ReporteMinistraBean) listaMinistraciones.get(itera);
								horaVar= reporteMinistraBeanHora.getHora();
								fechaVar= reporteMinistraBeanHora.getFecha();
							
							}
						}
						fila = hoja.createRow(1);
						HSSFCell celdaFec=fila.createCell((short)1);
						
						//NOMBRE INSTITUCION
						celdaFec = fila.createCell((short)4);
						celdaFec.setCellStyle(estiloCentrado);
						celdaFec.setCellValue(creditosBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(
								  1, 1, 4, 11  
						  ));
						
						//FECHA
						celdaFec = fila.createCell((short)13);
						celdaFec.setCellValue("Fecha:");
						celdaFec.setCellStyle(estiloNeg8);	
						celdaFec = fila.createCell((short)14);
						celdaFec.setCellValue(fechaVar);
						
						
						
						//HORA						
						fila = hoja.createRow(2);
						Calendar calendario = new GregorianCalendar();
						HSSFCell celdaHora=fila.createCell((short)1);
						celdaHora = fila.createCell((short)13);
						celdaHora.setCellValue("Hora:");
						celdaHora.setCellStyle(estiloNeg8);	
						celdaHora = fila.createCell((short)14);
						celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE));
						
						HSSFCell celda=fila.createCell((short)4);
						celda.setCellStyle(estiloCentrado);						
						celda.setCellValue("REPORTE DE MINISTRACIONES DEL "+creditosBean.getFechaInicio()+" AL "+creditosBean.getFechaVencimien());
						hoja.addMergedRegion(new CellRangeAddress(
								  2, 2, 4, 11  
						  ));
						// Creacion de fila
						fila = hoja.createRow(3);
						
						fila = hoja.createRow(4);
						celda = fila.createCell((short)1);
						celda.setCellValue("Sucursal:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)2);
						celdaFec.setCellValue((!creditosBean.getNombreSucursal().isEmpty())?creditosBean.getNombreSucursal():"TODAS");
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Promotor:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)5);
						celdaFec.setCellValue((!creditosBean.getNombrePromotor().isEmpty())?creditosBean.getNombrePromotor():"TODOS");

						celda = fila.createCell((short)7);
						celda.setCellValue("Producto Crédito:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)8);
						celdaFec.setCellValue((!creditosBean.getNombreProducto().isEmpty())?creditosBean.getNombreProducto():"TODOS");

						celda = fila.createCell((short)10);
						celda.setCellValue("Fecha Inicio:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)11);
						celdaFec.setCellValue(creditosBean.getFechaInicio());

						celda = fila.createCell((short)13);
						celda.setCellValue("Fecha Fin:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)14);
						celdaFec.setCellValue((creditosBean.getFechaVencimien()));
                         
						fila = hoja.createRow(5);
						celda = fila.createCell((short)1);
						celda.setCellValue("Moneda:");  
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)2);
						celdaFec.setCellValue((!creditosBean.getNombreMoneda().isEmpty())?creditosBean.getNombreMoneda():"TODAS");

						celda = fila.createCell((short)4);
						celda.setCellValue("Género:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)5);
						celdaFec.setCellValue((!creditosBean.getNombreGenero().isEmpty())?creditosBean.getNombreGenero():"TODOS");
						
						celda = fila.createCell((short)7);
						celda.setCellValue("Estado:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)8);
						celdaFec.setCellValue((!creditosBean.getNombreEstado().isEmpty())?creditosBean.getNombreEstado():"TODOS");
						
						celda = fila.createCell((short)10);
						celda.setCellValue("Municipio:");
						celda.setCellStyle(estiloNeg8);
						celdaFec = fila.createCell((short)11);
					
						celdaFec.setCellValue((!creditosBean.getNombreMunicipi().isEmpty())?creditosBean.getNombreMunicipi():"TODOS");
						
					
						if("S".equals(creditosBean.getEsNomina())){
							
								celda = fila.createCell((short)13);
								celda.setCellValue("Institución Nómina:");
								celda.setCellStyle(estiloNeg8);
								celdaFec = fila.createCell((short)14);
								celdaFec.setCellValue((!creditosBean.getNombreInstit().isEmpty())?creditosBean.getNombreInstit():"TODAS");
								if("S".equals(creditosBean.getManejaConvenio()))
								{
								
								fila = hoja.createRow(6);
								
								celda = fila.createCell((short)1);
								celda.setCellValue("Convenio Nómina:");
								celda.setCellStyle(estiloNeg8);
								celdaFec = fila.createCell((short)2);
								celdaFec.setCellValue((!creditosBean.getDesConvenio().isEmpty())?creditosBean.getDesConvenio():"TODOS");
								}
							
						}else {
							fila = hoja.createRow(6);
						}
						
						fila = hoja.createRow(7);
						
						fila = hoja.createRow(8);
						
						//Fuente	Sucursal	Promotor	Cve Cliente		Nombre Cliente	3Solicitud			3Crédito			3Desembolso

						//Inicio en la segunda fila y que el fila uno tiene los encabezados
						celda = fila.createCell((short)1);
						celda.setCellValue("Fuente");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)2);
						celda.setCellValue("Grupo ID");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)3);
						celda.setCellValue("Nombre Grupo");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Sucursal");
						celda.setCellStyle(estiloNeg8);
						// caso de que sea producto de nomina
						int ultCol=4;
						int incCol=0;
						if(creditosBean.getEsNomina().equalsIgnoreCase("S")){
							incCol=1;
							celda = fila.createCell((short)(ultCol+incCol));
							celda.setCellValue("Institución Nómina");
							celda.setCellStyle(estiloNeg8);
							
							incCol=incCol+1;
							celda = fila.createCell((short)(ultCol+incCol));
							celda.setCellValue("Convenio");
							celda.setCellStyle(estiloNeg8);

						}
						celda = fila.createCell((short)(5+incCol));
						celda.setCellValue("Promotor");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(6+incCol));
						celda.setCellValue("Cliente ID");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(7+incCol));
						celda.setCellValue("Nombre Cliente");
						celda.setCellStyle(estiloNeg8);				
						
						celda = fila.createCell((short)(8+incCol));
						celda.setCellValue("Solicitud");
						celda.setCellStyle(estiloCentrado);	
						
						 hoja.addMergedRegion(new CellRangeAddress(
						            8, 8, (8+incCol), (10+incCol)  
						  ));
						 
						celda = fila.createCell((short)(11+incCol));
						celda.setCellValue("Crédito");
						celda.setCellStyle(estiloCentrado);	
							
						hoja.addMergedRegion(new CellRangeAddress(
						           8, 8, (11+incCol), (13+incCol)  
						 ));

						celda = fila.createCell((short)(14+incCol));
						celda.setCellValue("Desembolso");
						celda.setCellStyle(estiloCentrado);	
							
						hoja.addMergedRegion(new CellRangeAddress(
						           8, 8, (14+incCol),(16+incCol)  
						 ));	
						
						fila = hoja.createRow(9);
					 //Id Solicitud	Fecha Alta	Monto|	Id Crédito	Fecha Autorización	Monto|	Monto	Fecha	Instrumento

						celda = fila.createCell((short)(8+incCol));
						celda.setCellValue("ID Solici.");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(9+incCol));
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(10+incCol));
						celda.setCellValue("Monto");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(11+incCol));
						celda.setCellValue("ID Crédito");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(12+incCol));
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(13+incCol));
						celda.setCellValue("Monto");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(14+incCol));
						celda.setCellValue("Monto");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(15+incCol));
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)(16+incCol));
						celda.setCellValue("Instr.");
						celda.setCellStyle(estiloNeg8);
						
						// fila filtros reporte, caso si es producto credito de nomina
						int incFil=0;
						
						int i=(10+incFil),iter=0;
						int tamanioLista=listaMinistraciones.size();
						ReporteMinistraBean reporteMinistraBean=null;
						for(iter=0; iter<tamanioLista; iter ++ ){

							reporteMinistraBean= (ReporteMinistraBean)listaMinistraciones.get(iter);
								fila=hoja.createRow(i);
								//Fuente	Sucursal	Promotor	Clave Cliente	Nombre Cliente

								celda=fila.createCell((short)1);
								celda.setCellValue(reporteMinistraBean.getTipoFondeo());
								
								celda=fila.createCell((short)2);
								celda.setCellValue(reporteMinistraBean.getGrupoID());
								celda=fila.createCell((short)3);
								celda.setCellValue(reporteMinistraBean.getNombreGrupo());
								
								celda=fila.createCell((short)4);
								celda.setCellValue(reporteMinistraBean.getNombreSucurs());
//								//////////////////////Si es producto de nomina
								if(creditosBean.getEsNomina().equalsIgnoreCase("S")){
									celda=fila.createCell((short)5);
									celda.setCellValue(reporteMinistraBean.getInstitucionNominaID());
									celda=fila.createCell((short)6);
									celda.setCellValue(reporteMinistraBean.getConvenioNominaID());
									
								}
//								fin si es producto de nomina								
								celda=fila.createCell((short)(5+incCol));
								celda.setCellValue(reporteMinistraBean.getNombrePromotor());
								
								celda=fila.createCell((short)(6+incCol));
								celda.setCellValue(reporteMinistraBean.getClienteID());
								
								celda=fila.createCell((short)(7+incCol));
								celda.setCellValue(reporteMinistraBean.getNombreCompleto());
								//ID Solicitud	Fecha Alta	Monto
								
								celda=fila.createCell((short)(8+incCol));
								celda.setCellValue(reporteMinistraBean.getSolicitudCreditoID());
								
								celda=fila.createCell((short)(9+incCol));
								celda.setCellValue(reporteMinistraBean.getFechaRegistro());
								celda.setCellStyle(estiloDatosCentrado);
								
								celda=fila.createCell((short)(10+incCol));
								if(!reporteMinistraBean.getMontoSolici().isEmpty()){
								 celda.setCellValue(Double.parseDouble(reporteMinistraBean.getMontoSolici()));
								 celda.setCellStyle(estiloFormatoDecimal);
								}
								else
								{
									 celda.setCellValue(reporteMinistraBean.getMontoSolici());
								}
								
								//ID Crédito	Fecha Autorización	Monto

								celda=fila.createCell((short)(11+incCol));
								celda.setCellValue(reporteMinistraBean.getCreditoID());
								
								celda=fila.createCell((short)(12+incCol));
								celda.setCellValue(reporteMinistraBean.getFechaAutoriza());
								celda.setCellStyle(estiloDatosCentrado);
								
								celda=fila.createCell((short)(13+incCol));
								celda.setCellValue(Double.parseDouble(reporteMinistraBean.getMontoCredito()));
								celda.setCellStyle(estiloFormatoDecimal);
								
								//Monto	Fecha	Instrumento

								celda=fila.createCell((short)(14+incCol));
								celda.setCellValue(Double.parseDouble(reporteMinistraBean.getMontoDesembolso()));
								celda.setCellStyle(estiloFormatoDecimal);
								
								celda=fila.createCell((short)(15+incCol));
								celda.setCellValue(reporteMinistraBean.getFechaInicio());
								celda.setCellStyle(estiloDatosCentrado);
								
								celda=fila.createCell((short)(16+incCol));
								celda.setCellValue(reporteMinistraBean.getTipoDispersion());
							
								
							i++;
						}
						 
						i = i+2;
						fila=hoja.createRow(i);
						celda = fila.createCell((short)0);
						celda.setCellValue("Registros Exportados");
						celda.setCellStyle(estiloNeg8);
						
						i = i+1;
						fila=hoja.createRow(i);
						celda=fila.createCell((short)0);
						celda.setCellValue(tamanioLista);
						

						for(int celd=0; celd<=21; celd++)
						hoja.autoSizeColumn((short)celd);

												
						//Creo la cabecera
						response.addHeader("Content-Disposition","inline; filename=ReporteMinistracionesCredito.xls");
						response.setContentType("application/vnd.ms-excel");
						
						ServletOutputStream outputStream = response.getOutputStream();
						hoja.getWorkbook().write(outputStream);
						outputStream.flush();
						outputStream.close();
						
						}catch(Exception e){
							e.printStackTrace();
						}//Fin del catch
					//} fin if null
					return  listaMinistraciones;
					
					}

	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}


	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}



	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
   
}
