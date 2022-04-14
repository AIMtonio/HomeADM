package contabilidad.servicio;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellRangeAddress;

import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import contabilidad.bean.ReporteFinancierosBean;
import contabilidad.dao.ReportesFinancierosDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ReporteFinancierosServicio extends	BaseServicio{

	String transaccion ="0";
	String mes ="";
	String dia="";
	String anio="";
	String fecha="";
	String fechaFin="";
	String diaFin="";
	String mesFin="";
	String anioFin="";

	ReportesFinancierosDAO reporteFinancierosDAO = null;
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	ParamGeneralesServicio paramGeneralesServicio;

	public ReporteFinancierosServicio(){
		super();
	}

	public static interface Enum_Lis_ReportesFinancieros{
		int balanceContable 		= 1;
		int estadoResultado			= 2;
		int estadoFlujoEfec 		= 4;
		int estadoVariacion			= 5;
		int estadoResultadoMes		= 6;
	}

	public static interface Enum_EstadoVariacion{
		String ParticipacionControladora = "ParticipacionControladora";
		String CapitalSocial = "CapitalSocial";
		String AportacionesCapital = "AportacionesCapital";
		String PrimaVenta = "PrimaVenta";
		String ObligacionesSubordinadas = "ObligacionesSubordinadas";
		String IncorporacionSocFinancieras = "IncorporacionSocFinancieras";
		String ReservaCapital = "ReservaCapital";
		String ResultadoEjerAnterior = "ResultadoEjerAnterior";
		String ResultadoTitulosVenta = "ResultadoTitulosVenta";
		String ResultadoValuacionInstrumentos = "ResultadoValuacionInstrumentos";
		String EfectoAcomulado = "EfectoAcomulado";
		String BeneficioEmpleados = "BeneficioEmpleados";
		String ResultadoMonetario = "ResultadoMonetario";
		String ResultadoActivos = "ResultadoActivos";
		String ParticipacionNoControladora = "ParticipacionNoControladora";
		String CapitalContable = "CapitalContable";
		String EfectoIncorporacion = "EfectoIncorporacion";
	}

	public String reporteEstadosFinancierosPantalla(
			ReporteFinancierosBean estadosFinancierosBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		try{
			fecha 	= estadosFinancierosBean.getFecha();
			anio 	= fecha.substring(0, 4);
			mes  	= fecha.substring(5, 7);
			dia  	= fecha.substring(8, 10);
			mes		= OperacionesFechas.getNombreMes(mes, false);

			fechaFin = estadosFinancierosBean.getFechaFin();
			anioFin	= fechaFin.substring(0,4);
			mesFin	= fechaFin.substring(5,7);
			diaFin  = fechaFin.substring(8, 10);
			mesFin	= OperacionesFechas.getNombreMes(mesFin, false);

			parametrosReporte.agregaParametro("Par_NombreInstitucion",estadosFinancierosBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_DireccionInstitucion",estadosFinancierosBean.getDirecInstitucion());
			parametrosReporte.agregaParametro("Par_RFC",estadosFinancierosBean.getRfc());
			parametrosReporte.agregaParametro("Par_FechaCorte",estadosFinancierosBean.getFecha());
			parametrosReporte.agregaParametro("Par_EjercicioCont",estadosFinancierosBean.getEjercicio());
			parametrosReporte.agregaParametro("Par_PeriodoCont",estadosFinancierosBean.getPeriodo());
			parametrosReporte.agregaParametro("Par_FechaAlCorte",estadosFinancierosBean.getFecha());
			parametrosReporte.agregaParametro("Par_FechaFin",estadosFinancierosBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_Cifras",estadosFinancierosBean.getCifras());
			parametrosReporte.agregaParametro("Par_NumTransaccion",transaccion);
			parametrosReporte.agregaParametro("Par_Anio",anio);
			parametrosReporte.agregaParametro("Par_Mes",mes);
			parametrosReporte.agregaParametro("Par_Dia",dia);
			parametrosReporte.agregaParametro("Par_AnioFin",anioFin);
			parametrosReporte.agregaParametro("Par_MesFin",mesFin);
			parametrosReporte.agregaParametro("Par_DiaFin",diaFin);
			parametrosReporte.agregaParametro("Par_FechaSistema", estadosFinancierosBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_GerenteGral",estadosFinancierosBean.getGerenteGeneral());
			parametrosReporte.agregaParametro("Par_PresiConsejo",estadosFinancierosBean.getPresidenteConsejo());
			parametrosReporte.agregaParametro("Par_JefeContabilidad",estadosFinancierosBean.getJefeContabilidad());
			parametrosReporte.agregaParametro("Par_DirectorFinanzas",estadosFinancierosBean.getDirectorFinanzas());
			parametrosReporte.agregaParametro("Par_CCInicial",estadosFinancierosBean.getCcInicial());
			parametrosReporte.agregaParametro("Par_CCFinal",estadosFinancierosBean.getCcFinal());
			parametrosReporte.agregaParametro("Par_CCInicialDes",estadosFinancierosBean.getCcInicialDes());
			parametrosReporte.agregaParametro("Par_CCFinalDes",estadosFinancierosBean.getCcFinalDes());

			parametrosReporte.agregaParametro("Par_TipoConsulta",estadosFinancierosBean.getTipoConsulta());

		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Reporte Financiero Balance Contable", e);
		}

		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream reporteFinancierosPDF(
			ReporteFinancierosBean estadosFinancierosBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		try{
			fecha 	= estadosFinancierosBean.getFecha();
			anio 	= fecha.substring(0, 4);
			mes  	= fecha.substring(5, 7);
			dia  	= fecha.substring(8, 10);
			mes		= OperacionesFechas.getNombreMes(mes, false);

			fechaFin = estadosFinancierosBean.getFechaFin();
			anioFin = fechaFin.substring(0,4);
			mesFin	= fechaFin.substring(5,7);
			diaFin	= fechaFin.substring(8, 10);
			mesFin	= OperacionesFechas.getNombreMes(mesFin, false);

			parametrosReporte.agregaParametro("Par_NombreInstitucion",estadosFinancierosBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_DireccionInstitucion",estadosFinancierosBean.getDirecInstitucion());
			parametrosReporte.agregaParametro("Par_RFC",estadosFinancierosBean.getRfc());
			parametrosReporte.agregaParametro("Par_FechaCorte",estadosFinancierosBean.getFecha());
			parametrosReporte.agregaParametro("Par_EjercicioCont",estadosFinancierosBean.getEjercicio());
			parametrosReporte.agregaParametro("Par_PeriodoCont",estadosFinancierosBean.getPeriodo());
			parametrosReporte.agregaParametro("Par_FechaAlCorte",estadosFinancierosBean.getFecha());
			parametrosReporte.agregaParametro("Par_FechaFin",estadosFinancierosBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_Cifras",estadosFinancierosBean.getCifras());
			parametrosReporte.agregaParametro("Par_NumTransaccion",transaccion);
			parametrosReporte.agregaParametro("Par_Anio",anio);
			parametrosReporte.agregaParametro("Par_Mes",mes);
			parametrosReporte.agregaParametro("Par_Dia",dia);
			parametrosReporte.agregaParametro("Par_AnioFin",anioFin);
			parametrosReporte.agregaParametro("Par_MesFin",mesFin);
			parametrosReporte.agregaParametro("Par_DiaFin",diaFin);
			parametrosReporte.agregaParametro("Par_FechaSistema", estadosFinancierosBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_GerenteGral",estadosFinancierosBean.getGerenteGeneral());
			parametrosReporte.agregaParametro("Par_PresiConsejo",estadosFinancierosBean.getPresidenteConsejo());
			parametrosReporte.agregaParametro("Par_JefeContabilidad",estadosFinancierosBean.getJefeContabilidad());
			parametrosReporte.agregaParametro("Par_DirectorFinanzas", estadosFinancierosBean.getDirectorFinanzas());
			parametrosReporte.agregaParametro("Par_CCInicial",estadosFinancierosBean.getCcInicial());
			parametrosReporte.agregaParametro("Par_CCFinal",estadosFinancierosBean.getCcFinal());
			parametrosReporte.agregaParametro("Par_CCInicialDes",estadosFinancierosBean.getCcInicialDes());
			parametrosReporte.agregaParametro("Par_CCFinalDes",estadosFinancierosBean.getCcFinalDes());

			parametrosReporte.agregaParametro("Par_TipoConsulta",estadosFinancierosBean.getTipoConsulta());

		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Reporte Financiero Balance Contable", e);
		}

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public void generaReporteExcel(ReporteFinancierosBean reporteFinancierosBean,String nombreReporte,HttpServletResponse response){
		List listaConMapa = new ArrayList();
		ParametrosSesionBean parametrosSesion = null;
		try{
			parametrosSesionBean.setEmpresaID(1);
			parametrosSesion = parametrosAplicacionDAO.consultaReporteFinanciero(parametrosSesionBean, parametrosSesionBean.getOrigenDatos(), ParametrosAplicacionServicio.Enum_Con_ParAplicacion.reportesFinancieros);

			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			paramGeneralesBean = paramGeneralesServicio.consulta(ParamGeneralesServicio.Enum_Con_ParamGenerales.ConCteEspecifico, paramGeneralesBean);

			Map<String,String> mapaReporte = new HashMap<String,String>();
			switch(Utileria.convierteEntero(reporteFinancierosBean.getEstadoFinanID())){
				case Enum_Lis_ReportesFinancieros.balanceContable:
					listaConMapa = reporteFinancierosDAO.balanceGeneral(reporteFinancierosBean);
					mapaReporte = (Map<String, String>) listaConMapa.get(0);
					reporteBalanceGeneral(reporteFinancierosBean, parametrosSesion, mapaReporte, response, paramGeneralesBean);
				break;
				case Enum_Lis_ReportesFinancieros.estadoResultado:
				case Enum_Lis_ReportesFinancieros.estadoResultadoMes:
					listaConMapa = reporteFinancierosDAO.estadoResultado(reporteFinancierosBean);
					mapaReporte = (Map<String, String>) listaConMapa.get(0);
					reporteEstadoResultado(reporteFinancierosBean, parametrosSesion, mapaReporte, response, paramGeneralesBean);
				break;
				case Enum_Lis_ReportesFinancieros.estadoFlujoEfec:
					listaConMapa = reporteFinancierosDAO.flujoEfectivo(reporteFinancierosBean);
					mapaReporte = (Map<String,String>) listaConMapa.get(0);
					reporteFlujoEfectivo(reporteFinancierosBean, parametrosSesion, mapaReporte, response, paramGeneralesBean);
				break;
				case Enum_Lis_ReportesFinancieros.estadoVariacion:
					List listaCabecera = reporteFinancierosDAO.cabeceraEstadoVariacion(reporteFinancierosBean);
					List listaReporte = reporteFinancierosDAO.estadoVariacion(reporteFinancierosBean, paramGeneralesBean);
					Map<String,String> mapaCabecera = (Map<String,String>)listaCabecera.get(0);
					reporteEstadoVariacion(reporteFinancierosBean, parametrosSesion, mapaCabecera, listaReporte, response, paramGeneralesBean);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar los reportes financieros ", exception);
			exception.printStackTrace();
		}

	}

	public void reporteEstadoResultado(ReporteFinancierosBean reporteFinancierosBean, ParametrosSesionBean parametrosSesion, Map<String,String> mapaReporte, HttpServletResponse response, ParamGeneralesBean paramGeneralesBean) {

		try {

			InputStream plantilla = new FileInputStream(parametrosAuditoriaBean.getRutaReportes()+"contabilidad/LayautEstadoDeResultado.xlsx");
			XSSFWorkbook libro = (XSSFWorkbook) WorkbookFactory.create(plantilla);
			Sheet hoja = libro.getSheetAt(0);
			//AGREGAMSO EL LOGO
			if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas ){
				Utileria.agregaLogoClienteExcel(libro, parametrosAuditoriaBean.getLogoCtePantalla(),
						3,4, // DATOS DE LA COLUMNA
						0,4, // DATOS DE LA FILA
						hoja, 0
						);
			}

			for(int i = 0 ; i < 120 ; i++){
				Row fila = hoja.getRow(i);
				for(int j = 0 ; j < 20 ; j++){
					Cell celda = fila.getCell(j);
					//leemos el contenido
					if(celda != null){
						switch (celda.getCellType()) {

							case Cell.CELL_TYPE_STRING:
								String contenidoCelda = celda.getStringCellValue();

								//comparamos y remplazamosfuenteNegrita8
								contenidoCelda.indexOf("[");
								contenidoCelda.indexOf("]");
								if(contenidoCelda.indexOf("[")>-1 && contenidoCelda.indexOf("]")>-1){
									String parametroABuscar = contenidoCelda.substring(contenidoCelda.indexOf("[")+1,contenidoCelda.indexOf("]"));

									if(parametroABuscar.equals("NombreInstitucion")){
										celda.setCellValue(reporteFinancierosBean.getNombreInstitucion());
									}
									if(parametroABuscar.equals("Direccion")){
										celda.setCellValue(reporteFinancierosBean.getDirecInstitucion());
									}
									if(parametroABuscar.equals("Fecha")){
										celda.setCellValue("ESTADO DE RESULTADO AL "+Utileria.convertirFechaLetras(reporteFinancierosBean.getFecha()));
										if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
											celda.setCellValue("ESTADO DE RESULTADO");
										}
									}

									if(parametroABuscar.equals("Cifra")){
										celda.setCellValue("(Cifra en Pesos)");
										if(reporteFinancierosBean.getCifras().equalsIgnoreCase("M")){
											celda.setCellValue("(Cifra en Miles de Pesos)");
										}
									}
									if(parametroABuscar.equals("Par_GerenteGral")){
										celda.setCellValue(parametrosSesion.getGerenteGeneral());
									}
									if(parametroABuscar.equals("Par_DirectorFinanzas")){
										celda.setCellValue(parametrosSesion.getDirectorFinanzas());
									}
									if(parametroABuscar.equals("Par_JefeContabilidad")){
										celda.setCellValue(parametrosSesion.getJefeContabilidad());
									}

									Iterator valores = mapaReporte.entrySet().iterator();
									while(valores.hasNext()){
										Map.Entry<String,String> nodo = (Map.Entry<String,String>)valores.next();
										String llave = nodo.getKey();
										if(parametroABuscar.equals(llave)){
											String valor = nodo.getValue();
											//remplazo de los valores
											celda.setCellValue(Utileria.convierteDoble(valor));

											if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
												if( llave.equals("Par_FechaPeriodo") 	 || llave.equals("Par_DirectorFinanzas") ||
													llave.equals("Par_JefeContabilidad") || llave.equals("Par_GerenteGral")){
													celda.setCellValue(valor);
												}

											}
										}
									}

								}
							break;
							case Cell.CELL_TYPE_NUMERIC:
								break;
							case Cell.CELL_TYPE_BOOLEAN:
							break;
							case Cell.CELL_TYPE_BLANK:
							break;
							case Cell.CELL_TYPE_FORMULA:
							break;
							default:
							break;
						}
					}
				}
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=EstadoDeResultado.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void reporteFlujoEfectivo(ReporteFinancierosBean reporteFinancierosBean, ParametrosSesionBean parametrosSesion, Map<String,String> mapaReporte, HttpServletResponse response, ParamGeneralesBean paramGeneralesBean) {

		try {

			InputStream plantilla = new FileInputStream(parametrosAuditoriaBean.getRutaReportes()+"contabilidad/LayoutFlujoEfectivo.xlsx");
			XSSFWorkbook libro = (XSSFWorkbook) WorkbookFactory.create(plantilla);
			Sheet hoja = libro.getSheetAt(0);

			//Se agrega el Logo para el Cliente Natgas
			if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas ){
				Utileria.agregaLogoClienteExcel(libro, parametrosAuditoriaBean.getLogoCtePantalla(), 3, 4, 0, 4, hoja, 0);
			}

			for(int i = 0 ; i < 120 ; i++){
				Row fila = hoja.getRow(i);
				for(int j = 1 ; j < 20 ; j++){

					Cell celda = fila.getCell(j);
					//leemos el contenido
					if(celda != null){
						switch (celda.getCellType()) {

							case Cell.CELL_TYPE_STRING:
								//leemos el contenido
								String contenidoCelda = celda.getStringCellValue();

								//comparamos y remplazamos
								contenidoCelda.indexOf("[");
								contenidoCelda.indexOf("]");
								if(contenidoCelda.indexOf("[")>-1 && contenidoCelda.indexOf("]")>-1){
									String parametroABuscar = contenidoCelda.substring(contenidoCelda.indexOf("[")+1,contenidoCelda.indexOf("]"));

									if(parametroABuscar.equals("NombreInstitucion")){
										celda.setCellValue(reporteFinancierosBean.getNombreInstitucion());
									}
									if(parametroABuscar.equals("Direccion")){
										celda.setCellValue(reporteFinancierosBean.getDirecInstitucion());
									}
									if(parametroABuscar.equals("Fecha")){
										celda.setCellValue("ESTADO DE FLUJO DE EFECTIVO DEL 01 DE ENERO AL "+Utileria.convertirFechaLetras(reporteFinancierosBean.getFecha()));
										if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
											celda.setCellValue("ESTADO DE FLUJO DE EFECTIVO");
										}
									}
									if(parametroABuscar.equals("Cifra")){
										celda.setCellValue("(Cifra en Pesos)");
										if(reporteFinancierosBean.getCifras().equalsIgnoreCase("M")){
											celda.setCellValue("(Cifra en Miles de Pesos)");
										}
									}
									if(parametroABuscar.equals("Par_GerenteGral")){
										celda.setCellValue(parametrosSesion.getGerenteGeneral());
									}
									if(parametroABuscar.equals("Par_DirectorFinanzas")){
										celda.setCellValue(parametrosSesion.getDirectorFinanzas());
									}
									if(parametroABuscar.equals("Par_JefeContabilidad")){
										celda.setCellValue(parametrosSesion.getJefeContabilidad());
									}
									Iterator valores = mapaReporte.entrySet().iterator();
									while(valores.hasNext()){
										Map.Entry<String,String> nodo = (Map.Entry<String,String>)valores.next();
										String llave = nodo.getKey();
										if(parametroABuscar.equals(llave)){
											String valor = nodo.getValue();
											//remplazo de los valores
											celda.setCellValue(Utileria.convierteDoble(valor));
											if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas) {
												if( llave.equals("Par_FechaPeriodo") || llave.equals("Par_DirectorFinanzas") ||
													llave.equals("Par_JefeContabilidad") || llave.equals("Par_GerenteGral")){
													celda.setCellValue(valor);
												}
											}
										}
									}
								}
							break;
							case Cell.CELL_TYPE_NUMERIC:
								break;
							case Cell.CELL_TYPE_BOOLEAN:
							break;
							case Cell.CELL_TYPE_BLANK:
							break;
							case Cell.CELL_TYPE_FORMULA:
							break;
							default:
							break;
						}
					}
				}
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=FlujoEfectivo.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public void reporteBalanceGeneral(ReporteFinancierosBean reporteFinancierosBean, ParametrosSesionBean parametrosSesion, Map<String,String> mapaReporte, HttpServletResponse response, ParamGeneralesBean paramGeneralesBean) {

		try {

			InputStream plantilla = new FileInputStream(parametrosAuditoriaBean.getRutaReportes()+"contabilidad/LayoutBalanceGeneral.xlsx");
			XSSFWorkbook libro = (XSSFWorkbook) WorkbookFactory.create(plantilla);
			Sheet hoja = libro.getSheetAt(0);

			//Se agrega el Logo para el Cliente Natgas
			if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas ){
				Utileria.agregaLogoClienteExcel(libro, parametrosAuditoriaBean.getLogoCtePantalla(), 3, 4, 0, 4, hoja, 0);
			}

			for(int i = 0 ; i < 160 ; i++){
				Row fila = hoja.getRow(i);
				for(int j = 1 ; j < 25 ; j++){

					Cell celda = fila.getCell(j);
					//leemos el contenido
					if(celda != null){
						switch (celda.getCellType()) {

							case Cell.CELL_TYPE_STRING:
								String contenidoCelda = celda.getStringCellValue();

								//comparamos y remplazamos
								contenidoCelda.indexOf("[");
								contenidoCelda.indexOf("]");
								if(contenidoCelda.indexOf("[")>-1 && contenidoCelda.indexOf("]")>-1){
									String parametroABuscar = contenidoCelda.substring(contenidoCelda.indexOf("[")+1,contenidoCelda.indexOf("]"));

									if(parametroABuscar.equals("NombreInstitucion")){
										celda.setCellValue(reporteFinancierosBean.getNombreInstitucion());
									}
									if(parametroABuscar.equals("Direccion")){
										celda.setCellValue(reporteFinancierosBean.getDirecInstitucion());
									}
									if(parametroABuscar.equals("Fecha")){
										celda.setCellValue("BALANCE GENERAL AL "+Utileria.convertirFechaLetras(reporteFinancierosBean.getFecha()));
										celda.setCellValue(parametrosSesion.getGerenteGeneral());
										if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
											celda.setCellValue("BALANCE GENERAL");
										}
									}
									if(parametroABuscar.equals("Cifra")){
										celda.setCellValue("(Cifra en Pesos)");
										if(reporteFinancierosBean.getCifras().equalsIgnoreCase("M")){
											celda.setCellValue("(Cifra en Miles de Pesos)");
										}
									}
									if(parametroABuscar.equals("Par_GerenteGral")){
										celda.setCellValue(parametrosSesion.getGerenteGeneral());
									}
									if(parametroABuscar.equals("Par_DirectorFinanzas")){
										celda.setCellValue(parametrosSesion.getDirectorFinanzas());
									}
									if(parametroABuscar.equals("Par_JefeContabilidad")){
										celda.setCellValue(parametrosSesion.getJefeContabilidad());
									}
									Iterator valores = mapaReporte.entrySet().iterator();
									while(valores.hasNext()){
										Map.Entry<String,String> nodo = (Map.Entry<String,String>)valores.next();
										String llave = nodo.getKey();

										if(parametroABuscar.equals(llave)){
											String valor = nodo.getValue();
											//remplazo de los valores
											celda.setCellValue(Utileria.convierteDoble(valor));
											if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas) {
												if( llave.equals("Par_FechaPeriodo") 	 || llave.equals("Par_DirectorFinanzas") ||
													llave.equals("Par_JefeContabilidad") || llave.equals("Par_GerenteGral")){
													celda.setCellValue(valor);
												}
											}
										}
									}
								}
							break;
							case Cell.CELL_TYPE_NUMERIC:
							break;
							case Cell.CELL_TYPE_BOOLEAN:
							break;
							case Cell.CELL_TYPE_BLANK:
							break;
							case Cell.CELL_TYPE_FORMULA:
							break;
							default:
							break;
						}
					}
				}
			}
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=BalanceGeneral.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void reporteEstadoVariacion(ReporteFinancierosBean reporteFinancierosBean, ParametrosSesionBean parametrosSesion, Map<String,String> mapaCabecera, List<ReporteFinancierosBean> listaReporte, HttpServletResponse response, ParamGeneralesBean paramGeneralesBean) {

		try {

			InputStream plantilla = new FileInputStream(parametrosAuditoriaBean.getRutaReportes()+"contabilidad/LayoutEstadoVariacion.xlsx");
			XSSFWorkbook libro = (XSSFWorkbook) WorkbookFactory.create(plantilla);
			Sheet hoja = libro.getSheetAt(0);

			//Se agrega el Logo para el Cliente Natgas
			if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas ){
				Utileria.agregaLogoClienteExcel(libro, parametrosAuditoriaBean.getLogoCtePantalla(), 3, 4, 0, 4, hoja, 0);
			}

			Font fuenteNegrita= libro.createFont();
			fuenteNegrita.setFontHeightInPoints((short)18);
			fuenteNegrita.setFontName("Arial");
			fuenteNegrita.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			Font fuente= libro.createFont();
			fuente.setFontHeightInPoints((short)18);
			fuente.setFontName("Arial");
			
			CellStyle estiloNegritaCentrado = libro.createCellStyle();
			estiloNegritaCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloNegritaCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloNegritaCentrado.setFont(fuenteNegrita);
			estiloNegritaCentrado.setWrapText(true);
			
			CellStyle estiloNegrita = libro.createCellStyle();
			estiloNegrita.setFont(fuenteNegrita);
			
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita);

			CellStyle estiloFuente = libro.createCellStyle();
			estiloFuente.setFont(fuente);

			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setFont(fuente);
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));

			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimalN = libro.createCellStyle();
			estiloFormatoDecimalN.setFont(fuenteNegrita);
			DataFormat formato = libro.createDataFormat();
			estiloFormatoDecimalN.setDataFormat(formato.getFormat("$#,##0.00"));

			int filaActual = 7;
			int totalCeldas = 5+(Utileria.convierteEntero(mapaCabecera.get("NumCapitalContribuido"))+Utileria.convierteEntero(mapaCabecera.get("NumCapitalGanado")));
			for(int i = 0 ; i < 100 ; i++){
				Row fila = hoja.getRow(i);
				for(int j = 1 ; j < totalCeldas ; j++){

					Cell celda = fila.getCell(j);

					//leemos el contenido
					if(celda != null){
						switch (celda.getCellType()) {

							case Cell.CELL_TYPE_STRING:
								String contenidoCelda = celda.getStringCellValue();

								//comparamos y remplazamos
								contenidoCelda.indexOf("[");
								contenidoCelda.indexOf("]");
								if(contenidoCelda.indexOf("[")>-1 && contenidoCelda.indexOf("]")>-1){
									String parametroABuscar = contenidoCelda.substring(contenidoCelda.indexOf("[")+1,contenidoCelda.indexOf("]"));

									if(parametroABuscar.equals("NombreInstitucion")){
										celda.setCellValue(reporteFinancierosBean.getNombreInstitucion());
									}
									if(parametroABuscar.equals("Direccion")){
										celda.setCellValue(reporteFinancierosBean.getDirecInstitucion());
									}
									if(parametroABuscar.equals("Fecha")){
										celda.setCellValue("ESTADO DE VARIACIONES EN EL CAPITAL CONTABLE AL "+Utileria.convertirFechaLetras(reporteFinancierosBean.getFecha()));
										if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
											celda.setCellValue("DEL 01 DE ENERO AL "+Utileria.convertirFechaLetras(reporteFinancierosBean.getFecha()));
										}
									}
									if(parametroABuscar.equals("Cifra")){
										celda.setCellValue("(Cifra en Pesos)");
										if(reporteFinancierosBean.getCifras().equalsIgnoreCase("M")){
											celda.setCellValue("(Cifra en Miles de Pesos)");
										}
									}
									if(parametroABuscar.equals("Par_GerenteGral")){
										celda.setCellValue(parametrosSesion.getGerenteGeneral());
									}
									if(parametroABuscar.equals("Par_DirectorFinanzas")){
										celda.setCellValue(parametrosSesion.getDirectorFinanzas());
									}
									if(parametroABuscar.equals("Par_JefeContabilidad")){
										celda.setCellValue(parametrosSesion.getJefeContabilidad());
									}

									if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
										if(parametroABuscar.equals("Par_DirectorFinanzas")){
											celda.setCellValue(listaReporte.get(0).getDirectorFinanzas());
										}
										if(parametroABuscar.equals("Par_JefeContabilidad")){
											celda.setCellValue(listaReporte.get(0).getJefeContabilidad());
										}
										if(parametroABuscar.equals("Par_GerenteGral")){
											celda.setCellValue(listaReporte.get(0).getGerenteGeneral());
										}
									}
								}
								break;
							case Cell.CELL_TYPE_NUMERIC:
								break;
							case Cell.CELL_TYPE_BOOLEAN:
							break;
							case Cell.CELL_TYPE_BLANK:
							break;
							case Cell.CELL_TYPE_FORMULA:
							break;
							default:
							break;
						}
					}
				}
			}
			int numCC = Utileria.convierteEntero(mapaCabecera.get("NumCapitalContribuido"));
			int numCG = Utileria.convierteEntero(mapaCabecera.get("NumCapitalGanado"));
			int filaCabecera = filaActual;
			Row fila = hoja.getRow(filaActual);
			Cell celda =fila.createCell((short)2);
			celda.setCellValue("CAPITAL CONTRIBUIDO");
			celda.setCellStyle(estiloNegritaCentrado);
			hoja.addMergedRegion(new CellRangeAddress(
					filaActual, //first row (0-based)
					filaActual, //last row  (0-based)
					2, //first column (0-based)
					1+numCC//last column  (0-based)
			));


			celda = fila.createCell((short)2+numCC);
			celda.setCellValue("CAPITAL GANADO");
			celda.setCellStyle(estiloNegritaCentrado);
			hoja.addMergedRegion(new CellRangeAddress(
					filaActual, //first row (0-based)
					filaActual, //last row  (0-based)
					2+numCC, //first column (0-based)
					1+numCC+numCG  //last column  (0-based)
			));

			if( Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas ){
				celda = fila.createCell((short)2+numCC+numCG);
				celda.setCellValue("TOTAL CAPITAL CONTABLE");
				celda.setCellStyle(estiloNegritaCentrado);
				hoja.addMergedRegion(new CellRangeAddress(
						filaActual, //first row (0-based)
						filaActual+1, //last row  (0-based)
						2+numCC+numCG, //first column (0-based)
						2+numCC+numCG  //last column  (0-based)
				));
			}

			filaActual++;
			fila = hoja.createRow(filaActual);
			celda = fila.createCell(2);
			int contador = 3;
			int tamanioMapa = 1;

			for(int i=1;i<=mapaCabecera.size()-2;i++){
				Iterator valores = mapaCabecera.entrySet().iterator();
				while(valores.hasNext()){

					Map.Entry<String,String> nodo = (Map.Entry<String,String>)valores.next();
					String llave = nodo.getKey();

					String valor = nodo.getValue();
					//remplazo de los valores
					if(!llave.equals("NumCapitalContribuido")&&!llave.equals("NumCapitalGanado")){
						String []cabecera = valor.split("\\|");
						if(llave.equals(i+"")){
							celda.setCellValue(cabecera[3]);
							celda.setCellStyle(estiloNegritaCentrado);
							celda = fila.createCell(contador);
							contador ++;
						}

					}
				}
			}


			filaActual++;
			int contadorNegro = 0;
			for(ReporteFinancierosBean estadoVariacion : listaReporte){
				contadorNegro++;
				fila = hoja.createRow(filaActual);
				celda = fila.createCell(1);
				celda.setCellValue(estadoVariacion.getDescripcion());
				if(contadorNegro == listaReporte.size()){
					celda.setCellStyle(estiloNegrita);
				} else {
					celda.setCellStyle(estiloFuente);
				}

				hoja.addMergedRegion(new CellRangeAddress(
						filaActual, //first row (0-based)
						filaActual, //last row  (0-based)
						1, //first column (0-based)
						1  //last column  (0-based)
				));

				// aqui recorro 6 veces
				Iterator valores = mapaCabecera.entrySet().iterator();
				while(valores.hasNext()){
					int celdaActual=1;
					Map.Entry<String,String> nodo = (Map.Entry<String,String>)valores.next();
					String llave = nodo.getKey();

					String valor = nodo.getValue();
					//remplazo de los valores

					if(!llave.equals("NumCapitalContribuido")&&!llave.equals("NumCapitalGanado")){
						celdaActual = celdaActual+Utileria.convierteEntero(llave);
						String []cabecera = valor.split("\\|");
						String busca = cabecera[0];
						celda = fila.createCell(celdaActual);
						if(busca.equals(Enum_EstadoVariacion.ParticipacionControladora)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getParticipacionControladora()));
						}
						if(busca.equals(Enum_EstadoVariacion.CapitalSocial)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getCapitalSocial()));
						}
						if(busca.equals(Enum_EstadoVariacion.AportacionesCapital)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getAportacionesCapital()));
						}
						if(busca.equals(Enum_EstadoVariacion.PrimaVenta)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getPrimaVenta()));
						}
						if(busca.equals(Enum_EstadoVariacion.ObligacionesSubordinadas)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getObligacionesSubordinadas()));
						}
						if(busca.equals(Enum_EstadoVariacion.IncorporacionSocFinancieras)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getIncorporacionSocFinancieras()));
						}
						if(busca.equals(Enum_EstadoVariacion.ReservaCapital)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getReservaCapital()));
						}
						if(busca.equals(Enum_EstadoVariacion.ResultadoEjerAnterior)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getResultadoEjerAnterior()));
						}
						if(busca.equals(Enum_EstadoVariacion.ResultadoTitulosVenta)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getResultadoTitulosVenta()));
						}
						if(busca.equals(Enum_EstadoVariacion.ResultadoValuacionInstrumentos)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getResultadoValuacionInstrumentos()));
						}
						if(busca.equals(Enum_EstadoVariacion.EfectoAcomulado)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getEfectoAcomulado()));
						}
						if(busca.equals(Enum_EstadoVariacion.BeneficioEmpleados)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getBeneficioEmpleados()));
						}
						if(busca.equals(Enum_EstadoVariacion.ResultadoMonetario)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getResultadoMonetario()));
						}
						if(busca.equals(Enum_EstadoVariacion.ResultadoActivos)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getResultadoActivos()));
						}
						if(busca.equals(Enum_EstadoVariacion.ParticipacionNoControladora)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getParticipacionNoControladora()));
						}
						if(busca.equals(Enum_EstadoVariacion.CapitalContable)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getCapitalContable()));
						}
						if(busca.equals(Enum_EstadoVariacion.EfectoIncorporacion)){
							celda.setCellValue(Utileria.convierteDoble(estadoVariacion.getEfectoIncorporacion()));
						}

						if(contadorNegro == listaReporte.size()){
							celda.setCellStyle(estiloFormatoDecimalN);
						}else{
							celda.setCellStyle(estiloFormatoDecimal);
						}

						hoja.addMergedRegion(new CellRangeAddress(
								filaActual, //first row (0-based)
								filaActual, //last row  (0-based)
								celdaActual, //first column (0-based)
								celdaActual //last column  (0-based)
						));
					}
				}

				filaActual++;
				fila = hoja.createRow(filaActual);
			}

			for(int celd=0; celd<=17; celd++){
				hoja.autoSizeColumn((short)celd);
			}
			
			if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
				
				hoja.setColumnWidth(0, 1500);
				hoja.setColumnWidth(1, 26000);
				
				for(int celd = 2; celd <= mapaCabecera.size() - 1; celd++) {
					hoja.setColumnWidth(celd, 8500);
				}
				hoja.getRow(filaCabecera + 1).setHeight((short) 2900);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=EstadoVariacion.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public ReportesFinancierosDAO getReporteFinancierosDAO() {
		return reporteFinancierosDAO;
	}

	public void setReporteFinancierosDAO(ReportesFinancierosDAO reporteFinancierosDAO) {
		this.reporteFinancierosDAO = reporteFinancierosDAO;
	}

	public ParametrosAplicacionDAO getParametrosAplicacionDAO() {
		return parametrosAplicacionDAO;
	}

	public void setParametrosAplicacionDAO(
			ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

}
