 
package credito.reporte;

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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepAntSaldosBean;
import credito.bean.RepVencimiBean;
import credito.servicio.CreditosServicio;
   
public class ReporteAntigSaldosControlador  extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		}
	public ReporteAntigSaldosControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
 
	
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
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = antigSaldosRepPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = antigSaldosExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream antigSaldosRepPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaRepAntigSaldosPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepAntiguedadSaldos.pdf");
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
		public List  antigSaldosExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;
		//List listaCreditos = null;
    	listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		 
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
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Antiguedad de Saldos");
			HSSFRow fila= hoja.createRow(0);
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
 
			celdaUsu = fila.createCell((short)11);
			celdaUsu.setCellValue("Días de Atraso Inicial:");
			celdaUsu.setCellStyle(estiloNeg8);	
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            11, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
			celdaUsu = fila.createCell((short)13);
			celdaUsu.setCellValue((!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
			
			
			celdaUsu = fila.createCell((short)15);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)16);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");

			
			String horaVar="";
			String fechaVar= creditosBean.getParFechaEmision();

			
			int itera=0;
			RepAntSaldosBean creditoHora = null;
			if(!listaCreditos.isEmpty()){
			for( itera=0; itera<1; itera ++){

				creditoHora = (RepAntSaldosBean) listaCreditos.get(itera);
				horaVar= creditoHora.getHora();
				fechaVar= creditoHora.getFecha();
				
			}
			}

			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			
			
			celdaFec = fila.createCell((short)11);
			celdaFec.setCellValue("Días de Atraso Final:");
			celdaFec.setCellStyle(estiloNeg8);	
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            11, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
			celdaFec = fila.createCell((short)13);
			celdaFec.setCellValue((!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");
			
			
			
			celdaFec = fila.createCell((short)15);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)16);
			celdaFec.setCellValue(fechaVar);
			//
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)15);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)16);
			celdaHora.setCellValue(horaVar);
    // fin susuario,fecha y hora
 			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE ANTIGÜEDAD DE SALDOS AL "+creditosBean.getFechaInicio()+" :CAPITAL " );
		

		
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		    
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
		//						

			celda = fila.createCell((short)1);
			celda.setCellValue("No. de Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("ID Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("ID Prod.");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)5);
			celda.setCellValue("Monto Original");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Fecha Desemb.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Fecha Vto. Final");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Saldo Total Capital");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Capital Vigente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Capital Vencido");
			celda.setCellStyle(estiloNeg8);
			
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Capital Vencido (Rango de Días)");
			celda.setCellStyle(estiloCentrado);		
			

		    hoja.addMergedRegion(new CellRangeAddress(
		    		 4, 4, 11, 19  
		    ));
		    
		    celda = fila.createCell((short)20);
			celda.setCellValue("Días de Atraso Máximo");
			celda.setCellStyle(estiloCentrado);		
			
 
		   //	  Comisiones	Otros cargos	

			fila = hoja.createRow(5);//NUEVA FILA
			
			celda = fila.createCell((short)11);
			celda.setCellValue("1-29");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)12);
			celda.setCellValue("30-59");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)13);
			celda.setCellValue("60-89");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)14);
			celda.setCellValue("90-119");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)15);
			celda.setCellValue("120-149");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)16);
			celda.setCellValue("150-179");
			celda.setCellStyle(estiloNeg8);	
						

			celda = fila.createCell((short)17);
			celda.setCellValue("180-269");
			celda.setCellStyle(estiloNeg8);	
						
			celda = fila.createCell((short)18);
			celda.setCellValue("270-364");
			celda.setCellStyle(estiloNeg8);	
		
			celda = fila.createCell((short)19);
			celda.setCellValue("365 - +");
			celda.setCellStyle(estiloNeg8);
			
		
		    
			
			int i=7,iter=0,tamanioLista=0;
			if (listaCreditos!=null)
			 tamanioLista = listaCreditos.size();
 
			RepAntSaldosBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				credito = (RepAntSaldosBean) listaCreditos.get(iter);
				fila=hoja.createRow(i);
				// CreditoID,ClienteID,NombreCompleto,MontoCredito,FechaInicio,
				celda=fila.createCell((short)1);
				celda.setCellValue(credito.getCreditoID());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(credito.getClienteID());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(credito.getNomCliente());

				celda=fila.createCell((short)4);
				celda.setCellValue(credito.getProdCredID());
				
				celda=fila.createCell((short)5);
				celda.setCellValue(Double.parseDouble(credito.getMontoOriginal()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)6);
				celda.setCellValue(credito.getFechaIni());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(credito.getFechaVencim());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(Double.parseDouble(credito.getTotCap()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Double.parseDouble(credito.getCapVig()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				celda=fila.createCell((short)10);
				celda.setCellValue(Double.parseDouble(credito.getCapVen()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(Double.parseDouble(credito.getBucket1()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)12);
				celda.setCellValue(Double.parseDouble(credito.getBucket2()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				// Comisiones,Cargos,AmortizacionID,IVATotal,CobraIVAMora,
				celda=fila.createCell((short)13);
				celda.setCellValue(Double.parseDouble(credito.getBucket3()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				celda=fila.createCell((short)14);
				celda.setCellValue(Double.parseDouble(credito.getBucket4()));
				celda.setCellStyle(estiloFormatoDecimal);
				
			 
				
				celda=fila.createCell((short)15);
				celda.setCellValue(Double.parseDouble(credito.getBucket5()));
				celda.setCellStyle(estiloFormatoDecimal);
				

				celda=fila.createCell((short)16);
				celda.setCellValue(Double.parseDouble(credito.getBucket6()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				celda=fila.createCell((short)17);
				celda.setCellValue(Double.parseDouble(credito.getBucket7()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)18);
				celda.setCellValue(Double.parseDouble(credito.getBucket8()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)19);
				celda.setCellValue(Double.parseDouble(credito.getBucket9()));
				celda.setCellStyle(estiloFormatoDecimal);
 			 

				celda=fila.createCell((short)20);
				celda.setCellValue(credito.getMaxDiaAtr());		
				celda.setCellStyle(estiloDatosCentrado);
					
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
			

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteAntSaldos.xls");
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
