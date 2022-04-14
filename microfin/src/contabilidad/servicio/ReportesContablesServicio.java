package contabilidad.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import contabilidad.dao.ReportesContablesDAO;
import contabilidad.bean.ReporteBalanzaContableBean;
import contabilidad.bean.ReportesContablesBean;

public class ReportesContablesServicio  extends BaseServicio {
	
	private ReportesContablesServicio(){
		super();
	}

	ReportesContablesDAO reportesContablesDAO = null;
	CorreoServicio correoServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	public static interface Enum_Lis_ReportesContables{
		int principal 		= 1;
		int balanzaComp		= 2;
	}
	
	public static interface Enum_Con_ReportesContables{
		int balanzaSinMov 		= 1;
		int balanzaConMov 		= 2;
	}
	
	public static interface Enum_Rep_BalanzaContable {
		int ReporPantalla = 1 ;
		int ReporPDF = 2 ;
		int ReporExcel = 3 ;
	}
	
	public String reportesContablesCuenta(ReportesContablesBean reportesContablesBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/*Reporte de movimientos por cuenta contable*/
	public String reportesMovCuentaContaPoliza(ReportesContablesBean reportesContablesBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CuentaCompleta", reportesContablesBean.getCuentaCompleta());
		parametrosReporte.agregaParametro("Par_CuentaCompFin",reportesContablesBean.getCuentaCompletaFin());
		parametrosReporte.agregaParametro("Par_DesCuentapFin",reportesContablesBean.getDesCuentaCompletaF());
		parametrosReporte.agregaParametro("Par_FechaIni", reportesContablesBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaFin", reportesContablesBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_DescripCuenta", reportesContablesBean.getDesCuentaCompleta());
		parametrosReporte.agregaParametro("Par_Usuario",reportesContablesBean.getNombreusuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reportesContablesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",reportesContablesBean.getFechaEmision());
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream reportesMovCuentaContaPolizaPDF(ReportesContablesBean reportesContablesBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CuentaCompleta", reportesContablesBean.getCuentaCompleta());
		parametrosReporte.agregaParametro("Par_CuentaCompFin",reportesContablesBean.getCuentaCompletaFin());
		parametrosReporte.agregaParametro("Par_DesCuentapFin",reportesContablesBean.getDesCuentaCompletaF());
		parametrosReporte.agregaParametro("Par_FechaIni", reportesContablesBean.getFechaIni());
		parametrosReporte.agregaParametro("Par_FechaFin", reportesContablesBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_DescripCuenta", reportesContablesBean.getDesCuentaCompleta());
		parametrosReporte.agregaParametro("Par_Usuario",reportesContablesBean.getNombreusuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reportesContablesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",reportesContablesBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_PrimerRango", reportesContablesBean.getPrimerRango());
		parametrosReporte.agregaParametro("Par_SegundoRango", reportesContablesBean.getSegundoRango());
		parametrosReporte.agregaParametro("Par_PrimerCentroC", reportesContablesBean.getPrimerCentroCostos());
		parametrosReporte.agregaParametro("Par_SegundoCentroC", reportesContablesBean.getSegundoCentroCostos());
		parametrosReporte.agregaParametro("Par_TipoInstrumentoID", reportesContablesBean.getTipoInstrumentoID());
		parametrosReporte.agregaParametro("Par_DescTipoInstrumento", reportesContablesBean.getDescTipoInstrumento());
		parametrosReporte.agregaParametro("Par_RutaImagen", parametrosAuditoriaBean.getRutaImgReportes());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/*Reporte de balanza contable*/
	public String reporteBalanzaComprobacion(ReporteBalanzaContableBean reporteBalanzaContable, String nombreReporte) throws Exception{

		String htmlString = "";
		MensajeTransaccionBean mensajeTransaccionBean = null;
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
		
		try{
			
			paramGeneralesBean.setValorParametro(reporteBalanzaContable.getNombreUsuario());
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableSI, paramGeneralesBean);
			
			ParametrosReporte parametrosReporte = new ParametrosReporte();
	
			parametrosReporte.agregaParametro("Par_Ejercicio", Integer.parseInt(reporteBalanzaContable.getEjercicio()));
			parametrosReporte.agregaParametro("Par_Periodo",Integer.parseInt(reporteBalanzaContable.getPeriodo()));
			parametrosReporte.agregaParametro("Par_Fecha", reporteBalanzaContable.getFecha());
			parametrosReporte.agregaParametro("Par_TipoConsulta",reporteBalanzaContable.getTipoConsulta());
			parametrosReporte.agregaParametro("Par_SaldosCero", reporteBalanzaContable.getSaldoCero());
			parametrosReporte.agregaParametro("Par_Cifras", reporteBalanzaContable.getCifras());
			parametrosReporte.agregaParametro("Par_NombreUsuario",reporteBalanzaContable.getClaveUsuario());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",reporteBalanzaContable.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_FechaEmision",reporteBalanzaContable.getFechaEmision());
			parametrosReporte.agregaParametro("Par_FechaFin",reporteBalanzaContable.getFechaFin());
			parametrosReporte.agregaParametro("Par_CCInicial",reporteBalanzaContable.getCcInicial());
			parametrosReporte.agregaParametro("Par_CCFinal",reporteBalanzaContable.getCcFinal());
			parametrosReporte.agregaParametro("Par_CCInicialDes",reporteBalanzaContable.getCcInicialDes());
			parametrosReporte.agregaParametro("Par_CCFinalDes",reporteBalanzaContable.getCcFinalDes());
			parametrosReporte.agregaParametro("Par_CuentaIni",reporteBalanzaContable.getCuentaIni());
			parametrosReporte.agregaParametro("Par_CuentaFin",reporteBalanzaContable.getCuentaFin());
			parametrosReporte.agregaParametro("Par_NivelDet",reporteBalanzaContable.getNivelDetalle());
			parametrosReporte.agregaParametro("Par_TipoBalanza",reporteBalanzaContable.getTipoBalanza());
			
			htmlString = Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
			
		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
			loggerSAFI.info("Error al crear al Balanza Contable en Pantalla: " + exception);
			loggerSAFI.info("Resultado Act. EjecucionBalanzaContable: " +   Utileria.logJsonFormat(mensajeTransaccionBean));
		}
		
		return htmlString;

	}
	
	// Reporte de saldos de balanza contable en pdf
	public ByteArrayOutputStream reporteBalanzaComprobacionPDF(ReporteBalanzaContableBean reporteBalanzaContable, String nombreReporte) throws Exception{
		
		ByteArrayOutputStream byteArrayOutputStream = null;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
		
		try{
			
			paramGeneralesBean.setValorParametro(reporteBalanzaContable.getNombreUsuario());
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableSI, paramGeneralesBean);
			
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Ejercicio", Integer.parseInt(reporteBalanzaContable.getEjercicio()));
			parametrosReporte.agregaParametro("Par_Periodo",Integer.parseInt(reporteBalanzaContable.getPeriodo()));
			parametrosReporte.agregaParametro("Par_Fecha", reporteBalanzaContable.getFecha());
			parametrosReporte.agregaParametro("Par_TipoConsulta",reporteBalanzaContable.getTipoConsulta());
			parametrosReporte.agregaParametro("Par_SaldosCero", reporteBalanzaContable.getSaldoCero());
			parametrosReporte.agregaParametro("Par_Cifras", reporteBalanzaContable.getCifras());
			parametrosReporte.agregaParametro("Par_NombreUsuario",reporteBalanzaContable.getClaveUsuario());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",reporteBalanzaContable.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_FechaEmision",reporteBalanzaContable.getFechaEmision());
			parametrosReporte.agregaParametro("Par_FechaFin",reporteBalanzaContable.getFechaFin());
			parametrosReporte.agregaParametro("Par_CCInicial",reporteBalanzaContable.getCcInicial());
			parametrosReporte.agregaParametro("Par_CCFinal",reporteBalanzaContable.getCcFinal());
			parametrosReporte.agregaParametro("Par_CCInicialDes",reporteBalanzaContable.getCcInicialDes());
			parametrosReporte.agregaParametro("Par_CCFinalDes",reporteBalanzaContable.getCcFinalDes());
			parametrosReporte.agregaParametro("Par_CuentaIni",reporteBalanzaContable.getCuentaIni());
			parametrosReporte.agregaParametro("Par_CuentaFin",reporteBalanzaContable.getCuentaFin());
			parametrosReporte.agregaParametro("Par_NivelDet",reporteBalanzaContable.getNivelDetalle());
			parametrosReporte.agregaParametro("Par_TipoBalanza",reporteBalanzaContable.getTipoBalanza());
			
			byteArrayOutputStream = Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
			
		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
			loggerSAFI.info("Error al crear al Balanza Contable en PDF: " + exception);
			loggerSAFI.info("Resultado Act. EjecucionBalanzaContable: " +   Utileria.logJsonFormat(mensajeTransaccionBean));
		}
		
		return byteArrayOutputStream;

	}
	
	/*case para listas de reportes de Balanza*/
	public List <ReporteBalanzaContableBean>listaReporteBalanzaComp(int tipoLista, ReporteBalanzaContableBean balanza, HttpServletResponse response){

		List<ReporteBalanzaContableBean> listaBalanza=null;
	
		switch(tipoLista){
		
			case Enum_Lis_ReportesContables.balanzaComp:
				listaBalanza = reportesContablesDAO.consultaBalanzaComprobacion(balanza, tipoLista); 
			break;	
		
		}
		
		return listaBalanza;
	}

	
	// Reporte de balanza contable en Excel
	public void reporteBalanzaComprobacionExcel(int tipoLista, ReporteBalanzaContableBean reporteBalanzaContable,  HttpServletResponse httpServletResponse){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();

		try {

			paramGeneralesBean.setValorParametro(reporteBalanzaContable.getNombreUsuario());
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableSI, paramGeneralesBean);
			List<ReporteBalanzaContableBean> listaBalanza = reportesContablesDAO.consultaBalanzaComprobacion(reporteBalanzaContable, tipoLista); 	

			//if(listaBalanza != null){
			// Creacion de Libro
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, Constantes.TamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, Constantes.TamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, Constantes.TamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, Constantes.TamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Centrado
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, Constantes.TamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Decimal
			XSSFCellStyle estiloTextoDecimal = Utileria.crearFuenteDecimal(libro, Constantes.TamanioTexto, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("BALANZA_DE_COMPROBACIÓN");
			XSSFRow fila = hoja.createRow(0);
			
			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celda = fila.createCell((short)1);
			celda.setCellValue(reporteBalanzaContable.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 6));
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			
			celda = fila.createCell((short)9);
			celda.setCellValue(reporteBalanzaContable.getClaveUsuario());
			celda.setCellStyle(estiloTexto);
			
			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellStyle(estiloTitulo);
			celda.setCellValue("Balanza de Comprobación al "+reporteBalanzaContable.getFecha());
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 6));
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);
			
			celda = fila.createCell((short)9);
			celda.setCellValue(reporteBalanzaContable.getFechaEmision());
			celda.setCellStyle(estiloTexto);
											
			fila = hoja.createRow(3);
			celda = fila.createCell((short)8);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			
			celda = fila.createCell((short)9);
			celda.setCellValue(reporteBalanzaContable.getHoraEmision());
			celda.setCellStyle(estiloTexto);
			
			
			//Variable para recibir el valor del Bean  
			String saldosCero	 = "NO";
			String cifras		 = "MILES";
			String ejercicioID	 = reporteBalanzaContable.getEjercicio();
			String periodoID	 = reporteBalanzaContable.getPeriodo();
			String cuentaContableInicial = reporteBalanzaContable.getCuentaIni();
			String cuentaContableFinal 	 = reporteBalanzaContable.getCuentaFin();
			String nivelDetalle	 = reporteBalanzaContable.getNivelDetalle();

			if(periodoID.equals("37")){
				periodoID = "TODOS";
			}
			
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			if(ejercicioID .equals("0")){
			}else{
				celda = fila.createCell((short)1);
				celda.setCellValue("Ejercicio:");
				celda.setCellStyle(estiloParametros);
				
				celda = fila.createCell((short)2);
				celda.setCellValue(ejercicioID);
				celda.setCellStyle(estiloTexto);
			}
			
			if(periodoID .equals("0")){
			}else{
				celda = fila.createCell((short)5);
				celda.setCellValue("Periodo:");
				celda.setCellStyle(estiloParametros);
				
				celda = fila.createCell((short)6);
				celda.setCellValue(periodoID);
				celda.setCellStyle(estiloTexto);
			}
			
			if(reporteBalanzaContable.getCuentaIni().equals("")){
				cuentaContableInicial = "TODOS";
				cuentaContableFinal   = "TODOS";
			}
			
			fila = hoja.createRow(6);
			celda=fila.createCell((short)1);
			celda.setCellValue("Cuenta Contable Inicial:");
			celda.setCellStyle(estiloParametros);

			celda=fila.createCell((short)2);
			celda.setCellValue(cuentaContableInicial);
			celda.setCellStyle(estiloTexto);
			
			celda=fila.createCell((short)5);
			celda.setCellValue("Cuenta Contable Final:");
			celda.setCellStyle(estiloParametros);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(cuentaContableFinal);
			celda.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(7);
			celda=fila.createCell((short)1);
			celda.setCellValue("Centro de Costos Inicial:");
			celda.setCellStyle(estiloParametros);
			
			celda=fila.createCell((short)2);
			celda.setCellValue(reporteBalanzaContable.getCcInicialDes());
			celda.setCellStyle(estiloTexto);
			
			celda=fila.createCell((short)5);
			celda.setCellValue("Centro de Costos Final:");
			celda.setCellStyle(estiloParametros);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(reporteBalanzaContable.getCcFinalDes());
			celda.setCellStyle(estiloTexto);

			if(reporteBalanzaContable.getCifras().equals( "P" )){
				cifras = "PESOS"; 
			}
			
			if(reporteBalanzaContable.getNivelDetalle().equals("")){
				nivelDetalle = "TODOS";
			}
			
			fila = hoja.createRow(8);
			celda=fila.createCell((short)1);
			celda.setCellValue("Cifras:");
			celda.setCellStyle(estiloParametros);

			celda=fila.createCell((short)2);
			celda.setCellValue(cifras);
			celda.setCellStyle(estiloTexto);

			celda=fila.createCell((short)5);
			celda.setCellValue("Nivel Detalle:");
			celda.setCellStyle(estiloParametros);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(nivelDetalle);
			celda.setCellStyle(estiloTexto);

			if(reporteBalanzaContable.getSaldoCero().equals( "S" )){
				saldosCero ="SI";	 
			}
			
			fila = hoja.createRow(9);
			celda=fila.createCell((short)1);
			celda.setCellValue("Saldos Cero:");
			celda.setCellStyle(estiloParametros);

			celda=fila.createCell((short)2);
			celda.setCellValue(saldosCero);
			celda.setCellStyle(estiloTexto);
			
			fila = hoja.createRow(10);
			fila = hoja.createRow(11);
			
			// Creacion de Cabeceras
			fila = hoja.createRow(12);
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)1);
			celda.setCellValue("Cuenta");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("C.C.");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Saldo Inicial Deudor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Saldo Inicial Acreedor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Cargos");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Abonos");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Saldo Deudor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Saldo Acreedor");
			celda.setCellStyle(estiloCabecera);
			
			int numeroFila = 13;
			int numRegistros = 0;
			double totalSaldoInicialDeudor = 0;
			double totalSaldoInicialAcreedor = 0;
			double totalCargos = 0;
			double totalAbonos = 0;
			double totalSaldoFinalDeudor = 0;
			double totalSaldoFinalAcreedor = 0;

			for(ReporteBalanzaContableBean reporteBalanzaContableBean : listaBalanza ){

				fila=hoja.createRow(numeroFila);

				celda=fila.createCell((short)1);
				celda.setCellValue(reporteBalanzaContableBean.getCuentaContable());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(reporteBalanzaContableBean.getConcepto());
				celda.setCellStyle(estiloTexto);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(reporteBalanzaContableBean.getCentroCosto());
				celda.setCellStyle(estiloTextoCentrado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getSaldoInicial()));
				celda.setCellStyle(estiloTextoDecimal);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getSaldoIniAcreed()));
				celda.setCellStyle(estiloTextoDecimal);
				
				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getCargos()));
				celda.setCellStyle(estiloTextoDecimal);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getAbonos()));
				celda.setCellStyle(estiloTextoDecimal);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getSaldoDeudor()));
				celda.setCellStyle(estiloTextoDecimal);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(reporteBalanzaContableBean.getSaldoAcreedor()));
				celda.setCellStyle(estiloTextoDecimal);
				
				numRegistros = numRegistros + 1;
				numeroFila++;
			}
			
			if(	listaBalanza.size()>0 ){	
				ReporteBalanzaContableBean balanza;
				balanza = (ReporteBalanzaContableBean)listaBalanza.get(0);
				totalSaldoInicialDeudor		= balanza.getSumaSalIni();
				totalSaldoInicialAcreedor 	= balanza.getSumaSalIniAcre();
				totalCargos					= balanza.getSumaCargos();
				totalAbonos					= balanza.getSumaAbonos();
			 	totalSaldoFinalDeudor		= balanza.getSumaSalDeu();
				totalSaldoFinalAcreedor		= balanza.getSumaSalAcr();					
			}
			
			
			numeroFila = numeroFila+2;
			fila=hoja.createRow(numeroFila);
			celda = fila.createCell((short)1);
			celda.setCellValue("Registros Exportados:");
			celda.setCellStyle(estiloParametros);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Total Saldo Inicial Deudor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Total Saldo Inicial Acreedor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Total Cargos");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Total Abonos");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Total Saldo Deudor");
			celda.setCellStyle(estiloCabecera);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Total Saldo Acreedor");
			celda.setCellStyle(estiloCabecera);
			
			numeroFila = numeroFila+1;
			fila=hoja.createRow(numeroFila);
			celda=fila.createCell((short)1);
			celda.setCellValue(numRegistros);
			
			celda=fila.createCell((short)4);
			celda.setCellValue(totalSaldoInicialDeudor);
			celda.setCellStyle(estiloTextoDecimal);
			
			celda=fila.createCell((short)5);
			celda.setCellValue(totalSaldoInicialAcreedor);
			celda.setCellStyle(estiloTextoDecimal);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(totalCargos);
			celda.setCellStyle(estiloTextoDecimal);
			
			celda=fila.createCell((short)7);
			celda.setCellValue(totalAbonos);
			celda.setCellStyle(estiloTextoDecimal);
			
			celda=fila.createCell((short)8);
			celda.setCellValue(totalSaldoFinalDeudor);
			celda.setCellStyle(estiloTextoDecimal);
			
			celda=fila.createCell((short)9);
			celda.setCellValue(totalSaldoFinalAcreedor);
			celda.setCellStyle(estiloTextoDecimal);

			for(int celdaAjustar = Constantes.ENTERO_CERO; celdaAjustar <= 9; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}
									
			//Creo la cabecera
			httpServletResponse.addHeader("Content-Disposition","inline; filename=ReporteBalanzaComprobacion.xls");
			httpServletResponse.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = httpServletResponse.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
		
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			mensajeTransaccionBean = paramGeneralesServicio.ejecucionBalanzaContable(ParamGeneralesServicio.Enum_Act_ParamGenerales.EjecucionBalanzaContableNO, paramGeneralesBean);
			loggerSAFI.info("Error al crear al Balanza Contable en Excel: " + exception);;
			loggerSAFI.info("Resultado Act. EjecucionBalanzaContable: " +   Utileria.logJsonFormat(mensajeTransaccionBean));
		}
	}
		
	/**
	 * Reporte de Movimientos por cuenta contable Contabilidad -> Reportes ->Movimientos por Cuenta Contable
	 * @param reportesContablesBean
	 * @param response
	 * @return
	 */
	public List<ReportesContablesBean> listaReporteMovCtas(ReportesContablesBean reportesContablesBean, HttpServletResponse response) {
		List<ReportesContablesBean> listaMovCtas = null;
		listaMovCtas = reportesContablesDAO.consultaRepMovimientosCta(reportesContablesBean);
		return listaMovCtas;
	}

	public void setReportesContablesDAO(ReportesContablesDAO reportesContablesDAO) {
		this.reportesContablesDAO = reportesContablesDAO;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
}
