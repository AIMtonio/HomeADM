
 package tesoreria.reporte;



import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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

 
import tesoreria.servicio.PresupSucursalServicio;
import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.bean.RepPresupSucursalBean;
 

public class ReportePresupControlador extends AbstractCommandController {
	PresupSucursalServicio presupSucursalServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
 	public ReportePresupControlador(){
 		setCommandClass(PresupuestoSucursalBean.class);
 		setCommandName("presupBean");
 	}
    
 	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		PresupuestoSucursalBean presupuestoSucursalBean = (PresupuestoSucursalBean) command;
 		 
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			presupSucursalServicio.getPresupSucursalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = presupSucursalServicio.reportePresupPantalla(presupuestoSucursalBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reportePresupuestosPDF(presupuestoSucursalBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = reportePresupuestosExcel(tipoLista, presupuestoSucursalBean, response);
				break;
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
 	}
 	
 	
 // Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reportePresupuestosPDF(PresupuestoSucursalBean presupuestoSucursalBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = presupSucursalServicio.reportePresupPDF(presupuestoSucursalBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReportePresupuestos.pdf");
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

	
	public List reportePresupuestosExcel(int tipoLista,PresupuestoSucursalBean presupuestosBean,  HttpServletResponse response){
		List listaPresupuestos=null;
		listaPresupuestos = presupSucursalServicio.listaReportesPresupuestos(tipoLista,presupuestosBean,response); 	
		 
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
			//Estilo negrita de 10 para el titulo del reporte y centrado
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloNeg10.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
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
			HSSFSheet hoja = libro.createSheet("Reporte de Presupuestos");
			HSSFRow fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
 			celdaUsu.setCellValue(presupuestosBean.getNombreInstitucion());
 			celdaUsu.setCellStyle(estiloNeg10);

			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);
			
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue((!presupuestosBean.getNombreUsuario().isEmpty())?presupuestosBean.getNombreUsuario(): "TODOS");

			fila = hoja.createRow(1);
			
			
			HSSFCell celdaFec=fila.createCell((short)1);
			
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(presupuestosBean.getParFechaEmision());
			
			fila = hoja.createRow(2);
			
			
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE DE PRESUPUESTOS DEL MES "+presupuestosBean.getNombreMesIni()+" DEL AÑO "+presupuestosBean.getAnioInicio()+" AL MES "+presupuestosBean.getNombreMesFin()+ " DEL AÑO "+presupuestosBean.getAnioFin());
		

		
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
			
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Estatus Presupuesto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue((!presupuestosBean.getNombreEstatus().isEmpty())?presupuestosBean.getNombreEstatus(): "TODOS");
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Estatus Movimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue((!presupuestosBean.getNomEstatusMov().isEmpty())?presupuestosBean.getNomEstatusMov(): "TODOS");
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue((!presupuestosBean.getNombreSucursal().isEmpty())?presupuestosBean.getNombreSucursal(): "TODOS");
			
			
		
			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
		
			
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Folio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Registro");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Usuario");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloNeg8);			

			celda = fila.createCell((short)5);
			celda.setCellValue("Movimientos de Presupuestos");
			celda.setCellStyle(estiloCentrado);
			
			fila = hoja.createRow(7);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
						
			celda = fila.createCell((short)7);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloCentrado);		
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Monto Disponible");
			celda.setCellStyle(estiloCentrado);		

			celda = fila.createCell((short)9);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);		
			
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 7, 0, 0  
		    ));
		       hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 7, 1, 1 
		    ));
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 7, 2, 2 
		    ));
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 7, 3, 3 
		    ));
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 7, 4, 4 
		    ));
		    hoja.addMergedRegion(new CellRangeAddress(
		    		 6, 6, 5, 9 
		    ));
		   
			
		   

		    
			
			int i=8,iter=0;
			int tamanioLista = listaPresupuestos.size();
			RepPresupSucursalBean presupuesto = null;
			for( iter=0; iter<tamanioLista; iter ++){
			 
				presupuesto = (RepPresupSucursalBean) listaPresupuestos.get(iter);
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(presupuesto.getFolioEncID());
				
				celda=fila.createCell((short)1);
				celda.setCellValue(presupuesto.getFecha());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(presupuesto.getNombreSucurs());
				
				celda=fila.createCell((short)3);
				celda.setCellValue( presupuesto.getNombreCompleto());
				
				celda=fila.createCell((short)4);
				celda.setCellValue(presupuesto.getEstatusEnc());
				
				
				celda=fila.createCell((short)5);
				celda.setCellValue(presupuesto.getNombreConcep());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(presupuesto.getDescripcion());
				
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Double.parseDouble(presupuesto.getMonto()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(Double.parseDouble(presupuesto.getMontoDispon()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(presupuesto.getEstatusDet());
				
				
				i++;
			}
			
			for(int celd=0; celd<=19; celd++)
			hoja.autoSizeColumn((short)celd);
		
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepPresupuestos.xls");
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
			
			
		return  listaPresupuestos;
		
		
		}

	public void setPresupSucursalServicio(PresupSucursalServicio presupSucursalServicio) {
		this.presupSucursalServicio = presupSucursalServicio;
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
 
 