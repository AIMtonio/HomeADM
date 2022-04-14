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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.bean.SMSIngresosOpsBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SMSEnvioMensajeDAO extends BaseDAO{

	public SMSEnvioMensajeDAO(){
		super();
	}

	//Alta Emvio SMS Individual
	public MensajeTransaccionBean altaSmsEnvio(int tipoTransaccion, final SMSEnvioMensajeBean smsEnvioMensajeBean) {
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
								String query = "call SMSENVIOMENSAJEALT(?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,	?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Remitente",smsEnvioMensajeBean.getRemitente());
								sentenciaStore.setString("Par_Receptor",smsEnvioMensajeBean.getReceptor());
								sentenciaStore.setString("Par_FechaRealEnvio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Mensaje",smsEnvioMensajeBean.getMsjenviar());
								sentenciaStore.setString("Par_FechaProgEnvio",smsEnvioMensajeBean.getFechaProgEnvio());

								sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsEnvioMensajeBean.getCampaniaID()));
								sentenciaStore.setString("Par_FechaResp",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_CtaAsoc",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_NumCliente",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_DatosCliente",(smsEnvioMensajeBean.getDatosCliente() != "" ? smsEnvioMensajeBean.getDatosCliente() : Constantes.STRING_VACIO));

								sentenciaStore.setString("Par_SistemaID", (smsEnvioMensajeBean.getSistemaID() != "" ? smsEnvioMensajeBean.getSistemaID() :Constantes.STRING_VACIO ));
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de envio sms", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


public MensajeTransaccionBean altaSmsEnvioWS(int tipoTransaccion, final SMSEnvioMensajeBean smsEnvioMensajeBean) {
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
								String query = "call SMSENVIOMENSAJEALT(?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,	?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Remitente",smsEnvioMensajeBean.getRemitente());
								sentenciaStore.setString("Par_Receptor",smsEnvioMensajeBean.getReceptor());
								sentenciaStore.setString("Par_FechaRealEnvio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Mensaje",smsEnvioMensajeBean.getMsjenviar());
								sentenciaStore.setString("Par_FechaProgEnvio",smsEnvioMensajeBean.getFechaProgEnvio());

								sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsEnvioMensajeBean.getCampaniaID()));
								sentenciaStore.setString("Par_FechaResp",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_CtaAsoc",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_NumCliente",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_DatosCliente",(smsEnvioMensajeBean.getDatosCliente() != "" ? smsEnvioMensajeBean.getDatosCliente() : Constantes.STRING_VACIO));

								sentenciaStore.setString("Par_SistemaID", (smsEnvioMensajeBean.getSistemaID() != "" ? smsEnvioMensajeBean.getSistemaID() :Constantes.STRING_VACIO ));
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de envio sms", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Alta Envio SMS Masivo
	public MensajeTransaccionBean altaMasivo(final SMSEnvioMensajeBean smsEnvioMensajeBean, final SMSCondiciCargaBean smsCondiciCargaBean) {
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
								String query = "call SMSENVIOMENSAJEPRO(?,?,?,?,?,?,"
																	+ "?,?,?,?,?,?,"
																	+ "?,?,?,?,?,?,"
																	+ "?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoEnvio",smsCondiciCargaBean.getTipoEnvio());
								sentenciaStore.setString("Par_NumVeces",smsCondiciCargaBean.getNumVeces());
								sentenciaStore.setString("Par_Distancia",smsCondiciCargaBean.getDistancia());

								sentenciaStore.setString("Par_Remitente",smsEnvioMensajeBean.getRemitente());
								sentenciaStore.setString("Par_Receptor",smsEnvioMensajeBean.getReceptor());
								sentenciaStore.setString("Par_FechaRealEnvio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Mensaje",smsEnvioMensajeBean.getMsjenviar().trim());
								sentenciaStore.setString("Par_FechaProgEnvio",smsEnvioMensajeBean.getFechaProgEnvio());

								sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsEnvioMensajeBean.getCampaniaID()));
								sentenciaStore.setString("Par_FechaResp",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_CtaAsoc",smsEnvioMensajeBean.getCuentaAsociada());
								sentenciaStore.setString("Par_NumCliente",smsEnvioMensajeBean.getClienteID());
								sentenciaStore.setString("Par_DatosCliente",Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_SistemaID",Constantes.STRING_VACIO);
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
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+parametrosAuditoriaBean.getNombrePrograma()+"|"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta masiva de envio sms", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consuta pora generar el mensaje con plantilla */
	public SMSEnvioMensajeBean generaMensaje(final SMSEnvioMensajeBean smsEnvioMensajeBean, final int numeroConsulta) {
		SMSEnvioMensajeBean smsEnvioMensaje= new SMSEnvioMensajeBean();
		try{
			//Query con el Store Procedure
			String query = "call SMSPLANTILLAPRO(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					smsEnvioMensajeBean.getMsjenviar(),
					smsEnvioMensajeBean.getReceptor(),
					numeroConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion(),
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SMSPLANTILLAPRO(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
					SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
					smsEnvioMensajeBean.setMsjgenerado(resultSet.getString("MensajeRepuesta"));
					smsEnvioMensajeBean.setEncontrado(resultSet.getString("NoEncontrado"));
					smsEnvioMensajeBean.setEnviar(resultSet.getString("EnviarSi"));
					return smsEnvioMensajeBean;
				}// trows ecexeption
			});//lista
			smsEnvioMensaje= matches.size() > 0 ? (SMSEnvioMensajeBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error Consulta principal de envio de mensaje", e);
		}
		return smsEnvioMensaje;
	}// consultaPrincipal



	// Cancelacion de envio de sms
		public MensajeTransaccionBean cancelaEnvioSMS(final SMSEnvioMensajeBean smsEnvioMensajeBean, final int tipoTransaccion) {
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
									String query = "call SMSENVIOMENSAJEACT(?,?,?,?,?,?,	?,	?,?,	?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_CampaniaID",Utileria.convierteEntero(smsEnvioMensajeBean.getCampaniaID()));
									sentenciaStore.setString("Par_FechaCancel",Utileria.convierteFecha(smsEnvioMensajeBean.getFechaRealEnvio()));
									sentenciaStore.setString("Par_OpCancel",smsEnvioMensajeBean.getMsjenviar());
									sentenciaStore.setInt("Par_EnvioID",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_PIDTarea",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);

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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de envio de mensaje", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public MensajeTransaccionBean alertasRetirosSMS(final SMSEnvioMensajeBean smsEnvioMensajeBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SMSALERTASRETIROSPRO(?,?,?,?, ?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(smsEnvioMensajeBean.getCuentaAhoID()));
									sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(smsEnvioMensajeBean.getCantidadMov()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en alerta SMS de retiro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean alertasRetirosSMSVentanilla(final SMSEnvioMensajeBean smsEnvioMensajeBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SMSALERTASRETIROSPRO(?,?,?,?, ?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(smsEnvioMensajeBean.getCuentaAhoID()));
									sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(smsEnvioMensajeBean.getCantidadMov()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(smsEnvioMensajeBean.getNumTransaccion()));
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en alerta SMS de retiro en Ventanilla", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean alertasSms(final int numAlerta,final SMSIngresosOpsBean smsIngresosOpsBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SMSALERTASPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(smsIngresosOpsBean.getCuentaOrigenID()));
									sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(smsIngresosOpsBean.getMonto()));
									sentenciaStore.setInt("Par_NumAlerta", numAlerta);
									sentenciaStore.setString("Par_JsonParams", smsIngresosOpsBean.toJson());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(smsIngresosOpsBean.getNumTransaccion()));
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en alerta SMS de operación", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}
