package buroCredito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import buroCredito.bean.SolBuroCreditoBean;

public class SolBuroCreditoDAO extends BaseDAO  {
	ParametrosSesionBean parametrosSesionBean;
	public SolBuroCreditoDAO() {
		super();
	}

	/**
	 * Validacion de buro de credito
	 * @param solBuroCreditoBean
	 * @return
	 */
	public MensajeTransaccionBean validacionesBuroCredito(final SolBuroCreditoBean solBuroCreditoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BUROCREDITOVAL(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_ApellidoPaterno", solBuroCreditoBean.getApellidoPaterno());
							sentenciaStore.setString("Par_ApellidoMaterno", solBuroCreditoBean.getApellidoMaterno());
							sentenciaStore.setString("Par_PrimerNombre", solBuroCreditoBean.getPrimerNombre());
							sentenciaStore.setString("Par_SegundoNombre", solBuroCreditoBean.getSegundoNombre());
							sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());

							sentenciaStore.setString("Par_FechaNacimiento", solBuroCreditoBean.getFechaNacimiento());
							sentenciaStore.setString("Par_Calle", solBuroCreditoBean.getCalle());
							sentenciaStore.setString("Par_Manzana", solBuroCreditoBean.getManzana());
							sentenciaStore.setString("Par_Lote", solBuroCreditoBean.getLote());
							sentenciaStore.setString("Par_NumeroExt", solBuroCreditoBean.getNumeroExterior());

							sentenciaStore.setString("Par_NumeroInt", solBuroCreditoBean.getNumeroInterior());
							sentenciaStore.setString("Par_NombreColonia", solBuroCreditoBean.getNombreColonia());
							sentenciaStore.setString("Par_NombreMunicipio", solBuroCreditoBean.getNombreMuni());
							sentenciaStore.setString("Par_ClaveEstado", solBuroCreditoBean.getClaveEstado());
							sentenciaStore.setString("Par_CP", solBuroCreditoBean.getCP());

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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de respuesta buro", e);
		}
		return mensajeBean;
	}

	/**
	 * Alta de respuesta de buró de crédito
	 * @param solBuroCreditoBean
	 * @return
	 */
	public MensajeTransaccionBean altaRespuestaBuro(final SolBuroCreditoBean solBuroCreditoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLBUROCREDITOALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());
									sentenciaStore.setString("Par_FechaConsul", Utileria.convierteFecha(solBuroCreditoBean.getFechaConsulta()));
									sentenciaStore.setString("Par_PrimerNomb", solBuroCreditoBean.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNomb", solBuroCreditoBean.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNomb", solBuroCreditoBean.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat", solBuroCreditoBean.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat", solBuroCreditoBean.getApellidoMaterno());
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(solBuroCreditoBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(solBuroCreditoBean.getMunicipioID()));
									sentenciaStore.setString("Par_Calle", solBuroCreditoBean.getCalle());
									sentenciaStore.setString("Par_NumExterior", solBuroCreditoBean.getNumeroExterior());
									sentenciaStore.setString("Par_NumInterior", solBuroCreditoBean.getNumeroInterior());
									sentenciaStore.setString("Par_Piso", solBuroCreditoBean.getPiso());
									sentenciaStore.setString("Par_Colonia", solBuroCreditoBean.getNombreColonia());
									sentenciaStore.setString("Par_CP", solBuroCreditoBean.getCP());
									sentenciaStore.setString("Par_Lote", solBuroCreditoBean.getLote());
									sentenciaStore.setString("Par_Manzana", solBuroCreditoBean.getManzana());
									sentenciaStore.setString("Par_FechaNac", Utileria.convierteFecha(solBuroCreditoBean.getFechaNacimiento()));
									sentenciaStore.setString("Par_TipoAlta", solBuroCreditoBean.getTipoAlta());
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(solBuroCreditoBean.getLocalidadID()));

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
									solBuroCreditoBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de respuesta buro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Actualizacion del folio de solicitud BC en tabla respuesta de buró de crédito
	 * @param solBuroCreditoBean Bean que trae la informacion de la solicitud de buro de credito
	 * @param tipoActualizacion Actualizacion 1
	 * @return retorna el mensaje de exito
	 */
	public MensajeTransaccionBean actualizaFolioSolicitudBC(final SolBuroCreditoBean solBuroCreditoBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLBUROCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());
									sentenciaStore.setString("Par_FolioConsul", solBuroCreditoBean.getFolioConsulta());
									sentenciaStore.setLong("Par_NumTransacc", Utileria.convierteLong(solBuroCreditoBean.getNumTransaccion()));
									sentenciaStore.setInt("Par_Tipo", tipoActualizacion);
									sentenciaStore.setLong("Par_SolicitudCre", Utileria.convierteLong(solBuroCreditoBean.getSolicitudCreditoID()));


									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(solBuroCreditoBean.getNumTransaccion()));
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actualiza folio de solicitud BC", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consuta Solicitud por Llave Principal
	 * @param solBuroCreditoBean
	 * @param tipoConsulta
	 * @return
	 */
	public SolBuroCreditoBean consultaPrincipal(SolBuroCreditoBean solBuroCreditoBean,
			int tipoConsulta) {

		// Query con el Store Procedure
		String query = "call SOLBUROCREDITOCON(?,?,?,?,?, ?,?,?,?,?);";

		Object[] parametros = { solBuroCreditoBean.getFolioConsulta(),
				Constantes.STRING_VACIO,
				tipoConsulta,
				solBuroCreditoBean.getEmpresaID(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setRFC(resultSet.getString(1));
				solBuroCreditoBean.setFechaConsulta(resultSet.getString(2));
				solBuroCreditoBean.setPrimerNombre(resultSet.getString(3));
				solBuroCreditoBean.setSegundoNombre(resultSet.getString(4));
				solBuroCreditoBean.setTercerNombre(resultSet.getString(5));
				solBuroCreditoBean.setApellidoPaterno(resultSet.getString(6));
				solBuroCreditoBean.setApellidoMaterno(resultSet.getString(7));
				solBuroCreditoBean.setEstadoID(String.valueOf(resultSet.getInt(8)));
				solBuroCreditoBean.setLocalidadID(String.valueOf(resultSet.getInt(9)));
				solBuroCreditoBean.setMunicipioID(String.valueOf(resultSet.getInt(10)));
				solBuroCreditoBean.setCalle(resultSet.getString(11));
				solBuroCreditoBean.setNumeroExterior(resultSet.getString(12));
				solBuroCreditoBean.setNumeroInterior(resultSet.getString(13));
				solBuroCreditoBean.setPiso(resultSet.getString(14));
				solBuroCreditoBean.setNombreColonia(resultSet.getString(15));
				solBuroCreditoBean.setCP(resultSet.getString(16));
				solBuroCreditoBean.setLote(resultSet.getString(17));
				solBuroCreditoBean.setManzana(resultSet.getString(18));
				solBuroCreditoBean.setFechaNacimiento(resultSet.getString(19));
				solBuroCreditoBean.setFolioConsulta(resultSet.getString(20));
				solBuroCreditoBean.setDiasVigencia(String.valueOf(resultSet.getInt(21)));
				solBuroCreditoBean.setClaveUsuariob(resultSet.getString("Clave"));

				return solBuroCreditoBean;

			}
		});

		return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
	}

	/**
	 * Consulta se utiliza en la pantalla de Ratios para consultar si el cliente
	 * ya se le realizo la consulta de Buro de crédito, se realiza usando el RFC
	 * del cliente
	 *
	 * @param solBuroCreditoBean
	 *            Bean con los datos para consultar, obligatorio el RFC
	 * @param tipoConsulta
	 *            Numero de consulta:3
	 * @return Retorna el bean con los datos de la consulta de buro
	 */
	public SolBuroCreditoBean consultaFolio(SolBuroCreditoBean solBuroCreditoBean, int tipoConsulta) {
		try {
			String query = "call SOLBUROCREDITOCON(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = { Constantes.STRING_VACIO,
					solBuroCreditoBean.getRFC(),
					tipoConsulta,
					solBuroCreditoBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try {
						SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
						solBuroCreditoBean.setFolioConsulta(resultSet.getString(1));
						solBuroCreditoBean.setFechaConsulta(resultSet.getString(2));
						solBuroCreditoBean.setDiasVigencia(resultSet.getString(3));

						return solBuroCreditoBean;
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					return null;
				}
			});
			return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/**
	 * Lista los folios que se han generado de las consultas a Buro o Circulo de
	 * Credito, dependiendo
	 * @param solBuroCreditoBean
	 * @param tipoLista
	 * @return
	 */
	public List listaSolBuroCredito(SolBuroCreditoBean solBuroCreditoBean, int tipoLista) {
		String query = "call SOLBUROCREDITOLIS(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				solBuroCreditoBean.getNombreCompleto(),
				solBuroCreditoBean.getUsuarioID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setFolioConsulta(resultSet.getString(1));
				solBuroCreditoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				solBuroCreditoBean.setRFC(resultSet.getString("RFC"));
				solBuroCreditoBean.setFechaConsulta(resultSet.getString("FechaConsulta"));

				return solBuroCreditoBean;
			}
		});
		return matches;

	}

	/**
	 * Lista los titulares o avales de una solicitud de credito
	 * @param solBuroCreditoBean
	 * @param tipoLista
	 * @return
	 */
	public List listaBuroCreditoPorSol(SolBuroCreditoBean solBuroCreditoBean, int tipoLista) {
		String query = "caLL BUROCREDITOLIS (" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				solBuroCreditoBean.getFolioConsulta(),
				solBuroCreditoBean.getUsuarioID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call BUROCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setRelacion(resultSet.getString("Relacion"));
				solBuroCreditoBean.setAvalID(resultSet.getString("AvalID"));
				solBuroCreditoBean.setRegistroID(resultSet.getString("ClienteID"));
				solBuroCreditoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				solBuroCreditoBean.setRFC(resultSet.getString("RFC"));
				solBuroCreditoBean.setFolioConsulta(resultSet.getString("FolioConsulta"));
				solBuroCreditoBean.setFechaConsulta(resultSet.getString("FechaConsulta"));
				solBuroCreditoBean.setProspectoID(resultSet.getString("ProspectoID"));
				solBuroCreditoBean.setDiasVigencia(resultSet.getString("DiasVigencia"));
				solBuroCreditoBean.setCalle(resultSet.getString("Calle"));
				solBuroCreditoBean.setEstadoID(resultSet.getString("EstadoID"));
				solBuroCreditoBean.setMunicipioID(resultSet.getString("MunicipioID"));
				solBuroCreditoBean.setCP(resultSet.getString("CP"));
				solBuroCreditoBean.setOficial(resultSet.getString("Oficial"));
				solBuroCreditoBean.setFolioConsultaC(resultSet.getString("FolioCirculo"));
				solBuroCreditoBean.setFechaConsultaC(resultSet.getString("FechaCirculo"));
				solBuroCreditoBean.setDiasVigenciaC(resultSet.getString("DiasVigenciaC"));
				solBuroCreditoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				solBuroCreditoBean.setRealizaConsultasCC(resultSet.getString("RealizaConsultasCC"));
				solBuroCreditoBean.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
				return solBuroCreditoBean;
			}
		});
		return matches;
	}

	/**
	 * Actualizacion del folio BC de solicitud asincronamente
	 * @param solBuroCreditoBean
	 * @param tipoActualizacion
	 * @return
	 */
	public MensajeTransaccionBean actualizaFolioAsincronoBC(final SolBuroCreditoBean solBuroCreditoBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call SOLBUROCREDITOAACT(?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());
									sentenciaStore.setLong("Par_NumTransacc", Utileria.convierteLong(solBuroCreditoBean.getNumTransaccion()));
									sentenciaStore.setString("Par_FolioConsul", solBuroCreditoBean.getFolioConsulta());
									sentenciaStore.setInt("Par_Tipo", (tipoActualizacion));

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actualiza folio de solicitud BC", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Metodo de Actualizacion del folio CC de solicitud asincronamente
	 * @param solBuroCreditoBean
	 * @param tipoActualizacion
	 * @return
	 */
	public MensajeTransaccionBean actualizaFolioAsincronoCC(final SolBuroCreditoBean solBuroCreditoBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									//
									String query = "call SOLBUROCREDITOAACT(?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());
									sentenciaStore.setDouble("Par_NumTransacc", Utileria.convierteDoble(solBuroCreditoBean.getNumTransaccion()));
									sentenciaStore.setString("Par_FolioConsul", solBuroCreditoBean.getFolioConsultaC());
									sentenciaStore.setInt("Par_Tipo", (tipoActualizacion));

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actualiza folio de solicitud CC", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Actualización del folio de solicitud CC en tabla respuesta de circulo de crédito.
	 * @param solBuroCreditoBean : Clase bean con los valores a los parametros de entrada al SP-SOLBUROCREDITOACT.
	 * @param tipoActualizacion : Número de Actualización 2. Circulo de Crédito.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizaFolioSolicitudCC(final SolBuroCreditoBean solBuroCreditoBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLBUROCREDITOACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_RFC", solBuroCreditoBean.getRFC());
									sentenciaStore.setLong("Par_NumTransacc", Utileria.convierteLong(solBuroCreditoBean.getNumTransaccion()));
									sentenciaStore.setString("Par_FolioConsul", solBuroCreditoBean.getFolioConsultaC());
									sentenciaStore.setInt("Par_Tipo", (tipoActualizacion));
									sentenciaStore.setLong("Par_SolicitudCre", Utileria.convierteLong(solBuroCreditoBean.getSolicitudCreditoID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(solBuroCreditoBean.getFolioConsultaC()));
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + " error en actualiza folio de solicitud CC: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consuta el folio maximo
	 * @param solBuroCreditoBean
	 * @param tipoConsulta
	 * @return
	 */
	public SolBuroCreditoBean consultaFolioCirc(SolBuroCreditoBean solBuroCreditoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SOLBUROCREDITOCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { solBuroCreditoBean.getFolioConsulta(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setFolioConsultaC(resultSet.getString(1));

				return solBuroCreditoBean;

			}
		});

		return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
	}

	/**
	 * Consuta Solicitud por Llave Principal
	 * @param solBuroCreditoBean
	 * @param tipoConsulta
	 * @return
	 */
	public SolBuroCreditoBean consultaporFolioCirculo(SolBuroCreditoBean solBuroCreditoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SOLBUROCREDITOCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = { solBuroCreditoBean.getFolioConsultaC(),
				Constantes.STRING_VACIO,
				tipoConsulta,
				solBuroCreditoBean.getEmpresaID(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setRFC(resultSet.getString(1));
				solBuroCreditoBean.setFechaConsulta(resultSet.getString(2));
				solBuroCreditoBean.setPrimerNombre(resultSet.getString(3));
				solBuroCreditoBean.setSegundoNombre(resultSet.getString(4));
				solBuroCreditoBean.setTercerNombre(resultSet.getString(5));
				solBuroCreditoBean.setApellidoPaterno(resultSet.getString(6));
				solBuroCreditoBean.setApellidoMaterno(resultSet.getString(7));
				solBuroCreditoBean.setEstadoID(String.valueOf(resultSet.getInt(8)));
				solBuroCreditoBean.setLocalidadID(String.valueOf(resultSet.getInt(9)));
				solBuroCreditoBean.setMunicipioID(String.valueOf(resultSet.getInt(10)));
				solBuroCreditoBean.setCalle(resultSet.getString(11));
				solBuroCreditoBean.setNumeroExterior(resultSet.getString(12));
				solBuroCreditoBean.setNumeroInterior(resultSet.getString(13));
				solBuroCreditoBean.setPiso(resultSet.getString(14));
				solBuroCreditoBean.setNombreColonia(resultSet.getString(15));
				solBuroCreditoBean.setCP(resultSet.getString(16));
				solBuroCreditoBean.setLote(resultSet.getString(17));
				solBuroCreditoBean.setManzana(resultSet.getString(18));
				solBuroCreditoBean.setFechaNacimiento(resultSet.getString(19));
				solBuroCreditoBean.setFolioConsulta(resultSet.getString(20));
				solBuroCreditoBean.setDiasVigencia(String.valueOf(resultSet.getInt(21)));
				solBuroCreditoBean.setUsuario(resultSet.getString("UsuarioCirculo"));
				solBuroCreditoBean.setClaveUsuario(resultSet.getString("Clave"));
				return solBuroCreditoBean;
			}
		});
		return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
	}

	/**
	 * Consuta Solicitud por RFC
	 * @param solBuroCreditoBean
	 * @param tipoConsulta
	 * @return
	 */
	public SolBuroCreditoBean consultaporRFC(SolBuroCreditoBean solBuroCreditoBean, int tipoConsulta) {

		// Query con el Store Procedure
		String query = "call SOLBUROCREDITOCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = { Constantes.STRING_VACIO,
				solBuroCreditoBean.getRFC(),
				tipoConsulta,
				Utileria.convierteEntero(solBuroCreditoBean.getEmpresaID()),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
				solBuroCreditoBean.setFolioConsultaC(resultSet.getString("FolioConsultaC"));
				solBuroCreditoBean.setFechaConsulta(resultSet.getString("FechaConsulta"));
				solBuroCreditoBean.setDiasVigencia(resultSet.getString("DiasVigencia"));
				solBuroCreditoBean.setConsecutivoFol(resultSet.getString("ConsecutivoFol"));
				return solBuroCreditoBean;

			}
		});
		return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
	}

   /**
    * Consulta ocupada en la pantalla del Calculo del Ratios
    * @param solBuroCreditoBean Clase bean con los valores con los parametros de entrada al SP - SOLBUROCREDITOCON
    * @param tipoConsulta Número de Consulta 5
    * @return SolBuroCreditoBean Clase Bean con el resultado de la consulta
    */
	public SolBuroCreditoBean consultaporGeneral(SolBuroCreditoBean solBuroCreditoBean, int tipoConsulta) {
		try {
			// Query con el Store Procedure
			String query = "call SOLBUROCREDITOCON("
					+ "?,?,?,?,?,     "
					+ "?,?,?,?,?);";
			Object[] parametros = { Constantes.STRING_VACIO,
					solBuroCreditoBean.getRFC(),
					tipoConsulta,
					solBuroCreditoBean.getEmpresaID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLBUROCREDITOCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SolBuroCreditoBean solBuroCreditoBean = new SolBuroCreditoBean();
					try {
						solBuroCreditoBean.setFolioConsultaC(resultSet.getString("FolioConsulta"));
						solBuroCreditoBean.setFechaConsulta(resultSet.getString("FechaConsulta"));
						solBuroCreditoBean.setDiasVigencia(resultSet.getString("DiasVigencia"));
						solBuroCreditoBean.setAdeudoTotal(resultSet.getString("DeudaTotBuro"));
						solBuroCreditoBean.setCalificacionMOP(resultSet.getString("CalificaBuro"));
					} catch (Exception ex) {
						loggerSAFI.info("Error en SolBuroCreditoDAO.consultaporGeneral:" + ex.getMessage());
						ex.printStackTrace();
						return null;
					}
					return solBuroCreditoBean;

				}
			});
			return matches.size() > 0 ? (SolBuroCreditoBean) matches.get(0) : null;
		} catch (Exception ex) {
			loggerSAFI.info("Error en SolBuroCreditoDAO.consultaporGeneral:" + ex.getMessage());
			ex.printStackTrace();
		}
		return null;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}

