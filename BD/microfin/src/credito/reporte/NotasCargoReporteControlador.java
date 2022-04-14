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

import credito.bean.NotasCargoBean;
import credito.bean.NotasCargoRepBean;
import credito.servicio.NotasCargoServicio;


public class NotasCargoReporteControlador extends AbstractCommandController {
	
	public static interface Enum_Con_TipoReporte{
		int ReportePDF = 1;
		int ReporteExcel = 2;
	}
	
	ParametrosSesionBean parametrosSesionBean;
	NotasCargoServicio notasCargoServicio = null;
	String successView = null;

	private Object resultSet;
	
	public NotasCargoReporteControlador(){
		setCommandClass(NotasCargoBean.class);
		setCommandName("NotasCargoBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,
			  Object command, BindException errors)throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		NotasCargoBean notasCargoRepBean = (NotasCargoBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista = (request.getParameter("tipoLista"))!=null?Integer.parseInt(request.getParameter("tipoLista")):0;
		
		switch (tipoReporte) {
			case Enum_Con_TipoReporte.ReportePDF:
				System.out.println("Metodo controlador:");
				
			case Enum_Con_TipoReporte.ReporteExcel:
				List<NotasCargoRepBean>listaReporteExcel = reporteNotasCargoExcel(tipoLista, notasCargoRepBean, response);
				break;
				
			default:
				break;
		}
		
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Cartera Suspendida Por Defunción");
								
		return null;

	}
	
	public List<NotasCargoRepBean>reporteNotasCargoExcel(int tipoLista, NotasCargoBean notasCargoRepBean, HttpServletResponse response){
		
		List<NotasCargoRepBean> listaNotasCargoRepBean = null;
		
		String nombreProducto = notasCargoRepBean.getProductoCredito();
		int productoCreditoId = Utileria.convierteEntero(notasCargoRepBean.getProductoCreditoID());
		String institucionNomina = notasCargoRepBean.getInstitucionNomina();
		int institucionNominaID = Utileria.convierteEntero(notasCargoRepBean.getInstitucionNominaID());
		String convenioNomina = notasCargoRepBean.getConvenioNomina();
		int convenioNominaID = Utileria.convierteEntero(notasCargoRepBean.getConvenioNominaID());
		
		listaNotasCargoRepBean = notasCargoServicio.consultaReporteNotasCargo(Enum_Con_TipoReporte.ReporteExcel, notasCargoRepBean, response);
		Calendar calendario = Calendar.getInstance();
		
		
		if(listaNotasCargoRepBean !=null){
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
				XSSFSheet hoja = libro.createSheet("Notas de Cargo");
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
				celdaR.setCellValue("REPORTE DE NOTAS DE CARGO DEL " + notasCargoRepBean.getFechaInicio() + " AL " + notasCargoRepBean.getFechaFin());
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
				celda.setCellValue("Producto Credito:");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)2);
				if(productoCreditoId == 0){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(nombreProducto);
				}
				
				
				/*if("S".equals(castigosCarteraBean.getEsproducNomina())){
					celda = fila.createCell((short)4);
					celda.setCellValue("Institución Nómina:");
					celda.setCellStyle(estiloNeg8);	
					celda = fila.createCell((short)5);
					celda.setCellValue((!castigosCarteraBean.getNombreInstit().equals("")? castigosCarteraBean.getNombreInstit():"TODAS"));
					if("S".equals(castigosCarteraBean.getManejaConvenio()))
					{
						celda = fila.createCell((short)7);
						celda.setCellValue("Convenio Nómina:");
						celda.setCellStyle(estiloNeg8);	
						celda = fila.createCell((short)8);
						celda.setCellValue((!castigosCarteraBean.getDesConvenio().equals("")? castigosCarteraBean.getDesConvenio():"TODOS"));
					}
				
				}*/
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Institucion Nomina:");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)5);
				if(institucionNominaID == 0){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(institucionNomina);
				}
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Convenio Nomina:");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)9);
				if(convenioNominaID == 0){
					celda.setCellValue("TODOS");
				}else{
					celda.setCellValue(convenioNomina);
				}
								
				fila = hoja.createRow(5);
				fila = hoja.createRow(6);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Detalle Pago");
				celda.setCellStyle(estiloNegCentrado8);
				
				fila = hoja.createRow(7);

				celda = fila.createCell((short)1);
				celda.setCellValue("Producto de Crédito");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Institución de Nómina");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Convenio de Nómina");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("No. Cliente");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("No. Crédito");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("No. Amortización");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Tipo Nota Cargo");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("IVA");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Motivo");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Amortizacion");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Referencia");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Capital");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Interes");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("IVA Interes");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Moratorio");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("IVA Moratorio");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("Otras Comisiones");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("IVA Otras Comisiones");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("Total");
				celda.setCellStyle(estiloNegCentrado8);
				
				celda = fila.createCell((short)24);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNegCentrado8);
				
				int row = 9,iter=0;
				int tamanioLista = listaNotasCargoRepBean.size();
				NotasCargoRepBean notasCargoBean = null;
				for(iter=0; iter<tamanioLista; iter ++){
					notasCargoBean = (NotasCargoRepBean) listaNotasCargoRepBean.get(iter);
					
					fila = hoja.createRow(row);
					celda = fila.createCell((short)1);
					celda.setCellValue(notasCargoBean.getProductoCredito());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(notasCargoBean.getInstitucionNomina());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(notasCargoBean.getConvenioNomina());
					
					celda = fila.createCell((short)4);
					celda.setCellValue(notasCargoBean.getClienteID());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(notasCargoBean.getNombreCliente());
					
					celda = fila.createCell((short)6);
					celda.setCellValue(notasCargoBean.getCreditoID());
					
					celda = fila.createCell((short)7);
					celda.setCellValue(notasCargoBean.getAmortizacionID());
					
					celda = fila.createCell((short)8);
					celda.setCellValue(notasCargoBean.getReferencia());
					
					celda = fila.createCell((short)9);
					celda.setCellValue(notasCargoBean.getFechaRegistro()); 
					
					celda = fila.createCell((short)10);
					celda.setCellValue(notasCargoBean.getTipoNotaCargo());
					
					celda = fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getMonto().equals(null) || notasCargoBean.getMonto().equals("") ? "-" : notasCargoBean.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getIva().equals(null) || notasCargoBean.getIva().equals("") ? "-" : notasCargoBean.getIva()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda = fila.createCell((short)13);
					celda.setCellValue(notasCargoBean.getMotivo());
					
					if (Utileria.convierteEntero(notasCargoBean.getAmPagoNoReconoID()) > Constantes.ENTERO_CERO) {
						
						celda = fila.createCell((short)14);
						celda.setCellValue(notasCargoBean.getAmPagoNoReconoID());
						
						celda = fila.createCell((short)15);
						celda.setCellValue(notasCargoBean.getReferenciaNoRecono());
						
						celda = fila.createCell((short)16);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getCapital().equals(null) || notasCargoBean.getCapital().equals("") ? "-" : notasCargoBean.getCapital()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)17);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getInteres().equals(null) || notasCargoBean.getInteres().equals("") ? "-" : notasCargoBean.getInteres()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)18);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getIvaInteres().equals(null) || notasCargoBean.getIvaInteres().equals("") ? "-" : notasCargoBean.getIvaInteres()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)19);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getMoratorio().equals(null) || notasCargoBean.getMoratorio().equals("") ? "-" : notasCargoBean.getMoratorio()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)20);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getIvaMoratorio().equals(null) || notasCargoBean.getIvaMoratorio().equals("") ? "-" : notasCargoBean.getIvaMoratorio()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)21);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getIvaOtrasComisiones().equals(null) || notasCargoBean.getIvaOtrasComisiones().equals("") ? "-" : notasCargoBean.getIvaOtrasComisiones()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)22);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getIvaOtrasComisiones().equals(null) || notasCargoBean.getIvaOtrasComisiones().equals("") ? "-" : notasCargoBean.getIvaOtrasComisiones()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)23);
						celda.setCellValue(Utileria.convierteDoble(notasCargoBean.getTotalPago().equals(null) || notasCargoBean.getTotalPago().equals("") ? "-" : notasCargoBean.getTotalPago()));
						celda.setCellStyle(estiloFormatoDecimal);

						celda = fila.createCell((short)24);
						celda.setCellValue(notasCargoBean.getEstatus());
						
					}

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
				response.addHeader("Content-Disposition","inline; filename=ReporteNotasCargo.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		return listaNotasCargoRepBean;
	}
		
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public NotasCargoServicio getNotasCargoServicio() {
		return notasCargoServicio;
	}
	
	public void setNotasCargoServicio(NotasCargoServicio notasCargoServicio) {
		this.notasCargoServicio = notasCargoServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
