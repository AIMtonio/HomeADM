package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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


import originacion.bean.RatiosBean;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class RatiosDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;

	public RatiosDAO(){
		super();
	}

	/**
	 * Lista por concepto estos datos llenan los combos de C4
	 * @param ratiosBean
	 * @param tipoLista Numero de Lista
	 * @return
	 */
	public List listaPorConcepto(RatiosBean ratiosBean, int tipoLista) {
		List ratiosLis = null;
		try {
			// Query con el Store Procedure
			String query = "call RATIOSPUNTOSLIS(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_CERO,
					ratiosBean.getRatiosPorClasifID(),

					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"listaPorConcepto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call RATIOSPUNTOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					RatiosBean ratios = new RatiosBean();
					ratios.setRatiosPuntosID(String.valueOf(resultSet.getInt("RatiosPuntosID")));
					ratios.setDescripcion(resultSet.getString("Descripcion"));
					return ratios;
				}
			});
			ratiosLis = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en el listado de creditos para garantia liquida", e);
		}
		return ratiosLis;
	}

	/**
	 * Consulta de ratios desde la pantalla de Originacion -> Registro -> Ratios
	 * @param ratiosBean Bean con la informacion para realizar la consulta de ratios
	 * @param tipoConsulta Consulta 1
	 * @return
	 */
	public RatiosBean consultaRatios(RatiosBean ratiosBean, int tipoConsulta) {
		String query = "call RATIOSCON ("
				+ "?,?,?,?,?,      "
				+ "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call RATIOSCON(  " + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				RatiosBean ratios = new RatiosBean();

				try {
					ratios.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					ratios.setTotalResidencia(resultSet.getString("TotalResidencia"));
					ratios.setTotalOCupacion(resultSet.getString("TotalOupacion"));
					ratios.setTotalMora(resultSet.getString("TotalMora"));
					ratios.setTotalAfiliacion(resultSet.getString("TotalAfiliacion"));
					ratios.setTotalDeudaActual(resultSet.getString("TotalDeudaActual"));
					ratios.setTotalDeudaCredito(resultSet.getString("TotalDeudaCredito"));
					ratios.setTotalCobertura(resultSet.getString("TotalCobertura"));
					ratios.setTotalGastos(resultSet.getString("TotalGastos"));
					ratios.setTotalGastosCredito(resultSet.getString("TotalGastosCredito"));
					ratios.setTotalEstabilidadIng(resultSet.getString("TotalEstabilidadIng"));
					ratios.setTotalNegocio(resultSet.getString("TotalNegocio"));
					ratios.setPuntosTotal(resultSet.getString("PuntosTotal"));
					ratios.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
					ratios.setDescripcionNivel(resultSet.getString("Descripcion"));

					ratios.setActivosTerrenos(resultSet.getString("MontoTerreno"));
					ratios.setVivienda(resultSet.getString("MontoVivienda"));
					ratios.setActivosVehiculos(resultSet.getString("MontoVehiculos"));
					ratios.setOtrosActivos(resultSet.getString("MontoOtros"));

					ratios.setEstabilidadEmpleo(resultSet.getString("PuntosIDEstNeg"));
					ratios.setTieneNegocio(resultSet.getString("TieneNegocio"));
					ratios.setVentasMensuales(resultSet.getString("PuntosIDVentasMen"));
					ratios.setLiquidez(resultSet.getString("PuntosIDLiquidez"));
					ratios.setSituacionMercado(resultSet.getString("PuntosIDMercado"));
					ratios.setColaterales(resultSet.getString("Colaterales"));
					ratios.setEstatus(resultSet.getString("Estatus"));
				} catch (Exception ex) {
					loggerSAFI.debug("Error al consultar ratios. " + ex.getMessage());
					ex.printStackTrace();
					return null;
				}

				return ratios;
			}
		});
		return matches.size() > 0 ? (RatiosBean) matches.get(0) : null;
	}

	/**
	 * Metodo para calcular y guardar los ratios
	 * @param ratiosBean Bean con la informacion de los ratios a calcular
	 * @param TipoTransaccion Numero de transaccion 1: Calcular 2: Guardar
	 * @return
	 */
	public MensajeTransaccionBean calculoRatios(final RatiosBean ratiosBean, final int TipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos() + "-" + "DAO : " + ratiosBean.getSolicitudCreditoID());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call RATIOSPRO (    ?,?,?,?,?,   ?,?,?,?,?," +
											"   ?,?,?,?,?,   ?,?,?,?,?," +
											"   ?,?,?,?,?,   ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()));
									sentenciaStore.setString("Par_MorosidadCred", ratiosBean.getMorosidadCredito());
									sentenciaStore.setDouble("Par_MaximoMorosidad", Utileria.convierteDoble(ratiosBean.getMaximoMorosidad()));
									sentenciaStore.setDouble("Par_CalificaBuro", Utileria.convierteDoble(ratiosBean.getCalificaBuro()));
									sentenciaStore.setDouble("Par_PorDeuda", Utileria.convierteDoble(ratiosBean.getDeudaActual()));

									sentenciaStore.setDouble("Par_PorDeudaCredito", Utileria.convierteDoble(ratiosBean.getDeudaActualConCredito()));
									sentenciaStore.setDouble("Par_Cobertura", Utileria.convierteDoble(ratiosBean.getCobertura()));
									sentenciaStore.setDouble("Par_Gastos", Utileria.convierteDoble(ratiosBean.getGastosActuales()));
									sentenciaStore.setDouble("Par_GastosCredito", Utileria.convierteDoble(ratiosBean.getGastosConCredito()));
									sentenciaStore.setString("Par_TieneNegocio", ratiosBean.getTieneNegocio());

									sentenciaStore.setInt("Par_EstabEmpleo", Utileria.convierteEntero(ratiosBean.getEstabilidadEmpleo()));
									sentenciaStore.setInt("Par_VentasMensual", Utileria.convierteEntero(ratiosBean.getVentasMensuales()));
									sentenciaStore.setInt("Par_Liquidez", Utileria.convierteEntero(ratiosBean.getLiquidez()));
									sentenciaStore.setInt("Par_Mercado", Utileria.convierteEntero(ratiosBean.getSituacionMercado()));

									sentenciaStore.setDouble("Par_MontoTerreno", Utileria.convierteDoble(ratiosBean.getActivosTerrenos()));
									sentenciaStore.setDouble("Par_MontoVivienda", Utileria.convierteDoble(ratiosBean.getVivienda()));
									sentenciaStore.setDouble("Par_MontoVehiculos", Utileria.convierteDoble(ratiosBean.getActivosVehiculos()));
									sentenciaStore.setDouble("Par_MontoOtros", Utileria.convierteDoble(ratiosBean.getOtrosActivos()));

									sentenciaStore.setDouble("Par_MontoGarantizado", Utileria.convierteDoble(ratiosBean.getGarantizado()));
									sentenciaStore.setInt("Par_TipoTransaccion", TipoTransaccion);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en calculo del Ratios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta 2 Obtiene la cuota máxima
	 * @param ratiosBean Bean RatiosBean trae el número de solicitud, y numero de empresa para generar la consulta
	 * @param tipoConsulta Numero de consulta 2
	 * @return Regresa el resultado de la consulta
	 */
	public RatiosBean consultaDatosGenerales(RatiosBean ratiosBean, int tipoConsulta) {
		String query = "call RATIOSCON ("
				+ "?,?,?,?,?,   "
				+ "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()),
				tipoConsulta,

				Utileria.convierteEntero(ratiosBean.getEmpresaID()),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Utileria.convierteEntero(ratiosBean.getSucursalID()),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call RATIOSCON(  " + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RatiosBean ratios = new RatiosBean();
				try {
					ratios.setCuotaMaxima(resultSet.getString("CuotaMaxima"));
				} catch (Exception e) {
					loggerSAFI.error("Error en consulta de datos generales. RatiosDAO.consultaDatosGenerales ", e);
				}
				return ratios;
			}
		});
		return matches.size() > 0 ? (RatiosBean) matches.get(0) : null;
	}


	/**
	 * Metodo para actualizar la informacion de ratios, se utiliza para Procesar, Regresar, o Rechazar la solicitud de crédito
	 * @param ratiosBean
	 * @param tipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean actualizar(final RatiosBean ratiosBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos() + "-" + "DAO : " + ratiosBean.getSolicitudCreditoID());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call RATIOSACT ("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Par_Motivo", ratiosBean.getMotivo());
									sentenciaStore.setInt("Par_NumAct", tipoTransaccion);
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Actualizacion de los ratios.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consuta cuantos avales tiene una solicitudde crédito
	 * @param ratiosBean: Bean con los datos para la consulta
	 * @param tipoConsulta: Numero de consulta; 3
	 * @return
	 */
	public RatiosBean consultaNAvales(RatiosBean ratiosBean, int tipoConsulta) {
		try {
			String query = "call RATIOSCON ("
					+ "?,?,?,?,?,      "
					+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(ratiosBean.getSolicitudCreditoID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call RATIOSCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try {
						RatiosBean ratios = new RatiosBean();
						ratios.setnAvales(resultSet.getString("NAvales"));
						return ratios;
					} catch (Exception ex) {
						loggerSAFI.debug("Error al consultar ratios. " + ex.getMessage());
						ex.printStackTrace();
						return null;
					}

				}
			});
			return matches.size() > 0 ? (RatiosBean) matches.get(0) : null;
		} catch (Exception ex) {
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
