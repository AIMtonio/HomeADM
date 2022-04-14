package nomina.reporte;

import java.util.List;
import java.util.Calendar;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Utileria;
import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.servicio.GeneraDomiciliacionPagosServicio;

public class GeneraDomiciliacionPagosRepControlador extends AbstractCommandController{ 
	
	GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio = null;
	
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int Excel = 1; 
	}
	
	public GeneraDomiciliacionPagosRepControlador(){
		setCommandClass(GeneraDomiciliacionPagosBean.class);
		setCommandName("genera");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, 
			BindException errors) throws Exception { 
		
		GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean = (GeneraDomiciliacionPagosBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				  Integer.parseInt(request.getParameter("tipoReporte")):0;
				  
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
				
		String htmlString= "";
		
		switch(tipoReporte){ 
			case Enum_Con_TipReporte.Excel:
				 List listaReportes = RepDomiciliacionPagosExcel(tipoLista, generaDomiciliacionPagosBean, response);
			break;
		}
		return null;
	}
	
	/**
	 * 
	 * @param tipoLista : Reporte de Domiciliación de Pagos en Excel
	 * @param generaDomiciliacionPagosBean
	 * @param response
	 * @return
	 */
	public List RepDomiciliacionPagosExcel(int tipoLista,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean,HttpServletResponse response){
		
		List listaDomiciliacionPagos = null;
		
		listaDomiciliacionPagos = generaDomiciliacionPagosServicio.lista(tipoLista, generaDomiciliacionPagosBean);
		
		int regExport = 0;
		
		if(listaDomiciliacionPagos != null){
		try {
			SXSSFWorkbook libro = new SXSSFWorkbook(100);
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Arial");
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNeg8= libro.createFont();
			fuenteNeg8.setFontHeightInPoints((short)8);
			fuenteNeg8.setFontName("Arial");
			fuenteNeg8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			//Estilo negrita de 10 para encabezados del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			// Estilo de datos centrado en la información del reporte
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER); 
			
			// Estrilo centrado fuente negrita 10
			CellStyle estiloCentrado10 = libro.createCellStyle();			
			estiloCentrado10.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado10.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado10.setFont(fuenteNegrita10);
			
			// Estilo centrado fuente negrita 8
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			// Estilo negrita de 8 para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			CellStyle estiloNegro8 = libro.createCellStyle();
			estiloNegro8.setFont(fuenteNeg8);
			
			//Estilo negrita de 8  y color de fondo
			CellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$ #,##0.00"));
			Sheet hoja = null;
			hoja = libro.createSheet("Reporte Domiciliación de Pagos");
			
			Row fila = hoja.createRow(0);
			
			// Nombre Usuario
			Cell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNegro8);	
			celdaUsu = fila.createCell((short)8);				
			celdaUsu.setCellValue((!generaDomiciliacionPagosBean.getNomUsuario().toUpperCase().isEmpty())?generaDomiciliacionPagosBean.getNomUsuario().toUpperCase():"TODOS");				
				
			fila = hoja.createRow(1);
			
			// Nombre Institucion	
			Cell celdaInst = fila.createCell((short)1);
			celdaInst = fila.createCell((short)2);
			celdaInst.setCellValue(generaDomiciliacionPagosBean.getNombreInstitucion());
			
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila 
		            1, //ultima fila 
		            2, //primer celda
		            5 //ultima celda
		    ));			
			
			celdaInst.setCellStyle(estiloCentrado10);
			// Fecha en que se genera el reporte
			Cell celdaFec = fila.createCell((short)1);
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNegro8);	
			celdaFec = fila.createCell((short)8);
			celdaFec.setCellValue(generaDomiciliacionPagosBean.getFechaSistema());	
			
			fila = hoja.createRow(2);
			
			// Titulo del Reporte
			Cell celda = fila.createCell((short)1);
			celda = fila.createCell((short)2);
			celda.setCellValue("REPORTE DOMICILIACIÓN DE PAGOS");
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila 
		            2, //ultima fila 
		            2, //primer celda
		            5 //ultima celda
		    ));										
			celda.setCellStyle(estiloCentrado10);
			
			// Hora en que se genera el reporte
			Cell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)7);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNegro8);	
			celdaHora = fila.createCell((short)8);
			
			String horaVar = "";
			
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
			
			celdaHora.setCellValue(horaVar);					
			
			fila = hoja.createRow(3);						
			
			// Creacion de fila
				
			fila = hoja.createRow(4);
			celda = fila.createCell((short)1);
			celda.setCellValue("No. Cliente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre Institución");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Cuenta Clabe");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("No. Crédito");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Exigible");
			celda.setCellStyle(estiloCentrado);
			
			int i = 5, iter = 0;
			int tamanioLista = listaDomiciliacionPagos.size();
			
			GeneraDomiciliacionPagosBean domiciliacion = null;

			
			for(iter = 0; iter<tamanioLista; iter ++){
				domiciliacion = (GeneraDomiciliacionPagosBean) listaDomiciliacionPagos.get(iter);
				
				fila = hoja.createRow(i);
				celda = fila.createCell((short)1);
				celda.setCellValue(domiciliacion.getClienteID());
				
				celda = fila.createCell((short)2);
				celda.setCellValue(domiciliacion.getNombreCliente());
				
				celda = fila.createCell((short)3);
				celda.setCellValue(domiciliacion.getNombreInstitucion());
				
				celda = fila.createCell((short)4);
				celda.setCellValue(domiciliacion.getCuentaClabe());

				celda = fila.createCell((short)5);
				celda.setCellValue(domiciliacion.getCreditoID());
				
				celda = fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(domiciliacion.getMontoExigible()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				regExport = regExport + 1;

				i++;
			}
				
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNegro8);
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);	
			
			for(int celd=0; celd<=19; celd++)
			hoja.autoSizeColumn((short)celd);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteDomiciliacionPagos.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			libro.write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
			
				e.printStackTrace();
			}
		}
		
		return listaDomiciliacionPagos;
		
	}

	// ============ GETTER  & SETTER ============== //

	public GeneraDomiciliacionPagosServicio getGeneraDomiciliacionPagosServicio() {
		return generaDomiciliacionPagosServicio;
	}

	public void setGeneraDomiciliacionPagosServicio(GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio) {
		this.generaDomiciliacionPagosServicio = generaDomiciliacionPagosServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
