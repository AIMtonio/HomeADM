package ventanilla.reporte;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

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



import ventanilla.bean.CajasMovsBean;
import ventanilla.servicio.CajasMovsServicio;

public class ReporteCajaPrincipalControlador  extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	CajasMovsServicio cajasMovsServicio = null;
	String nombreReporte = null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
public static interface Enum_Con_TipRepor {
		  
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		  
		}
public ReporteCajaPrincipalControlador(){
	setCommandClass(CajasMovsBean.class);
	setCommandName("cajasMovsBean");	
	
}

protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception {
	
	CajasMovsBean cajasMovs = (CajasMovsBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
		
	String htmlString= "";
		
	switch(tipoReporte){		
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteCajaPrincipalPDF(cajasMovs, nombreReporte, response);
		break;
			
		case Enum_Con_TipRepor.ReporExcel:	
			int tipoLista = 2;
			 List listaReportes = reporteCajaPrincipalExcel(tipoLista, cajasMovs, response);
		break;
	
	}
	
	return null;
	
		
}







//Reporte de vencimientos en pdf
	public ByteArrayOutputStream reporteCajaPrincipalPDF(CajasMovsBean cajasMovsBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			System.out.println("Entro en el controlador Correcto");
			htmlStringPDF = cajasMovsServicio.reporteCajaPrincipalPDF(cajasMovsBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteCajaPrincipal.pdf");
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




	public List  reporteCajaPrincipalExcel(int tipoLista,CajasMovsBean cajasMovsBean,  HttpServletResponse response){
		List listaCajaPricipal=null;
		listaCajaPricipal = cajasMovsServicio.listaReporteCajaPrincipal(tipoLista,cajasMovsBean,response); 	
	 
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
		HSSFSheet hoja = libro.createSheet("CAJA PRINCIPAL");
		HSSFRow fila= hoja.createRow(0);
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)11);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)12);
		celdaUsu.setCellValue((!cajasMovsBean.getClaveUsuario().isEmpty())?cajasMovsBean.getClaveUsuario(): "TODOS");
		
		String horaVar="";
		String fechaVar=cajasMovsBean.getFechaEmision();

		
		int itera=0;
		CajasMovsBean cajasMovs = null;
		if(!listaCajaPricipal.isEmpty()){
			for( itera=0; itera<1; itera ++){
				cajasMovs = (CajasMovsBean) listaCajaPricipal.get(itera);
				horaVar= cajasMovs.getHoraHemision();								
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
		celdaInst.setCellValue(cajasMovsBean.getNombreInstitucion());
							
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
		celda.setCellValue("REPORTE DE MOVIMIENTOS DE CAJA PRINCIPAL DEL "+cajasMovsBean.getFechaInicio()+" AL "+cajasMovsBean.getFechaFin());
		celda.setCellStyle(estiloCentrado);
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            10  //ultima celda   (0-based)
	    ));
	    
		
	   
	   
	   fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
		celda = fila.createCell((short)1);
		celda.setCellValue("Caja:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((!cajasMovsBean.getCajaID().equals("0")? cajasMovsBean.getNombreCaja():"TODAS"));
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Moneda:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)5);
		celda.setCellValue((!cajasMovsBean.getMonedaID().equals("0")? cajasMovsBean.getNombreMoneda():"TODAS"));
		
		// Creacion de fila
		fila = hoja.createRow(6); // Fila vacia
		fila = hoja.createRow(7);// Campos
								

		celda = fila.createCell((short)1);
		celda.setCellValue("CajaID");
		celda.setCellStyle(estiloNeg8);		

		celda = fila.createCell((short)2);
		celda.setCellValue("Nombre Caja");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Fecha");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Transacción");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Tipo");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)6);
		celda.setCellValue("Descripción");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Referencia");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Referencia2");
		celda.setCellStyle(estiloNeg8);
		
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Entradas");
		celda.setCellStyle(estiloNeg8);
		

		celda = fila.createCell((short)10);
		celda.setCellValue("Salidas");
		celda.setCellStyle(estiloNeg8);
		
		
	    hoja.addMergedRegion(new CellRangeAddress(
	    		 7, 7, 10, 14  
	    ));

			

		// Recorremos la lista para la parte de los datos 	
		int i=10,iter=0;
		int tamanioLista = listaCajaPricipal.size();
		CajasMovsBean cajas = null;
		for( iter=0; iter<tamanioLista; iter ++){
		
			cajas = (CajasMovsBean) listaCajaPricipal.get(iter);
			fila=hoja.createRow(i);

			
			celda=fila.createCell((short)1);
			celda.setCellValue(cajas.getCajaID());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(cajas.getNombreCaja());
			
			celda=fila.createCell((short)3); 
			celda.setCellValue(cajas.getFecha());
			
			celda=fila.createCell((short)4);
			celda.setCellValue(cajas.getTransaccion()); 			

			celda=fila.createCell((short)5);
			celda.setCellValue(cajas.getTipo());
			
			celda=fila.createCell((short)6);
			celda.setCellValue(cajas.getDescripcion());
			
			celda=fila.createCell((short)7);
			celda.setCellValue(cajas.getReferencia());
				
			celda=fila.createCell((short)8);
			celda.setCellValue(cajas.getReferencia2());
						
			celda=fila.createCell((short)9);
			celda.setCellValue(Double.parseDouble(cajas.getEntradas()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)10);
			celda.setCellValue(Double.parseDouble(cajas.getSalidas()));
			celda.setCellStyle(estiloFormatoDecimal);
					
			
		 
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
		response.addHeader("Content-Disposition","inline; filename=RepMovCajaPrincipal.xls");
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
		
		
	return  listaCajaPricipal;
	
	
	}
	
	
	//---------------Getter y setter --------------------
	public CajasMovsServicio getCajasMovsServicio() {
		return cajasMovsServicio;
	}

	public void setCajasMovsServicio(CajasMovsServicio cajasMovsServicio) {
		this.cajasMovsServicio = cajasMovsServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
}
