package originacion.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
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

import originacion.bean.AnalistasAsignacionBean;
import originacion.servicio.AnalistasAsignacionServicio;


public class RepProductividadAnalistasControlador extends AbstractCommandController {
	AnalistasAsignacionServicio analistasAsignacionServicio;
	String nombreReporte = null;
	String successView = null;
	
	public RepProductividadAnalistasControlador() {
		setCommandClass(AnalistasAsignacionBean.class);
		setCommandName("analistasAsignacionBean");
	}
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2;
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AnalistasAsignacionBean analistasAsignacionBean = (AnalistasAsignacionBean) command;
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		String htmlString = "";

		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = repProductividadAnalistaPDF(analistasAsignacionBean, nombreReporte, response);
			break;
		case Enum_Con_TipRepor.ReporExcel:
			List<AnalistasAsignacionBean>listaReportes=repProductividadAnalistaExcel(analistasAsignacionBean,response);
			break;
		}
		return null;
	}

	private ByteArrayOutputStream repProductividadAnalistaPDF(AnalistasAsignacionBean analistasAsignacionBean, String nombreReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = analistasAsignacionServicio.reporteProductividadAnalistaPDF(analistasAsignacionBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=productividadAnalistas.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return htmlStringPDF;
	}
	
	private List<AnalistasAsignacionBean> repProductividadAnalistaExcel(AnalistasAsignacionBean analistasAsignacionBean, HttpServletResponse response) {
		List<AnalistasAsignacionBean> listaAnalistasAsignacion= null;
		
		listaAnalistasAsignacion = analistasAsignacionServicio.listaReporte(Utileria.convierteEntero(analistasAsignacionBean.getTipoReporte()), analistasAsignacionBean);
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
		analistasAsignacionBean.setHoraEmision(postFormater.format(calendario.getTime()));
		
		if(listaAnalistasAsignacion != null){
			try{
				XSSFSheet hoja = null;
				XSSFWorkbook libro=null;
				libro = new XSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				XSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				
				XSSFFont fuenteNegrita10Izq= libro.createFont();
				fuenteNegrita10Izq.setFontHeightInPoints((short)10);
				fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

				//Crea un Fuente con tamaño 8 para informacion del reporte.
				XSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				XSSFFont fuente8Cuerpo= libro.createFont();
				fuente8Cuerpo.setFontHeightInPoints((short)8);
				fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

				//Crea un Fuente con tamaño 8 para informacion del reporte.
				XSSFFont fuente10= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				XSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);
				
				//Alineado a la izq
				XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
				estiloNeg10Izq.setFont(fuenteNegrita10Izq);
				estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);
				
				//Estilo negrita de 8  para encabezados del reporte
				XSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloEncabezados = libro.createCellStyle();
				estiloEncabezados.setFont(fuenteNegrita8);
				estiloEncabezados.setBorderBottom((short)1);
				estiloEncabezados.setBorderRight((short)1);
				estiloEncabezados.setBorderLeft((short)1);
				estiloEncabezados.setBorderTop((short)1);
				
				

				XSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				XSSFCellStyle estilo10 = libro.createCellStyle();
				estilo8.setFont(fuente10);
				

				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));	
				estiloFormatoDecimal.setFont(fuente8);
				
				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimalTit = libro.createCellStyle();
				XSSFDataFormat formatTit = libro.createDataFormat();
				estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
				estiloFormatoDecimalTit.setFont(fuenteNegrita8);
					

				// Creacion de hoja					
				hoja = libro.createSheet("Reporte de Productividad de Analistas");
				
			  	// inicio fecha, usuario,institucion y hora
				XSSFRow fila= hoja.createRow(0);
				XSSFCell celdaUsu= fila.createCell((short)9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg10Izq);	
				celdaUsu = fila.createCell((short)10);
				celdaUsu.setCellValue(analistasAsignacionBean.getUsuario());
				
								
				fila = hoja.createRow(1);
				String fechaVar = analistasAsignacionBean.getFechaSistema().toString();
			  	XSSFCell celdaFec= fila.createCell((short)9);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg10Izq);	
				celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue(fechaVar);
				
				
				XSSFCell celdaInst=fila.createCell((short)0);
				celdaInst.setCellValue(analistasAsignacionBean.getNombreInstitucion());
				 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            8  //ultima celda   (0-based)
				    ));
				 celdaInst.setCellStyle(estiloNeg10);


					fila = hoja.createRow(2);
					XSSFCell celdaHora= fila.createCell((short)9);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg10Izq);	
					celdaHora = fila.createCell((short)10);
					celdaHora.setCellValue(analistasAsignacionBean.getHoraEmision());
					// fin fecha usuario,institucion y hora
					XSSFCell celda=fila.createCell((short)0);
					celda.setCellValue("REPORTE DE PRODUCTIVIDAD");
					celda.setCellStyle(estiloNeg10);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            8 //ultima celda   (0-based)
				    ));
					celda.setCellStyle(estiloNeg10);	
					
					fila = hoja.createRow(3);
					celda=fila.createCell((short)0);
					celda.setCellValue("DEL "+Utileria.convertirFechaLetras(analistasAsignacionBean.getFechaInicio())
											 +" AL "+Utileria.convertirFechaLetras(analistasAsignacionBean.getFechaFin()));
					celda.setCellStyle(estiloNeg10);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            3, //primera fila (0-based)
				            3, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            8 //ultima celda   (0-based)
				    ));
					
					
				
	                fila = hoja.createRow(5);
					
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10Izq);
					celda.setCellValue("Usuario:");
					
					celda=fila.createCell((short)1);
					celda.setCellValue(((!analistasAsignacionBean.getUsuarioID().isEmpty())?analistasAsignacionBean.getNombreCompleto(): "TODOS").toUpperCase());
					celda.setCellStyle(estilo10);
				
				fila = hoja.createRow(6);
				
				fila = hoja.createRow(7);
				celda = fila.createCell((short)7);
				celda.setCellValue("% Productividad Global");
				celda.setCellStyle(estiloEncabezados);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						7, //primera fila (0-based)
						7, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            8 //ultima celda   (0-based)
			    ));
				celda = fila.createCell((short)9);
				celda.setCellValue("% Productividad individual");
				celda.setCellStyle(estiloEncabezados);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						7, //primera fila (0-based)
						7, //ultima fila  (0-based)
			            9, //primer celda (0-based)
			            10 //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(8);

				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell((short)0);
				celda.setCellValue("Analista");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Asignadas");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("En Revisión");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Devueltas");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Canceladas");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Rechazadas");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Autorizadas");
				celda.setCellStyle(estiloEncabezados);

				celda = fila.createCell((short)7);
				celda.setCellValue("% Pendientes");
				celda.setCellStyle(estiloEncabezados);

				celda = fila.createCell((short)8);
				celda.setCellValue("% Autorizadas");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("% Pendientes");
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("% Terminadas");
				celda.setCellStyle(estiloEncabezados);
				


				int tamanioLista=listaAnalistasAsignacion.size();
				int i=9;
				
				AnalistasAsignacionBean analistasAsigBean = null;
				for(int iter=0; iter<tamanioLista; iter++){
					analistasAsigBean = (AnalistasAsignacionBean) listaAnalistasAsignacion.get(iter);
					
					fila=hoja.createRow(i);	
					
					celda=fila.createCell((short)0);
					celda.setCellValue(analistasAsigBean.getNombre());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getAsignadas()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getEnRevision()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getDevoluciones()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getCanceladas()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getRechazadas()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteEntero( analistasAsigBean.getAutorizadas()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteDoble( analistasAsigBean.getPendGlobal()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble( analistasAsigBean.getAutGlobal()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble( analistasAsigBean.getPendIndv()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble( analistasAsigBean.getTerminadas()));
					celda.setCellStyle(estilo8);
								
					i++;
				}
				
				fila = hoja.createRow(i);

				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell((short)0);
				celda.setCellValue("TOTAL:");
				celda.setCellStyle(estiloEncabezados);
				
				int numeroPosicion=listaAnalistasAsignacion.size();
				int totalAsignadas=0;
				int totalEnRevision=0;
				int totalDevueltas=0;
				int totalCanceladas=0;
				int totalRechazadas=0;
				int totalAutorizadas=0;
				double totalPorcPendGlobal=0.0;
				double totalAutoriGlobal=0.0;

				if(numeroPosicion>0){
					totalAsignadas=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalAsignadas());
					totalEnRevision=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalEnRevision());
					totalDevueltas=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalDevueltas());
					totalCanceladas=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalCanceladas());
					totalRechazadas=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalRechazadas());
					totalAutorizadas=Utileria.convierteEntero( listaAnalistasAsignacion.get(0).getTotalAutorizadas());
					totalPorcPendGlobal=Utileria.convierteDoble( listaAnalistasAsignacion.get(0).getTotalPorcPendGlobal());
					totalAutoriGlobal=Utileria.convierteDoble( listaAnalistasAsignacion.get(0).getTotalAutoriGlobal());
				}

				celda = fila.createCell((short)1);
				celda.setCellValue(totalAsignadas);
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)2);
				celda.setCellValue(totalEnRevision);
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)3);
				celda.setCellValue(totalDevueltas);
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)4);
				celda.setCellValue(totalCanceladas);
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)5);
				celda.setCellValue(totalRechazadas);
				celda.setCellStyle(estiloEncabezados);
				
				celda = fila.createCell((short)6);
				celda.setCellValue(totalAutorizadas);
				celda.setCellStyle(estiloEncabezados);

				celda = fila.createCell((short)7);
				celda.setCellValue(totalPorcPendGlobal);
				celda.setCellStyle(estiloEncabezados);

				celda = fila.createCell((short)8);
				celda.setCellValue(totalAutoriGlobal);
				celda.setCellStyle(estiloEncabezados);
					
				i = i+2;
				fila=hoja.createRow(i);				
				celda = fila.createCell((short)0);				
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila=hoja.createRow(i);		
				celda = fila.createCell((short)0);
				celda.setCellValue(listaAnalistasAsignacion.size());
				celda.setCellStyle(estilo8);
				
				for(int celd=0; celd<=i; celd++){
					hoja.autoSizeColumn((short)celd);
				}
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteProductividadAnalistas.xlsx");
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
		return listaAnalistasAsignacion;
	}
	
	public AnalistasAsignacionServicio getAnalistasAsignacionServicio() {
		return analistasAsignacionServicio;
	}

	public void setAnalistasAsignacionServicio(AnalistasAsignacionServicio analistasAsignacionServicio) {
		this.analistasAsignacionServicio = analistasAsignacionServicio;
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

