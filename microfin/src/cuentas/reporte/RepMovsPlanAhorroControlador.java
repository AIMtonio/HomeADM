package cuentas.reporte;

import general.bean.ParametrosSesionBean;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import java_cup.internal_error;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.TipoRespuestaCobBean;
import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.servicio.FoliosPlanAhorroServicio;
import cuentas.servicio.FoliosPlanAhorroServicio.Enum_Con_TipRepor;

public class RepMovsPlanAhorroControlador extends AbstractCommandController{

	FoliosPlanAhorroServicio repMovsPlanAhorroServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte = null;
	String successView = null;
	
	public RepMovsPlanAhorroControlador(){
		setCommandClass(FoliosPlanAhorroBean.class);
		setCommandName("foliosPlanAhorroMovs");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errores) throws Exception{
		
		FoliosPlanAhorroBean reportePlanAhorroBean = (FoliosPlanAhorroBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte")!=null) ? 
						Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		
		switch(tipoReporte){
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = reporteMovsPlanAhorroPDF(reportePlanAhorroBean,nombreReporte,response);
			break;
		case Enum_Con_TipRepor.reporteExcel :
			List<FoliosPlanAhorroBean> listaReportes = reporteMovsPlanAhorroExcel(tipoReporte,reportePlanAhorroBean,response);
			break;
		}
		
		return null;
	}

	public ByteArrayOutputStream reporteMovsPlanAhorroPDF(FoliosPlanAhorroBean reportePlanAhorroBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try{
			htmlStringPDF = repMovsPlanAhorroServicio.repPlanAhorroPDF(reportePlanAhorroBean,nombreReporte,parametrosSesionBean);
			response.addHeader("Content-Disposition","inline; filename=ReporteMovsPlanAhorro.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return htmlStringPDF ;
	}
	
	public List<FoliosPlanAhorroBean> reporteMovsPlanAhorroExcel(int tipoReporte, FoliosPlanAhorroBean repPlanAhorro, HttpServletResponse response){
		List<FoliosPlanAhorroBean> listaMovsPlanAhorro = null;

		listaMovsPlanAhorro = repMovsPlanAhorroServicio.reportesLista(tipoReporte,repPlanAhorro);
		
		Calendar calendario = Calendar.getInstance();
		
		String nomReporte = "Movs_Plan_Ahorro";
		
		if(listaMovsPlanAhorro!=null){
			try {
				Workbook libro = new SXSSFWorkbook();
				
				//Encabezado
				Font fuenteNegrita8Enc = libro.createFont();
				fuenteNegrita8Enc.setFontHeightInPoints((short)8);
				fuenteNegrita8Enc.setFontName("Negrita");
				fuenteNegrita8Enc.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita8 = libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuente10 = libro.createFont();
				fuente10.setFontHeightInPoints((short)10);
				
				CellStyle estilo10 = libro.createCellStyle();
				estilo10.setFont(fuente10);
				
				CellStyle estiloTitulo = libro.createCellStyle();
				estiloTitulo.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloTitulo.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloTitulo.setFont(fuenteNegrita8Enc);
				
				CellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setFont(fuenteNegrita8);
				
				CellStyle estiloFormatoMoneda = libro.createCellStyle();
				estiloFormatoMoneda.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				
				//Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("Reporte Movimientos Plan de Ahorro");
				
				Row fila = hoja.createRow(0);
				Cell celda = fila.createCell((short)10);
								
				celda.setCellValue("Usuario:");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue(parametrosSesionBean.getClaveUsuario());
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(0,0,11,11));
				
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(parametrosSesionBean.getNombreInstitucion());
				celda.setCellStyle(estiloTitulo);
				hoja.addMergedRegion(new CellRangeAddress(1,1,1,9));
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Fecha:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(1,1,10,10));
				
				celda = fila.createCell((short)11);
				celda.setCellValue(parametrosSesionBean.getFechaSucursal().toString());
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(1,1,10,10));
				
				
				fila = hoja.createRow(2);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Reporte de Movimientos de Plan de Ahorro");
				celda.setCellStyle(estiloTitulo);
				hoja.addMergedRegion(new CellRangeAddress(2,2,1,9));
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(2,2,10,10));
				
				celda = fila.createCell((short)11);
				String horaVar = "";
				int hora = calendario.get(Calendar.HOUR_OF_DAY);
				int minutos = calendario.get(Calendar.MINUTE);
				int segundos = calendario.get(Calendar.SECOND);
				String h = Integer.toString(hora);
				String m = "";
				String s = "";
				if(minutos<10) m = "0"+Integer.toString(minutos);else m = Integer.toString(minutos);
				if(segundos<10) s = "0"+Integer.toString(segundos);else s = Integer.toString(segundos);
				horaVar = h+":"+m+":"+s;
				celda.setCellValue(horaVar);
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(2,2,11,11));
				
				fila = hoja.createRow(3);
				
				
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Plan de Ahorro:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(4,4,0,1));
				
