package fira.dao;

import fira.bean.MinistracionCredAgroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.UsuarioServicio;

public class MinistraCredAgroDAO extends BaseDAO {

	private UsuarioDAO usuarioDAO = null;

	public MinistraCredAgroDAO() {
		super();
	}

	public static interface Enum_Act_Ministraciones {
		int desembolso	= 1;
		int cancelacion	= 2;
	};

	public static interface Enum_Alt_Ministraciones {
		String simulador	= "1";
		String solicitud	= "2";
		String credito		= "3";
	};

	/**
	 * Método para dar de Baja las ministraciones de Credito
	 * @param ministracionCredAgroBean : Bean con los datos para dar de baja las ministraciones
	 * @param numeroTransaccion
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean bajaMinistracion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MINISTRACREDAGROBAJ(" +
										"?,?,?,?,?,     " +
										"?,?,?,?,?,     " +
										"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteEntero(ministracionCredAgroBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ministracionCredAgroBean.getClienteID()));
								sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ministracionCredAgroBean.getProspectoID()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Baja de Ministracion: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Baja de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en Baja de Ministracion.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Método para dar de alta las ministraciones de credito.
	 * @param numeroTransaccion : Numero de Transaccion.
	 * @param ministracionCredAgroBean : Clase bean con los datos para dar de alta las ministraciones SP-MINISTRACREDAGROALT.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaMinistracion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MINISTRACREDAGROALT("
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,     "
										+ "?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_TransaccionID", numeroTransaccion);
								sentenciaStore.setInt("Par_Numero", Utileria.convierteEntero(ministracionCredAgroBean.getNumero()));
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteEntero(ministracionCredAgroBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ministracionCredAgroBean.getClienteID()));
								sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ministracionCredAgroBean.getProspectoID()));
								sentenciaStore.setString("Par_FechaPagoMinis", ministracionCredAgroBean.getFechaPagoMinis());
								sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(ministracionCredAgroBean.getCapital()));
								sentenciaStore.setInt("Par_NumAlta", Utileria.convierteEntero(ministracionCredAgroBean.getNumAlta()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Ministracion: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al dar de alta la Ministracion.");
			ex.printStackTrace();
		}
		return mensaje;
	}
	/**
	 * Método que actualiza los valores para las ministraciones.
	 * @param ministracionCredAgroBean : Clase bean con los valores de los parámetros de entrada al SP-MINISTRACREDAGROACT.
	 * @param numeroTransaccion : Número de transacción.
	 * @param numActualizacion : Número de Actualización.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizacion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion, final int numActualizacion) {
		MensajeTransaccionBean mensaje = null;
		if(numActualizacion==Enum_Act_Ministraciones.cancelacion){
			ministracionCredAgroBean.setTransaccionID(String.valueOf(transaccionDAO.generaNumeroTransaccionOut()));
		} else {
			ministracionCredAgroBean.setTransaccionID(String.valueOf(numeroTransaccion));
		}
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL MINISTRACREDAGROACT("
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,	  "
										+ "?,?,?,     "
										+ "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_TransaccionID", Utileria.convierteLong(ministracionCredAgroBean.getTransaccionID()));
								sentenciaStore.setInt("Par_Numero", Utileria.convierteEntero(ministracionCredAgroBean.getNumero()));
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(ministracionCredAgroBean.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ministracionCredAgroBean.getClienteID()));

								sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ministracionCredAgroBean.getProspectoID()));
								sentenciaStore.setString("Par_FechaPagoMinis", Utileria.convierteFecha(ministracionCredAgroBean.getFechaPagoMinis()));
								sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(ministracionCredAgroBean.getCapital()));
								sentenciaStore.setString("Par_FechaMinistracion", Utileria.convierteFecha(ministracionCredAgroBean.getFechaMinistracion()));
								sentenciaStore.setString("Par_Estatus", ministracionCredAgroBean.getEstatus());

								sentenciaStore.setString("Par_UsuarioAutoriza", ministracionCredAgroBean.getUsuarioAutoriza());
								sentenciaStore.setString("Par_FechaAutoriza", Utileria.convierteFecha(ministracionCredAgroBean.getFechaAutoriza()));
								sentenciaStore.setString("Par_ComentariosAutoriza", ministracionCredAgroBean.getComentariosAutoriza());
								sentenciaStore.setString("Par_ForPagComGarantia", ministracionCredAgroBean.getForPagComGarantia());
								sentenciaStore.setInt("Par_NumAct", numActualizacion);

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", Utileria.convierteLong(ministracionCredAgroBean.getTransaccionID()));
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Actualizacion en Calendario de Ministraciones: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Actualizacion en Calendario de Ministraciones: ", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en Actualizacion en Calendario de Ministraciones.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Método que realiza la cancelación de las ministraciones actualizando el saldo
	 * de acuerdo al tipo de cancelación.
	 * @param ministracionCredAgroBean : Clase bean con los valores a los parámetros de entrada al SP-MINISTRACANCELPRO.
	 * @param numeroTransaccion : Número de Transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean cancelacion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MINISTRACANCELPRO("
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,     "
										+ "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_Numero", Utileria.convierteEntero(ministracionCredAgroBean.getNumero()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de Ministracion: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Cancelar la Ministracion.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Método que realiza la actualización de los intereses de las amorizaciones y del pagaré
	 * por la cancelación de la ministración realizada.
	 * @param ministracionCredAgroBean : Clase bean con los valores a los parámetros de entrada al SP-MINISTRACANCELACT.
	 * @param numeroTransaccion : Número de Transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizaCancelacion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MINCREDCANCELACT("
										+ "?,?,?,?,?,     "
										+ "?,?,?,?,?,     "
										+ "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ministracionCredAgroBean.getCreditoID()));
								sentenciaStore.setInt("Par_Numero", Utileria.convierteEntero(ministracionCredAgroBean.getNumero()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de Ministracion: " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Cancelar la Ministracion.");
			ex.printStackTrace();
		}
		return mensaje;
	}
	/**
	 *
	 * Método que realiza la cancelación de las ministraciones actualizando el saldo a las amortizaciones
	 * de acuerdo al tipo de cancelación y actualiza el estatus de la ministración a cancelar.
	 * @param ministracionCredAgroBean : Clase bean con los valores de los parámetros de entrada a los SP's.
	 * @param numeroTransaccion : Número de Transacción.
	 * @param numActualizacion : Número para realizar la actualización del estatus de la ministración.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean cancelacionMinistracion(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion,
			final int numActualizacion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						/* Se realiza la actualización de los saldos de las amortizaciones
						 * de acuerdo al tipo de cancelación. */
						mensajeBean = cancelacion(ministracionCredAgroBean, numeroTransaccion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						// Se actualiza el estatus de la ministración cancelada.
						mensajeBean = actualizaAgro(ministracionCredAgroBean, numeroTransaccion, numActualizacion, true);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						// Se actualizan los intereses y el pagaré.
						mensajeBean = actualizaCancelacion(ministracionCredAgroBean, numeroTransaccion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de Ministracion", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception e) {
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al Cancelar la Ministracion de Créditos Agro.");
			loggerSAFI.error(mensaje.getDescripcion(), e);
		}
		return mensaje;
	}

