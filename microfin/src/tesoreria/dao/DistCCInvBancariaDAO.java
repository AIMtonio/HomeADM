package tesoreria.dao;

import general.bean.MensajeTransaccionBean;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.bean.InvBancariaBean;

public class DistCCInvBancariaDAO extends BaseDAO {

	private final static String salidaPantalla = "S";

	public DistCCInvBancariaDAO() {
		super();
	}

	public List<DistCCInvBancariaBean> lista(DistCCInvBancariaBean distCCInvBancaria, int tipoLista) {
		String query = "call DISTCCINVBANCARIALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { distCCInvBancaria.getInversionID(), tipoLista, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "DistCCInvBancariaDAO.lista", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DISTCCINVBANCARIALIS(" + Arrays.toString(parametros) + ")");

		List<DistCCInvBancariaBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DistCCInvBancariaBean distcc = new DistCCInvBancariaBean();
				distcc.setInversionID(resultSet.getString("InversionID"));
				distcc.setCentroCosto(resultSet.getString("CentroCosto"));
				distcc.setNombre_centroCosto(resultSet.getString("Nombre_centroCosto"));
				distcc.setMonto(resultSet.getString("Monto"));
				distcc.setInteresGenerado(resultSet.getString("InteresGenerado"));
				distcc.setiSR(resultSet.getString("ISR"));
				distcc.setTotalRecibir(resultSet.getString("TotalRecibir"));
				return distcc;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean alta(final DistCCInvBancariaBean distCCInvBancaria, final String consecutivo, final String altaMovimiento, final InvBancariaBean inversionBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call DISTCCINVBANCARIAALT(" + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(consecutivo));
							sentenciaStore.setInt("Par_CentroCostoID", Utileria.convierteEntero(distCCInvBancaria.getCentroCosto()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(distCCInvBancaria.getMonto()));
							sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(distCCInvBancaria.getiSR()));
							sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble((distCCInvBancaria.getInteresGenerado())));

							sentenciaStore.setDouble("Par_TotalRecibir", Utileria.convierteDoble(distCCInvBancaria.getTotalRecibir()));
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "DistCCInvBancariaDAO.alta");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
								// SI FUE EXITOSO DAR DE ALTA LA CONTABILIDAD
								mensajeTransaccion = altaContabilidad(distCCInvBancaria, consecutivo, altaMovimiento, inversionBean);
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DistCCInvBancariaDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DistCCInvBancariaDAO.alta");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
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

	public MensajeTransaccionBean altaContabilidad(final DistCCInvBancariaBean distCCInvBancaria, final String consecutivo, final String altaMovimiento, final InvBancariaBean inversionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {

			mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONTAINVBANPRO(" + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(distCCInvBancaria.getInversionID()));
								sentenciaStore.setInt("Par_CentroCosto", Utileria.convierteEntero(distCCInvBancaria.getCentroCosto()));
								sentenciaStore.setString("Par_TipoInversion", distCCInvBancaria.getTipoInversion());
								sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(distCCInvBancaria.getMonedaID()));
								sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(distCCInvBancaria.getInstitucionID()));

								sentenciaStore.setString("Par_FechaAplicacion", distCCInvBancaria.getFechaInicio());
								sentenciaStore.setString("Par_Monto", distCCInvBancaria.getMontoOriginalInv());
								sentenciaStore.setString("Par_MontoInvCC", distCCInvBancaria.getMonto());
								sentenciaStore.setString("Par_NumCtaInstit", distCCInvBancaria.getNumCtaInstit());
								sentenciaStore.setString("Par_AltaEncPoliza", distCCInvBancaria.alta_poliza_no);

								sentenciaStore.setInt("Par_ConceptoCon", Utileria.convierteEntero(distCCInvBancaria.ConceptoContable));
								sentenciaStore.setInt("Par_ConceptoInvBan", Utileria.convierteEntero(inversionBean.getClasificacionInver() != null && inversionBean.getClasificacionInver().equals("R") ? distCCInvBancaria.ConceptoInvBanReporto : distCCInvBancaria.ConceptoInvBan));
								sentenciaStore.setString("Par_TipoMovTeso", distCCInvBancaria.tipoMovimientoTesoreria);
								sentenciaStore.setString("Par_DescContable", distCCInvBancaria.descripcionContable);
								sentenciaStore.setString("Par_DescMovimiento", distCCInvBancaria.descripcionMovimiento);
								sentenciaStore.setString("Par_NatConta", distCCInvBancaria.naturalezaCargo);

								sentenciaStore.setString("Par_AltaMovOperativo", altaMovimiento);
								sentenciaStore.setString("Par_AltaContaTesoreria", "S");
								sentenciaStore.setString("Par_PolizaID", distCCInvBancaria.getPolizaID());
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_Empresa", parametrosAuditoriaBean.getEmpresaID());

								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "InvBancariaDAO.altaInversion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DistCCInvBancariaDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .DistCCInvBancariaDAO.alta");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);

			e.printStackTrace();
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		return mensaje;

	}

	public MensajeTransaccionBean altaDevengamiento(final String altaPoliza, final String altaMovOperativos, final DistCCInvBancariaBean distCCInvBancaria, final String consecutivo, final InvBancariaBean inversionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVBANDEVINTALTAPRO(" +
										"?,?,?,?,?," +
										"?,?,?,?,?," +
										"?,?,?,?,?," +
										"?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(distCCInvBancaria.getInversionID()));
								sentenciaStore.setInt("Par_CentroCostoID", Utileria.convierteEntero(distCCInvBancaria.getCentroCosto()));
								sentenciaStore.setString("Par_FechaInicio", inversionBean.getFechaInicio());
								sentenciaStore.setString("Par_FechaVencimiento", inversionBean.getFechaVencimiento());
								sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(consecutivo));
								sentenciaStore.setString("Par_AltaPoliza", altaPoliza);
								sentenciaStore.setString("Par_RealizarMovOper",altaMovOperativos);
								sentenciaStore.setString("Par_Salida", salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_Empresa", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "DistCCInvBancariaDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR +" .DistCCInvBancariaDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .DistCCInvBancariaDAO.alta");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);

			e.printStackTrace();
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		return mensaje;

	}

}