				celda = fila.createCell((short)2);
				if(repPlanAhorro.getPlanID().equals("0")){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(repPlanAhorro.getPlanID()+"-"+listaMovsPlanAhorro.get(0).getNombrePlan());
				}
				hoja.addMergedRegion(new CellRangeAddress(4,4,2,5));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(4,4,7,8));
				
				celda = fila.createCell((short)9);
				if(repPlanAhorro.getSucursal().equals("0")){
					celda.setCellValue("TODAS");
				}else{
					celda.setCellValue(parametrosSesionBean.getNombreSucursal());
				}				
				hoja.addMergedRegion(new CellRangeAddress(4,4,9,10));
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Cliente:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(5,5,0,1));
				
				celda = fila.createCell((short)2);
				if(repPlanAhorro.getClienteID().equals("0")){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(repPlanAhorro.getClienteID()+"-"+listaMovsPlanAhorro.get(0).getNombreCliente());
				}
				hoja.addMergedRegion(new CellRangeAddress(5,5,2,5));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Estatus:");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(5,5,7,8));
				
				celda = fila.createCell((short)9);
				if(repPlanAhorro.getEstatus().equals("")){
					celda.setCellValue("TODOS");
				}else{
					String estatus = listaMovsPlanAhorro.get(0).getEstatus();
					if(estatus.equals("A")){
						celda.setCellValue("Activo");
					}else if(estatus.equals("V")){
						celda.setCellValue("Vencido");
					}else if(estatus.equals("C")){
						celda.setCellValue("Cancelado");
					}
				}
				hoja.addMergedRegion(new CellRangeAddress(5,5,9,10));
				
				fila = hoja.createRow(6);
				
				
				fila = hoja.createRow(7);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Cliente");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,0,0));
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Nombre del Cliente");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,1,1));
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Cuenta");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,2,2));
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Tipo de Cuenta");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,3,3));
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,4,4));
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Plan de Ahorro");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,5,5));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Folio");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,6,6));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,7,7));
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,8,8));
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,9,9));
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Fecha Cancelación");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,10,10));
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Usuario Cancelación");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,11,11));
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Fecha Liberación");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(7,7,12,12));
				
				int rowExcel = 8;
				int tamanioLista = listaMovsPlanAhorro.size();
				if(tamanioLista>0){
					for(int cont = 0 ;cont < tamanioLista; cont++){
						fila = hoja.createRow(rowExcel);
						
						celda = fila.createCell((short)0);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getClienteID());
						
						celda = fila.createCell((short)1);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getNombreCliente());
						
						celda = fila.createCell((short)2);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getCuentaID());
						
						celda = fila.createCell((short)3);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getDescCuenta());
						
						celda = fila.createCell((short)4);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getSucursal());
						
						celda = fila.createCell((short)5);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getNombrePlan());
						
						celda = fila.createCell((short)6);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getSerie());
						
						celda = fila.createCell((short)7);
						String estatus = listaMovsPlanAhorro.get(cont).getEstatus();
						if(estatus.equals("A")){
							celda.setCellValue("Activo");
						}else if(estatus.equals("V")){
							celda.setCellValue("Vencido");
						}else if(estatus.equals("C")){
							celda.setCellValue("Cancelado");
						}
						
						celda = fila.createCell((short)8);
						celda.setCellValue("$"+listaMovsPlanAhorro.get(cont).getMonto());
						celda.setCellStyle(estiloFormatoMoneda);
						
						celda = fila.createCell((short)9);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getFecha());
						
						celda = fila.createCell((short)10);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getFechaCancela());
						
						celda = fila.createCell((short)11);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getUsuarioCancela());
						
						celda = fila.createCell((short)12);
						celda.setCellValue(listaMovsPlanAhorro.get(cont).getFechaMeta());
						
						rowExcel++;
					}
					
					fila = hoja.createRow(rowExcel+2);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(tamanioLista);
					celda.setCellStyle(estiloEncabezado);
				}
				
				response.addHeader("Content-Disposition","inline; filename="+nomReporte+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return listaMovsPlanAhorro;
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
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	public FoliosPlanAhorroServicio getRepMovsPlanAhorroServicio() {
		return repMovsPlanAhorroServicio;
	}
	public void setRepMovsPlanAhorroServicio(
			FoliosPlanAhorroServicio repMovsPlanAhorroServicio) {
		this.repMovsPlanAhorroServicio = repMovsPlanAhorroServicio;
	}
}
