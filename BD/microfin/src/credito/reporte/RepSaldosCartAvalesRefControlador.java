package credito.reporte;

import herramientas.Utileria;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
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

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

import credito.bean.CreditosBean;
import credito.bean.SaldosCarteraAvaRefRepBean;
import credito.servicio.CreditosServicio;

public class RepSaldosCartAvalesRefControlador extends AbstractCommandController {

	CreditosServicio creditosServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	String nomReporte = null;
	String successView = null;

	public static interface Enum_Con_TipRepor {
		int ReporExcel = 1;
	}

	public RepSaldosCartAvalesRefControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {

		CreditosBean creditosBean = (CreditosBean) command;

		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;

		String htmlString = "";

		switch (tipoReporte) {
			case Enum_Con_TipRepor.ReporExcel:
				List listaReportes = reporteExcel(tipoLista, creditosBean, response);
			break;
		}
		return null;
	}

	// Reporte de saldos capital de credito en excel
	public List reporteExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos=null;
    	listaCreditos = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 
    	ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		
		String safilocaleCliente = "safilocale.cliente";
		safilocaleCliente = Utileria.generaLocale(safilocaleCliente, parametrosSisBean.getNombreCortoInst());
		
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Rep. Saldos Cartera Aval Ref");
			HSSFRow fila= hoja.createRow(0);
			
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
 
			
			celdaUsu = fila.createCell(9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell(10);
			celdaUsu.setCellValue((!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");

			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm:ss");	
			String horaVar=postFormater.format(calendario.getTime());
			String fechaVar=creditosBean.getParFechaEmision();

			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			
			celdaFec = fila.createCell(9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell(10);
			celdaFec.setCellValue(fechaVar);
			 
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell(9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell(10);
			celdaHora.setCellValue(horaVar);
 			
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(creditosBean.getNombreInstitucion());
		
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		    
			// Creacion de fila
			fila = hoja.createRow(3);
 			
			HSSFCell celdaTitulo=fila.createCell((short)1);
			celdaTitulo.setCellStyle(estiloNeg10);
			celdaTitulo.setCellValue("REPORTE DE SALDOS DE CARTERA, AVALES Y REFERENCIAS AL DÍA "+creditosBean.getFechaInicio());
		
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
			
			// Seccion de Filtros
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			int numCeldaFilt = 1;
			HSSFCell celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Sucursal:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreSucursal());

			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Moneda:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreMoneda());

			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Producto de Crédito:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreProducto());

			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Promotor:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombrePromotor());

			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Género:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreGenero());

			fila = hoja.createRow(6);
			numCeldaFilt = 1;
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Estado:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreEstado());

			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Municipio:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue(creditosBean.getNombreMunicipi());
			
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Días de Atraso Inicial:");
			celdaFiltros.setCellStyle(estiloNeg8);	
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue((!creditosBean.getAtrasoInicial().isEmpty())?creditosBean.getAtrasoInicial(): "0");
			
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue("Días de Atraso Final:");
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros = fila.createCell(numCeldaFilt++);
			celdaFiltros.setCellValue((!creditosBean.getAtrasoFinal().isEmpty())?creditosBean.getAtrasoFinal(): "99999");

			fila = hoja.createRow(7);

			// Encabezado Desglose Saldo Exigible
			HSSFCell celda = fila.createCell((short)11);
			celda.setCellValue("Desglose Saldo Exigible");
			celda.setCellStyle(estiloCentrado);		

		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            11, //primer celda (0-based)
		            20  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(8);
			int numCelda = 1;
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Crédito ID");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Grupo ID");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Nombre Grupo");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue(safilocaleCliente+" ID");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Nombre del "+safilocaleCliente);
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Monto Original");
			celda.setCellStyle(estiloCentrado);			

			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Fecha Desembolso");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Fecha Vto. Final");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Saldo Total");
			celda.setCellStyle(estiloCentrado);
			
			// Desgloce Saldo Exigible
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Capital Vigente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Capital Vencido");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Intereses");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Moratorios");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Comisiones");
			celda.setCellStyle(estiloCentrado);							

			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Seguro");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("IVA Seguro");
			celda.setCellStyle(estiloCentrado);	
						
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Total Pagar");// Total Cuota
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Días Atraso");
			celda.setCellStyle(estiloCentrado);	
			
			// Datos del Domicilio del Cliente
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Celular");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado");
			celda.setCellStyle(estiloCentrado);
			
			// Datos de las Referencias
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreReferencia1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreReferencia2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreReferencia3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad3");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado3");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreReferencia4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad4");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado4");
			celda.setCellStyle(estiloCentrado);

			// Datos de los Avales
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreAval1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad1");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado1");
			celda.setCellStyle(estiloCentrado);
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("NombreAval2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Teléfono2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Calle y Número2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Colonia2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("C.P.2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Localidad2");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)numCelda++);
			celda.setCellValue("Estado2");
			celda.setCellStyle(estiloCentrado);
			
			int i=9,iter=0;
			int tamanioLista = listaCreditos.size();
			SaldosCarteraAvaRefRepBean credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
				numCelda = 1;
				credito = (SaldosCarteraAvaRefRepBean) listaCreditos.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCreditoID());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getEstatusCredito());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getGrupoID());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreGrupo());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getClienteID());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreCompleto());
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getFechaInicio());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getFechaVencimien());
				celda.setCellStyle(estiloDatosCentrado);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getSaldoTotal()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				// Desgloce Saldo Exigible
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getCapital()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getCapitalVencido()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getInteres()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getMoratorios()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getComisiones()));
				celda.setCellStyle(estiloFormatoDecimal);			 
				
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getiVATotal()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getSeguro()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getiVASeguro()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(Double.parseDouble(credito.getTotalCuota()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getDiasAtraso());						
				celda.setCellStyle(estiloDatosCentrado);
				
				// Datos del Domicilio
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefono());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCelular());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumero());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColonia());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcP());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidad());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstado());						
				
				// Datos de las referencias
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreReferencia1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoRef1());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroRef1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaRef1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPRef1());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadRef1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoRef1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreReferencia2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoRef2());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroRef2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaRef2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPRef2());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadRef2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoRef2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreReferencia3());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoRef3());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroRef3());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaRef3());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPRef3());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadRef3());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoRef3());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreReferencia4());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoRef4());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroRef4());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaRef4());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPRef4());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadRef4());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoRef4());
				
				// Datos de los Avales
				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreAval1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoAval1());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroAval1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaAval1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPAval1());						
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadAval1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoAval1());						

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreAval2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getTelefonoAval2());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getCalleNumeroAval2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreColoniaAval2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getcPAval2());
				celda.setCellStyle(estiloDatosCentrado);

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreLocalidadAval2());

				celda=fila.createCell((short)numCelda++);
				celda.setCellValue(credito.getNombreEstadoAval2());
				i++;
			}
			 
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);

			for(int celd=0; celd<=numCelda+1; celd++){
				hoja.autoSizeColumn((short)celd);
			}
								
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepSaldosCarteraCobAvalesReferencias.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
		return  listaCreditos;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
