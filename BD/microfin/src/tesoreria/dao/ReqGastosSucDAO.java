package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.ReqGastosSucBean;
import tesoreria.bean.ReqGastoGridBean;
import tesoreria.bean.CuentasAhoSucBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

public class ReqGastosSucDAO extends BaseDAO {

	public ReqGastosSucDAO(){
		super();
	}

	public MensajeTransaccionBean altaEncabezadoReq(final ReqGastosSucBean reqGastosSucBean, final long numTransaccion) {
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
							String query = "call REQGASTOSUCURALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(reqGastosSucBean.getSucursalID()));
							sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(reqGastosSucBean.getUsuarioID()));
							sentenciaStore.setDate("Par_FechRequis",OperacionesFechas.conversionStrDate(reqGastosSucBean.getFechRequisicion()));
							sentenciaStore.setString("Par_FormaPago",reqGastosSucBean.getFormaPago());
							sentenciaStore.setInt("Par_CuentaDepo",Utileria.convierteEntero(reqGastosSucBean.getCuentaDepositar()));

							sentenciaStore.setString("Par_EstatusReq",reqGastosSucBean.getEstatus());
							sentenciaStore.setString("Par_TipoGasto",reqGastosSucBean.getTipoGasto());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
							// se imprime el call del sp ejecutado en el log
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de encabezados requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//alta de cuerpo de Requisicion de gastos a sucursales
	public MensajeTransaccionBean altaCuerpoReq(final ReqGastoGridBean reqGastoGridBean, final int numReqGasID, final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REQGASTOSUCMOVALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_DetReqGasID", Utileria.convierteEntero(reqGastoGridBean.getDetReqGasID()));
							sentenciaStore.setInt("Par_NumReqGasID", numReqGasID);
							sentenciaStore.setInt("Par_TipoGastoID", Utileria.convierteEntero(reqGastoGridBean.getTipoGastoID()));
							sentenciaStore.setString("Par_Observaciones", reqGastoGridBean.getObservaciones());
							sentenciaStore.setDouble("Par_PartPresupuesto", Utileria.convierteDoble(reqGastoGridBean.getPartPresupuesto()));

							sentenciaStore.setInt("Par_FolioPresupID", Utileria.convierteEntero(reqGastoGridBean.getPartidaPreID()));
							sentenciaStore.setDouble("Par_MontPresupuest", Utileria.convierteDoble(reqGastoGridBean.getMontPresupuest()));
							sentenciaStore.setDouble("Par_NoPresupuestado", Utileria.convierteDoble(reqGastoGridBean.getNoPresupuestado()));
							sentenciaStore.setDouble("Par_MontoAutorizado", Utileria.convierteDoble(reqGastoGridBean.getMontoAutorizado()));
							sentenciaStore.setString("Par_Estatus", reqGastoGridBean.getEstatus());

							sentenciaStore.setString("Par_TipoDeposito", reqGastoGridBean.getTipoDeposito());
							sentenciaStore.setString("Par_NumFactura", reqGastoGridBean.getNoFactura());
							sentenciaStore.setInt("Par_ProveedorID", Utileria.convierteEntero(reqGastoGridBean.getProveedorID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(reqGastoGridBean.getSucursalID()));
							sentenciaStore.setInt("Par_CentroCostoID", Utileria.convierteEntero(reqGastoGridBean.getCentroCostoID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado");
					}else
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuerpo requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// Actualizar encabezado de requisición
	public MensajeTransaccionBean actualizaEncabezadoReq (final ReqGastosSucBean reqGastosSucBean, final int tipoActualizacion, final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REQGASTOSUCURACT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_NumReqGasID", Utileria.convierteEntero(reqGastosSucBean.getNumReqGasID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(reqGastosSucBean.getSucursalID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(reqGastosSucBean.getUsuarioID()));
							sentenciaStore.setDate("Par_FechRequisicion",OperacionesFechas.conversionStrDate(reqGastosSucBean.getFechRequisicion()));
							sentenciaStore.setString("Par_FormaPago", reqGastosSucBean.getFormaPago());

							sentenciaStore.setLong("Par_CuentaDepositar", Utileria.convierteLong(reqGastosSucBean.getCuentaDepositar()));
							sentenciaStore.setString("Par_EstatusReq", reqGastosSucBean.getEstatus());
							sentenciaStore.setString("Par_TipoGasto", reqGastosSucBean.getTipoGasto());
							sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado");
					}else
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza encabezados de requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Actualizar cuerpo de Requisicion
	public MensajeTransaccionBean actualizaCuerpoReq(final ReqGastoGridBean reqGastoGridBean, final int numReqGasID,
            final int tipoActualizacion, final long numTransaccion){
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
							String query = "call REQGASTOSUCMOVACT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_DetReqGasID",Utileria.convierteEntero(reqGastoGridBean.getDetReqGasID()));
							sentenciaStore.setInt("Par_NumReqGasID",numReqGasID);
							sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(reqGastoGridBean.getTipoGastoID()));
							sentenciaStore.setString("Par_Observaciones",reqGastoGridBean.getObservaciones());
							sentenciaStore.setDouble("Par_PartPresupuesto",Utileria.convierteDoble(reqGastoGridBean.getPartPresupuesto()));

							sentenciaStore.setInt("Par_FolioPresupID",Utileria.convierteEntero(reqGastoGridBean.getPartidaPreID()));
							sentenciaStore.setDouble("Par_MontPresupuest",Utileria.convierteDoble(reqGastoGridBean.getMontPresupuest()));
							sentenciaStore.setDouble("Par_NoPresupuestado",Utileria.convierteDoble(reqGastoGridBean.getNoPresupuestado()));
							sentenciaStore.setDouble("Par_MontoAutorizado",Utileria.convierteDoble(reqGastoGridBean.getMontoAutorizado()));
							sentenciaStore.setString("Par_Estatus",reqGastoGridBean.getEstatus());

							sentenciaStore.setString("Par_TipoDeposito",reqGastoGridBean.getTipoDeposito());
							sentenciaStore.setInt("Par_ClaveDispMov",Utileria.convierteEntero(reqGastoGridBean.getClaveDispMov()));
							sentenciaStore.setInt("Par_UsuarioAutoID",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(reqGastoGridBean.getProveedorID()));
							sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							// se imprime el call del sp ejecutado en el log
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza cuerpo de requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// proceso de Alta de Requisición
	public MensajeTransaccionBean altaRequisicionGasto(final ReqGastosSucBean reqGastosSucBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		// se genera un numero de transaccion para que todas las operaciones se vayan con el mismo numero
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
				    // Se manda a llamar la funcion que crea la lista de beans de detalles de requisicion de gastos
					ArrayList listaDetalleGrid = (ArrayList) DetalleGrid(reqGastosSucBean);
					// Despues de tener la lista de bean se dara de alta el encabezado de la Requisicion
					mensajeBean = altaEncabezadoReq(reqGastosSucBean, parametrosAuditoriaBean.getNumeroTransaccion());


					if(mensajeBean.getNumero()==0){
						int numReqGasID = Utileria.convierteEntero(mensajeBean.getConsecutivoString());
						ReqGastoGridBean reqGastoGridBean = new ReqGastoGridBean();
			            for(int i=0; i < listaDetalleGrid.size(); i++){
							reqGastoGridBean = (ReqGastoGridBean) listaDetalleGrid.get(i);
							// se asigna el valor de sucursal y de tipo de gasto de acuerdo a cada movimiento de requisicion
							reqGastoGridBean.setSucursalID(reqGastosSucBean.getSucursalID());
							//reqGastoGridBean.setTipoDeposito(reqGastosSucBean.getFormaPago());

							mensajeBean= altaCuerpoReq(reqGastoGridBean, numReqGasID,  parametrosAuditoriaBean.getNumeroTransaccion());


							if(mensajeBean.getNumero()!=0){
							//	mensajeBean.setNumero(999);
							//	mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
						}
					}else{
						throw new Exception(mensajeBean.getDescripcion());
					}
					return mensajeBean;
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Actualizacion de Requisicion de Gasto
	public MensajeTransaccionBean actualizaRequisicionGasto(final ReqGastosSucBean reqGastosSucBean,final int tipoActualizacion ){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		// se genera un numero de transaccion para que todas las operaciones se vayan con el mismo numero
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					ArrayList listaDetalleGrid = (ArrayList) DetalleGrid(reqGastosSucBean);
					int numReqGasID = Utileria.convierteEntero(mensajeBean.getConsecutivoInt());
					ReqGastoGridBean reqGastoGridBean = new ReqGastoGridBean();
					for(int i=0; i < listaDetalleGrid.size(); i++){
						reqGastoGridBean = (ReqGastoGridBean) listaDetalleGrid.get(i);
						// se asigna el valor de sucursal y de tipo de gasto de acuerdo a cada movimiento de requisicion
						reqGastoGridBean.setSucursalID(reqGastosSucBean.getSucursalID());
						//reqGastoGridBean.setTipoDeposito(reqGastosSucBean.getFormaPago());


						if(reqGastoGridBean.getDetReqGasID().equals("0")){
							System.out.println("Entro en igual a cero");
							mensajeBean= altaCuerpoReq(reqGastoGridBean, numReqGasID, parametrosAuditoriaBean.getNumeroTransaccion() );
						}
						else{
							// si el elemeto no esta autorizado entonces se actualiza


							if(reqGastoGridBean.getNoFactura()!=""){
							}
							if(reqGastoGridBean.getEstatus().equals("C") && reqGastoGridBean.getNoFactura()!=""){
							}

							mensajeBean= actualizaCuerpoReq(reqGastoGridBean, numReqGasID, tipoActualizacion, parametrosAuditoriaBean.getNumeroTransaccion() );

						}
						if(mensajeBean.getNumero()!=0){
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else{
							mensajeBean.setConsecutivoString(String.valueOf(numReqGasID));
						}
					}
					if(mensajeBean.getNumero()==0){
						mensajeBean = actualizaEncabezadoReq(reqGastosSucBean, tipoActualizacion,  parametrosAuditoriaBean.getNumeroTransaccion() );

					}else{
						throw new Exception(mensajeBean.getDescripcion());
					}
					return mensajeBean;
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza requisicion", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// se forma la lista de bean de requisición de gastos
	public List DetalleGrid(ReqGastosSucBean reqGastosSucBean){
		// se guardan en listas los valores obtenidos por name
		List<String> ldetReqGasID   = reqGastosSucBean.getLdetReqGasID();
		List<String> lnoFactura		= reqGastosSucBean.getLnoFactura();
		List<String> lproveedor		= reqGastosSucBean.getLproveedor();
		List<String> ltipoGastoID	= reqGastosSucBean.getLtipoGastoID();
		List<String> lobservaciones	= reqGastosSucBean.getLobservaciones();
		List<String> lpartidaPre	= reqGastosSucBean.getLpartidaPre();
		List<String> lpartidaPreID	= reqGastosSucBean.getLpartidaPreID();
		List<String> lmontoPre		= reqGastosSucBean.getLmontoPre();
		List<String> lnoPresupuestado = reqGastosSucBean.getLnoPresupuestado();
		List<String> lmonAutorizado	= reqGastosSucBean.getLmonAutorizado();
		List<String> lstatus		= reqGastosSucBean.getLstatus();
		List<String> lTipoDeposito	= reqGastosSucBean.getLtipoDeposito();
		List<String> lCentroCosto	= reqGastosSucBean.getLcentroCostoID();


		ArrayList listaDetalle = new ArrayList();
		ReqGastoGridBean reqGastoGridBean = null;

		// se obtiene el tamaño de la lista para saber cuantas veces se hara el ciclo
		int tamanio = ltipoGastoID.size();
		for(int i=0; i<tamanio; i++){
			reqGastoGridBean = new ReqGastoGridBean();
			reqGastoGridBean.setDetReqGasID(ldetReqGasID.get(i));
			reqGastoGridBean.setNoFactura(lnoFactura.get(i));
			reqGastoGridBean.setProveedorID(lproveedor.get(i));
			reqGastoGridBean.setTipoGastoID(ltipoGastoID.get(i));
			reqGastoGridBean.setObservaciones(lobservaciones.get(i));
			reqGastoGridBean.setPartidaPreID(lpartidaPreID.get(i));
			reqGastoGridBean.setPartPresupuesto(lpartidaPre.get(i));
			reqGastoGridBean.setMontPresupuest(lmontoPre.get(i));
			reqGastoGridBean.setNoPresupuestado(lnoPresupuestado.get(i));
			reqGastoGridBean.setMontoAutorizado(lmonAutorizado.get(i));
			reqGastoGridBean.setEstatus(lstatus.get(i));
			reqGastoGridBean.setTipoDeposito(lTipoDeposito.get(i));
			reqGastoGridBean.setCentroCostoID(lCentroCosto.get(i));
			listaDetalle.add(reqGastoGridBean);

		}
		return listaDetalle;
	}// fin DetalleGrid

	public List ReqGastsGridLis(int tipoLista,ReqGastosSucBean reqGastosSucBean){
		List listReqGastsGrid = null;
		try{
			String query = "call REQGASTOSUCMOVCON (?,?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(reqGastosSucBean.getNumReqGasID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"Presupesto.conFolioOperacinon",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCMOVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				@Override
				public Object mapRow(ResultSet resultSet, int index) throws SQLException {
					// TODO Auto-generated method stub
					ReqGastoGridBean reqGastoGridBean = new ReqGastoGridBean();
				    reqGastoGridBean.setDetReqGasID(resultSet.getString("DetReqGasID"));
					reqGastoGridBean.setNumReqGasID(resultSet.getString("NumReqGasID"));
					reqGastoGridBean.setTipoGastoID(resultSet.getString("TipoGastoID"));
					reqGastoGridBean.setObservaciones(resultSet.getString("Observaciones"));
					reqGastoGridBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
					reqGastoGridBean.setPartPresupuesto(resultSet.getString("PartPresupuesto"));
					reqGastoGridBean.setMontPresupuest(resultSet.getString("MontPresupuest"));
					reqGastoGridBean.setNoPresupuestado(resultSet.getString("NoPresupuestado"));
					reqGastoGridBean.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					reqGastoGridBean.setEstatus(resultSet.getString("Estatus"));
					reqGastoGridBean.setPartidaPreID(resultSet.getString("FolioPresupID"));
					reqGastoGridBean.setClaveDispMov(resultSet.getString("ClaveDispMov"));
					reqGastoGridBean.setNoFactura(resultSet.getString("NoFactura"));
					reqGastoGridBean.setProveedorID(resultSet.getString("ProveedorID"));
					reqGastoGridBean.setTipoDeposito(resultSet.getString("TipoDeposito"));


					return reqGastoGridBean;
				}

			});
			listReqGastsGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en requisicion de gastos grid", e);
		}
		return listReqGastsGrid;
	}

	// muestra el la lista de movimientos de requisicion pero sin los que se pasen de su monto presupuestado
	public List reqGastsGridLisDentroPresupuesto(int tipoLista,ReqGastosSucBean reqGastosSucBean){
		List listReqGastsGrid = null;
		try{
			String query = "call REQGASTOSUCMOVCON (?,?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(reqGastosSucBean.getNumReqGasID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"Presupesto.conFolioOperacinon",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCMOVCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				@Override
				public Object mapRow(ResultSet resultSet, int index) throws SQLException {
					// TODO Auto-generated method stub
					ReqGastoGridBean reqGastoGridBean = new ReqGastoGridBean();
				    reqGastoGridBean.setDetReqGasID(resultSet.getString("DetReqGasID"));
					reqGastoGridBean.setNumReqGasID(resultSet.getString("NumReqGasID"));
					reqGastoGridBean.setTipoGastoID(resultSet.getString("TipoGastoID"));
					reqGastoGridBean.setObservaciones(resultSet.getString("Observaciones"));
					reqGastoGridBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
					reqGastoGridBean.setPartPresupuesto(resultSet.getString("PartPresupuesto"));
					reqGastoGridBean.setMontPresupuest(resultSet.getString("MontPresupuest"));
					reqGastoGridBean.setNoPresupuestado(resultSet.getString("NoPresupuestado"));
					reqGastoGridBean.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					reqGastoGridBean.setEstatus(resultSet.getString("Estatus"));
					reqGastoGridBean.setPartidaPreID(resultSet.getString("FolioPresupID"));
					reqGastoGridBean.setClaveDispMov(resultSet.getString("ClaveDispMov"));
					reqGastoGridBean.setNoFactura(resultSet.getString("NoFactura"));
					reqGastoGridBean.setProveedorID(resultSet.getString("ProveedorID"));
					reqGastoGridBean.setTipoDeposito(resultSet.getString("TipoDeposito"));

					return reqGastoGridBean;
				}
			});
			listReqGastsGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en requisicion de gastos grid lista dentro de presupuesto", e);
		}
		return listReqGastsGrid;
	}

	public List cuentasSucursal(int tipoLista,CuentasAhoSucBean cuentasAhoSucBean){
		List listCuentasSucursal = null;
		try{
			String query = "call CUENTASAHOSUCURCON (?,?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = {
					Utileria.convierteEntero(cuentasAhoSucBean.getSucursalID()),
					Utileria.convierteEntero(cuentasAhoSucBean.getInstitucionID()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"Presupesto.conFolioOperacinon",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOSUCURCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				@Override
				public Object mapRow(ResultSet resultSet, int index) throws SQLException {
					// TODO Auto-generated method stub
					CuentasAhoSucBean cuentasSucursal = new CuentasAhoSucBean();
					cuentasSucursal.setCuentaSucurID(resultSet.getString("CuentaSucurID"));
					cuentasSucursal.setCueClave(resultSet.getString("CueClave"));
					return cuentasSucursal;
				}
			});
			listCuentasSucursal= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cuentas sucursal", e);
		}
		return listCuentasSucursal;
	}


	public ReqGastosSucBean consultaPrincipalEnc(final  ReqGastosSucBean reqGastosSucBean, int tipoConsulta){
		ReqGastosSucBean reqGastosSuc = new ReqGastosSucBean();
		try{
			//Query con el Store Procedure
			String query = "call REQGASTOSUCURCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(reqGastosSucBean.getNumReqGasID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ProductosCreditoDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCURCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReqGastosSucBean reqGasBean = new ReqGastosSucBean();

					reqGasBean.setNumReqGasID(resultSet.getString("NumReqGasID"));
					reqGasBean.setSucursalID(resultSet.getString("SucursalID"));
					reqGasBean.setUsuarioID(resultSet.getString("UsuarioID"));
					reqGasBean.setFechRequisicion(resultSet.getString("FechRequisicion"));
					reqGasBean.setFormaPago(resultSet.getString("FormaPago"));

					reqGasBean.setEstatus(resultSet.getString("EstatusReq"));
					reqGasBean.setTipoGasto(resultSet.getString("TipoGasto"));
					reqGasBean.setSucursalDescr(resultSet.getString("NombreSucurs"));
					reqGasBean.setUsuarioDescr(resultSet.getString("Nombre"));
					return reqGasBean;
				}
			});
			reqGastosSuc= matches.size() > 0 ? (ReqGastosSucBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de encabezado", e);
		}
		return reqGastosSuc;
	}


	public CuentasAhoSucBean consultaCtaSucur(final  ReqGastosSucBean reqGastosSucBean, int tipoConsulta){
		CuentasAhoSucBean cuentasAhoSucBean=new CuentasAhoSucBean();
		try{
			//Query con el Store Procedure
			String query = "call REQGASTOSUCURCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(reqGastosSucBean.getNumReqGasID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ProductosCreditoDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCURCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				    CuentasAhoSucBean cuentasAhoSucBean = new CuentasAhoSucBean();
					cuentasAhoSucBean.setInstitucionID(resultSet.getString("InstitucionID"));
					cuentasAhoSucBean.setCuentaAhoID(resultSet.getString(2));
					return cuentasAhoSucBean;
				}
			});
			cuentasAhoSucBean= matches.size() > 0 ? (CuentasAhoSucBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuenta de sucursal", e);
		}
		return cuentasAhoSucBean;
	}

	// lista requisiciones de gastos con estatus Alta filtrados por sucursal
	public List listaEstatusAlta(ReqGastosSucBean reqGastosSucBean, int tipoLista){
		List listaReq = null;
		try{
			//Query con el Store Procedure
			String query = "call REQGASTOSUCURLIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(reqGastosSucBean.getSucursalID()),
					reqGastosSucBean.getDescripcionSuc(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCURLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReqGastosSucBean reqGastosSucBean = new ReqGastosSucBean();
					reqGastosSucBean.setNumReqGasID(resultSet.getString("NumReqGasID"));
					reqGastosSucBean.setFechRequisicion(resultSet.getString("FechRequisicion"));
					return reqGastosSucBean;
				}
			});
			listaReq= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de lista de estatus ", e);
		}
		return listaReq;
	}// fin listaEstatusAlta


	// lista requisiciones de gastos con estatus Procesado
	public List listaEstatusProcesado(ReqGastosSucBean reqGastosSucBean, int tipoLista){
		List listaReq = null;
		try{
			//Query con el Store Procedure
			String query = "call REQGASTOSUCURLIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(reqGastosSucBean.getSucursalID()),
					reqGastosSucBean.getDescripcionSuc(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REQGASTOSUCURLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReqGastosSucBean reqGastosSucBean = new ReqGastosSucBean();
					reqGastosSucBean.setNumReqGasID(resultSet.getString("NumReqGasID"));
					reqGastosSucBean.setFechRequisicion(resultSet.getString("FechRequisicion"));
					return reqGastosSucBean;
				}
			});
			listaReq = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar lista de estatus", e);
		}
		return listaReq;
	} // fin listaEstatusProcesado
} //fin d la clase.
