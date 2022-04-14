package soporte.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;

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

import credito.bean.AvalesBean;
import soporte.bean.EnvioCorreoBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

public class EnvioCorreoDAO extends BaseDAO{

	private static String Origen_PLD="P";
	private static String ESTATUS_NO_ENVIADO = "N";

	public EnvioCorreoDAO() {
		// TODO Auto-generated constructor stub
		super();
	}

	// Alta de correos
	public MensajeTransaccionBean altaCorreo(final EnvioCorreoBean envioCorreoBean) {
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
									String query = "call ENVIOCORREOALT(?,?,?,?,?,?,?,?,?,  ?,?,?,	?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Remitente",envioCorreoBean.getRemitente());
									sentenciaStore.setString("Par_DestinatarioPLD",envioCorreoBean.getDestinatario());
									sentenciaStore.setString("Par_Mensaje",envioCorreoBean.getMensaje());
									sentenciaStore.setString("Par_Asunto",envioCorreoBean.getAsunto());

									sentenciaStore.setString("Par_Fecha",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Par_ServidorCorreo",envioCorreoBean.getSevidorCorreo());
									sentenciaStore.setString("Par_Puerto",envioCorreoBean.getPuerto());
									sentenciaStore.setString("Par_UsuarioCorreo",envioCorreoBean.getUsuarioCorreo());
									sentenciaStore.setString("Par_Contrasenia",envioCorreoBean.getContrasenia());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria se mandan vacios ya que las  pantallas que ejecutan este metodo
									//no necesitan sesion
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Correo", e);
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

	// Alta de correos externa
	public MensajeTransaccionBean altaCorreoExterno(final EnvioCorreoBean envioCorreoBean,final String origenDatos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenDatos)).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ENVIOCORREOALT(?,?,?,?,?,?,?,?,?,  ?,?,?,	?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Remitente",envioCorreoBean.getRemitente());
									sentenciaStore.setString("Par_DestinatarioPLD",envioCorreoBean.getDestinatario());
									sentenciaStore.setString("Par_Mensaje",envioCorreoBean.getMensaje());
									sentenciaStore.setString("Par_Asunto",envioCorreoBean.getAsunto());

									sentenciaStore.setString("Par_Fecha",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Par_ServidorCorreo",envioCorreoBean.getSevidorCorreo());
									sentenciaStore.setString("Par_Puerto",envioCorreoBean.getPuerto());
									sentenciaStore.setString("Par_UsuarioCorreo",envioCorreoBean.getUsuarioCorreo());
									sentenciaStore.setString("Par_Contrasenia",envioCorreoBean.getContrasenia());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria se mandan vacios ya que las  pantallas que ejecutan este metodo
									//no necesitan sesion
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Aud_FechaActual",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
									sentenciaStore.setString("Aud_ProgramaID","Pantallas PLD");
									sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

									loggerSAFI.info(origenDatos+"-"+sentenciaStore.toString());
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
					loggerSAFI.error(origenDatos+"-"+"error en alta de Correo", e);
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

	/**
	 * Consulta que revisa cuantos correos pendientes hay para poder ejecutar el KTR para el proceso de PLD
	 * @param envioCorreoBean : Bean con la informacion para la consulta de pendientes de envio de correo
	 * @param tipoConsulta : Numero de consulta 1
	 * @return
	 */
	public EnvioCorreoBean consultaPendientesPLD(EnvioCorreoBean envioCorreoBean, int tipoConsulta) {
		try {
			String query = "call ENVIOCORREOCON("
					+ "?,?,?,?,?,     "
					+ "?,?,?,?,?,     "
					+ "?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Origen_PLD,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.FECHA_VACIA,

					ESTATUS_NO_ENVIADO,
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ENVIOCORREOCON(  " + Arrays.toString(parametros) + ")");
			List<EnvioCorreoBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try {
						EnvioCorreoBean bean = new EnvioCorreoBean();
						bean.setPendientesEnvio(resultSet.getString("PendientesEnvio"));
						return bean;
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					return null;
				}
			});
			return matches.size() > 0 ? (EnvioCorreoBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
}
