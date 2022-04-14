package contabilidad.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ReqGastosSucBean;
import tesoreria.reporte.ReporteRequisicionControlador.Enum_Con_TipRepor;

import contabilidad.servicio.CuentasContablesServicio;

import contabilidad.bean.CuentasContablesBean;
import cuentas.servicio.CuentasAhoServicio;

public class PDFMaestroCuentasRepControlador extends AbstractCommandController{

	CuentasContablesServicio cuentasContablesServicio = null;
	String nombreReporte = null;	
	String successView = null;	
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF		= 2 ;
		  int  ReporExcel	= 3 ;
		  
	}

 	public PDFMaestroCuentasRepControlador(){
 		setCommandClass(CuentasContablesBean.class);
 		setCommandName("cuentasContablesBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		CuentasContablesBean cuentasContables = (CuentasContablesBean) command;
 		
 		int consultar =(request.getParameter("consultar")!=null)?
 				Integer.parseInt(request.getParameter("consultar")):0;
		String htmlString= "";
		
		switch(consultar){
		case Enum_Con_TipRepor.ReporPantalla:
			 htmlString = cuentasContablesServicio.reporteMaestroContable(cuentasContables, nombreReporte);
		break;
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteMContablePDF(cuentasContables, nombreReporte, response);
		break;
		case Enum_Con_TipRepor.ReporExcel:
			List<CuentasContablesBean>listaReportes=reporteMaestroExcel(cuentasContables, response);
			
		break;
		}
		if(consultar ==Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
 				
  	}
 
	public ByteArrayOutputStream reporteMContablePDF(CuentasContablesBean cuentasContables, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = cuentasContablesServicio.reporteMaestroContablePDF(cuentasContables, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=MaestroCuentas.pdf");
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
	// Reporte de Maestr Contable contable en Excel
		public List <CuentasContablesBean>reporteMaestroExcel(CuentasContablesBean cuentasContables,HttpServletResponse response){
			List <CuentasContablesBean> listaMaestros= null;
			listaMaestros=cuentasContablesServicio.listaReporteMaetroContableExcel(cuentasContables,response);
								
			if(listaMaestros!=null){
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
					
					// Creacion de hoja
					HSSFSheet hoja = libro.createSheet("Reporte Maestro Contable");
					HSSFRow fila= hoja.createRow(0);
					HSSFCell celda=fila.createCell((short)1);

					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(cuentasContables.getNombreInstitucion());

					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Usuario: "+cuentasContables.getUsuario());

					fila = hoja.createRow(1);
					fila = hoja.createRow(2);
					
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Reporte del Catálogo Maestro de Cuentas Contables");
					
					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha: "+cuentasContables.getFechaEmision());

					fila = hoja.createRow(3);
					fila = hoja.createRow(4);
					
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Concepto: "+cuentasContables.getConceptoCta());
					
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Moneda: "+cuentasContables.getDescripcionMoneda());
					
					// Creacion de fila
					fila = hoja.createRow(5);
					fila = hoja.createRow(6);

					//Inicio en la segunda fila y que el fila uno tiene los encabezados
					celda = fila.createCell((short)0);
					celda.setCellValue("Cuenta");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)1);
					celda.setCellValue("Descripción");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)2);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)3);
					celda.setCellValue("Moneda");
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)4);
					celda.setCellValue("Restricción");
					celda.setCellStyle(estiloNeg8);
					
					int i=7;
					
					for(CuentasContablesBean maestro : listaMaestros){
						fila=hoja.createRow(i);
						String tipoCta = maestro.getTipoCuenta();
						if(tipoCta.equals("0")){
							tipoCta="TODAS";
						}
						if(tipoCta.equals("1")){
							tipoCta="ACTIVO";
						}
						if(tipoCta.equals("2")){
							tipoCta="PASIVO";
						}
						if(tipoCta.equals("3")){
							tipoCta="COMPLEMENTARIA DE ACTIVO";
						}
						if(tipoCta.equals("4")){
							tipoCta="CAPITAL Y RESERVAS";
						}
						if(tipoCta.equals("5")){
							tipoCta="RESULTADOS INGRESOS";
						}
						if(tipoCta.equals("6")){
							tipoCta="RESULTADOS EGRESOS";
						}
						if(tipoCta.equals("7")){
							tipoCta="ORDEN DEUDORA";
						}
						if(tipoCta.equals("8")){
							tipoCta="ORDEN ACREEDORA";
						}
						
						celda=fila.createCell((short)0);
						celda.setCellValue(maestro.getCuentaCompleta());
						
						celda=fila.createCell((short)1);
						celda.setCellValue(maestro.getDescripcion());
						
						celda=fila.createCell((short)2);
						celda.setCellValue(tipoCta);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(maestro.getDescriCorta());

						celda=fila.createCell((short)4);
						celda.setCellValue(maestro.getRestringida());
						
						i++;
					}
					
					hoja.autoSizeColumn((short)0);
					hoja.autoSizeColumn((short)1);
					hoja.autoSizeColumn((short)2);
					hoja.autoSizeColumn((short)3);
					hoja.autoSizeColumn((short)4);
					
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=ReporteMaestroContable.xls");
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
			
			return listaMaestros;
			
		}

	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public String getSuccessView() {
		return successView;
	}	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
