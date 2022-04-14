package originacion.dao;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import originacion.bean.ConsolidacionesBean;

public class ConsolidacionesDAO extends BaseDAO {

	public ConsolidacionesDAO() {
		super();
	}

	// Alta Proceso de Consolidación Agro
	public MensajeTransaccionBean procesoAltaConsolidacionAgro( final ConsolidacionesBean consolidacionesBean) {
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();

				try {

					mensajeTransaccionBean = validacionConsolidacion(consolidacionesBean);
					if( mensajeTransaccionBean.getNumero()!= Constantes.ENTERO_CERO ){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeTransaccionBean = altaConsolidacion(consolidacionesBean);
					if(mensajeTransaccionBean.getNumero()!=0){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					mensajeTransaccionBean.setCampoGenerico("creditoID");

				} catch (Exception exception) {
					if(mensajeTransaccionBean.getNumero()==0){
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el proceso de Alta de Consolidación Agro ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensajeTransaccion;
	}// Fin Proceso de Consolidación Agro

	// Alta de Consolidaciones
	public MensajeTransaccionBean altaConsolidacion(final ConsolidacionesBean consolidacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CREDCONSOLIDAAGROGRIDPRO(?,?,?,?,?,"
																			+"?,?,?,"
																			+"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_FolioConsolida", Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(consolidacionesBean.getCreditoID()));
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(consolidacionesBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_Transaccion", Utileria.convierteLong(consolidacionesBean.getTransaccion()));
								sentenciaStore.setDate("Par_FechaProyeccion", OperacionesFechas.conversionStrDate(consolidacionesBean.getFechaDesembolso()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.altaConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(5));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(5));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Créditos Consolidados ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin Alta de Consolidaciones

	// Validacion de Consolidaciones
	public MensajeTransaccionBean validacionConsolidacion(final ConsolidacionesBean consolidacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CRECONSOLIDAAGROVAL(?,?,?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_FolioConsolida", Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(consolidacionesBean.getCreditoID()));
								sentenciaStore.setLong("Par_Transaccion", Utileria.convierteLong(consolidacionesBean.getTransaccion()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.validacionConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la validación de Créditos Consolidados ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin Validacion de Consolidaciones

	// Alta de Consolidaciones por Solicitud de Crédito
	public MensajeTransaccionBean procesoSolicitudConsolidacion(final ConsolidacionesBean consolidacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CRECONSOLIDAAGROPRO(?,?,?,?,?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_FolioConsolida", Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()));
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(consolidacionesBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_Transaccion", Utileria.convierteLong(consolidacionesBean.getTransaccion()));
								sentenciaStore.setDate("Par_FechaDesembolso", OperacionesFechas.conversionStrDate(consolidacionesBean.getFechaDesembolso()));
								sentenciaStore.setString("Par_AltaGarAval", consolidacionesBean.getAltaGarAval());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.altaSolicitudConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error el Alta de Consolidaciones por Solicitud de Créditos ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin de Consolidaciones por Solicitud de Crédito

	// Baja de Consolidaciones
	public MensajeTransaccionBean bajaConsolidacion(final ConsolidacionesBean consolidacionesBean, final int tipoOperacion) {
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
								String query = "CALL CRECONSOLIDAAGROBAJ(?,?,?,?,?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_FolioConsolida", Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()));
								sentenciaStore.setLong("Par_DetalleID", Utileria.convierteLong(consolidacionesBean.getDetalleFolioConsolidaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(consolidacionesBean.getCreditoID()));
								sentenciaStore.setLong("Par_Transaccion", Utileria.convierteLong(consolidacionesBean.getTransaccion()));
								sentenciaStore.setInt("Par_TipoBaja", tipoOperacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.bajaConsolidacion");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja de Folios Consolidados ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin Baja de Consolidaciones

	// Creación Tabla Espejo de la Solicitud Consolidado
	public MensajeTransaccionBean creaListaTemporal(final ConsolidacionesBean consolidacionesBean) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								//Query con el Store Procedure
								String query = "CALL CRECONSOLIDAAGRODETGRIDPRO(?," +
																			   "?,?,?," +
																			   "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(consolidacionesBean.getSolicitudCreditoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.creaListaTemporal");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(5));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(5));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Creacion de la Lista Espejo de Crédito Consolidados ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Creación Tabla Espejo de la Solicitud Consolidado

	// Proyeccion de Creditos
	public MensajeTransaccionBean proyeccionInteres(final ConsolidacionesBean consolidacionesBean) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								//Query con el Store Procedure
								String query = "CALL CRECONSOLIDAPROYECCIONPRO(?,?,?," +
																			  "?,?,?," +
																			  "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_FolioConsolidacionID", Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()));
								sentenciaStore.setLong("Par_Transaccion", Utileria.convierteLong(consolidacionesBean.getTransaccion()));
								sentenciaStore.setDate("Par_FechaProyeccion", OperacionesFechas.conversionStrDate(consolidacionesBean.getFechaDesembolso()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ConsolidacionesDAO.proyeccionInteres");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Proyección de Intereses de Créditos Consolidados ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta de Crédito Consolidado
	public ConsolidacionesBean consultaCreditoConsolidado(final ConsolidacionesBean consolidacionesBean, final int tipoConsulta) {
		try {
			String query = "CALL CRECONSOLIDAAGROCON(?,?,?," +
													"?,"+
													"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getTransaccion()),
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.consultaCreditoConsolidado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL CRECONSOLIDAAGROCON(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidaciones = new ConsolidacionesBean();
					try {
						consolidaciones.setCreditoID(resultSet.getString("CreditoID"));
						consolidaciones.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
						consolidaciones.setMontoCredito(resultSet.getString("Monto"));
						consolidaciones.setFuenteFondeo(resultSet.getString("Fondeo"));
						consolidaciones.setEstatus(resultSet.getString("Estatus"));

						consolidaciones.setGarantiaFira(resultSet.getString("GarantiaFIRA"));
						consolidaciones.setGarantiaLiquida(resultSet.getString("GarantiaLiq"));
						consolidaciones.setMontoExigible(resultSet.getString("SaldoActual"));
						consolidaciones.setDescripcion(resultSet.getString("Descripcion"));
						consolidaciones.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return consolidaciones;
				}
			});
			return matches.size() > 0 ? (ConsolidacionesBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// Consulta de Crédito Consolidado
	public ConsolidacionesBean asignaGarantiaFira(final ConsolidacionesBean consolidacionesBean, final int tipoConsulta) {
		try {
			String query = "CALL CRECONSOLIDAAGROCON(?,?,?," +
													"?,"+
													"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getTransaccion()),
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.asignaGarantiaFira",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL CRECONSOLIDAAGROCON(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidaciones = new ConsolidacionesBean();
					try {
						consolidaciones.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
						consolidaciones.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
						consolidaciones.setActivaCombo(resultSet.getString("ActivaCombo"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return consolidaciones;
				}
			});
			return matches.size() > 0 ? (ConsolidacionesBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// Validación de Cliente Consolidado
	public ConsolidacionesBean validaClienteConsolidado(final ConsolidacionesBean consolidacionesBean, final int tipoConsulta) {
		try {
			String query = "CALL CLIENTECONSOLIDADOCON(?,?," +
													  "?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(consolidacionesBean.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.validaClienteConsolidado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL CLIENTECONSOLIDADOCON(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidaciones = new ConsolidacionesBean();
					try {

						consolidaciones.setClienteID(resultSet.getString("ClienteID"));
						consolidaciones.setIdentificacion(resultSet.getString("Identificacion"));
						consolidaciones.setDireccion(resultSet.getString("Direccion"));
						consolidaciones.setCuentaAhorro(resultSet.getString("CuentaAhorro"));
						consolidaciones.setEsConsolidadoAgro(resultSet.getString("EsClienteConsolidado"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return consolidaciones;
				}
			});
			return matches.size() > 0 ? (ConsolidacionesBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// Consulta de Crédito Consolidado
	public ConsolidacionesBean consultaConsolidacion(final ConsolidacionesBean consolidacionesBean, final int tipoConsulta) {
		try {
			String query = "CALL CRECONSOLIDAAGROENCCON( ?,?,?,?," +
														"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getSolicitudCreditoID()),
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.consultaConsolidacion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL CRECONSOLIDAAGROENCCON(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidaciones = new ConsolidacionesBean();
					try {
						consolidaciones.setFolioConsolidaID(resultSet.getString("FolioConsolida"));
						consolidaciones.setFechaConsolida(resultSet.getString("FechaConsolida"));
						consolidaciones.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
						consolidaciones.setCreditoID(resultSet.getString("CreditoID"));
						consolidaciones.setFechaDesembolso(resultSet.getString("FechaDesembolso"));

						consolidaciones.setCantidadRegistros(resultSet.getString("CantRegistros"));
						consolidaciones.setMontoConsolidado(resultSet.getString("MontoConsolidado"));
						consolidaciones.setEstatus(resultSet.getString("Estatus"));
						consolidaciones.setDeudorOriginalID(resultSet.getString("DeudorOriginalID"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return consolidaciones;
				}
			});
			return matches.size() > 0 ? (ConsolidacionesBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// Monto Total Consolidado
	public ConsolidacionesBean montoConsolidado(final ConsolidacionesBean consolidacionesBean, final int tipoConsulta) {
		try {
			String query = "CALL CRECONSOLIDAAGROENCCON( ?,?,?,?," +
														"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getSolicitudCreditoID()),
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.montoConsolidado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL CRECONSOLIDAAGROENCCON(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidaciones = new ConsolidacionesBean();
					try {
						consolidaciones.setMontoExigible(resultSet.getString("MontoExigible"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return consolidaciones;
				}
			});
			return matches.size() > 0 ? (ConsolidacionesBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// Lista de Creditos consolidados
	public List<ConsolidacionesBean> listaCreditoConsolidado(ConsolidacionesBean consolidacionesBean, int tipoLista) {
		List<ConsolidacionesBean> listaConsolidacionesBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CRECONSOLIDAAGROLIS(?,?,?,?," +
													"?," +
													"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				Utileria.convierteEntero(consolidacionesBean.getClienteID()),
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getTransaccion()),

				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.listaCreditoConsolidado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CRECONSOLIDAAGROLIS(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidacion = new ConsolidacionesBean();

					consolidacion.setCreditoID(resultSet.getString("CreditoID"));
					consolidacion.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
					consolidacion.setTipoGarantia(resultSet.getString("TipoGarantia"));
					consolidacion.setEstatus(resultSet.getString("Estatus"));

					return consolidacion;
				}
			});

			listaConsolidacionesBean = matches;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de Créditos Consolidados por Cliente", exception);
		}
		return listaConsolidacionesBean;
	}

	// Lista Grid de Creditos consolidados
	public List<ConsolidacionesBean> listaGridCreditoConsolidado(ConsolidacionesBean consolidacionesBean, int tipoLista) {
		List<ConsolidacionesBean> listaConsolidacionesBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CRECONSOLIDAAGROLIS(?,?,?,?," +
													"?," +
													"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(consolidacionesBean.getCreditoID()),
				Utileria.convierteEntero(consolidacionesBean.getClienteID()),
				Utileria.convierteLong(consolidacionesBean.getFolioConsolidaID()),
				Utileria.convierteLong(consolidacionesBean.getTransaccion()),

				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConsolidacionesDAO.listaCreditoConsolidado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CRECONSOLIDAAGROLIS(  " + Arrays.toString(parametros) + ")");
			List<ConsolidacionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionesBean consolidacion = new ConsolidacionesBean();

					consolidacion.setFolioConsolidaID(resultSet.getString("FolioConsolidaID"));
					consolidacion.setDetalleFolioConsolidaID(resultSet.getString("DetalleFolioConsolidaID"));
					consolidacion.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					consolidacion.setCreditoID(resultSet.getString("CreditoID"));
					consolidacion.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));

					consolidacion.setMontoCredito(resultSet.getString("MontoCredito"));
					consolidacion.setFuenteFondeo(resultSet.getString("FuenteFondeo"));
					consolidacion.setEstatus(resultSet.getString("Estatus"));
					consolidacion.setGarantiaFira(resultSet.getString("GarantiaFIRA"));
					consolidacion.setGarantiaLiquida(resultSet.getString("GarantiaLiq"));

					consolidacion.setMontoExigible(resultSet.getString("SaldoActual"));
					consolidacion.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));

					return consolidacion;
				}
			});

			listaConsolidacionesBean = matches;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de Créditos Consolidados por Cliente", exception);
		}
		return listaConsolidacionesBean;
	}

}
