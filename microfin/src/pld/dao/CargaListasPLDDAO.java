package pld.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.CargaListasPLDBean;
import pld.bean.PLDListasPersBloqBean;
import seguridad.bean.ConexionOrigenDatosBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CargaListasPLDDAO extends BaseDAO {

	java.sql.Date fecha = null;
	private static final String CARGA_MASIVA = "C";

	public CargaListasPLDDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/* Alta de Carga de Archivos para listas PLD */
	public MensajeTransaccionBean alta(final CargaListasPLDBean cargaListasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CARGALISTASPLDALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoLista", cargaListasBean.getTipoLista());
									sentenciaStore.setString("Par_RutaArchivo", cargaListasBean.getRutaArchivoSubido());
									sentenciaStore.setString("Par_FechaCarga", cargaListasBean.getFechaCarga());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaListasPLDDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaListasPLDDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de carga de listas PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Actualizacion Carga de Archivos para listas PLD */
	public MensajeTransaccionBean actualiza(final CargaListasPLDBean cargaListasBean,final ParametrosAuditoriaBean parametrosAudBean, final ConexionOrigenDatosBean conexionOrigenDatosBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAudBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAudBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CARGALISTASPLDACT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_CargaListasID", cargaListasBean.getCargaListasID());
									sentenciaStore.setString("Par_TipoLista", cargaListasBean.getTipoLista());
									sentenciaStore.setInt("Par_TipoAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAudBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAudBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAudBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAudBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAudBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAudBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAudBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAudBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaListasPLDDAO.actualiza");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaListasPLDDAO.actualiza");
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
					loggerSAFI.error(parametrosAudBean.getOrigenDatos()+"-"+"error en actualizacion de carga de listas PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consulta de Carga de Archivos para listas PLD */
	public CargaListasPLDBean consulta(final CargaListasPLDBean cargaListasBean, final int tipoConsulta){

		CargaListasPLDBean cargaBean =null;
		try {
			cargaBean = (CargaListasPLDBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CARGALISTASPLDCON(?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_CargaListasID",Utileria.convierteEntero(cargaListasBean.getCargaListasID()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CargaListasPLDDAO.consulta");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							CargaListasPLDBean carga = new CargaListasPLDBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								carga.setCargaListasID(resultadosStore.getString("CargaListasID"));
								carga.setRutaArchivoSubido(resultadosStore.getString("RutaArchivo"));
								carga.setFechaCarga(resultadosStore.getString("FechaCarga"));
								carga.setEstatus(resultadosStore.getString("Estatus"));
							}
							return carga;
						}
					});
			return cargaBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de carga de listas PLD: ", e);
			return null;
		}
	}
	/**
	 * Método que procesa las listas negras y la carga a la tabla de PLDLISTANEGRAS
	 * @param cargaListasBean: Bean que tra el campo de que si incluye o no el encabezado de la lista
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean procesaListasNegras(final CargaListasPLDBean cargaListasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTANEGRASPRO("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_IncluyeEncabezado", cargaListasBean.getIncluyeEncabezado());
									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaListasNegras");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaListasPLDDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CargaListasPLDDAO.procesaListasNegras");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de carga de listas PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que procesa las listas negras y las carga a la tabla de PLDLISTASNEGRAS
	 * @param cargaListasBean: Bean que tra el campo de que si incluye o no el encabezado de la lista
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean procesaListasPersBloq(final CargaListasPLDBean cargaListasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTAPERSBLOQPRO("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_IncluyeEncabezado", cargaListasBean.getIncluyeEncabezado());
									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaListasPersBloq");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaListasPLDDAO.procesaListasNegras");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CargaListasPLDDAO.procesaListasPersBloq");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de carga de listas PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que procesa la búsqueda masiva de clientes en las listas PLD.
	 * @param cargaListasBean : Clase bean con los parámetros de entrada al SP-PLDDETECPERSPRO.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean procesaBusquedaMasiva(final CargaListasPLDBean cargaListasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDDETECPERSPRO("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoLista", cargaListasBean.getTipoLista());
									sentenciaStore.setString("Par_Masivo", cargaListasBean.getMasivo());
									sentenciaStore.setString("Par_SoloNombres", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_SoloApellidos", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_NombresConocidos", Constantes.STRING_VACIO);

									sentenciaStore.setString("Par_RFC", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_RFCm", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_TipoPersona", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_RazonSocial", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_FechaNac", Constantes.FECHA_VACIA);

									sentenciaStore.setInt("Par_PaisID", Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Par_ListaPLDID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_IDQEQ", Constantes.STRING_VACIO);
									sentenciaStore.setLong("Par_NumeroOficio", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_EstadoID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_OrigenDeteccion", CARGA_MASIVA);

									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaListasPersBloq");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaListasPLDDAO.procesaBusquedaMasiva");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CargaListasPLDDAO.procesaBusquedaMasiva");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - error en busqueda masiva en listas PLD: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}