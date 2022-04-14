package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.text.SimpleDateFormat;
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

import pld.bean.ReportesSITIBean;
import pld.dao.ReportesSITIDAO;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class RepOperaPLDControlador extends AbstractCommandController {
	String					nombreReporte			= null;
	String					successView				= null;
	ParametrosSesionBean	parametrosSesionBean	= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	ReportesSITIDAO			reportesSITIDAO			= null;
	
	public static interface Enum_Con_TipRepor {
		int	EXCEL	= 1;
	}
	
	public static interface Enum_Con_TipOpera {
		int	Inusuales		= 1;
		int	Reelevantes		= 2;
		int	InternasPreo	= 3;
	}
	
	public RepOperaPLDControlador() {
		setCommandClass(ReportesSITIBean.class);
		setCommandName("reportesSITI");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReportesSITIBean reporteSITIBean = (ReportesSITIBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoOperacion = Utileria.convierteEntero(request.getParameter("tipoOperacion"));
		String htmlString = "";
		switch (tipoOperacion) {
			case Enum_Con_TipOpera.Inusuales :
			case Enum_Con_TipOpera.Reelevantes :
			case Enum_Con_TipOpera.InternasPreo :
						reporteSITIExcel(reporteSITIBean, request, response, tipoOperacion);
				break;
		}
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
	private List<ReportesSITIBean> reporteSITIExcel(ReportesSITIBean reporteSITIBean, HttpServletRequest request, HttpServletResponse response, int tipoReporte) {
		List<ReportesSITIBean> listaReporte = null;
		try {
			final String valorVacio = "";
			String nombreReporteXLS = "";
			String leyendaSocap = "Las columnas marcadas con asterisco (*) (14, 34 a la 41) no aplican para Operaciones Relevantes." + "\nLas columnas marcadas con asterisco (**) (29 a la 33) aplican únicamente para Instituciones y" + " Sociedades Mutualistas de Seguros, y para Instituciones de Fianzas.";
			String leyendaSofom = "Las columnas marcadas con asterisco (*) (14, 29 a la 36) no aplican para Operaciones Relevantes.";
			switch (tipoReporte) {
				case Enum_Con_TipOpera.Reelevantes :
					listaReporte=reportesSITIDAO.listaReporteOpPLD(reporteSITIBean, tipoReporte);
					nombreReporteXLS = "ReporteReelevantes";
					break;
				case Enum_Con_TipOpera.Inusuales :
					listaReporte=reportesSITIDAO.listaReporteOpPLD(reporteSITIBean, tipoReporte);
					nombreReporteXLS = "ReporteInusuales";
					break;
				case Enum_Con_TipOpera.InternasPreo :
					listaReporte=reportesSITIDAO.listaReporteOpPLD(reporteSITIBean, tipoReporte);
					nombreReporteXLS = "ReporteInternaPreo";
					break;
			}
			
			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			
			XSSFSheet hoja = null;
			XSSFWorkbook libro = null;
			libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			XSSFFont fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			// Fuente encabezado del reporte
			XSSFFont fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
			
			//Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 10);
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
			
			// Estilo de datos centrados 
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
			
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
			hoja = libro.createSheet("Reporte SITI");
			
			// inicio fecha, usuario,institucion y hora
			XSSFRow fila = hoja.createRow(0);
			XSSFCell celdaUsu = fila.createCell(9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(10);
			celdaUsu.setCellValue(((!reporteSITIBean.getUsuario().isEmpty()) ? reporteSITIBean.getUsuario() : "TODOS").toUpperCase());
			
			fila = hoja.createRow(1);
			String fechaVar = reporteSITIBean.getFechaSistema().toString();
			XSSFCell celdaFec = fila.createCell(9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(10);
			celdaFec.setCellValue(fechaVar);
			
			XSSFCell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(reporteSITIBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celdaInst.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(2);
			XSSFCell celdaHora = fila.createCell(9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(10);
			celdaHora.setCellValue(hora);
			// fin fecha usuario,institucion y hora
			XSSFCell celda = fila.createCell((short) 1);
			celda.setCellValue(reporteSITIBean.getTituloReporte().toUpperCase());
			celda.setCellStyle(estiloNeg10);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			2, //primera fila (0-based)
			2, //ultima fila  (0-based)
			1, //primer celda (0-based)
			8 //ultima celda   (0-based)
			));
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(4);
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			int numCelda = 0;
			celda = fila.createCell(numCelda);
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TIPO DE REPORTE");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("PERIODO DEL REPORTE");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("FOLIO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("ORGANISMO SUPERVISOR");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("CLAVE DE LA ENTIDAD FINANCIERA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("LOCALIDAD");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("SUCURSAL");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TIPO DE OPERACIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("INSTRUMENTO MONETARIO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO DE CUENTA, CONTRATO,\nPÓLIZA  O NÚMERO DE SEGURIDAD SOCIAL");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("MONTO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("MONEDA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("FECHA DE LA OPERACIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("FECHA DE DETECCIÓN\nDE LA OPERACIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("NACIONALIDAD");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TIPO DE PERSONA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("RAZÓN SOCIAL O DENOMINACIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("NOMBRE");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("APELLIDO PATERNO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("APELLIDO MATERNO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("RFC");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("CURP");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("FECHA DE NACIMIENTO\nO DE CONSTITUCIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("DOMICILIO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("COLONIA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("CIUDAD O POBLACIÓN");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TELÉFONO");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("ACTIVIDAD ECONÓMICA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			if (parametrosSisBean.getNombreCortoInst().equals("socap") || parametrosSisBean.getNombreCortoInst().equals("scap") || parametrosSisBean.getNombreCortoInst().equals("sofipo")) {
				celda = fila.createCell(numCelda++);
				celda.setCellValue("NOMBRE**");
				hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("APELLIDO PATERNO**");
				hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("APELLIDO MATERNO**");
				hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("RFC**");
				hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("CURP**");
				hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
				celda.setCellStyle(estiloCentrado);
			}
			celda = fila.createCell(numCelda++);
			celda.setCellValue("CONSECUTIVO DE CUENTAS\nO PERSONAS RELACIONADAS *");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO DE CUENTA");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("CLAVE DE ENTIDAD FINANCIERA*");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TITULAR DE LA CUENTA\nO RELACIONADO: NOMBRE *");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("APELLIDO PATERNO *");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("APELLIDO MATERNO *");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("DESCRIPCIÓN DE LA OPERACIÓN *");
			hoja.addMergedRegion(new CellRangeAddress(4, 5, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("RAZONES POR LAS QUE EL ACTO U OPERACIÓN\nSE CONSIDERA PREOCUPANTE O INUSUAL *");
			celda.setCellStyle(estiloCentrado);
			
			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			int i = 6;
			if (listaReporte != null) {
				
				int tamanioLista = listaReporte.size();
				
				ReportesSITIBean sitiBean = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					sitiBean = (ReportesSITIBean) listaReporte.get(iter);
					
					numCelda = 0;
					fila = hoja.createRow(i);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getTipoReporte());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getPeriodoReporte());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFolio());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClaveOrgSupervisor());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClaveEntCasFim());
					celda.setCellStyle(estilo8);
					
					//06
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getLocalidadSuc());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getSucursalID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getTipoOperacionID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getInstrumentMonID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getCuentaAhoID());
					celda.setCellStyle(estilo8);
					
					//11
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getMonto());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClaveMoneda());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFechaOpe());
					celda.setCellStyle(estilo8);
					
					// no aplica para op relevantes
					celda = fila.createCell(numCelda++);
					celda.setCellValue(tipoReporte == Enum_Con_TipOpera.Reelevantes ? valorVacio : sitiBean.getFechaDeteccion());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNacionalidad());
					celda.setCellStyle(estilo8);
					
					//16
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getTipoPersona());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getRazonSocial());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNombre());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getApellidoPat());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getApellidoMat());
					celda.setCellStyle(estilo8);
					
					//21
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getRFC());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getCURP());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getFechaNac());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getDomicilio());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getColonia());
					celda.setCellStyle(estilo8);
					
					//26
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getLocalidad());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getTelefono());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getActEconomica());
					celda.setCellStyle(estilo8);
					// A partir de aqui ya no aplica para el rep. de relevantes
					// de la 29 - 33 no aplican por tipo de institucion financieta
					if (parametrosSisBean.getNombreCortoInst().equals("socap") || parametrosSisBean.getNombreCortoInst().equals("scap") || parametrosSisBean.getNombreCortoInst().equals("sofipo")) {
						celda = fila.createCell(numCelda++);
						celda.setCellValue(valorVacio);
						celda.setCellStyle(estilo8);
						
						celda = fila.createCell(numCelda++);
						celda.setCellValue(valorVacio);
						celda.setCellStyle(estilo8);
						
						//31
						celda = fila.createCell(numCelda++);
						celda.setCellValue(valorVacio);
						celda.setCellStyle(estilo8);
						
						celda = fila.createCell(numCelda++);
						celda.setCellValue(valorVacio);
						celda.setCellStyle(estilo8);
						
						celda = fila.createCell(numCelda++);
						celda.setCellValue(valorVacio);
						celda.setCellStyle(estilo8);
					}
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getCtaRelacionadoID());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getCuenAhoRelacionado());
					celda.setCellStyle(estilo8);
					
					//36 y 31 para sofom
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getClaveCasfimRelacionado());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getNomTitular());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getApPatTitular());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getApMatTitular());
					celda.setCellStyle(estilo8);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getDesOperacion());
					celda.setCellStyle(estilo8);
					
					//41 y 36 para sofom
					celda = fila.createCell(numCelda++);
					celda.setCellValue(sitiBean.getRazones());
					celda.setCellStyle(estilo8);
					
					i++;
				}
				
				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue(listaReporte.size());
				celda.setCellStyle(estilo8);
				
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				
				if (parametrosSisBean.getNombreCortoInst().equals("socap") || parametrosSisBean.getNombreCortoInst().equals("scap") || parametrosSisBean.getNombreCortoInst().equals("sofipo")) {
					celda.setCellValue(leyendaSocap);
				} else {
					celda.setCellValue(leyendaSofom);
				}
			}
			
			hoja.addMergedRegion(new CellRangeAddress(i, i + 1, 0, 7));
			celda.setCellStyle(estilo8);
			
			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=" + nombreReporteXLS + ".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return listaReporte;
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

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ReportesSITIDAO getReportesSITIDAO() {
		return reportesSITIDAO;
	}

	public void setReportesSITIDAO(ReportesSITIDAO reportesSITIDAO) {
		this.reportesSITIDAO = reportesSITIDAO;
	}
	
}
