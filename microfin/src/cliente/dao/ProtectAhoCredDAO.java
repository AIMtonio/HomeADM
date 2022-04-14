package cliente.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;



import cliente.bean.ProtecionAhorroCreditoBean;
import cliente.servicio.ProtectAhoCredServicio.Enum_Tra_Actualizacion;
import cuentas.bean.CuentasAhoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import seguridad.servicio.SeguridadRecursosServicio;
import ventanilla.bean.IngresosOperacionesBean;

public class ProtectAhoCredDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public ProtectAhoCredDAO(){
		super();
	}

	// Alta de Cuentas y Creditos al autorizar la proteccion
	public MensajeTransaccionBean autorizaProteccionPro(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean, final List listaCuentas, final List listaCreditos, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ProtecionAhorroCreditoBean protecionAhorroCredito;

					/* si se trata de una actualizacion por autorizacion de solicitud, se dan de alta los creditos o cuentas
					 * seleccionados por la persona que realiza la autorizacion */
					if( tipoActualizacion == Enum_Tra_Actualizacion.autoriza ) 	{
						for(int i=0; i<listaCreditos.size(); i++){
							protecionAhorroCredito = (ProtecionAhorroCreditoBean)listaCreditos.get(i);
							mensajeBean = altaCreditosProteccion(protecionAhorroCredito, protecionAhorroCreditoBean,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						for(int i=0; i<listaCuentas.size(); i++){
							protecionAhorroCredito = (ProtecionAhorroCreditoBean)listaCuentas.get(i);
							if(Utileria.convierteDoble(protecionAhorroCredito.getMonAplicaCuenta()) >0){
								mensajeBean = altaCuentasProteccion(protecionAhorroCredito,protecionAhorroCreditoBean, parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}

					/* se llama a sp para autorizar o rechazar una solicitud */
					mensajeBean = autorizaRechazaProteccion(protecionAhorroCreditoBean,parametrosAuditoriaBean.getNumeroTransaccion(), tipoActualizacion);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta proteccion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Alta de Cuentas para la proteccion
	public MensajeTransaccionBean altaCuentasProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
													  final ProtecionAhorroCreditoBean protecionAhorroCredito,final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIAPROTECCUENALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(protecionAhorroCreditoBean.getCuentaAhoID()));
								sentenciaStore.setDouble("Par_MontoAplica",Utileria.convierteDoble(protecionAhorroCreditoBean.getMonAplicaCuenta()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Cuentas para la proteccion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	// Alta de Creditos para la proteccion
	public MensajeTransaccionBean altaCreditosProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
			  												final ProtecionAhorroCreditoBean protecionAhorroCredito,final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIAPROTECCREDALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(protecionAhorroCreditoBean.getCreditoID()));
								sentenciaStore.setDouble("Par_MontoAplicaCred",Utileria.convierteDoble(protecionAhorroCreditoBean.getMonAplicaCredito()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Protección de creditos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	// Baja CUENTAS Proteccion
	//public MensajeTransaccionBean bajaCuentasProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
	//												final int tipoBaja, final long numTransaccion){
	//	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	//	mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
	//		public Object doInTransaction(TransactionStatus transaction) {
	//			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
	//			try {
	//				// Query con el Store Procedure
	//				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
	//					new CallableStatementCreator() {
	//						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
	//							String query = "call CLIAPROTECCUENBAJ(?,?,?,?,?, ?,?,?,?,?, ?,?);";
	//							CallableStatement sentenciaStore = arg0.prepareCall(query);
	//
	//							sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCreditoBean.getClienteID()));
	//							sentenciaStore.setLong("Par_NumBaj",tipoBaja);
	//							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
	//							sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
	//							sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
	//
	//							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
	//							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
	//							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
	//							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
	//							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
	//							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
	//							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
	//							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
	//
	//
	//							return sentenciaStore;
	//						}
	//					},new CallableStatementCallback() {
	//						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
	//																										DataAccessException {
	//							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
	//							if(callableStatement.execute()){
	//								ResultSet resultadosStore = callableStatement.getResultSet();
	//
	//								resultadosStore.next();
	//								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
	//								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
	//								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
	//								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
	//
	//							}else{
	//								mensajeTransaccion.setNumero(999);
	//								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
	//							}
	//
	//							return mensajeTransaccion;
	//						}
	//					}
	//					);
	//
	//				if(mensajeBean ==  null){
	//					mensajeBean = new MensajeTransaccionBean();
	//					mensajeBean.setNumero(999);
	//					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
	//				}else if(mensajeBean.getNumero()!=0){
	//					throw new Exception(mensajeBean.getDescripcion());
	//				}
	//			} catch (Exception e) {
	//
	//				if (mensajeBean.getNumero() == 0) {
	//					mensajeBean.setNumero(999);
	//				}
	//				mensajeBean.setDescripcion(e.getMessage());
	//				transaction.setRollbackOnly();
	//				e.printStackTrace();
	//				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Ceuantas para la proteccion", e);
	//			}
	//			return mensajeBean;
	//		}
	//	});
	//	return mensaje;
	//
	//}
	// Baja CREDITOS Proteccion
	//public MensajeTransaccionBean bajaCreditosProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
	//												final int tipoBaja, final long numTransaccion){
	//	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	//	mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
	//		public Object doInTransaction(TransactionStatus transaction) {
	//			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
	//			try {
	//				// Query con el Store Procedure
	//				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
	//					new CallableStatementCreator() {
	//						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
	//							String query = "call CLIAPROTECCREDBAJ(?,?,?,?,?, ?,?,?,?,?, ?,?);";
	//							CallableStatement sentenciaStore = arg0.prepareCall(query);
	//
	//							sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCreditoBean.getClienteID()));
	//							sentenciaStore.setLong("Par_NumBaj",tipoBaja);
	//							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
	//							sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
	//							sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
	//
	//							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
	//							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
	//							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
	//							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
	//							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
	//							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
	//							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
	//							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
	//
	//
	//							return sentenciaStore;
	//						}
	//					},new CallableStatementCallback() {
	//						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
	//																										DataAccessException {
	//							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
	//							if(callableStatement.execute()){
	//								ResultSet resultadosStore = callableStatement.getResultSet();
	//
	//								resultadosStore.next();
	//								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
	//								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
	//								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
	//								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
	//
	//							}else{
	//								mensajeTransaccion.setNumero(999);
	//								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
	//							}
	//
	//							return mensajeTransaccion;
	//						}
	//					}
	//					);
	//
	//				if(mensajeBean ==  null){
	//					mensajeBean = new MensajeTransaccionBean();
	//					mensajeBean.setNumero(999);
	//					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
	//				}else if(mensajeBean.getNumero()!=0){
	//					throw new Exception(mensajeBean.getDescripcion());
	//				}
	//			} catch (Exception e) {
	//
	//				if (mensajeBean.getNumero() == 0) {
	//					mensajeBean.setNumero(999);
	//				}
	//				mensajeBean.setDescripcion(e.getMessage());
	//				transaction.setRollbackOnly();
	//				e.printStackTrace();
	//				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Ceuantas para la proteccion", e);
	//			}
	//			return mensajeBean;
	//		}
	//	});
	//	return mensaje;
	//
	//}


	// Alta de la Proteccion del Cliente
	public MensajeTransaccionBean altaProteccion(final ProtecionAhorroCreditoBean protecionAhorroCredito){
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
								protecionAhorroCredito.setUsuarioReg(protecionAhorroCredito.getUsuarioReg().trim().replaceAll(",", "").replaceAll("\\$", ""));
								String query = "call CLIAPLICAPROTECALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setInt("Par_UsuarioReg",Utileria.convierteEntero(protecionAhorroCredito.getUsuarioReg()));
								sentenciaStore.setString("Par_ActaDefuncion", protecionAhorroCredito.getActaDefuncion());
								sentenciaStore.setString("Par_FechaDefuncion", Utileria.convierteFecha(protecionAhorroCredito.getFechaDefuncion()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Protección", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


//	// Alta de Cuentas y Creditos para la proteccion
//	public MensajeTransaccionBean autorizaProteccionPro(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
//														 final List listaCreditos, final List listaCuentas) {
//		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
//		transaccionDAO.generaNumeroTransaccion();
//		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
//			public Object doInTransaction(TransactionStatus transaction) {
//				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
//				try {
//					String Autorizar="A";
//
//					ProtecionAhorroCreditoBean protecionAhorroCredito;
//					if(protecionAhorroCreditoBean.getProceso().equalsIgnoreCase(Autorizar)){ //Si se va Autorizar entonces se modifican los beneficios
//						for(int i=0; i<listaCreditos.size(); i++){
//							protecionAhorroCredito = (ProtecionAhorroCreditoBean)listaCreditos.get(i);
//							mensajeBean = actualizaCreditosProteccion(protecionAhorroCredito, protecionAhorroCreditoBean,parametrosAuditoriaBean.getNumeroTransaccion());
//							if(mensajeBean.getNumero()!=0){
//								throw new Exception(mensajeBean.getDescripcion());
//							}
//						}
//						for(int i=0; i<listaCuentas.size(); i++){
//							protecionAhorroCredito = (ProtecionAhorroCreditoBean)listaCuentas.get(i);
//							mensajeBean = actualizaCuentasProteccion(protecionAhorroCredito,protecionAhorroCreditoBean, parametrosAuditoriaBean.getNumeroTransaccion());
//							if(mensajeBean.getNumero()!=0){
//								throw new Exception(mensajeBean.getDescripcion());
//							}
//						}
//					}
//
//					mensajeBean = autorizaProteccion(protecionAhorroCreditoBean,parametrosAuditoriaBean.getNumeroTransaccion());
//					if(mensajeBean.getNumero()!=0){
//						throw new Exception(mensajeBean.getDescripcion());
//					}
//
//					mensajeBean.setDescripcion("Solicitud de Protección Autorizada Correctamente");
//					mensajeBean.setNombreControl("clienteID");
//
//				} catch (Exception e) {
//					if(mensajeBean.getNumero()==0){
//						mensajeBean.setNumero(999);
//					}
//					mensajeBean.setDescripcion(e.getMessage());
//					transaction.setRollbackOnly();
//					e.printStackTrace();
//					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error la Solicitud de protección de credito", e);
//				}
//				return mensajeBean;
//			}
//		});
//		return mensaje;
//	}

	// Actualiza  Cuentas para la proteccion
	public MensajeTransaccionBean actualizaCuentasProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
													  final ProtecionAhorroCreditoBean protecionAhorroCredito,final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIAPROTECCUENACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(protecionAhorroCreditoBean.getCuentaAhoID()));

								sentenciaStore.setDouble("Par_MontoAplica",Utileria.convierteDoble(protecionAhorroCreditoBean.getMonAplicaCuenta()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizacion de Ceuantas para la proteccion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	// Actualiza de Creditos para la proteccion
	public MensajeTransaccionBean actualizaCreditosProteccion(final ProtecionAhorroCreditoBean protecionAhorroCreditoBean,
			  												final ProtecionAhorroCreditoBean protecionAhorroCredito,final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CLIAPROTECCREDACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(protecionAhorroCreditoBean.getCreditoID()));
								sentenciaStore.setDouble("Par_MontoAplicaCred",Utileria.convierteDoble(protecionAhorroCreditoBean.getMonAplicaCredito()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualización de Protección de creditos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	// Autorizacion y alta de beneficiarios de la proteccion
	public MensajeTransaccionBean autorizaRechazaProteccion(final ProtecionAhorroCreditoBean protecionAhorroCredito, final long numTransaccion, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								protecionAhorroCredito.setUsuarioAut(protecionAhorroCredito.getUsuarioAut().trim().replaceAll(",", "").replaceAll("\\$", ""));
								protecionAhorroCredito.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(protecionAhorroCredito.getClaveUsuario(), protecionAhorroCredito.getContraseniaAut()));

								String query = "call CLIAPLICAPROTECPRO(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
								sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(protecionAhorroCredito.getUsuarioAut()));
								sentenciaStore.setString("Par_Comentario",protecionAhorroCredito.getComentario());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion/*parametrosAuditoriaBean.getNumeroTransaccion()*/);
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Protección", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	// Autorizacion y alta de beneficiarios de la proteccion
		public MensajeTransaccionBean autorizaRechazaProteccion(final ProtecionAhorroCreditoBean protecionAhorroCredito, final int tipoActualizacion){
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

									protecionAhorroCredito.setUsuarioAut(protecionAhorroCredito.getUsuarioAut().trim().replaceAll(",", "").replaceAll("\\$", ""));
									protecionAhorroCredito.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(protecionAhorroCredito.getClaveUsuario(), protecionAhorroCredito.getContraseniaAut()));

									String query = "call CLIAPLICAPROTECPRO(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_ClienteID",Utileria.convierteLong(protecionAhorroCredito.getClienteID()));
									sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(protecionAhorroCredito.getUsuarioAut()));
									sentenciaStore.setString("Par_Comentario",protecionAhorroCredito.getComentario());
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Protección", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;

		}



	public MensajeTransaccionBean pagoProteccionCta(final IngresosOperacionesBean ingresosOperacionesBean,
													final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call PAGOPROTECAHOPRO(?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);

				sentenciaStore.setInt("Par_PersonaID", Utileria.convierteEntero(ingresosOperacionesBean.getPersonaRelacionID()));
				sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));

				sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
				sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

				sentenciaStore.setString("Par_AltaEncPoliza",ingresosOperacionesBean.getAltaEnPoliza());
				sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
				sentenciaStore.setString("Par_AltaDetPol",ingresosOperacionesBean.getAltaDetPoliza());

				sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

				sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
				sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
				sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
				sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
				sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
				sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
				sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);


				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
				return sentenciaStore;
				}},new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
											DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
						if(callableStatement.execute()){
							ResultSet resultadosStore = callableStatement.getResultSet();
								resultadosStore.next();

							mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
							mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
							mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
							mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
						}else{
							mensajeTransaccion.setNumero(999);
							mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}
					return mensajeTransaccion;
					}
				});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			}catch (Exception e) {
				if (mensajeBean.getNumero()==0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Proteccion de Ahorro", e);
				transaction.setRollbackOnly();
			}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	// Consultra Proteccion del Cliente
	public ProtecionAhorroCreditoBean consultaPrincipal(ProtecionAhorroCreditoBean protecionAhorroCreditoBean, int tipoConsulta){
		String query = "call CLIAPLICAPROTECCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(protecionAhorroCreditoBean.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPLICAPROTECCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

				protecionAhorroCredito.setClienteID(resultSet.getString("ClienteID"));
				protecionAhorroCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));
				protecionAhorroCredito.setUsuarioReg(resultSet.getString("UsuarioReg"));
				protecionAhorroCredito.setUsuarioAut(resultSet.getString("UsuarioAut"));
				protecionAhorroCredito.setFechaAutoriza(resultSet.getString("FechaAutoriza"));

				protecionAhorroCredito.setUsuarioRechaza(resultSet.getString("UsuarioRechaza"));
				protecionAhorroCredito.setFechaRechaza(resultSet.getString("FechaRechaza"));
				protecionAhorroCredito.setEstatus(resultSet.getString("Estatus"));
				protecionAhorroCredito.setComentario(resultSet.getString("Comentario"));
				protecionAhorroCredito.setMonAplicaCuenta(resultSet.getString("MonAplicaCuenta"));

				protecionAhorroCredito.setMonAplicaCredito(resultSet.getString("MonAplicaCredito"));
				protecionAhorroCredito.setActaDefuncion(resultSet.getString("ActaDefuncion"));
				protecionAhorroCredito.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
				return protecionAhorroCredito;
			}
		});
		return matches.size() > 0 ? (ProtecionAhorroCreditoBean) matches.get(0) : null;
	}

	// Lista de beneficiarios de una cuenta con proteccion
	public List listaBeneficiariosCte(ProtecionAhorroCreditoBean protecionAhorroCreditoBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CLIAPROTECBENLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(protecionAhorroCreditoBean.getClienteID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"listaCreditoProtec",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPROTECBENLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

					protecionAhorroCredito.setClienteID(resultSet.getString("ClienteID"));
					protecionAhorroCredito.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					protecionAhorroCredito.setClienteID(resultSet.getString("ClienteBenID"));
					protecionAhorroCredito.setNombre(resultSet.getString("NombreBene"));

					protecionAhorroCredito.setRelacion(resultSet.getString("Descripcion"));
					protecionAhorroCredito.setSaldo(resultSet.getString("SaldoCta"));
					protecionAhorroCredito.setMonAplicaCuenta(resultSet.getString("MonAplicaCuenta"));
					protecionAhorroCredito.setPorcentaje(resultSet.getString("Porcentaje"));
					protecionAhorroCredito.setTotalRecibir(resultSet.getString("CantidadRecibir"));
					protecionAhorroCredito.setPersonaID(resultSet.getString("PersonaID"));
					protecionAhorroCredito.setEstatus(resultSet.getString("Estatus"));
					protecionAhorroCredito.setNombRecibePago(resultSet.getString("NombRecibePago"));

					return protecionAhorroCredito;

				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Beneficiarios", e);
		}
		return listaCredAutInac;
	}




	// Lista de Clientes
	public List listaClientesProteccion(ProtecionAhorroCreditoBean protecionAhorroCreditoBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CLIAPLICAPROTECLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					protecionAhorroCreditoBean.getNombre(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"listaClientesProteccion",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPLICAPROTECLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

					protecionAhorroCredito.setClienteID(resultSet.getString(1));
					protecionAhorroCredito.setNombre(resultSet.getString(2));

					return protecionAhorroCredito;

				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en  la lista de Clientes con el programa de proteccion", e);
		}
		return listaCredAutInac;

	}


	// Lista de CUENTAS que se encuentran en el programa de la proteccion
	public List listaGridProteccionAhorro(ProtecionAhorroCreditoBean protecionAhorroCreditoBean, int tipoLista){
		String query = "call CLIAPROTECCUENLIS(?,?,?,?,?,	?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(protecionAhorroCreditoBean.getClienteID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPROTECCUENLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

				protecionAhorroCredito.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				protecionAhorroCredito.setClienteID(resultSet.getString("ClienteID"));
				protecionAhorroCredito.setDescripcionTipoCta(resultSet.getString("Descripcion"));
				protecionAhorroCredito.setEtiqueta(resultSet.getString("Etiqueta"));
				protecionAhorroCredito.setSaldo(resultSet.getString("Saldo"));
				protecionAhorroCredito.setMonAplicaCuenta(resultSet.getString("MonAplicaCuenta"));

				return protecionAhorroCredito;


			}
		});
		return matches;
	}

	public List listaGridCuentasAhorro(ProtecionAhorroCreditoBean cuentasAho, int tipoLista){
		String query = "call PROTECCIONESCTALIS(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(cuentasAho.getClienteID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),

					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

				protecionAhorroCredito.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				protecionAhorroCredito.setClienteID(resultSet.getString("ClienteID"));
				protecionAhorroCredito.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
				protecionAhorroCredito.setDescripcionTipoCta(resultSet.getString("Descripcion"));
				protecionAhorroCredito.setSaldo(resultSet.getString("Saldo"));
				return protecionAhorroCredito;
			}
		});
		return matches;
	}

	// Lista de Creditos que estan en el programa de Proteccion, grid
	public List listaCreditoProtec(ProtecionAhorroCreditoBean protecionAhorroCreditoBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CLIAPROTECCREDLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(protecionAhorroCreditoBean.getClienteID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"listaCreditoProtec",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPROTECCREDLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProtecionAhorroCreditoBean protecionAhorroCredito = new ProtecionAhorroCreditoBean();

					protecionAhorroCredito.setClienteID(resultSet.getString("ClienteID"));
					protecionAhorroCredito.setCreditoID(resultSet.getString("CreditoID"));
					protecionAhorroCredito.setTotalAdeudo(resultSet.getString("MontoAdeudo"));
					protecionAhorroCredito.setEstatus(resultSet.getString("Estatus"));
					protecionAhorroCredito.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					protecionAhorroCredito.setMontoCredito(resultSet.getString("MontoCredito"));
					protecionAhorroCredito.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
					protecionAhorroCredito.setMonAplicaCredito(resultSet.getString("MontoAplicaCred"));
					return protecionAhorroCredito;

				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el resumen de cliente de credito", e);
		}
		return listaCredAutInac;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}

