package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.CondicionProductoNominaBean;
import nomina.bean.NomEsquemaTasaCredBean;

public class NomEsquemaTasaCredDAO extends BaseDAO{

	public List<?> listaGridNomEsquemaTasaCred(int tipoLista, NomEsquemaTasaCredBean nomEsquemaTasaCredBean) {
		List<?> lista = null;
		try {
			String query = "CALL NOMESQUEMATASACREDLIS (?,?,?,?,?," +
														"?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(nomEsquemaTasaCredBean.getCondicionCredID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NomEsquemaTasaCredDAO.listaGridNomEsquemaTasaCred",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMESQUEMATASACREDLIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					NomEsquemaTasaCredBean resultado = new NomEsquemaTasaCredBean();
					resultado.setEsqTasaCredID(resultSet.getString("EsqTasaCredID"));
					resultado.setSucursalID(resultSet.getString("SucursalID"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setPlazoID(resultSet.getString("PlazoID"));
					resultado.setMinCred(resultSet.getString("MinCred"));
					resultado.setMaxCred(resultSet.getString("MaxCred"));
					resultado.setMontoMin(resultSet.getString("MontoMin"));
					resultado.setMontoMax(resultSet.getString("MontoMax"));
					resultado.setTasa(resultSet.getString("Tasa"));

					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de esquemas de tasa de crédito", e);
		}
		return lista;
	}


	public MensajeTransaccionBean guardarEsquemasTasaCred(final CondicionProductoNominaBean condicionProductoNominaBean, final ArrayList<NomEsquemaTasaCredBean> nomEsquemasTasa){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					NomEsquemaTasaCredBean tasaBean = new NomEsquemaTasaCredBean();
					tasaBean.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());
					mensajeBean= bajaNomEsquemaTasaCred(tasaBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					for (int i = 0; i < nomEsquemasTasa.size(); i++) {
						NomEsquemaTasaCredBean esquemaTasa = nomEsquemasTasa.get(i);
						esquemaTasa.setCondicionCredID(condicionProductoNominaBean.getCondicionCredID());

						mensajeBean = altaNomEsquemaTasaCred(esquemaTasa);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
						mensajeBean.setDescripcion("Esquemas de tasa de crédito guardados exitosamente");
						mensajeBean.setNombreControl("convenioNominaID");
						mensajeBean.setConsecutivoInt(condicionProductoNominaBean.getConvenioNominaID());
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("agrega");
					mensajeBean.setConsecutivoString("0");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de esquemas de tasa de crédito:", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});

		return mensajeResultado;

	}


	public MensajeTransaccionBean altaNomEsquemaTasaCred(final NomEsquemaTasaCredBean nomEsquemaTasaCredBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL NOMESQUEMATASACREDALT (?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CondicionCredID", Utileria.convierteLong(nomEsquemaTasaCredBean.getCondicionCredID()));
									sentenciaStore.setString("Par_SucursalID", nomEsquemaTasaCredBean.getSucursalID());
									sentenciaStore.setString("Par_TipoEmpleadoID", nomEsquemaTasaCredBean.getTipoEmpleadoID());
									sentenciaStore.setString("Par_PlazoID", nomEsquemaTasaCredBean.getPlazoID());
									sentenciaStore.setInt("Par_MinCred", Utileria.convierteEntero(nomEsquemaTasaCredBean.getMinCred()));

									sentenciaStore.setInt("Par_MaxCred", Utileria.convierteEntero(nomEsquemaTasaCredBean.getMaxCred()));
									sentenciaStore.setDouble("Par_MontoMin",Utileria.convierteDoble(nomEsquemaTasaCredBean.getMontoMin()));
									sentenciaStore.setDouble("Par_MontoMax", Utileria.convierteDoble(nomEsquemaTasaCredBean.getMontoMax()));
									sentenciaStore.setDouble("Par_Tasa", Utileria.convierteDoble(nomEsquemaTasaCredBean.getTasa()));


									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NomEsquemaMontoCredDAO.altaNomEsquemaTasaCred");
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NomEsquemaMontoCredDAO.altaNomEsquemaTasaCred");
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
						throw new Exception(Constantes.MSG_ERROR + " NomEsquemaMontoCredDAO.altaNomEsquemaTasaCred");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al registrar el esquema de tasa de crédito" + e);
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


	// metodo para dar de baja todos los esquemas de tasas de un esquema de monto
		public MensajeTransaccionBean bajaNomEsquemaTasaCred(final NomEsquemaTasaCredBean nomEsquemaTasaCredBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Stored Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "CALL NOMESQUEMATASACREDBAJ (?,?,?,?,?,	" +
																					"?,?,?,?,?," +
																					"?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setLong("Par_CondicionCredID", Utileria.convierteLong(nomEsquemaTasaCredBean.getCondicionCredID()));

										sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID", "NomEsquemaTasaCredDAO.bajaNomEsquemaTasaCred");
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NomEsquemaTasaCredDAO.bajaNomEsquemaTasaCred");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								}
								);
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " NomEsquemaTasaCredDAO.bajaNomEsquemaTasaCred");
						} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + " Error al eliminar los esquemas de tasa de crédito" + e);
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
