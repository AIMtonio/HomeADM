package originacion.dao;
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
import originacion.bean.CreditosPlazosBean;
import originacion.bean.FrecuenciaBean;

public class CreditosPlazosDAO  extends BaseDAO{

	public CreditosPlazosDAO() {
		super();
	}
	/**
	 * Alta de Plazos de Credito
	 * @param creditosPlazosBean
	 * @return
	 */
	public MensajeTransaccionBean altaPlazosCredito(final CreditosPlazosBean creditosPlazosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSPLAZOSALT(?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Dias",Utileria.convierteEntero(creditosPlazosBean.getDias()));
								sentenciaStore.setString("Par_Descripcion",creditosPlazosBean.getDescripcion());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de plazos de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Eliminacion de plazos de credito
	 * @param creditosPlazosBean
	 * @return
	 */
	public MensajeTransaccionBean modificaEsquemaTasas(final CreditosPlazosBean creditosPlazosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREDITOSPLAZOSBAJ(?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								    loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								    return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion en esquema de tasas", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}
	/**
	 * Consulta principal para los plazos
	 * @param creditosPlazosBean
	 * @param tipoConsulta
	 * @return
	 */
	public CreditosPlazosBean consultaPrincipal(CreditosPlazosBean creditosPlazosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSPLAZOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								creditosPlazosBean.getPlazoID(),
								OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
				creditosPlazosBean.setPlazoID(String.valueOf(resultSet.getInt(1)));
				creditosPlazosBean.setDias(String.valueOf(resultSet.getInt(2)));
				creditosPlazosBean.setDescripcion(resultSet.getString(3));


					return creditosPlazosBean;

			}
		});

		return matches.size() > 0 ? (CreditosPlazosBean) matches.get(0) : null;
	}
	/**
	 * Consuta la fecha de acuerdo con el Plazo de credito
	 * @param creditosPlazosBean
	 * @param tipoConsulta
	 * @return
	 */
	public CreditosPlazosBean consultaFechaPlazo(CreditosPlazosBean creditosPlazosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSPLAZOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosPlazosBean.getFrecuenciaCap(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								creditosPlazosBean.getPlazoID(),
								OperacionesFechas.conversionStrDate(creditosPlazosBean.getFechaActual()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
				creditosPlazosBean.setFechaActual(String.valueOf(resultSet.getDate(1)));
				creditosPlazosBean.setNumCuotas(String.valueOf(resultSet.getInt(2)));
				return creditosPlazosBean;

			}
		});

		return matches.size() > 0 ? (CreditosPlazosBean) matches.get(0) : null;
	}
	/**
	 * Consuta la fecha de vencimiento de credito (o solicitud )de acuerdo a las cuotas
	 * @param creditosPlazosBean
	 * @param tipoConsulta
	 * @return
	 */
	public CreditosPlazosBean consultaFechaVencimientoCuotas(CreditosPlazosBean creditosPlazosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSPLAZOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosPlazosBean.getFrecuenciaCap(),
								Utileria.convierteEntero(creditosPlazosBean.getNumCuotas()),
								Utileria.convierteEntero(creditosPlazosBean.getPeriodicidadCap()),
								Constantes.ENTERO_CERO,
								OperacionesFechas.conversionStrDate(creditosPlazosBean.getFechaActual()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
				creditosPlazosBean.setFechaActual(String.valueOf(resultSet.getDate(1)));

				return creditosPlazosBean;

			}
		});

		return matches.size() > 0 ? (CreditosPlazosBean) matches.get(0) : null;
	}
	/**
	 * Lista de Plazos para Combo el combo
	 * @param creditosPlazosBean
	 * @param tipoLista
	 * @return
	 */
	public List<CreditosPlazosBean> listaCombo(CreditosPlazosBean creditosPlazosBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CREDITOSPLAZOSLIS(" +
				"?,?,?,?,?,    " +
				"?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSLIS(" + Arrays.toString(parametros) + ")");

		List<CreditosPlazosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
					creditosPlazosBean.setPlazoID(String.valueOf(resultSet.getInt(1)));
					creditosPlazosBean.setDescripcion(resultSet.getString(2));
					return creditosPlazosBean;
				}
			});

			return matches;
	}
	/**
	 * Lista solo plazos mensuales, para combo
	 * @param creditosPlazosBean
	 * @param tipoLista
	 * @return
	 */
	public List<CreditosPlazosBean> listaPlazoMes(CreditosPlazosBean creditosPlazosBean, int tipoLista) {
		String query = "call CREDITOSPLAZOSLIS(" +
				"?,?,?,?,?,      " +
				"?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSLIS(" + Arrays.toString(parametros) + ")");

		List<CreditosPlazosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
					creditosPlazosBean.setPlazoID(String.valueOf(resultSet.getInt("PlazoID")));
					creditosPlazosBean.setDescripcion(resultSet.getString("Descripcion"));
					return creditosPlazosBean;
				}
			});

		return matches;
	}
	/**
	 * Lista los plazos por producto
	 * @param creditosPlazosBean
	 * @param tipoLista
	 * @return
	 */
	public List<CreditosPlazosBean> listaPlazosProducto(CreditosPlazosBean creditosPlazosBean, int tipoLista) {
		String query = "call CREDITOSPLAZOSLIS(" +
				"?,?,?,?,?,     " +
				"?,?,?,?,?);";
		Object[] parametros = {	creditosPlazosBean.getProducCreditoID(),
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSPLAZOSLIS(" + Arrays.toString(parametros) + ")");
		List<CreditosPlazosBean> matches;
		try{
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosPlazosBean creditosPlazosBean = new CreditosPlazosBean();
					creditosPlazosBean.setPlazoID(String.valueOf(resultSet.getInt("PlazoID")));
					creditosPlazosBean.setDescripcion(resultSet.getString("Descripcion"));
					creditosPlazosBean.setDias(resultSet.getString("Dias"));
					creditosPlazosBean.setFrecuenciaCap(resultSet.getString("Frecuencias"));
					return creditosPlazosBean;
				}
			});
		} catch(Exception ex){
			ex.printStackTrace();
			matches=new ArrayList<CreditosPlazosBean>();
		}

		return matches;
	}


}
