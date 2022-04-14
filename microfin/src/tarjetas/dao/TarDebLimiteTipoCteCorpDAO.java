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

import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.bean.TarDebLimiteTipoCteCorpBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebLimiteTipoCteCorpDAO extends BaseDAO{

	public TarDebLimiteTipoCteCorpDAO() {
		super();
	}
	/*Alta de tipos de tarjetas de debito y cliente corporativo*/
	public MensajeTransaccionBean tipoTarjetaDebitoCte(final int tipoTransaccion, final TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean) {
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
								String query = "call TARDEBLIMXCONTRAALT(?,?,?,?,?,	?,?,?,?,?,?,	?,?,?,?,?, ?,?,?,?,?, ?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarDebLimiteTipoCteCorpBean.getTipoTarjetaDebID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(tarDebLimiteTipoCteCorpBean.getClienteCorpID()));
								sentenciaStore.setString("Par_DisposicionesDia",tarDebLimiteTipoCteCorpBean.getNumeroDia());
								sentenciaStore.setString("Par_MontoMaxDia",tarDebLimiteTipoCteCorpBean.getMontoDisDia());
								sentenciaStore.setString("Par_MontoMaxMes",tarDebLimiteTipoCteCorpBean.getMontoDisMes());

								sentenciaStore.setString("Par_MontoMaxCompraDia",tarDebLimiteTipoCteCorpBean.getMontoComDia());
								sentenciaStore.setString("Par_MontoMaxComprasMensual",tarDebLimiteTipoCteCorpBean.getMontoComMes());
								sentenciaStore.setString("Par_BloqueoATM",tarDebLimiteTipoCteCorpBean.getBloqueoATM());
								sentenciaStore.setString("Par_BloqueoPOS",tarDebLimiteTipoCteCorpBean.getBloqueoPOS());
								sentenciaStore.setString("Par_BloqueoCashback",tarDebLimiteTipoCteCorpBean.getBloqueoCash());


								sentenciaStore.setString("Par_OperacionesMOTO",tarDebLimiteTipoCteCorpBean.getOperacionMoto());
								sentenciaStore.setString("Par_NumConsultaMes",tarDebLimiteTipoCteCorpBean.getNumConsultaMes());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de limites por tipo de tarjeta de debito", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consulta de tipo de tarjeta debito y cliente corporativo*/
	public TarDebLimiteTipoCteCorpBean consultaTipoTarjetaDebitoCte(int tipoConsulta,TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean){

		String query = "call TARDEBLIMXCONTRACON(?,?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarDebLimiteTipoCteCorpBean.getTipoTarjetaDebID(),
				tarDebLimiteTipoCteCorpBean.getClienteCorpID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TarDebLimiteTipoCteCorpDAO.consultaTipoTarjetaDebitoCte",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBLIMXCONTRACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarDebLimiteTipoCteCorpBean tipoTarjetaDeb= new TarDebLimiteTipoCteCorpBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjetaDeb.setDescripcion(resultSet.getString(2));
				tipoTarjetaDeb.setClienteCorpID(
				 (resultSet.getString(3)!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteEntero(resultSet.getString(3)
										   ),TarDebLimiteTipoCteCorpBean.LONGITUD_ID) : Constantes.STRING_VACIO  );
				tipoTarjetaDeb.setNombreClienteCorp(resultSet.getString(4));
				tipoTarjetaDeb.setMontoDisDia(resultSet.getString(5));
				tipoTarjetaDeb.setMontoDisMes(resultSet.getString(6));
				tipoTarjetaDeb.setMontoComDia(resultSet.getString(7));
				tipoTarjetaDeb.setMontoComMes(resultSet.getString(8));
				tipoTarjetaDeb.setBloqueoATM(resultSet.getString(9));
				tipoTarjetaDeb.setBloqueoPOS(resultSet.getString(10));
				tipoTarjetaDeb.setBloqueoCash(resultSet.getString(11));
				tipoTarjetaDeb.setOperacionMoto(resultSet.getString(12));
				tipoTarjetaDeb.setNumeroDia(resultSet.getString(13));
				tipoTarjetaDeb.setNumConsultaMes(resultSet.getString(14));
					return tipoTarjetaDeb;
			}
		});

		return matches.size() > 0 ? (TarDebLimiteTipoCteCorpBean) matches.get(0) : null;
	}
	/* Modificacion de tipo de tarjeta debito y cliente corporativo */
	public MensajeTransaccionBean modtipoTarjetaDebitoCte(final TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					String query = "call TARDEBLIMXCONTRAACT(?,?,?,?,?,	?,?,?,?,?,?, 	?,?,?,?,?,	?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(tarDebLimiteTipoCteCorpBean.getTipoTarjetaDebID()),
							tarDebLimiteTipoCteCorpBean.getNumeroDia(),
							tarDebLimiteTipoCteCorpBean.getMontoDisDia(),
							tarDebLimiteTipoCteCorpBean.getMontoDisMes(),
							tarDebLimiteTipoCteCorpBean.getMontoComDia(),
							tarDebLimiteTipoCteCorpBean.getMontoComMes(),
							tarDebLimiteTipoCteCorpBean.getBloqueoATM(),
							tarDebLimiteTipoCteCorpBean.getBloqueoPOS(),
							tarDebLimiteTipoCteCorpBean.getBloqueoCash(),
							tarDebLimiteTipoCteCorpBean.getOperacionMoto(),
							tarDebLimiteTipoCteCorpBean.getNumConsultaMes(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"TarDebLimiteTipoTarDebDAO.modtipoTarjetaDebito",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBLIMXCONTRAACT(" + Arrays.toString(parametros) +")");
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


