package fondeador.reporte;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import credito.bean.CreditosBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.bean.RepAnaliticoCarteraPasBean;
import fondeador.servicio.CreditoFondeoServicio;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

public class RepAnaCarteraPasControlador extends AbstractCommandController {
	CreditoFondeoServicio	creditoFondeoServicio	= null;
	String					successView				= null;
	ParametrosSesionBean	parametrosSesionBean	= null;
	
	public static interface Enum_Con_TipRepor {
		int	ReporExcel	= 3;
	}
	public RepAnaCarteraPasControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditoFondeoBean creditosBean = (CreditoFondeoBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		String htmlString = "";
		
		switch (tipoReporte) {
		
			case Enum_Con_TipRepor.ReporExcel :
				List listaReportes = proxVencimientosExcel(tipoLista, creditosBean, response);
				break;
		}
		
		if (tipoReporte == CreditosBean.ReporPantalla) {
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		} else {
			return null;
		}
		
	}
	
	// Reporte de saldos capital de credito en excel
	public List proxVencimientosExcel(int tipoLista, CreditoFondeoBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		//List listaCreditos = null;
		listaCreditos = creditoFondeoServicio.listaReportesCreditos(tipoLista, creditosBean, response);
		Map<String, Double> totaSaldCapVig = new HashMap<String, Double>();
		Map<String, Double> totaSaldCapAtr = new HashMap<String, Double>();
		Map<String, Double> totaSaldIntVig = new HashMap<String, Double>();
		Map<String, Double> totaSaldIntAtr = new HashMap<String, Double>();
		Map<String, Double> totaSaldoMora = new HashMap<String, Double>();
		Map<String, Double> totaSaldComPag = new HashMap<String, Double>();
		Map<String, Double> totaSaldOtrCom = new HashMap<String, Double>();
		try {
			String safilocale = "safilocale.cliente";
			safilocale = Utileria.generaLocale(safilocale, parametrosSesionBean.getNomCortoInstitucion());
			boolean mostrarAgro = false;
			if (listaCreditos.size() > 0) {
				RepAnaliticoCarteraPasBean cre = (RepAnaliticoCarteraPasBean) listaCreditos.get(0);
				mostrarAgro = cre.getManejaCarteraAgro().equals("S");
			}
			
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			//Estilo Decima con negritas para los totales
			HSSFCellStyle estiloFormatoDecimalNegrita = libro.createCellStyle();
			HSSFDataFormat format2 = libro.createDataFormat();
			estiloFormatoDecimalNegrita.setDataFormat(format2.getFormat("$#,##0.00"));
			estiloFormatoDecimalNegrita.setFont(fuenteNegrita8);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Reporte Analítico Cartera Pasiva");
			HSSFRow fila = hoja.createRow(0);
			
			fila = hoja.createRow(1);
			
			HSSFCell celda = fila.createCell((short) 3);
			celda.setCellStyle(estiloNeg10);
			celda.setCellValue("REPORTE ANALÍTICO DE CARTERA PASIVA AL DÍA " + creditosBean.getFechaACP());
			celda.setCellStyle(estiloDatosCentrado);
			celda.setCellStyle(estiloNeg8);
		
			celda = fila.createCell((short) 28);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short) 29);
			celda.setCellValue(creditosBean.getUsuario());
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			3, //primer celda (0-based)
			10 //ultima celda   (0-based)
			));
			
			fila = hoja.createRow(2);
			
			celda = fila.createCell((short) 28);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short) 29);
			celda.setCellValue(creditosBean.getParFechaEmision());
			
			fila = hoja.createRow(3);
			celda = fila.createCell((short) 1);
			celda.setCellValue("Institución Fondeo:");
			celda.setCellStyle(estiloNeg8);
			celda = fila.createCell((short) 2);
			celda.setCellValue((!creditosBean.getNombreInstitFon().isEmpty()) ? creditosBean.getNombreInstitFon() : "TODOS");
			
			String horaVar = "";
			
			int itera = 0;
			RepAnaliticoCarteraPasBean creditoHora = null;
			if (!listaCreditos.isEmpty()) {
				for (itera = 0; itera < 1; itera++) {
					creditoHora = (RepAnaliticoCarteraPasBean) listaCreditos.get(itera);
					horaVar = creditoHora.getHoraEmision();
				}
			}
			
			HSSFCell celdaHora = fila.createCell((short) 28);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short) 29);
			celdaHora.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			//						
			int nCelda = 0;
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Crédito Fondeo");
			celda.setCellStyle(estiloNeg8);
			if(mostrarAgro){
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Nombre del Acreditado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Crédito Activo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Fecha de Otorgamiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Fecha próximo vencimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Monto próximo vencimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Fecha último vencimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Tasa pasiva");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Núm. De " + safilocale+"s");
			celda.setCellStyle(estiloNeg8);
			}
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Institución de Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Nombre Institución de Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Línea de Fondeo");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Descripción de Línea");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Moneda");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Nombre Moneda");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Valor Divisa en Otorgamiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Estatus de Crédito");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Monto Original Crédito");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("No. Amortizaciones");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Cap.Vigente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Cap. Atrasado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Interés Vigente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Interés Atrasado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Moratorios");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Comisión Falta Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Saldo Otras Comisiones");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("IVA Interés Pagado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("IVA Moratorio Pagado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("IVA Com. Falta Pago");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("IVA Otras Comisiones Pagado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Retención Acumulada");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Paso Cap. Atrasado Del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Paso Interés Atrasado Del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Int. Devengado en el Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Moratorio Devengado en el Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Com. Fal. Pago Devengado en el Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Cap. Vigente del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Cap. Vigente del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Interés Vigente del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Interés Atrasado del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Comisiones del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago Moratorios del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Pago IVA del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Retención ISR del Día");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short) nCelda++);
			celda.setCellValue("Días de Atraso");
			celda.setCellStyle(estiloNeg8);
			double monto = 0;
			int i = 7, iter = 0;
			int tamanioLista = listaCreditos.size();
			RepAnaliticoCarteraPasBean celdaRep = null;
			for (iter = 0; iter < tamanioLista; iter++) {
				
				celdaRep = (RepAnaliticoCarteraPasBean) listaCreditos.get(iter);
				fila = hoja.createRow(i);
				nCelda = 0;
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getCreditoFondeoID());
				if(mostrarAgro){
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getNombreCompleto());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getCreditoID());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getFechaMinistrado());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getFechaProxPag());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getMontoProx());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getFechaUltVenc());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getTasaFija());
					
					celda = fila.createCell((short) nCelda++);
					celda.setCellValue(celdaRep.getNumSocios());
				}
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getInstitutFondID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getNombreInstitFon());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getLineaFondeoID());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getDescripLinea());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getMonedaID());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getDescMoneda());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getValoMoneda());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getEstatusCredito());
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getNumAmortizacion());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoCapVigente()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoCapVigente());
				if(totaSaldCapVig.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldCapVig.get(celdaRep.getDescMoneda());
				}
				totaSaldCapVig.put(celdaRep.getDescMoneda(), monto);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoCapAtras()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoCapAtras());
				if(totaSaldCapAtr.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldCapAtr.get(celdaRep.getDescMoneda());
				}
				totaSaldCapAtr.put(celdaRep.getDescMoneda(), monto);
				
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoInteresPro()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoInteresPro());
				if(totaSaldIntVig.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldIntVig.get(celdaRep.getDescMoneda());
				}
				totaSaldIntVig.put(celdaRep.getDescMoneda(), monto);
				
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoInteresAtra()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoInteresAtra());
				if(totaSaldIntAtr.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldIntAtr.get(celdaRep.getDescMoneda());
				}
				totaSaldIntAtr.put(celdaRep.getDescMoneda(), monto);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoMoratorios());
				if(totaSaldoMora.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldoMora.get(celdaRep.getDescMoneda());
				}
				totaSaldoMora.put(celdaRep.getDescMoneda(), monto);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoComFaltaPa()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoComFaltaPa());
				if(totaSaldComPag.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldComPag.get(celdaRep.getDescMoneda());
				}
				totaSaldComPag.put(celdaRep.getDescMoneda(), monto);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSaldoOtrasCom()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				monto = 0;
				monto = Utileria.convierteDoble(celdaRep.getSaldoOtrasCom());
				if(totaSaldOtrCom.get(celdaRep.getDescMoneda()) != null){
					monto = monto + totaSaldOtrCom.get(celdaRep.getDescMoneda());
				}
				totaSaldOtrCom.put(celdaRep.getDescMoneda(), monto);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSalIVAInteres()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSalIVAMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSalIVAComFalPago()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSalIVACom()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getSalRetencion()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPasoCapAtraDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPasoIntAtraDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getIntOrdDevengado()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getIntMorDevengado()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getComisiDevengado()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoCapVigDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoCapAtrDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoIntOrdDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoIntAtrDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoComisiDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getPagoIvaDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(Utileria.convierteDoble(celdaRep.getISRDelDia()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short) nCelda++);
				celda.setCellValue(celdaRep.getDiasAtraso());
				celda.setCellStyle(estiloDatosCentrado);
				
				
				i++;
			}
			i = i + 2;
			int contaNumFilas = 0;
			for(String nomMoneda : totaSaldCapVig.keySet()){		
				contaNumFilas++;
				fila = hoja.createRow(i++);
				//fila = hoja.getRow(i);
				celda = fila.createCell((short)6);
				celda.setCellValue(nomMoneda);
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue(totaSaldCapVig.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)12);
				celda.setCellValue(totaSaldCapAtr.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)13);
				celda.setCellValue(totaSaldIntVig.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)14);
				celda.setCellValue(totaSaldIntAtr.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)15);
				celda.setCellValue(totaSaldoMora.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)16);
				celda.setCellValue(totaSaldComPag.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				celda = fila.createCell((short)17);
				celda.setCellValue(totaSaldOtrCom.get(nomMoneda));
				celda.setCellStyle(estiloFormatoDecimalNegrita);
				
				
			}
			
			i = i - contaNumFilas;
			if(contaNumFilas > 0){
				fila = hoja.getRow(i);
			}else{
				fila = hoja.createRow(i);
			}
			celda = fila.createCell((short) 0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i + 1;
			if(contaNumFilas > 1){
				fila = hoja.getRow(i);
			}else{
				fila = hoja.createRow(i);
			}
			celda = fila.createCell((short) 0);
			celda.setCellValue(tamanioLista);
			
			for (int celd = 0; celd <= 70; celd++)
				hoja.autoSizeColumn((short) celd);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteAnaCartPas.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			//	log.info("Termina Reporte");
		} catch (Exception e) {
			//	log.info("Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
			System.out.println(e.getMessage());
		}//Fin del catch
			//} 
		
		return listaCreditos;
		
	}
	
	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
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
	
	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}
	
}
