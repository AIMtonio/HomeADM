package credito.reporte;
     
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
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

import tesoreria.bean.DispersionGridBean;

import com.lowagie.text.pdf.hyphenation.TernaryTree.Iterator;

import credito.bean.CreditosBean;
import credito.bean.RepMasivoFRBean;
import credito.bean.ReporteMinistraBean;
import credito.reporte.MinistracionesCredRepControlador.Enum_Con_TipRepor;
import credito.servicio.CreditosServicio;

public class ReporteCargaMasivaFRControlador extends AbstractCommandController{
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporTxt= 2 ;
		  int  ReporExcel= 3 ;
	}
	
	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public ReporteCargaMasivaFRControlador () {
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
					
				break;
					
				case Enum_Con_TipRepor.ReporTxt:
					 List listaReportesTxt = reporteMasivoFRArchivoTXT(tipoLista,creditosBean,response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = reporteMasivoFRExcel(tipoLista,creditosBean,response);
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
							response.addHeader("Content-Disposition","inline; filename=ReporteMinistraciones.pdf");
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
					
					
				
					// Reporte de saldos capital de credito en excel
					public List  reporteMasivoFRExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
					List listaFR=null;
					//List listaCreditos = null;
					listaFR = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
					
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
						
						//Estilo negrita de 8  y color de fondo
						HSSFCellStyle estiloColor = libro.createCellStyle();
						estiloColor.setFont(fuenteNegrita8);
						estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
						estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
						
						
						//Estilo Formato decimal (0.00)
						HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
						HSSFDataFormat format = libro.createDataFormat();
						estiloFormatoDecimal.setDataFormat(format.getFormat("0.00"));
						
						//centrado
						HSSFCellStyle estiloCentrado = libro.createCellStyle();
						estiloCentrado.setFont(fuenteNegrita8);
						estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
						estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
						
					    // Lista de encabezados del excel de FR
						List<String> listaTitulosFR = new ArrayList<String>();	
						/* 1  */listaTitulosFR.add("- Tipo de operación");
						/* 2  */listaTitulosFR.add("- No de cliente del intermediario");
						/* 3  */listaTitulosFR.add("- No de línea");
						/* 4  */listaTitulosFR.add("- No de disposición");
						/* 5  */listaTitulosFR.add("- No de cliente del acreditado");
						/* 6  */listaTitulosFR.add("- No de crédito del acreditado");
						/* 7  */listaTitulosFR.add("- Nombre del acreditado");
						/* 8  */listaTitulosFR.add("- Tipo de persona");
						/* 9  */listaTitulosFR.add("- Sexo");
						/* 10 */listaTitulosFR.add("- CURP");
						/* 11 */listaTitulosFR.add("- RFC");
						/* 12 */listaTitulosFR.add("- Entidad federativa");
						/* 13 */listaTitulosFR.add("- Tipo de productor");
						/* 14 */listaTitulosFR.add("- Figura jurídica");
						/* 15 */listaTitulosFR.add("- Tipo de crédito");
						/* 16 */listaTitulosFR.add("- Producto/Cultivo");
						/* 17 */listaTitulosFR.add("- Destino del crédito");
						/* 18 */listaTitulosFR.add("- Tipo de unidad");
						/* 19 */listaTitulosFR.add("- Unidades a habilitar");
						/* 20 */listaTitulosFR.add("- Riego o temporal");
						/* 21 */listaTitulosFR.add("- Ciclo agrícola");
						/* 22 */listaTitulosFR.add("- Fecha de apertura");
						/* 23 */listaTitulosFR.add("- Fecha de vencimiento");
						/* 24 */listaTitulosFR.add("- Monto del crédito");
						/* 25 */listaTitulosFR.add("- Tipo de moneda");
						/* 26 */listaTitulosFR.add("- Periodicidad de pagos");
						/* 27 */listaTitulosFR.add("- Estatus del crédito");
						/* 28 */listaTitulosFR.add("- No de días de atraso");
						/* 29 */listaTitulosFR.add("- Capital vigente");
						/* 30 */listaTitulosFR.add("- Intereses vigentes");
						/* 31 */listaTitulosFR.add("- Capital vencido");
						/* 32 */listaTitulosFR.add("- Intereses vencidos");
						/* 33 */listaTitulosFR.add("- Saldo total");
						/* 34 */listaTitulosFR.add("- Fecha de saldo");
						/* 35 */listaTitulosFR.add("- Tipo de tasa");
						/* 36 */listaTitulosFR.add("- Base de referencia");
						/* 37 */listaTitulosFR.add("- Puntos adicionales a la base");
						/* 38 */listaTitulosFR.add("- Tasa");
						/* 39 */listaTitulosFR.add("- Municipio");
						/* 40 */listaTitulosFR.add("- Monto Otorgado Financiera Rural");
						/* 41 */listaTitulosFR.add("- Apoyo FONAGA");
						/* 42 */listaTitulosFR.add("- Programas especiales");
						/* 43 */listaTitulosFR.add("- No. Ministración");

						// Creacion de hoja
						HSSFSheet hoja = libro.createSheet("Reporte Masivo para Financiera Rural");
						HSSFRow fila= hoja.createRow(0);
						HSSFCell celda=null;
						for (int cel=0; cel < listaTitulosFR.size(); cel ++){
					    String  titulo= (String) listaTitulosFR.get(cel);
					    celda=fila.createCell((short)cel);
						celda.setCellValue(titulo);
						celda.setCellStyle(estiloNeg8);
						}
                     		
						
						int i=1,iter=0;
						int tamanioLista=listaFR.size();
						RepMasivoFRBean repFRBean=null;
						for(iter=0; iter<tamanioLista; iter ++ ){

							repFRBean= (RepMasivoFRBean)listaFR.get(iter);
								fila=hoja.createRow(i);
						
								celda=fila.createCell((short)0);// [1] en frExcel
								celda.setCellValue(repFRBean.getTipoOperacion());
														
								celda=fila.createCell((short)1);// [2] en frExcel
								celda.setCellValue(repFRBean.getNumCliIntermediario());
								
								celda=fila.createCell((short)2);// [3] en frExcel
								celda.setCellValue(repFRBean.getNumeroLinea());
								
								celda=fila.createCell((short)3);// [4] en frExcel
								celda.setCellValue(repFRBean.getNumDisposicion());
								
								celda=fila.createCell((short)4);// [5] en frExcel
								celda.setCellValue(repFRBean.getClienteID());
								
								celda=fila.createCell((short)5);// [6] en frExcel
								celda.setCellValue(repFRBean.getCreditoID());
								
								celda=fila.createCell((short)6);// [7] en frExcel
								celda.setCellValue(repFRBean.getNombreCompleto());
								
								celda=fila.createCell((short)7);// [8] en frExcel
								celda.setCellValue(repFRBean.getTipoPersona());
									
								celda=fila.createCell((short)8);// [9] en frExcel
								celda.setCellValue(repFRBean.getSexo());
								
								celda=fila.createCell((short)9);// [10] en frExcel
								celda.setCellValue(repFRBean.getCURP());
								
								celda=fila.createCell((short)10);// [11] en frExcel
								celda.setCellValue(repFRBean.getRFC());
								
								celda=fila.createCell((short)11);// [12] en frExcel
								celda.setCellValue(repFRBean.getEstadoID());
								
								celda=fila.createCell((short)12);// [13] en frExcel
								celda.setCellValue(repFRBean.getTipoProductor());
								
								celda=fila.createCell((short)13);// [14] en frExcel
								celda.setCellValue(repFRBean.getFiguraJuridica());
								
								celda=fila.createCell((short)14);// [15] en frExcel
								celda.setCellValue(repFRBean.getTipoCredito());
												
								celda=fila.createCell((short)15);// [16] en frExcel
								celda.setCellValue(repFRBean.getActividadFR());
								
								celda=fila.createCell((short)16);// [17] en frExcel
								celda.setCellValue(repFRBean.getDestinoCredito());
								
								celda=fila.createCell((short)17);// [18] en frExcel
								celda.setCellValue(repFRBean.getTipoUnidad());
								
								celda=fila.createCell((short)18);// [19] en frExcel
								celda.setCellValue(repFRBean.getUnidHabilitar());
								
								celda=fila.createCell((short)19);// [20] en frExcel
								celda.setCellValue(repFRBean.getRiegoTemporal());
								
								celda=fila.createCell((short)20);// [21] en frExcel
								celda.setCellValue(repFRBean.getCicloAgricola());
								
								celda=fila.createCell((short)21);// [22] en frExcel
								celda.setCellValue(repFRBean.getFechaApertura());
								
								celda=fila.createCell((short)22);// [23] en frExcel
								celda.setCellValue(repFRBean.getFechaVencimiento());
								
								celda=fila.createCell((short)23);// [24] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getMontoCredito()));
											
								celda=fila.createCell((short)24);// [25] en frExcel
								celda.setCellValue(repFRBean.getTipoMoneda());
								
								celda=fila.createCell((short)25);// [26] en frExcel
								celda.setCellValue(repFRBean.getPeriodicidadPagos());
								
								celda=fila.createCell((short)26);// [27] en frExcel
								celda.setCellValue(repFRBean.getEstatusCredito());
								
								celda=fila.createCell((short)27);// [28] en frExcel
								celda.setCellValue(repFRBean.getDiasAtraso());
								
								celda=fila.createCell((short)28);// [29] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getCapitalVigente()));
								
								celda=fila.createCell((short)29);// [30] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getInteresesVigente()));
								
								celda=fila.createCell((short)30);// [31] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getCapitalVencido()));
								
								celda=fila.createCell((short)31);// [32] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getInteresesVencido()));
								
								celda=fila.createCell((short)32);// [33] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getSaldoTotal()));
								
								celda=fila.createCell((short)33);// [34] en frExcel
								celda.setCellValue(repFRBean.getFechaSaldo());
								
								celda=fila.createCell((short)34);// [35] en frExcel
								celda.setCellValue(repFRBean.getTipoTasa());
								
								celda=fila.createCell((short)35);// [36] en frExcel
								celda.setCellValue(repFRBean.getBaseReferencia());
								
								celda=fila.createCell((short)36);// [37] en frExcel
								celda.setCellValue(repFRBean.getPuntsAdicionales());
							
									
								celda=fila.createCell((short)37);// [38] en frExcel
								celda.setCellValue(repFRBean.getTasaFija());
								
								celda=fila.createCell((short)38);// [39] en frExcel
								celda.setCellValue(repFRBean.getMunicipioID());
								
								celda=fila.createCell((short)39);// [40] en frExcel
								celda.setCellValue(Double.parseDouble(repFRBean.getMontoOtorgadoFR()));
								
								celda=fila.createCell((short)40);// [41] en frExcel
								celda.setCellValue(repFRBean.getApoyoFONAGA());
								
								celda=fila.createCell((short)41);// [42] en frExcel
								celda.setCellValue(repFRBean.getProgEspeciales());
								
								celda=fila.createCell((short)42);// [43] en frExcel
								celda.setCellValue(repFRBean.getNumMinistracion());
								
							i++;
						}
						 
											

						for(int celd=0; celd<=42; celd++)
						hoja.autoSizeColumn((short)celd);

												
						//Creo la cabecera
						response.addHeader("Content-Disposition","inline; filename=ReporteMasivoFR.xls");
						response.setContentType("application/vnd.ms-excel");
						
						ServletOutputStream outputStream = response.getOutputStream();
						hoja.getWorkbook().write(outputStream);
						outputStream.flush();
						outputStream.close();
						
						}catch(Exception e){
							e.printStackTrace();
						}//Fin del catch
					//} fin if null
					return  listaFR;
					
					}
					
					
					public List  reporteMasivoFRArchivoTXT (int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
						List listaFR=null;
						//List listaCreditos = null;
						 	
						String archivoSal ="RepMasivoFR-"+creditosBean.getFechaInicio()+".txt";
						try{
							ServletOutputStream ouputStream=null;
							BufferedWriter writer = new BufferedWriter(new FileWriter(archivoSal));
							
							listaFR = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response);
							
						
							
							 if (!listaFR.isEmpty()){
								 
								 int i=1,iter=0;
									int tamanioLista=listaFR.size();
									RepMasivoFRBean repFRBean=null;
									for(iter=0; iter<tamanioLista; iter ++ ){

										repFRBean= (RepMasivoFRBean)listaFR.get(iter);
									 
									 writer.write(		

											 repFRBean.getTipoOperacion()+"|"+ 	//[1]
											 ""+repFRBean.getNumCliIntermediario()+"|"+	//[2]
											 ""+repFRBean.getNumeroLinea()+"|"+	//[3]
											 ""+repFRBean.getNumDisposicion()+"|"+	//[4]
											 ""+repFRBean.getClienteID()+"|"+	//[5]
											 ""+repFRBean.getCreditoID()+"|"+	//[6]
											 ""+repFRBean.getNombreCompleto()+"|"+	//[7]
											 ""+repFRBean.getTipoPersona()+"|"+	//[8]
											 ""+repFRBean.getSexo()+"|"+	//[9]
											 ""+repFRBean.getCURP()+"|"+	//[10]
											 ""+repFRBean.getRFC()+"|"+	//[11]
											 ""+repFRBean.getEstadoID()+"|"+	//[12]
											 ""+repFRBean.getTipoProductor()+"|"+	//[13]
											 ""+repFRBean.getFiguraJuridica()+"|"+	//[14]
											 ""+repFRBean.getTipoCredito()+"|"+	//[15]
											 ""+repFRBean.getActividadFR()+"|"+	//[16]
											 ""+repFRBean.getDestinoCredito()+"|"+	//[17]
											 ""+repFRBean.getTipoUnidad()+"|"+	//[18]
										     ""+repFRBean.getUnidHabilitar()+"|"+	//[19]
											 ""+repFRBean.getRiegoTemporal()+"|"+	//[20]
											 ""+repFRBean.getCicloAgricola()+"|"+	//[21]
											 ""+repFRBean.getFechaApertura()+"|"+	//[22]
											 ""+repFRBean.getFechaVencimiento()+"|"+	//[23]
											 ""+repFRBean.getMontoCredito()+"|"+	//[24]
											 ""+repFRBean.getTipoMoneda()+"|"+	//[25]
											 ""+repFRBean.getPeriodicidadPagos()+"|"+	//[26]
											 ""+repFRBean.getEstatusCredito()+"|"+	//[27]
											 ""+repFRBean.getDiasAtraso()+"|"+	//[28]
										     ""+repFRBean.getCapitalVigente()+"|"+	//[29]
											 ""+repFRBean.getInteresesVigente()+"|"+	//[30]
											 ""+repFRBean.getCapitalVencido()+"|"+	//[31]
											 ""+repFRBean.getInteresesVencido()+"|"+	//[32]
											 ""+repFRBean.getSaldoTotal()+"|"+	//[33]
											 ""+repFRBean.getFechaSaldo()+"|"+	//[34]
											 ""+repFRBean.getTipoTasa()+"|"+	//[35]
											 ""+repFRBean.getBaseReferencia()+"|"+	//[36]
											 ""+repFRBean.getPuntsAdicionales()+"|"+	//[37]
											 ""+repFRBean.getTasaFija()+"|"+	//[38]
											 ""+repFRBean.getMunicipioID()+"|"+	//[39]
											 ""+repFRBean.getMontoOtorgadoFR()+"|"+	//[40]
											 ""+repFRBean.getApoyoFONAGA()+"|"+	//[41]
											 ""+repFRBean.getProgEspeciales()+"|"+	//[42]
											 repFRBean.getNumMinistracion()	//[43]
												);        
										writer.newLine(); // Esto es un salto de linea	
								 }
								 				 
							 }else{
								 writer.write("");
							 }
										
							writer.close();
							
							
					        FileInputStream archivo = new FileInputStream(archivoSal);
					        int longitud = archivo.available();
					        byte[] datos = new byte[longitud];
					        archivo.read(datos);
					        archivo.close();
					        
					        response.setHeader("Content-Disposition","attachment;filename="+archivoSal);
					    	response.setContentType("application/text");
					    	ouputStream = response.getOutputStream();
					    	ouputStream.write(datos);
					    	ouputStream.flush();
					    	ouputStream.close();
					    
					            
						}catch(IOException io ){
							io.printStackTrace();
						}		
						
						return listaFR;
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
