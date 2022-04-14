package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cuentas.bean.CuentasAhoBean;

import cliente.bean.ClienteBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CuentaAutorizadaDAO extends BaseDAO {

	public CuentaAutorizadaDAO(){
		super();
	}

	public AltaCuentaAutorizadaResponse altaCuentaAhutorizada(final AltaCuentaAutorizadaRequest cuentaAho) {
		AltaCuentaAutorizadaResponse mensaje = new AltaCuentaAutorizadaResponse();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (AltaCuentaAutorizadaResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				AltaCuentaAutorizadaResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (AltaCuentaAutorizadaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBCUENTASAHOAUTWSPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cuentaAho.getSucursalID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentaAho.getClienteID()));
									sentenciaStore.setInt("Par_TipoCuentaID",Utileria.convierteEntero(cuentaAho.getTipoCuentaID()));
									sentenciaStore.setString("Par_EsPrincipal",cuentaAho.getEsPrincipal());
									sentenciaStore.setString("Par_FechaContratacion", cuentaAho.getFechaContratacion());
									sentenciaStore.setDouble("Par_TasaPactada", Utileria.convierteDoble(cuentaAho.getTasaPactada()));
									sentenciaStore.registerOutParameter("Par_CuentaAhoID",Types.BIGINT);


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									AltaCuentaAutorizadaResponse mensajeTransaccion = new AltaCuentaAutorizadaResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setCuentaAhoID(resultadosStore.getString("CuentaAhoID"));

									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .CuentasAhoAutDAO.altaCuenta");
										mensajeTransaccion.setCuentaAhoID(""+Constantes.ENTERO_CERO);

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new AltaCuentaAutorizadaResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .CuentasAhoAutDAO.altaCuenta");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new AltaCuentaAutorizadaResponse();
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ALTACUENTAAUTORIZADA");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en WS de Alta de Cuenta Autorizada :" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}






}
