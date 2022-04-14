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

import pld.bean.PLDListaNegrasBean;
import pld.bean.PLDListasPersBloqBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class PLDListaNegrasDAO extends BaseDAO {

	private PLDListaNegrasDAO() {
		super();
	}

	ParametrosSesionBean parametrosSesionBean = null;

	/**
	 * Método para el alta de personas en listas negras
	 * @param pldListaNegrasBean: Bean con la información de la persona a dar de alta en las listas negras PLD
	 * @param tipoAct: Tipo de Actualización (No requerido)
	 * @return
	 */
	public MensajeTransaccionBean alta(final PLDListaNegrasBean pldListaNegrasBean, final int tipoAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTANEGRASALT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_PrimerNom", pldListaNegrasBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom", pldListaNegrasBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom", pldListaNegrasBean.getTercerNombre());
									sentenciaStore.setString("Par_ApPat", pldListaNegrasBean.getApellidoPaterno());
									sentenciaStore.setString("Par_ApMat", pldListaNegrasBean.getApellidoMaterno());

									sentenciaStore.setString("Par_RFC", pldListaNegrasBean.getRFC());
									sentenciaStore.setDate("Par_FechaNac", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_NombresCon", pldListaNegrasBean.getNombresConocidos());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(pldListaNegrasBean.getPaisID()));
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(pldListaNegrasBean.getEstadoID()));

									sentenciaStore.setString("Par_TipoLista", pldListaNegrasBean.getTipoLista());
									sentenciaStore.setDate("Par_FechaAlta", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaAlta()));
									sentenciaStore.setDate("Par_FechaReactivacion", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaReactivacion()));
									sentenciaStore.setDate("Par_FechaInactivacion", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaInactivacion()));
									sentenciaStore.setString("Par_Estatus", pldListaNegrasBean.getEstatus());

									sentenciaStore.setString("Par_NumeroOficio", pldListaNegrasBean.getNumeroOficio());
									sentenciaStore.setString("Par_TipoPersona", pldListaNegrasBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial", pldListaNegrasBean.getRazonSocial());
									sentenciaStore.setString("Par_RFCm", pldListaNegrasBean.getRFCm());

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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de lista negra", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para la modificacion de personas en listas negras
	 * @param pldListaNegrasBean: Bean con la información de la persona a modificar en las listas negras PLD
	 * @return
	 */
	public MensajeTransaccionBean modificacion(final PLDListaNegrasBean pldListaNegrasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDLISTANEGRASMOD("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_ListaNegraID", Utileria.convierteLong(pldListaNegrasBean.getListaNegraID()));
									sentenciaStore.setString("Par_PrimerNom", pldListaNegrasBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom", pldListaNegrasBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom", pldListaNegrasBean.getTercerNombre());
									sentenciaStore.setString("Par_ApPat", pldListaNegrasBean.getApellidoPaterno());

									sentenciaStore.setString("Par_ApMat", pldListaNegrasBean.getApellidoMaterno());
									sentenciaStore.setString("Par_RFC", pldListaNegrasBean.getRFC());
									sentenciaStore.setDate("Par_FechaNac", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_NombresCon", pldListaNegrasBean.getNombresConocidos());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(pldListaNegrasBean.getPaisID()));

									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(pldListaNegrasBean.getEstadoID()));
									sentenciaStore.setString("Par_TipoLista", pldListaNegrasBean.getTipoLista());
									sentenciaStore.setDate("Par_FechaAlta", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaAlta()));
									sentenciaStore.setDate("Par_FechaReactivacion", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaReactivacion()));
									sentenciaStore.setDate("Par_FechaInactivacion", OperacionesFechas.conversionStrDate(pldListaNegrasBean.getFechaInactivacion()));

									sentenciaStore.setString("Par_Estatus", pldListaNegrasBean.getEstatus());
									sentenciaStore.setString("Par_NumeroOficio",pldListaNegrasBean.getNumeroOficio());
									sentenciaStore.setString("Par_TipoPersona", pldListaNegrasBean.getTipoPersona());
									sentenciaStore.setString("Par_RazonSocial", pldListaNegrasBean.getRazonSocial());
									sentenciaStore.setString("Par_RFCm", pldListaNegrasBean.getRFCm());

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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de lista negra", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta de personas en listas negras
	 * @param pldListaNegrasBean: Bean con el ID para la consulta de listas negras
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public PLDListaNegrasBean consultaPrincipal(final PLDListaNegrasBean pldListaNegrasBean, int tipoConsulta) {
		String query = "call PLDLISTANEGRASCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {

				pldListaNegrasBean.getListaNegraID(),
				tipoConsulta,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PLDListaNegrasDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDLISTANEGRASCON(" + Arrays.toString(parametros) + ");");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PLDListaNegrasBean listasNegras = new PLDListaNegrasBean();

				listasNegras.setListaNegraID(resultSet.getString("ListaNegraID"));
				listasNegras.setPrimerNombre(resultSet.getString("PrimerNombre"));
				listasNegras.setSegundoNombre(resultSet.getString("SegundoNombre"));
				listasNegras.setTercerNombre(resultSet.getString("TercerNombre"));
				listasNegras.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				listasNegras.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				listasNegras.setRFC(resultSet.getString("RFC"));
				listasNegras.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				listasNegras.setNombresConocidos(resultSet.getString("NombresConocidos"));
				listasNegras.setPaisID(resultSet.getString("PaisID"));
				listasNegras.setEstadoID(resultSet.getString("EstadoID"));
				listasNegras.setTipoLista(resultSet.getString("TipoLista"));
				listasNegras.setFechaAlta(resultSet.getString("FechaAlta"));
				listasNegras.setFechaReactivacion(resultSet.getString("FechaReactivacion"));
				listasNegras.setFechaInactivacion(resultSet.getString("FechaInactivacion"));
				listasNegras.setEstatus(resultSet.getString("Estatus"));
				listasNegras.setNumeroOficio(resultSet.getString("NumeroOficio"));
				listasNegras.setTipoPersona(resultSet.getString("TipoPersona"));
				listasNegras.setRazonSocial(resultSet.getString("RazonSocial"));
				listasNegras.setRFCm(resultSet.getString("RFCm"));
				return listasNegras;
			}
		});
		return matches.size() > 0 ? (PLDListaNegrasBean) matches.get(0) : null;
	}

	/**
	 * Lista principal para personas en listas negras
	 * @param tipoLista: Numero de lista
	 * @param pldListaNegrasBean: Bean con el primer nombre para filtrar la lista
	 * @return
	 */
	public List listaPrincipal(int tipoLista, final PLDListaNegrasBean pldListaNegrasBean) {
		List listaPrincipal = null;
		try {
			String query = "call PLDLISTANEGRASLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					pldListaNegrasBean.getPrimerNombre(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PLDListaNegrasDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDLISTANEGRASLIS(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					PLDListaNegrasBean listasNegras = new PLDListaNegrasBean();
					listasNegras.setListaNegraID(resultSet.getString("ListaNegraID"));
					listasNegras.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return listasNegras;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista negra", e);
		}
		return listaPrincipal;

	}

	/**
	 * CONSULTA PARA LA RELACION DE UN CLIENTE
	 * @param pldListaNegrasBean: Bean con la informacion para listar a las personas en listas negras
	 * @param tipoConsulta: Numero de consulta
	 * @return
	 */
	public PLDListaNegrasBean consultaPrincipalClie(final PLDListaNegrasBean pldListaNegrasBean, int tipoConsulta) {
		String query = "call PLDCLIENLISNEGRASCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {

				pldListaNegrasBean.getListaNegraID(),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PLDListasNegrasDAO.consultaEstaListNegra",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()

		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDCLIENLISNEGRASCON(" + Arrays.toString(parametros).replace("[", "]") + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PLDListaNegrasBean listasNegras = new PLDListaNegrasBean();
				listasNegras.setEsListaNegra(resultSet.getString("EsListaNegra"));
				listasNegras.setCoincidencia(resultSet.getString("Coincidencia"));

				return listasNegras;
			}
		});
		return matches.size() > 0 ? (PLDListaNegrasBean) matches.get(0) : null;
	}

	public JSONArray consultaDatosLev(final PLDListaNegrasBean listasBean, final int tipoConsulta, final long numTransaccion){
		JSONArray resultadoStore = null;
		try {
			resultadoStore = (JSONArray)
				((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDLISTANEGRASCON(" +
													"?,?,?,?,?,	" +
													"?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_ListaNegraID",Utileria.convierteLong(listasBean.getListaNegraID()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setString("Par_TipoPersona", listasBean.getTipoPersona());
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","PLDListaNegrasDAO.consultaDatosLev");
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
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}