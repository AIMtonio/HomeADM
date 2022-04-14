package pld.dao;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.OpeInusualesBean;
import pld.bean.PLDListasPersBloqBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class PLDListasPersBloqDAO extends BaseDAO {

	private PLDListasPersBloqDAO() {
		super();
	}

	ParametrosSesionBean parametrosSesionBean = null;

	/**
	 * Método para el alta de personas en listas de personas bloqueadas
	 * @param pldListasBean:Bean con la información de la persona a dar de alta en las listas de personas bloqueadas
	 * @param tipoAct: Tipo de actualizacion
	 * @return
	 */
	public MensajeTransaccionBean alta(final PLDListasPersBloqBean pldListasBean, final int tipoAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTAPERSBLOQALT("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_PrimerNom", pldListasBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom", pldListasBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom", pldListasBean.getTercerNombre());
									sentenciaStore.setString("Par_ApPat", pldListasBean.getApellidoPaterno());
									sentenciaStore.setString("Par_ApMat", pldListasBean.getApellidoMaterno());

									sentenciaStore.setString("Par_RFC", pldListasBean.getRFC());
									sentenciaStore.setDate("Par_FechaNac", OperacionesFechas.conversionStrDate(pldListasBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_NombresCon", pldListasBean.getNombresConocidos());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(pldListasBean.getPaisID()));
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(pldListasBean.getEstadoID()));

									sentenciaStore.setString("Par_TipoPersona", pldListasBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial", pldListasBean.getRazonSocial());
									sentenciaStore.setString("Par_RFCm", pldListasBean.getRFCm());
									sentenciaStore.setString("Par_TipoLista", pldListasBean.getTipoLista());
									sentenciaStore.setDate("Par_FechaAlta", OperacionesFechas.conversionStrDate(pldListasBean.getFechaAlta()));

									sentenciaStore.setDate("Par_FechaReactivacion", OperacionesFechas.conversionStrDate(pldListasBean.getFechaReactivacion()));
									sentenciaStore.setDate("Par_FechaInactivacion", OperacionesFechas.conversionStrDate(pldListasBean.getFechaInactivacion()));
									sentenciaStore.setString("Par_Estatus", pldListasBean.getEstatus());
									sentenciaStore.setString("Par_NumeroOficio", pldListasBean.getNumeroOficio());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de listas de personas bloqueadas: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para la modificacion de personas en listas de personsas bloqueadas
	 * @param pldListasBean: Bean con la información de la persona a modificar en las listas personas bloqueadas de PLD
	 * @return
	 */
	public MensajeTransaccionBean modificacion(final PLDListasPersBloqBean pldListasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTAPERSBLOQMOD("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_PersonaBloqID", Utileria.convierteLong(pldListasBean.getPersonaBloqID()));
									sentenciaStore.setString("Par_PrimerNom", pldListasBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom", pldListasBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom", pldListasBean.getTercerNombre());
									sentenciaStore.setString("Par_ApPat", pldListasBean.getApellidoPaterno());

									sentenciaStore.setString("Par_ApMat", pldListasBean.getApellidoMaterno());
									sentenciaStore.setString("Par_RFC", pldListasBean.getRFC());
									sentenciaStore.setDate("Par_FechaNac", OperacionesFechas.conversionStrDate(pldListasBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_NombresCon", pldListasBean.getNombresConocidos());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(pldListasBean.getPaisID()));

									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(pldListasBean.getEstadoID()));
									sentenciaStore.setString("Par_TipoPersona", pldListasBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial", pldListasBean.getRazonSocial());
									sentenciaStore.setString("Par_RFCm", pldListasBean.getRFCm());
									sentenciaStore.setString("Par_TipoLista", pldListasBean.getTipoLista());

									sentenciaStore.setDate("Par_FechaAlta", OperacionesFechas.conversionStrDate(pldListasBean.getFechaAlta()));
									sentenciaStore.setDate("Par_FechaReactivacion", OperacionesFechas.conversionStrDate(pldListasBean.getFechaReactivacion()));
									sentenciaStore.setDate("Par_FechaInactivacion", OperacionesFechas.conversionStrDate(pldListasBean.getFechaInactivacion()));
									sentenciaStore.setString("Par_Estatus", pldListasBean.getEstatus());
									sentenciaStore.setString("Par_NumeroOficio", pldListasBean.getNumeroOficio());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en modificacion de listas de personas bloqueadas: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Generación de Alerta Inusual, Alerta de Correo y Seguimiento de Operación.
	 * @param pldListasBean Bean {@linkplain OpeInusualesBean} con la información de la persona detectada.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean generaAlertaInus(final OpeInusualesBean pldListasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDDETECLISTASLVPRO(	"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_ListaID", Utileria.convierteLong(pldListasBean.getListaID()));
									sentenciaStore.setInt("Par_TipoLista", Utileria.convierteEntero(pldListasBean.getTipoLista()));
									sentenciaStore.setString("Par_TipoListaID", pldListasBean.getTipoListaID());
									sentenciaStore.setInt("Par_ClavePersonaInv", Utileria.convierteEntero(pldListasBean.getClavePersonaInv()));
									sentenciaStore.setString("Par_PrimerNombre", pldListasBean.getPrimerNombre());

									sentenciaStore.setString("Par_SegundoNombre", pldListasBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre", pldListasBean.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPaterno", pldListasBean.getApPaternoPersonaInv());
									sentenciaStore.setString("Par_ApellidoMaterno", pldListasBean.getApMaternoPersonaInv());
									sentenciaStore.setString("Par_RFC", pldListasBean.getrFC());

									sentenciaStore.setString("Par_FechaNacimiento", pldListasBean.getFechaNacimiento());
									sentenciaStore.setString("Par_NombreCompleto", pldListasBean.getNombreCompleto());
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(pldListasBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(pldListasBean.getPaisID()));
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(pldListasBean.getEstadoID()));

									sentenciaStore.setString("Par_TipoPersSAFI", pldListasBean.getTipoPersonaSAFI());
									sentenciaStore.setString("Par_TipoPersona", pldListasBean.getTipoPersona());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.registerOutParameter("Par_Coincidencias", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_PersonaBloqID", Types.BIGINT);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==Constantes.DETECCION_PLD){ // Error 50 que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"- [LV] Error en Alta de Alerta Inusual: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operacion, el Cliente hizo coincidencia con la Listas de Personas Bloqueadas.");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "- [LV] Error en Alta de Alerta Inusual: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta principal en pantalla de registro en la lista de personas bloqueadas
	 * @param pldListasBean:Bean con el ID para la consulta de listas negras
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public PLDListasPersBloqBean consultaPrincipal(final PLDListasPersBloqBean pldListasBean, int tipoConsulta) {
		String query = "call PLDLISTAPERSBLOQCON(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
				pldListasBean.getPersonaBloqID(),
				tipoConsulta,
				Constantes.STRING_VACIO, // Par_TipoPersSAFI
				Constantes.STRING_VACIO, // Par_TipoPersona
				Constantes.ENTERO_CERO, // Par_CuentaAhoID
				Constantes.ENTERO_CERO, // Par_CreditoID

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PLDListasPersBloqDAO.consultaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDLISTAPERSBLOQCON(" + Arrays.toString(parametros) + ");");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PLDListasPersBloqBean listasPersBloq = new PLDListasPersBloqBean();

				listasPersBloq.setPersonaBloqID(resultSet.getString("PersonaBloqID"));
				listasPersBloq.setPrimerNombre(resultSet.getString("PrimerNombre"));
				listasPersBloq.setSegundoNombre(resultSet.getString("SegundoNombre"));
				listasPersBloq.setTercerNombre(resultSet.getString("TercerNombre"));
				listasPersBloq.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				listasPersBloq.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				listasPersBloq.setRFC(resultSet.getString("RFC"));
				listasPersBloq.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				listasPersBloq.setNombresConocidos(resultSet.getString("NombresConocidos"));
				listasPersBloq.setPaisID(resultSet.getString("PaisID"));
				listasPersBloq.setEstadoID(resultSet.getString("EstadoID"));
				listasPersBloq.setTipoPersona(resultSet.getString("TipoPersona"));
				listasPersBloq.setRazonSocial(resultSet.getString("RazonSocial"));
				listasPersBloq.setRFCm(resultSet.getString("RFCm"));
				listasPersBloq.setTipoLista(resultSet.getString("TipoLista"));
				listasPersBloq.setFechaAlta(resultSet.getString("FechaAlta"));
				listasPersBloq.setFechaReactivacion(resultSet.getString("FechaReactivacion"));
				listasPersBloq.setFechaInactivacion(resultSet.getString("FechaInactivacion"));
				listasPersBloq.setEstatus(resultSet.getString("Estatus"));
				listasPersBloq.setNumeroOficio(resultSet.getString("NumeroOficio"));
				return listasPersBloq;
			}
		});
		return matches.size() > 0 ? (PLDListasPersBloqBean) matches.get(0) : null;
	}

	// Consulta para saber si la persona se encuentra en la lista de pers. bloqueadas
	public PLDListasPersBloqBean consultaEstaBloq(final PLDListasPersBloqBean pldListasBean, int tipoConsulta) {
		String query = "call PLDLISTAPERSBLOQCON(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
				pldListasBean.getPersonaBloqID(),
				tipoConsulta,
				pldListasBean.getTipoPers(),
				pldListasBean.getTipoPersona(),
				pldListasBean.getCuentaAhoID(),
				pldListasBean.getCreditoID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PLDListasPersBloqDAO.consultaEstaBloq",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDLISTAPERSBLOQCON(" + Arrays.toString(parametros) + ");");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PLDListasPersBloqBean listasPersBloq = new PLDListasPersBloqBean();
				listasPersBloq.setEstaBloqueado(resultSet.getString("EstaBloqueado"));
				listasPersBloq.setCoincidencia(resultSet.getString("Coincidencia"));
				return listasPersBloq;
			}
		});
		return matches.size() > 0 ? (PLDListasPersBloqBean) matches.get(0) : null;
	}

	/**
	 * Consulta principal en pantalla de registro en la lista de personas bloqueadas
	 * @param pldListasBean:Bean con el ID para la consulta de listas negras
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public JSONArray consultaDatosLev(final PLDListasPersBloqBean listasBean, final int tipoConsulta, final long numTransaccion){
		JSONArray resultadoStore = null;
		try {
			resultadoStore = (JSONArray)
				((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDLISTAPERSBLOQCON(" +
													"?,?,?,?,?,	" +
													"?,?,?,?,?,	" +
													"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_PersonaBloqID",Utileria.convierteLong(listasBean.getPersonaBloqID()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setString("Par_TipoPersSAFI",listasBean.getTipoPers());
							sentenciaStore.setString("Par_TipoPersona", listasBean.getTipoPersona());
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(listasBean.getCuentaAhoID()));

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(listasBean.getCreditoID()));
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());

							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","PLDListasPersBloqDAO.consultaDatosLev");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							JSONArray json = new JSONArray();
							ResultSet resultadosStore = null;
							if(callableStatement.execute()){
								resultadosStore = callableStatement.getResultSet();
								ResultSetMetaData rsmd = resultadosStore.getMetaData();
								while(resultadosStore.next()) {
									int numColumns = rsmd.getColumnCount();
									JSONObject obj = new JSONObject();
									for (int i=1; i<=numColumns; i++) {
										String column_name = rsmd.getColumnLabel(i);
										obj.put(column_name, resultadosStore.getString(i));
									}
									json.put(obj);
								}
							}
							return json;
						}
					});
			return resultadoStore;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta (consultaDatosLev): ", e);
			return null;
		}
	}

	public List listaPrincipal(int tipoLista, final PLDListasPersBloqBean pldListasBean) {
		List listaPrincipal = null;
		try {
			String query = "call PLDLISTAPERSBLOQLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					pldListasBean.getPrimerNombre(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PLDListasPersBloqDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDLISTAPERSBLOQLIS(" + Arrays.toString(parametros) + ");");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PLDListasPersBloqBean listasPersBloq = new PLDListasPersBloqBean();
					listasPersBloq.setPersonaBloqID(resultSet.getString("PersonaBloqID"));
					listasPersBloq.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return listasPersBloq;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en lista principal de listas de personas bloqueadas: ", e);
		}
		return listaPrincipal;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}