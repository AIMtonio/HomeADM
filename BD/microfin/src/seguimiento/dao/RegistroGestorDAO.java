package seguimiento.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import seguimiento.bean.RegistroGestorBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RegistroGestorDAO extends BaseDAO{
	public RegistroGestorDAO() {
		super();
	}

	public MensajeTransaccionBean altaCliente(final RegistroGestorBean registroGestorBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = bajaGestores(registroGestorBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean = altaClienteGestor(registroGestorBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Gestor Agregado Correctamente: "+registroGestorBean.getGestorID());
					mensajeBean.setNombreControl("gestorID");
					mensajeBean.setConsecutivoString(registroGestorBean.getGestorID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de clientes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaSucursal(final RegistroGestorBean registroGestorBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = bajaGestores(registroGestorBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean = altaClienteGestor(registroGestorBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					int i=0;
					for(i=0; i<registroGestorBean.getLsucursalID().size(); i++){
						registroGestorBean.setSucursalID((String) registroGestorBean.getLsucursalID().get(i));
						registroGestorBean.setDescripcion((String) registroGestorBean.getLdescripcion().get(i));

						mensajeBean = altaSucursalGestor(registroGestorBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Gestor Agregado Correctamente: "+registroGestorBean.getGestorID());
					mensajeBean.setNombreControl("gestorID");
					mensajeBean.setConsecutivoString(registroGestorBean.getGestorID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de sucursales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaZona(final RegistroGestorBean registroGestorBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = bajaGestores(registroGestorBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean = altaClienteGestor(registroGestorBean);
					if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
					}
					int i=0;
					for(i=0; i<registroGestorBean.getLestadoID().size(); i++){
						registroGestorBean.setEstadoID((String) registroGestorBean.getLestadoID().get(i));
						registroGestorBean.setMunicipioID((String) registroGestorBean.getLmunicipioID().get(i));
						registroGestorBean.setLocalidadID((String) registroGestorBean.getLlocalidadID().get(i));
						registroGestorBean.setColoniaID((String) registroGestorBean.getLcoloniaID().get(i));


						mensajeBean = altaZonaGestor(registroGestorBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Gestor Agregado Correctamente: "+registroGestorBean.getGestorID());
					mensajeBean.setNombreControl("gestorID");
					mensajeBean.setConsecutivoString(registroGestorBean.getGestorID());

				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de zonas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaPromotor(final RegistroGestorBean registroGestorBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = bajaGestores(registroGestorBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean = altaClienteGestor(registroGestorBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					int i=0;
					for(i=0; i<registroGestorBean.getLpromotorID().size(); i++){
						registroGestorBean.setPromotorID((String) registroGestorBean.getLpromotorID().get(i));
						registroGestorBean.setDescripcionProm((String) registroGestorBean.getLdescripcionProm().get(i));

						mensajeBean = altaPromotorGestor(registroGestorBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Gestor Agregado Correctamente: "+registroGestorBean.getGestorID());
					mensajeBean.setNombreControl("gestorID");
					mensajeBean.setConsecutivoString(registroGestorBean.getGestorID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de promotores", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Alta de Clientes */
	public MensajeTransaccionBean altaClienteGestor(final RegistroGestorBean registroGestorBean) {
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
									String query = "call SEGTOADMONGESTORALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GestorID",Utileria.convierteEntero(registroGestorBean.getGestorID()));
									sentenciaStore.setInt("Par_TipoGestionID",Utileria.convierteEntero(registroGestorBean.getTipoGestionID()));
									sentenciaStore.setInt("Par_SupervisorID",Utileria.convierteEntero(registroGestorBean.getSupervisorID()));
									sentenciaStore.setInt("Par_Ambito",Utileria.convierteEntero(registroGestorBean.getTipoAmbito()));

									//Parametros de Salida
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaGestor");
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
							throw new Exception(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaGestor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores" + e);
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

	/* Alta de Sucursales */
	public MensajeTransaccionBean altaSucursalGestor(final RegistroGestorBean registroGestorBean) {
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
									String query = "call SEGTOADMONXSUCURSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GestorID",Utileria.convierteEntero(registroGestorBean.getGestorID()));
									sentenciaStore.setInt("Par_TipoGestionID",Utileria.convierteEntero(registroGestorBean.getTipoGestionID()));
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(registroGestorBean.getSucursalID()));

									//Parametros de Salida
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaSucursalGestor");
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
							throw new Exception(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaSucursalGestor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Sucursal Gestor" + e);
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

	/* Alta de Zona Geografica */
	public MensajeTransaccionBean altaZonaGestor(final RegistroGestorBean registroGestorBean) {
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
									String query = "call SEGTOADMONXZONALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GestorID",Utileria.convierteEntero(registroGestorBean.getGestorID()));
									sentenciaStore.setInt("Par_TipoGestionID",Utileria.convierteEntero(registroGestorBean.getTipoGestionID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(registroGestorBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(registroGestorBean.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(registroGestorBean.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(registroGestorBean.getColoniaID()));

									//Parametros de Salida
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaZonaGestor");
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
							throw new Exception(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaZonaGestor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Zona Geografica Gestor" + e);
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

	/* Alta de Promotores */
	public MensajeTransaccionBean altaPromotorGestor(final RegistroGestorBean registroGestorBean) {
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
									String query = "call SEGTOADMONXPROMOALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GestorID",Utileria.convierteEntero(registroGestorBean.getGestorID()));
									sentenciaStore.setInt("Par_TipoGestionID",Utileria.convierteEntero(registroGestorBean.getTipoGestionID()));
									sentenciaStore.setInt("Par_PromotorID",Utileria.convierteEntero(registroGestorBean.getPromotorID()));

									//Parametros de Salida
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaPromotorGestor");
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
							throw new Exception(Constantes.MSG_ERROR + " .RegistroGestorDAO.altaPromotorGestor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Promotores" + e);
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

	/* Consuta de Cliente*/
	public RegistroGestorBean consultaGestor(int tipoConsulta, RegistroGestorBean registroGestorBean) {
		RegistroGestorBean registroGestor = null;
		try{
		//Query con el Store Procedure
		String query = "call SEGTOADMONGESTORCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	registroGestorBean.getGestorID(),
								registroGestorBean.getTipoGestionID(),
								registroGestorBean.getSupervisorID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RegistroGestorDAO.consultaGestor",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONGESTORCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							RegistroGestorBean registroGestorBean = new RegistroGestorBean();
							registroGestorBean.setGestorID(resultSet.getString("GestorID"));
							registroGestorBean.setNombreGestor(resultSet.getString("NombreCompleto"));
							registroGestorBean.setTipoGestionID(resultSet.getString("TipoGestionID"));
							registroGestorBean.setNombreTipoGestion(resultSet.getString("Descripcion"));
							registroGestorBean.setSupervisorID(resultSet.getString("SupervisorID"));
							registroGestorBean.setNombreSupervisor(resultSet.getString("NombreCompleto"));
							registroGestorBean.setTipoAmbito(resultSet.getString("Ambito"));


						return registroGestorBean;
					}
		});
		registroGestor = matches.size() > 0 ? (RegistroGestorBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de gestores", e);

	}
	return registroGestor;
	}

	/* Consuta Sucursal*/
	public List consultaSucursalGestor(RegistroGestorBean registroGestorBean, int tipoConsulta){
		List gestorSucursal= null ;
		try{
			String query = "call SEGTOADMONXSUCURSCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					registroGestorBean.getGestorID(),
					registroGestorBean.getTipoGestionID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"RegistroGestorDAO.consultaSucursalGestor",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONXSUCURSCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegistroGestorBean gestorSuc = new RegistroGestorBean();
					gestorSuc.setSucursalID(resultSet.getString("SucursalID"));
					gestorSuc.setDescripcion(resultSet.getString("NombreSucurs"));
					return gestorSuc;
				}
			});
			gestorSucursal =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de sucursal de gestores", e);
		}
		return gestorSucursal;
	}

	/* Consuta Zona */
	public List consultaZonaGestor(RegistroGestorBean registroGestorBean, int tipoConsulta){
		List gestorZona= null ;
		try{
			String query = "call SEGTOADMONXZONACON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					registroGestorBean.getGestorID(),
					registroGestorBean.getTipoGestionID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"RegistroGestorDAO.consultaZonaGestor",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONXZONACON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegistroGestorBean gestorZona = new RegistroGestorBean();
					gestorZona.setEstadoID(resultSet.getString("EstadoID"));
					gestorZona.setDescripcionEst(resultSet.getString("Nombre"));
					gestorZona.setMunicipioID(resultSet.getString("MunicipioID"));
					gestorZona.setDescripcionMun(resultSet.getString("NombreMunicipio"));
					gestorZona.setLocalidadID(resultSet.getString("LocalidadID"));
					gestorZona.setDescripcionLoc(resultSet.getString("NombreLocalidad"));
					gestorZona.setColoniaID(resultSet.getString("ColoniaID"));
					gestorZona.setDescripcionCol(resultSet.getString("NombreColonia"));
					return gestorZona;
				}
			});
			gestorZona =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de zona geografica de gestores", e);
		}
		return gestorZona;
	}

	/* Consuta Promotor */
	public List consultaPromotorGestor(RegistroGestorBean registroGestorBean, int tipoConsulta){
		List gestorPromotor= null ;
		try{
			String query = "call SEGTOADMONXPROMOCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					registroGestorBean.getGestorID(),
					registroGestorBean.getTipoGestionID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"RegistroGestorDAO.consultaPromotorGestor",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONXPROMOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegistroGestorBean gestorPromotor = new RegistroGestorBean();
					gestorPromotor.setPromotorID(resultSet.getString("PromotorID"));
					gestorPromotor.setDescripcionProm(resultSet.getString("NombrePromotor"));

					return gestorPromotor;
				}
			});
			gestorPromotor =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de promotores de gestores", e);
		}
		return gestorPromotor;
	}



	/* Baja de Gestores  */
	public MensajeTransaccionBean bajaGestores(final RegistroGestorBean registroGestorBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SEGTOADMONGESTORBAJ(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							registroGestorBean.getGestorID(),
							registroGestorBean.getTipoGestionID(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegistroGestorDAO.eliminaGestores",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONGESTORBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Gestores", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	// Lista Tipo de Gestor filtrada por Gestor
	public List listaTipoGestor(final RegistroGestorBean registroGestorBean, int tipoLista) {
		List listaResultado = null;
		try{
			//Query con el Store Procedure
			String query = "call SEGTOADMONGESTORLIS(?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(registroGestorBean.getGestorID()),
									registroGestorBean.getTipoGestionID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegistroGestorDAO.listaTipoGestor",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOADMONGESTORLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RegistroGestorBean registroGestor = new RegistroGestorBean();
					registroGestor.setTipoGestionID(resultSet.getString("TipoGestionID"));
					registroGestor.setNombreTipoGestion(resultSet.getString("Descripcion"));
					registroGestor.setDescripcion(resultSet.getString("UsuarioID"));

					return registroGestor;
				}
			});
			listaResultado =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de tipo de gestor: " +e);
		}
		return listaResultado;
	}
}