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

import tarjetas.bean.ConfigFTPProsaBean;
import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.bean.TarjetaDebitoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ConfiguracionProcesoTarDAO extends BaseDAO{
	public ConfiguracionProcesoTarDAO(){
		super();
	}

	public MensajeTransaccionBean confifFTPProsaMod(final int tipoTransaccion, final ConfigFTPProsaBean  configFTPProsaBean) {
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
								String query = "call CONFIGFTPPROSAMOD(?,?,?,?,?, 	?,?,?,?,?,   ?,   ?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ConfigFTPProsaID",Utileria.convierteEntero(configFTPProsaBean.getConfigFTPProsaID()));
								sentenciaStore.setString("Par_Servidor",configFTPProsaBean.getServidor());
								sentenciaStore.setString("Par_Usuario",configFTPProsaBean.getUsuario());
								sentenciaStore.setString("Par_Contrasenia",configFTPProsaBean.getContrasenia());
								sentenciaStore.setString("Par_Puerto",configFTPProsaBean.getPuerto());

								sentenciaStore.setString("Par_Ruta",configFTPProsaBean.getRuta());
								sentenciaStore.setString("Par_HoraInicio",configFTPProsaBean.getHoraInicio());
								sentenciaStore.setString("Par_HoraFin",configFTPProsaBean.getHoraFin());
								sentenciaStore.setInt("Par_IntervaloMin",Utileria.convierteEntero(configFTPProsaBean.getIntervaloMin()));
								sentenciaStore.setInt("Par_NumIntentos",Utileria.convierteEntero(configFTPProsaBean.getNumIntentos()));

								sentenciaStore.setString("Par_Mensaje",configFTPProsaBean.getMensajeCorreo());

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_UsuarioID", parametrosAuditoriaBean.getUsuario());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de configuracion ftp", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean  configFTPProsaAct(final int tipoTransaccion, final ConfigFTPProsaBean  configFTPProsaBean) {
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
								String query = "call CONFIGFTPPROSAACT(?,?,?,?,?, 	?,?,?,?,?,   ?,?,?,?,?,    ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ConfigFTPProsaID",Utileria.convierteEntero(configFTPProsaBean.getConfigFTPProsaID()));
								sentenciaStore.setString("Par_Servidor",configFTPProsaBean.getServidor());
								sentenciaStore.setString("Par_Usuario",configFTPProsaBean.getUsuario());
								sentenciaStore.setString("Par_Contrasenia",configFTPProsaBean.getContrasenia());
								sentenciaStore.setString("Par_Puerto",configFTPProsaBean.getPuerto());

								sentenciaStore.setInt("Par_NumAct",tipoTransaccion);
								sentenciaStore.setString("Par_Ruta",configFTPProsaBean.getRuta());
								sentenciaStore.setString("Par_HoraInicio",configFTPProsaBean.getHoraInicio());
								sentenciaStore.setInt("Par_IntervaloMin",Utileria.convierteEntero(configFTPProsaBean.getIntervaloMin()));
								sentenciaStore.setInt("Par_NumIntentos",Utileria.convierteEntero(configFTPProsaBean.getNumIntentos()));

								sentenciaStore.setString("Par_Mensaje",configFTPProsaBean.getMensajeCorreo());
								sentenciaStore.setInt("Par_UsuarioRemiten", Utileria.convierteEntero(configFTPProsaBean.getUsuarioRemitente()));

								sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
								// Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_UsuarioID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","ConfiguracionProcesoTarDAO.configFTPProsaAct");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en ACTUALIZAR la configuracion ftp", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/// consulta principal
	public ConfigFTPProsaBean principal(final int tipoConsulta, ConfigFTPProsaBean configFTPProsaBean){
		String query = "call CONFIGFTPPROSACON(?,?,   ?,?,?,?, ?,?,?);";

		Object[] parametros = {
				configFTPProsaBean.getConfigFTPProsaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConfiguracionProcesoTarDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONFIGFTPPROSACON(" + Arrays.toString(parametros) +")");
		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConfigFTPProsaBean configFTPProsaBean = new ConfigFTPProsaBean();
				configFTPProsaBean.setConfigFTPProsaID(resultSet.getString("ConfigFTPProsaID"));
				configFTPProsaBean.setServidor(resultSet.getString("Servidor"));
				configFTPProsaBean.setUsuario(resultSet.getString("Usuario"));
				configFTPProsaBean.setContrasenia(resultSet.getString("Contrasenia"));
				configFTPProsaBean.setPuerto(resultSet.getString("Puerto"));
				configFTPProsaBean.setRuta(resultSet.getString("Ruta"));
				configFTPProsaBean.setHoraInicio(resultSet.getString("HoraInicio"));
				configFTPProsaBean.setIntervaloMin(resultSet.getString("IntervaloMin"));
				configFTPProsaBean.setNumIntentos(resultSet.getString("NumIntentos"));
				configFTPProsaBean.setMensajeCorreo(resultSet.getString("Mensaje"));
				//configFTPProsaBean.setCorreoRemitente(resultSet.getString("CorreoRemitente"));
				configFTPProsaBean.setUsuarioRemitente(resultSet.getString("UsuarioRemiten"));



				return configFTPProsaBean;
			}
		});
		return matches.size() > 0 ? (ConfigFTPProsaBean) matches.get(0) : null;
	}


}
