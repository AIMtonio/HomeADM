package credito.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.format.BoldStyle;

import org.apache.batik.ext.awt.image.rendered.TileBlock;
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

import pld.bean.ReportesSITIBean;
import pld.reporte.ReporteSITIControlador.Enum_Con_TipRepor;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.AmortizacionCreditoServicio;
import credito.servicio.CreditosServicio;

public class RepAmortCredControlador extends AbstractCommandController{	
	private AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	private CreditosServicio creditosServicio = null;

	ParametrosSesionBean parametrosSesionBean;
	String nombreReporte = null;
	String successView = null;
	
	public RepAmortCredControlador(){
		setCommandClass(AmortizacionCreditoBean.class);
		setCommandName("amortizacionCreditoBean");
	}

	public static interface Enum_TipoReporte {
		int  AmorPagareCredito	= 2;
		int  AmorInfoCreditos	= 3;
	}
	
	public static interface Enum_TipoEstatus {
		char  Inactivo	= 'I';
		char  Vigente	= 'V';
		char  Pagado	= 'P';
		char  Cancelado	= 'C';
		char  Vencido	= 'B';
		char  Atrasado	= 'A';
	}
	
	public static interface Enum_TipoSuma {
		int  SumaCapital	= 1;
		int  SumaInteres	= 2;
		int  SumaIVAInteres	= 3;
		int	 SumaSeguro		= 4;
		int  SumaIVaSeguro	= 5;
		int  sumaComisiones	= 6;
		int  sumaIvaCom		= 7;
	}
	
	public static interface Enum_TipoPrepago{
		char  UltimCuotas	= 'U';
		char  CuotSigInme	= 'I';
		char  ProCuotVig	= 'V';
		char  Ninguno		= 'N';
	}
	
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AmortizacionCreditoBean amortizacionCreditoBean = (AmortizacionCreditoBean) command;
		
		List<AmortizacionCreditoBean>listaReportes = null;
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Utileria.convierteEntero(request.getParameter("tipoReporte")) : 0;
		int tipoConsulta = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;
		
