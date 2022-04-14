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

import originacion.bean.ReferenciaClienteBean;
import originacion.servicio.ReferenciaClienteServicio;

public class RepReferenciasCteControlador extends AbstractCommandController {
	ReferenciaClienteServicio referenciaClienteServicio;
	String nombreReporte = null;
	String successView = null;
	
	public RepReferenciasCteControlador() {
		setCommandClass(ReferenciaClienteBean.class);
		setCommandName("referenciaClienteBean");
	}
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2;
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReferenciaClienteBean referenciaClienteBean = (ReferenciaClienteBean) command;
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		String htmlString = "";

		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = repReferenciasCtePDF(referenciaClienteBean, nombreReporte, response);
			break;
		case Enum_Con_TipRepor.ReporExcel:
			List<ReferenciaClienteBean>listaReportes=repReferenciasCteExcel(referenciaClienteBean,response);
			break;
		}
		return null;
	}

	private ByteArrayOutputStream repReferenciasCtePDF(ReferenciaClienteBean referenciaClienteBean, String nombreReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = referenciaClienteServicio.reporteReferenciasCtePDF(referenciaClienteBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReferenciasSolicitudCredito.pdf");
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
	
	private List<ReferenciaClienteBean> repReferenciasCteExcel(ReferenciaClienteBean referenciaClienteBean, HttpServletResponse response) {
		List<ReferenciaClienteBean> listaReferencias= null;
		
		listaReferencias = referenciaClienteServicio.listaReporte(Utileria.convierteEntero(referenciaClienteBean.getTipoReporte()), referenciaClienteBean);
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
		referenciaClienteBean.setHoraEmision(postFormater.format(calendario.getTime()));
		
		if(listaReferencias != null){
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
				hoja = libro.createSheet("Reporte Referencias Sol. Cred.");
				
			  	// inicio fecha, usuario,institucion y hora
				XSSFRow fila= hoja.createRow(0);
				XSSFCell celdaUsu= fila.createCell((short)5);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg10Izq);	
				celdaUsu = fila.createCell((short)6);
				celdaUsu.setCellValue(((!referenciaClienteBean.getNombreUsuario().isEmpty())?referenciaClienteBean.getNombreUsuario(): "TODOS").toUpperCase());
				
				fila = hoja.createRow(1);
				String fechaVar = referenciaClienteBean.getFechaSistema().toString();
			  	XSSFCell celdaFec= fila.createCell((short)5);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg10Izq);	
				celdaFec = fila.createCell((short)6);
				celdaFec.setCellValue(fechaVar);
				
				
				XSSFCell celdaInst=fila.createCell((short)1);
				celdaInst.setCellValue(referenciaClienteBean.getNombreInstitucion());
				 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            4  //ultima celda   (0-based)
				    ));
				 celdaInst.setCellStyle(estiloNeg10);


					fila = hoja.createRow(2);
					XSSFCell celdaHora= fila.createCell((short)5);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg10Izq);	
					celdaHora = fila.createCell((short)6);
					celdaHora.setCellValue(referenciaClienteBean.getHoraEmision());
					// fin fecha usuario,institucion y hora
					XSSFCell celda=fila.createCell((short)1);
					celda.setCellValue("REPORTE DE REFERENCIAS POR SOLICITUD DE CRÉDITO DEL "+referenciaClienteBean.getFechaInicio()+
							" AL "+referenciaClienteBean.getFechaFin());
					celda.setCellStyle(estiloNeg10);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            4 //ultima celda   (0-based)
				    ));
					celda.setCellStyle(estiloNeg10);	
				
				
				fila = hoja.createRow(4);
				
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Producto de Crédito:");
				
				celda=fila.createCell((short)2);
				celda.setCellValue(referenciaClienteBean.getNombreProducto());
				celda.setCellStyle(estilo10);
				
				String interesado = "";
				if(referenciaClienteBean.getInteresado().trim().isEmpty()){
					interesado = "TODOS";
				} else if(referenciaClienteBean.getInteresado().equalsIgnoreCase("S")){
					interesado = "Si";
				} else if(referenciaClienteBean.getInteresado().equalsIgnoreCase("N")){
					interesado = "No";
				}
				
				celda=fila.createCell((short)3);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Interesado:");				
				celda=fila.createCell((short)4);
				celda.setCellValue(interesado);
				celda.setCellStyle(estilo10);
				
				fila = hoja.createRow(5);
				fila = hoja.createRow(7);

				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell((short)0);
				celda.setCellValue("Solicitud de Crédito");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)1);
				celda.setCellValue("Solicitante");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)2);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Teléfono");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Domicilio");
				celda.setCellStyle(estiloNeg8);

				int tamanioLista=listaReferencias.size();
				int i=8;
				
				ReferenciaClienteBean referenciasBean = null;
				for(int iter=0; iter<tamanioLista; iter++){
					referenciasBean = (ReferenciaClienteBean) listaReferencias.get(iter);
					
					fila=hoja.createRow(i);				
					celda=fila.createCell((short)0);
					celda.setCellValue(referenciasBean.getSolicitudCreditoID());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(referenciasBean.getNombreCte());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(referenciasBean.getNombreCompleto());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					

					celda=fila.createCell((short)3);
					celda.setCellValue(referenciasBean.getTelefono());
					celda.setCellStyle(estilo8);
	
						
					celda=fila.createCell((short)4);
					celda.setCellValue(referenciasBean.getDireccionCompleta());
					celda.setCellStyle(estilo8);				
					i++;
				}
				 
				i = i+2;
				fila=hoja.createRow(i);				
				celda = fila.createCell((short)0);				
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila=hoja.createRow(i);		
				celda = fila.createCell((short)0);
				celda.setCellValue(listaReferencias.size());
				celda.setCellStyle(estilo8);
				
				for(int celd=0; celd<=i; celd++){
					hoja.autoSizeColumn((short)celd);
				}
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteRefernciasSolicitud.xlsx");
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
		return listaReferencias;
	}
	public ReferenciaClienteServicio getReferenciaClienteServicio() {
		return referenciaClienteServicio;
	}

	public void setReferenciaClienteServicio(ReferenciaClienteServicio referenciaClienteServicio) {
		this.referenciaClienteServicio = referenciaClienteServicio;
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
