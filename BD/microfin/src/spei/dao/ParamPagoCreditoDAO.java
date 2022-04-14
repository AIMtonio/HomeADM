package spei.dao;

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
import spei.bean.ParamPagoCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParamPagoCreditoDAO extends BaseDAO{

	public ParamPagoCreditoDAO() {
		super();
	}


	public MensajeTransaccionBean modificacion(final ParamPagoCreditoBean paramPagoCreditoBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SPEIPARAMPAGOCREPRO(?,?,?,?,?, 	" +
																		"?,?,?,?,?,	" +
																		"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumEmpresaID",Utileria.convierteEntero(paramPagoCreditoBean.getNumEmpresaID()));
								sentenciaStore.setString("Par_AplicaPagAutCre",paramPagoCreditoBean.getAplicaPagAutCre());
								sentenciaStore.setString("Par_EnCasoNoTieneExiCre",paramPagoCreditoBean.getEnCasoTieneExiCre());
								sentenciaStore.setString("Par_EnCasoSobrantePagCre",paramPagoCreditoBean.getEnCasoSobrantePagCre());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
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


	public ParamPagoCreditoBean consultaPrincipal(int tipoConsulta, ParamPagoCreditoBean  paramPagoCreditoBean){

		String query = "call SPEIPARAMPAGOCRECON(?,?,		" +
												"?,?,?,?,?,			?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(paramPagoCreditoBean.getNumEmpresaID()),
								tipoConsulta,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								Constantes.STRING_VACIO,
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIPARAMPAGOCRECON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParamPagoCreditoBean paramPagoCreditoBean = new ParamPagoCreditoBean();
				paramPagoCreditoBean.setAplicaPagAutCre(String.valueOf(resultSet.getString("AplicaPagAutCre")));
				paramPagoCreditoBean.setEnCasoTieneExiCre(String.valueOf(resultSet.getString("EnCasoNoTieneExiCre")));
				paramPagoCreditoBean.setEnCasoSobrantePagCre(String.valueOf(resultSet.getString("EnCasoSobrantePagCre")));
				return paramPagoCreditoBean;
			}
		});

		return matches.size() > 0 ? (ParamPagoCreditoBean) matches.get(0) : null;
	}


}
