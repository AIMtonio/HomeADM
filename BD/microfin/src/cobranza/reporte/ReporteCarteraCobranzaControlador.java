package cobranza.reporte;

import herramientas.Utileria;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.RepCarteraCobranzaBean;
import cobranza.servicio.AsignaCarteraServicio;
import cobranza.servicio.AsignaCarteraServicio.Enum_Rep_AsignaCartera;

public class ReporteCarteraCobranzaControlador extends AbstractCommandController{
	
	AsignaCarteraServicio asignaCarteraServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public ReporteCarteraCobranzaControlador() {
		setCommandClass(RepCarteraCobranzaBean.class);
		setCommandName("repCarteraCobranzaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RepCarteraCobranzaBean repCarteraCobranzaBean = (RepCarteraCobranzaBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
				int tipoLista =(request.getParameter("tipoLista")!=null)?
						Integer.parseInt(request.getParameter("tipoLista")):
							0;
						switch(tipoReporte){
						case Enum_Rep_AsignaCartera.excelRepCartera:			
							 List listaReportes = reporteCarteraCobranzaExcel(tipoLista,repCarteraCobranzaBean,response);
						break;
						
					}
					return null;			
				}

				// Reporte de Cartera por cobranza
				public List  reporteCarteraCobranzaExcel(int tipoLista,RepCarteraCobranzaBean repCarteraCobranzaBean, HttpServletResponse response){
					
					
					List listaAsignaCobranza = null;

					RepCarteraCobranzaBean reporteCarteraCobranzaBean = null; 
			    	
			    	// SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
					listaAsignaCobranza = asignaCarteraServicio.listaCarteraCobranza(tipoLista,repCarteraCobranzaBean); 	
					
			    	try {	
						//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
						XSSFWorkbook libro = new XSSFWorkbook();
						XSSFFont fuenteNegrita10= libro.createFont();
						fuenteNegrita10.setFontHeightInPoints((short)10);
						fuenteNegrita10.setFontName("Negrita");
						fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
						XSSFCellStyle estiloNeg10 = libro.createCellStyle();
						estiloNeg10.setFont(fuenteNegrita10);

						//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
						XSSFFont fuenteNegrita8= libro.createFont();
						fuenteNegrita8.setFontHeightInPoints((short)8);
						fuenteNegrita8.setFontName("Negrita");
						fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
						XSSFCellStyle estiloNeg8 = libro.createCellStyle();
						estiloNeg8.setFont(fuenteNegrita8);

						// Estilo centrado (S)
						XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
						estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
						estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER); 
						
						// Negrita 10 centrado
						XSSFFont centradoNegrita10 = libro.createFont();
						centradoNegrita10.setFontHeightInPoints((short)10);
						centradoNegrita10.setFontName("Negrita");
						centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
						XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
						estiloNegCentrado10.setFont(fuenteNegrita10);
						estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						
						//Estilo negrita de 8  y color de fondo
						XSSFCellStyle estiloColor = libro.createCellStyle();
						estiloColor.setFont(fuenteNegrita8);
						estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
						estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);

						
						//Estilo Formato decimal (0.00)
						XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
						XSSFDataFormat format = libro.createDataFormat();
						estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));


						XSSFSheet hoja = libro.createSheet("CarteraCobranza");
						XSSFRow fila= hoja.createRow(0);

						XSSFCell celda =fila.createCell((short)3);
						celda.setCellStyle(estiloNegCentrado10);
						celda.setCellValue(repCarteraCobranzaBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //first row (0-based)
					            0, //last row  (0-based)
					            3, //first column (0-based)
					            8  //last column  (0-based)
					    )); 
						

						//celda	= fila.createCell((short)1);
						celda	= fila.createCell((short)44);
						celda.setCellValue("Usuario:");
						celda.setCellStyle(estiloNeg8);	
						celda = fila.createCell((short)45);
						celda.setCellValue(repCarteraCobranzaBean.getNomUsuario());
						Calendar calendario = Calendar.getInstance();
						int hora = calendario.get(Calendar.HOUR_OF_DAY);
						String horaVar = hora+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);


						fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
						celda	= fila.createCell((short)3);			
						celda.setCellStyle(estiloNegCentrado10);
						celda.setCellValue("REPORTE DE CARTERA POR COBRANZA  AL " + repCarteraCobranzaBean.getFechaReporte() );
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //first row (0-based)
					            1, //last row  (0-based)
					            3, //first column (0-based)
					            8  //last column  (0-based)
					    ));
						
						celda	= fila.createCell((short)44);
						celda.setCellValue("Fecha:");
						celda.setCellStyle(estiloNeg8);	
						celda = fila.createCell((short)45);
						celda.setCellValue(repCarteraCobranzaBean.getFechaReporte());

						fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
						celda = fila.createCell((short)44);
						celda.setCellValue("Hora:");
						celda.setCellStyle(estiloNeg8);	
						celda = fila.createCell((short)45);
						celda.setCellValue(horaVar);

												
						fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------		
						// Creacion de fila
						fila = hoja.createRow(5);	//	FILA 5	---------------------------------------------------------

						celda = fila.createCell((short)0);
						celda.setCellValue("Sucursal Ejecutivo");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)1);
						celda.setCellValue("No. Usuario");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)2);
						celda.setCellValue("Nombre Usuario");
						celda.setCellStyle(estiloNeg8);			

						celda = fila.createCell((short)3);
						celda.setCellValue("No. Socio/Cliente");
						celda.setCellStyle(estiloNeg8);		

						celda = fila.createCell((short)4);
						celda.setCellValue("Nombre Socio/Cliente");
						celda.setCellStyle(estiloNeg8);	
						
						celda = fila.createCell((short)5);
						celda.setCellValue(" Fecha Nacimiento");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)6);
						celda.setCellValue("Edad");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)7);
						celda.setCellValue(" Grupo No Solidario");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)8);
						celda.setCellValue("Fecha Ingreso");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)9);
						celda.setCellValue("Persona Relacionada");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)10);
						celda.setCellValue("Ocupación");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)11);
						celda.setCellValue("Municipio");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)12);
						celda.setCellValue("Localidad");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)13);
						celda.setCellValue("Domicilio ");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)14);
						celda.setCellValue("No. Crédito");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)15);
						celda.setCellValue("No. Sucursal");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)16);
						celda.setCellValue("No. Producto");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)17);
						celda.setCellValue("Descripción Producto");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)18);
						celda.setCellValue(" Estatus");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)19);
						celda.setCellValue("Fecha Inicio");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)20);
						celda.setCellValue("Fecha Vencimiento");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)21);
						celda.setCellValue("Frecuencia Pago Cap.");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)22);
						celda.setCellValue(" Monto Ahorro Ordinario");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)23);
						celda.setCellValue(" Monto Ahorro Vista ");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)24);
						celda.setCellValue("Saldo Inversiones");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)25);
						celda.setCellValue(" Monto Otorgado");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)26);
						celda.setCellValue("Saldo Total de Capital ");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)27);
						celda.setCellValue(" Saldo Capital Vigente");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)28);
						celda.setCellValue(" Saldo Capital Atrasado");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)29);
						celda.setCellValue("Saldo Capital Vencido");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)30);
						celda.setCellValue("Saldo Interés Ordinario");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)31);
						celda.setCellValue("Saldo Interés Moratorio");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)32);
						celda.setCellValue("Cant. Cuotas Pagadas");
						celda.setCellStyle(estiloNeg8);			

						celda = fila.createCell((short)33);
						celda.setCellValue(" Cant. Cuotas Vencidas");
						celda.setCellStyle(estiloNeg8);		

						celda = fila.createCell((short)34);
						celda.setCellValue("Cant. Cuotas Vigentes");
						celda.setCellStyle(estiloNeg8);	
						
						celda = fila.createCell((short)35);
						celda.setCellValue("Fecha Último Pago");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)36);
						celda.setCellValue("Monto Garantía Líquida");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)37);
						celda.setCellValue(" Gar. Prendaria Hipotecaria");
						celda.setCellStyle(estiloNeg8);	

						celda = fila.createCell((short)38);
						celda.setCellValue(" Días Atraso");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short)39);
						celda.setCellValue("Teléfono Socio/Cliente");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)40);
						celda.setCellValue(" Tel. Celular Socio/Cliente");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)41);
						celda.setCellValue(" Tel. Trabajo Socio/Cliente");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)42);
						celda.setCellValue("Avales");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)43);
						celda.setCellValue("Gestor Asignado ");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)44);
						celda.setCellValue("Fecha de Asignación");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)45);
						celda.setCellValue("Promesas Pago");
						celda.setCellStyle(estiloNeg8);	

						
						
						
						int tamanioLista = listaAsignaCobranza.size();
						int row = 6;
						for(int iter=0; iter<tamanioLista; iter ++){
						 
							reporteCarteraCobranzaBean = (RepCarteraCobranzaBean) listaAsignaCobranza.get(iter);
							
							fila=hoja.createRow(row);		
						
							celda=fila.createCell((short)0);
							celda.setCellValue(reporteCarteraCobranzaBean.getSucEjecutivo());
							
							celda=fila.createCell((short)1);
							celda.setCellValue(reporteCarteraCobranzaBean.getNumUsuario());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(reporteCarteraCobranzaBean.getNombreUsuario());
							
							celda=fila.createCell((short)3);
							celda.setCellValue(reporteCarteraCobranzaBean.getNumSocio());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(reporteCarteraCobranzaBean.getNombreSocio());
							
							celda=fila.createCell((short)5);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaNac());
							
							celda=fila.createCell((short)6);
							celda.setCellValue(reporteCarteraCobranzaBean.getEdadSocio());
							
							celda=fila.createCell((short)7);
							celda.setCellValue(reporteCarteraCobranzaBean.getGpoNoSolidario());
							
							celda=fila.createCell((short)8);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaIngreso());
							
							celda=fila.createCell((short)9);
							celda.setCellValue(reporteCarteraCobranzaBean.getPerRelacionada());
							
							celda=fila.createCell((short)10);
							celda.setCellValue(reporteCarteraCobranzaBean.getOcupacion());
							
							celda=fila.createCell((short)11);
							celda.setCellValue(reporteCarteraCobranzaBean.getMunicipio());
							
							celda=fila.createCell((short)12);
							celda.setCellValue(reporteCarteraCobranzaBean.getLocalidad());
							
							celda=fila.createCell((short)13);
							celda.setCellValue(reporteCarteraCobranzaBean.getDomicilio());
							
							celda=fila.createCell((short)14);
							celda.setCellValue(reporteCarteraCobranzaBean.getNumCredito());
							
							celda=fila.createCell((short)15);
							celda.setCellValue(reporteCarteraCobranzaBean.getSucCredito());
							
							celda=fila.createCell((short)16);
							celda.setCellValue(reporteCarteraCobranzaBean.getNumProdCretito());
							
							celda=fila.createCell((short)17);
							celda.setCellValue(reporteCarteraCobranzaBean.getDesProdCredito());
							
							celda=fila.createCell((short)18);
							celda.setCellValue(reporteCarteraCobranzaBean.getEstatusCredito());
							
							celda=fila.createCell((short)19);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaInicio());
							
							celda=fila.createCell((short)20);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaVencimiento());
							
							celda=fila.createCell((short)21);
							celda.setCellValue(reporteCarteraCobranzaBean.getFrecuenciaPagoCap());
							
							celda=fila.createCell((short)22);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getMontoAhorroOrd()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)23);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getMontoAhorroVista()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)24);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoInversiones()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)25);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getMontoOtorgado()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)26);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoCapital()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)27);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoCapitalVigente()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)28);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoCapitalAtradaso()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)29);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoCapitalVencido()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)30);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoInteresOrdinario()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)31);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getSaldoInteresMora()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)32);
							celda.setCellValue(reporteCarteraCobranzaBean.getCuotasPagadas());
							
							celda=fila.createCell((short)33);
							celda.setCellValue(reporteCarteraCobranzaBean.getCuotasVencidas());
							
							celda=fila.createCell((short)34);
							celda.setCellValue(reporteCarteraCobranzaBean.getCuotasVigentes());
							
							celda=fila.createCell((short)35);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaUltPago());
							
							celda=fila.createCell((short)36);
							celda.setCellValue(Utileria.convierteDoble(reporteCarteraCobranzaBean.getMontGarantiaLiquida()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)37);
							celda.setCellValue(reporteCarteraCobranzaBean.getGarPrendHipotecaria());
							
							celda=fila.createCell((short)38);
							celda.setCellValue(reporteCarteraCobranzaBean.getDiasAtraso());
							
							celda=fila.createCell((short)39);
							celda.setCellValue(reporteCarteraCobranzaBean.getTelefono());
							
							celda=fila.createCell((short)40);
							celda.setCellValue(reporteCarteraCobranzaBean.getTelefonoCelular());
							
							celda=fila.createCell((short)41);
							celda.setCellValue(reporteCarteraCobranzaBean.getTelefonoTrabajo());
							
							celda=fila.createCell((short)42);
							celda.setCellValue(reporteCarteraCobranzaBean.getAvales());
							
							celda=fila.createCell((short)43);
							celda.setCellValue(reporteCarteraCobranzaBean.getGestor());
							
							celda=fila.createCell((short)44);
							celda.setCellValue(reporteCarteraCobranzaBean.getFechaAsignacion());
							
							celda=fila.createCell((short)45);
							celda.setCellValue(reporteCarteraCobranzaBean.getPromesasPago());

									
								
							row++;

						} 

						row = row+2;
						fila=hoja.createRow(row);
						celda = fila.createCell((short)0);
						celda.setCellValue("Registros Exportados");
						celda.setCellStyle(estiloNeg8);
						
						row = row+1;
						fila=hoja.createRow(row);
						celda=fila.createCell((short)0);
						celda.setCellValue(tamanioLista);
						
						// Autoajusta las columnas
						for(int celd=0; celd<=45; celd++)
						hoja.autoSizeColumn((short)celd);
											
						//Creo la cabecera
						response.addHeader("Content-Disposition","inline; filename=RepCarteraCobranza.xls");
						response.setContentType("application/vnd.ms-excel");
						
						ServletOutputStream outputStream = response.getOutputStream();
						hoja.getWorkbook().write(outputStream);
						outputStream.flush();
						outputStream.close();
						
						
			    	}catch(Exception e){
			    		e.printStackTrace();
			    	}//Fin del catch
						
					return  listaAsignaCobranza;
					
					
				}

				
				

				public AsignaCarteraServicio getAsignaCarteraServicio() {
					return asignaCarteraServicio;
				}

				public void setAsignaCarteraServicio(AsignaCarteraServicio asignaCarteraServicio) {
					this.asignaCarteraServicio = asignaCarteraServicio;
				}

				public String getNombreReporte() {
					return nombreReporte;
				}

				public void setNombreReporte(String nombreReporte) {
					this.nombreReporte = nombreReporte;
				}

				public String getSuccessView() {
					return successView;
				}

				public void setSuccessView(String successView) {
					this.successView = successView;
				}
				
				
}
