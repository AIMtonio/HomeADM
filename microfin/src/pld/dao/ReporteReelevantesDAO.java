package pld.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.ArchivoReelevantesBean;
import pld.bean.ReporteReelevantesBean;
import pld.bean.ReportesSITIBean;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ReporteReelevantesDAO extends BaseDAO{

	java.sql.Date fecha = null;
	ArchivoReelevantesDAO archivoReelevantesDAO = null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;

	public ReporteReelevantesDAO() {
		super();
	}

	private final static String salidaPantalla = "S";
	private final static String tipoReporteTxt	= "1";
	private final static String tipoReporteTipoExcel = "2";

	//Query con el Store Procedure Para la consulta principal

	public ReporteReelevantesBean consultaNombArch(final ReporteReelevantesBean reporteReelevantesBean, final int tipoConsulta){
		ReporteReelevantesBean reporteBean =null;
		try {

			reporteBean = (ReporteReelevantesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PLDREPREELEVANCON(?,?,?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_FechaInicial",reporteReelevantesBean.getPeriodoInicio());
							sentenciaStore.setString("Par_FechaFinal",reporteReelevantesBean.getPeriodoFin());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							ReporteReelevantesBean reporteReelevantes = new ReporteReelevantesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								reporteReelevantes.setArchivo(resultadosStore.getString(1));

							}
							return reporteReelevantes;
						}
					});
			return reporteBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de nombre de archivo en reporte reelevante", e);
			return null;
		}
	}


	//Query con el Store Procedure Para la consulta del archivo


	public ReporteReelevantesBean consultaArch(final ReporteReelevantesBean reporteReelevantesBean, final int tipoConsulta){
		ReporteReelevantesBean reporteBean =null;
		try {

			//Query con el Store Procedure
			reporteBean = (ReporteReelevantesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PLDREPREELEVANCON(?,?,?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_FechaInicial",reporteReelevantesBean.getPeriodoInicio());
							sentenciaStore.setString("Par_FechaFinal",reporteReelevantesBean.getPeriodoFin());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							ReporteReelevantesBean reporteReelevantes = new ReporteReelevantesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								reporteReelevantes.setAux(resultadosStore.getString(1));
							}
							return reporteReelevantes;
						}
					});
			return reporteBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de archivo de reporte reelevante", e);
			return null;
		}
	}


	//Query con el Store Procedure Para la consulta generar nombre

	public ReporteReelevantesBean consultaGeneraArch(final ReporteReelevantesBean reporteReelevantesBean, final int tipoConsulta){
		ReporteReelevantesBean reporteBean =null;
		try {

			//Query con el Store Procedure
			reporteBean = (ReporteReelevantesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PLDREPREELEVANCON(?,?,?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_FechaInicial",reporteReelevantesBean.getPeriodoInicio());
							sentenciaStore.setString("Par_FechaFinal",reporteReelevantesBean.getPeriodoFin());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							ReporteReelevantesBean reporteReelevantes = new ReporteReelevantesBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								reporteReelevantes.setAuxGeneraArch(resultadosStore.getString(1));

							}
							return reporteReelevantes;
						}
					});
			return reporteBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta general de archivo en reporte reelevante", e);
			return null;
		}
	}



	public MensajeTransaccionBean altaHisRele(final ReporteReelevantesBean reporteReelevantesBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDHISREELEVANALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
									sentenciaStore.setDate("Par_FechaGeneracion",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getFechaGeneracion()));
									sentenciaStore.setInt("Par_PeriodoID",Utileria.convierteEntero(reporteReelevantesBean.getPeriodoID()));
									sentenciaStore.setDate("Par_PeriodoInicio",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getPeriodoInicio()));
									sentenciaStore.setDate("Par_PeriodoFin",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getPeriodoFin()));

									sentenciaStore.setString("Par_Archivo",reporteReelevantesBean.getArchivo());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReporteReelevantesDAO.altaHisRele");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReporteReelevantesDAO.altaHisRele");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico reelevante", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/**
	 * Pasa a la tabla histórica y a tabla de reporte cnbv todas las operaciones generadas en el periodo
	 * y genera el reporte (archivo separado por punto y coma) dependiendo del tipo de institución financiera
	 * parametrizada en INSTITUCIONES y en PARAMETROSSIS.
	 * @author avelasco
	 * @param reporteReelevantesBean : Clase bean con los parámetros de entrada al(los) SP(s).
	 * @param listaReporte : Tipo de reporte a generar (número de consulta).
	 * @return Clase bean con el mensaje generado de la transacción (MensajeTransaccionBean).
	 */
	public MensajeTransaccionBean altaHistoricoGeneraReporte(final ReporteReelevantesBean reporteReelevantesBean, final int listaReporte) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final long numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				String nombreArchivo = Constantes.STRING_VACIO;
				String rutaArchivo = Constantes.STRING_VACIO;
				List ListaOperacionParaArchivo = null;
				String tipoInstitucion = "";


				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = altaHisRele(reporteReelevantesBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					//----- se consultan los datos que se ingresaran al reporte----
					reporteReelevantesBean.setTipoReporte(tipoReporteTxt);
					ListaOperacionParaArchivo = archivoReelevantesDAO.OpeReelevantes(reporteReelevantesBean, listaReporte, numTransaccion);


					/* Se obtiene la ruta de archivos PLD que se encuentra en el servidor */
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setEmpresaID("1");
					parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.principal, parametrosSisBean);
					rutaArchivo = parametrosSisBean.getRutaArchivosPLD().trim();
					nombreArchivo = reporteReelevantesBean.getArchivo();

					/* Genera el archivo con los campos de acuerdo al tipo de institucion */
					generaArchivoOpeRelevantes(nombreArchivo,rutaArchivo, ListaOperacionParaArchivo);

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico general de reporte", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}finally{
					mensajeBean.setCampoGenerico(nombreArchivo);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param nombre : Nombre del Archivo
	 * @param rutaDestino : Ruta Destino del Archivo
	 * @param ListaOperacionParaArchivo
	 * @return
	 * @throws IOException
	 */
	public MensajeTransaccionBean generaArchivoOpeRelevantes(final String nombre, final String rutaDestino,final List ListaOperacionParaArchivo) throws IOException {

		String archivoSal = rutaDestino + nombre;

		List<ArchivoReelevantesBean> listaRee = null;

		BufferedWriter writer = null;

		try{
			writer = new BufferedWriter(new FileWriter(archivoSal));
			listaRee = ListaOperacionParaArchivo;

			if (!listaRee.isEmpty()){

				int i=1,iter=0;
				int tamanioLista=listaRee.size();
				ArchivoReelevantesBean archivoReelevantesBean = null;

				for(iter=0; iter<tamanioLista; iter ++ ){

					archivoReelevantesBean = (ArchivoReelevantesBean)listaRee.get(iter);

					writer.write(archivoReelevantesBean.getOperaRelevante());

					writer.newLine(); // Esto es un salto de linea
				}
			}else{
				writer.write("");
			}
			writer.close();
		}catch(IOException io ){
			io.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al generar archivos", io);
		}
		return null;
	}

	/**
	 * Crea un directorio si no existe y le asiga permisos especiales a un archivo específico.
	 * @param directorio : Ruta del directorio.
	 * @param rutaAbsolutaArchivo : Ruta del archivo.
	 * @throws IOException
	 * @author avelasco
	 */
	private void creaDirectorioArchivos(String directorio, String rutaAbsolutaArchivo) throws IOException{
		boolean exists = (new File(directorio)).exists();
		// Si no existe el directorio, se crea.
		if (!exists) {
			File nuevoDirectorio = new File(directorio);
			nuevoDirectorio.mkdirs();
		}
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		Process process = Runtime.getRuntime().exec("sudo "+parametros.getRutaArchivos()+"Permisos/permisosArchivos.sh " +rutaAbsolutaArchivo);
		loggerSAFI.info("sudo "+parametros.getRutaArchivos()+"Permisos/permisosArchivos.sh " +rutaAbsolutaArchivo);
	}
	/**
	 * Lista las operaciones relevantes para mostrarse en el reporte en Excel.
	 * Llama al alta de op. relevantes en el histórico y consulta las operaciones a reportar.
	 * @param reporteReelevantesBean : Clase bean con los parámetros de entrada al SP-PLDHISREELEVANALT y al SP-PLDCNBVOPEREELCON.
	 * @param listaReporte : Número de consulta de la lista de operaciones.
	 * @return List : Lista de operaciones a Reportar.
	 * @author avelasco
	 */
	public List listaReporteExcel(final ReportesSITIBean reporteReelevantesBean, final int listaReporte){
		List ListaOperacionParaArchivo = null;
		final long numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			mensajeBean = altaHisRele(reporteReelevantesBean, numTransaccion);
			if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}

			//----- se consultan los datos que se ingresaran al reporte----
			reporteReelevantesBean.setTipoReporte(tipoReporteTipoExcel);
			ListaOperacionParaArchivo = archivoReelevantesDAO.OpeReelevantesExcel(reporteReelevantesBean, listaReporte, numTransaccion);

		} catch (Exception e) {
			if(mensajeBean.getNumero()==0){
				mensajeBean.setNumero(999);
			}
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos en reporte op. relevantes: ", e);
		}
		return ListaOperacionParaArchivo;
	}


	public MensajeTransaccionBean altaHisRele(final ReportesSITIBean reporteReelevantesBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDHISREELEVANALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
									sentenciaStore.setDate("Par_FechaGeneracion",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getFechaGeneracion()));
									sentenciaStore.setInt("Par_PeriodoID",Utileria.convierteEntero(reporteReelevantesBean.getPeriodoID()));
									sentenciaStore.setDate("Par_PeriodoInicio",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getPeriodoInicio()));
									sentenciaStore.setDate("Par_PeriodoFin",OperacionesFechas.conversionStrDate(reporteReelevantesBean.getPeriodoFin()));

									sentenciaStore.setString("Par_Archivo",reporteReelevantesBean.getArchivo());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReporteReelevantesDAO.altaHisRele");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReporteReelevantesDAO.altaHisRele");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico reelevante", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public ArchivoReelevantesDAO getArchivoReelevantesDAO() {
		return archivoReelevantesDAO;
	}


	public void setArchivoReelevantesDAO(ArchivoReelevantesDAO archivoReelevantesDAO) {
		this.archivoReelevantesDAO = archivoReelevantesDAO;
	}


	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}


	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}