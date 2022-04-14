package credito.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import herramientas.Utileria;
import inversiones.bean.InversionBean;

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
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.bean.ReporteCreditosBean;
import credito.bean.ReporteMovimientosCreditosBean;
import credito.reporte.SaldosCapitalRepControlador.Enum_Con_TipRepor;
import credito.servicio.CreditosServicio;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class RepMovsCredSumControlador extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;
	String nomReporMovCred = null;
	MonedasServicio monedasServicio = null;
	String successView = null;
	
	public RepMovsCredSumControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
	
		CreditosBean creditosBean = (CreditosBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;

		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;
				
		switch(tipoReporte){	
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringpdf = reporMovsCreditoSumaPDF(creditosBean, nomReporMovCred, response); 		
			break;
			case Enum_Con_TipRepor.ReporExcel:		
				List<CreditosBean>listaReportes = movimientosCreditosumExcel(tipoLista,creditosBean,response,request);
			break;
		}
		
		return null;
		
	}
	
	
	// Reporte de movimientos de creditos sumarizado en pdf
		public ByteArrayOutputStream reporMovsCreditoSumaPDF(CreditosBean creditosBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringpdf = null;		
			try {
				htmlStringpdf = creditosServicio.reporMovsCreditoSumPDF(creditosBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteMoviCredSumarizado.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringpdf.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		return htmlStringpdf;
		}
	

	// Reporte movimientos de credito sumarizado en excel
	/**
	 * Reporte de Movimientos Sumarizados de Créditos
	 * @param tipoLista Numero 15
	 * @param creditosBean Bean de consulta CreditosBean
	 * @param response
	 * @param request
	 * @return
	 */
	public List  movimientosCreditosumExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response,HttpServletRequest request){
		List listaCreditosSum=null;
		listaCreditosSum = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		
		int regExport = 0;		
		MonedasBean monedaBean = null;
		monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
													creditosBean.getMonedaID());		
		creditosBean.setMonedaID(monedaBean.getDescriCorta());
		
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
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Reporte Movimientos de Credito");
			HSSFRow fila= hoja.createRow(0);
			
			HSSFCell celdaUsu=fila.createCell((short)0);
			celdaUsu.setCellStyle(estiloNeg10);
			celdaUsu.setCellValue(request.getParameter("nombreInstitucion"));					
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            8  //ultima celda   (0-based)
		    ));
			celdaUsu.setCellStyle(estiloCentrado);
			
			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");

			String horaVar="";
			String fechaVar=creditosBean.getParFechaEmision();
			String numCuenta="";
			boolean cobraSeguroCuota=false;

			
			int itera=0;
			ReporteMovimientosCreditosBean creditoHora = null;
			if(!listaCreditosSum.isEmpty()){
				for( itera=0; itera<1; itera ++){
					creditoHora = (ReporteMovimientosCreditosBean) listaCreditosSum.get(itera);
					horaVar= creditoHora.getHoraMov();
					fechaVar= creditosBean.getParFechaEmision();
					numCuenta=creditoHora.getCuentaID();
					cobraSeguroCuota= creditoHora.getCobraSeguroCuota().equals("S")?true:false;
				}
			}
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE MOVIMIENTOS DE PAGO POR CRÉDITO DEL "+creditosBean.getFechaInicio()+" AL "+creditosBean.getFechaVencimien());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
			celda.setCellStyle(estiloCentrado);
		    
		
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(horaVar);
						
			// Creacion de fila
			fila = hoja.createRow(3);
			// celda titulo
			celdaHora = fila.createCell((short)1);
			celdaHora.setCellValue("No. Crédito:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)2);
			celdaHora.setCellValue(creditosBean.getCreditoID());

			// Creacion de fila
			fila = hoja.createRow(4);
			//celda titulo
			celdaHora = fila.createCell((short)1);
			celdaHora.setCellValue("No. Cuenta:");
			
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)2);
			celdaHora.setCellValue(numCuenta);
			
			celdaHora = fila.createCell((short)3);
			celdaHora.setCellValue("Fecha Desembolso:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)4);
			celdaHora.setCellValue(request.getParameter("fechaMinistrado"));
			
			celdaHora = fila.createCell((short)5);
			celdaHora.setCellValue("Monto Otorgado:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)6);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getMontoCredito()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			celdaHora = fila.createCell((short)7);
			celdaHora.setCellValue("Moneda:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			
			celdaHora = fila.createCell((short)8);
			celdaHora.setCellValue(creditosBean.getMonedaID());
			
			celdaHora = fila.createCell((short)9);
			celdaHora.setCellValue("Producto:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(request.getParameter("producCreditoID"));
			celdaHora = fila.createCell((short)11);
			celdaHora.setCellValue(request.getParameter("nombreProducto"));
			
			fila = hoja.createRow(5);
			//celda titulo 			
			celdaHora = fila.createCell((short)1);
			celdaHora.setCellValue("No. Cliente:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)2);
			celdaHora.setCellValue(request.getParameter("clienteID"));
			celdaHora = fila.createCell((short)3);
			celdaHora.setCellValue(request.getParameter("nombreCliente"));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            5, //primera fila (0-based)
		            5, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
		    

			celdaHora = fila.createCell((short)7);
			celdaHora.setCellValue("Estatus:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)8);
			celdaHora.setCellValue(request.getParameter("estatus"));
			
			celdaHora = fila.createCell((short)9);
			celdaHora.setCellValue("Saldo:");
			celdaHora.setCellStyle(estiloNeg8);	
			// valor
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(Double.parseDouble(creditosBean.getAdeudoTotal()));
			celdaHora.setCellStyle(estiloFormatoDecimal);
			
			// Creacion de fila
			fila = hoja.createRow(6);
			//Inicio en la celda 1 con los encabezados
			celda = fila.createCell((short)1);
			        
			celda.setCellValue("Fecha.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Interés Normal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("IVA Interés Normal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Interés Moratorio");
			celda.setCellStyle(estiloNeg8);
			 	  	 		
			celda = fila.createCell((short)8);
			celda.setCellValue("IVA Interés Moratorio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Comisión Falta Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("IVA Comisiones");
			celda.setCellStyle(estiloNeg8);
			if(cobraSeguroCuota){
				celda = fila.createCell((short)11);
				celda.setCellValue("Seguro Cuota");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)12);
				celda.setCellValue("IVA Seguro");
				celda.setCellStyle(estiloNeg8);
			}
			
		
			int i=7,iter=0;
			int tamanioLista = listaCreditosSum.size();
			ReporteMovimientosCreditosBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){

					credito = (ReporteMovimientosCreditosBean) listaCreditosSum.get(iter);
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(credito.getFecha());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(credito.getDescripcions());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(credito.getMonto());
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)4);
					celda.setCellValue(credito.getCapital());
					celda.setCellStyle(estiloFormatoDecimal);					
					   
					celda=fila.createCell((short)5);
					celda.setCellValue(credito.getInteresNormal());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(credito.getIvainteresNormal());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(credito.getInteresMoratorio());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(credito.getIvainteresMoratorio());
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)9);
					celda.setCellValue(credito.getComisionFaltapago());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(credito.getIvaComisiones());
					celda.setCellStyle(estiloFormatoDecimal);
					
					if(cobraSeguroCuota){
						celda=fila.createCell((short)11);
						celda.setCellValue(credito.getMontoSeguroCuota());
						celda.setCellStyle(estiloFormatoDecimal);

						celda=fila.createCell((short)12);
						celda.setCellValue(credito.getMontoIVASeguroCuota());
						celda.setCellStyle(estiloFormatoDecimal);
					}
					
				i++;
			}
			 
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)10);
			celda.setCellValue("Procedure:");
			celda.setCellStyle(estiloNeg10);
			
			celda=fila.createCell((short)11);
			celda.setCellValue("CREDMOVIMISUMREP");
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			

			for(int celd=0; celd<=21; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteMovsCreditosSum.xls");
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
		return  listaCreditosSum;
		
		
	}


	public String getSuccessView() {
		return successView;
	}



	public void setSuccessView(String successView) {
		this.successView = successView;
	}



	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}


	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}	


	public String getNomReporMovCred() {
		return nomReporMovCred;
	}


	public void setNomReporMovCred(String nomReporMovCred) {
		this.nomReporMovCred = nomReporMovCred;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}


	

}
