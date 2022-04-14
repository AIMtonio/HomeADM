package credito.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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

import credito.bean.AmortizacionCreditoBean;
import credito.reporte.RepAmortCredControlador.Enum_TipoSuma;
import credito.servicio.AmortizacionCreditoServicio;

public class RepProyeccionCreditoControlador extends AbstractCommandController {

	AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int reportePDF  = 1 ;		
		  int reporteExcel = 6 ;
		}
	
	
	public RepProyeccionCreditoControlador () {
		setCommandClass(AmortizacionCreditoBean.class);
		setCommandName("amortizacionCreditoBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		AmortizacionCreditoBean bean = (AmortizacionCreditoBean) command;

		List<AmortizacionCreditoBean>listaReportes = null;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
	
	
	switch(tipoReporte){	
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = reportePDF(tipoReporte,bean, nomReporte, response);
		break;
		case Enum_Con_TipRepor.reporteExcel:
			listaReportes = reporteAmorSolCreditoExcel(bean, request, response, tipoReporte);
		break;
	}	
				
		return null;	
	}

		
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream reportePDF(int tipoReporte,AmortizacionCreditoBean bean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = amortizacionCreditoServicio.reporteProyeccionCredito(tipoReporte,bean, nomReporte);
			amortizacionCreditoServicio.reporteProyeccionCreditoBajaAccesorios(bean);
			response.addHeader("Content-Disposition","inline; filename=ReporteProyeccionCredito.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF
	
	
	private List<AmortizacionCreditoBean> reporteAmorSolCreditoExcel(AmortizacionCreditoBean amortizacionCreditoBean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<AmortizacionCreditoBean> listaReporte= amortizacionCreditoServicio.listaGrid(tipoReporte, amortizacionCreditoBean);
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
		String hora = postFormater.format(calendario.getTime());
		String nombreReporteXLS = "AmortizacionesSolicitudCredito";
		String tituloReporte = "TABLA DE AMORTIZACIONES SOLICITUD DE CRÉDITO";
		
		if(listaReporte != null){
			try{
				XSSFSheet hoja = null;
				XSSFWorkbook libro=null;
				short fuenteBold 	= XSSFFont.BOLDWEIGHT_BOLD;
				short fuenteNoBold	= XSSFFont.BOLDWEIGHT_NORMAL;
				short fuenteCen		= XSSFCellStyle.ALIGN_CENTER;
				short fuenteIzq		= XSSFCellStyle.ALIGN_LEFT;
				libro = new XSSFWorkbook();
								
				// Creacion de hoja					
				hoja = libro.createSheet("Amortizaciones SolicitudCredito");
				
				XSSFRow fila= hoja.createRow(0);
				XSSFCell celdaUsu= fila.createCell(9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				celdaUsu = fila.createCell(10);
				celdaUsu.setCellValue(parametrosSesionBean.getClaveUsuario().toUpperCase());
				
				fila = hoja.createRow(1);
				String fechaVar = parametrosSesionBean.getFechaSucursal().toString();
			  	XSSFCell celdaFec= fila.createCell(9);
				celdaFec.setCellValue("Fecha:");	
				celdaFec.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				celdaFec = fila.createCell(10);
				celdaFec.setCellValue(fechaVar);
				
				
				XSSFCell celdaInst=fila.createCell((short)1);
				celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 8 ));
				celdaInst.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));

				fila = hoja.createRow(2);
				XSSFCell celdaHora= fila.createCell(9);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));	
				celdaHora = fila.createCell(10);
				celdaHora.setCellValue(hora);
				// fin fecha usuario,institucion y hora
				
				XSSFCell celda=fila.createCell((short)1);
				celda.setCellValue(tituloReporte); 
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				hoja.addMergedRegion(new CellRangeAddress( 2, 2, 1, 8 ));	
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				
				fila = hoja.createRow(5);
				XSSFCell celdaTitulo= fila.createCell(0);
				hoja.addMergedRegion(new CellRangeAddress( 5, 5, 0, 2 ));	
				celdaTitulo.setCellValue("Simulador de Amortizaciones");
				celdaTitulo.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));	
				
				
				fila = hoja.createRow(6);
				int numCelda = 0;
		
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Número");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha Pago");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("  Capital  ");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("  Interés  ");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				if((request.getParameter("cobraSeguroCuota").equals("S"))){
					celda = fila.createCell(numCelda++);
					celda.setCellValue("  Seguro  ");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("  IVA Seguro  ");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				}
				
				if (request.getParameter("cobraAccesorios").equals("S")){
					celda = fila.createCell(numCelda++);
					celda.setCellValue("  Otras Comisiones  ");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("  IVA Otras Comisiones  ");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				}
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue(" Total Pago ");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue(" Saldo Capital ");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				int tamanioLista=listaReporte.size();
				int i=7;
				
				AmortizacionCreditoBean amortiCredBean = null;
				for(int iter=0; iter<tamanioLista; iter++){
					amortiCredBean = (AmortizacionCreditoBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila=hoja.createRow(i);
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getAmortizacionID());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaInicio());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaVencim());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaExigible());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getCapital()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));

					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getInteres()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getIvaInteres()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					if((request.getParameter("cobraSeguroCuota").equals("S"))){
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoSeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getiVASeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));	
					}
					
					if (request.getParameter("cobraAccesorios").equals("S")){
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoOtrasComisiones()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoIVAOtrasComisiones()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					}
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoCuota()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapital()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					i++;
				}
				
				for (int celd = 0; celd <= i; celd++){
					hoja.autoSizeColumn(celd, true);
				}
				
				numCelda = 3;
				fila=hoja.createRow(i);				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue("Totales:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue(sumarColumna(listaReporte, 1));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue(sumarColumna(listaReporte, 2));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue(sumarColumna(listaReporte, 3));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				if((request.getParameter("cobraSeguroCuota").equals("S"))){
					celda=fila.createCell(numCelda++);
					celda.setCellValue(sumarColumna(listaReporte, 4));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(sumarColumna(listaReporte, 5));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}
				
				if (request.getParameter("cobraAccesorios").equals("S")){
					celda=fila.createCell(numCelda++);
					celda.setCellValue(sumarColumna(listaReporte, 6));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(sumarColumna(listaReporte, 7));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}
				
				i = i+3;
				fila=hoja.createRow(i);				
				celda = fila.createCell((short)0);				
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				i++;
				fila=hoja.createRow(i);		
				celda = fila.createCell((short)0);
				celda.setCellValue(listaReporte.size());
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreReporteXLS+".xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		return listaReporte;
	}
	
	private double sumarColumna(List listaReporte, int opcion){
		double suma = 0.0;
		AmortizacionCreditoBean amortiCredBean = null;
		
		for(int iter=0; iter<listaReporte.size(); iter++){
			amortiCredBean = (AmortizacionCreditoBean) listaReporte.get(iter);
			
			switch (opcion) {
			case Enum_TipoSuma.SumaCapital:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getCapital());
				break;
			case Enum_TipoSuma.SumaInteres:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getInteres());
				break;
			case Enum_TipoSuma.SumaIVAInteres:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getIvaInteres());
				break;
			case Enum_TipoSuma.SumaSeguro:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getMontoSeguroCuota());
				break;
			case Enum_TipoSuma.SumaIVaSeguro:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getiVASeguroCuota());
				break;
			case Enum_TipoSuma.sumaComisiones:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getMontoOtrasComisiones());
				break;
			case Enum_TipoSuma.sumaIvaCom:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getMontoIVAOtrasComisiones());
				break;
			}
		}
		return suma;
	}
	
	private XSSFCellStyle crearFuente(XSSFWorkbook libro, int tamFuente, short align, short type){
		XSSFFont fuente = libro.createFont();
		fuente.setFontHeightInPoints((short)tamFuente);
		fuente.setFontName(HSSFFont.FONT_ARIAL);
		fuente.setBoldweight(type);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		estilo.setFont(fuente);
		estilo.setAlignment(align);

		return estilo;
	}
	
	private XSSFCellStyle fuenteFormatoDecimal(XSSFWorkbook libro, int tamFuente, short type){
		XSSFFont fuente = libro.createFont();
		fuente.setFontHeightInPoints((short)tamFuente);
		fuente.setFontName(HSSFFont.FONT_ARIAL);
		fuente.setBoldweight(type);
		
		XSSFCellStyle estilo = libro.createCellStyle();		
		XSSFDataFormat format = libro.createDataFormat();
		estilo.setDataFormat(format.getFormat("$#,###,##0.00"));	
		estilo.setFont(fuente);
		
		return estilo;
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
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public AmortizacionCreditoServicio getAmortizacionCreditoServicio() {
		return amortizacionCreditoServicio;
	}
	public void setAmortizacionCreditoServicio(
			AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}
	
}