	/**
	 * Método que actualiza los valores para las ministraciones y valida el usuario en caso de requerir validación.
	 * @param ministracionCredAgroBean : Clase bean con los valores de los parámetros de entrada al SP-MINISTRACREDAGROACT.
	 * @param numeroTransaccion : Número de transacción.
	 * @param numActualizacion : Número de Actualización.
	 * @param validaUsuario : Indica si se realiza la validación del Usuario y Contraseña que autoriza la operación.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizaAgro(final MinistracionCredAgroBean ministracionCredAgroBean, final long numeroTransaccion,
			final int numActualizacion, boolean validaUsuario) {
		MensajeTransaccionBean mensaje = null;

		if(validaUsuario){
			mensaje = new MensajeTransaccionBean();
			UsuarioBean usuarioBean = new UsuarioBean();
			usuarioBean.setClave(ministracionCredAgroBean.getUsuarioAutoriza());
			if(usuarioBean.getClave().equalsIgnoreCase("")){
				mensaje.setNumero(4);
				mensaje.setDescripcion("El Usuario de Autorizacion se encuentra vacio.");
				mensaje.setNombreControl("usuarioAutoriza");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
			usuarioBean = usuarioDAO.consultaXClave(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
			// Se genera una contraseña con la clave del usuario y de la contraseña que se reciben desde pantalla.
			String passEnvio = SeguridadRecursosServicio.encriptaPass(ministracionCredAgroBean.getUsuarioAutoriza(), ministracionCredAgroBean.getContraseniaAutoriza());
			ministracionCredAgroBean.setUsuarioAutoriza(usuarioBean.getUsuarioID());
			if (!usuarioBean.getContrasenia().equals(passEnvio)) {
				mensaje.setNumero(5);
				mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado.");
				mensaje.setNombreControl("contraseniaAutoriza");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
		} else {
			ministracionCredAgroBean.setUsuarioAutoriza(null);
		}

		mensaje = actualizacion(ministracionCredAgroBean, numeroTransaccion, numActualizacion);

		return mensaje;
	}
	/**
	 * Alta de Detalle de las Ministraciones
	 * Nota: El número de transaccion se envia desde el alta del crédito o al realizar la simulacion del crédito.
	 * @param ministracionCredAgroBean : Bean con la Informacion para dar de alta las ministraciones de credito
	 * @param listaDetalle : Array<MinistracionCredAgroBean> con la lista de ministraciones a grabar
	 * @return
	 */
	public MensajeTransaccionBean grabaDetalle(final MinistracionCredAgroBean ministracionCredAgroBean, final String detalles, final long numeroTransaccion) {
		MensajeTransaccionBean mensajeTransaccion = null;
		if (numeroTransaccion >= Constantes.ENTERO_CERO) {
			mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						String tipoAlta = Enum_Alt_Ministraciones.simulador;
						if( Utileria.convierteLong(ministracionCredAgroBean.getSolicitudCreditoID())>0 &&
							Utileria.convierteLong(ministracionCredAgroBean.getCreditoID())==0){
							tipoAlta = Enum_Alt_Ministraciones.solicitud;
						} else if(Utileria.convierteLong(ministracionCredAgroBean.getCreditoID())>0){
							tipoAlta = Enum_Alt_Ministraciones.credito;
						}
						List<MinistracionCredAgroBean> listaDetalle = creaListaDetalle(detalles, ministracionCredAgroBean, tipoAlta);
						mensajeBean = bajaMinistracion(ministracionCredAgroBean, numeroTransaccion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						if (listaDetalle.size() > 0) {
							for (MinistracionCredAgroBean detalle : listaDetalle) {
								mensajeBean = altaMinistracion(detalle, numeroTransaccion);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Solicitud necesita Minimo de 1 Ministración.");
							throw new Exception(mensajeBean.getDescripcion());
						}
						return mensajeBean;
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						mensajeBean.setNombreControl("grabar");
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en grabar Ministracion: ", e);
						return mensajeBean;
					}
				}
			});
		} else {
			mensajeTransaccion = new MensajeTransaccionBean();
			mensajeTransaccion.setNumero(999);
			mensajeTransaccion.setDescripcion("El Número de transacción esta Vacío.");
		}
		return mensajeTransaccion;
	}

	/**
	 * Método para crear la lista de las ministraciones
	 * @param detalles : String con los detalles
	 * @param ministracionCredAgroBean : SolicitudCreditoBean
	 * @param tipoAlta
	 * @return
	 */
	private List<MinistracionCredAgroBean> creaListaDetalle(String detalles, MinistracionCredAgroBean ministracionCredAgroBean, String tipoAlta) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<MinistracionCredAgroBean> listaDetalle = new ArrayList<MinistracionCredAgroBean>();
		MinistracionCredAgroBean detalle;
		try {
			while (tokensBean.hasMoreTokens()) {
				detalle = new MinistracionCredAgroBean();
				stringCampos = tokensBean.nextToken();

				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				detalle.setNumero(tokensCampos[0]);
				detalle.setClienteID(ministracionCredAgroBean.getClienteID());
				detalle.setProspectoID(ministracionCredAgroBean.getProspectoID());
				detalle.setSolicitudCreditoID(ministracionCredAgroBean.getSolicitudCreditoID());
				detalle.setCreditoID(ministracionCredAgroBean.getCreditoID());
				detalle.setFechaPagoMinis(tokensCampos[1]);
				detalle.setCapital(tokensCampos[2]);
				detalle.setNumAlta(tipoAlta);

				listaDetalle.add(detalle);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public List<MinistracionCredAgroBean> lista(int tipoLista, MinistracionCredAgroBean ministracionCredAgroBean) {
		List<MinistracionCredAgroBean> lista=null;
		String query = "CALL MINISTRACREDAGROLIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?,?);";
		Object[] parametros = {
				tipoLista,
				ministracionCredAgroBean.getTransaccionID(),
				ministracionCredAgroBean.getSolicitudCreditoID(),
				ministracionCredAgroBean.getCreditoID(),
				ministracionCredAgroBean.getClienteID(),

				ministracionCredAgroBean.getProspectoID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"MinistraCredAgroDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call MINISTRACREDAGROLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<MinistracionCredAgroBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MinistracionCredAgroBean ministra = new MinistracionCredAgroBean();
					ministra.setNumero(resultSet.getString("Numero"));
					ministra.setTransaccionID(resultSet.getString("TransaccionID"));
					ministra.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					ministra.setCreditoID(resultSet.getString("CreditoID"));
					ministra.setClienteID(resultSet.getString("ClienteID"));
					ministra.setProspectoID(resultSet.getString("ProspectoID"));
					ministra.setFechaPagoMinis(resultSet.getString("FechaPagoMinis"));
					ministra.setCapital(resultSet.getString("Capital"));
					ministra.setDiferencia(resultSet.getString("Diferencia"));
					ministra.setTotal(resultSet.getString("Total"));
					return ministra;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en MinistraCredAgroDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Lista el calendario de ministraciones para realizar los desembolsos de acuerdo al calendario del crédito.
	 * Usada en la pantalla de Desembolso de Crédito del módulo Creditos Agro.
	 * @param tipoLista : Número de Lista 2.
	 * @param ministracionCredAgroBean : Clase bean con el valor del CreditoID.
	 * @return Lista del calendario de ministraciones.
	 * @author avelasco
	 */
	public List<MinistracionCredAgroBean> listaDesembolso(int tipoLista, MinistracionCredAgroBean ministracionCredAgroBean) {
		List<MinistracionCredAgroBean> lista=null;
		String query = "CALL MINISTRACREDAGROLIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?,?);";
		Object[] parametros = {
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				ministracionCredAgroBean.getCreditoID(),
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"MinistraCredAgroDAO.listaDesembolso",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call MINISTRACREDAGROLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<MinistracionCredAgroBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MinistracionCredAgroBean ministra = new MinistracionCredAgroBean();
					ministra.setNumero(resultSet.getString("Numero"));
					ministra.setFechaPagoMinis(resultSet.getString("FechaPagoMinis"));
					ministra.setCapital(resultSet.getString("Capital"));
					ministra.setEstatus(resultSet.getString("Estatus"));
					ministra.setFechaMinistracion(resultSet.getString("FechaMinistracion"));
					ministra.setSeleccionado(resultSet.getString("Seleccionado"));
					ministra.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
					ministra.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
					return ministra;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en MinistraCredAgroDAO.listaDesembolso: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Alta de Detalle de las Ministraciones Renovacion
	 * Nota: El número de transaccion se envia desde el alta del crédito o al realizar la simulacion del crédito.
	 * @param ministracionCredAgroBean : Bean con la Informacion para dar de alta las ministraciones de credito
	 * @param listaDetalle : Array<MinistracionCredAgroBean> con la lista de ministraciones a grabar
	 * @return
	 */
	public MensajeTransaccionBean grabaDetalleRenovacion(final MinistracionCredAgroBean ministracionCredAgroBean, final String detalles, final long numeroTransaccion) {
		MensajeTransaccionBean mensajeTransaccion = null;
		if (numeroTransaccion >= Constantes.ENTERO_CERO) {
			mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						String tipoAlta = Enum_Alt_Ministraciones.simulador;
						if(Utileria.convierteEntero(ministracionCredAgroBean.getSolicitudCreditoID())>0 &&
								Utileria.convierteEntero(ministracionCredAgroBean.getCreditoID())==0){
							tipoAlta = Enum_Alt_Ministraciones.solicitud;
						} else if(Utileria.convierteEntero(ministracionCredAgroBean.getCreditoID())>0){
							tipoAlta = Enum_Alt_Ministraciones.credito;
						}
						List<MinistracionCredAgroBean> listaDetalle = creaListaDetalle(detalles, ministracionCredAgroBean, tipoAlta);
						mensajeBean = bajaMinistracion(ministracionCredAgroBean, numeroTransaccion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						if (listaDetalle.size() > 0) {
							for (MinistracionCredAgroBean detalle : listaDetalle) {
								mensajeBean = altaMinistracion(detalle, numeroTransaccion);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Solicitud necesita Minimo de 1 Ministración.");
							throw new Exception(mensajeBean.getDescripcion());
						}
						return mensajeBean;
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						mensajeBean.setNombreControl("grabar");
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en grabar Ministracion: ", e);
						return mensajeBean;
					}
				}
			});
		} else {
			mensajeTransaccion = new MensajeTransaccionBean();
			mensajeTransaccion.setNumero(999);
			mensajeTransaccion.setDescripcion("El Número de transacción esta Vacío.");
		}
		return mensajeTransaccion;
	}



	public long numTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

}