package pld.dao;

import general.bean.MensajeTransaccionBean;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


import pld.bean.CatDestinoRecursosBean;
import pld.bean.CatOrigenRecursosBean;
import pld.bean.PerfilTransaccionalBean;

public class PerfilTransaccionalDAO extends BaseDAO {


	public MensajeTransaccionBean graba(final PerfilTransaccionalBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDPERFILTRANSACCIONALALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(bean.getClienteID()));
							sentenciaStore.setInt("Par_UsuarioServicioID", Utileria.convierteEntero(bean.getUsuarioID()));
							sentenciaStore.setDouble("Par_DepositosMax", Utileria.convierteDoble(bean.getDepositosMax()));
							sentenciaStore.setDouble("Par_RetirosMax", Utileria.convierteDoble(bean.getRetirosMax()));
							sentenciaStore.setInt("Par_NumDepositos", Utileria.convierteEntero(bean.getNumDepositos()));
							sentenciaStore.setInt("Par_NumRetiros", Utileria.convierteEntero(bean.getNumRetiros()));
							sentenciaStore.setInt("Par_CatOrigenRecID", Utileria.convierteEntero(bean.getOrigenRecursos()));
							sentenciaStore.setInt("Par_CatDestinoRecID", Utileria.convierteEntero(bean.getDestinoRecursos()));
							sentenciaStore.setString("Par_ComentarioOrigenRec", bean.getComentarioOrigenRec());
							sentenciaStore.setString("Par_ComentarioDestRec", bean.getComentarioDestRec());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta del Perfil Transaccional. ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final PerfilTransaccionalBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDPERFILTRANSACCIONALMOD("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(bean.getClienteID()));
							sentenciaStore.setInt("Par_UsuarioServicioID", Utileria.convierteEntero(bean.getUsuarioID()));
							sentenciaStore.setDouble("Par_DepositosMax", Utileria.convierteDoble(bean.getDepositosMax()));
							sentenciaStore.setDouble("Par_RetirosMax", Utileria.convierteDoble(bean.getRetirosMax()));
							sentenciaStore.setInt("Par_NumDepositos", Utileria.convierteEntero(bean.getNumDepositos()));
							sentenciaStore.setInt("Par_NumRetiros", Utileria.convierteEntero(bean.getNumRetiros()));
							sentenciaStore.setInt("Par_CatOrigenRecID", Utileria.convierteEntero(bean.getOrigenRecursos()));
							sentenciaStore.setInt("Par_CatDestinoRecID", Utileria.convierteEntero(bean.getDestinoRecursos()));
							sentenciaStore.setString("Par_ComentarioOrigenRec", bean.getComentarioOrigenRec());
							sentenciaStore.setString("Par_ComentarioDestRec", bean.getComentarioDestRec());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion del Perfil Transaccional del Cliente.", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

public PerfilTransaccionalBean consultaPrincipalCliente(final PerfilTransaccionalBean bean,final int tipoConsulta) {

		PerfilTransaccionalBean perfilTransaccionalBean = new PerfilTransaccionalBean();

		try {
			String query = "call PLDPERFILTRANSACCIONALCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
				bean.getClienteID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PerfilTransaccionalDAO.consultaPrincipalCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSACCIONALCON(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));
					lista.setOrigenRecursos(resultSet.getString("CatOrigenRecID"));
					lista.setDestinoRecursos(resultSet.getString("CatDestinoRecID"));
					lista.setComentarioOrigenRec(resultSet.getString("ComentarioOrigenRec"));
					lista.setComentarioDestRec(resultSet.getString("ComentarioDestRec"));
					return lista;
				}
			});

			if (matches.size() > 0) {
                perfilTransaccionalBean  = (PerfilTransaccionalBean) matches.get(0);
            }

		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta del perfil transaccional del cliente: ", e);
            perfilTransaccionalBean = null;
		}

		return perfilTransaccionalBean;
	}

	/**
	* Método para consultar perfil transaccional del usuario de servicios.
	* @param tipoConsulta : Número de consulta 3. Consulta principal para perfil transaccional de usuario de servicios.
	* @param conocimientoUsuarioBean : Bean con los datos necesarios del usuario de servicios a consultar.
	* @return {@link PerfilTransaccionalBean}.
	*/
	public PerfilTransaccionalBean consultaPrincipalUsuario(final PerfilTransaccionalBean perfilBean,final int tipoConsulta) {

		PerfilTransaccionalBean perfilTransaccionalBean = new PerfilTransaccionalBean();

		try {
			String query = "call PLDPERFILTRANSACCIONALCON(?,?, ?,?,?,?,?,?,?);";

			Object[] parametros = {
				Utileria.convierteEntero(perfilBean.getUsuarioID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PerfilTransaccionalDAO.consultaPrincipalUsuario",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSACCIONALCON(" + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setUsuarioID(resultSet.getString("UsuarioServicioID"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));
					lista.setOrigenRecursos(resultSet.getString("CatOrigenRecID"));
					lista.setDestinoRecursos(resultSet.getString("CatDestinoRecID"));
					lista.setComentarioOrigenRec(resultSet.getString("ComentarioOrigenRec"));
					lista.setComentarioDestRec(resultSet.getString("ComentarioDestRec"));
					return lista;
				}
			});

			if (matches.size() > 0) {
                perfilTransaccionalBean  = (PerfilTransaccionalBean) matches.get(0);
            }

		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta del perfil transaccional del usuario de servicios: ", e);
            perfilTransaccionalBean = null;
		}

		return perfilTransaccionalBean;
	}
	
	@SuppressWarnings("unchecked")
	public List<PerfilTransaccionalBean> listaHistoricaCliente(PerfilTransaccionalBean bean,final int tipoLista) {
		List<PerfilTransaccionalBean> matches = null;
		try {
			String query = "call PLDPERFILTRANSACCIONALLIS("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?);";
			Object[] parametros = {
					tipoLista, bean.getClienteID(),
					bean.getSucursalID(),
					bean.getFechaIncio(),
					bean.getFechaFin(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PerfilTransaccionalDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSACCIONALLIS(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));
					lista.setOrigenRecursos(resultSet.getString("CatOrigenRecID"));
					lista.setDescripcionOrigen(resultSet.getString("DescripcionOrigen"));
					lista.setDestinoRecursos(resultSet.getString("CatDestinoRecID"));
					lista.setDescripcionDestino(resultSet.getString("DescripcionDestino"));
					lista.setComentarioOrigenRec(resultSet.getString("ComentarioOrigenRec"));
					lista.setComentarioDestRec(resultSet.getString("ComentarioDestRec"));
					lista.setFecha(resultSet.getString("Fecha"));
					lista.setHora(resultSet.getString("Hora"));
					lista.setTipoProceso(resultSet.getString("TipoProceso"));

					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista historica del cliente. ", ex);
		}
		return matches;
	}

		@SuppressWarnings("unchecked")
	public List<PerfilTransaccionalBean> listaHistoricaUsuario(PerfilTransaccionalBean bean,final int tipoLista) {
		List<PerfilTransaccionalBean> matches = null;
		try {
			String query = "call PLDPERFILTRANSACCIONALLIS("
							+ "?,?,?,?,?,"
							+ "?,?,?,?,?,"
							+ "?,?);";
			Object[] parametros = {
					tipoLista, bean.getUsuarioID(),
					bean.getSucursalID(),
					bean.getFechaIncio(),
					bean.getFechaFin(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PerfilTransaccionalDAO.lista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSACCIONALLIS(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setUsuarioID(resultSet.getString("UsuarioServicioID"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));
					lista.setOrigenRecursos(resultSet.getString("CatOrigenRecID"));
					lista.setDescripcionOrigen(resultSet.getString("DescripcionOrigen"));
					lista.setDestinoRecursos(resultSet.getString("CatDestinoRecID"));
					lista.setDescripcionDestino(resultSet.getString("DescripcionDestino"));
					lista.setComentarioOrigenRec(resultSet.getString("ComentarioOrigenRec"));
					lista.setComentarioDestRec(resultSet.getString("ComentarioDestRec"));
					lista.setFecha(resultSet.getString("Fecha"));
					lista.setHora(resultSet.getString("Hora"));
					lista.setTipoProceso(resultSet.getString("TipoProceso"));

					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista hostorica del usuario de servicios. ", ex);
		}
		return matches;
	}
	public List<PerfilTransaccionalBean> listaAut(PerfilTransaccionalBean bean,final int tipoLista) {
		List<PerfilTransaccionalBean> matches = null;
		try {
			String query = "call PLDPERFILTRANSACCIONALLIS("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?);";
			Object[] parametros = {
					tipoLista, bean.getClienteID(),
					bean.getSucursalID(),
					OperacionesFechas.conversionStrDate(bean.getFechaIncio()),
					OperacionesFechas.conversionStrDate(bean.getFechaFin()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PerfilTransaccionalDAO.listaAut",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSACCIONALLIS(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setFecha(resultSet.getString("Fecha"));
					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setNombreCompleto(resultSet.getString("NombreCompleto"));
					lista.setNombreSucursal(resultSet.getString("NombreSucursal"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));

					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista PLD", ex);
		}
		return matches;
	}


	public List listaComboOrigenRec(int tipoLista) {
		List matches = null;
		try {
			String query = "call CATPLDORIGENRECLIS(" + "?,?,?,?,?,		" + "?,?,?);";
			Object[] parametros = {tipoLista, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "PerfilTransaccionalDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATPLDORIGENRECLIS(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatOrigenRecursosBean lista = new CatOrigenRecursosBean();

					lista.setCatOrigenRecID(resultSet.getString("CatOrigenRecID"));
					lista.setDescripcion(resultSet.getString("Descripcion"));
					lista.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista combo de Origen de los Recursos.", ex);
		}
		return matches;
	}

	public List listaComboDestinoRec(int tipoLista) {
		List matches = null;
		try {
			String query = "call CATPLDDESTINORECLIS(" + "?,?,?,?,?,		" + "?,?,?);";
			Object[] parametros = {tipoLista, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "PerfilTransaccionalDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATPLDDESTINORECLIS(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatDestinoRecursosBean lista = new CatDestinoRecursosBean();

					lista.setCatDestinoRecID(resultSet.getString("CatDestinoRecID"));
					lista.setDescripcion(resultSet.getString("Descripcion"));
					lista.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista combo de Destino de los Recursos.", ex);
		}
		return matches;
	}

	public MensajeTransaccionBean actualizacion(final List<PerfilTransaccionalBean> listaDetalles, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					for (PerfilTransaccionalBean detalle : listaDetalles) {
						mensajeBean = grabaDetalle(detalle, tipoTransaccion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en grabar detalle:", e);
					return mensajeBean;
				}
				return mensajeBean;
			}



		});
		return mensajeTransaccion;
	}

	private MensajeTransaccionBean grabaDetalle(final PerfilTransaccionalBean detalle, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "CALL PLDPERFILTRANSACCIONALACT("
									+ "?,?,?,?,?,	"
									+ "?,?,?,?,?,	"
									+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(detalle.getClienteID()));
							sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(detalle.getFecha()));
							sentenciaStore.setString("Par_AutoRec", detalle.getEstatus());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
						mensajeBean.setNombreControl("grabar");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Actualización del Perfil Transaccional: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<PerfilTransaccionalBean> listaReporte(PerfilTransaccionalBean bean,final int tipoLista) {
		List<PerfilTransaccionalBean> matches = null;
		try {
			String query = "call PLDPERFILTRANSREP("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?);";
			Object[] parametros = {

					OperacionesFechas.conversionStrDate(bean.getFechaInicio()),
					OperacionesFechas.conversionStrDate(bean.getFechaFinal()),
					bean.getSucursalID(),
					bean.getClienteID(),
					bean.getTipoPersona(),

					bean.getEstatus(),
					bean.getTipoProceso(),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,

					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PerfilTransaccionalDAO.listaReporte",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSREP(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setFecha(resultSet.getString("Fecha"));
					lista.setHora(resultSet.getString("Hora"));
					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setNombreCompleto(resultSet.getString("NombreCompleto"));
					lista.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
					lista.setNombreSucurs(resultSet.getString("NombreSucurs"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setAntDepositosMax(resultSet.getString("AntDepositosMax"));
					lista.setPorcExcDepo(resultSet.getString("PorcExcDepo"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setAntRetirosMax(resultSet.getString("AntRetirosMax"));
					lista.setRetirosExc(resultSet.getString("RetirosExc"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setAntNumDepositos(resultSet.getString("AntNumDepositos"));
					lista.setNumDepEx(resultSet.getString("NumDepEx"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));
					lista.setAntNumRetiros(resultSet.getString("AntNumRetiros"));
					lista.setNumRetEx(resultSet.getString("NumRetEx"));
					lista.setEstatus(resultSet.getString("Estatus"));
					lista.setTipoProceso(resultSet.getString("TipoProceso"));
					lista.setNivelRiesgo(resultSet.getString("NivelRiesgo"));

					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista Reporte de PLD", ex);
		}
		return matches;
	}

	public List repPerfilTransaccional(PerfilTransaccionalBean bean, int tipoLista) {
		// TODO Auto-generated method stub
		List<PerfilTransaccionalBean> matches = null;
		try {
			String query = "call PLDPERFILTRANSREP("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?);";
			Object[] parametros = {

					OperacionesFechas.conversionStrDate(bean.getFechaInicio()),
					OperacionesFechas.conversionStrDate(bean.getFechaFinal()),
					bean.getSucursalID(),
					bean.getClienteID(),
					Constantes.STRING_VACIO,

					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,

					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PerfilTransaccionalDAO.listaReporteAut",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPERFILTRANSREP(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PerfilTransaccionalBean lista = new PerfilTransaccionalBean();

					lista.setFecha(resultSet.getString("Fecha"));
					lista.setClienteID(resultSet.getString("ClienteID"));
					lista.setNombreCompleto(resultSet.getString("NombreCompleto"));
					lista.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
					lista.setNombreSucurs(resultSet.getString("NombreSucursal"));
					lista.setDepositosMax(resultSet.getString("DepositosMax"));
					lista.setRetirosMax(resultSet.getString("RetirosMax"));
					lista.setNumDepositos(resultSet.getString("NumDepositos"));
					lista.setNumRetiros(resultSet.getString("NumRetiros"));

					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista Reporte de PLD", ex);
		}
		return matches;
	}

}
