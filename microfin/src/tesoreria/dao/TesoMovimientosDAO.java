package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.CuentasAhoBean;
import cuentas.dao.CuentasAhoDAO;
import tesoreria.bean.MovNoIdentificadosBean;
import tesoreria.bean.ReqGastosSucBean;
import tesoreria.bean.TesoreriaMovsBean;
import tesoreria.bean.DepositosRefeBean;
import tesoreria.dao.DepositosRefeDAO.Enum_Tra_NatMovimi;
import tesoreria.servicio.DepositosRefeServicio.Enum_Tra_Inserta;
import general.dao.BaseDAO;
public class TesoMovimientosDAO  extends BaseDAO{

	CuentasAhoDAO cuentasAhoDAO = null;
	final	String saltoLinea=" <br> ";
	DepositosRefeDAO depositosRefeDAO = new DepositosRefeDAO();
	public TesoMovimientosDAO(){
		super();
	}

	public MensajeTransaccionBean altaMovimientos(final List listaGridDetalle,final List  listaDetGridDepos, final HttpServletRequest request){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String mensajeValidacion = "Movimientos insertados Exitosamente.";
					String depositosReferenciados = "1"; // tabla TIPOSMOVTESO3
					TesoreriaMovsBean tesoMovsBean;
					DepositosRefeBean depRefeBean;

					for(int i=0; i<listaDetGridDepos.size(); i++){// ciclo para actualizar DEPOSITOREFERE
						depRefeBean = (DepositosRefeBean) listaDetGridDepos.get(i);
				   		mensajeBean = actDeposReferen(depRefeBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}


					for(int i=0; i<listaDetGridDepos.size(); i++){// ciclo para agregar pagos

						depRefeBean = (DepositosRefeBean) listaDetGridDepos.get(i);
						depRefeBean.setNumCtaInstit(request.getParameter("cuentaAhorroID"));
						if(depRefeBean.getTipoCanal().equals("2")){
							MensajeTransaccionBean mensaje=new MensajeTransaccionBean();//mensaje transaccion

							depRefeBean.setCuentaAhoID(depRefeBean.getReferenciaMov());

							mensaje=cuentasAhoDAO.depCuentasValDR(depRefeBean);
						    System.out.println(mensaje.getNumero());
							if(mensaje.getNumero()== 0){
								mensajeBean = depositosRefeDAO.procesoDepositoRefere(depRefeBean, parametrosAuditoriaBean.getNumeroTransaccion(), Constantes.salidaNO);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeValidacion=mensaje.getDescripcion();

							}
							if(mensaje.getNumero()==3||mensaje.getNumero()==4){
								mensajeBean = depositosRefeDAO.procesoDepositoRefere(depRefeBean, parametrosAuditoriaBean.getNumeroTransaccion(), Constantes.salidaNO);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeValidacion+=saltoLinea+mensaje.getDescripcion();
								mensajeBean.setDescripcion(mensajeValidacion);

								CuentasAhoBean cuentaAhoBean = new CuentasAhoBean();
								cuentaAhoBean.setCuentaAhoID(depRefeBean.getReferenciaMov());
								cuentaAhoBean.setCanal("R");
								cuentaAhoBean.setMotivoLimite(mensaje.getNumero());
								cuentaAhoBean.setDescripcionLimite(mensaje.getDescripcion());
								cuentaAhoBean.setFechaMovimento(depRefeBean.getFechaOperacion());
								mensaje = cuentasAhoDAO.altaLimExCuentas(cuentaAhoBean, false);
								if(mensaje.getNumero()!=0){
									throw new Exception(mensaje.getDescripcion());
								}

							}else{

								if(mensaje.getNumero()==1||mensaje.getNumero()==2){
									mensajeValidacion+=saltoLinea+mensaje.getDescripcion();
									mensajeBean.setDescripcion(mensajeValidacion);
								}
							}
						}else{
							mensajeBean = depositosRefeDAO.procesoDepositoRefere(depRefeBean, parametrosAuditoriaBean.getNumeroTransaccion(), Constantes.salidaNO);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion(mensajeValidacion);
						mensajeBean.setNombreControl("cuentaAhorroID");

					}

				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimientos", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(997);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// Insertar movimientos
	public MensajeTransaccionBean altaTesoMovs(final TesoreriaMovsBean tesoMovsBean){

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
								String query = "call TESORERIAMOVSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(tesoMovsBean.getCuentaAhoID()));
								sentenciaStore.setDate("Par_FechaMov",OperacionesFechas.conversionStrDate(tesoMovsBean.getFechaMov()));
								sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(tesoMovsBean.getMontoMov()));
								sentenciaStore.setString("Par_DescripcionMov",tesoMovsBean.getDescripcionMov());
								sentenciaStore.setString("Par_ReferenciaMov",tesoMovsBean.getReferenConfirm());

								sentenciaStore.setString("Par_Status",tesoMovsBean.getStatus());
								sentenciaStore.setString("Par_NatMovimiento","A"); // Abono a su cuenta, Crdito, etc
								sentenciaStore.setString("Par_TipoRegristro","A");			// Indica como se realizo el movimiento por automatico

								sentenciaStore.setString("Par_TipoMov",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_NumeroMov",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","TesoMovimientosDao.altaTesoMovs");
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
									mensajeTransaccion.setConsecutivoString(Utileria.completaCerosIzquierda(resultadosStore.getString(4), 5));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimientos de tesoreria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	// Insertar movimientos
	public MensajeTransaccionBean altaTesoreriaMovs(final DepositosRefeBean refeBean, final double numeroTransaccion){
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
								String query = "call TESORERIAMOVSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(refeBean.getCuentaAhoID()));
								sentenciaStore.setDate("Par_FechaMov",OperacionesFechas.conversionStrDate(refeBean.getFechaOperacion()));
								sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(refeBean.getMontoMov()));
								sentenciaStore.setString("Par_DescripcionMov",refeBean.getDescripcionMov());
								sentenciaStore.setString("Par_ReferenciaMov",refeBean.getReferenciaMov());

								sentenciaStore.setString("Par_Status",Enum_Tra_NatMovimi.vacio);
								sentenciaStore.setString("Par_NatMovimiento",Enum_Tra_NatMovimi.abono); // Abono a su cuenta, Crdito, etc
								sentenciaStore.setString("Par_TipoRegristro","A");			// Indica como se realizo el movimiento por automatico

								sentenciaStore.setString("Par_TipoMov",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_NumeroMov",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimientos de tesoreria ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	public MensajeTransaccionBean generaAltaMovimiento(final  MovNoIdentificadosBean movimientos,final int posicion){
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
								String query = "call TESORERIAMOVSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(movimientos.getCuentaAhoID()));
								sentenciaStore.setDate("Par_FechaMov",OperacionesFechas.conversionStrDate(movimientos.getFechaOperacion().get(posicion)));
								sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(movimientos.getMonto().get(posicion)));
								sentenciaStore.setString("Par_DescripcionMov",movimientos.getDescripcion().get(posicion));
								sentenciaStore.setString("Par_ReferenciaMov",movimientos.getReferencia().get(posicion));

								sentenciaStore.setString("Par_Status","N");
								sentenciaStore.setString("Par_NatMovimiento",movimientos.getNatMovimiento().get(posicion)); // Abono a su cuenta, Crdito, etc
								sentenciaStore.setString("Par_TipoRegristro","P");			// Indica como se realizo el movimiento por automatico

								sentenciaStore.setString("Par_TipoMov",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_NumeroMov",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");
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
									mensajeTransaccion.setConsecutivoString(Utileria.completaCerosIzquierda(resultadosStore.getString(4), 5));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generar alta de movimiento", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public MensajeTransaccionBean actDeposReferen(final DepositosRefeBean depRefeBean){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try{
			String query = "call DEPOSITOREFEREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

			Object[] parametros = {

					 Utileria.convierteEntero(depRefeBean.getFolioCargaID()),
					 Utileria.convierteLong(depRefeBean.getCuentaAhoID()),
					 Utileria.convierteEntero(depRefeBean.getInstitucionID()),
					 depRefeBean.getStatus(),
					 depRefeBean.getReferenNoIden(),
					 depRefeBean.getDescripNoIden(),
					 Utileria.convierteEntero(depRefeBean.getTipoCanal()),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"DepositosRefeDao.actDeposReferen",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFEREACT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					return mensaje;
				}
			});

			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;

		} catch (Exception e) {
		    e.printStackTrace();
		    loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de deposito referenciado", e);
			if(mensaje.getNumero()==0){
				mensaje.setNumero(998);

			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}  // FIN Modificar


	// consulta para reporte en excel de Fondeo Sucursales
			public List consultaRepProxFondeo(final ReqGastosSucBean reqGastosSucBean, int tipoLista){
				List ListaResultado=null;


				try{


				String query = "call SUCURSALFONDEOREP(?, ?,?,?,?,?,?,?)";

				          	Object[] parametros ={
									Utileria.convierteFecha(reqGastosSucBean.getParFechaEmision()),



						    		parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUCURSALFONDEOREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						 ReqGastosSucBean reqGastosSucBean= new ReqGastosSucBean();
						 reqGastosSucBean.setSucursalID(resultSet.getString("SucursalID"));
						 reqGastosSucBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
						 reqGastosSucBean.setSaldoCajaAntenc(resultSet.getString("SaldoCajAtenc"));
						 reqGastosSucBean.setSaldoCajaPrin(resultSet.getString("SaldoCajPrin"));

						 reqGastosSucBean.setPorDesembo(resultSet.getString("PorDesemb"));
						 reqGastosSucBean.setDesemboHoy(resultSet.getString("DesembHoy"));

						 reqGastosSucBean.setMtoBancosRec(resultSet.getString("MtoRecBancos"));

						 System.out.println("fondeo222"+resultSet.getString("SaldoCajPrin"));




						return reqGastosSucBean;
					}
				});
				ListaResultado= matches;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de Fondeo Sucursales", e);
				}
				return ListaResultado;
			}



	public DepositosRefeDAO getDepositosRefeDAO() {
		return depositosRefeDAO;
	}

	public void setDepositosRefeDAO(DepositosRefeDAO depositosRefeDAO) {
		this.depositosRefeDAO = depositosRefeDAO;
	}
	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}


	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}

}
