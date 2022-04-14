
package cliente.dao;

import herramientas.Constantes;
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

import cliente.bean.CliAplicaPROFUNBean;
import cliente.bean.ClienteBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import seguridad.servicio.SeguridadRecursosServicio;


public class CliAplicaPROFUNDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public CliAplicaPROFUNDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	// ------------------ Transacciones ------------------------------------------
	/* Alta del Cliente PROFUN*/
	public MensajeTransaccionBean altaCliAplicaPROFUN(final CliAplicaPROFUNBean cliAplicaPROFUN) {
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
									String query = "call CLIAPLICAPROFUNALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cliAplicaPROFUN.getClienteID()));
									sentenciaStore.setInt("Par_UsuarioReg",Utileria.convierteEntero(cliAplicaPROFUN.getUsuarioReg()));
									sentenciaStore.setString("Par_FechaRegistro",cliAplicaPROFUN.getFechaRegistro());
									sentenciaStore.setString("Par_Estatus",cliAplicaPROFUN.getEstatus());
									sentenciaStore.setString("Par_Comentario",cliAplicaPROFUN.getComentario());
									sentenciaStore.setString("Par_ActaDefuncion",cliAplicaPROFUN.getActaDefuncionProfun());
									sentenciaStore.setString("Par_FechaDefuncion",cliAplicaPROFUN.getFechaDefuncionProfun());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CliAplicaPROFUNDAO.altaCliAplicaPROFUN");
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
							throw new Exception(Constantes.MSG_ERROR + " .CliAplicaPROFUNDAO.altaCliAplicaPROFUN");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de la Solicitud PROFUN" + e);
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


	/* Autorizacion o Rechazo de la Solicitud */
	public MensajeTransaccionBean autorizaRechazaCliAplicaPROFUN(final CliAplicaPROFUNBean cliAplicaPROFUN, final int tipoTransaccion) {
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
									String query = "call CLIAPLICAPROFUNACT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?);";//parametros de auditoria
									cliAplicaPROFUN.setContrasenia(SeguridadRecursosServicio.encriptaPass(cliAplicaPROFUN.getUsuarioAuto(), cliAplicaPROFUN.getContrasenia()));//Encriptando la contraseña de quien autoriza la solicitud
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cliAplicaPROFUN.getClienteID()));
									sentenciaStore.setString("Par_UsuarioAuto",cliAplicaPROFUN.getUsuarioAuto());
									sentenciaStore.setString("Par_MotivoRechazo", cliAplicaPROFUN.getMotivoRechazo());
									sentenciaStore.setString("Par_Contrasenia",cliAplicaPROFUN.getContrasenia());
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(cliAplicaPROFUN.getMonto()));

									sentenciaStore.setInt("Par_NumAct",tipoTransaccion);
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CliAplicaPROFUNDAO.rechazaCliAplicaPROFUN");
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
							throw new Exception(Constantes.MSG_ERROR + " .CliAplicaPROFUNDAO.rechazaCliAplicaPROFUN");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en rechazar la Solicitud PROFUN" + e);
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


	//Consulta de Clientes que Aplican PROFUN
	public CliAplicaPROFUNBean consultaPrincipal(CliAplicaPROFUNBean cliAplicaPROFUN, int tipoConsulta){
		CliAplicaPROFUNBean cliAplicaPROFUNBean = null;
		try{
			String query = "call CLIAPLICAPROFUNCON(" +
				"?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(cliAplicaPROFUN.getClienteID()),
				  	tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CliAplicaPROFUNDAO.consulta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPLICAPROFUNCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CliAplicaPROFUNBean cliAplicaPROFUN = new CliAplicaPROFUNBean();
					cliAplicaPROFUN.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
					cliAplicaPROFUN.setMonto(resultSet.getString("Monto"));
					cliAplicaPROFUN.setComentario(resultSet.getString("Comentario"));
					cliAplicaPROFUN.setActaDefuncionProfun(resultSet.getString("ActaDefuncion"));
					cliAplicaPROFUN.setFechaDefuncionProfun(resultSet.getString("FechaDefuncion"));

					cliAplicaPROFUN.setUsuarioReg(resultSet.getString("UsuarioReg"));
					cliAplicaPROFUN.setFechaRegistro(resultSet.getString("FechaRegistro"));
					cliAplicaPROFUN.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					cliAplicaPROFUN.setUsuarioAuto(resultSet.getString("UsuarioAuto"));
					cliAplicaPROFUN.setUsuarioRechaza(resultSet.getString("UsuarioRechaza"));

					cliAplicaPROFUN.setFechaRechaza(resultSet.getString("FechaRechaza"));
					cliAplicaPROFUN.setMotivoRechazo(resultSet.getString("MotivoRechazo"));
					cliAplicaPROFUN.setAplicadoSocios(resultSet.getString("AplicadoSocios"));
					cliAplicaPROFUN.setEstatus(resultSet.getString("Estatus"));
					return cliAplicaPROFUN;
				}
			});
			cliAplicaPROFUNBean  = matches.size() > 0 ? (CliAplicaPROFUNBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Solicitudes de Clientes PROFUN", e);
		}
		return cliAplicaPROFUNBean;
	}


	// -- Lista de Clientes PROFUN --//
	public List listaPrincipal(CliAplicaPROFUNBean cliAplicaPROFUNBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call CLIAPLICAPROFUNLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	cliAplicaPROFUNBean.getNombreCompleto(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIAPLICAPROFUNLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CliAplicaPROFUNBean cliAplicaPROFUN = new CliAplicaPROFUNBean();
					cliAplicaPROFUN.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(1),ClienteBean.LONGITUD_ID));
					cliAplicaPROFUN.setNombreCompleto(resultSet.getString(2));
					return cliAplicaPROFUN;
				}
			});
			return matches;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
