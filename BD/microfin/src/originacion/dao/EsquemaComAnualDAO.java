package originacion.dao;

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

import originacion.bean.EsquemaComAnualBean;
import originacion.bean.EsquemaSeguroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class EsquemaComAnualDAO extends BaseDAO {
	public EsquemaComAnualDAO() {
		super();
	}

	/**
	 * Método de Alta de Parametrización de Esquema de Cobro de Comisión Anual del Crédito.
	 * <br><b>SP:</b>ESQUEMACOMANUALALT</b></br>
	 * @param esquemaComAnualBean : Bean con los datos para El Esquema de Tipo <b>EsquemaComAnualBean</b>
	 * @return MensajeTransaccionBean  : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean alta(final EsquemaComAnualBean esquemaComAnualBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL ESQUEMACOMANUALALT(" +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    "
											+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(esquemaComAnualBean.getProducCreditoID()));
									sentenciaStore.setString("Par_CobraComision", esquemaComAnualBean.getCobraComision());
									sentenciaStore.setString("Par_TipoComision", esquemaComAnualBean.getTipoComision());
									sentenciaStore.setString("Par_BaseCalculo", esquemaComAnualBean.getBaseCalculo());
									sentenciaStore.setDouble("Par_MontoComision", Utileria.convierteDoble(esquemaComAnualBean.getMontoComision()));
									sentenciaStore.setDouble("Par_PorcentajeComision", Utileria.convierteDoble(esquemaComAnualBean.getPorcentajeComision()));
									sentenciaStore.setInt("Par_DiasGracia", Utileria.convierteEntero(esquemaComAnualBean.getDiasGracia()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Alta de parametrizacion de esquemas de cobro de comision anual: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para la Actualización del Esquema de Cobro de Comision Anual de Créditos.
	 * <br><b>SP:</b>ESQUEMACOMANUALMOD</br>
	 * @param esquemaComAnualBean :  Bean con los datos para El Esquema de Tipo <b>EsquemaComAnualBean</b>
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean actualiza(final EsquemaComAnualBean esquemaComAnualBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL ESQUEMACOMANUALMOD(" +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    "
											+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(esquemaComAnualBean.getProducCreditoID()));
									sentenciaStore.setString("Par_CobraComision", esquemaComAnualBean.getCobraComision());
									sentenciaStore.setString("Par_TipoComision", esquemaComAnualBean.getTipoComision());
									sentenciaStore.setString("Par_BaseCalculo", esquemaComAnualBean.getBaseCalculo());
									sentenciaStore.setDouble("Par_MontoComision", Utileria.convierteDoble(esquemaComAnualBean.getMontoComision()));
									sentenciaStore.setDouble("Par_PorcentajeComision", Utileria.convierteDoble(esquemaComAnualBean.getPorcentajeComision()));
									sentenciaStore.setInt("Par_DiasGracia", Utileria.convierteEntero(esquemaComAnualBean.getDiasGracia()));

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
						mensajeBean.setNombreControl("modificar");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Actualizacion de parametrizacion de esquemas de cobro de comision anual: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para la consulta de Esquemas de Cobro de Comisión Anual
	 * <br><b>SP:</b>ESQUEMACOMANUALCON</b></br>
	 * @param tipoConsulta Numero de Consulta
	 * @param esquemaComAnualBean Bean con los datos para El Esquema de Tipo <b>EsquemaComAnualBean</b>
	 * @return EsquemaComAnualBean
	 */
	public EsquemaComAnualBean consultaPrincipal(int tipoConsulta, EsquemaComAnualBean esquemaComAnualBean) {
		EsquemaComAnualBean bean = null;
		try{
		String query = "CALL ESQUEMACOMANUALCON(" +
				"?,?,?,?,?,   " +
				"?,?,?,?   );";
		Object[] parametros = {
				Utileria.convierteEntero(esquemaComAnualBean.getProducCreditoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"EsquemaComAnualDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		// loggeo de jQuery en llamadas al store procedure
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ESQUEMACOMANUALCON(" + Arrays.toString(parametros) + ")");
		List<EsquemaComAnualBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try{
						EsquemaComAnualBean esquema = new EsquemaComAnualBean();
						esquema.setProducCreditoID((resultSet.getString("ProducCreditoID")));
						esquema.setCobraComision((resultSet.getString("CobraComision")));
						esquema.setTipoComision((resultSet.getString("TipoComision")));
						esquema.setBaseCalculo((resultSet.getString("BaseCalculo")));
						esquema.setMontoComision((resultSet.getString("MontoComision")));
						esquema.setPorcentajeComision((resultSet.getString("PorcentajeComision")));
						esquema.setDiasGracia((resultSet.getString("DiasGracia")));
						return esquema;
					} catch(Exception ex){
						ex.printStackTrace();
					}
					return null;
			}

		});
		bean=matches.size() > 0 ? matches.get(0) : null;

		} catch(Exception ex){
			ex.printStackTrace();
		}
		return bean;
	}
}
