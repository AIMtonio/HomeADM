package contabilidad.reporte;
import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.util.Calendar;
import java.util.GregorianCalendar;
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
import herramientas.Utileria;
import contabilidad.bean.ReporteISRRetenidoBean;

import contabilidad.servicio.ReporteISRRetenidoServicio;
import contabilidad.servicio.ReporteISRRetenidoServicio.Enum_Lis_reporteISRRetenidoServicio;

public class ReporteISRRetenidoRepControlador extends AbstractCommandController{

	ReporteISRRetenidoServicio reporteISRRetenidoServicio = null;
	public static interface Enum_Tip_ReporteISRRetenido{
		  
		  int  reporteExcel		= 1 ;
	}
	
 	public ReporteISRRetenidoRepControlador(){
 		setCommandClass(ReporteISRRetenidoBean.class);
 		setCommandName("reporteISRRetenidoBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {

		ReporteISRRetenidoBean reporteISRRetenidoBean = (ReporteISRRetenidoBean) command;

		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;

		String htmlString = "";
		List listaReportes;
		try {
		
				switch (tipoReporte) {
				case Enum_Lis_reporteISRRetenidoServicio.reporteExcel:
					listaReportes = reporteISRRetenidoExcel(reporteISRRetenidoBean,
							Enum_Lis_reporteISRRetenidoServicio.reporteExcel,
							request, response);
					break;
				
				
				}
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		}


	public List  reporteISRRetenidoExcel(ReporteISRRetenidoBean reporteISRRetenidoBean,int tipoLista, HttpServletRequest request, HttpServletResponse response){
		List <ReporteISRRetenidoBean>listaRepISRRetenido  = null;
		listaRepISRRetenido =reporteISRRetenidoServicio.listaReportes(reporteISRRetenidoBean,tipoLista);
		Calendar calendario = new GregorianCalendar();
		String fecha=Utileria.convierteFecha(reporteISRRetenidoBean.getFecha());
		String anio=reporteISRRetenidoBean.getAnio();
		String hora=reporteISRRetenidoBean.getHora();
		String usuarionombre=reporteISRRetenidoBean.getUsuarionombre();
		String empresa=reporteISRRetenidoBean.getNombreInstitucion();
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			/* ------------------------  SE CREAN LOS ESTILOS QUE SE USARAN EN EL REPORTE ------------------------ */
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont estilo10= libro.createFont();
			estilo10.setFontHeightInPoints((short)10);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente Negrita con tamaño 11 para el titulo del reporte
			HSSFFont fuenteNegrita11= libro.createFont();
			fuenteNegrita11.setFontHeightInPoints((short)11);
			fuenteNegrita11.setFontName("Negrita");
			fuenteNegrita11.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.

			//Estilo tamaño de 10 para el titulo del reporte
			HSSFCellStyle estiloTam10 = libro.createCellStyle();
			estiloTam10.setFont(estilo10);
			
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 11 para el titulo del reporte
			HSSFCellStyle estiloNeg11 = libro.createCellStyle();
			estiloNeg11.setFont(fuenteNegrita11);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  

			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 alineda a la derecha 
			HSSFCellStyle estiloNeg10Der = libro.createCellStyle();
			estiloNeg10Der.setFont(fuenteNegrita10);
			estiloNeg10Der.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			//*
			HSSFCellStyle estilo10Der = libro.createCellStyle();
			estiloNeg10Der.setFont(estilo10);
			estiloNeg10Der.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// crea formato datos 
			HSSFDataFormat format = libro.createDataFormat();

			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0.00"));
			
			//centrado
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita11);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("ISRRetenido");
			// se crea la primer fila
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celda;
			fila = hoja.createRow(1);
			celda = fila.createCell((short)9);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)10);
			celda.setCellValue(usuarionombre);
			celda.setCellStyle(estilo10Der);
			
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)4);
			celda.setCellValue(empresa);
			celda.setCellStyle(estiloCentrado);	
			celda = fila.createCell((short)9);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)10);
			celda.setCellValue(fecha);
			celda.setCellStyle(estiloTam10);
			fila = hoja.createRow(3);
			celda = fila.createCell((short)4);
			celda.setCellValue("REPORTE ISR RETENIDO");
			celda.setCellStyle(estiloCentrado);
			celda = fila.createCell((short)9);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)10);
			celda.setCellValue(hora);
			celda.setCellStyle(estilo10Der);
			
			
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Año:");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)3);
			celda.setCellValue(anio);
			celda.setCellStyle(estilo10Der);
			
			///hoja.addMergedRegion(new CellRangeAddress(5, 5, 0, 14));
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);

			celda = fila.createCell((short)0);
			celda.setCellValue("No. Socio");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)1);
			celda.setCellValue("Primer mes");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)2);
			celda.setCellValue("Ultimo Mes");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)3);
			celda.setCellValue("No. Sucursal / Socio");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)4);
			celda.setCellValue("Nombre Socio");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)5);
			celda.setCellValue("RFC Socio");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)6);
			celda.setCellValue("CURP Socio");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)7);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)8);
			celda.setCellValue("ISR");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)9);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)10);
			celda.setCellValue("Menor de Edad");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)11);
			celda.setCellValue("Nombre Del Tutor");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)12);
			celda.setCellValue("RFC Del Tutor");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)13);
			celda.setCellValue("CURP Del Tutor");
			celda.setCellStyle(estiloNeg10);
			
			
			
			int i=8;
			for(ReporteISRRetenidoBean ISRretener : listaRepISRRetenido){
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(ISRretener.getSocio());
				celda=fila.createCell((short)1);
				celda.setCellValue(reporteISRRetenidoServicio.descripcionMes(ISRretener.getPrimermes()));
				celda=fila.createCell((short)2);
				celda.setCellValue(reporteISRRetenidoServicio.descripcionMes(ISRretener.getUltimomes()));
				celda=fila.createCell((short)3);
				celda.setCellValue(ISRretener.getSucursal());
				celda=fila.createCell((short)4);
				celda.setCellValue(ISRretener.getNombre());
				celda=fila.createCell((short)5);
				celda.setCellValue(ISRretener.getRfc());
				celda=fila.createCell((short)6);
				celda.setCellValue(ISRretener.getCurp());
				celda=fila.createCell((short)7);
				celda.setCellValue(Double.parseDouble(ISRretener.getIntereses()));
				celda.setCellStyle(estiloFormatoDecimal);
				celda=fila.createCell((short)8);
				celda.setCellValue(Double.parseDouble(ISRretener.getIsr()));
				celda.setCellStyle(estiloFormatoDecimal);
				celda=fila.createCell((short)9);
				celda.setCellValue(ISRretener.getEstatus());
				celda=fila.createCell((short)10);
				celda.setCellValue(ISRretener.getEsmenor());
				celda=fila.createCell((short)11);
				celda.setCellValue(ISRretener.getNombre_tutor());
				celda=fila.createCell((short)12);
				celda.setCellValue(ISRretener.getRfc_tutor());
				celda=fila.createCell((short)13);
				celda.setCellValue(ISRretener.getCurp_tutor());
			
			i++;
			
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
			hoja.autoSizeColumn((short)9);
			hoja.autoSizeColumn((short)10);
			hoja.autoSizeColumn((short)11);
			hoja.autoSizeColumn((short)12);
			hoja.autoSizeColumn((short)13);
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteIsrRetenido.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
		return  listaRepISRRetenido;	
	}

	public ReporteISRRetenidoServicio getReporteISRRetenidoServicio() {
		return reporteISRRetenidoServicio;
	}

	public void setReporteISRRetenidoServicio(
			ReporteISRRetenidoServicio reporteISRRetenidoServicio) {
		this.reporteISRRetenidoServicio = reporteISRRetenidoServicio;
	} 
		
	
	 	
	}

