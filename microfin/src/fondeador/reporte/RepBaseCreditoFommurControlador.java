package fondeador.reporte;

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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import fondeador.bean.RedesCuentoBean;
import fondeador.reporte.RepDetalleCredFonControlador.Enum_Con_TipRepor;
import fondeador.servicio.RedesCuentoServicio;

public class RepBaseCreditoFommurControlador extends AbstractCommandController {

	RedesCuentoServicio redesCuentoServicio = null;
	String nombreReporte = null;
	String nomReporte= null;
	String nombReporteCal = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		}
	
	public RepBaseCreditoFommurControlador(){
		setCommandClass(RedesCuentoBean.class);
		setCommandName("redesCuentoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command,
			org.springframework.validation.BindException errors) throws Exception {
	
		RedesCuentoBean redesCuentoBean= (RedesCuentoBean) command;
	
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;
				
		String htmlString= "";
		
		switch(tipoReporte){
		
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = RepBaseCreditoFommurPDF(redesCuentoBean, nombreReporte, response);
		break;
			
		case Enum_Con_TipRepor.ReporExcel:		
			 List listaReportes = repBaseCreditoFommurExcel(tipoLista,redesCuentoBean,response);
		break;
//		case Enum_Con_TipRepor.ReporPDF2:
//			ByteArrayOutputStream htmlStringPDF2 = RepCalificaPorcentResPDF(creditosBean, nombReporteCal, response);
//		break;
//			
//		case Enum_Con_TipRepor.ReporExcel2:		
//			 List listaReportes2 = calificacionesPorcResExcel(tipoLista,creditosBean,response);
//		break;
	}
	
	if(tipoReporte == CreditosBean.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}else {
		return null;
	}
		
//		ByteArrayOutputStream htmlStringPDF = null;
//		try {
//			String contentOriginal = response.getContentType();
//			htmlStringPDF = redesCuentoServicio.reporteDetalleFonPDF(redesCuentoBean, nombreReporte);
//			response.addHeader("Content-Disposition", "inline; filename=DetalleAsigCreditos.pdf");
//			response.setContentType(contentOriginal);
//			
//			byte[] bytes = htmlStringPDF.toByteArray();
//			response.getOutputStream().write(bytes,0,bytes.length);
//			response.getOutputStream().flush();
//			response.getOutputStream().close();
//		} catch (Exception e) {
//			e.printStackTrace();
//		}		
//		return null;
	}

	// Reporte de detalle pdf 
		public ByteArrayOutputStream RepBaseCreditoFommurPDF(RedesCuentoBean redesCuentoBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = redesCuentoServicio.reporteCreditoBaseFommurPDF(redesCuentoBean, nombreReporte);
				response.addHeader("Content-Disposition", "inline; filename=BaseCreditoFommur.pdf");
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
				public List  repBaseCreditoFommurExcel(int tipoLista,RedesCuentoBean redesCuentoBean,  HttpServletResponse response){
				List listaCreditos=null;
				//List listaCreditos = null;
		  	listaCreditos = redesCuentoServicio.listaReportesCreditos(tipoLista,redesCuentoBean,response); 	
				
				int regExport = 0;
				
			//	if(listaCreditos != null){
				

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
					estiloCentrado.setFont(fuenteNegrita8);
					estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					
					
					//Estilo negrita de 8  y color de fondo
					HSSFCellStyle estiloColor = libro.createCellStyle();
					estiloColor.setFont(fuenteNegrita8);
					estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
					estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
					
					
					//Estilo Formato decimal (0.00)
					HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
					HSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
					HSSFDataFormat format = libro.createDataFormat();
					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
					estiloFormatoTasa.setDataFormat(format.getFormat("###0.0000"));
					// Creacion de hoja					
					HSSFSheet hoja = libro.createSheet("Reporte Detalle Asignación de Créditos");
					HSSFRow fila= hoja.createRow(0);
					// inicio usuario,fecha y hora
								HSSFCell celdaUsu=fila.createCell((short)1);
					 
								celdaUsu = fila.createCell((short)14);
								celdaUsu.setCellValue("Usuario:");
								celdaUsu.setCellStyle(estiloNeg8);	
								celdaUsu = fila.createCell((short)15);
								celdaUsu.setCellValue((!redesCuentoBean.getUsuarioAsigna().isEmpty())?redesCuentoBean.getUsuarioAsigna(): "TODOS");
								 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
								            0, //primera fila (0-based)
								            0, //ultima fila  (0-based)
								            17, //primer celda (0-based)
								            20  //ultima celda   (0-based)
								    ));
								
								String horaVar="";
								String fechaVar=redesCuentoBean.getParFechaEmision();

								
								int itera=0;
								RedesCuentoBean creditoHora = null;
								if(!listaCreditos.isEmpty()){
								for( itera=0; itera<1; itera ++){

									creditoHora = (RedesCuentoBean) listaCreditos.get(itera);
									horaVar= creditoHora.getHora();
//									fechaVar= creditoHora.getFecha();
									
								}
								}
								fila = hoja.createRow(1);
								HSSFCell celdaFec=fila.createCell((short)1);
								celdaFec = fila.createCell((short)14);
								celdaFec.setCellValue("Fecha:");
								celdaFec.setCellStyle(estiloNeg8);	
								celdaFec = fila.createCell((short)15);
								celdaFec.setCellValue(fechaVar);
								 
								
								fila = hoja.createRow(2);
								HSSFCell celdaHora=fila.createCell((short)1);
								celdaHora = fila.createCell((short)14);
								celdaHora.setCellValue("Hora:");
								celdaHora.setCellStyle(estiloNeg8);	
								celdaHora = fila.createCell((short)15);
								celdaHora.setCellValue(horaVar);
					    // fin susuario,fecha y hora
								fila = hoja.createRow(3);
					HSSFCell celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("DETALLE DE ASIGNACIÓN DE CRÉDITOS" );
					celda.setCellStyle(estiloDatosCentrado);
				
				    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            3, //primera fila (0-based)
				            3, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            14  //ultima celda   (0-based)
				    ));
				    
					
					// Creacion de fila
					fila = hoja.createRow(4);
					fila = hoja.createRow(5);
					
				
				
					celda = fila.createCell((short)1);
					celda.setCellValue("Selección");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("ID Crédito");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)4);
					celda.setCellValue("Fecha Inicio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Fecha Vencimiento");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Monto Crédito");
					celda.setCellStyle(estiloNeg8);			

					celda = fila.createCell((short)7);
					celda.setCellValue("Saldo Capital");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Producto de Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("Tipo de Persona");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Sexo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Estado Civil");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)12);
					celda.setCellValue("Destino de Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)13);
					celda.setCellValue("Actividad BMX");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)14);
					celda.setCellValue("Direccion Oficial");
					celda.setCellStyle(estiloNeg8);	
					
					int i=7,iter=0;
					int tamanioLista = listaCreditos.size();
					RedesCuentoBean credito = null;
					for( iter=0; iter<tamanioLista; iter ++){
						//Fecha	ID Crédito	No.Cliente	NombreCliente	Id producto	Sucursal	Monto Credito
							credito = (RedesCuentoBean) listaCreditos.get(iter);
							fila=hoja.createRow(i);

							celda=fila.createCell((short)1);
							celda.setCellValue(credito.getFormaSeleccion());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(credito.getCreditoID());
										
							celda=fila.createCell((short)3);
							celda.setCellValue(credito.getNombreCompleto());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(credito.getFechaInicio());
							celda.setCellStyle(estiloDatosCentrado);

							celda=fila.createCell((short)5);
							celda.setCellValue(credito.getFechaVencimien());
							celda.setCellStyle(estiloDatosCentrado);

							celda=fila.createCell((short)6);
							celda.setCellValue(Utileria.convierteLong(credito.getMontoCredito()));
							celda.setCellStyle(estiloFormatoDecimal);

							celda=fila.createCell((short)7);
							celda.setCellValue(Utileria.convierteLong(credito.getSaldoCapital()));
							celda.setCellStyle(estiloFormatoDecimal);
							
							celda=fila.createCell((short)8);
							celda.setCellValue(credito.getDescripcion());
							
							celda=fila.createCell((short)9);
							celda.setCellValue(credito.getTipoPersona());
							celda.setCellStyle(estiloDatosCentrado);
							
							celda=fila.createCell((short)10);
							celda.setCellValue(credito.getSexo());
							
							celda=fila.createCell((short)11);
							celda.setCellValue(credito.getEstadoCivil());
							
							celda=fila.createCell((short)12);
							celda.setCellValue(credito.getDestino());
							
							celda=fila.createCell((short)13);
							celda.setCellValue(credito.getActDescrip());
							
							celda=fila.createCell((short)14);
							celda.setCellValue(credito.getDireccionCompleta());
							
							
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
					
					for(int celd=0; celd<=13; celd++)
					hoja.autoSizeColumn((short)celd);
				
										
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=DetalleAsigCrédito.xls");
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
				//}
				return  listaCreditos;
				
				
				}

		
		
	public RedesCuentoServicio getRedesCuentoServicio() {
		return redesCuentoServicio;
	}

	public void setRedesCuentoServicio(RedesCuentoServicio redesCuentoServicio) {
		this.redesCuentoServicio = redesCuentoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public String getNombReporteCal() {
		return nombReporteCal;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setNombReporteCal(String nombReporteCal) {
		this.nombReporteCal = nombReporteCal;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
}