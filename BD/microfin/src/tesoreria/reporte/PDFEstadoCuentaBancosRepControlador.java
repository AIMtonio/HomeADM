package tesoreria.reporte;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
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

import tesoreria.bean.EstadoCuentaBancosReporteBean;
import tesoreria.servicio.EstadoCuentaBancosReporteServicio;

public class PDFEstadoCuentaBancosRepControlador extends AbstractCommandController{

	EstadoCuentaBancosReporteServicio estadoCuentaBancosReporteServicio  = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public static interface Enum_Con_TipoReporte {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		}

 	public PDFEstadoCuentaBancosRepControlador(){
 		setCommandClass(EstadoCuentaBancosReporteBean.class);
		setCommandName("estadoCuentaBancosReporteBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		EstadoCuentaBancosReporteBean estadoCuentaBancosReporteBean = (EstadoCuentaBancosReporteBean) command;
 		
 		String htmlString= "";
 			
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
 				Integer.parseInt(request.getParameter("tipoReporte")):
 			0;
 		int tipoLista =(request.getParameter("tipoLista")!=null)?
 				Integer.parseInt(request.getParameter("tipoLista")):
 			0;
		switch(tipoReporte){
			
			case Enum_Con_TipoReporte.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteEstadoCuentaBancosPDF(estadoCuentaBancosReporteBean, nombreReporte, response,request);
			break;
				
			case Enum_Con_TipoReporte.ReporExcel:		
				 List listaReportes = reporteEstadoCuentaBancosExcel(tipoLista,estadoCuentaBancosReporteBean, response, request);
			break;
		}	

 		return null;
 	}
 	
 // Reporte de Estado de Cuenta de Bancos en pdf
 	public ByteArrayOutputStream reporteEstadoCuentaBancosPDF(EstadoCuentaBancosReporteBean estadoCuentaBancosReporteBean, String nomReporte,HttpServletResponse response, HttpServletRequest request){
 		ByteArrayOutputStream htmlStringPDF = null;
 		try {
 			htmlStringPDF = estadoCuentaBancosReporteServicio.reporteEstadoCuentaBancosPDF(estadoCuentaBancosReporteBean, request, nomReporte );
 			response.addHeader("Content-Disposition","inline; filename=estadoCuentaBancos.pdf");
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

	// Reporte de Estado de Cuenta de Bancos en excel
	public List  reporteEstadoCuentaBancosExcel(int tipoLista,EstadoCuentaBancosReporteBean estadoCuentaBancosReporteBean, HttpServletResponse response, HttpServletRequest request){
		List listaEstadoCuentaBancos=null;
		
		listaEstadoCuentaBancos =  estadoCuentaBancosReporteServicio.lista(estadoCuentaBancosReporteBean);	
	 
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
		HSSFSheet hoja = libro.createSheet("Reporte de Cuentas de Bancos");
		HSSFRow fila= hoja.createRow(0);
		
		// Creacion de los merge de las celdas
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					0, //primera fila (0-based)
					0, //ultima fila  (0-based)
					1, //primer celda (0-based)
			        3  //ultima celda   (0-based)
		    ));
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            3  //ultima celda   (0-based)
		    ));
	
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            1  //ultima celda   (0-based)
		    ));
		   
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            5, //primera fila (0-based)
	            5, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            2  //ultima celda   (0-based)
	    ));
	    
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            5, //primera fila (0-based)
	            5, //ultima fila  (0-based)
	            3, //primer celda (0-based)
	            4  //ultima celda   (0-based)
	    ));
	    

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
		    
		

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            3  //ultima celda   (0-based)
		    ));
		    
		

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            4, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
		    

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            5, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
		    

		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            6, //primer celda (0-based)
		            6  //ultima celda   (0-based)
		    ));
		    
		
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellStyle(estiloNeg10);
		celda.setCellStyle(estiloCentrado);
		celda.setCellValue(request.getParameter("nombreInstitucionSistema"));
		
		celda=fila.createCell((short)5);
		celda.setCellStyle(estiloNeg8);
		celda.setCellValue("Usuario:");

		celda=fila.createCell((short)6);
		//celda1.setCellStyle(estiloNeg8);
		celda.setCellValue(request.getParameter("claveUsuario"));
		
		    
		fila = hoja.createRow(1);
		
		celda=fila.createCell((short)5);
		celda.setCellStyle(estiloNeg8);
		celda.setCellValue("Fecha:");

		celda=fila.createCell((short)6);
		//celda1.setCellStyle(estiloNeg8);
		celda.setCellValue(request.getParameter("fechaSistema"));
		
		fila = hoja.createRow(2);
		
		Calendar calendario = Calendar.getInstance();
		
		String horaVar="";
				String fechaVar=request.getParameter("fechaSistema");
				int hora =calendario.get(Calendar.HOUR_OF_DAY);
				int minutos = calendario.get(Calendar.MINUTE);
				int segundos = calendario.get(Calendar.SECOND);
				
				String h = Integer.toString(hora);
				String m = "";
				String s = "";
				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
				if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
				
					 
				horaVar= h+":"+m+":"+s;
		
		celda=fila.createCell((short)5);
		celda.setCellStyle(estiloNeg8);
		celda.setCellValue("Hora:");

		celda=fila.createCell((short)6);
		//celda1.setCellStyle(estiloNeg8);
		celda.setCellValue(horaVar);
		
		
		fila = hoja.createRow(3);
		
		celda=fila.createCell((short)1);
		celda.setCellStyle(estiloNeg10);
		celda.setCellStyle(estiloCentrado);
		celda.setCellValue("Reporte de Cuentas de Bancos");
		
		fila = hoja.createRow(4);

		fila = hoja.createRow(5);
	   
		celda=fila.createCell((short)1);
		//celda3.setCellStyle(estiloNeg10);
		celda.setCellValue("Banco: "+request.getParameter("nombreInstitucion"));
		celda.setCellStyle(estiloNeg8);
		
	    celda=fila.createCell((short)3);
		//	celda4.setCellStyle(estiloNeg10);
		celda.setCellValue("No. Cuenta: "+request.getParameter("numCtaInstit"));
		celda.setCellStyle(estiloNeg8);
		
		// Creacion de fila
		fila = hoja.createRow(6);
		
		celda=fila.createCell((short)1);
		celda.setCellValue("Fecha");
		celda.setCellStyle(estiloNeg10);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Descripción");
		celda.setCellStyle(estiloNeg10);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Referencia");
		celda.setCellStyle(estiloNeg10);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Cargos");
		celda.setCellStyle(estiloNeg10);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Abonos");
		celda.setCellStyle(estiloNeg10);	

		celda = fila.createCell((short)6);
		celda.setCellValue("Saldo");
		celda.setCellStyle(estiloNeg10);
		
		int i=8,iter=0;
		int tamanioLista = listaEstadoCuentaBancos.size();
		EstadoCuentaBancosReporteBean estadoCuentaBancos = null;
		for( iter=0; iter<tamanioLista; iter ++){
			
			estadoCuentaBancos = (EstadoCuentaBancosReporteBean) listaEstadoCuentaBancos.get(iter);
			fila=hoja.createRow(i);
			// Fecha,Descripcion,Referencia,Cargos,Abonos,Saldo
			celda=fila.createCell((short)1);
			celda.setCellValue(estadoCuentaBancos.getFechaMov());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(estadoCuentaBancos.getDescripcionMov());
			
			celda=fila.createCell((short)3);
			celda.setCellValue(estadoCuentaBancos.getReferenciaMov());
			
			celda=fila.createCell((short)4);
			celda.setCellValue(Double.parseDouble(estadoCuentaBancos.getCargos().trim().replaceAll(",","")));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)5);
			celda.setCellValue(Double.parseDouble(estadoCuentaBancos.getAbonos().trim().replaceAll(",","")));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(estadoCuentaBancos.getSaldoAcumulado());
			celda.setCellValue(Double.parseDouble(estadoCuentaBancos.getSaldoAcumulado().trim().replaceAll(",","")));
			celda.setCellStyle(estiloFormatoDecimal);
		    		
			i++;
		}
	

		for(int celd=0; celd<=18; celd++)
		hoja.autoSizeColumn((short)celd);
	
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=EstadoCuentaBancos.xls");
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
		
		
	return  listaEstadoCuentaBancos;
	
	
	}


 	
	public EstadoCuentaBancosReporteServicio getEstadoCuentaBancosReporteServicio() {
		return estadoCuentaBancosReporteServicio;
	}

	public void setEstadoCuentaBancosReporteServicio(
			EstadoCuentaBancosReporteServicio estadoCuentaBancosReporteServicio) {
		this.estadoCuentaBancosReporteServicio = estadoCuentaBancosReporteServicio;
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
