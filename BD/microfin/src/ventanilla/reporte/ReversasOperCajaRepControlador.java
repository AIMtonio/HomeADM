package ventanilla.reporte;

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
import fondeador.bean.CreditoFondeoBean;
import fondeador.bean.RepVencimiPasBean;
import fondeador.reporte.RepVencimienPasivosControlador.Enum_Con_TipRepor;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.ReversasOperCajaBean;
import ventanilla.servicio.CajasVentanillaServicio;
import ventanilla.servicio.CatalogoGastosAntServicio;
import ventanilla.servicio.ReversasOperCajaServicio;

public class ReversasOperCajaRepControlador extends AbstractCommandController{
	
	ReversasOperCajaServicio reversasOperCajaServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	
public static interface Enum_Con_TipRepor {
		  
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		  
		}
public ReversasOperCajaRepControlador(){
	setCommandClass(ReversasOperCajaBean.class);
	setCommandName("reversasOperCajaBean");	
	
}

protected ModelAndView handle(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors)throws Exception {
	
	ReversasOperCajaBean reversasOperCajaBean = (ReversasOperCajaBean) command;

int tipoReporte =(request.getParameter("tipoReporte")!=null)?
		Integer.parseInt(request.getParameter("tipoReporte")):
	0;
		
String htmlString= "";
		
	switch(tipoReporte){		
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reversaOperCajaRepPDF(reversasOperCajaBean, nombreReporte, response);
		break;	
		
		case Enum_Con_TipRepor.ReporExcel:
			 List listaReportes = reversasOpera(2, reversasOperCajaBean, response);
		break;	
		
		
	}
	return null;		
}

//Reporte en PDF
	public ByteArrayOutputStream reversaOperCajaRepPDF(ReversasOperCajaBean reversasOperCajaBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reversasOperCajaServicio.reporteReversasPDF(reversasOperCajaBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepReversas.pdf");
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


	public List  reversasOpera(int tipoLista, ReversasOperCajaBean reversasOperCajaBean,  HttpServletResponse response){
		List listaOperaciones=null;
    	listaOperaciones = reversasOperCajaServicio.listaReversas(reversasOperCajaBean,response); 	
    	
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
			

			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
			
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Reversas Ventanilla");
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celdaIni=fila.createCell((short)4);
			//celdaIni.setCellStyle(estiloNeg10);
			celdaIni.setCellValue(reversasOperCajaBean.getNombreInstitucion());
			celdaIni.setCellStyle(estiloCentrado);
			//celdaIni.setCellStyle(estiloNeg8);	
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            4, //primer celda (0-based)
		            8  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(1);
 			
			HSSFCell celda=fila.createCell((short)4);
			//celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE REVERSAS DE CAJA DEL "+reversasOperCajaBean.getFechaIni()+" AL "+reversasOperCajaBean.getFechaFin());
			celda.setCellStyle(estiloCentrado);
			//celda.setCellStyle(estiloNeg8);	
			
			
			
			fila = hoja.createRow(2);
			
			HSSFCell celdaFec=fila.createCell((short)1);
			celda = fila.createCell((short)11);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(reversasOperCajaBean.getUsuario());
			

			fila = hoja.createRow(3);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)12);
			celda.setCellValue(reversasOperCajaBean.getFecha());
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((!reversasOperCajaBean.getNombreSucursal().equals("0"))? reversasOperCajaBean.getNombreSucursal():"TODAS");
			
			fila = hoja.createRow(4);
			String horaVar="";
			
			int itera=0;
			ReversasOperCajaBean creditoHora = null;
			if(!listaOperaciones.isEmpty()){
				for( itera=0; itera<1; itera ++){
					creditoHora = (ReversasOperCajaBean) listaOperaciones.get(itera);
					horaVar= creditoHora.getHora();					
				}
			}
			
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)11);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)12);
			celdaHora.setCellValue(reversasOperCajaBean.getHoraEmision());	
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Caja:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((!reversasOperCajaBean.getDescripcionCaja().equals("0"))? reversasOperCajaBean.getDescripcionCaja():"TODAS");
		   
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            4, //primer celda (0-based)
		            8  //ultima celda   (0-based)
		    ));
		   
		   
		   
		   fila = hoja.createRow(5);//NUEVA FILA
			
			//						
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
		   
				celda = fila.createCell((short)2);
				celda.setCellValue("Caja");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Usuario Captura");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Usuario Autoriza");
				celda.setCellStyle(estiloNeg8);			

				celda = fila.createCell((short)6);
				celda.setCellValue("Hora");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Operación Reversa");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Descripción");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Referencia Instrumento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Transacción");
				celda.setCellStyle(estiloNeg8);

				
				
				int i=7,iter=0;
				int tamanioLista = listaOperaciones.size();
				ReversasOperCajaBean cajas = null;
				for( iter=0; iter<tamanioLista; iter ++){
				 
					cajas = (ReversasOperCajaBean)listaOperaciones.get(iter);
					fila=hoja.createRow(i);
					//
					
					celda=fila.createCell((short)1);
					celda.setCellValue(cajas.getSucursalID()+" - "+cajas.getNombreSucursal());	
					
					celda=fila.createCell((short)2);
					celda.setCellValue(cajas.getCajaID()+" - " +cajas.getDescripcionCaja());
					

					celda=fila.createCell((short)3);
					celda.setCellValue(cajas.getFecha());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(cajas.getClave());				

					celda=fila.createCell((short)5);
					celda.setCellValue(cajas.getClaveUsuarioAut());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(cajas.getHora());
					celda.setCellStyle(estiloDatosCentrado);

				    
				    celda=fila.createCell((short)7);
					celda.setCellValue(cajas.getDescripcion());
				   
					
					celda=fila.createCell((short)8);
					celda.setCellValue(cajas.getMotivo());	
					
					
					celda=fila.createCell((short)9);
					celda.setCellValue(cajas.getReferencia());
				    
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Double.parseDouble(cajas.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					
					celda=fila.createCell((short)11);
					celda.setCellValue(cajas.getTransaccion());
					celda.setCellStyle(estiloDatosDerecha);
					
					
					
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
				response.addHeader("Content-Disposition","inline; filename=ReporteReversas.xls");
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

	public ReversasOperCajaServicio getReversasOperCajaServicio() {
		return reversasOperCajaServicio;
	}

	public void setReversasOperCajaServicio(
			ReversasOperCajaServicio reversasOperCajaServicio) {
		this.reversasOperCajaServicio = reversasOperCajaServicio;
	}
	
	
}
