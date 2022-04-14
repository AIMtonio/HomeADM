package credito.reporte;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import com.itextpdf.text.Utilities;

import activos.bean.RepCatalogoActivosBean;

import credito.bean.CarCreditoSuspendidoBean;
import credito.servicio.CarCreditoSuspendidoServicio;

public class CarCreditoSuspReporteControlador extends AbstractCommandController {
	
	public static interface Enum_Con_TipoReporte{
		int ReportePDF = 1;
		int ReporteExcel = 2;
	}
	
	ParametrosSesionBean parametrosSesionBean;
	
	CarCreditoSuspendidoServicio carCreditoSuspendidoServicio = null;
	String successView = null;
	
	public CarCreditoSuspReporteControlador(){
		setCommandClass(CarCreditoSuspendidoBean.class);
		setCommandName("CarCreditoSuspendidoBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,
			  Object command, BindException errors)throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		CarCreditoSuspendidoBean carCreditoSuspendidoBean = (CarCreditoSuspendidoBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista = (request.getParameter("tipoLista"))!=null?Integer.parseInt(request.getParameter("tipoLista")):0;
		carCreditoSuspendidoBean.setNombreSucursal(request.getParameter("nombreSucursal"));
		carCreditoSuspendidoBean.setNombreProducto(request.getParameter("nombreProducto"));
		carCreditoSuspendidoBean.setUsuario(parametrosSesionBean.getClaveUsuario());
		
		String nombreReporte = "creditos/CreditosSuspendidos.prpt";
		
		switch (tipoReporte) {
			case Enum_Con_TipoReporte.ReportePDF:
				System.out.println("Metodo controlador:");
				ByteArrayOutputStream htmlString = carCreditoSuspendidoServicio.reporteCarCreditoSuspPDF(carCreditoSuspendidoBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=CreditosSuspendidos.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlString.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
				break;
			case Enum_Con_TipoReporte.ReporteExcel:
				List<CarCreditoSuspendidoBean>listaREporteExcel = reporteCreditoSuspendidoExcel(tipoLista, carCreditoSuspendidoBean, response);
				break;
				
			default:
				break;
		}
		
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Cartera Suspendida Por Defunción");
								
		return null;

	}
	
	public List<CarCreditoSuspendidoBean>reporteCreditoSuspendidoExcel(int tipoLista, CarCreditoSuspendidoBean carCreditoSuspendidoBean, HttpServletResponse response){
		List<CarCreditoSuspendidoBean> listaCreditoSuspBean = null;
		
		String nombreSucursal = carCreditoSuspendidoBean.getNombreSucursal();
		String nombreProducto = carCreditoSuspendidoBean.getNombreProducto();
		int sucursalId = Utileria.convierteEntero(carCreditoSuspendidoBean.getSucursalID());
		int productoCreditoId = Utileria.convierteEntero(carCreditoSuspendidoBean.getProductoCreditoID());
		
		listaCreditoSuspBean = carCreditoSuspendidoServicio.consultaReporteCreditoSusp(Enum_Con_TipoReporte.ReporteExcel, carCreditoSuspendidoBean, response);
		Calendar calendario = Calendar.getInstance();
		
		
		if(listaCreditoSuspBean !=null){
			try{
				XSSFWorkbook libro = new XSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				// Negrita 10 centrado
				XSSFFont centradoNegrita10 = libro.createFont();
				centradoNegrita10.setFontHeightInPoints((short)10);
				centradoNegrita10.setFontName("Negrita");
				centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
				estiloNegCentrado10.setFont(centradoNegrita10);
				estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				
				// Negrita 8 centrado
				XSSFFont centradoNegrita8= libro.createFont();
				centradoNegrita8.setFontHeightInPoints((short)8);
				centradoNegrita8.setFontName("Negrita");
				centradoNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				XSSFCellStyle estiloNegCentrado8 = libro.createCellStyle();
				estiloNegCentrado8.setFont(centradoNegrita8);
				estiloNegCentrado8.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
				estiloNegCentrado8.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
							
				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$ #,##0.00"));

				XSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("Créditos Suspendidos Por Defunción");
				XSSFRow fila= hoja.createRow(0);

				// Nombre Usuario
				XSSFCell celdaini = fila.createCell((short)1);
				celdaini = fila.createCell((short)17);
				celdaini.setCellValue("Usuario:");
				celdaini.setCellStyle(estiloNeg8);	
				celdaini = fila.createCell((short)18);
				celdaini.setCellValue(parametrosSesionBean.getClaveUsuario());
				
				// Descripcion del Reporte
				fila	= hoja.createRow(1);	
				
				// Fecha en que se genera el reporte
				XSSFCell celdafin = fila.createCell((short)2);
				celdafin = fila.createCell((short)17);
				celdafin.setCellValue("Fecha:");
				celdafin.setCellStyle(estiloNeg8);	
				celdafin = fila.createCell((short)18);
				String mes = "0";
				if((calendario.get(Calendar.MONTH)+1) > 9)
				{
					mes = String.valueOf(calendario.get(Calendar.MONTH)+1);
				}
				else
				{
					mes = "0" + String.valueOf(calendario.get(Calendar.MONTH)+1);
				}
				celdafin.setCellValue(calendario.get(Calendar.DAY_OF_MONTH) + "/" + mes + "/" + calendario.get(Calendar.YEAR));
				
				// Nombre Institucion
				XSSFCell celdaInst=fila.createCell((short)1);
				celdaInst=fila.createCell((short)1);
				celdaInst.setCellStyle(estiloNegCentrado10);
				celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //first row (0-based)
			            1, //last row  (0-based)
			            1, //first column (0-based)
			            13  //last column  (0-based)
			    )); 
				
				// Hora en que se genera el reporte
				fila = hoja.createRow(2);	
				XSSFCell celda=fila.createCell((short)1);
				celda = fila.createCell((short)17);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)18);
				
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
				
				XSSFCell celdaR=fila.createCell((short)2);
				celdaR	= fila.createCell((short)1);			
				celdaR.setCellStyle(estiloNegCentrado10);
				celdaR.setCellValue("REPORTE DE CRÉDITOS SUSPENDIDOS POR DEFUNCIÓN DEL " + carCreditoSuspendidoBean.getFechaInicio() + " AL " + carCreditoSuspendidoBean.getFechaFinal());
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //first row (0-based)
			            2, //last row  (0-based)
			            1, //first column (0-based)
			            13  //last column  (0-based)
			    ));
				
				// Encabezado del Reporte
				fila = hoja.createRow(3);	
				
				// Filtros
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)2);
				if(sucursalId == 0){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(nombreSucursal);
				}
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Producto Credito:");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)5);
				if(productoCreditoId == 0){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(nombreProducto);
				}
								
				fila = hoja.createRow(5);
				fila = hoja.createRow(6);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("ID Crédito");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("No. Cliente");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Producto Crédito");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Grupo");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Monto Original");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha Desembolso");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Suspensión");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha Defunción");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Folio Acta");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Detalle de la Suspensión");
				celda.setCellStyle(estiloNegCentrado8);
				hoja.addMergedRegion(new CellRangeAddress(
			            6, //first row (0-based)
			            6, //last row  (0-based)
			            11, //first column (0-based)
			            15  //last column  (0-based)
			    ));
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Detalle Recuperación");
				celda.setCellStyle(estiloNegCentrado8);
				hoja.addMergedRegion(new CellRangeAddress(
			            6, //first row (0-based)
			            6, //last row  (0-based)
			            16, //first column (0-based)
			            18  //last column  (0-based)
			    ));
				
				fila = hoja.createRow(7);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Capital");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Interés");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Moratorios");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Comisiones");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Notas de cargo");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Total");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Pagos Crédito");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("Condonaciones");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Por Recuperar");
				celda.setCellStyle(estiloNegCentrado8);
				
				int row = 9,iter=0;
				int tamanioLista = listaCreditoSuspBean.size();
				CarCreditoSuspendidoBean creditoSuspendidoBean = null;
				for(iter=0; iter<tamanioLista; iter ++){
					creditoSuspendidoBean = (CarCreditoSuspendidoBean) listaCreditoSuspBean.get(iter);
					
					fila = hoja.createRow(row);
					celda = fila.createCell((short)1);
					celda.setCellValue(creditoSuspendidoBean.getCreditoID());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(creditoSuspendidoBean.getClienteID());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(creditoSuspendidoBean.getNombreCliente());
					
					celda = fila.createCell((short)4);
					celda.setCellValue(creditoSuspendidoBean.getProductoCreditoDesc());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(creditoSuspendidoBean.getNombreGrupo());
					
					celda = fila.createCell((short)6);			
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getMontoOriginal().equals(null) || creditoSuspendidoBean.getMontoOriginal().equals("") ? "-" : creditoSuspendidoBean.getMontoOriginal()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)7);
					celda.setCellValue(creditoSuspendidoBean.getFechaDesembolso());
					
					celda = fila.createCell((short)8);
					celda.setCellValue(creditoSuspendidoBean.getFechaSuspencion());
					
					celda = fila.createCell((short)9);
					celda.setCellValue(creditoSuspendidoBean.getFechaDefuncion());
					
					celda = fila.createCell((short)10);
					celda.setCellValue(creditoSuspendidoBean.getFolioActa());
					
					celda = fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getTotalSalCapital().equals(null) || creditoSuspendidoBean.getTotalSalCapital().equals("") ? "-" : creditoSuspendidoBean.getTotalSalCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getTotalSalInteres().equals(null) || creditoSuspendidoBean.getTotalSalInteres().equals("") ? "-" : creditoSuspendidoBean.getTotalSalInteres()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getTotalSalMoratorio().equals(null) || creditoSuspendidoBean.getTotalSalMoratorio().equals("") ? "-" : creditoSuspendidoBean.getTotalSalMoratorio()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getTotalSalComisiones().equals(null) || creditoSuspendidoBean.getTotalSalComisiones().equals("") ? "-" : creditoSuspendidoBean.getTotalSalComisiones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getNotasCargo().equals(null) || creditoSuspendidoBean.getNotasCargo().equals("") ? "-" : creditoSuspendidoBean.getNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getTotalAdeudo().equals(null) || creditoSuspendidoBean.getTotalAdeudo().equals("") ? "-" : creditoSuspendidoBean.getTotalAdeudo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getPagos().equals(null) || creditoSuspendidoBean.getPagos().equals("") ? "-" : creditoSuspendidoBean.getPagos()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getCondonaciones().equals(null) || creditoSuspendidoBean.getCondonaciones().equals("") ? "-" : creditoSuspendidoBean.getCondonaciones()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(creditoSuspendidoBean.getRecuperar().equals(null) || creditoSuspendidoBean.getRecuperar().equals("") ? "-" : creditoSuspendidoBean.getRecuperar()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					row++;
				}
				
								
				int cellRegExp = 13 + tamanioLista;
				fila = hoja.createRow(cellRegExp);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNegCentrado8);
				fila = hoja.createRow(cellRegExp+1);
				celda = fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				
				
				for(int celd=0; celd<=18; celd++){
					hoja.autoSizeColumn((short)celd);
				}
				
				for(int celd=8; celd<=10; celd++){
					hoja.autoSizeColumn((short)celd);
				}				
				hoja.setColumnWidth(1, 20 * 256);	
				hoja.setColumnWidth(7, 25 * 256);					
				hoja.setColumnWidth(11, 25 * 256);					
				hoja.setColumnWidth(12, 25 * 256);					
				hoja.setColumnWidth(13, 25 * 256);
				
				//Se crea la cabecera
				response.addHeader("Content-Disposition","inline; filename=RepCreditosSuspendidos.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return listaCreditoSuspBean;
	}
	
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public CarCreditoSuspendidoServicio getCarCreditoSuspendidoServicio() {
		return carCreditoSuspendidoServicio;
	}
	public void setCarCreditoSuspendidoServicio(
			CarCreditoSuspendidoServicio carCreditoSuspendidoServicio) {
		this.carCreditoSuspendidoServicio = carCreditoSuspendidoServicio;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
}
