package spei.reporte;

import herramientas.Constantes;
import herramientas.Utileria;

import java.util.Calendar;
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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import spei.bean.RepSpeiEnviosBean;
import spei.servicio.RepSpeiEnviosServicio;

public class ReporteSpeiEnviosRepControlador extends AbstractCommandController{
	public static interface Enum_Tipo_Reporte {
		int pdf = 1;
		int excel = 2;
	}
	
	RepSpeiEnviosServicio repSpeiEnviosServicio = null;
	
	String successView = null;
	
	public ReporteSpeiEnviosRepControlador() {
		setCommandClass(RepSpeiEnviosBean.class);
		setCommandName("repSpeiEnvios");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,  Object command, BindException errors) throws Exception {

		RepSpeiEnviosBean repSpeiEnviosBean = (RepSpeiEnviosBean) command;
		
		int tipoReporte =(request.getParameter("tipoRep")!=null)?Integer.parseInt(request.getParameter("tipoRep")):0;
		int numReporte =(request.getParameter("numReporte")!=null)?Integer.parseInt(request.getParameter("numReporte")):0;
		
		String htmlString = "";
		
		switch(tipoReporte){	
		case Enum_Tipo_Reporte.excel:	
			 List<RepSpeiEnviosBean>listaReportes = listaReporte(tipoReporte, numReporte, repSpeiEnviosBean ,response);
			 break;
			 
		}
		return null;	
	}
	
	public List<RepSpeiEnviosBean> listaReporte(int tipoReporte, int numReporte, RepSpeiEnviosBean repSpeiEnviosBean,  HttpServletResponse response){
		List<RepSpeiEnviosBean> listaSpeiEnvios=null;
		
		if(tipoReporte == Enum_Tipo_Reporte.excel){
			listaSpeiEnvios = repSpeiEnviosServicio.listaReporte(numReporte, repSpeiEnviosBean, response);
		}	
		
		Calendar calendario = Calendar.getInstance();
		
		if(listaSpeiEnvios != null){
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente10= libro.createFont();
				fuente10.setFontHeightInPoints((short)10);
				fuente10.setFontName("Arial");
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			
				
				//Estilo negrita de 8  para encabezados del reporte												
				HSSFCellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita10);
				estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo negrita de 8  para encabezados del reporte												
				HSSFCellStyle estiloCentradoNoNeg = libro.createCellStyle();
				estiloCentradoNoNeg.setFont(fuente10);
				estiloCentradoNoNeg.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita10);
				
				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
				
				HSSFSheet hoja = libro.createSheet("Reporte SPEI Envíos");
				HSSFRow fila = hoja.createRow(0);
				
