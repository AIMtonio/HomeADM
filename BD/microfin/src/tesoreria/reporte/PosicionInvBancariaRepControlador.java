package tesoreria.reporte;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import regulatorios.bean.CarteraPorTipoA0411Bean;
import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio;


public class PosicionInvBancariaRepControlador extends AbstractCommandController{

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel =3;
	}
	
	InvBancariaServicio invBancariaServicio = null;
	String nomReporte = null;
	String successView = null;
	
	public PosicionInvBancariaRepControlador(){
		setCommandClass(InvBancariaBean.class);
		setCommandName("invBancariaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,  HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		InvBancariaBean invBancaria = (InvBancariaBean) command;	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tioTransaccion")):
					0;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
		invBancariaServicio.getInvBancariaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString= "";
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporExcel:		
				List<InvBancariaBean>listaReportes = reportePosicionInvExcel(tipoLista, invBancaria, response, request);
			break;
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reportePosicionInvBancaria(invBancaria, nomReporte, response, request);
			break;
		}
		if(tipoReporte == Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
	}

	// Reporte de saldos capital de credito en excel
	public List <InvBancariaBean> reportePosicionInvExcel(int tipoLista, InvBancariaBean invBancariaBean,  HttpServletResponse response, HttpServletRequest request){
		List<InvBancariaBean> listaPosicionInv=null;
		listaPosicionInv = invBancariaServicio.listaPosicionInvBancaria(tipoLista, invBancariaBean,response); 	
		if(listaPosicionInv != null){
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
							
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);

				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);

				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);

				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);

				//Estilo de 8  para Contenido
				HSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);

				//Estilo negrita de 8  y color de fondo
				HSSFCellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("0.00"));

				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Reporte de Posicion de Inversiones Bancarias");
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(1);
				fila = hoja.createRow(2);

				HSSFCell celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(request.getParameter("nomInstitucion"));
				hoja.addMergedRegion(new CellRangeAddress(
				           2,2,1,4));
				fila = hoja.createRow(3);
				celda = fila.createCell	((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE DE POSICION DE INVERSIONES BANCARIAS AL " + invBancariaBean.getFechaInicio() );
				hoja.addMergedRegion(new CellRangeAddress(
				           3,3,1,6));
				celda = fila.createCell((short)7);
				celda.setCellValue("Usuario:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)8);
				celda.setCellValue(request.getParameter("nomUsuario"));
				celda.setCellStyle(estiloNeg8);
				fila = hoja.createRow(4);
				celda = fila.createCell((short)1);
				celda.setCellValue("Institución:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)2);
				celda.setCellValue(request.getParameter("nombreInstitucion"));
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)8);
				celda.setCellValue(invBancariaBean.getFechaInicio());
				celda.setCellStyle(estiloNeg8);
				
				// Creacion de fila
				fila = hoja.createRow(5);
				fila = hoja.createRow(6);

				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell((short)0);
				celda.setCellValue("No. Inversión");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)1);
				celda.setCellValue("Institución");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)2);
				celda.setCellValue("Cuenta");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)3);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)4);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)5);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)6);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)7);
				celda.setCellValue("Plazo Días");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Tasa");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Tasa ISR");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)10);
				celda.setCellValue("Interés Recibir");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)11);
				celda.setCellValue("Interés Retener");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)12);
				celda.setCellValue("Total Recibir");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)13);
				celda.setCellValue("Interés Provisión");
				celda.setCellStyle(estiloNeg8);
				
				Double interesRecibir=0.0;
				Double totalRecibir=0.0;
				Double interesProvisionado=0.0;

				int i=7;
				for(InvBancariaBean invBancaria : listaPosicionInv ){
					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(invBancaria.getInversionID());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(invBancaria.getNombreCorto());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(invBancaria.getNumCtaInstit());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(invBancaria.getFechaInicio());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)4);					
					celda.setCellValue(invBancaria.getFechaVencimiento());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(invBancaria.getTipoInversion());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("$ "+Double.parseDouble(invBancaria.getMonto()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(invBancaria.getPlazo());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(invBancaria.getTasa());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(invBancaria.getTasaISR());
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("$ "+Double.parseDouble(invBancaria.getInteresRecibir()));
					celda.setCellStyle(estilo8);
					interesRecibir += Double.parseDouble(invBancaria.getInteresRecibir());
					
					celda=fila.createCell((short)11);
					celda.setCellValue("$ "+Double.parseDouble(invBancaria.getInteresRetener()));
					celda.setCellStyle(estilo8);
					
					celda=fila.createCell((short)12);
					celda.setCellValue("$ "+Double.parseDouble(invBancaria.getTotalRecibir()));
					celda.setCellStyle(estilo8);
					totalRecibir += Double.parseDouble(invBancaria.getTotalRecibir());
					
					celda=fila.createCell((short)13);
					celda.setCellValue("$ "+ Double.parseDouble(invBancaria.getInteresProvisionado()));
					celda.setCellStyle(estilo8);
					interesProvisionado += Double.parseDouble(invBancaria.getInteresProvisionado());
					
					i++;
				}
				
				i = i+1;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)6);
				celda.setCellValue("TOTALES:");
				celda.setCellStyle(estiloNeg8);
				
				celda=fila.createCell((short)10);
				celda.setCellValue("$ "+interesRecibir);
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)12);
				celda.setCellValue("$ "+totalRecibir);
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)13);
				celda.setCellValue("$ "+interesProvisionado);
				celda.setCellStyle(estilo8);
				
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
				hoja.autoSizeColumn((short)14);
						
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReportePosicionInversiones.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return  listaPosicionInv;	
	}

	// Reporte Tira Auditora PDF
	public ByteArrayOutputStream reportePosicionInvBancaria(InvBancariaBean invBancariaBean, String nomReporte, HttpServletResponse response, HttpServletRequest request){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = invBancariaServicio.reportePosicionInvBancaria(invBancariaBean, nomReporte, request);
			response.addHeader("Content-Disposition","inline; filename=ReportePosicionInversion.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// 	TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	public InvBancariaServicio getInvBancariaServicio() {
			return invBancariaServicio;
	}
	public void setInvBancariaServicio(InvBancariaServicio invBancariaServicio) {
		this.invBancariaServicio = invBancariaServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