		switch (tipoReporte) {
		case Enum_TipoReporte.AmorPagareCredito:
			listaReportes = reporteAmorPagareCreditoExcel(amortizacionCreditoBean, request, response,tipoConsulta);
			break;
		case Enum_TipoReporte.AmorInfoCreditos:
			listaReportes=reporteAmorInfoCreditoExcel(amortizacionCreditoBean, request, response,tipoConsulta);
			break;
		}
		return null;
	}
	

	private List<AmortizacionCreditoBean> reporteAmorInfoCreditoExcel(AmortizacionCreditoBean amortizacionCreditoBean, HttpServletRequest request, HttpServletResponse response, int tipoConsulta){
		List<AmortizacionCreditoBean> listaReporte= amortizacionCreditoServicio.listaGrid(tipoConsulta, amortizacionCreditoBean);
		String nombreReporteXLS = "AmortizacionesInfoCredito";
		String tituloReporte = "INFORMACIÓN DEL CRÉDITO";
		
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
		String hora = postFormater.format(calendario.getTime());
		
		if(listaReporte != null){
			try{
				XSSFSheet hoja 		= null;
				XSSFWorkbook libro	= null;
				short fuenteBold 	= XSSFFont.BOLDWEIGHT_BOLD;
				short fuenteNoBold	= XSSFFont.BOLDWEIGHT_NORMAL;
				short fuenteCen		= XSSFCellStyle.ALIGN_CENTER;
				short fuenteIzq		= XSSFCellStyle.ALIGN_LEFT;
				short fuenteDer		= XSSFCellStyle.ALIGN_RIGHT;
				libro = new XSSFWorkbook();
				
				int numRow = 0;
								
				// Creacion de hoja					
				hoja = libro.createSheet("Amortizaciones InfoCredito");
				
				XSSFRow fila= hoja.createRow(0); //Nuevo ROW
				XSSFCell celdaUsu= fila.createCell(9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				celdaUsu = fila.createCell(10);
				celdaUsu.setCellValue(parametrosSesionBean.getClaveUsuario().toUpperCase());
				
				fila = hoja.createRow(1); //ROW 1
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

				fila = hoja.createRow(2); // ROW 2
				XSSFCell celdaHora= fila.createCell(9);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));	
				celdaHora = fila.createCell(10);
				celdaHora.setCellValue(hora);
				
				XSSFCell celda=fila.createCell((short)1);
				celda.setCellValue(tituloReporte); 
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				hoja.addMergedRegion(new CellRangeAddress( 2, 2, 1, 8 ));	
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				//Seccion CONSULTA CREDITO
				numRow = numRow + 5;
				fila = hoja.createRow(numRow); //ROW 5
				XSSFCell celdaTitulo= fila.createCell(0);
				celdaTitulo.setCellValue("Consulta Crédito");
				celdaTitulo.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));	
				
				numRow = numRow + 2;
				fila = hoja.createRow(numRow); //ROW 7
				celda = fila.createCell(0);
				celda.setCellValue("Crédito:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(request.getParameter("creditoID"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue("Cliente:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(4);
				celda.setCellValue(request.getParameter("clienteID"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(5);
				hoja.addMergedRegion(new CellRangeAddress(7, 7, 5, 7));
				celda.setCellValue(request.getParameter("nombreCliente"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 8
				celda = fila.createCell(0);
				celda.setCellValue("Cuenta:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(request.getParameter("cuentaID"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue("Moneda:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(4);
				celda.setCellValue(request.getParameter("monedaID"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(5);
				celda.setCellValue(request.getParameter("monedaDes"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 9
				celda = fila.createCell(0);
				celda.setCellValue("Estatus:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(request.getParameter("estatus"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue("producto Crédito:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(4);
				celda.setCellValue(request.getParameter("producCreditoID"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
							
				celda = fila.createCell(5);
				hoja.addMergedRegion(new CellRangeAddress(9, 9, 5, 7));
				celda.setCellValue(request.getParameter("descripProducto"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 10
				celda = fila.createCell(0);
				celda.setCellValue("Días Falta Pago:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(request.getParameter("diasFaltaPago"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue("Tasa Fija:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(4);
				celda.setCellValue(request.getParameter("tasaFija"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(5);
				celda.setCellValue("%");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				if(!request.getParameter("grupoID").equals("")){
					numRow = numRow+1;
					fila = hoja.createRow(numRow); //ROW 11
					celda = fila.createCell(0);
					celda.setCellValue("Grupo:" );
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(1);
					celda.setCellValue(request.getParameter("grupoID"));
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
					
					celda = fila.createCell(3);
					celda.setCellValue("Ciclo:");
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(4);
					celda.setCellValue(request.getParameter("cicloID"));
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
					
					numRow = numRow+1;
					fila = hoja.createRow(numRow); //ROW 12
					celda = fila.createCell(1);
					hoja.addMergedRegion(new CellRangeAddress(12, 12, 1, 2 ));
					celda.setCellValue(request.getParameter("grupoDes"));
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				}
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 13
				celda = fila.createCell(0);
				celda.setCellValue("Tipo Prepago Capital:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));

				celda = fila.createCell(1);
				hoja.addMergedRegion(new CellRangeAddress(numRow, numRow, 1, 2 ));

				char opcion = (request.getParameter("tipoPrepagoTD").equals(""))? 'N' : request.getParameter("tipoPrepagoTD").charAt(0);
				switch (opcion){
				case Enum_TipoPrepago.UltimCuotas:
					celda.setCellValue("Últimas Cuotas");
					break;
				case Enum_TipoPrepago.CuotSigInme:
					celda.setCellValue("Cuotas Siguientes Inmediatas");
					break;
				case Enum_TipoPrepago.ProCuotVig:
					celda.setCellValue("Prorrateo Cuotas Vigentes");
					break;
				case Enum_TipoPrepago.Ninguno:
					celda.setCellValue("Ninguno");
					break;
				}
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue("Origen:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(4);
				celda.setCellValue(request.getParameter("origen"));
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 14
				celda = fila.createCell(0);
				celda.setCellValue("Cobra Seguro Cuota:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue((request.getParameter("cobraSeguroCuota").equals("N"))? "No" : "Si");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				//Seccion CONSULTA CREDITO
				numRow = numRow + 3;
				fila = hoja.createRow(numRow); //ROW 17
				celda = fila.createCell(0);
				celda.setCellValue("Saldo Crédito");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				numRow = numRow + 2;
				fila = hoja.createRow(numRow); //ROW 19
				celda = fila.createCell(0);
				celda.setCellValue("Tipo Pago: ");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue("[" + ((request.getParameter("totalAde").equals("true"))? "X" : "  ") + "] Total Adeudo");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("[" + ((request.getParameter("exigible").equals("true"))? "X" : "  ") + "] Pago Cuota");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				numRow = numRow + 2;
				if(request.getParameter("totalAde").equals("true")){ //Opcion Total Adeudo
					fila = hoja.createRow(numRow); //ROW 21
					celda = fila.createCell(0);
					celda.setCellValue("Total Adeudo:");
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(1);
					celda.setCellValue(Utileria.convierteDoble(request.getParameter("adeudoTotal").replace(",", "")));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}else{
					fila = hoja.createRow(numRow); //ROW 21
					celda = fila.createCell(0);
					celda.setCellValue("Total Pagar:");
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(1);
					celda.setCellValue(Utileria.convierteDoble(request.getParameter("pagoExigible").replace(",", "")));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda = fila.createCell(2);
					celda.setCellValue("Exigible al Día:");
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(3);
					celda.setCellValue(Utileria.convierteDoble(request.getParameter("exigibleAlDia").replace(",", "")));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda = fila.createCell(4);
					celda.setCellValue("Monto Proyectado:");
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
					
					celda = fila.createCell(5);
					celda.setCellValue(Utileria.convierteDoble(request.getParameter("montoProyectado").replace(",", "")));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}
				
				if(!request.getParameter("grupoID").equals("")){
					if(request.getParameter("totalAde").equals("true")){ 
						numRow = numRow+1;
						fila = hoja.createRow(numRow); //ROW 22
						celda = fila.createCell(0);
						celda.setCellValue("Total Adeudo Grupal:");
						celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
						
						celda = fila.createCell(1);
						celda.setCellValue(Utileria.convierteDoble(request.getParameter("montoTotDeudaPC").replace(",", "")));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					}else{
						numRow = numRow+1;
						fila = hoja.createRow(numRow); //ROW 22
						celda = fila.createCell(0);
						celda.setCellValue("Total Pagar Grupal:");
						celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
						
						celda = fila.createCell(1);
						celda.setCellValue(Utileria.convierteDoble(request.getParameter("montoTotExigiblePC").replace(",", "")));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						celda = fila.createCell(2);
						celda.setCellValue("Exigible al Día:");
						celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
						
						celda = fila.createCell(3);
						celda.setCellValue(Utileria.convierteDoble(request.getParameter("exigibleAlDiaG").replace(",", "")));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						celda = fila.createCell(4);
						celda.setCellValue("Monto Proyectado:");
						celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
						
						celda = fila.createCell(5);
						celda.setCellValue(Utileria.convierteDoble(request.getParameter("montoProyectadoG").replace(",", "")));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					}
				}
				
				numRow = numRow + 2;
				fila = hoja.createRow(numRow); //ROW 24
				celda = fila.createCell(0);
				celda.setCellValue("Capital");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
								
				celda = fila.createCell(4);
				celda.setCellValue("IVA Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(5);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIVAInteres").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Comisiones");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("IVA Comisiones");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 25
				celda = fila.createCell(0);
				celda.setCellValue("Vigente:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoCapVigent").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Ordinario:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoInterOrdin").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Falta Pago:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoComFaltPago").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("Falta Pago:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("salIVAComFalPag").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 26
				celda = fila.createCell(0);
				celda.setCellValue("Atrasado:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoCapAtrasad").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Atrasado:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoInterAtras").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(4);
				celda.setCellValue("Moratorio");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(5);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoMoratorios").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Otras:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoOtrasComis").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("Otras:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIVAComisi").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 27
				celda = fila.createCell(0);
				celda.setCellValue("Vencido:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoCapVencido").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Vencido:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoInterVenc").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(4);
				celda.setCellValue("IVA Moratorio");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(5);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIVAMorator").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Admon:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoAdmonComis").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("Admon:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIVAAdmonComisi").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 28
				celda = fila.createCell(0);
				celda.setCellValue("Vencido no Exigible:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldCapVenNoExi").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Provisión:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoInterProvi").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Seguro:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoSeguroCuota").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("IVA Seguro:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIVASeguroCuota").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 29
				celda = fila.createCell(0);
				celda.setCellValue("Total:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(1);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("totalCapital").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(2);
				celda.setCellValue("Cal.No Cont.:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoIntNoConta").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(6);
				celda.setCellValue("Anualidad:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoComAnual").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("Anualidad:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("saldoComAnualIVA").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 30
				celda = fila.createCell(6);
				celda.setCellValue("Total:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(7);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("totalComisi").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(8);
				celda.setCellValue("Total:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(9);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("totalIVACom").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				numRow = numRow+1;
				fila = hoja.createRow(numRow); //ROW 31
				celda = fila.createCell(2);
				celda.setCellValue("Total:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				celda = fila.createCell(3);
				celda.setCellValue(Utileria.convierteDoble(request.getParameter("totalInteres").replace(",", "")));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));

				//Seccion AMORTIZACIONES
				numRow = numRow + 3;
				fila = hoja.createRow(numRow); //ROW 34
				celda = fila.createCell(0);
				celda.setCellValue("Amortizaciones");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));
				
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				int numCelda = 0;
				numRow = numRow + 1;
				fila = hoja.createRow(numRow); //ROW 35
				
				celda = fila.createCell(numCelda++);	//1
				celda.setCellValue("Num");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//2
				celda.setCellValue("Fec.Inicio");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//3
				celda.setCellValue("Fec.Vencim");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//4
				celda.setCellValue("Fec.Exigible");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//5
				celda.setCellValue("Estatus");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//6
				celda.setCellValue("Capital");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//7
				celda.setCellValue("Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//8
				celda.setCellValue("IVA Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				if((request.getParameter("cobraSeguroCuota").equals("S"))){
					celda = fila.createCell(numCelda++);	//9
					celda.setCellValue("Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
					
					celda = fila.createCell(numCelda++);	//10
					celda.setCellValue("IVA Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));	
				}
				
				celda = fila.createCell(numCelda++);	//11
				celda.setCellValue("Mon.Cuota");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//12
				celda.setCellValue("Saldos");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
								
				celda = fila.createCell(numCelda++);	//13
				celda.setCellValue("Cap.Vigente");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//14
				celda.setCellValue("Cap.Atrasado");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//15
				celda.setCellValue("Cap.Vencido");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//16
				celda.setCellValue("Cap.VenNoExi");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//17
				celda.setCellValue("Int.Provisión");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//18
				celda.setCellValue("Int.Atrasado");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//19
				celda.setCellValue("Int.Vencido");	
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//20
				celda.setCellValue("Int.NoCont");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//21
				celda.setCellValue("IVA Int");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//22
				celda.setCellValue("Moratorio");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//23
				celda.setCellValue("IVA Mora");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//24
				celda.setCellValue("Falta Pago");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//25
				celda.setCellValue("IVA");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//26
				celda.setCellValue("OtrasCom");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//27
				celda.setCellValue("IVA");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				// Nota Cargo
				celda = fila.createCell(numCelda++);	//28
				celda.setCellValue("NotasCargo");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);	//29
				celda.setCellValue("IVA");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				if((request.getParameter("cobraSeguroCuota").equals("S"))){
					celda = fila.createCell(numCelda++);	//30
					celda.setCellValue("Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
					
					celda = fila.createCell(numCelda++);	//31
					celda.setCellValue("IVA Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				}
				
				celda = fila.createCell(numCelda++);	//32
				celda.setCellValue("Tot.Cuota");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				for (int celd = 0; celd <= 12; celd++){
					hoja.autoSizeColumn(celd, true);
				}
								
				int tamanioLista=listaReporte.size();
				int i=numRow+1;
				
				AmortizacionCreditoBean amortiCredBean = null;
				
				for(int iter=0; iter<tamanioLista; iter++){
					amortiCredBean = (AmortizacionCreditoBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila=hoja.createRow(i);
					
					//1 Num;
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getAmortizacionID());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					//2 Fec.Inicio
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaInicio());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
		
					//3 Fec.Vencim
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaVencim());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					//4 Fec.Exigible
					celda=fila.createCell(numCelda++);
					celda.setCellValue(amortiCredBean.getFechaExigible());
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteNoBold));
					
					//5 Estatus
					celda=fila.createCell(numCelda++);
					celda.setCellValue(tipoEstatus(amortiCredBean.getEstatus().charAt(0)));
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
					
					//6 Capital
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getCapital()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//7 Interés
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getInteres()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//8 IVA Interés
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getIvaInteres()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					if((request.getParameter("cobraSeguroCuota").equals("S"))){
						//9 Seguro
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoSeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						//10 IVA Seguro	
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getiVASeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					}
					
					//11 Mon.Cuota
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoCuota()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//12 Saldos
					celda=fila.createCell(numCelda++);
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//13 Cap.Vigente
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapVigente()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//14 Cap.Atrasado
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapAtrasado()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//15 Cap.Vencido
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapVencido()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//16 Cap.VenNoExi
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapVNE()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//17 Int.Provisión
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIntProvisionado()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//18 Int.Atrasado
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIntAtrasado()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//19 Int.Vencido	
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIntVencido()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//20 Int.NoCont
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIntCalNoCont()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//21 IVA Int
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVAInteres()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//22 Moratorio
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoMoratorios()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//23 IVA Mora
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVAMora()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//24 Falta Pago;
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoComFaltaPago()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//25 IVA
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVAComFaltaPago()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//26 OtrasCom
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoOtrasComisiones()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//27 IVA
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVAOtrasCom()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));

					//28 Nota Cargo
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoNotasCargo()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					//29 IVA Nota Cargo
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getMontoIvaNotaCargo()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					if((request.getParameter("cobraSeguroCuota").equals("S"))){
						//30 Seguro
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoSeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
						
						//31 IVA Seguro
						celda=fila.createCell(numCelda++);
						celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVASeguroCuota()));
						celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					}
					
					//32 Tot.Cuota
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getTotalPago()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					i++;
				}
				
				numCelda = 4;
				fila=hoja.createRow(i);				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue("Totales: ");
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
					celda = fila.createCell(numCelda++);				
					celda.setCellValue(sumarColumna(listaReporte, 4));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda = fila.createCell(numCelda++);				
					celda.setCellValue(sumarColumna(listaReporte, 5));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}
				
				for (int celd = 0; celd <= i; celd++){
					hoja.autoSizeColumn(celd, true);
				}
				
				i = i+1;
				fila=hoja.createRow(i);				
				celda = fila.createCell((short)0);				
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));

				i = i+1;
				fila=hoja.createRow(i);		
				celda = fila.createCell((short)0);
				celda.setCellValue(listaReporte.size());
				celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));		
												
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
	
		
	private List<AmortizacionCreditoBean> reporteAmorPagareCreditoExcel(AmortizacionCreditoBean amortizacionCreditoBean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<AmortizacionCreditoBean> listaReporte= amortizacionCreditoServicio.listaGrid(tipoReporte, amortizacionCreditoBean);
		Calendar calendario = new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");	
		String hora = postFormater.format(calendario.getTime());
		String nombreReporteXLS = "AmortizacionesPagareCredito";
		String tituloReporte = "TABLA DE AMORTIZACIONES DEL PAGARÉ DE CRÉDITO";
		
		if(listaReporte != null){
			try{
				XSSFSheet hoja = null;
				XSSFWorkbook libro=null;
				short fuenteBold 	= XSSFFont.BOLDWEIGHT_BOLD;
				short fuenteNoBold	= XSSFFont.BOLDWEIGHT_NORMAL;
				short fuenteCen		= XSSFCellStyle.ALIGN_CENTER;
				short fuenteIzq		= XSSFCellStyle.ALIGN_LEFT;
				short fuenteDer 	= XSSFCellStyle.ALIGN_RIGHT;
				libro = new XSSFWorkbook();
								
				// Creacion de hoja					
				hoja = libro.createSheet("Amortizaciones PagareCredito");
				
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
				
				
				fila = hoja.createRow(4);
				XSSFCell celdaTitulo= fila.createCell(0);
				celdaTitulo.setCellValue("Amortizaciones");
				celdaTitulo.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteBold));	
				
				fila = hoja.createRow(5);
				
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				int numCelda = 0;
				celda = fila.createCell(numCelda);
				hoja.addMergedRegion(new CellRangeAddress(5,5,numCelda,numCelda));

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
				celda.setCellValue("Fecha Exigible");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Estatus");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Capital");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Interés");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				if((request.getParameter("cobraSeguroCuota").equals("S"))){
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("IVA Seguro");
					celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));	
				}
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Otras Comisiones");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Otras Comisiones");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Total Pago");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Capital");
				celda.setCellStyle(crearFuente(libro, 10, fuenteCen, fuenteBold));
				
				for (int celd = 0; celd <= 12; celd++){
					hoja.autoSizeColumn(celd, true);
				}
				
				int tamanioLista=listaReporte.size();
				int i=6;
				
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
					celda.setCellValue(tipoEstatus(amortiCredBean.getEstatus().charAt(0)));
					celda.setCellStyle(crearFuente(libro, 10, fuenteIzq, fuenteNoBold));
					
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
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoOtrasComisiones()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoIVAOtrasCom()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getTotalPago()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda=fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(amortiCredBean.getSaldoCapital()));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					i++;
				}
				
				numCelda = 4;
				fila=hoja.createRow(i);				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue("Totales: ");
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
					celda = fila.createCell(numCelda++);				
					celda.setCellValue(sumarColumna(listaReporte, 4));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
					
					celda = fila.createCell(numCelda++);				
					celda.setCellValue(sumarColumna(listaReporte, 5));
					celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				}
				celda = fila.createCell(numCelda++);				
				celda.setCellValue(sumarColumna(listaReporte, 6)); 
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
				
				celda = fila.createCell(numCelda++);				
				celda.setCellValue(sumarColumna(listaReporte, 7));
				celda.setCellStyle(fuenteFormatoDecimal(libro, 10, fuenteNoBold));
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
				
								
				for (int celd = 0; celd <= 12; celd++){
					hoja.autoSizeColumn(celd, true);
				}
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
	
	private String tipoEstatus(char tipoEstatus){
		String estatus = "";
		switch (tipoEstatus) {
		case Enum_TipoEstatus.Inactivo:
			estatus = "INACTIVA";
			break;
		case Enum_TipoEstatus.Vigente:
			estatus = "VIGENTE";
			break;
		case Enum_TipoEstatus.Pagado:
			estatus = "PAGADA";
			break;
		case Enum_TipoEstatus.Vencido:
			estatus = "VENCIDO";
			break;
		case Enum_TipoEstatus.Cancelado:
			estatus = "CANCELADA";
			break;
		case Enum_TipoEstatus.Atrasado:
			estatus = "ATRASADA";
			break;
		}
		return estatus;
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
				suma = suma + Utileria.convierteDoble(amortiCredBean.getSaldoOtrasComisiones());
				break;
			case Enum_TipoSuma.sumaIvaCom:
				suma = suma + Utileria.convierteDoble(amortiCredBean.getSaldoIVAOtrasCom());
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
	
	public AmortizacionCreditoServicio getAmortizacionCreditoServicio() {
		return amortizacionCreditoServicio;
	}

	public void setAmortizacionCreditoServicio(
			AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
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
