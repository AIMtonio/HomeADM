package bancaMovil.dao;

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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import bancaMovil.bean.BAMEnviaCorreoBean;


public class BAMEnviaCorreoDAO extends BaseDAO{


	public BAMEnviaCorreoDAO () {
		super();
	}

	ParametrosSesionBean parametrosSesionBean;


	/* Alta del Perfil */

	public MensajeTransaccionBean altaCorreo(final  BAMEnviaCorreoBean correoBean) {
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
									String query = "call BAMENVIOCORREOALT(?,?,?,?,? ,?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Destinatario",correoBean.getDestinatario());//correoBean.getDestinatario());
									sentenciaStore.setString("Par_Mensaje",correoBean.getMensaje());
									sentenciaStore.setString("Par_Tipo",correoBean.getTipo());
									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria se mandan vacios ya que las  pantallas que ejecutan este metodo
									//no necesitan sesion
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Aud_FechaActual",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
									sentenciaStore.setString("Aud_ProgramaID","Banca Movil");
									sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"),""));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BAMCorreoDAO.altaCorreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + ".BAMCorreoDAO.altaCorreo");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error("Error en Alta de correo: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					loggerSAFI.error("Error en Alta de correo" + e);
					e.printStackTrace();
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


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
