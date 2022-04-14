package originacion.dao;

import general.bean.MensajeTransaccionBean;
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

import originacion.bean.EsquemaCargoDispBean;

public class EsquemaCargoDispDAO extends BaseDAO{

	public EsquemaCargoDispDAO(){
		super();
	}

	/**
	 * Alta de Esquema Cobro por Disposición de Crédito.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP-ESQUEMACARGOSDISPALT.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final EsquemaCargoDispBean esquemaCargoDispBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL ESQUEMACARGOSDISPALT("
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(esquemaCargoDispBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(esquemaCargoDispBean.getInstitucionID()));
								sentenciaStore.setString("Par_NombInstitucion",esquemaCargoDispBean.getNombInstitucion());
								sentenciaStore.setString("Par_TipoDispersion",esquemaCargoDispBean.getTipoDispersion());
								sentenciaStore.setString("Par_TipoCargo",esquemaCargoDispBean.getTipoCargo());

								sentenciaStore.setInt("Par_Nivel",Utileria.convierteEntero(esquemaCargoDispBean.getNivel()));
								sentenciaStore.setDouble("Par_MontoCargo",Utileria.convierteDoble((esquemaCargoDispBean.getMontoCargo())));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta del parametrizacion de esquemas de cobro por disposicion de credito: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Baja de Esquema Cobro por Disposición de Crédito.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP-ESQUEMACARGOSDISPBAJ.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean baja(final EsquemaCargoDispBean esquemaCargoDispBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL ESQUEMACARGOSDISPBAJ("
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(esquemaCargoDispBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(esquemaCargoDispBean.getInstitucionID()));
								sentenciaStore.setString("Par_TipoDispersion",esquemaCargoDispBean.getTipoDispersion());
								sentenciaStore.setString("Par_TipoCargo",esquemaCargoDispBean.getTipoCargo());
								sentenciaStore.setInt("Par_Nivel",Utileria.convierteEntero(esquemaCargoDispBean.getNivel()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
								}else{
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja del parametrizacion de Esquema de Cobro por Disposicion de Credito: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Consulta el Esquema Cobro por Disposición de Crédito.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP-ESQUEMACARGOSDISPCON.
	 * @param tipoConsulta : Número de Consulta.
	 * @return
	 */
	public EsquemaCargoDispBean consulta(final EsquemaCargoDispBean esquemaCargoDispBean, int tipoConsulta) {
		String query = "CALL ESQUEMACARGOSDISPCON(" +
				"?,?,?,?,?,	" +
				"?,?,?,?,?,	" +
				"?,?,?);";
		Object[] parametros = {
				esquemaCargoDispBean.getProductoCreditoID(),
				esquemaCargoDispBean.getInstitucionID(),
				esquemaCargoDispBean.getTipoDispersion(),
				esquemaCargoDispBean.getTipoCargo(),
				esquemaCargoDispBean.getNivel(),

				tipoConsulta,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),

				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMACARGOSDISPCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaCargoDispBean parametro = new EsquemaCargoDispBean();
				parametro.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				parametro.setInstitucionID(resultSet.getString("InstitucionID"));
				parametro.setNombInstitucion(resultSet.getString("NombInstitucion"));
				parametro.setMontoCargo(resultSet.getString("MontoCargo"));
				parametro.setTipoDispersion(resultSet.getString("TipoDispersion"));
				parametro.setTipoCargo(resultSet.getString("TipoCargo"));
				parametro.setNivel(resultSet.getString("Nivel"));

				return parametro;

			}
		});

		return matches.size() > 0 ? (EsquemaCargoDispBean) matches.get(0) : null;
	}
	/**
	 * Lista el Esquema Cobro por Disposición de Crédito.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP-ESQUEMACARGOSDISPLIS.
	 * @param tipoLista : Número de Lista.
	 * @return
	 */
	public List<EsquemaCargoDispBean> lista(EsquemaCargoDispBean esquemaCargoDispBean, int tipoLista) {
		List<EsquemaCargoDispBean> lista=new ArrayList<EsquemaCargoDispBean>();
		String query = "CALL ESQUEMACARGOSDISPLIS(" +
				"?,?,?,?,?,	" +
				"?,?,?,?);";
		Object[] parametros = {
				esquemaCargoDispBean.getProductoCreditoID(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"EsquemaCargoDispDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ESQUEMACARGOSDISPLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		try{
			List<EsquemaCargoDispBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaCargoDispBean parametro = new EsquemaCargoDispBean();
					parametro.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
					parametro.setInstitucionID(resultSet.getString("InstitucionID"));
					parametro.setNombInstitucion(resultSet.getString("NombInstitucion"));
					parametro.setMontoCargo(resultSet.getString("MontoCargo"));
					parametro.setTipoDispersion(resultSet.getString("TipoDispersion"));
					parametro.setTipoCargo(resultSet.getString("TipoCargo"));
					parametro.setNivel(resultSet.getString("Nivel"));
					return parametro;
				}
			});
			if(matches!=null)
			{
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en EsquemaCargoDispDAO.lista: "+ex.getMessage());
		}
		return lista;
	}
	/**
	 * Lista del reporte de los Cobros por Disposición de Créditos.
	 * @param esquemaCargoDispBean : Clase bean con los parámetros de entrada al SP-CARGOXDISPOSCREDREP.
	 * @param tipoReporte : Número de Reporte.
	 * @return
	 */
	public List<EsquemaCargoDispBean> reporte(EsquemaCargoDispBean esquemaCargoDispBean, int tipoReporte) {
		List<EsquemaCargoDispBean> lista=new ArrayList<EsquemaCargoDispBean>();
		String query = "CALL CARGOXDISPOSCREDREP(" +
				"?,?,?,?,?,	" +
				"?,?,?,?,?,	" +
				"?);";
		Object[] parametros = {
				esquemaCargoDispBean.getInstitucionID(),
				esquemaCargoDispBean.getFechaInicio(),
				esquemaCargoDispBean.getFechaFinal(),
				tipoReporte,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EsquemaCargoDispDAO.reporte",
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call CARGOXDISPOSCREDREP(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		try{
			List<EsquemaCargoDispBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaCargoDispBean parametro = new EsquemaCargoDispBean();
					parametro.setNombInstitucion(resultSet.getString("NombInstitucion"));
					parametro.setFechaCargo(resultSet.getString("FechaCargo"));
					parametro.setClienteID(resultSet.getString("ClienteID"));
					parametro.setCreditoID(resultSet.getString("CreditoID"));
					parametro.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					parametro.setMontoCargo(resultSet.getString("MontoCargo"));
					parametro.setTipoDispersion(resultSet.getString("TipoDispersion"));
					parametro.setTipoCargo(resultSet.getString("TipoCargo"));
					parametro.setNivel(resultSet.getString("Nivel"));
					return parametro;
				}
			});
			if(matches!=null)
			{
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en EsquemaCargoDispDAO.reporte: "+ex.getMessage());
		}
		return lista;
	}
}
