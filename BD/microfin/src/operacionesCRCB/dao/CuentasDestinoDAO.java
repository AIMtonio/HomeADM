package operacionesCRCB.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.ActCuentaDestinoRequest;
import operacionesCRCB.beanWS.request.AltaCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.ActCuentaDestinoResponse;
import operacionesCRCB.beanWS.response.AltaCuentaDestinoResponse;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


public class CuentasDestinoDAO extends BaseDAO {

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CuentasDestinoDAO(){
		super();
	}


	//Alta de cuentas destino
	public AltaCuentaDestinoResponse altaCtaDestinoWS(final AltaCuentaDestinoRequest cuentasDesBean, final int tipoTransaccion) {
		AltaCuentaDestinoResponse mensaje = new AltaCuentaDestinoResponse();
		transaccionDAO.generaNumeroTransaccionWS();
		mensaje = (AltaCuentaDestinoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				AltaCuentaDestinoResponse mensajeBean = new AltaCuentaDestinoResponse();
					try{
						// Query con el Store Procedure
						mensajeBean = (AltaCuentaDestinoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRCBCUENTADESTINOWSPRO(?,?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasDesBean.getClienteID()));
									sentenciaStore.setInt("Par_CuentaTranID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasDesBean.getBanco()));
									sentenciaStore.setInt("Par_TipoCuenta",Utileria.convierteEntero(cuentasDesBean.getTipoCuentaSpei()));
									sentenciaStore.setString("Par_Cuenta",cuentasDesBean.getCuenta());

									sentenciaStore.setString("Par_Beneficiario",cuentasDesBean.getBeneficiario());
									sentenciaStore.setString("Par_Alias",cuentasDesBean.getAlias());
									sentenciaStore.setInt("Par_NumOperacion",tipoTransaccion);

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

									AltaCuentaDestinoResponse mensajeTransaccion = new AltaCuentaDestinoResponse();

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setClienteID(resultadosStore.getString("ClienteID"));
										mensajeTransaccion.setCuentaTranID(resultadosStore.getString("CuentaTranID"));
										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));


									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new AltaCuentaDestinoResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
							throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cuenta destino WS", e);
						if (mensajeBean.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
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

	//Actualizacion de cuentas destino
	public ActCuentaDestinoResponse actCtaDestinoWS(final ActCuentaDestinoRequest cuentasDesBean, final int tipoTransaccion) {
		ActCuentaDestinoResponse mensaje = new ActCuentaDestinoResponse();
		transaccionDAO.generaNumeroTransaccionWS();
		mensaje = (ActCuentaDestinoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ActCuentaDestinoResponse mensajeBean = new ActCuentaDestinoResponse();
					try{
						// Query con el Store Procedure
						mensajeBean = (ActCuentaDestinoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRCBCUENTADESTINOWSPRO(?,?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasDesBean.getClienteID()));
									sentenciaStore.setInt("Par_CuentaTranID",Utileria.convierteEntero(cuentasDesBean.getCuentaTranID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasDesBean.getBanco()));
									sentenciaStore.setInt("Par_TipoCuenta",Utileria.convierteEntero(cuentasDesBean.getTipoCuentaSpei()));
									sentenciaStore.setString("Par_Cuenta",cuentasDesBean.getCuenta());

									sentenciaStore.setString("Par_Beneficiario",cuentasDesBean.getBeneficiario());
									sentenciaStore.setString("Par_Alias",cuentasDesBean.getAlias());
									sentenciaStore.setInt("Par_NumOperacion",tipoTransaccion);

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

									ActCuentaDestinoResponse mensajeTransaccion = new ActCuentaDestinoResponse();

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setClienteID(resultadosStore.getString("ClienteID"));
										mensajeTransaccion.setCuentaTranID(resultadosStore.getString("CuentaTranID"));
										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));


									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ActCuentaDestinoResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
							throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizacion de Cuenta destino WS", e);
						if (mensajeBean.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
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
