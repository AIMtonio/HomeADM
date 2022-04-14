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

import tarjetas.bean.OperacionesTarjetaBean;
import tarjetas.beanWS.response.OperacionesTarjetaResponse;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class OperacionesTarjetaDAO extends BaseDAO{

	public OperacionesTarjetaDAO() {
		super();
	}


	/*Se hace la llamada al sp que afecta el saldo*/
	public OperacionesTarjetaResponse operacionTarjetaAlta(final OperacionesTarjetaBean operacionesTarjetasBean) {
		OperacionesTarjetaResponse mensaje = new OperacionesTarjetaResponse();
		mensaje = (OperacionesTarjetaResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				OperacionesTarjetaResponse mensajeBean = new OperacionesTarjetaResponse();
				try {
					// Query con el Store Procedure
			mensajeBean = (OperacionesTarjetaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call OPERATARJETASWSPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarDebID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setString("Par_NatMovimiento", operacionesTarjetasBean.getNaturalezaMovimiento());
								sentenciaStore.setDouble("Par_MontoOpe",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setString("Par_NIP", operacionesTarjetasBean.getNip());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								OperacionesTarjetaResponse mensajeTransaccion = new OperacionesTarjetaResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("CodigoRespuesta"));
									mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("MensajeRespuesta"));
									mensajeTransaccion.setSaldoActualizado(resultadosStore.getString("SaldoActualizado"));
									mensajeTransaccion.setNumeroTransaccion(resultadosStore.getString("NumeroTransaccion"));
								}else{
									mensajeTransaccion.setCodigoRespuesta("999");
									mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new OperacionesTarjetaResponse();
						mensajeBean.setCodigoRespuesta("999");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
						throw new Exception(mensajeBean.getMensajeRespuesta());
					}
				} catch (Exception e) {
					if (mensajeBean.getCodigoRespuesta()!=null) {
						if (mensajeBean.getCodigoRespuesta().equals("00")) {
							mensajeBean.setCodigoRespuesta("999");
						}
					}

					mensajeBean.setMensajeRespuesta(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de operacion de tarjeta", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/*Se hace el alta de bitacora de operaciones tarjeta*/
	public OperacionesTarjetaResponse bitacoraMovsTarAlta(final OperacionesTarjetaBean operacionesTarjetasBean, final long numTransaccion) {
		OperacionesTarjetaResponse mensaje = new OperacionesTarjetaResponse();
		mensaje = (OperacionesTarjetaResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				OperacionesTarjetaResponse mensajeBean = new OperacionesTarjetaResponse();
				try {
					// Query con el Store Procedure
			mensajeBean = (OperacionesTarjetaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call BITACORAMOVSTARALT(" +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TipoOpeID", operacionesTarjetasBean.getTipoOperacion());
								sentenciaStore.setString("Par_TarDebID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setString("Par_OrigenInst", operacionesTarjetasBean.getOrigenInstrumento());
								sentenciaStore.setDouble("Par_MontoOpe",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setDate("Par_FechaHrOpe",OperacionesFechas.conversionStrDate(operacionesTarjetasBean.getFechaHoraOperacion()));


								sentenciaStore.setInt("Par_NumeroTran",Utileria.convierteEntero(operacionesTarjetasBean.getNumeroTransaccion()));
								sentenciaStore.setString("Par_GiroNegocio", operacionesTarjetasBean.getGiroNegocio());
								sentenciaStore.setString("Par_PuntoEntrada", operacionesTarjetasBean.getPuntoEntrada());
								sentenciaStore.setString("Par_TerminalID", operacionesTarjetasBean.getIdTerminal());
								sentenciaStore.setString("Par_NombreUbiTer", operacionesTarjetasBean.getNombreUbicacionTerminal());

								sentenciaStore.setString("Par_NIP", operacionesTarjetasBean.getNip());
								sentenciaStore.setString("Par_CodigoMonOpe", operacionesTarjetasBean.getCodigoMonedaoperacion());
								sentenciaStore.setDouble("Par_MontosAdi",Utileria.convierteDoble(operacionesTarjetasBean.getMontosAdicionales()));
								sentenciaStore.setDouble("Par_MonSurcharge",Utileria.convierteDoble(operacionesTarjetasBean.getMontoSurcharge()));
								sentenciaStore.setDouble("Par_MonLoyaltyfee",Utileria.convierteDoble(operacionesTarjetasBean.getMontoLoyaltyfee()));


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",1);
								sentenciaStore.setInt("Aud_Usuario", 16);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP","127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID","bitacoraMovsTarAlta");
								sentenciaStore.setInt("Aud_Sucursal",1);
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								OperacionesTarjetaResponse mensajeTransaccion = new OperacionesTarjetaResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("CodigoRespuesta"));
									mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("MensajeRespuesta"));
									mensajeTransaccion.setSaldoActualizado(resultadosStore.getString("SaldoActualizado"));
									mensajeTransaccion.setNumeroTransaccion(resultadosStore.getString("NumeroTransaccion"));
								}else{
									mensajeTransaccion.setCodigoRespuesta("999");
									mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new OperacionesTarjetaResponse();
						mensajeBean.setCodigoRespuesta("999");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
						throw new Exception(mensajeBean.getMensajeRespuesta());
					}
				} catch (Exception e) {
					if (mensajeBean.getCodigoRespuesta()!=null) {
						if (mensajeBean.getCodigoRespuesta().equals("00")) {
							mensajeBean.setCodigoRespuesta("999");
						}
					}

					mensajeBean.setMensajeRespuesta(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de bitacora de operaciones de tarjeta", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* ejecuta el proceso que hace los movimientos de una compra normal*/
	public MensajeTransaccionBean opeTarjetaCompraNormal(final OperacionesTarjetaBean operacionesTarjetasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARJETACOMPNORPRO(" +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setDouble("Par_MontoTran",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setDouble("Par_MontoAdicio",Utileria.convierteDoble(operacionesTarjetasBean.getMontosAdicionales()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(operacionesTarjetasBean.getMonedaID()));
								sentenciaStore.setString("Par_Transaccion", operacionesTarjetasBean.getNumeroTransaccion());

								sentenciaStore.setString("Par_DescriMov", operacionesTarjetasBean.getNombreUbicacionTerminal());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",1);
								sentenciaStore.setInt("Aud_Usuario", 16);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP","127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID","opeTarjetaCompraNormal");
								sentenciaStore.setInt("Aud_Sucursal",1);
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
									mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en operaciones de tarjeta de compra normal", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* ejecuta el proceso que hace los movimientos de una compra normal*/
	public MensajeTransaccionBean opeTarjetaCompraRetiroEfectivo(final OperacionesTarjetaBean operacionesTarjetasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARJETACOMPRETPRO(" +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setDouble("Par_MontoTran",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setDouble("Par_MontoAdicio",Utileria.convierteDoble(operacionesTarjetasBean.getMontosAdicionales()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(operacionesTarjetasBean.getMonedaID()));
								sentenciaStore.setString("Par_Transaccion", operacionesTarjetasBean.getNumeroTransaccion());

								sentenciaStore.setString("Par_DescriMov", operacionesTarjetasBean.getNombreUbicacionTerminal());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",1);
								sentenciaStore.setInt("Aud_Usuario", 16);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP","127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID","opeTarjetaCompraNormal");
								sentenciaStore.setInt("Aud_Sucursal",1);
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
									mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en operacion de tarjeta de compra y retiro en efectivo", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* ejecuta el proceso que hace los movimientos de un retiro de efectivo*/
	public MensajeTransaccionBean opeTarjetaRetiroEfectivo(final OperacionesTarjetaBean operacionesTarjetasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARJETARETEFEPRO(" +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setDouble("Par_MontoTran",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setDouble("Par_MontoAdicio",Utileria.convierteDoble(operacionesTarjetasBean.getMontosAdicionales()));
								sentenciaStore.setDouble("Par_Surcharge",Utileria.convierteDoble(operacionesTarjetasBean.getMontoSurcharge()));
								sentenciaStore.setDouble("Par_LoyaltyFee",Utileria.convierteDoble(operacionesTarjetasBean.getMontoLoyaltyfee()));

								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(operacionesTarjetasBean.getMonedaID()));
								sentenciaStore.setString("Par_Transaccion", operacionesTarjetasBean.getNumeroTransaccion());
								sentenciaStore.setString("Par_DescriMov", operacionesTarjetasBean.getNombreUbicacionTerminal());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							    sentenciaStore.setInt("Par_EmpresaID",1);
								sentenciaStore.setInt("Aud_Usuario", 16);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP","127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID","opeTarjetaCompraNormal");
								sentenciaStore.setInt("Aud_Sucursal",1);
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
									mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en operacion de tarjeta retiro efectivo", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* ejecuta el proceso que hace los movimientos de un retiro de efectivo*/
	public MensajeTransaccionBean opeTarjetaDeposito(final OperacionesTarjetaBean operacionesTarjetasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARJETADEPOSIPRO(" +
										"?,?,?,?,?, ?,?,?,?,?,"+
										"?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaID", operacionesTarjetasBean.getNumeroTarjeta());
								sentenciaStore.setDouble("Par_MontoTran",Utileria.convierteDoble(operacionesTarjetasBean.getMontoTransaccion()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(operacionesTarjetasBean.getMonedaID()));
								sentenciaStore.setString("Par_Transaccion", operacionesTarjetasBean.getNumeroTransaccion());
								sentenciaStore.setString("Par_DescriMov", operacionesTarjetasBean.getNombreUbicacionTerminal());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							    sentenciaStore.setInt("Par_EmpresaID",1);
								sentenciaStore.setInt("Aud_Usuario", 16);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate("1900-01-01"));
								sentenciaStore.setString("Aud_DireccionIP","127.0.0.1");
								sentenciaStore.setString("Aud_ProgramaID","opeTarjetaCompraNormal");
								sentenciaStore.setInt("Aud_Sucursal",1);
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
									mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
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
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en operacion de tarjeta en deposito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Consulta de saldo actualizado de la cuenta*/
	public OperacionesTarjetaResponse consultaSaldoWSTarjetas(OperacionesTarjetaBean operacionesTarjetaBean, int tipoConsulta) {
		OperacionesTarjetaResponse operacionesTarjetaCon = new OperacionesTarjetaResponse();
		try{
			// Query con el Store Procedure
			String query = "call OPERATARJETASWSCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { operacionesTarjetaBean.getNumeroTarjeta(),
									operacionesTarjetaBean.getNip(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"consultaSaldoWSTarjetas",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPERATARJETASWSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					OperacionesTarjetaResponse operacionesTarjetaBean = new OperacionesTarjetaResponse();
					operacionesTarjetaBean.setCodigoRespuesta(resultSet.getString("CodigoRespuesta"));
					operacionesTarjetaBean.setMensajeRespuesta(resultSet.getString("MensajeRespuesta"));
					operacionesTarjetaBean.setSaldoActualizado(resultSet.getString("SaldoActualizado"));
					operacionesTarjetaBean.setNumeroTransaccion(resultSet.getString("NumeroTransaccion"));
				return operacionesTarjetaBean;
				}
			});
			operacionesTarjetaCon =  matches.size() > 0 ? (OperacionesTarjetaResponse) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de saldo de tarjeta ws", e);
		}
		return operacionesTarjetaCon;
	}
}
