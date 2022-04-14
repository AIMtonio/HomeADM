package originacion.dao;

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

import originacion.bean.ConfiguracionRatiosBean;
import originacion.servicio.ConfiguracionRatiosServicio;

public class ConfiguracionRatiosDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public ConfiguracionRatiosDAO() {
		super();
	}

	/**
	 * Lista para traer la configuración de los ratios por producto. Aplica para Concepto, Clasificacion, y SubClasificacion
	 * @param configuracionRatiosBean
	 * @param tipoLista Número de lista (1,2,3)
	 * @return
	 */
	public List<ConfiguracionRatiosBean> listaxPorcentaje(ConfiguracionRatiosBean configuracionRatiosBean, int tipoLista) {
		List<ConfiguracionRatiosBean> lista = new ArrayList<ConfiguracionRatiosBean>();
		double total = 0;
		try {
			String query = "CALL RATIOSCONFXPRODLIS(" +
					"?,?,?,?,?,   " +
					"?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(configuracionRatiosBean.getProducCreditoID()),
					Utileria.convierteEntero(configuracionRatiosBean.getRatiosCatalogoRelID()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ConfiguracionRatiosDAO.listaxPorcentaje",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL RATIOSCONFXPRODLIS(" + Arrays.toString(parametros) + ")");
			List<ConfiguracionRatiosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConfiguracionRatiosBean parametro = new ConfiguracionRatiosBean();
					parametro.setRatiosCatalogoID(resultSet.getString("RatiosCatalogoID"));
					parametro.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					parametro.setDescripcion(Utileria.generaLocale(resultSet.getString("Descripcion"), parametrosSesionBean.getNomCortoInstitucion()));
					parametro.setPorcentaje(resultSet.getString("Porcentaje"));
					parametro.setnRegistroCat(resultSet.getString("NRegistroCat"));
					return parametro;
				}
			});
			lista = matches;
			if (lista != null) {
				for (ConfiguracionRatiosBean porcentaje : lista) {
					total = total + Utileria.convierteDoble(porcentaje.getPorcentaje());
				}
				if (lista.size() > 0) {
					lista.get(0).setTotal(String.valueOf(total));
				}
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en ConfiguracionRatiosDAO.listaXConcepto:" + ex.getMessage());
			ex.printStackTrace();
		} finally {
			return lista;
		}
	}

	public List<ConfiguracionRatiosBean> listaxLimites(ConfiguracionRatiosBean configuracionRatiosBean, int tipoLista) {
		List<ConfiguracionRatiosBean> lista = new ArrayList<ConfiguracionRatiosBean>();
		double total = 0;
		try {
			String query = "CALL RATIOSCONFXPRODLIS(" +
					"?,?,?,?,?,   " +
					"?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(configuracionRatiosBean.getProducCreditoID()),
					Utileria.convierteEntero(configuracionRatiosBean.getRatiosCatalogoRelID()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ConfiguracionRatiosDAO.listaxPorcentaje",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL RATIOSCONFXPRODLIS(" + Arrays.toString(parametros) + ")");
			List<ConfiguracionRatiosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConfiguracionRatiosBean parametro = new ConfiguracionRatiosBean();
					parametro.setRatiosCatalogoID(resultSet.getString("RatiosCatalogoID"));
					parametro.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					parametro.setDescripcion(Utileria.generaLocale(resultSet.getString("Descripcion"), parametrosSesionBean.getNomCortoInstitucion()));
					parametro.setLimiteInferior(resultSet.getString("LimiteInferior"));
					parametro.setLimiteSuperior(resultSet.getString("LimiteSuperior"));
					parametro.setPuntos(resultSet.getString("Puntos"));
					return parametro;
				}
			});
			lista = matches;
			if (lista != null) {
				for (ConfiguracionRatiosBean porcentaje : lista) {
					total = total + Utileria.convierteDoble(porcentaje.getPorcentaje());
				}
				if (lista.size() > 0) {
					lista.get(0).setTotal(String.valueOf(total));
				}
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en ConfiguracionRatiosDAO.listaXConcepto:" + ex.getMessage());
			ex.printStackTrace();
		} finally {
			return lista;
		}
	}

	/**
	 * Método para grabar la configuración de los ratior por producto de crédito.
	 * @param listaDetalles: List<ConfiguracionRatiosBean>
	 * @param tipoTransaccion: Número de transacción {@link ConfiguracionRatiosServicio.Enum_tran_RatiosConf}
	 * @return
	 */
	public MensajeTransaccionBean graba(final List<ConfiguracionRatiosBean> listaDetalles, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					for (ConfiguracionRatiosBean detalle : listaDetalles) {
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

	/**
	 * Graba el detalle de la configuración de ratios
	 * @param configuracionRatiosBean: Configuración de ratios
	 * @param tipoTransaccion: Número de transacción
	 * @return MensajeTransaccionBean
	 */
	private MensajeTransaccionBean grabaDetalle(final ConfiguracionRatiosBean configuracionRatiosBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL RATIOSCONFXPRODALT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,"
											+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(configuracionRatiosBean.getProducCreditoID()));
									sentenciaStore.setInt("Par_RatiosCatalogoID", Utileria.convierteEntero(configuracionRatiosBean.getRatiosCatalogoID()));
									sentenciaStore.setDouble("Par_Porcentaje", Utileria.convierteDoble(configuracionRatiosBean.getPorcentaje()));
									sentenciaStore.setDouble("Par_LimiteInferior", Utileria.convierteDoble(configuracionRatiosBean.getLimiteInferior()));
									sentenciaStore.setDouble("Par_LimiteSuperior", Utileria.convierteDoble(configuracionRatiosBean.getLimiteSuperior()));
									sentenciaStore.setInt("Par_Puntos", Utileria.convierteEntero(configuracionRatiosBean.getPuntos()));
									sentenciaStore.setInt("Par_Transaccion", tipoTransaccion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setInt("Aud_Empresa", parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de configuracion de ratios por producto: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
