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
import tarjetas.bean.TarDebLimiteTipoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebLimiteTipoDAO extends BaseDAO{

	public TarDebLimiteTipoDAO() {
		super();
	}
	/*Alta de tipos de tarjetas de debito*/
	public MensajeTransaccionBean tipoTarjetaDebito(final int tipoTransaccion, final TarDebLimiteTipoBean tarDebLimiteTipoBean) {
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
								String query = "call TARDEBLIMITESXTIPOALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,"
																		+ "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarDebLimiteTipoBean.getTipoTarjetaDebID()));
								sentenciaStore.setString("Par_DisposicionesDia",tarDebLimiteTipoBean.getNumeroDia());
								sentenciaStore.setString("Par_MontoMaxDia",tarDebLimiteTipoBean.getMontoDisDia());
								sentenciaStore.setString("Par_MontoMaxMes",tarDebLimiteTipoBean.getMontoDisMes());
								sentenciaStore.setString("Par_MontoMaxCompraDia",tarDebLimiteTipoBean.getMontoComDia());

								sentenciaStore.setString("Par_MontoMaxComprasMensual",tarDebLimiteTipoBean.getMontoComMes());
								sentenciaStore.setString("Par_BloqueoATM",tarDebLimiteTipoBean.getBloqueoATM());
								sentenciaStore.setString("Par_BloqueoPOS",tarDebLimiteTipoBean.getBloqueoPOS());
								sentenciaStore.setString("Par_BloqueoCashback",tarDebLimiteTipoBean.getBloqueoCash());
								sentenciaStore.setString("Par_OperacionesMOTO",tarDebLimiteTipoBean.getOperacionMoto());

								sentenciaStore.setInt("Par_NumConsultaMes",Utileria.convierteEntero(tarDebLimiteTipoBean.getNumConsultaMes()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de limites por tipo de tarjeta de debito", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consulta de tipo de tarjeta debito*/
	public TarDebLimiteTipoBean consultaTipoTarjetaDebito(int tipoConsulta,TarDebLimiteTipoBean tarDebLimiteTipoBean){
		String query = "call TARDEBLIMITESXTIPOCON(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarDebLimiteTipoBean.getTipoTarjetaDebID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebLimiteTipoTarDebDAO.consultaTipoTarjetaDebito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBLIMITESXTIPOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebLimiteTipoBean tipoTarjetaDeb= new TarDebLimiteTipoBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjetaDeb.setDescripcion(resultSet.getString(2));
				tipoTarjetaDeb.setMontoDisDia(resultSet.getString(3));
				tipoTarjetaDeb.setMontoDisMes(resultSet.getString(4));
				tipoTarjetaDeb.setMontoComDia(resultSet.getString(5));
				tipoTarjetaDeb.setMontoComMes(resultSet.getString(6));
				tipoTarjetaDeb.setBloqueoATM(resultSet.getString(7));
				tipoTarjetaDeb.setBloqueoPOS(resultSet.getString(8));
				tipoTarjetaDeb.setBloqueoCash(resultSet.getString(9));
				tipoTarjetaDeb.setOperacionMoto(resultSet.getString(10));
				tipoTarjetaDeb.setNumeroDia(resultSet.getString(11));
				tipoTarjetaDeb.setNumConsultaMes(resultSet.getString(12));
				return tipoTarjetaDeb;
			}
		});
		return matches.size() > 0 ? (TarDebLimiteTipoBean) matches.get(0) : null;
	}

	/* Modificacion de tipo de tarjeta debito */
	public MensajeTransaccionBean modtipoTarjetaDebito(final TarDebLimiteTipoBean tarDebLimiteTipoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call TARDEBLIMITESXTIPOMOD(?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,"
															+ "?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(tarDebLimiteTipoBean.getTipoTarjetaDebID()),
							tarDebLimiteTipoBean.getNumeroDia(),
							tarDebLimiteTipoBean.getMontoDisDia(),
							tarDebLimiteTipoBean.getMontoDisMes(),
							tarDebLimiteTipoBean.getMontoComDia(),

							tarDebLimiteTipoBean.getMontoComMes(),
							tarDebLimiteTipoBean.getBloqueoATM(),
							tarDebLimiteTipoBean.getBloqueoPOS(),
							tarDebLimiteTipoBean.getBloqueoCash(),
							tarDebLimiteTipoBean.getOperacionMoto(),

							tarDebLimiteTipoBean.getNumConsultaMes(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TarDebLimiteTipoTarDebDAO.modtipoTarjetaDebito",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBLIMITESXTIPOMOD(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de tipos de tarjetas", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}
