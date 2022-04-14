package originacion.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ReporteConsolidacionBean;
import originacion.servicio.ReporteConsolidacionSerivicio;
import reporte.ParametrosReporte;
import reporte.Reporte;

@SuppressWarnings("deprecation")
public class ReporteConsolidacionControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	ReporteConsolidacionSerivicio reporteConsolidacionSerivicio = null;	
	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte = null;
	String successView = null;
	
	public ReporteConsolidacionControlador(){
		setCommandClass(ReporteConsolidacionBean.class);
		setCommandName("reporteConsolidacionBean");
	}

	public static interface Enum_Con_TipRepor {
		int  ReporPDF = 1 ;
		int ReporteExcel = 2;
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors) throws Exception {	
		
		ReporteConsolidacionBean reporteConsolidacionBean =(ReporteConsolidacionBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = ConsolidacionesRepPDF(reporteConsolidacionBean, nombreReporte,response);
			break;
			case Enum_Con_TipRepor.ReporteExcel:
				List htmlStringExcel = ConsolidacionesRepExcel(reporteConsolidacionBean,response);
			break;
		}
		return null;
	}
	
	private ByteArrayOutputStream ConsolidacionesRepPDF(ReporteConsolidacionBean reporteConsolidacionBean, String nombreReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try{
			htmlStringPDF = reporteConsolidacionSerivicio.repConsolidacionesPDF(reporteConsolidacionBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ConsolidacionesRep.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}
	
	@SuppressWarnings("rawtypes")
	public List  ConsolidacionesRepExcel(ReporteConsolidacionBean reporteConsolidacionBean,  HttpServletResponse response){
		List listaConsolidacionesRepExcel=null;
		listaConsolidacionesRepExcel = reporteConsolidacionSerivicio.listaReporteConsolidaciones(reporteConsolidacionBean); 	
	
		try {
		HSSFWorkbook libro = new HSSFWorkbook();
		HSSFFont fuenteNegrita10= libro.createFont();
		fuenteNegrita10.setFontHeightInPoints((short)10);
		fuenteNegrita10.setFontName("Negrita");
		fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);		

		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)8);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
		estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
		
		HSSFCellStyle estiloCentrado = libro.createCellStyle();			
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		estiloCentrado.setFont(fuenteNegrita10);
		
		HSSFCellStyle estiloCentrado2 = libro.createCellStyle();			
		estiloCentrado2.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		
		HSSFCellStyle estiloColor = libro.createCellStyle();
		estiloColor.setFont(fuenteNegrita8);
		estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
		estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
		HSSFDataFormat format = libro.createDataFormat();
		estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
						
		HSSFSheet hoja = libro.createSheet("Reporte Consolidaciones");
		HSSFRow fila= hoja.createRow(0);

		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)11);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)12);
		
		celdaUsu.setCellValue(reporteConsolidacionBean.getClaveUsuario());
		Calendar calendario = Calendar.getInstance();
		int hora=calendario.get(Calendar.HOUR_OF_DAY);
		String horaVar=hora+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);
			
		HSSFCell celdaInst=fila.createCell((short)1);
		celdaInst.setCellValue(reporteConsolidacionBean.getNombreInstitucion());
		hoja.addMergedRegion(new CellRangeAddress(0, 0, 1, 10));	
		celdaInst.setCellStyle(estiloCentrado);

		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);

		celdaFec = fila.createCell((short)11);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)12);
		celdaFec.setCellValue(reporteConsolidacionBean.getFechaSistema());
		
		HSSFCell celdaNombreReporte=fila.createCell((short)1);
		celdaNombreReporte.setCellValue("Reporte de Consolidaciones del "+reporteConsolidacionBean.getFechaInicial()+" al "+reporteConsolidacionBean.getFechaFinal());

		hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 10));

		celdaNombreReporte.setCellStyle(estiloCentrado);	
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)11);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)12);
		celdaHora.setCellValue(horaVar);
		
		HSSFCell celda=fila.createCell((short)1);					


		fila = hoja.createRow(3); 
		fila = hoja.createRow(4);
		celda = fila.createCell((short)1);
		celda.setCellValue("Fecha Inicial");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue(reporteConsolidacionBean.getFechaInicial());
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Fecha Final:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)4);
		celda.setCellValue(reporteConsolidacionBean.getFechaFinal());
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Sucursal:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)6);
		celda.setCellValue((!reporteConsolidacionBean.getSucursalID().equals(""))?reporteConsolidacionBean.getSucursalID()+"-"+reporteConsolidacionBean.getNombreSucursal():"TODAS");
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Producto Crédito:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)8);
		celda.setCellValue((!reporteConsolidacionBean.getProductoCredito().equals(""))?reporteConsolidacionBean.getProductoCredito()+"-"+reporteConsolidacionBean.getNombreProductoCredito():"TODOS");
		
		fila = hoja.createRow(6);
		fila = hoja.createRow(7);		

		celda = fila.createCell((short)1);
		celda.setCellValue(Utileria.generaLocale(Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		 
		celda = fila.createCell((short)2);
		celda.setCellValue("Nombre "+ Utileria.generaLocale(Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Crédito Origen");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Crédito Destino");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Producto Crédito (Crédito Destino)");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)6);
		celda.setCellValue("Fecha Consolidación)");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Estatus Inicial");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Estatus Actual");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Monto Original");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
				
		celda = fila.createCell((short)10);
		celda.setCellValue("Pagos Sostenidos Realizados");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)11);
		celda.setCellValue("Saldo Total Capital");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)12);
		celda.setCellValue("Saldo Interés Total");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)13);
		celda.setCellValue("Saldo Moratorio Total");
		celda.setCellStyle(estiloNeg8);
		celda.setCellStyle(estiloCentrado);

		int tamanioLista = listaConsolidacionesRepExcel.size();
		int row=8;
		ReporteConsolidacionBean reporteConsolidacion;
				
		for(int iter=0; iter<tamanioLista; iter ++){					
			reporteConsolidacion = (ReporteConsolidacionBean) listaConsolidacionesRepExcel.get(iter);
			
			fila=hoja.createRow(row);
			
			celda=fila.createCell((short)1);
			celda.setCellValue(reporteConsolidacion.getClienteID());
			celda.setCellStyle(estiloCentrado2);
			
			celda=fila.createCell((short)2);
			celda.setCellValue(reporteConsolidacion.getNombreCompleto());
			
			celda=fila.createCell((short)3); 
			celda.setCellValue(reporteConsolidacion.getCreditoOrigenID());
			
			celda=fila.createCell((short)4); 
			celda.setCellValue(reporteConsolidacion.getCreditoDestinoID());
								
			celda=fila.createCell((short)5);
			celda.setCellValue(reporteConsolidacion.getProductoDestino());
			
			celda=fila.createCell((short)6);
			celda.setCellValue(reporteConsolidacion.getFechaConsolidacion());

			celda=fila.createCell((short)7);
			celda.setCellValue(reporteConsolidacion.getEstatusInicial());
			
			celda=fila.createCell((short)8);
			celda.setCellValue(reporteConsolidacion.getEstatusCredito());
			
			celda=fila.createCell((short)9);
			celda.setCellValue(Utileria.convierteDoble(reporteConsolidacion.getMontoOriginal()));
			celda.setCellStyle(estiloFormatoDecimal);	
			
			celda=fila.createCell((short)10);
			celda.setCellValue(reporteConsolidacion.getPagoSostenido());
			celda.setCellStyle(estiloCentrado2);
			
			celda=fila.createCell((short)11);
			celda.setCellValue(reporteConsolidacion.getSaldoTotalCapital());
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)12);
			celda.setCellValue(reporteConsolidacion.getSaldoInteresTotal());
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)13);
			celda.setCellValue(reporteConsolidacion.getSaldoMoratorioTotal());
			celda.setCellStyle(estiloFormatoDecimal);
				
			row++;
		}
		
		row = row+2;
		fila=hoja.createRow(row);
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		row = row+1;
		fila=hoja.createRow(row);
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		
		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);

		response.addHeader("Content-Disposition","inline; filename=Reporte_ConsolidacionesCredito.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		}catch(Exception e){
			e.printStackTrace();
		}
		return  listaConsolidacionesRepExcel;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ReporteConsolidacionSerivicio getReporteConsolidacionSerivicio() {
		return reporteConsolidacionSerivicio;
	}

	public void setReporteConsolidacionSerivicio(
			ReporteConsolidacionSerivicio reporteConsolidacionSerivicio) {
		this.reporteConsolidacionSerivicio = reporteConsolidacionSerivicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
