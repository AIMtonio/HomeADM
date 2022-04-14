package nomina.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


import nomina.bean.NominaCondicionCredBean;
import nomina.bean.CondicionProductoNominaBean;


import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class NominaCondicionCredDAO  extends BaseDAO  {

	public List<?> listaGridNomCondicionCred(int tipoLista, NominaCondicionCredBean nominaCondicionCredBean) {
		List<?> lista = null;
		try {
			String query = "CALL NOMCONDICIONCREDLIS (?,?,?,?,?," +
													"?,?,?,?,?);";
			Object[] parametros = {
					nominaCondicionCredBean.getInstitNominaID(),
					nominaCondicionCredBean.getConvenioNominaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaCondicionCredDAO.listaGridNomCondicionCred",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMCONDICIONCREDLIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NominaCondicionCredBean resultado = new NominaCondicionCredBean();
					resultado.setCondicionCredID(resultSet.getString("CondicionCredID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					resultado.setTipoTasa(resultSet.getString("TipoTasa"));
					resultado.setValorTasa(resultSet.getString("ValorTasa"));
					resultado.setTipoCobMora(resultSet.getString("TipoCobMora"));
					resultado.setValorMora(resultSet.getString("ValorMora"));
					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de condiciones de producto de crédito", e);
		}
		return lista;
	}

	public MensajeTransaccionBean guardarCondicionesCredito(final CondicionProductoNominaBean condicionProductoNominaBean, final ArrayList<NominaCondicionCredBean> condiciones){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{

					for (int i = 0; i < condiciones.size(); i++) {
						NominaCondicionCredBean condicion = condiciones.get(i);
						condicion.setConvenioNominaID(condicionProductoNominaBean.getConvenioNominaID());
						condicion.setInstitNominaID(condicionProductoNominaBean.getInstitNominaID());
						int condicionID = Utileria.convierteEntero(condicion.getCondicionCredID());


						if(condicionID == Constantes.ENTERO_CERO){
							mensajeBean = altaNomCondicionCred(condicion);
							if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
								throw new Exception(mensajeBean.getDescripcion());
							}

						}else if(condicionID > Constantes.ENTERO_CERO){
							mensajeBean = modificarNomCondicionCred(condicion);

							if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
								throw new Exception(mensajeBean.getDescripcion());
							}

						}

					}

					NominaCondicionCredBean beanBaja = new NominaCondicionCredBean();
					beanBaja.setConvenioNominaID(condicionProductoNominaBean.getConvenioNominaID());
					beanBaja.setInstitNominaID(condicionProductoNominaBean.getInstitNominaID());
						mensajeBean = bajaNomCondicionesCred(beanBaja);

						if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
							mensajeBean.setDescripcion("Condiciones de crédito guardados exitosamente");
							mensajeBean.setNombreControl("convenioNominaID");
							mensajeBean.setConsecutivoInt(condicionProductoNominaBean.getConvenioNominaID());
						}


				}catch (Exception e) {
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("agrega");
					mensajeBean.setConsecutivoString("0");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de condiciones de crédito:", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});

		return mensajeResultado;

	}

	// metodo para modificar condicion de credito
	public MensajeTransaccionBean modificarNomCondicionCred(final NominaCondicionCredBean nominaCondicionCredBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL NOMCONDICIONCREDMOD (?,?,?,?,?," +
																			"?,?,?,"+
																			"?,?,?,"+
																			"?,?,?,?,?," +
																			"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CondicionCredID", Utileria.convierteLong(nominaCondicionCredBean.getCondicionCredID()));
									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_ConvenioNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getConvenioNominaID()));
									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(nominaCondicionCredBean.getProducCreditoID()));
									sentenciaStore.setString("Par_TipoTasa", nominaCondicionCredBean.getTipoTasa());

									sentenciaStore.setDouble("Par_ValorTasa", Utileria.convierteDoble(nominaCondicionCredBean.getValorTasa()));
									sentenciaStore.setString("Par_TipoCobMora", nominaCondicionCredBean.getTipoCobMora());
									sentenciaStore.setDouble("Par_ValorMora", Utileria.convierteDoble(nominaCondicionCredBean.getValorMora()));

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NominaCondicionCredDAO.modificarNomCondicionCred");

									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "NominaCondicionCredDAO.modificarNomCondicionCred");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NominaCondicionCredDAO.modificarNomCondicionCred");
					} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + " Error al modificar condición de crédito" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Metodo para dar de alta una condicion de credito
		public MensajeTransaccionBean altaNomCondicionCred(final NominaCondicionCredBean nominaCondicionCredBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Stored Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "CALL NOMCONDICIONCREDALT (?,?,?,?,?," +
																				 "?,?,"+
																				 "?,?,?,?,?," +
																				 "?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getInstitNominaID()));
										sentenciaStore.setInt("Par_ConvenioNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getConvenioNominaID()));
										sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(nominaCondicionCredBean.getProducCreditoID()));
										sentenciaStore.setString("Par_TipoTasa", nominaCondicionCredBean.getTipoTasa());
										sentenciaStore.setDouble("Par_ValorTasa",Utileria.convierteDoble(nominaCondicionCredBean.getValorTasa()));

										sentenciaStore.setString("Par_TipoCobMora", nominaCondicionCredBean.getTipoCobMora());
										sentenciaStore.setDouble("Par_ValorMora",Utileria.convierteDoble(nominaCondicionCredBean.getValorMora()));

										sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID", "NominaCondicionCredDAO.altaNomCondicionCred");
										sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
										return sentenciaStore;
									}
								}, new CallableStatementCallback<Object>() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
									DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if (callableStatement.execute()) {
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
											mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										} else {
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NominaCondicionCredDAO.altaNomCondicionCred");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								}
								);
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " NominaCondicionCredDAO.altaNomCondicionCred");
						} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al registrar condición de crédito" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// CONSULTA DEL VALOR DE TASA DE UNA CONDICION
		public NominaCondicionCredBean consultaValorTasa(int tipoConsulta, NominaCondicionCredBean nominaCondicionCredBean) {
			NominaCondicionCredBean registro = null;
			try {
				String query = "CALL NOMCONDICIONCREDCON (?,?,?,?,?,"
														+ "	?,?,?,?,?,"
														+ " ?,?);";
				Object[] parametros = {

						Utileria.convierteLong(nominaCondicionCredBean.getCondicionCredID()),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"NominaCondicionCredDAO.consultaValorTasa",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMCONDICIONCREDCON (" + Arrays.toString(parametros) + ")");
				List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						NominaCondicionCredBean resultado = new NominaCondicionCredBean();

						resultado.setValorTasa(resultSet.getString("ValorTasa"));
						return resultado;
					}
				});
				registro = matches.size() > 0 ? (NominaCondicionCredBean) matches.get(0) : null;
			} catch(Exception e) {
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta el valor Tasa", e);
			}

			return registro;
		}

		// CONSULTA LA CANTIDAD DE ESQUEMAS DE TASAS QUE TIENE LA CONDICION
		public NominaCondicionCredBean consultaCantEsquema(int tipoConsulta, NominaCondicionCredBean nominaCondicionCredBean) {
			NominaCondicionCredBean registro = null;
			try {
				String query = "CALL NOMCONDICIONCREDCON (?,?,?,?,?,"
														+ "	?,?,?,?,?,"
														+ " ?,?);";
				Object[] parametros = {

						Utileria.convierteLong(nominaCondicionCredBean.getCondicionCredID()),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"NominaCondicionCredDAO.consultaCantEsquema",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMCONDICIONCREDCON (" + Arrays.toString(parametros) + ")");
				List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						NominaCondicionCredBean resultado = new NominaCondicionCredBean();

						resultado.setCantidad(resultSet.getString("Cantidad"));
						return resultado;
					}
				});
				registro = matches.size() > 0 ? (NominaCondicionCredBean) matches.get(0) : null;
			} catch(Exception e) {
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta el valor Tasa", e);
			}

			return registro;
		}


		// CONSULTA DEL NUMERO DE COINCIDENCIAS QUE TIENE LA CONDICION
				public NominaCondicionCredBean conCoincidenciaCondicion(int tipoConsulta, NominaCondicionCredBean nominaCondicionCredBean) {
					NominaCondicionCredBean registro = null;
					try {
						String query = "CALL NOMCONDICIONCREDCON (?,?,?,?,?,"
																+ "	?,?,?,?,?,"
																+ " ?,?);";
						Object[] parametros = {

								Utileria.convierteLong(nominaCondicionCredBean.getCondicionCredID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"NominaCondicionCredDAO.conCoincidenciaCondicion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

						loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMCONDICIONCREDCON (" + Arrays.toString(parametros) + ")");
						List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								NominaCondicionCredBean resultado = new NominaCondicionCredBean();

								resultado.setnCoincidencias(resultSet.getString("NCoincidencias"));
								return resultado;
							}
						});
						registro = matches.size() > 0 ? (NominaCondicionCredBean) matches.get(0) : null;
					} catch(Exception e) {
						e.printStackTrace();
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de Coincidencias de Condicion Producto de credito", e);
					}

					return registro;
				}

				// CONSULTA CONDICION
				public NominaCondicionCredBean consultaPorConvenio(int tipoConsulta, NominaCondicionCredBean nominaCondicionCredBean) {
					NominaCondicionCredBean registro = null;
					try {
						String query = "CALL NOMCONDICIONCREDCON (?,?,?,?,?,"
																+ "	?,?,?,?,?,"
																+ " ?,?);";
						Object[] parametros = {

								Utileria.convierteLong(nominaCondicionCredBean.getCondicionCredID()),
								Utileria.convierteLong(nominaCondicionCredBean.getInstitNominaID()),
								Utileria.convierteLong(nominaCondicionCredBean.getConvenioNominaID()),
								Utileria.convierteLong(nominaCondicionCredBean.getProducCreditoID()),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"NominaCondicionCredDAO.consultaPorConvenio",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

						loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMCONDICIONCREDCON (" + Arrays.toString(parametros) + ")");
						List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								NominaCondicionCredBean resultado = new NominaCondicionCredBean();
								resultado.setCondicionCredID(resultSet.getString("CondicionCredID"));
								resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
								resultado.setProducCreditoID(resultSet.getString("ProducCreditoID"));
								resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
								resultado.setTipoCobMora(resultSet.getString("TipoCobMora"));
								resultado.setValorMora(resultSet.getString("ValorMora"));
								resultado.setTipoTasa(resultSet.getString("TipoTasa"));
								resultado.setValorTasa(resultSet.getString("ValorTasa"));
								return resultado;
							}
						});
						registro = matches.size() > 0 ? (NominaCondicionCredBean) matches.get(0) : null;
					} catch(Exception e) {
						e.printStackTrace();
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta el valor Tasa", e);
					}

					return registro;
				}




		// metodo para dar de baja todas las condiciones de credito de un convenio de nomina
		public MensajeTransaccionBean bajaNomCondicionesCred(final NominaCondicionCredBean nominaCondicionCredBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Stored Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "CALL NOMCONDICIONCREDBAJ (?,?,?,?,?,	" +
																				"?,?,?,?,?," +
																				"?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ConvenioNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getConvenioNominaID()));
										sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(nominaCondicionCredBean.getInstitNominaID()));

										sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID", "NominaCondicionCredDAO.bajaNomCondicionesCred");
										sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
										return sentenciaStore;
									}
								}, new CallableStatementCallback<Object>() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
									DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if (callableStatement.execute()) {
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										} else {
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NominaCondicionCredDAO.bajaNomCondicionesCred");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								}
								);
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " NominaCondicionCredDAO.bajaNomCondicionesCred");
						} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + " Error al eliminar condiciones de crédito" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



}


