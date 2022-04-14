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

import tarjetas.bean.LimitesTarDebIndividualBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class LimitesTarDebIndividualDAO extends BaseDAO{

	public LimitesTarDebIndividualDAO() {
		super();
	}

	// Alta limite de Tarjetas de Debito
	public MensajeTransaccionBean altaLimiteTarjetaDebito( final LimitesTarDebIndividualBean limitesTarDebIndividualBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL TARDEBLIMITESALT( ?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarjetaDebID",limitesTarDebIndividualBean.getTarjetaDebID());
								sentenciaStore.setString("Par_DisposicionesDia",limitesTarDebIndividualBean.getDisposicionesDia());
								sentenciaStore.setString("Par_MontoMaxDia",limitesTarDebIndividualBean.getMontoMaxDia());
								sentenciaStore.setString("Par_MontoMaxMes",limitesTarDebIndividualBean.getMontoMaxMes());
								sentenciaStore.setString("Par_MontoMaxCompraDia",limitesTarDebIndividualBean.getMontoMaxCompraDia());

								sentenciaStore.setString("Par_MontoMaxComprasMensual",limitesTarDebIndividualBean.getMontoMaxComprasMensual());
								sentenciaStore.setString("Par_BloqueoATM",limitesTarDebIndividualBean.getBloqueoATM());
								sentenciaStore.setString("Par_BloqueoPOS",limitesTarDebIndividualBean.getBloqueoPOS());
								sentenciaStore.setString("Par_BloqueoCashback",limitesTarDebIndividualBean.getBloqueoCashback());
								sentenciaStore.setString("Par_Vigencia",limitesTarDebIndividualBean.getVigencia());

								sentenciaStore.setString("Par_OperacionesMOTO",limitesTarDebIndividualBean.getOperacionesMOTO());
								sentenciaStore.setString("Par_NumConsultaMes",limitesTarDebIndividualBean.getNumConsultaMes());
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Limites de Tarjetas de Debito ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin Alta limite de Tarjetas de Debito

	//------------------------------------consulta de tipo de tarjeta debito  ----------------------
	public LimitesTarDebIndividualBean consultaLimitesTarDeb(int tipoConsulta,LimitesTarDebIndividualBean limitesTarDebIndividualBean){
		String query = "call TARDEBLIMITESCON(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				limitesTarDebIndividualBean.getTarjetaDebID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARDEBLIMITESCON.consultaLimitesTarDeb",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBLIMITESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LimitesTarDebIndividualBean limitesTarDebIndividualBean= new LimitesTarDebIndividualBean();
				limitesTarDebIndividualBean.setDisposicionesDia(resultSet.getString(1));
				limitesTarDebIndividualBean.setMontoMaxDia(resultSet.getString(2));
				limitesTarDebIndividualBean.setNumConsultaMes(resultSet.getString(3));
				limitesTarDebIndividualBean.setMontoMaxMes(resultSet.getString(4));
				limitesTarDebIndividualBean.setMontoMaxCompraDia(resultSet.getString(5));
				limitesTarDebIndividualBean.setMontoMaxComprasMensual(resultSet.getString(6));
				limitesTarDebIndividualBean.setBloqueoATM(resultSet.getString(7));
				limitesTarDebIndividualBean.setBloqueoPOS(resultSet.getString(8));
				limitesTarDebIndividualBean.setBloqueoCashback(resultSet.getString(9));
				limitesTarDebIndividualBean.setVigencia(Utileria.convierteFecha(resultSet.getString(10)));
				limitesTarDebIndividualBean.setOperacionesMOTO(resultSet.getString(11));
				return limitesTarDebIndividualBean;
			}
		});

		return matches.size() > 0 ? (LimitesTarDebIndividualBean) matches.get(0) : null;
	}

	// Modificacion limite de Tarjetas de Debito
	public MensajeTransaccionBean modificaLimiteTarjetaDebito( final LimitesTarDebIndividualBean limitesTarDebIndividualBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL TARDEBLIMITESMOD( ?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarjetaDebID",limitesTarDebIndividualBean.getTarjetaDebID());
								sentenciaStore.setString("Par_DisposicionesDia",limitesTarDebIndividualBean.getDisposicionesDia());
								sentenciaStore.setString("Par_MontoMaxDia",limitesTarDebIndividualBean.getMontoMaxDia());
								sentenciaStore.setString("Par_MontoMaxMes",limitesTarDebIndividualBean.getMontoMaxMes());
								sentenciaStore.setString("Par_MontoMaxCompraDia",limitesTarDebIndividualBean.getMontoMaxCompraDia());

								sentenciaStore.setString("Par_MontoMaxComprasMensual",limitesTarDebIndividualBean.getMontoMaxComprasMensual());
								sentenciaStore.setString("Par_BloqueoATM",limitesTarDebIndividualBean.getBloqueoATM());
								sentenciaStore.setString("Par_BloqueoPOS",limitesTarDebIndividualBean.getBloqueoPOS());
								sentenciaStore.setString("Par_BloqueoCashback",limitesTarDebIndividualBean.getBloqueoCashback());
								sentenciaStore.setString("Par_Vigencia",limitesTarDebIndividualBean.getVigencia());

								sentenciaStore.setString("Par_OperacionesMOTO",limitesTarDebIndividualBean.getOperacionesMOTO());
								sentenciaStore.setString("Par_NumConsultaMes",limitesTarDebIndividualBean.getNumConsultaMes());
								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificación de Limites de Tarjetas de Debito ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin Modificacion limite de Tarjetas de Debito

	public LimitesTarDebIndividualBean consultaTarDebLimite(int tipoConsulta,LimitesTarDebIndividualBean limitesTarDebIndividualBean){
		String query = "call TARJETADEBITOCON(?,?,?,?,?, ?, ?,   ?,?,?,?, ?,?,?);";
		Object[] parametros = {
				limitesTarDebIndividualBean.getTarjetaDebID(),
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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LimitesTarDebIndividualBean bitacoraEstatusTarDeb = new LimitesTarDebIndividualBean();

				bitacoraEstatusTarDeb.setTarjetaDebID(resultSet.getString(1));
			    bitacoraEstatusTarDeb.setEstatus(resultSet.getString(2));
			    bitacoraEstatusTarDeb.setClienteID(
			    		 (resultSet.getString(3)!=null) ?
								   Utileria.completaCerosIzquierda(
										   Utileria.convierteEntero(resultSet.getString(3)
												   ),LimitesTarDebIndividualBean.LONGITUD_ID) : Constantes.STRING_VACIO  );
				bitacoraEstatusTarDeb.setNombreCompleto(resultSet.getString(4));
				bitacoraEstatusTarDeb.setCoorporativo(resultSet.getString(5));
			    bitacoraEstatusTarDeb.setCuentaAho(
						   (resultSet.getString(6)!=null) ?
								   Utileria.completaCerosIzquierda(
										   Utileria.convierteEntero(resultSet.getString(6)
												   ),LimitesTarDebIndividualBean.LONGITUD_ID) : Constantes.STRING_VACIO  );
			  	bitacoraEstatusTarDeb.setNombreTipoCuenta(resultSet.getString(7));
				bitacoraEstatusTarDeb.setTipoTarjetaDebID(resultSet.getString(8));
				bitacoraEstatusTarDeb.setNombreTarjeta(resultSet.getString(9));
				bitacoraEstatusTarDeb.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));
				return bitacoraEstatusTarDeb;
			}
		});
		return matches.size() > 0 ? (LimitesTarDebIndividualBean) matches.get(0) : null;
	}
}
