package cuentas.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.BitacoraHuellaBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.BitacoraHuellaServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import tesoreria.bean.BloqueoBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.IngresosOperacionesDAO;
import cuentas.bean.BloqueoSaldoBean;

public class BloqueoSaldoDAO  extends BaseDAO {
	IngresosOperacionesDAO ingresosOperacionesDAO = null;
	UsuarioServicio usuarioServicio = null;
	BitacoraHuellaServicio bitacoraHuellaServicio = null;
	public BloqueoSaldoDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	private final static String salidaPantalla = "S";

public List tiposBloqueo (int tipoLista,BloqueoBean bloqueoBean){

		String query = "call TIPOSBLOQUEOSCON (?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {
				Utileria.convierteEntero(bloqueoBean.getTiposBloqID()),
			    tipoLista,

			    Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSBLOQUEOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				BloqueoBean bloqueoBean = new BloqueoBean();
				bloqueoBean.setTiposBloqID(resultSet.getString("TiposBloqID"));
				bloqueoBean.setDescripcion(resultSet.getString("Descripcion"));

				return bloqueoBean;
			}

		});



		return matches;

	}//...........................

public MensajeTransaccionBean bloqueosPro(final BloqueoSaldoBean bloqueoSaldoBean){
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

	loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Bloqueos Pro 1 transaccion generada aqui : " + parametrosAuditoriaBean.getNumeroTransaccion());

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BLOQUEOSPRO(?,?,?,?,?, ?,?,?,?,? ,?,?, ?,?, ?,?,?,?,?, ?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_BloqueoID" ,  (bloqueoSaldoBean.getBloqueoID() != null) ? bloqueoSaldoBean.getBloqueoID() : Constantes.STRING_CERO );
							sentenciaStore.setString("Par_NatMovimiento" ,  bloqueoSaldoBean.getNatMovimiento());
							sentenciaStore.setLong("Par_CuentaAhoID" ,  Utileria.convierteLong(bloqueoSaldoBean.getCuentaAhoID()));
							sentenciaStore.setString("Par_FechaMov" ,  bloqueoSaldoBean.getFechaMov());
							sentenciaStore.setDouble("Par_MontoBloq" ,  Utileria.convierteDoble(bloqueoSaldoBean.getMontoBloq()));

							sentenciaStore.setString("Par_FechaDesbloq" ,  Constantes.FECHA_VACIA);
							sentenciaStore.setInt("Par_TiposBloqID" ,  Utileria.convierteEntero(bloqueoSaldoBean.getTiposBloqID()));
							sentenciaStore.setString("Par_Descripcion" ,  bloqueoSaldoBean.getDescripcion());
							sentenciaStore.setLong("Par_Referencia" ,  Utileria.convierteLong(bloqueoSaldoBean.getReferencia()));
							sentenciaStore.setString("Par_UsuarioClave" ,  (bloqueoSaldoBean.getClaveUsuAuto() != null) ? bloqueoSaldoBean.getClaveUsuAuto() : Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_ContraseniaAut" ,  (bloqueoSaldoBean.getContraseniaUsu() != null) ? bloqueoSaldoBean.getContraseniaUsu() : Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_Salida",salidaPantalla);
							//Parametros de OutPut
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Bloqueos Pro -> " + e);
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
	 * Método para realizar el proceso de Bloqueo del Saldo de la Cuenta
	 * @param bloqueoSaldoBean : Bean BloqueoSaldoBean con la Información de la Cuenta
	 * @param numTransaccion : Número de Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean bloqueosPro(final BloqueoSaldoBean bloqueoSaldoBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BLOQUEOSPRO(?,?,?,?,?, ?,?,?,?,? ,?,?, ?,?, ?,?,?,?,?, ?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_BloqueoID", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_NatMovimiento", bloqueoSaldoBean.getNatMovimiento());
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(bloqueoSaldoBean.getCuentaAhoID()));
							sentenciaStore.setString("Par_FechaMov", bloqueoSaldoBean.getFechaMov());
							sentenciaStore.setDouble("Par_MontoBloq", Utileria.convierteDoble(bloqueoSaldoBean.getMontoBloq()));

							sentenciaStore.setString("Par_FechaDesbloq", Constantes.FECHA_VACIA);
							sentenciaStore.setInt("Par_TiposBloqID", Utileria.convierteEntero(bloqueoSaldoBean.getTiposBloqID()));
							sentenciaStore.setString("Par_Descripcion", bloqueoSaldoBean.getDescripcion());
							sentenciaStore.setLong("Par_Referencia", Utileria.convierteLong(bloqueoSaldoBean.getReferencia()));
							sentenciaStore.setString("Par_UsuarioClave", (bloqueoSaldoBean.getClaveUsuAuto() != null) ? bloqueoSaldoBean.getClaveUsuAuto() : Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_ContraseniaAut", (bloqueoSaldoBean.getContraseniaUsu() != null) ? bloqueoSaldoBean.getContraseniaUsu() : Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Bloqueos Pro" + e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Bloqueos Pro" + e);
					}
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
	 * Desbloqueo del Saldo en la reversa de Abono a cuenta por tipo de cuenta eb ventanilla
	 * @param bloqueoSaldoBean : Bean con la Informacion de la Cuenta
	 * @param numTransaccion : Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean desbloqueoAutomaticoPro(final BloqueoSaldoBean bloqueoSaldoBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BLOQUEOSPRO(?,?,?,?,?, ?,?,?,?,? ,?,?, ?,?, ?,?,?,?,?, ?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_BloqueoID", Utileria.convierteEntero(bloqueoSaldoBean.getBloqueoID()));
							sentenciaStore.setString("Par_NatMovimiento", bloqueoSaldoBean.getNatMovimiento());
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(bloqueoSaldoBean.getCuentaAhoID()));
							sentenciaStore.setString("Par_FechaMov", bloqueoSaldoBean.getFechaMov());
							sentenciaStore.setDouble("Par_MontoBloq", Utileria.convierteDoble(bloqueoSaldoBean.getMontoBloq()));

							sentenciaStore.setString("Par_FechaDesbloq", bloqueoSaldoBean.getFecha());
							sentenciaStore.setInt("Par_TiposBloqID", Utileria.convierteEntero(bloqueoSaldoBean.getTiposBloqID()));
							sentenciaStore.setString("Par_Descripcion", bloqueoSaldoBean.getDescripcion());
							sentenciaStore.setLong("Par_Referencia", Utileria.convierteLong(bloqueoSaldoBean.getReferencia()));
							sentenciaStore.setString("Par_UsuarioClave", (bloqueoSaldoBean.getClaveUsuAuto() != null) ? bloqueoSaldoBean.getClaveUsuAuto() : Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_ContraseniaAut", (bloqueoSaldoBean.getContraseniaUsu() != null) ? bloqueoSaldoBean.getContraseniaUsu() : Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .BloqueoSaldoDAO.bloqueosPro");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Bloqueos Pro" + e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Bloqueos Pro" + e);
					}
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

	public BloqueoSaldoBean consultaDesDevGarLiquida(final BloqueoSaldoBean bloqueoSaldoBean, int tipoConsulta) {
		BloqueoSaldoBean bloqueo = null;

		try{
			String query = "call BLOQUEOSCON(?,?,?,?,?, ?,?,?,?,?,   ?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									bloqueoSaldoBean.getReferencia(),
									bloqueoSaldoBean.getCuentaAhoID(),


									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaTransaccionCajaMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BloqueoSaldoBean bloqueoSaldo = new BloqueoSaldoBean();
					bloqueoSaldo.setBloqueoID(resultSet.getString("BloqueoID"));
					bloqueoSaldo.setMontoBloq(resultSet.getString("MontoBloq"));


					return bloqueoSaldo;
				}
			});
			bloqueo= matches.size() > 0 ? (BloqueoSaldoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta  de Bloqueos Devolucion de GL", e);
		}
		return bloqueo;
	}

	/**
	 * Consulta si Aplica un Bloqueo Automatico de Saldo, en los Depositos Realizados Pueden Existir Tipos de Cuenta que Indican que se Bloque el Saldo con Cada Deposito
	 * @param bloqueoSaldoBean : Bean BloqueoSaldoBean con la informacion de la Cuenta a Bloquear
	 * @param tipoConsulta : Tipo de Consulta
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return String
	 */
	public String consultaAplicaBloqueoAutomatico(final BloqueoSaldoBean bloqueoSaldoBean, int tipoConsulta, boolean origenVentanilla) {
		String bloquearSaldo = null;

		try {
			String query = "call BLOQUEOSCON(?,?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					bloqueoSaldoBean.getCuentaAhoID(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"bloqueoSaldoDAO",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };

			if (origenVentanilla) {
				loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call BLOQUEOSCON(" + Arrays.toString(parametros) + ")");
			} else {
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call BLOQUEOSCON(" + Arrays.toString(parametros) + ")");
			}
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					String bloqueoSaldo = new String();
					bloqueoSaldo = resultSet.getString("BloquearSaldo");
					return bloqueoSaldo;
				}
			});
			bloquearSaldo = matches.size() > 0 ? (String) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			if (origenVentanilla) {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Consulta de Bloqueo", e);
			} else {
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Consulta de Bloqueo", e);
			}
		}
		return bloquearSaldo;
	}


	public MensajeTransaccionBean grabaListaDetalleSaldo(final  BloqueoSaldoBean bloqueoSaldoBean, final List listaDetalleSaldo) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					UsuarioBean usuarioBean = new UsuarioBean();
					MensajeTransaccionBean mensaje = null;
					BloqueoSaldoBean bloSaldoBean = null;
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
					BitacoraHuellaBean bitacoraHuellaBean = new BitacoraHuellaBean();
					String passValidaUser = null;
					String presentedPassword = bloqueoSaldoBean.getContraseniaUsu();
					for(int i=0; i<listaDetalleSaldo.size(); i++){
						String hdPass = presentedPassword;
						bloSaldoBean = (BloqueoSaldoBean)listaDetalleSaldo.get(i);
						/* -- -----------------------------------------------------------------
						 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
						 * -- -----------------------------------------------------------------
						 */
						usuarioBean.setClave(bloqueoSaldoBean.getClaveUsuAuto());
						usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
						if(usuarioBean == null){
							mensaje = new MensajeTransaccionBean();
				    		mensaje.setNumero(404);
				    		mensaje.setDescripcion("Usuario Invalido");

				    		return mensaje;
						}
						bloqueoSaldoBean.setClaveUsuAuto(usuarioBean.getClave());

				        if(hdPass.contains("HD>>")){
				        	hdPass = hdPass.replace("HD>>", "");
				        	bloqueoSaldoBean.setContraseniaUsu(SeguridadRecursosServicio.encriptaPass(bloqueoSaldoBean.getClaveUsuAuto(), hdPass));
				        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(bloqueoSaldoBean.getClaveUsuAuto());
				        	if(bloqueoSaldoBean.getContraseniaUsu().equals(passValidaUser)){
				        		bloSaldoBean.setContraseniaUsu(usuarioBean.getContrasenia());
				        		bloSaldoBean.setClaveUsuAuto(bloqueoSaldoBean.getClaveUsuAuto());
				        		mensaje = bloqueosProceso(bloSaldoBean,ingresosOperacionesBean);
				        		if(mensaje.getNumero()!=0){
									throw new Exception(mensaje.getDescripcion());
								}

				        		Date date = new Date();
				        		DateFormat fecha = new SimpleDateFormat("yyyy-MM-dd");
				        		String convertido = fecha.format(date);
				        		bitacoraHuellaBean.setClienteUsuario(usuarioBean.getUsuarioID());
				        		bitacoraHuellaBean.setNumeroTransaccion(mensaje.getConsecutivoString());
				        		bitacoraHuellaBean.setTipoOperacion("102");
				        		bitacoraHuellaBean.setTipo("U");
				        		bitacoraHuellaBean.setDescriOperacion("DESBLOQUEO SALDO");
				        		bitacoraHuellaBean.setSucursalCteUsr(bloqueoSaldoBean.getSucursalID());
				        		bitacoraHuellaBean.setCaja(bloqueoSaldoBean.getCajaID());
				        		bitacoraHuellaBean.setFecha(convertido);
				        		bitacoraHuellaServicio.grabaTransaccion(1, bitacoraHuellaBean);
				        	}else{
				        		mensaje = new MensajeTransaccionBean();
				        		mensaje.setNumero(405);
				        		mensaje.setDescripcion("Token Huella Invalida");
				        	}

				        }else{
				        	bloSaldoBean.setClaveUsuAuto(bloqueoSaldoBean.getClaveUsuAuto());
							bloSaldoBean.setContraseniaUsu(SeguridadRecursosServicio.encriptaPass(bloqueoSaldoBean.getClaveUsuAuto(), bloqueoSaldoBean.getContraseniaUsu()));
							mensaje = bloqueosProceso(bloSaldoBean,ingresosOperacionesBean);
							if(mensaje.getNumero()!=0){
								throw new Exception(mensaje.getDescripcion());
							}

				        }
						if(mensajeBean.getNumero()!=0){
							return mensaje;
						}

					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
					mensajeBean.setNombreControl("solicitudCreditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en graba lista de garantias por solicitud", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	//	metodo para realizar el Bloqueo de saldo
	public MensajeTransaccionBean bloqueosProceso(final BloqueoSaldoBean bloqueoSaldoBean,final IngresosOperacionesBean ingresosOperacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			    String Cero="1";
			    String Bloqueo="B";
			    String Desbloqueo="D";
			    int tipoBloqFOGAFI = 20;
				try {
					mensajeBean = bloqueosPro(bloqueoSaldoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					if((bloqueoSaldoBean.getNatMovimiento()).equals(Bloqueo)){
						ingresosOperacionesBean.setFecha(bloqueoSaldoBean.getFechaMov());
						ingresosOperacionesBean.setClienteID(bloqueoSaldoBean.getClienteID());
						ingresosOperacionesBean.setCuentaAhoID(bloqueoSaldoBean.getCuentaAhoID());
						ingresosOperacionesBean.setMonedaID(Cero);
						ingresosOperacionesBean.setCantidadMov(bloqueoSaldoBean.getMontoBloq());
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi); //indicamos que si tenga encabezado de los datalles en la poliza

						if(Integer.parseInt(bloqueoSaldoBean.getTiposBloqID()) == tipoBloqFOGAFI){
							ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepBloqGarFOGAFI);//concepto para el bloqueo de saldo cuando se trata de un deposito de GL
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.BloqueoManualSaldoFOGAFI);
						}
						else{
							ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepBloqGarLiq);//concepto para el bloqueo de saldo cuando se trata de un deposito de GL
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.BloqueoManualSaldo);
						}

						ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDeposito);		//Indicamos que se trata de un Bloqueo
						ingresosOperacionesBean.setTipoBloq(bloqueoSaldoBean.getTiposBloqID());

					}else{
						ingresosOperacionesBean.setFecha(bloqueoSaldoBean.getFechaMov());
						ingresosOperacionesBean.setClienteID(bloqueoSaldoBean.getClienteID());
						ingresosOperacionesBean.setCuentaAhoID(bloqueoSaldoBean.getCuentaAhoID());
						ingresosOperacionesBean.setMonedaID(Cero);
						ingresosOperacionesBean.setCantidadMov(bloqueoSaldoBean.getMontoBloq());
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);   //indicamos que si tenga encabezado de los datalles en la poliza
						ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepDevolucionGL);//concepto para desbloquear el monto de un deposito de GL
						ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDevolucion);        //Indicamos que es Desbloqueo
						ingresosOperacionesBean.setTipoBloq(bloqueoSaldoBean.getTiposBloqID());
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.DesBloqueoManualSaldo);
					}

					mensajeBean = ingresosOperacionesDAO.agregaDetallesGL(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(), false);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
					mensajeBean.setNombreControl("numeroTransaccion");
					mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Proceso Bloqueo Manual de Saldo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//---------------------------REPORTES --------------------------------------------------
	public List listaReporteBloqueoSaldos(final BloqueoSaldoBean bloqueoSaldoBean, int tipoLista){
		List ListaResultado=null;

		try{
		String query = "call BLOQUEOSREP(?,?,?,?,?,  ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bloqueoSaldoBean.getSucursalID()),
							Utileria.convierteEntero(bloqueoSaldoBean.getClienteID()),
							Utileria.convierteLong(bloqueoSaldoBean.getCuentaAhoID()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BloqueoSaldoBean bloqueoSaldoBean= new BloqueoSaldoBean();

				bloqueoSaldoBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),11));
				bloqueoSaldoBean.setDescripcion(resultSet.getString("Etiqueta"));
				bloqueoSaldoBean.setMotivoBloqueo(resultSet.getString("Motivo"));
				bloqueoSaldoBean.setDescripcionBloq(resultSet.getString("Descripcion"));
				bloqueoSaldoBean.setReferencia(resultSet.getString("Referencia"));
				bloqueoSaldoBean.setMontoBloq(resultSet.getString("MontoBloq"));
				bloqueoSaldoBean.setFecha(Utileria.convierteFecha(resultSet.getString("FechaMov")));
				bloqueoSaldoBean.setUsuarioIDAuto(Utileria.completaCerosIzquierda(resultSet.getString("UsuarioID"),2));
				bloqueoSaldoBean.setNombreUsuario(resultSet.getString("NombreCompleto"));
				bloqueoSaldoBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),10));
				bloqueoSaldoBean.setNombreCliente(resultSet.getString("NombreCliente"));

				bloqueoSaldoBean.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getString("SucursalID"),3));
				bloqueoSaldoBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
				bloqueoSaldoBean.setNatMovimiento(resultSet.getString("NatMovimiento"));
				bloqueoSaldoBean.setFechaDesbloq(resultSet.getString("FechaDesbloq"));
				return bloqueoSaldoBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Bloqueo de Saldos", e);
		}
		return ListaResultado;
	}

	public IngresosOperacionesDAO getIngresosOperacionesDAO() {
		return ingresosOperacionesDAO;
	}

	public void setIngresosOperacionesDAO(
			IngresosOperacionesDAO ingresosOperacionesDAO) {
		this.ingresosOperacionesDAO = ingresosOperacionesDAO;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public BitacoraHuellaServicio getBitacoraHuellaServicio() {
		return bitacoraHuellaServicio;
	}

	public void setBitacoraHuellaServicio(
			BitacoraHuellaServicio bitacoraHuellaServicio) {
		this.bitacoraHuellaServicio = bitacoraHuellaServicio;
	}


}