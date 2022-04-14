package cliente.dao;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClienteBean;
import cliente.bean.IdentifiClienteBean;

public class IdentifiClienteDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public IdentifiClienteDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	/* Alta de identificación del Cliente */

	public MensajeTransaccionBean alta(final IdentifiClienteBean identifiCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call IDENTIFICLIENTEALT(?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?,  ?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(identifiCliente.getClienteID()));
									sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(identifiCliente.getTipoIdentiID()));
									sentenciaStore.setString("Par_Oficial",identifiCliente.getOficial());
									sentenciaStore.setString("Par_NumIndentif",identifiCliente.getNumIdentific());
									sentenciaStore.setString("Par_FecExIden",Utileria.convierteFecha(identifiCliente.getFecExIden()));
									sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(identifiCliente.getFecVenIden()));

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","IdentifiClienteDAO.alta");
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2),parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .IdentifiClienteDAO.alta");
									}
									return mensajeTransaccion;
								}
							});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .IdentifiClienteDAO.alta");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de identificacion de clientes", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/**
	 * Baja de identificacion del Cliente
	 * @param identifiCliente : {@link IdentifiClienteBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean baja(final IdentifiClienteBean identifiCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call IDENTIFICLIENTEBAJ(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(identifiCliente.getClienteID()));
								sentenciaStore.setInt("Par_IdentificID",Utileria.convierteEntero(identifiCliente.getIdentificID()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "IdentifiClienteDAO.baja");

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2),parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al dar de Baja una Identificacion.", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al dar de Baja una Identificacion." + ex.getMessage());
		}
		return mensaje;
	}

	/**
	 * Modificación de Identificación del Cliente
	 * @param identifiCliente : {@link IdentifiClienteBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean modifica(final IdentifiClienteBean identifiCliente){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call IDENTIFICLIENTEMOD(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(identifiCliente.getClienteID()));
								sentenciaStore.setInt("Par_IdentificID",Utileria.convierteEntero(identifiCliente.getIdentificID()));
								sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(identifiCliente.getTipoIdentiID()));
								sentenciaStore.setString("Par_Oficial",identifiCliente.getOficial());
								sentenciaStore.setString("Par_NumIndentif",identifiCliente.getNumIdentific());
								sentenciaStore.setDate("Par_FecExIden",OperacionesFechas.conversionStrDate(identifiCliente.getFecExIden()));
								sentenciaStore.setDate("Par_FecVenIden",OperacionesFechas.conversionStrDate(identifiCliente.getFecVenIden()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_IdenID", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "IdentifiClienteDAO.modifica");
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2),parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al Modificar Identificacion.", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Modificar Identificacion: " + ex.getMessage());
		}
		return mensaje;
	}

	public MensajeTransaccionBean modificaReplica(final IdentifiClienteBean identifiCliente, final String origenReplica){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(new TransactionCallback<Object>() {
				@SuppressWarnings({ "unchecked", "rawtypes" })
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call IDENTIFICLIENTEMOD(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(identifiCliente.getClienteID()));
								sentenciaStore.setInt("Par_IdentificID",Utileria.convierteEntero(identifiCliente.getIdentificID()));
								sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(identifiCliente.getTipoIdentiID()));
								sentenciaStore.setString("Par_Oficial",identifiCliente.getOficial());
								sentenciaStore.setString("Par_NumIndentif",identifiCliente.getNumIdentific());
								sentenciaStore.setDate("Par_FecExIden",OperacionesFechas.conversionStrDate(identifiCliente.getFecExIden()));
								sentenciaStore.setDate("Par_FecVenIden",OperacionesFechas.conversionStrDate(identifiCliente.getFecVenIden()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_IdenID", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "IdentifiClienteDAO.modifica");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(origenReplica + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2),parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
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
						loggerSAFI.error(origenReplica + "-" + "Error al Modificar Identificacion.", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Modificar Identificacion: " + ex.getMessage());
		}
		return mensaje;
	}

	/* Consuta de identificación del Cliente por Llave Principal*/

	public IdentifiClienteBean consultaPrincipal(IdentifiClienteBean identifiCliente, int tipoConsulta){

		String query = "call IDENTIFICLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {Utileria.convierteEntero(identifiCliente.getClienteID()),
							   Utileria.convierteEntero(identifiCliente.getIdentificID()),
							   Constantes.ENTERO_CERO,
							   tipoConsulta,
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO,
							   Constantes.FECHA_VACIA,
							   Constantes.STRING_VACIO,
							   "IdentifiClienteDAO.consultaPrincipal",
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDENTIFICLIENTECON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				IdentifiClienteBean identifiCliente = new IdentifiClienteBean();
				identifiCliente.setClienteID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				identifiCliente.setIdentificID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(2),3)));
				identifiCliente.setTipoIdentiID(String.valueOf(resultSet.getInt(3)));
				identifiCliente.setDescripcion(resultSet.getString(4));
				identifiCliente.setOficial(resultSet.getString(5));
				identifiCliente.setNumIdentific(resultSet.getString(6));
				identifiCliente.setFecExIden(resultSet.getString(7));
				identifiCliente.setFecVenIden(resultSet.getString(8));

				return identifiCliente;
			}
		});

		return matches.size() > 0 ? (IdentifiClienteBean) matches.get(0) : null;

		}

	//consulta Foranea de Identificaciones del cliente

	public IdentifiClienteBean consultaForanea(IdentifiClienteBean identifiCliente, int tipoConsulta) {

		String query = "call IDENTIFICLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(identifiCliente.getClienteID()),
								Utileria.convierteEntero(identifiCliente.getIdentificID()),
				 				Constantes.ENTERO_CERO,
				 				tipoConsulta,
				 				Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"IdentifiClienteDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDENTIFICLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				IdentifiClienteBean identifiCliente = new IdentifiClienteBean();

				identifiCliente.setIdentificID(resultSet.getString(1));
				identifiCliente.setTipoIdentiID(resultSet.getString(2));

					return identifiCliente;

			}
		});
		return matches.size() > 0 ? (IdentifiClienteBean) matches.get(0) : null;

	}

	public IdentifiClienteBean consultaIdentiOficial(IdentifiClienteBean identifi, int tipoConsulta){
		String query = "call IDENTIFICLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {Utileria.convierteEntero(identifi.getClienteID()),
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO,
							   tipoConsulta,
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO,
							   Constantes.FECHA_VACIA,
							   Constantes.STRING_VACIO,
							   "IdentifiClienteDAO.consultaIdentiOficial",
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDENTIFICLIENTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				IdentifiClienteBean identifiCliente = new IdentifiClienteBean();
				identifiCliente.setIdentificID(resultSet.getString(1));
				identifiCliente.setTipoIdentiID(resultSet.getString(2));
				identifiCliente.setClienteID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				identifiCliente.setOficial(resultSet.getString(4));
				identifiCliente.setNumIdentific(resultSet.getString(5));
				identifiCliente.setFecExIden(resultSet.getString(6));
				identifiCliente.setFecVenIden(resultSet.getString(7));
				return identifiCliente;
			}
		});

		return matches.size() > 0 ? (IdentifiClienteBean) matches.get(0) : null;

	}


	public IdentifiClienteBean consultaTieneTipoIden(IdentifiClienteBean identifi, int tipoConsulta){
		String query = "call IDENTIFICLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {Utileria.convierteEntero(identifi.getClienteID()),
							   Constantes.ENTERO_CERO,
							   Utileria.convierteEntero(identifi.getTipoIdentiID()),
							   tipoConsulta,
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO,
							   Constantes.FECHA_VACIA,
							   Constantes.STRING_VACIO,
							   "IdentifiClienteDAO.consultaTipoNumeroIdenti",
							   Constantes.ENTERO_CERO,
							   Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDENTIFICLIENTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				IdentifiClienteBean identifiCliente = new IdentifiClienteBean();
				identifiCliente.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
				identifiCliente.setIdentificID(resultSet.getString(2));
				identifiCliente.setTipoIdentiID(resultSet.getString(3));
				identifiCliente.setNumIdentific(resultSet.getString(4));
				return identifiCliente;
			}
		});

		return matches.size() > 0 ? (IdentifiClienteBean) matches.get(0) : null;

	}


	/* Lista de Identificacion del cliente */

	public List lista(IdentifiClienteBean identifiCliente, int tipoLista){
		String query = "call IDENTIFICLIENTELIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	identifiCliente.getClienteID(),
								identifiCliente.getDescripcion(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"IdentifiClienteDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDENTIFICLIENTELIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				IdentifiClienteBean identifiCliente = new IdentifiClienteBean();
				identifiCliente.setIdentificID(String.valueOf(resultSet.getInt(1)));
				identifiCliente.setDescripcion(resultSet.getString(2));

				return identifiCliente;

			}
		});
		return matches;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}

