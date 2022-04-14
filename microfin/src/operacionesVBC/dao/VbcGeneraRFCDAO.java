package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcGeneraRFCRequest;
import operacionesVBC.beanWS.response.VbcGeneraRFCResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class VbcGeneraRFCDAO extends BaseDAO{

	public VbcGeneraRFCDAO() {
		super();
	}

	public VbcGeneraRFCResponse generaRFC(final VbcGeneraRFCRequest requestBean) {
		VbcGeneraRFCResponse mensaje = new VbcGeneraRFCResponse();
		transaccionDAO.generaNumeroTransaccionWS();

		mensaje = (VbcGeneraRFCResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				VbcGeneraRFCResponse mensajeBean = new VbcGeneraRFCResponse();
				try{
					// Query con el Store Procedure
					mensajeBean = (VbcGeneraRFCResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIENTEWSRFCCAL(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Cli_Nombre",requestBean.getNombre().toUpperCase());
								sentenciaStore.setString("Cli_ApePat",requestBean.getApellidoPaterno().toUpperCase());
								sentenciaStore.setString("Cli_ApeMat",requestBean.getApellidoMaterno().toUpperCase());
								sentenciaStore.setString("Cli_FecNac",requestBean.getFechaNacimiento());
								sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());

								sentenciaStore.setString("Par_Clave",requestBean.getClave());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_RFC", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
								sentenciaStore.setString("Aud_DireccionIP", "127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								VbcGeneraRFCResponse mensajeTransaccion = new VbcGeneraRFCResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
									mensajeTransaccion.setRfc(resultadosStore.getString("Rfc"));
									mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));
								}else{
									mensajeTransaccion.setCodigoRespuesta("999");
									mensajeTransaccion.setRfc("");
									mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new VbcGeneraRFCResponse();
						mensajeBean.setCodigoRespuesta("999");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getCodigoRespuesta()!= "0"){
						throw new Exception(mensajeBean.getMensajeRespuesta());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Generar RFC WS", e);
					if (mensajeBean.getCodigoRespuesta() == "0") {
						mensajeBean.setCodigoRespuesta("999");
					}
					mensajeBean.setMensajeRespuesta(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}
