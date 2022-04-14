package tarjetas.dao;

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

import tarjetas.bean.LimitesTarCreIndividualBean;
import tarjetas.bean.LimitesTarDebIndividualBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class LimitesTarCreIndividualDAO extends BaseDAO{

	public LimitesTarCreIndividualDAO() {
		super();
	}

	public MensajeTransaccionBean limitesTardeb( final LimitesTarDebIndividualBean limitesTarCreIndividualBean) {
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
								String query = "call TARCRELIMITESALT( ?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_TarjetaCredID",limitesTarCreIndividualBean.getTarjetaDebID());
								sentenciaStore.setString("Par_DisposicionesDia",limitesTarCreIndividualBean.getDisposicionesDia());
								sentenciaStore.setString("Par_MontoMaxDia",limitesTarCreIndividualBean.getMontoMaxDia());
								sentenciaStore.setString("Par_MontoMaxMes",limitesTarCreIndividualBean.getMontoMaxMes());
								sentenciaStore.setString("Par_MontoMaxCompraDia",limitesTarCreIndividualBean.getMontoMaxCompraDia());

								sentenciaStore.setString("Par_MontoMaxComprasMensual",limitesTarCreIndividualBean.getMontoMaxComprasMensual());
								sentenciaStore.setString("Par_BloqueoATM",limitesTarCreIndividualBean.getBloqueoATM());
								sentenciaStore.setString("Par_BloqueoPOS",limitesTarCreIndividualBean.getBloqueoPOS());
								sentenciaStore.setString("Par_BloqueoCashback",limitesTarCreIndividualBean.getBloqueoCashback());
								sentenciaStore.setString("Par_Vigencia",limitesTarCreIndividualBean.getVigencia());

								sentenciaStore.setString("Par_OperacionesMOTO",limitesTarCreIndividualBean.getOperacionesMOTO());
								sentenciaStore.setString("Par_NumConsultaMes",limitesTarCreIndividualBean.getNumConsultaMes());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de limites de tarjeta", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}






	/* Modificacion del Cliente */
	public MensajeTransaccionBean modificaLimitesTar(final LimitesTarDebIndividualBean limitesTarCreIndividualBean) {
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
									String query = "call TARCRELIMITESMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TarjetaCredID",limitesTarCreIndividualBean.getTarjetaDebID());
									sentenciaStore.setString("Par_DisposicionesDia",limitesTarCreIndividualBean.getDisposicionesDia());
									sentenciaStore.setString("Par_MontoMaxDia",limitesTarCreIndividualBean.getMontoMaxDia());
									sentenciaStore.setString("Par_MontoMaxMes",limitesTarCreIndividualBean.getMontoMaxComprasMensual());
									sentenciaStore.setString("Par_MontoMaxCompraDia",limitesTarCreIndividualBean.getMontoMaxCompraDia());

									sentenciaStore.setString("Par_MontoMaxComprasMensual",limitesTarCreIndividualBean.getMontoMaxComprasMensual());
									sentenciaStore.setString("Par_BloqueoATM",limitesTarCreIndividualBean.getBloqueoATM());
									sentenciaStore.setString("Par_BloqueoPOS",limitesTarCreIndividualBean.getBloqueoPOS());
									sentenciaStore.setString("Par_BloqueoCashback",limitesTarCreIndividualBean.getBloqueoCashback());
									sentenciaStore.setString("Par_Vigencia",limitesTarCreIndividualBean.getVigencia());

									sentenciaStore.setString("Par_OperacionesMOTO",limitesTarCreIndividualBean.getOperacionesMOTO());
									sentenciaStore.setString("Par_NumConsultaMes",limitesTarCreIndividualBean.getNumConsultaMes());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
							throw new Exception(Constantes.MSG_ERROR + " .LimitesTarCreDAO.modificaLimites");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Limites de Tarjeta" + e);
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


	//------------------------------------consulta de tipo de tarjeta debito  ----------------------
	public LimitesTarCreIndividualBean consultaLimitesTarDeb(int tipoConsulta,LimitesTarCreIndividualBean limitesTarCreIndividualBean){
		String query = "call TARCRELIMITESCON(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				limitesTarCreIndividualBean.getTarjetaCredID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TARCRELIMITESCON.consultaLimitesTarCre",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARCRELIMITESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				LimitesTarCreIndividualBean limitesTarCreIndividualBean = new LimitesTarCreIndividualBean();
				limitesTarCreIndividualBean.setDisposicionesDia(resultSet.getString(1));
				limitesTarCreIndividualBean.setMontoMaxDia(resultSet.getString(2));
				limitesTarCreIndividualBean.setNumConsultaMes(resultSet.getString(3));
				limitesTarCreIndividualBean.setMontoMaxMes(resultSet.getString(4));
				limitesTarCreIndividualBean.setMontoMaxCompraDia(resultSet.getString(5));
				limitesTarCreIndividualBean.setMontoMaxComprasMensual(resultSet.getString(6));
				limitesTarCreIndividualBean.setBloqueoATM(resultSet.getString(7));
				limitesTarCreIndividualBean.setBloqueoPOS(resultSet.getString(8));
				limitesTarCreIndividualBean.setBloqueoCashback(resultSet.getString(9));
				limitesTarCreIndividualBean.setVigencia(Utileria.convierteFecha(resultSet.getString(10)));
				limitesTarCreIndividualBean.setOperacionesMOTO(resultSet.getString(11));
				return limitesTarCreIndividualBean;
			}
		});

		return matches.size() > 0 ? (LimitesTarCreIndividualBean) matches.get(0) : null;
	}


}
