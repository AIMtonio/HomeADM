package contabilidad.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Calendar;

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

import contabilidad.bean.CuentasContablesBean;
import contabilidad.reporte.PDFMaestroCuentasRepControlador.Enum_Con_TipRepor;
import contabilidad.servicio.CuentasContablesServicio;

public class RepSATExcelControlador extends AbstractCommandController {

	CuentasContablesServicio cuentasContablesServicio = null;
	String successView = null;	
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel	= 1 ;
		  
	}

 	public RepSATExcelControlador(){
 		setCommandClass(CuentasContablesBean.class);
 		setCommandName("cuentasContablesBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		CuentasContablesBean cuentasContables = (CuentasContablesBean) command;
 		
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
 				Integer.parseInt(request.getParameter("tipoReporte")):0;
		String htmlString= "";
		
		switch(tipoReporte){
		case Enum_Con_TipRepor.ReporExcel:
			List<CuentasContablesBean>listaReportes=reportePeriodoExcel(cuentasContables, response);
			
		break;
		}
		
	return null;
		
 				
  	}
 
	// Reporte de Maestr Contable contable en Excel
		public List <CuentasContablesBean>reportePeriodoExcel(CuentasContablesBean cuentasContables,HttpServletResponse response){
			List <CuentasContablesBean> listaPeriodos= null;
			listaPeriodos=cuentasContablesServicio.listaReportePeriodosExcel(cuentasContables,response);
								
			if(listaPeriodos!=null){
				try {
					XSSFWorkbook libro = new XSSFWorkbook();
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					XSSFFont fuenteNegrita8= libro.createFont();
					fuenteNegrita8.setFontHeightInPoints((short)8);
					fuenteNegrita8.setFontName("Negrita");
					fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					XSSFCellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					// Negrita 10 centrado
					XSSFFont centradoNegrita10 = libro.createFont();
					centradoNegrita10.setFontHeightInPoints((short)10);
					centradoNegrita10.setFontName("Negrita");
					centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
					estiloNegCentrado10.setFont(centradoNegrita10);
					estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
					
					// Negrita 8 centrado
					XSSFFont centradoNegrita8= libro.createFont();
					centradoNegrita8.setFontHeightInPoints((short)8);
					centradoNegrita8.setFontName("Negrita");
					centradoNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					XSSFCellStyle estiloNegCentrado8 = libro.createCellStyle();
					estiloNegCentrado8.setFont(centradoNegrita8);
					estiloNegCentrado8.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
								
					//Estilo Formato decimal (0.00)
					XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
					XSSFDataFormat format = libro.createDataFormat();
					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
					
					// Creacion de hoja
					XSSFSheet hoja = libro.createSheet("ReporteTimbradoPeriodo");
					XSSFRow fila= hoja.createRow(0);

					// Nombre Usuario
					XSSFCell celdaini = fila.createCell((short)1);
					celdaini = fila.createCell((short)8);
					celdaini.setCellValue("Usuario:");
					celdaini.setCellStyle(estiloNeg8);	
					celdaini = fila.createCell((short)9);
					celdaini.setCellValue(cuentasContables.getUsuario());
					
					// Descripcion del Reporte
					fila = hoja.createRow(1);	
					// Fecha en que se genera el reporte
					XSSFCell celdafin = fila.createCell((short)8);
					celdafin.setCellValue("Fecha:");
					celdafin.setCellStyle(estiloNeg8);	
					celdafin = fila.createCell((short)9);
					celdafin.setCellValue(cuentasContables.getFechaEmision());
		   
					// Nombre Institucion
					XSSFCell celdaInst=fila.createCell((short)1);
					celdaInst=fila.createCell((short)3);
					celdaInst.setCellStyle(estiloNegCentrado10);
					celdaInst.setCellValue(cuentasContables.getNombreInstitucion());
					hoja.addMergedRegion(new CellRangeAddress(
				            1, //first row (0-based)
				            1, //last row  (0-based)
				            3, //first column (0-based)
				            7  //last column  (0-based)
				    )); 
					
					// Hora en que se genera el reporte
					fila = hoja.createRow(2);	
					XSSFCell celda = fila.createCell((short)8);
					celda.setCellValue("Hora:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)9);
					
					String horaVar="";
					
					Calendar calendario = Calendar.getInstance();	 
					int hora =calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);
					
					String h = "";
					String m = "";
					String s = "";
					if(hora<10)h="0"+Integer.toString(hora); else h=Integer.toString(hora);
					if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
					if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
						 
					horaVar= h+":"+m+":"+s;
					
					celda.setCellValue(horaVar);
					
					XSSFCell celdaR=fila.createCell((short)2);
					celdaR	= fila.createCell((short)3);			
					celdaR.setCellStyle(estiloNegCentrado10);
					celdaR.setCellValue("REPORTE DE TIMBRADOS DEL PERIODO " + cuentasContables.getPeriodo() );
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //first row (0-based)
				            2, //last row  (0-based)
				            3, //first column (0-based)
				            7  //last column  (0-based)
				    ));
					
					// Encabezado del Reporte
					fila = hoja.createRow(3);	
					fila = hoja.createRow(4);	
					
		

					//Inicio en la segunda fila y que el fila uno tiene los encabezados
					celda = fila.createCell((short)1);
					celda.setCellValue("Periodo");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)2);
					celda.setCellValue("Número de Cliente");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)4);
					celda.setCellValue("UUID");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)5);
					celda.setCellValue("RFC Emisor");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)6);
					celda.setCellValue("RFC Receptor");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Total Timbrado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Producto");
					celda.setCellStyle(estiloNeg8);

					
					int row = 5,iter=0;
					int tamanioLista = listaPeriodos.size();
					CuentasContablesBean disposicion = null;
					for(iter=0; iter<tamanioLista; iter ++){
					disposicion = (CuentasContablesBean) listaPeriodos.get(iter);

						fila=hoja.createRow(row);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(disposicion.getPeriodo());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(disposicion.getClienteID());
						
						celda=fila.createCell((short)3);
						celda.setCellValue(disposicion.getNombreCliente());
						
						celda=fila.createCell((short)4);
						celda.setCellValue((disposicion.getUUID()).replaceAll("(\n|\r)", ""));

						celda=fila.createCell((short)5);
						celda.setCellValue(disposicion.getRFCEmisor());
						
						celda=fila.createCell((short)6);
						celda.setCellValue(disposicion.getRFCReceptor());
						
						celda=fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteDoble(disposicion.getTotalTimbrado()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(disposicion.getProducto());
						
						row++;
					}
					
					hoja.autoSizeColumn((short)0);
					hoja.autoSizeColumn((short)1);
					hoja.autoSizeColumn((short)2);
					hoja.autoSizeColumn((short)3);
					hoja.autoSizeColumn((short)4);
					hoja.autoSizeColumn((short)5);
					hoja.autoSizeColumn((short)6);
					hoja.autoSizeColumn((short)7);
					hoja.autoSizeColumn((short)8);
				
					row = row+2;
					fila=hoja.createRow(row);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);

					row = row+1;
					fila=hoja.createRow(row);
					celda=fila.createCell((short)0);
					celda.setCellValue(tamanioLista);
					
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=ReporteTimbradosPeriodo.xls");
					response.setContentType("application/vnd.ms-excel");

					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
					
				}catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				
				
			}
			
			return listaPeriodos;
			
		}

	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}


	public String getSuccessView() {
		return successView;
	}	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
