package aportaciones.dao;

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

import cardinal.seguridad.mars.Encryptor20;

import aportaciones.bean.AportDispersionesBean;
import aportaciones.bean.AportacionesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import ventanilla.bean.SpeiEnvioBean;


public class AportDispersionesDAO extends BaseDAO{

	public AportDispersionesDAO(){
		super();
	}
	private static interface Enum_NumActualizacionSPEI {
		int actualizaFirma = 504;
	}
	/**
	 * Alta de los Beneficiarios de las Dispersiones.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final AportDispersionesBean aportDispersionesBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTBENEFICIARIOSALT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setString("Par_InstitucionID", aportDispersionesBean.getInstitucionID());
									sentenciaStore.setString("Par_TipoCuentaSpei", aportDispersionesBean.getTipoCuentaID());

									sentenciaStore.setString("Par_Clabe", aportDispersionesBean.getClabe());
									sentenciaStore.setString("Par_Beneficiario", aportDispersionesBean.getBeneficiario());
									sentenciaStore.setString("Par_EsPrincipal", aportDispersionesBean.getEsPrincipal());
									sentenciaStore.setDouble("Par_MontoDispersion", Utileria.convierteDoble(aportDispersionesBean.getMonto()));
									sentenciaStore.setDouble("Par_MontoTotal", Utileria.convierteDoble(aportDispersionesBean.getTotal()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de dispersiones aport: " + e);
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
	 * Actualización de las Dispersiones.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualiza(final AportDispersionesBean aportDispersionesBean,final int tipoAct, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTDISPERSIONESACT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setString("Par_Estatus", aportDispersionesBean.getEstatus());
									sentenciaStore.setInt("Par_TipoAct", tipoAct);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: " + e);
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
	 * Actualización de las Dispersiones.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean valida(final String detalle,final int tipoAct) {
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
									String query = "call APORTDISPERSIONVAL("
											+ "?,"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_CadenaAport", detalle);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: " + e);
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
	 * Actualización de los beneficiarios.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean actualizaBeneficiarios(final AportDispersionesBean aportDispersionesBean,final int tipoAct, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTDISPERSIONESACT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setString("Par_Estatus", aportDispersionesBean.getEstatus());
									sentenciaStore.setInt("Par_TipoAct", tipoAct);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: " + e);
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
	 * Actualización de las Dispersiones.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 *
	 */
	public MensajeTransaccionBean cancela(final AportDispersionesBean aportDispersionesBean,final int tipoAct, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTDISPERSIONCAN("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setString("Par_MontoCancelar", aportDispersionesBean.getMonto());
									sentenciaStore.setInt("Par_TipoBaja", tipoAct);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.actualizacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: " + e);
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
	 * Procesa de las Dispersiones SPEI.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con los datos de la cuota a Dispersar.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean procesa(final AportDispersionesBean aportDispersionesBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTDISPERSIONESPRO("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("SpeiControl"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.procesa");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.procesa");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en dispersion de aportaciones: " + e);
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
	 * Procesa Exportar Dispersiones.
	 * @param aportDispersionesBean : Clase bean {@link AportDispersionesBean} con los datos de la cuota a Exportar.
	 * @param numTransaccion : Número de transacción.
	 */
	public MensajeTransaccionBean exporta(final AportDispersionesBean aportDispersionesBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call EXPORTADISPERSIONESPRO("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.procesa");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.procesa");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en dispersion de aportaciones: " + e);
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
	 * Elimina los beneficiarios de las dispersiones y los pasa al histórico.
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean}.
	 * @param numTransaccion número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean baja(final AportDispersionesBean aportDispersionesBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISAPORTBENEFICIARIOSALT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_AportacionID", aportDispersionesBean.getAportacionID());
									sentenciaStore.setString("Par_AmortizacionID", aportDispersionesBean.getAmortizacionID());
									sentenciaStore.setString("Par_CuentaTranID", aportDispersionesBean.getCuentaTranID());
									sentenciaStore.setInt("Par_TipoBaja", 1);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportDispersionesDAO.baja");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportDispersionesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de dispersiones aport: " + e);
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
	 * Método que elimina y registra los nuevos beneficiarios de las dispersiones pendientes.
	 * @param apDispBean Clase bean que contiene los valores para dar de baja del grupo y da de alta en el histórico.
	 * @param listaDetalle Lista de los nuevos integrantes a registrar.
	 * @return MensajeTransaccionBean Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaDetalle(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();

		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					String tipoPersona = "";
					int tipoAct = 2;

					for(AportDispersionesBean detalleBaja : listaDetalle){
						tipoPersona = detalleBaja.getTipoPersona();

						mensajeBean=baja(detalleBaja, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						if(tipoPersona.equalsIgnoreCase("A")){
							mensajeBean = actualiza(detalleBaja, tipoAct, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = alta(detalleBaja, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar beneficiarios aport: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Método que actualiza los estatus de las dispersiones.
	 * @param apDispBean Clase bean que contiene los valores para la actualización.
	 * @param listaDetalle Lista de las cuotas.
	 * @param tipoTransaccion tipo de transacción.
	 * @return MensajeTransaccionBean Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizaEstatus(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalle, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					for(AportDispersionesBean detalle : listaDetalle){
						mensajeBean = actualiza(detalle, tipoTransaccion, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}




	/**
	 * Método que cancela las dispersiones.
	 * @param apDispBean Clase bean que contiene los valores para la actualización.
	 * @param listaDetalle Lista de las cuotas.
	 * @param tipoTransaccion tipo de transacción.
	 * @return MensajeTransaccionBean Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean cancelaAport(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalle, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					String tipoPersona = "";
					int tipoAct = 0;

					for(AportDispersionesBean detalle : listaDetalle){
						tipoPersona = detalle.getTipoPersona();
						if(tipoPersona.equalsIgnoreCase("A")){
							tipoAct = 1;
							tipoPersona = detalle.getTipoPersona();

							mensajeBean=baja(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = cancela(detalle, tipoAct, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}else{
							tipoAct = 2;
							tipoPersona = detalle.getTipoPersona();

							mensajeBean=baja(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = cancela(detalle, tipoAct, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}


					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de dispersiones aport: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Método que procesa las dispersiones.
	 * @param apDispBean Clase bean que contiene los valores para dispersar las aportaciones.
	 * @param listaDetalle Lista de las cuotas a dispersar.
	 * @param tipoTransaccion tipo de transacción.
	 * @return MensajeTransaccionBean Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean dispersaAport(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalle, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();

				try{
					for(AportDispersionesBean detalle : listaDetalle){
						mensajeBean = procesa(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						if (mensajeBean.getCampoGenerico().equalsIgnoreCase("S")){
							int AportBeneficiarioID = Utileria.convierteEntero(mensajeBean.getConsecutivoString());
							int numCon	= 1;

							speiEnvioBean = consultaSpeiAport(numCon,parametrosAuditoriaBean.getNumeroTransaccion(),AportBeneficiarioID);

							if(speiEnvioBean != null){
								try {
									Encryptor20 encryptor = new Encryptor20();
									String firmaSAFI = "";

						        	firmaSAFI = speiEnvioBean.getFolioSpeiID() + speiEnvioBean.getCuentaBeneficiario() + speiEnvioBean.getCuentaOrd();

						        	firmaSAFI = encryptor.generaFirmaStrong(firmaSAFI);

						        	speiEnvioBean.setFirma(firmaSAFI);
								} catch (Exception e) {
									mensajeBean.setNumero(999);
									throw new Exception("Ha ocurrido un error al generar la Firma del SPEI.");
								}

								mensajeBean = actualizarFirmaEnvioSPEI(speiEnvioBean, parametrosAuditoriaBean.getNumeroTransaccion());

								if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesamiento de dispersiones aport: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 *
	 * @param apDispBean : Clase bean que contiene los valores para exportar las aportaciones.
	 * @param listaDetalle : Lista de las cuotas a exportar.
	 * @param tipoTransaccion : Tipo de Transacción.
	 * @return
	 */
	public MensajeTransaccionBean exportaAport(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalle, final int tipoTransaccion) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					for(AportDispersionesBean detalle : listaDetalle){
						mensajeBean = exporta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesamiento de Exportación de Aportaciones: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Lista las Dispersiones Pendientes de las Aportaciones. (usada en el Grid).
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con el número del cliente.
	 * @param tipoLista número de lista.
	 * @return Lista con las Cuotas.
	 * @author avelasco
	 */
	public List<AportDispersionesBean> listaPrincipal(AportDispersionesBean aportDispersionesBean, int tipoLista){
		transaccionDAO.generaNumeroTransaccion();

		String query = "call APORTDISPERSIONESLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?,	"
				+ "?,?);";
		Object[] parametros = {
				aportDispersionesBean.getAportacionID(),
				aportDispersionesBean.getAmortizacionID(),
				aportDispersionesBean.getClienteID(),
				aportDispersionesBean.getNombreCompleto(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AportDispersionesDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTDISPERSIONESLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List<AportDispersionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportDispersionesBean aportDispersionesBean = new AportDispersionesBean();
				try{
				aportDispersionesBean.setAportacionID(resultSet.getString("AportacionID"));
				aportDispersionesBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				aportDispersionesBean.setClienteID(resultSet.getString("ClienteID"));
				aportDispersionesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				aportDispersionesBean.setCapital(resultSet.getString("Capital"));
				aportDispersionesBean.setInteres(resultSet.getString("Interes"));
				aportDispersionesBean.setInteresRetener(resultSet.getString("InteresRetener"));
				aportDispersionesBean.setTotal(resultSet.getString("Total"));
				aportDispersionesBean.setCuentaTranID(resultSet.getString("CuentaTranID"));
				aportDispersionesBean.setInstitucionID(resultSet.getString("InstitucionID"));
				aportDispersionesBean.setNombre(resultSet.getString("Nombre"));
				aportDispersionesBean.setTipoCuentaID(resultSet.getString("TipoCuentaSpei"));
				aportDispersionesBean.setTipoCuentaDesc(resultSet.getString("TipoCuentaDesc"));
				aportDispersionesBean.setClabe(resultSet.getString("Clabe"));
				aportDispersionesBean.setBeneficiario(resultSet.getString("Beneficiario"));
				aportDispersionesBean.setEsPrincipal(resultSet.getString("EsPrincipal"));
				aportDispersionesBean.setMonto(resultSet.getString("MontoDispersion"));
				aportDispersionesBean.setEstatus(resultSet.getString("Estatus"));
				aportDispersionesBean.setTotalBenP(resultSet.getString("TotalBenP"));
				aportDispersionesBean.setTotalBenNP(resultSet.getString("TotalBenNP"));
				aportDispersionesBean.setCuentaAhoID(resultSet.getString("cuentaAhoID"));
				aportDispersionesBean.setMontoPendiente(resultSet.getString("MontoPendiente"));
				aportDispersionesBean.setTotalMontoPendiente(resultSet.getString("MontoTotalPendiente"));
				}catch(Exception cx){
					cx.printStackTrace();
				}
				return aportDispersionesBean;
			}
		});
		return matches;
	}

	/**
	 * Lista los Beneficiarios de Cuentas Destino. (usada en el Grid).
	 * @param aportDispersionesBean clase bean {@link AportDispersionesBean} con el número del cliente.
	 * @param tipoLista número de lista.
	 * @return Lista con las Cuotas.
	 * @author avelasco
	 */
	public List<AportDispersionesBean> listaBeneficiarios(AportDispersionesBean aportDispersionesBean, int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		String query = "call APORTDISPERSIONESLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?,	"
				+ "?,?);";
		Object[] parametros = {
				aportDispersionesBean.getAportacionID(),
				aportDispersionesBean.getAmortizacionID(),
				aportDispersionesBean.getClienteID(),
				aportDispersionesBean.getNombreCompleto(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AportDispersionesDAO.listaBeneficiarios",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTDISPERSIONESLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List<AportDispersionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportDispersionesBean aportDispersionesBean = new AportDispersionesBean();
				aportDispersionesBean.setAportacionID(resultSet.getString("AportacionID"));
				aportDispersionesBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				aportDispersionesBean.setCuentaTranID(resultSet.getString("CuentaTranID"));
				aportDispersionesBean.setInstitucionID(resultSet.getString("InstitucionID"));
				aportDispersionesBean.setNombre(resultSet.getString("Nombre"));
				aportDispersionesBean.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
				aportDispersionesBean.setTipoCuentaDesc(resultSet.getString("Descripcion"));
				aportDispersionesBean.setClabe(resultSet.getString("Clabe"));
				aportDispersionesBean.setBeneficiario(resultSet.getString("Beneficiario"));
				aportDispersionesBean.setEsPrincipal(resultSet.getString("EsPrincipal"));
				aportDispersionesBean.setTotal(resultSet.getString("Total"));
				aportDispersionesBean.setMonto(resultSet.getString("MontoDispersion"));
				aportDispersionesBean.setTieneBen(resultSet.getString("TieneBen"));
				return aportDispersionesBean;
			}
		});
		return matches;
	}

	/**
	 * Lista los Clientes con Aportaciones Pendientes a Dispersar.
	 * @param aportDispersionesBean clase bean {@link AportacionesBean} con el número del cliente.
	 * @param tipoLista número de lista.
	 * @return Lista con los clientes.
	 * @author avelasco
	 */
	public List<AportDispersionesBean> listaClientes(AportacionesBean aportDispersionesBean, int tipoLista){
		String query = "call APORTDISPERSIONESLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?,	"
				+ "?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				aportDispersionesBean.getClienteID(),
				aportDispersionesBean.getNombreCompleto(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"AportDispersionesDAO.listaPrincipal",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTDISPERSIONESLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List<AportDispersionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportDispersionesBean aportDispersionesBean = new AportDispersionesBean();
				aportDispersionesBean.setNumero(resultSet.getString("ClienteID"));
				aportDispersionesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return aportDispersionesBean;
			}
		});
		return matches;
	}

	/**
	 * Reporte de Dispersiones Procesadas.
	 * @param aportDispersionesBean {@link AportDispersionesBean} bean con la información a filtrar.
	 * @param tipoLista {@link int} Tipo de Lista.
	 * @return List<{@link AportDispersionesBean} lista con los datos del reporte.
	 * @author avelasco
	 */
	public List<AportDispersionesBean> listaReporte(AportDispersionesBean aportDispersionesBean, int tipoLista) {
		String query = "call APORTBENEFICIARIOSREP("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?,	"
				+ "?,?,?);";
		Object[] parametros = {
				aportDispersionesBean.getFechaInicio(),
				aportDispersionesBean.getFechaFinal(),
				aportDispersionesBean.getEstatus(),
				Utileria.convierteEntero(aportDispersionesBean.getClienteID()),
				Utileria.convierteEntero(aportDispersionesBean.getProductoID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),

				parametrosAuditoriaBean.getDireccionIP(),
				"AportDispersionesDAO.listaReporte",
				parametrosAuditoriaBean.getSucursal(),
				aportDispersionesBean.getNumTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTBENEFICIARIOSREP(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List<AportDispersionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportDispersionesBean aportDispersionesBean = new AportDispersionesBean();
				aportDispersionesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				aportDispersionesBean.setClienteID(resultSet.getString("ClienteID"));
				aportDispersionesBean.setNombreAportante(resultSet.getString("NombreAportante"));
				aportDispersionesBean.setPromotorID(resultSet.getString("PromotorID"));
				aportDispersionesBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
				aportDispersionesBean.setFechaCorte(resultSet.getString("FechaCorte"));
				aportDispersionesBean.setNumAportaciones(resultSet.getString("NumAportaciones"));
				aportDispersionesBean.setCapital(resultSet.getString("Capital"));
				aportDispersionesBean.setInteres(resultSet.getString("Interes"));
				aportDispersionesBean.setInteresRetener(resultSet.getString("InteresRetener"));
				aportDispersionesBean.setTotal(resultSet.getString("Total"));
				aportDispersionesBean.setDesEstatus(resultSet.getString("DesEstatus"));
				aportDispersionesBean.setNombreInstitucion(resultSet.getString("NombreInstitucion"));
				aportDispersionesBean.setTipoCuentaSpei(resultSet.getString("TipoCuentaSpei"));
				aportDispersionesBean.setClabe(resultSet.getString("Clabe"));
				aportDispersionesBean.setBeneficiario(resultSet.getString("Beneficiario"));
				aportDispersionesBean.setCantidadPagada(resultSet.getString("CantidadPagada"));
				aportDispersionesBean.setCantidadenDispersion(resultSet.getString("CantidadenDispersion"));
				aportDispersionesBean.setCantidadPendiente(resultSet.getString("CantidadPendiente"));
				aportDispersionesBean.setNumTransaccion(resultSet.getString("NumTransaccion"));
				return aportDispersionesBean;
			}
		});
		return matches;
	}

	/* Consulta de la BD para generar archivo de Dispersion Interbancario de Aportaciones */
	public List consultaDatosDispersionInter( final int consecutivo,int tipoConsulta){
		List dispersion = null;
		try{
			String query = "call EXPORTADISPERSIONESCON(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					consecutivo,
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AportDispersionesDAO.dispersionInter",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EXPORTADISPERSIONESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					AportDispersionesBean disperBean = new AportDispersionesBean();

					disperBean.setCuentaDestino(resultSet.getString("CuentaDestino"));
					disperBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					disperBean.setMonto(resultSet.getString("Monto"));
					disperBean.setNombreBeneficiario(resultSet.getString("NombreBenefi"));
					disperBean.setFolio(resultSet.getString("Folio"));
					disperBean.setDescripcion(resultSet.getString("Descripcion"));
					disperBean.setReferencia(resultSet.getString("Referencia"));
					disperBean.setTipoCuentaID(resultSet.getString("TipoCuentaSpei"));

					return disperBean;
				}
			});
			dispersion = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Dispersión Bancomer Interbancario.", e);
		}
		return dispersion;
	}

	public MensajeTransaccionBean procesaAportaciones(final AportDispersionesBean apDispBean,final List<AportDispersionesBean> listaDetalleB,final String detalles,final int tipoAct) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = grabaDetalle(apDispBean, listaDetalleB);

					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = valida(detalles, tipoAct);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = dispersaAport(apDispBean, listaDetalleB, tipoAct);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en procesamiento de dispersiones aport: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;

	}

	// Consulta de SPEI para actualizar su Firma
	public SpeiEnvioBean consultaSpeiAport(int tipoConsulta, long numTransaccion, int AportDispersionID) {
		String query = "CALL SPEIAPORTACIONESCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				AportDispersionID,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				numTransaccion
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL SPEIENVIOSCON("+Arrays.toString(parametros) + ");");
		List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();

				speiEnvioBean.setFolioSpeiID(resultSet.getString("FolioSpeiID"));
				speiEnvioBean.setCuentaBeneficiario(resultSet.getString("CuentaBeneficiario"));
				speiEnvioBean.setCuentaOrd(resultSet.getString("CuentaOrd"));

				return speiEnvioBean;
			}
		});

		return matches.size() > 0 ? (SpeiEnvioBean)matches.get(0) : null;
	}

	// Actualización de la Firma del SPEI
	public MensajeTransaccionBean actualizarFirmaEnvioSPEI(final SpeiEnvioBean speiEnvioBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SPEIENVIOSSTPACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_Folio", Utileria.convierteLong(speiEnvioBean.getFolioSpeiID()));
									sentenciaStore.setString("Par_ClaveRastreo", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_EstatusEnv", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioSTP", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Firma", speiEnvioBean.getFirma());

									sentenciaStore.setString("Par_PIDTarea", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumIntentos", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_CausaDevol", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Comentario", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_UsuarioEnvio", Constantes.STRING_VACIO);

									sentenciaStore.setInt("Par_UsuarioAutoriza", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_UsuarioVerifica", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_NumAct", Enum_NumActualizacionSPEI.actualizaFirma);

									// Parametros de Salida
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									// Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SpeiEnvioDAO.actualizarFirmaEnvioSPEI");
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
						throw new Exception(Constantes.MSG_ERROR + " .SpeiEnvioDAO.actualizarFirmaEnvioSPEI");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de la Firma del SPEI " + e);
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
}