package cliente.dao;

import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClientesPROFUNBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class ClientesPROFUNDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public ClientesPROFUNDAO() {
		super();
	}

	private final static String salidaPantalla = "S";

	// ------------------ Transacciones ------------------------------------------

	/* Alta del Cliente PROFUN*/
	public MensajeTransaccionBean altaClientesPROFUN(final ClientesPROFUNBean clientesPROFUN) {
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
									String query = "call CLIENTESPROFUNALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(clientesPROFUN.getClienteID()));
										sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(clientesPROFUN.getFechaRegistro()));
										sentenciaStore.setInt("Par_SucursalReg",Utileria.convierteEntero(clientesPROFUN.getSucursalReg()));
										sentenciaStore.setInt("Par_UsuarioReg",Utileria.convierteEntero(clientesPROFUN.getUsuarioReg()));
										sentenciaStore.setString("Par_Salida",salidaPantalla);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.altaClientesPROFUN");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.altaClientesPROFUN");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Cliente PROFUN" + e);
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
	}// fin de alta de clientes profun


	/* Actualización de datos en ClientePROFUN */
	public MensajeTransaccionBean actualizaClientesPROFUN(final ClientesPROFUNBean clientesPROFUN, final int tipoActualizacion) {
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
									String query = "call CLIENTESPROFUNACT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(clientesPROFUN.getClienteID()));
										sentenciaStore.setString("Par_FechaCancela",Utileria.convierteFecha(clientesPROFUN.getFechaCancela()));
										sentenciaStore.setInt("Par_UsuarioCan",Utileria.convierteEntero(clientesPROFUN.getUsuarioCan()));
										sentenciaStore.setInt("Par_SucursalCan",Utileria.convierteEntero(clientesPROFUN.getSucursalCan()));
										sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.actualizaClientesPROFUN");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}

										return mensajeTransaccion;
									}
								});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ClientesPROFUNDAO.actualizaClientesPROFUN");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la cancelacion de Cliente PROFUN" + e);
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
	}// fin de modificacion de clientes en profun


	//Consulta de Clientes PROFUN
	public ClientesPROFUNBean consultaPrincipal(ClientesPROFUNBean clientesPROFUN, int tipoConsulta){
		ClientesPROFUNBean clientesPROFUNBean = null;
		try{
			String query = "call CLIENTESPROFUNCON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(clientesPROFUN.getClienteID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ClientesPROFUNDAO.consultaPantallaRegistro",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESPROFUNCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClientesPROFUNBean clientesPROFUN = new ClientesPROFUNBean();
					clientesPROFUN.setClienteID(resultSet.getString("ClienteID"));
					clientesPROFUN.setFechaRegistro(resultSet.getString("FechaRegistro"));
					clientesPROFUN.setSucursalReg(resultSet.getString("SucursalReg"));
					clientesPROFUN.setSucursalCan(resultSet.getString("SucursalCan"));
					clientesPROFUN.setUsuarioReg(resultSet.getString("UsuarioReg"));

					clientesPROFUN.setUsuarioCan(resultSet.getString("UsuarioCan"));
					clientesPROFUN.setFechaCancela(resultSet.getString("FechaCancela"));
					clientesPROFUN.setEstatus(resultSet.getString("Estatus"));
					return clientesPROFUN;
				}
			});
			clientesPROFUNBean  = matches.size() > 0 ? (ClientesPROFUNBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Clientes PROFUN", e);
		}
		return clientesPROFUNBean;
	}


	//Consulta de Monto Adeudado PROFUN
	public ClientesPROFUNBean consultaMontoAdeudo(ClientesPROFUNBean clientesPROFUN, int tipoConsulta){
		ClientesPROFUNBean clientesPROFUNBean = null;
		try{
			String query = "call CLIENTESPROFUNCON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(clientesPROFUN.getClienteID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ClientesPROFUNDAO.consultaMontoAdeudo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESPROFUNCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClientesPROFUNBean clientesPROFUN = new ClientesPROFUNBean();
					clientesPROFUN.setClienteID(resultSet.getString("ClienteID"));
					clientesPROFUN.setMontoPendiente(resultSet.getString("MontoPendiente"));
					clientesPROFUN.setNumClientesProfun(resultSet.getString("NumClientesProfun"));

					return clientesPROFUN;
				}
			});
			clientesPROFUNBean  = matches.size() > 0 ? (ClientesPROFUNBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Monto Adeudado PROFUN", e);
		}
		return clientesPROFUNBean;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}

