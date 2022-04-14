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
import credito.bean.RepVencimiBean;
import credito.servicio.CreditosServicio;
   
public class RepVencimienPasivosControlador  extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
		}
	public RepVencimienPasivosControlador() {
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
				ByteArrayOutputStream htmlStringPDF = VencimientosPasivosRepPDF(creditosBean, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = proxVencimientosExcel(tipoLista,creditosBean,response);
			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream VencimientosPasivosRepPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaRepVencimientosPasivPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepVencimientosPasivos.pdf");
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
		public List  proxVencimientosExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;
		//List listaCreditos = null;
    	listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		 
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
			HSSFSheet hoja = libro.createSheet("Reporte Vencimientos pasivos");
			HSSFRow fila= hoja.createRow(0);
	
			fila = hoja.createRow(1);
			fila = hoja.createRow(2);
 			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE VENCIMIENTOS PASIVOS DEL DÍA "+creditosBean.getFechaInicio()+" AL DÍA "+creditosBean.getFechaVencimien());
		

		
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
			celda = fila.createCell((short)0);
			celda.setCellValue("Intit. Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Crédito ID");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Cliente ID");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Monto original");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)5);
			celda.setCellValue("Fecha Desembolso");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Fecha Vto. Final");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Saldo Total");
			celda.setCellStyle(estiloNeg8);
			

			
			celda = fila.createCell((short)8);
			celda.setCellValue("Detalle de Vencimientos");
			celda.setCellStyle(estiloCentrado);		
			

		    hoja.addMergedRegion(new CellRangeAddress(
		    		 4, 4, 8, 15  
		    ));
		    
		    celda = fila.createCell((short)16);
			celda.setCellValue("Pago");
			celda.setCellStyle(estiloCentrado);		
			

		    hoja.addMergedRegion(new CellRangeAddress(
		    		 4, 4, 16, 17 
		    ));
			
		   //	  Comisiones	Otros cargos	

			fila = hoja.createRow(5);//NUEVA FILA
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Fecha Vto.");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Interés");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Cargos");
			celda.setCellStyle(estiloNeg8);	
						

			celda = fila.createCell((short)14);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloNeg8);	
						
			celda = fila.createCell((short)15);
			celda.setCellValue("Total cuota");
			celda.setCellStyle(estiloNeg8);	
		
			celda = fila.createCell((short)16);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Días Atr.");
			celda.setCellStyle(estiloNeg8);	
		    
			
			int i=7,iter=0;
			int tamanioLista = listaCreditos.size();
			RepVencimiBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				credito = (RepVencimiBean) listaCreditos.get(iter);
				fila=hoja.createRow(i);
				// CreditoID,ClienteID,NombreCompleto,MontoCredito,FechaInicio,
				celda=fila.createCell((short)0);
				celda.setCellValue(credito.getCreditoID());
				
				celda=fila.createCell((short)1);
				celda.setCellValue(credito.getCreditoID());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(credito.getClienteID());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(credito.getNombreCompleto());
				
				celda=fila.createCell((short)4);
				celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(credito.getFechaInicio());
			    celda.setCellStyle(estiloDatosCentrado);
			    
				celda=fila.createCell((short)6);
				celda.setCellValue(credito.getFechaVencimien());
			    celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Double.parseDouble(credito.getSaldoTotal()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(credito.getFechaVencim());
			    celda.setCellStyle(estiloDatosCentrado);
				
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Double.parseDouble(credito.getCapital()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(Double.parseDouble(credito.getInteres()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(Double.parseDouble(credito.getMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				// Comisiones,Cargos,AmortizacionID,IVATotal,CobraIVAMora,
				celda=fila.createCell((short)12);
				celda.setCellValue(Double.parseDouble(credito.getComisiones()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)13);
				celda.setCellValue(Double.parseDouble(credito.getCargos()));
				celda.setCellStyle(estiloFormatoDecimal);
			 
				
				celda=fila.createCell((short)14);
				celda.setCellValue(Double.parseDouble(credito.getIVATotal()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)15);
				celda.setCellValue(Double.parseDouble(credito.getTotalCuota()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)16);
				celda.setCellValue(Double.parseDouble(credito.getPago()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)17);
				celda.setCellValue(credito.getFechaPago());
				 

				celda=fila.createCell((short)18);
				celda.setCellValue(credito.getDiasAtraso());	
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
			response.addHeader("Content-Disposition","inline; filename=ReporteVencimiePasiv.xls");
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
