package operacionesPDA.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import general.dao.TransaccionDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesPDA.beanWS.request.SP_PDA_Ahorros_ConsultaSaldoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_AbonoResponse;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_ConsultaSaldoResponse;

public class SP_PDA_Ahorros_ConsultaSaldoDAO extends BaseDAO{
	public SP_PDA_Ahorros_ConsultaSaldoDAO(){
		super();
	}

	public  SP_PDA_Ahorros_ConsultaSaldoResponse consultaSaldoWS(final SP_PDA_Ahorros_ConsultaSaldoRequest requestBean, final int tipoConsulta){
		SP_PDA_Ahorros_ConsultaSaldoResponse consultaSal=new SP_PDA_Ahorros_ConsultaSaldoResponse();
        System.out.println("ESTO ES:" + parametrosAuditoriaBean.getOrigenDatos());
        System.out.println("ESTO ES EL PAREMETRO DE LA CONSULTA: " +requestBean.getCuentaAltaID());
		consultaSal=(SP_PDA_Ahorros_ConsultaSaldoResponse)((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				SP_PDA_Ahorros_ConsultaSaldoResponse resultado = new SP_PDA_Ahorros_ConsultaSaldoResponse();
				try{
					resultado=(SP_PDA_Ahorros_ConsultaSaldoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

							new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CUENTASAHOCON(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";


									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(requestBean.getCuentaAltaID()));
									sentenciaStore.setInt("Par_ClienteID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_Mes",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_Anio",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_TipoCuenta",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumCon",tipoConsulta);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
									sentenciaStore.setString("Aud_ProgramaID", "operacionesPDA.WS.abonoCuentaWS");
									sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}

							}, new CallableStatementCallback(){
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								                                                                                 DataAccessException {
									SP_PDA_Ahorros_ConsultaSaldoResponse respuestaBean=new SP_PDA_Ahorros_ConsultaSaldoResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setCelular(resultadosStore.getString("TelefonoCelular"));
										respuestaBean.setDescripTipoCuenta(resultadosStore.getString("Etiqueta"));
										respuestaBean.setSaldoDisp(resultadosStore.getString("SaldoDispon"));
										respuestaBean.setCodigoRespuesta(resultadosStore.getString("NumErr"));
     									respuestaBean.setMensajeRespuesta(resultadosStore.getString("ErrMen"));

									}else{
										respuestaBean.setCelular(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setDescripTipoCuenta(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setSaldoDisp(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setCodigoRespuesta("999");
										respuestaBean.setMensajeRespuesta("Transacción Rechazada");

									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new SP_PDA_Ahorros_ConsultaSaldoResponse();

							resultado.setCelular(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setDescripTipoCuenta(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setSaldoDisp(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSPRO");

							throw new Exception(Constantes.MSG_ERROR + " .SP_PDA_Ahorro_ConsultaSaldo.consultaSaldoWS");
						}

					} catch (Exception e) {

						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta al WS", e);
					}
					return resultado;
			}
		});

		return consultaSal;
	}


	}

