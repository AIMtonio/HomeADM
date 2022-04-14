package ventanilla.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

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

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class OpVentanillaRepControlador extends AbstractCommandController{
	ParametrosSesionBean parametrosSesionBean=null;
	CajasVentanillaServicio cajasVentanillaServicio = null;
	String nombreReporteVen = null;
	String nombreReporteComer = null;
	String successView = null;
	
	
public static interface Enum_Con_TipRepor {		  
		  int  ReporPDFContable= 2 ;
		  int  ReporExcelContable= 3 ;
		  int  ReporPDFComercial=4;
		  int  ReporExcelComercial=5;		  
		}
public OpVentanillaRepControlador(){
	setCommandClass(CajasVentanillaBean.class);
	setCommandName("CajasVentanillaBean");	
	
}

protected ModelAndView handle(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors)throws Exception {
	
	CajasVentanillaBean cajasBean = (CajasVentanillaBean) command;

int tipoReporte =(request.getParameter("tipoReporte")!=null)?
		Integer.parseInt(request.getParameter("tipoReporte")):
	0;
		
String htmlString= "";
int tipoLista=0;
	switch(tipoReporte){		
		case Enum_Con_TipRepor.ReporPDFContable:
			ByteArrayOutputStream htmlStringPDF = OpVentanillaRepPDF(cajasBean, nombreReporteVen, response);
		break;			
		case Enum_Con_TipRepor.ReporExcelContable:	
			tipoLista = 2;
			 List listaReportes = opVentanillaExcel(tipoLista, cajasBean, response);
		break;
		case Enum_Con_TipRepor.ReporPDFComercial:
			ByteArrayOutputStream htmlStringPDFComercial = opVentanillaPDFComercial(cajasBean, nombreReporteComer,response); 
			break;
		case Enum_Con_TipRepor.ReporExcelComercial:
			tipoLista = 3;
			List listaReportesComercial = opVentanillaExcelComer(tipoLista,cajasBean,response);
			break;
	}
	
	return null;
	
		
}
//Reporte de vencimientos en pdf
	public ByteArrayOutputStream OpVentanillaRepPDF(CajasVentanillaBean cajasBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cajasVentanillaServicio.creaRepOpVentanillaPDF(cajasBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepOpVentanilla.pdf");
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


	public List  opVentanillaExcel(int tipoLista, CajasVentanillaBean cajasBean,  HttpServletResponse response){
		List listaOperaciones=null;
		
    	listaOperaciones = cajasVentanillaServicio.listaOpVentanilla(tipoLista,cajasBean,response); 	
    	
    	int regExport = 0;
		
	
			try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			Locale currentLocale;
			ResourceBundle messages;
	        currentLocale = new Locale(parametrosSesionBean.getNomCortoInstitucion());
	        messages = ResourceBundle.getBundle("messages", currentLocale);
	        
	        String opcMenu = messages.getString("safilocale.cliente");
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
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Operaciones Ventanilla");
			HSSFRow fila= hoja.createRow(0);
	
			fila=hoja.createRow(1);
			HSSFCell celdaTitulo=fila.createCell((short)3);
			celdaTitulo.setCellStyle(estiloNeg10);
			celdaTitulo.setCellValue(cajasBean.getNombreInstitucion());
			celdaTitulo.setCellStyle(estiloCentrado);
			celdaTitulo.setCellStyle(estiloNeg8);	
			
			HSSFCell celdaUsur=fila.createCell((short)9);			
			celdaUsur.setCellValue("Usuario:");
			celdaUsur.setCellStyle(estiloNeg8);	
			celdaUsur = fila.createCell((short)10);
			celdaUsur.setCellValue(cajasBean.getUsuario());
			
			fila = hoja.createRow(2);
			
			HSSFCell celda=fila.createCell((short)3);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE OPERACIONES EN VENTANILLA DEL DÍA "+cajasBean.getFechaIni()+" AL DÍA "+cajasBean.getFechaFin());
			celda.setCellStyle(estiloCentrado);
			celda.setCellStyle(estiloNeg8);									
			
			HSSFCell celdaFecha=fila.createCell((short)9);			
			celdaFecha.setCellValue("Fecha:");
			celdaFecha.setCellStyle(estiloNeg8);	
			celdaFecha = fila.createCell((short)10);
			celdaFecha.setCellValue(cajasBean.getFecha());
			
			fila = hoja.createRow(3);
			Calendar calendario=new GregorianCalendar();
			int hora, minutos;
			hora =calendario.get(Calendar.HOUR_OF_DAY);
			minutos = calendario.get(Calendar.MINUTE);
			String minute;
			if(minutos<9){
				minute="0"+minutos;
			}else{
				minute=""+minutos;
			}
			cajasBean.setHoraEmision(hora+":"+minute);
			
			String horaVar=cajasBean.getHoraEmision();
			
			/*int itera=0;
			CajasVentanillaBean creditoHora = null;
			if(!listaOperaciones.isEmpty()){
				for( itera=0; itera<1; itera ++){
					creditoHora = (CajasVentanillaBean) listaOperaciones.get(itera);
					horaVar= creditoHora.getHoraEmision();					
				}
			}*/
			
			HSSFCell celdaHora=fila.createCell((short)9);			
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(horaVar);
			
			fila = hoja.createRow(4);
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue((!cajasBean.getNombreSucursal().equals("0"))? cajasBean.getNombreSucursal():"TODAS");										
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Caja:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)3);
			celda.setCellValue((!cajasBean.getDescripcionCaja().equals("0"))? cajasBean.getDescripcionCaja():"TODAS");
		   
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            8  //ultima celda   (0-based)
		    ));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            8  //ultima celda   (0-based)
		    ));
		   
		   
		   
		   fila = hoja.createRow(5);//NUEVA FILA
			
			//						
				
				celda = fila.createCell((short)0);
				celda.setCellValue("No. Transacción");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);			

				celda = fila.createCell((short)2);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Caja");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Naturaleza");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue(opcMenu);//ok
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("No. Grupo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Instrumento");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)8);
				celda.setCellValue("Nombre");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Tipo de Movimiento");
				celda.setCellStyle(estiloCentrado);

				celda = fila.createCell((short)10);
				celda.setCellValue("Efectivo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("MontoSBC");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("No. Póliza");
				celda.setCellStyle(estiloCentrado);
		   
				
				int i=7,iter=0;
				int tamanioLista = listaOperaciones.size();
				CajasVentanillaBean cajas = null;
				for( iter=0; iter<tamanioLista; iter ++){
				 
					cajas = (CajasVentanillaBean)listaOperaciones.get(iter);
					fila=hoja.createRow(i);
					//
					celda=fila.createCell((short)0);
					celda.setCellValue(cajas.getNumTransaccion());				
					
					celda=fila.createCell((short)1);
					celda.setCellValue(cajas.getFecha());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(cajas.getSucursal());
				    
				    
				    celda=fila.createCell((short)3);
					celda.setCellValue(cajas.getDescripcionCaja());
				   
					
					celda=fila.createCell((short)4);
					String naturaleza="";
					switch(Utileria.convierteEntero(cajas.getNaturaleza())){	
					case 1:	
						naturaleza ="ENTRADA";
					break;
					case 2:	
						naturaleza ="SALIDA";
					break;
				
				}
					celda.setCellValue(naturaleza);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(cajas.getClienteID());
				    
					
					celda=fila.createCell((short)6);
					celda.setCellValue(cajas.getGrupoCred());
					
					
					
					celda=fila.createCell((short)7);
					celda.setCellValue(cajas.getNumCuenta());
				    
					
					celda=fila.createCell((short)8);
					celda.setCellValue(cajas.getNombreCliente());
				    
					
					
					celda=fila.createCell((short)9);
					celda.setCellValue(cajas.getReferencia());
					
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(cajas.getEfectivo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(cajas.getMontoSBC()));
					celda.setCellStyle(estiloFormatoDecimal);
				
					celda=fila.createCell((short)12);
					celda.setCellValue(cajas.getPolizaID());
		   
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
				response.addHeader("Content-Disposition","inline; filename=ReporteOpVentanilla.xls");
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
				
			return  listaOperaciones;
	}
	
	public ByteArrayOutputStream opVentanillaPDFComercial(CajasVentanillaBean cajasBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cajasVentanillaServicio.creaRepOpVentanillaPDF(cajasBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepOpVentanilla.pdf");
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
	
	
	public List  opVentanillaExcelComer(int tipoLista, CajasVentanillaBean cajasBean,  HttpServletResponse response){
		List listaOperaciones=null;
		
    	listaOperaciones = cajasVentanillaServicio.listaOpVentanilla(tipoLista,cajasBean,response); 	
    	
    	int regExport = 0;
		
			try {
				
			Calendar calendario=new GregorianCalendar();
			int hora, minutos;
			hora =calendario.get(Calendar.HOUR_OF_DAY);
			minutos = calendario.get(Calendar.MINUTE);
			String minute;
			if(minutos<9){
				minute="0"+minutos;
			}else{
				minute=""+minutos;
			}
			cajasBean.setHoraEmision(hora+":"+minute);
							
			Locale currentLocale;
			ResourceBundle messages;
	        currentLocale = new Locale(parametrosSesionBean.getNomCortoInstitucion());
	        messages = ResourceBundle.getBundle("messages", currentLocale);
	        
	        String opcMenu = messages.getString("safilocale.cliente");
	        
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
			
			HSSFCellStyle estiloTitulos = libro.createCellStyle();
			estiloTitulos.setFont(fuenteNegrita10);
			estiloTitulos.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloTitulos.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Operaciones Ventanilla Comercial");
			HSSFRow fila= hoja.createRow(0);
	
			fila=hoja.createRow(1);
			HSSFCell celdaTitulo=fila.createCell((short)1);
			celdaTitulo.setCellStyle(estiloTitulos);
			celdaTitulo.setCellValue(cajasBean.getNombreInstitucion());
			
			HSSFCell celdaUsur=fila.createCell((short)7);			
			celdaUsur.setCellValue("Usuario:");
			celdaUsur.setCellStyle(estiloNeg8);	
			celdaUsur = fila.createCell((short)8);
			celdaUsur.setCellValue(cajasBean.getUsuario());
			
			fila = hoja.createRow(2);
			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloTitulos);
			celda.setCellValue("REPORTE DE OPERACIONES EN VENTANILLA DEL DÍA "+cajasBean.getFechaIni()+" AL DÍA "+cajasBean.getFechaFin());
												
			
			HSSFCell celdaFecha=fila.createCell((short)7);			
			celdaFecha.setCellValue("Fecha:");
			celdaFecha.setCellStyle(estiloNeg8);	
			celdaFecha = fila.createCell((short)8);
			celdaFecha.setCellValue(cajasBean.getFecha());
			
			fila = hoja.createRow(3);
			
			String horaVar="";
			horaVar=cajasBean.getHoraEmision();
			
			HSSFCell celdaHora=fila.createCell((short)7);			
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)8);
			celdaHora.setCellValue(horaVar);
			
			fila = hoja.createRow(4);
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)1);
			celda.setCellValue((!cajasBean.getNombreSucursal().equals("0"))? cajasBean.getNombreSucursal():"TODAS");										
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Caja:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)3);
			celda.setCellValue((!cajasBean.getDescripcionCaja().equals("0"))? cajasBean.getDescripcionCaja():"TODAS");
			
			
			String Naturaleza="";
			if(Utileria.convierteEntero(cajasBean.getNaturaleza())==1){
				Naturaleza="ENTRADAS";
			}else if(Utileria.convierteEntero(cajasBean.getNaturaleza())==2){
				Naturaleza="SALIDAS";
			}else{
				Naturaleza="TODAS";
			}
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Naturaleza:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)5);
			celda.setCellValue(Naturaleza);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            6  //ultima celda   (0-based)
		    ));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            6  //ultima celda   (0-based)
		    ));
		   
		   
		   
		   fila = hoja.createRow(5);//NUEVA FILA
				
				celda = fila.createCell((short)0);
				celda.setCellValue("No. Transacción");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(opcMenu);
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)2);
				celda.setCellValue(("Nombre "+opcMenu));
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Grupo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Naturaleza");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("PolizaID");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Monto Operación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Monto Depósito");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)9);
				celda.setCellValue("Monto Cambio");
				celda.setCellStyle(estiloCentrado);						   
				
				int i=7,iter=0;
				int tamanioLista = listaOperaciones.size();				
				CajasVentanillaBean cajas = null;
				
				for( iter=0; iter<tamanioLista; iter ++){				
					cajas = (CajasVentanillaBean)listaOperaciones.get(iter);
					fila=hoja.createRow(i);
					//
					celda=fila.createCell((short)0);
					celda.setCellValue(cajas.getNumTransaccion());				
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(cajas.getClienteID());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(cajas.getNombreCliente());
				    
				    
				    celda=fila.createCell((short)3);
					celda.setCellValue(cajas.getGrupoCred());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(cajas.getDescripcionCaja());
					
					celda=fila.createCell((short)5);
					celda.setCellValue((cajas.getNaturaleza().equals("1")?"ENTRADA":"SALIDA"));
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(cajas.getPolizaID());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteDoble(cajas.getMontoOperacion()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble(cajas.getMontoDeposito()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(cajas.getMontoCambio()));
					celda.setCellStyle(estiloFormatoDecimal);
							   
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
				response.addHeader("Content-Disposition","inline; filename=ReporteOpVentanilla.xls");
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
				
			return  listaOperaciones;
	}

	public CajasVentanillaServicio getCajasVentanillaServicio() {
		return cajasVentanillaServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setCajasVentanillaServicio(CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public String getNombreReporteVen() {
		return nombreReporteVen;
	}

	public void setNombreReporteVen(String nombreReporteVen) {
		this.nombreReporteVen = nombreReporteVen;
	}

	public String getNombreReporteComer() {
		return nombreReporteComer;
	}

	public void setNombreReporteComer(String nombreReporteComer) {
		this.nombreReporteComer = nombreReporteComer;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
