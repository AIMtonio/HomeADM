
package credito.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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

import credito.bean.CreditosBean;
import credito.bean.ServiciosSolCredBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import originacion.bean.SolicitudCreditoBean;

public class ServiciosSolCredDAO extends BaseDAO {

	private static final String SALIDA_PANTALLA = "S";
	private static final String SP_SERVICIOSXSOLCREDLIS = "SERVICIOSXSOLCREDLIS";
	protected static final int ERROR_TRANSACCION = 999;
	private ParametrosSesionBean parametrosSesionBean = null;

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	@SuppressWarnings("unchecked")
	public List listaServicioSolicitudCredito(int tipoLista, ServiciosSolCredBean serviciosSolCredBean) {

		try {
			String query = "call " + SP_SERVICIOSXSOLCREDLIS + "(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(serviciosSolCredBean.getServicioSolID()),
					Utileria.convierteEntero(serviciosSolCredBean.getServicioID()),
					Utileria.convierteEntero(serviciosSolCredBean.getSolicitudCreditoID()),
					Utileria.convierteLong(serviciosSolCredBean.getCreditoID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call " + SP_SERVICIOSXSOLCREDLIS + "(" + Arrays.toString(parametros) + ")");
			return ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ServiciosSolCredBean serviciosSolCredBean = new ServiciosSolCredBean();
					serviciosSolCredBean.setServicioSolID(resultSet.getString("ServicioSolID"));
					serviciosSolCredBean.setServicioID(resultSet.getString("ServicioID"));
					serviciosSolCredBean.setDescripcion(resultSet.getString("Descripcion"));
					serviciosSolCredBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					serviciosSolCredBean.setCreditoID(resultSet.getString("CreditoID"));
					return serviciosSolCredBean;
				}
			});
		} catch (Exception e) {
			loggerSAFI.error("Error al obtener la lista de servicios adicionales ligados a la Solicitud de crédito/Crédito", e);
			e.printStackTrace();
		}

		return new ArrayList();
	}

	public MensajeTransaccionBean altaServiciosAdicionales(final ServiciosSolCredBean serviciosSolCredBean) {
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

									String query = "call SERVICIOSXSOLCREDALT(" +
										"?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ServicioID",Utileria.convierteEntero(serviciosSolCredBean.getServicioID()));
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(serviciosSolCredBean.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(serviciosSolCredBean.getCreditoID()));

									sentenciaStore.setString("Par_Salida", SALIDA_PANTALLA);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);


									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ServiciosAdicionalesDAO.altaServiciosAdicionales");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .ServiciosAdicionalesDAO.altaServiciosAdicionales");
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de alta los servicios adicionales" + e);
						e.printStackTrace();
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(ERROR_TRANSACCION);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	public MensajeTransaccionBean bajaServiciosAdicionales(final ServiciosSolCredBean serviciosSolCredBean) {
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

									String query = "call SERVICIOSXSOLCREDBAJ(" +
										"?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ServicioID",Utileria.convierteEntero(serviciosSolCredBean.getServicioID()));
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(serviciosSolCredBean.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(serviciosSolCredBean.getCreditoID()));

									sentenciaStore.setString("Par_Salida", SALIDA_PANTALLA);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ServiciosAdicionalesDAO.bajaServiciosAdicionales");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de baja los servicios adicionales" + e);
						e.printStackTrace();
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(ERROR_TRANSACCION);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}

	public MensajeTransaccionBean altaListaServiciosAdicionales(final SolicitudCreditoBean solicitudCredito,
			final List listaAltaServiciosAdicionales) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ServiciosSolCredBean serviciosSolCredBean = null;
					if (solicitudCredito.getSolicitudCreditoID() != null) {
						serviciosSolCredBean = new ServiciosSolCredBean();
						serviciosSolCredBean.setSolicitudCreditoID(solicitudCredito.getSolicitudCreditoID());
						mensajeBean = bajaServiciosAdicionales(serviciosSolCredBean);
					}
					if(mensajeBean.getNumero() == ERROR_TRANSACCION){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for (Object object : listaAltaServiciosAdicionales) {
						serviciosSolCredBean = (ServiciosSolCredBean) object;
						mensajeBean = altaServiciosAdicionales(serviciosSolCredBean);
						if(mensajeBean.getNumero() == ERROR_TRANSACCION){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Servicios adicionales agregados");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta lista de servicios adicionales ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaListaServiciosAdicionales(final CreditosBean creditoBean,
			final List listaAltaServiciosAdicionales) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ServiciosSolCredBean serviciosSolCredBean = null;
					if (creditoBean.getSolicitudCreditoID() != null) {
						serviciosSolCredBean = new ServiciosSolCredBean();
						serviciosSolCredBean.setSolicitudCreditoID(creditoBean.getSolicitudCreditoID());
						serviciosSolCredBean.setCreditoID(creditoBean.getCreditoID());
						mensajeBean = bajaServiciosAdicionales(serviciosSolCredBean);
					}
					if(mensajeBean.getNumero() == ERROR_TRANSACCION){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for (Object object : listaAltaServiciosAdicionales) {
						serviciosSolCredBean = (ServiciosSolCredBean) object;
						mensajeBean = altaServiciosAdicionales(serviciosSolCredBean);
						if(mensajeBean.getNumero() == ERROR_TRANSACCION){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Servicios adicionales agregados");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta lista de servicios adicionales ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