				if(tipoReporte == Enum_Tipo_Reporte.excel) {
					fila = hoja.createRow(1);
					HSSFCell celda=fila.createCell((short)0);	
					
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(repSpeiEnviosBean.getInstitucion());
					CellRangeAddress region = new CellRangeAddress(1,1,0,17);
					hoja.addMergedRegion(region);
						 
					celda = fila.createCell((short)18);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Usuario:");		
					celda = fila.createCell((short)19);
					celda.setCellValue(repSpeiEnviosBean.getUsuario());					
					
					fila = hoja.createRow(2);		
					
					celda = fila.createCell	((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Reporte de Envíos SPEI de "+repSpeiEnviosBean.getFechaInicio()+" AL "+repSpeiEnviosBean.getFechaFin());
					hoja.addMergedRegion(new CellRangeAddress(2, 2, 0, 17));	
					
					celda=fila.createCell((short)18);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Fecha: ");
					celda=fila.createCell((short)19);
					celda.setCellValue(repSpeiEnviosBean.getFecha());
					
					fila = hoja.createRow(3);								
					
					celda = fila.createCell((short)18);
					celda.setCellValue("Hora: ");
					celda.setCellStyle(estiloNeg8);
					celda = fila.createCell((short)19);
					String horaVar="";
					
					int hora =calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);
				
					String h = Integer.toString(hora);
					String m = "";
					String s = "";
					if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
					if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
					 
					horaVar= h+":"+m+":"+s;
					celda.setCellValue(horaVar);
					
					fila = hoja.createRow(4);
					
					celda = fila.createCell((short)0);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Monto Mínimo: " + repSpeiEnviosBean.getMontoTransferIni());
					
					celda = fila.createCell((short)1);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Monto Máximo: " + repSpeiEnviosBean.getMontoTransferFin());
					
					celda = fila.createCell((short)2);
					celda.setCellStyle(estiloNeg8);
					celda.setCellValue("Cuenta de Ahorro: " + (repSpeiEnviosBean.getCuentaAhoID().equals(Constantes.STRING_CERO) ? "TODOS" : repSpeiEnviosBean.getCuentaAhoID()));
					
					fila = hoja.createRow(5);
					fila = hoja.createRow(6);
					
					int numCelda = 0;
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Folio SPEI");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Folio STP");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Clave de Rastreo");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Cuenta de Ahorro");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);

					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Tipo de Orden");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Nombre del Beneficiario");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Cuenta del Beneficiario");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Nombre del Ordenante");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Cuenta del Ordenante");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Institución Receptora");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Institución Remitente");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Concepto Pago");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Monto a Transferir");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("IVA por Pagar");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("IVA Comisión");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Total Cargo a Cuenta");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Tipo de Pago");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Estado de la Orden de Pago");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Estado del Envío");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Causa de Devolución");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)numCelda++);
					celda.setCellValue("Fecha de la Operación");
					celda.setCellStyle(estiloCentrado);
					celda.setCellStyle(estiloNeg8);
					
					int i=7,iter=0;
					int tamanioLista = listaSpeiEnvios.size();
					RepSpeiEnviosBean reporteSpeiEnviosBean = null;
					
					for(iter=0; iter<tamanioLista; iter ++){
						numCelda = 0;
						reporteSpeiEnviosBean =  (RepSpeiEnviosBean) listaSpeiEnvios.get(iter);
						
						fila=hoja.createRow(i);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getFolioSpeiID() == null || reporteSpeiEnviosBean.getFolioSpeiID().equals("") ? "" : reporteSpeiEnviosBean.getFolioSpeiID());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getFolioSTP() == null || reporteSpeiEnviosBean.getFolioSTP().equals("") ? "" : reporteSpeiEnviosBean.getFolioSTP());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getClaveRastreo() == null || reporteSpeiEnviosBean.getClaveRastreo().equals("") ? "" : reporteSpeiEnviosBean.getClaveRastreo());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getCuentaAhoID() == null || reporteSpeiEnviosBean.getCuentaAhoID().equals("") ? "" : reporteSpeiEnviosBean.getCuentaAhoID());

						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getOrigenOperacion() == null || reporteSpeiEnviosBean.getOrigenOperacion().equals("") ? "" : reporteSpeiEnviosBean.getOrigenOperacion());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getNombreBeneficiario() == null || reporteSpeiEnviosBean.getNombreBeneficiario().equals("") ? "" : reporteSpeiEnviosBean.getNombreBeneficiario());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getCuentaBeneficiario() == null || reporteSpeiEnviosBean.getCuentaBeneficiario().equals("") ? "" : reporteSpeiEnviosBean.getCuentaBeneficiario());

						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getNombreOrd() == null || reporteSpeiEnviosBean.getNombreOrd().equals("") ? "" : reporteSpeiEnviosBean.getNombreOrd());

						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getCuentaOrd() == null || reporteSpeiEnviosBean.getCuentaOrd().equals("") ? "" : reporteSpeiEnviosBean.getCuentaOrd());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getInsReceptora() == null || reporteSpeiEnviosBean.getInsReceptora().equals("") ? "" : reporteSpeiEnviosBean.getInsReceptora());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getInsRemitente() == null || reporteSpeiEnviosBean.getInsRemitente().equals("") ? "" : reporteSpeiEnviosBean.getInsRemitente());

						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getConceptoPago() == null || reporteSpeiEnviosBean.getConceptoPago().equals("") ? "" : reporteSpeiEnviosBean.getConceptoPago());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Utileria.convierteDoble(reporteSpeiEnviosBean.getMontoTransferir()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Utileria.convierteDoble(reporteSpeiEnviosBean.getiVAPorPagar()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Utileria.convierteDoble(reporteSpeiEnviosBean.getiVAComision()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(Utileria.convierteDoble(reporteSpeiEnviosBean.getTotalCargoCuenta()));
						celda.setCellStyle(estiloFormatoDecimal);
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getTipoPago() == null || reporteSpeiEnviosBean.getTipoPago().equals("") ? "" : reporteSpeiEnviosBean.getTipoPago());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getEstatus() == null || reporteSpeiEnviosBean.getEstatus().equals("") ? "" : reporteSpeiEnviosBean.getEstatus());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getEstatusEnv() == null || reporteSpeiEnviosBean.getEstatusEnv().equals("") ? "" : reporteSpeiEnviosBean.getEstatusEnv());
						
						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getCausaDevol() == null || reporteSpeiEnviosBean.getCausaDevol().equals("") ? "" : reporteSpeiEnviosBean.getCausaDevol());

						celda=fila.createCell((short)numCelda++);
						celda.setCellValue(reporteSpeiEnviosBean.getFechaOperacion() == null || reporteSpeiEnviosBean.getFechaOperacion().equals("") ? "" : reporteSpeiEnviosBean.getFechaOperacion());
						estiloCentrado.setFont(fuente10);
						celda.setCellStyle(estiloCentradoNoNeg);
						
						i++;
					}
					
					i = i+2;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					celda=fila.createCell((short)1);
					celda.setCellValue(tamanioLista);	
					
					celda = fila.createCell((short)18);
					celda.setCellValue("Procedure:");
					celda.setCellStyle(estiloNeg8);
					celda=fila.createCell((short)19);
					celda.setCellValue("SPEIENVIOSSTPREP");

					for(int celd=0; celd<=numCelda+1; celd++){
						hoja.autoSizeColumn((short)celd);
					}

				}
				
				response.addHeader("Content-Disposition","inline; filename=ReporteSpeiEnvios.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return  listaSpeiEnvios;
	}
	
	public RepSpeiEnviosServicio getRepSpeiEnviosServicio() {
		return repSpeiEnviosServicio;
	}

	public void setRepSpeiEnviosServicio(RepSpeiEnviosServicio repSpeiEnviosServicio) {
		this.repSpeiEnviosServicio = repSpeiEnviosServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}