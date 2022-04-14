package tarjetas.dao;
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

import cliente.servicio.ClienteServicio;
import soporte.servicio.ParamGeneralesServicio;
import tarjetas.bean.BitacoraEstatusTarCredBean;
import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.bean.TarjetaDebitoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarjetaCreditoDAO  extends BaseDAO{
	ClienteServicio clienteServicio = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	int tipoConsultaTD	= 10;
	String conexionEntura = "E";

	public TarjetaCreditoDAO() {
		super();
	}

	// BLOQUEO DE TARJETA DE CREDITO
	public MensajeTransaccionBean bloqueoTarjeta(final int tipoTransaccion, final TarjetaDebitoBean  tarjetaDebitoBean) {
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
								String query = "call TARCREDBLOQMANALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}







	///-------------------alta de tarjeta debito desbloqueo----------------
	public MensajeTransaccionBean desbloqueoTarjeta(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean) {

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
								String query = "call TARCREDDESBLOQMANALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	//--------------------------------------------cancelacion--------------------------
	public MensajeTransaccionBean cancelacionTarjetaDebito(final int tipoTransaccion, final TarjetaDebitoBean tarjetaDebitoBean) {

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
								String query = "call TARCREDCANCELALT(?,?,?,?,?,       ?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NumTarjeta",tarjetaDebitoBean.getTarjetaDebID());
								sentenciaStore.setInt("Par_TarjetaHabiente",Utileria.convierteEntero(tarjetaDebitoBean.getTarjetaHabiente()));
								sentenciaStore.setInt("Par_CorporativoID",Utileria.convierteEntero(tarjetaDebitoBean.getCoorporativo()));
								sentenciaStore.setInt("Par_MotivoBloqID",Utileria.convierteEntero(tarjetaDebitoBean.getMotivoBloqID()));
								sentenciaStore.setString("Par_DescAdicional",tarjetaDebitoBean.getDescripcion());

								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de personal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}







	public MensajeTransaccionBean activa(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {
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
									String query = "call TARCREDACTIVARALT(?,?,?, ?,?,?, ?,?,? ,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TarjetaCredID", tarjetaDebitoBean.getTarjetaDebID());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TarjetaDebitoDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Activacion de tarjeta de credito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}





// ASOCIA CUENTA

	public MensajeTransaccionBean altaLineaCred(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {

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
									String query = "call LINEATARJETACREDALT(?,?,?,?,?,	 	?,?,?,?,?,		 ?,?,?,?,?, 	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_ClienteID",tarjetaDebitoBean.getClienteID());
									sentenciaStore.setString("Par_TarjetaCredID",tarjetaDebitoBean.getTarjetaDebID());
									sentenciaStore.setString("Par_NombreUsuario",tarjetaDebitoBean.getNombreCompleto());
									sentenciaStore.setInt("Par_TipoTarjetaCred",Utileria.convierteEntero(tarjetaDebitoBean.getTipoTarjetaDebID()));
									sentenciaStore.setString("Par_TipoCorte",tarjetaDebitoBean.getTipoCorte());
									sentenciaStore.setInt("Par_DiaCorte",Utileria.convierteEntero(tarjetaDebitoBean.getDiaCorte()));
									sentenciaStore.setString("Par_TipoPago",tarjetaDebitoBean.getTipoPago());

									sentenciaStore.setInt("Par_DiaPago",Utileria.convierteEntero(tarjetaDebitoBean.getDiaPago()));
									sentenciaStore.setString("Par_Relacion",tarjetaDebitoBean.getRelacion());
									sentenciaStore.setString("Par_CuentaClabe",tarjetaDebitoBean.getCuentaClabe());
									sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr",Types.CHAR);
									sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								}
							}
							,new CallableStatementCallback() {
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tarjeta de debito", e);
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



	public MensajeTransaccionBean altaCuentaClabe(int tipoTransaccion,final TarjetaDebitoBean tarjetaDebitoBean) {

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
									String query = "call LINEATARJETACREDPRO(?,?,?,?,?, 	?,?,?,?,?,		?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_ClienteID",tarjetaDebitoBean.getClienteID());
									sentenciaStore.setString("Par_TarjetaCredID",tarjetaDebitoBean.getTarjetaDebID());
									sentenciaStore.setString("Par_CuentaClabe",tarjetaDebitoBean.getCuentaClabe());
									sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr",Types.CHAR);

									sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								}
							}
							,new CallableStatementCallback() {
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tarjeta de cuenta clabe", e);
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




	// lista de tarjeta
	public List TarjetaCredito(int tipoLista,TarjetaCreditoBean tarjetaCreditoBean ) {


		String query = "call TARJETACREDITOLIS(?,?,?,?,?,    ?,?,?,?,?,	?,?);";
		Object[] parametros = {
				tarjetaCreditoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TipoTarjetaCredDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				TarjetaCreditoBean tarjetaCreditoBean= new TarjetaCreditoBean();
				tarjetaCreditoBean.setTarjetaCredID(resultSet.getString(1));
				tarjetaCreditoBean.setNombreComp(resultSet.getString(2));


				return tarjetaCreditoBean;

			}
		});
		return matches;
	}



	public List TarCredListaCta(int tipoLista,TarjetaCreditoBean tarjetaCreditoBean ) {
		String query = "call TARJETACREDITOLIS(?,?,?,?,?    ,?,?,?,?,?, 	?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tarjetaCreditoBean.getClienteID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),

				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TARJETACREDITOLIS.TarCredListaCta",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {

				TarjetaDebitoBean tarjetaDebitoBean= new TarjetaDebitoBean();
				tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaDebitoBean.setRelacion(resultSet.getString("Relacion"));
				tarjetaDebitoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjeta"));
				return tarjetaDebitoBean;
			}
		});
		return matches;
	}





	/// consulta principal
	public TarjetaCreditoBean principal(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
		String query = "call TARJETACREDITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				tarjetaCreditoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TipoTarjetaCredDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
				tarjetaCreditoBean.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
				tarjetaCreditoBean.setLoteDebitoID(resultSet.getString("LoteCreditoID"));
				tarjetaCreditoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				tarjetaCreditoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				tarjetaCreditoBean.setFechaActivacion(resultSet.getString("FechaActivacion"));
				tarjetaCreditoBean.setEstatus(resultSet.getString("Estatus"));
				tarjetaCreditoBean.setClienteID(resultSet.getString("ClienteID"));


				tarjetaCreditoBean.setFechaBloqueo(resultSet.getString("FechaBloqueo"));
				tarjetaCreditoBean.setMotivoBloqueo(resultSet.getString("MotivoBloqueo"));
				tarjetaCreditoBean.setFechaCancelacion(resultSet.getString("FechaCancelacion"));
				tarjetaCreditoBean.setMotivoCancelacion(resultSet.getString("MotivoCancelacion"));
				tarjetaCreditoBean.setFechaDesbloqueo(resultSet.getString("FechaDesbloqueo"));

				tarjetaCreditoBean.setMotivoDesbloqueo(resultSet.getString("MotivoDesbloqueo"));
				tarjetaCreditoBean.setNIP(resultSet.getString("NIP"));
				tarjetaCreditoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
				tarjetaCreditoBean.setRelacion(resultSet.getString("Relacion"));
				tarjetaCreditoBean.setSucursalID(resultSet.getString("SucursalID"));
				tarjetaCreditoBean.setTipoTarjetaCredID(resultSet.getString("TipoTarjetaCredID"));

				return tarjetaCreditoBean;
			}
		});
		return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
	}


	//CONSULTA
	public TarjetaCreditoBean consultaTarjetaDeb(int tipoConsulta,TarjetaCreditoBean tarjetaCreditoBean){
		String query = "call TARJETACREDITOCON(?,?,?,?,?,?, ?,    ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaCreditoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaCreditoBean bloqueoTarCred = new TarjetaCreditoBean();
				bloqueoTarCred.setTarjetaCredID(resultSet.getString(1));
				bloqueoTarCred.setEstatus(resultSet.getString(2));
				bloqueoTarCred.setTarjetaHabiente(resultSet.getString(3));
				bloqueoTarCred.setNombreComp(resultSet.getString(4));
				bloqueoTarCred.setCoorporativo(resultSet.getString(5));
				bloqueoTarCred.setEstatusId(resultSet.getString(6));
			return bloqueoTarCred;
			}
		});

		return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
	}

	//------------------------------------consulta de bitacora de tarjeta credito  cancel-----------------------
	public TarjetaCreditoBean consultaTarCredBitacoraDesBloq(int tipoConsulta,TarjetaCreditoBean tarjetaCreditoBean){

		String query = "call TC_BITACORACON(?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaCreditoBean.getTarjetaDebID(),

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TC_BITACORACON.consultaBitacoTarjetaDeb",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TC_BITACORACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
				tarjetaCreditoBean.setTarjetaID(resultSet.getString(1));
				tarjetaCreditoBean.setEstatus(resultSet.getString(2));
				tarjetaCreditoBean.setTarjetaHabiente(resultSet.getString(3));
				tarjetaCreditoBean.setNombreComp(resultSet.getString(4));
				tarjetaCreditoBean.setCoorporativo(resultSet.getString(5));
				tarjetaCreditoBean.setMotivoBloqueo(resultSet.getString(6));
				tarjetaCreditoBean.setFechaBloqueo(resultSet.getString(7));
				tarjetaCreditoBean.setDescriBloqueo(resultSet.getString(8));
				tarjetaCreditoBean.setEstatusId(resultSet.getString(9));


					return tarjetaCreditoBean;
			}
		});

		return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
	}






	public TarjetaCreditoBean consultaTarjetaCancel(int tipoConsulta,TarjetaCreditoBean tarjetaCreditoBean){
		String query = "call TARJETACREDITOCON(?,?,?,?,?,?, ?,    ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarjetaCreditoBean.getTarjetaDebID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,

				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARJETADEBITOBCON.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarjetaCreditoBean bloqueoTarCred = new TarjetaCreditoBean();

				bloqueoTarCred.setTarjetaID(resultSet.getString(1));
				bloqueoTarCred.setTarjetaHabiente(resultSet.getString(2));
				bloqueoTarCred.setNombreComp(resultSet.getString(3));
				bloqueoTarCred.setEstatus(resultSet.getString(4));
				bloqueoTarCred.setCoorporativo(resultSet.getString(5));
				bloqueoTarCred.setEstatusId(resultSet.getString(6));

					return bloqueoTarCred;
			}
		});

		return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
	}



	public List listTarEstatus(TarjetaCreditoBean tarjetaDebitoBean, int tipoLista) {
		List listaTarjetas=null;
		try{
		String query = "call TARJETACREDITOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?);";
		Object[] parametros = {
								tarjetaDebitoBean.getTarjetaDebID(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,

								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoTarjetaCredDAO.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarjetaCreditoBean tarjetaDebito = new TarjetaCreditoBean();
				tarjetaDebito.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
				tarjetaDebito.setNombreComp(resultSet.getString("NombreCompleto"));
				tarjetaDebito.setTipo(resultSet.getString("TipoTarjeta"));
				return tarjetaDebito;
			}
		});

		listaTarjetas= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tarjetas de credito", e);
		}
		return listaTarjetas;
	}








	//Consulta datos de la tarjeta de debito consulta#9
		public TarjetaCreditoBean consultaTarDebAsigna(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaDebitoDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
					tarjetaCreditoBean.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
					tarjetaCreditoBean.setCorpRelacionado(resultSet.getString("CorpRelacionado"));
					tarjetaCreditoBean.setClienteID(resultSet.getString("ClienteCorporativo"));
					tarjetaCreditoBean.setEstatus(resultSet.getString("Estatus"));

					return tarjetaCreditoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}



		/* Lista de Tarjetas Existentes */
		public List listTarExistente(int tipoLista, TarjetaCreditoBean tarjetaCreditoBean ) {
			String query = "call TARJETACREDITOLIS(?,?,?,?,?,    ?,?,?,?,?,		?,?);";
			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TarjetaCreditoDAO.listTarExistente",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
					tarjetaCreditoBean.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
					tarjetaCreditoBean.setNombreComp(resultSet.getString("NombreCompleto"));
					return tarjetaCreditoBean;
				}
			});
			return matches;
		}



		/*Consulta de Tarjetas Existentes */
		public TarjetaCreditoBean consultaTarExistentes(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaCreditoDAO.consultaMovTarjetas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			@SuppressWarnings("unchecked")
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
					tarjetaCreditoBean.setTarjetaID(resultSet.getString("TarjetaCredID"));
					tarjetaCreditoBean.setDescripcion(resultSet.getString("Descripcion"));
					tarjetaCreditoBean.setClienteID(
					 (resultSet.getString("ClienteID")!=null) ?
							   Utileria.completaCerosIzquierda(
									   Utileria.convierteEntero(resultSet.getString("ClienteID")
											   ),BitacoraEstatusTarCredBean.LONGITUD_ID) : Constantes.STRING_VACIO );
					tarjetaCreditoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					tarjetaCreditoBean.setCoorporativo(resultSet.getString("CorpRelacionado"));
					tarjetaCreditoBean.setLineaCreditoID(
							 (resultSet.getString("LineaTarCredID")!=null) ?
									   Utileria.completaCerosIzquierda(
											   Utileria.convierteLong(resultSet.getString("LineaTarCredID")
													   ),BitacoraEstatusTarCredBean.LONGITUD_ID) : Constantes.STRING_VACIO);
					tarjetaCreditoBean.setDescripcionProd(resultSet.getString("ProductoDesc"));
					tarjetaCreditoBean.setTipoTarjetaID(resultSet.getString("TipoTarjetaDebID"));
					tarjetaCreditoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
					tarjetaCreditoBean.setEstatusId(resultSet.getString("Estatus"));
					tarjetaCreditoBean.setProductoID(resultSet.getString("ProductoID"));
					return tarjetaCreditoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}



		/*Consulta para la pantalla de Consulta de Movimientos por Tarjeta  */
		public TarjetaCreditoBean consultaMovTarjetas(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaCreditoDAO.consultaMovTarjetas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			@SuppressWarnings("unchecked")
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
					tarjetaCreditoBean.setTarjetaID(resultSet.getString("TarjetaCredID"));
					tarjetaCreditoBean.setDescripcion(resultSet.getString("Descripcion"));
					tarjetaCreditoBean.setClienteID(
					 (resultSet.getString("ClienteID")!=null) ?
							   Utileria.completaCerosIzquierda(
									   Utileria.convierteEntero(resultSet.getString("ClienteID")
											   ),BitacoraEstatusTarCredBean.LONGITUD_ID) : Constantes.STRING_VACIO );
					tarjetaCreditoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					tarjetaCreditoBean.setCoorporativo(resultSet.getString("CorpRelacionado"));
					tarjetaCreditoBean.setLineaCreditoID(
					 (resultSet.getString("LineaTarCredID")!=null) ?
							   Utileria.completaCerosIzquierda(
									   Utileria.convierteLong(resultSet.getString("LineaTarCredID")
											   ),BitacoraEstatusTarCredBean.LONGITUD_ID) : Constantes.STRING_VACIO);
					tarjetaCreditoBean.setDescripcionProd(resultSet.getString("ProductoDesc"));
					tarjetaCreditoBean.setTipoTarjetaID(resultSet.getString("TipoTarjetaDebID"));
					tarjetaCreditoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
					tarjetaCreditoBean.setEstatusId(resultSet.getString("Estatus"));
					tarjetaCreditoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
					tarjetaCreditoBean.setProductoID(resultSet.getString("ProductoID"));
					return tarjetaCreditoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}

		/* Lista tarjetas de Debito con el nombre del cliente */
		public List listaTarjetasDeb(TarjetaCreditoBean tarjetaCreditoBean, int tipoLista) {
			List listaTarjetasDeb=null;
			try{
			String query = "call TARJETACREDITOLIS(?,?,?,?,?,		?,?,?,?,?,		?,?);";
			Object[] parametros = {
									tarjetaCreditoBean.getTarjetaDebID(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoLista,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"listaTarjetasDeb",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					TarjetaCreditoBean tarjetaCredito = new TarjetaCreditoBean();
					tarjetaCredito.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
					tarjetaCredito.setNombre(resultSet.getString("NombreCompleto"));

					return tarjetaCredito;
				}
			});

			listaTarjetasDeb= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tarjetas de debito", e);
			}
			return listaTarjetasDeb;
		}


		public TarjetaCreditoBean consultaTar(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaCreditoDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaDebitoBean = new TarjetaCreditoBean();
					tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaCredID"));
					tarjetaDebitoBean.setTipo(resultSet.getString("Descripcion"));
					tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
					tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					tarjetaDebitoBean.setClasificacion(resultSet.getString("Clasificacion"));
					tarjetaDebitoBean.setRelacion(resultSet.getString("CorpRelacionado"));
					tarjetaDebitoBean.setClienteCorporativo(resultSet.getString("ClienteCorporativo"));
					tarjetaDebitoBean.setRazonSocial(resultSet.getString("RazonSocial"));
					tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaCredID"));
					tarjetaDebitoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
					return tarjetaDebitoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}

		/*Consulta para la pantalla de Solicitud de Tarjeta Nominativa  */
		public TarjetaCreditoBean consultaComisionSol(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaCreditoDAO.consultaComisionSol",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			@SuppressWarnings("unchecked")
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();
					tarjetaCreditoBean.setClienteID(resultSet.getString("ClienteID"));
					tarjetaCreditoBean.setLineaCreditoID(resultSet.getString("LineaTarCredID"));
					tarjetaCreditoBean.setMontoComision(resultSet.getString("MontoComision"));
					return tarjetaCreditoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}




		/*Consulta para la pantalla de Asignacion de tarjeta  */
		public TarjetaCreditoBean consultaAsignacion(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?,?,   ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tarjetaCreditoBean.getTipoTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaCreditoDAO.consultaComisionSol",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			@SuppressWarnings("unchecked")
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaCreditoBean = new TarjetaCreditoBean();

					tarjetaCreditoBean.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
					tarjetaCreditoBean.setEstatus(resultSet.getString("Estatus"));
					tarjetaCreditoBean.setClienteID(resultSet.getString("ClienteID"));
					tarjetaCreditoBean.setRelacion(resultSet.getString("Relacion"));
					return tarjetaCreditoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}


		public TarjetaCreditoBean consultaAsocia(final int tipoConsulta, TarjetaCreditoBean tarjetaCreditoBean){
			String query = "call TARJETACREDITOCON(?,?,?,?,?,?, ?,    ?,?,?,?, ?,?,?);";

			Object[] parametros = {
					tarjetaCreditoBean.getTarjetaDebID(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TarjetaDebitoDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETACREDITOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarjetaCreditoBean tarjetaDebitoBean = new TarjetaCreditoBean();
					tarjetaDebitoBean.setTarjetaDebID(resultSet.getString("TarjetaCredID"));
					tarjetaDebitoBean.setDescripcion(resultSet.getString("Descripcion"));
					tarjetaDebitoBean.setClienteID(resultSet.getString("ClienteID"));
					tarjetaDebitoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					tarjetaDebitoBean.setCorpRelacionado(resultSet.getString("CorpRelacionado"));
					tarjetaDebitoBean.setTipoTarjetaDebID(resultSet.getString("TipoTarjetaDebID"));
					tarjetaDebitoBean.setEstatus(resultSet.getString("EstatusID"));
					tarjetaDebitoBean.setNombreTarjeta(resultSet.getString("NombreTarjeta"));
					tarjetaDebitoBean.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
					return tarjetaDebitoBean;
				}
			});
			return matches.size() > 0 ? (TarjetaCreditoBean) matches.get(0) : null;
		}

}
