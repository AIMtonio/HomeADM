package sms.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.parsing.ParseState;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SMSCondiciCargaDAO extends BaseDAO{

	public SMSCondiciCargaDAO(){
		super();
	}

	//Alta de Condiciones de Envio de SMS
	public MensajeTransaccionBean altaCondiciones(final SMSCondiciCargaBean smsCondiciCargaBean, final String numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SMSCONDICICARGAALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsCondiciCargaBean.getCampaniaID()));
								sentenciaStore.setString("Par_TipoEnvio",smsCondiciCargaBean.getTipoEnvio());
								sentenciaStore.setString("Par_OpcEnvio",smsCondiciCargaBean.getOpcionEnvio());
								sentenciaStore.setString("Par_NumVeces",smsCondiciCargaBean.getNumVeces());
								sentenciaStore.setString("Par_Distancia",smsCondiciCargaBean.getDistancia());
								sentenciaStore.setString("Par_FechaInicio",smsCondiciCargaBean.getFechaInicio());
								sentenciaStore.setString("Par_FechaFin",smsCondiciCargaBean.getFechaFin());
								sentenciaStore.setString("Par_Periodicid",smsCondiciCargaBean.getPeriodicidad());
								sentenciaStore.setString("Par_HoraPeriod",smsCondiciCargaBean.getHoraPeriodicidad());
								sentenciaStore.setInt("Par_NumTransac",Utileria.convierteEntero(numTransaccion));
								sentenciaStore.setString("Par_FechaProgEn",smsCondiciCargaBean.getFechaProgEnvio());

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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SMSCondiciCargaDAO.altaCondiciones");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de condiciones", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Simula fechas de envio de SMS
	public List simulaFechas(SMSCondiciCargaBean smsCondiciCargaBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		//Query con el Store Procedure
		String query = "call SMSFECHASCALENDPRO(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								smsCondiciCargaBean.getPeriodicidad(),
								Utileria.convierteFecha(smsCondiciCargaBean.getFechaInicio()),
								Utileria.convierteFecha(smsCondiciCargaBean.getFechaFin()),
								Utileria.convierteEntero(smsCondiciCargaBean.getCampaniaID()),
								Constantes.STRING_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSFECHASCALENDPRO(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
				smsEnvioMensajeBean.setEnvioID(resultSet.getString(1));
				smsEnvioMensajeBean.setFechaRespuesta(resultSet.getString(2));
				smsEnvioMensajeBean.setNumTransaccion(resultSet.getString(3));
				return smsEnvioMensajeBean;
			}
		});
		return matches;
	}
}
