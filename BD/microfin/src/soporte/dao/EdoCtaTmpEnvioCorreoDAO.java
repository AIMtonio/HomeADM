package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.bean.EdoCtaTmpEnvioCorreoBean;

public class EdoCtaTmpEnvioCorreoDAO extends BaseDAO {
	EdoCtaParamsDAO edoCtaParamsDAO = null;

	/**
	 * Funcion para dar de baja todos los registros en la tabla temporal de envio de correo con los estados de cuenta.
	 *
	 * @param tipoBaja
	 * @param edoCtaTmpEnvioCorreoBean
	 * @param nombreOrigenDatos
	 * @return
	 */
	public MensajeTransaccionBean bajaCompletaEdoCtaTmpEnvioCorreo(final int tipoBaja, final EdoCtaTmpEnvioCorreoBean edoCtaTmpEnvioCorreoBean, final String nombreOrigenDatos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(nombreOrigenDatos)).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(nombreOrigenDatos)).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL EDOCTATMPENVIOCORREOBAJ(?,?,?,?,?,?,?,?,  ?,  ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AnioMes", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_SucursalID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_CorreoEnvio", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_EstatusEdoCta", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_EstatusEnvio", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_FechaEnvio", Constantes.FECHA_VACIA);
									sentenciaStore.setInt("Par_UsuarioEnvia", Constantes.ENTERO_CERO);

									//Opcion Baja
									sentenciaStore.setInt("Par_NumBaj", tipoBaja);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.bajaCompletaEdoCtaTmpEnvioCorreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.bajaCompletaEdoCtaTmpEnvioCorreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar la baja de correos " + e);
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

	/**
	 * Funcion para dar de alta el envio de un correo con estados de cuenta.
	 *
	 * @param edoCtaTmpEnvioCorreoBean
	 * @param nombreOrigenDatos
	 * @return
	 */
	public MensajeTransaccionBean altaEdoCtaTmpEnvioCorreo(final EdoCtaTmpEnvioCorreoBean edoCtaTmpEnvioCorreoBean, final String nombreOrigenDatos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(nombreOrigenDatos)).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(nombreOrigenDatos)).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL EDOCTATMPENVIOCORREOALT(?,?,?,?,?,?,?,?,?,   ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AnioMes", Utileria.convierteEntero(edoCtaTmpEnvioCorreoBean.getAnioMes()));
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(edoCtaTmpEnvioCorreoBean.getClienteID()));
									sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(edoCtaTmpEnvioCorreoBean.getSucursalID()));
									sentenciaStore.setString("Par_CorreoEnvio", edoCtaTmpEnvioCorreoBean.getCorreo());
									sentenciaStore.setString("Par_EstatusEdoCta", edoCtaTmpEnvioCorreoBean.getEstatusEdoCta());
									sentenciaStore.setString("Par_EstatusEnvio", edoCtaTmpEnvioCorreoBean.getEstatusEnvio());
									sentenciaStore.setString("Par_FechaEnvio", Utileria.convierteFecha(edoCtaTmpEnvioCorreoBean.getFechaEnvio()));
									sentenciaStore.setInt("Par_UsuarioEnvia", Utileria.convierteEntero(edoCtaTmpEnvioCorreoBean.getUsuarioEnvia()));
									sentenciaStore.setString("Par_PDFGenerado", edoCtaTmpEnvioCorreoBean.getPdfGenerado());

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.altaEdoCtaTmpEnvioCorreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.altaEdoCtaTmpEnvioCorreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar el alta del correo " + e);
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

	/**
	 * Funcion que procesa los correos del temporal al productivo.
	 *
	 * @param tipoProceso
	 * @param edoCtaEnvioCorreoBean
	 * @param nombreOrigenDatos
	 * @return
	 */
	public MensajeTransaccionBean proEdoCtaEnvioCorreo(final int tipoProceso, final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean, final String nombreOrigenDatos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(nombreOrigenDatos)).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(nombreOrigenDatos)).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL EDOCTATMPENVIOCORREOPRO(?,?,?,?,?,?,?,?,   ?,   ?,?,?,   ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AnioMes", Utileria.convierteEntero(edoCtaEnvioCorreoBean.getAnioMes()));
									sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_SucursalID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_CorreoEnvio", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_EstatusEdoCta", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_EstatusEnvio", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_FechaEnvio", Constantes.FECHA_VACIA);
									sentenciaStore.setInt("Par_UsuarioEnvia", Constantes.ENTERO_CERO);

									//Opcion Baja
									sentenciaStore.setInt("Par_NumPro", tipoProceso);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar el alta del correo " + e);
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

	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}

	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}
}
