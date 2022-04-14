package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
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

import cliente.bean.RelacionEmpleadoClienteBean;


public class RelacionEmpleadoClienteDAO extends BaseDAO {

	public RelacionEmpleadoClienteDAO(){
		super();
	}

	public MensajeTransaccionBean grabaListaRelaciones(final RelacionEmpleadoClienteBean relacionClienteBean, final List listaRelacionesCli) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionBean mensajePersona = null;
				try {
					RelacionEmpleadoClienteBean relacionCli;
					mensajeBean = bajaRelacionCliente(relacionClienteBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajePersona = altaRelacionEmpresa(relacionClienteBean);

					if(mensajePersona.getNumero() == 0 || mensajePersona.getNumero() == 000){
						for(int i=0; i<listaRelacionesCli.size(); i++){
							relacionCli = (RelacionEmpleadoClienteBean)listaRelacionesCli.get(i);
							relacionCli.setEmpleadoID(mensajePersona.getConsecutivoString());

							mensajeBean = altaRelacionClientes(relacionCli);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("clienteID");
					mensajeBean.setConsecutivoString(relacionClienteBean.getClienteID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Relaciones del Cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaListaRelaciones(final RelacionEmpleadoClienteBean relacionClienteBean, final List listaRelacionesCli) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionBean mensajePersona = null;
				try {
					RelacionEmpleadoClienteBean relacionCli;
					mensajeBean = bajaRelacionCliente(relacionClienteBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajePersona = modificaRelacionEmpresa(relacionClienteBean);

					if(mensajePersona.getNumero() == 0 || mensajePersona.getNumero() == 000){
						for(int i=0; i<listaRelacionesCli.size(); i++){
							relacionCli = (RelacionEmpleadoClienteBean)listaRelacionesCli.get(i);
							relacionCli.setEmpleadoID(mensajePersona.getConsecutivoString());

							mensajeBean = altaRelacionClientes(relacionCli);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Informacion Actualizada.");
					mensajeBean.setNombreControl("clienteID");
					mensajeBean.setConsecutivoString(relacionClienteBean.getClienteID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Relaciones del Cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaRelacionClientes(final RelacionEmpleadoClienteBean relacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call RELACIONEMPLEADOALT("
									+ "?,?,?,?,?, 		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_EmpleadoID", relacionesBean.getEmpleadoID());

							sentenciaStore.setString("Par_RelacionadoID", relacionesBean.getRelacionadoID());
							sentenciaStore.setString("Par_NombreCliente", relacionesBean.getNombre());
							sentenciaStore.setString("Par_CURP", relacionesBean.getCURP());
							sentenciaStore.setString("Par_RFC", relacionesBean.getRFC());

							sentenciaStore.setString("Par_PuestoID", relacionesBean.getPuestoID());
							sentenciaStore.setString("Par_Parentesco", relacionesBean.getParentescoID());
							sentenciaStore.setString("Par_TipoRelacion", relacionesBean.getTipoRelacion());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta por relaciones cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaRelacionEmpresa(final RelacionEmpleadoClienteBean relacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call RELACIONPERSONASALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_EmpleadoID", relacionesBean.getEmpleadoID());
							sentenciaStore.setString("Par_NombreEmpleado", relacionesBean.getNombreEmpleado());
							sentenciaStore.setString("Par_CURPRelacionado", relacionesBean.getCURPEmpleado());
							sentenciaStore.setString("Par_RFCRelacionado", relacionesBean.getRFCEmpleado());
							sentenciaStore.setString("Par_PuestoIDEmp", relacionesBean.getPuestoEmpleadoID());

							sentenciaStore.setString("Par_PorcAcciones", relacionesBean.getPorcAcciones());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de Relacionados Empresa", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean modificaRelacionEmpresa(final RelacionEmpleadoClienteBean relacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call RELACIONPERSONASMOD("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_EmpleadoID", relacionesBean.getEmpleadoID());
							sentenciaStore.setString("Par_NombreEmpleado", relacionesBean.getNombreEmpleado());
							sentenciaStore.setString("Par_CURPRelacionado", relacionesBean.getCURPEmpleado());
							sentenciaStore.setString("Par_RFCRelacionado", relacionesBean.getRFCEmpleado());
							sentenciaStore.setString("Par_PuestoIDEmp", relacionesBean.getPuestoEmpleadoID());
							sentenciaStore.setInt("Par_PorcAcciones", Utileria.convierteEntero(relacionesBean.getPorcAcciones()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Modificación de Relacionados Empresa", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}





	public MensajeTransaccionBean bajaRelacionCliente(RelacionEmpleadoClienteBean relacionCliente) {
		String query = "call RELACIONEMPLEADOBAJ(?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				relacionCliente.getEmpleadoID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"DiasInversionDAO.bajaDiasInversion",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONEMPLEADOBAJ(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}




	public List listaRelacionesCliente(RelacionEmpleadoClienteBean relacionClienteBean, int tipoLista){
		String query = "call RELACIONEMPLEADOLIS(?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				relacionClienteBean.getEmpleadoID(),
				relacionClienteBean.getNombreEmpleado(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelacionClienteEmpleadoDAO.listaRelacionesCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONEMPLEADOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RelacionEmpleadoClienteBean relacionCliente = new RelacionEmpleadoClienteBean();
				relacionCliente.setEmpleadoID(resultSet.getString("EmpleadoID"));
				relacionCliente.setRelacionadoID(resultSet.getString("RelacionadoID"));
				relacionCliente.setNombre(resultSet.getString("NombreRelacionado"));
				relacionCliente.setCURP(resultSet.getString("CURP"));
				relacionCliente.setRFC(resultSet.getString("RFC"));
				relacionCliente.setPuestoID(resultSet.getString("PuestoID"));
				relacionCliente.setParentescoID(resultSet.getString("ParentescoID"));
				relacionCliente.setTipoRelacion(resultSet.getString("TipoRelacion"));
				return relacionCliente;


			}
		});
		return matches;
	}

	public List listaPrincipal(RelacionEmpleadoClienteBean relacionClienteBean, int tipoLista){
		String query = "call RELACIONEMPLEADOLIS(?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				relacionClienteBean.getEmpleadoID(),
				relacionClienteBean.getNombreEmpleado(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelacionClienteEmpleadoDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONEMPLEADOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RelacionEmpleadoClienteBean relacionCliente = new RelacionEmpleadoClienteBean();
				relacionCliente.setEmpleadoID(resultSet.getString("PersonaID"));
				relacionCliente.setNombreEmpleado(resultSet.getString("NombrePersona"));
				return relacionCliente;


			}
		});
		return matches;
		}

	/* Consulta relaciones */
	public RelacionEmpleadoClienteBean consultaRelacionado(RelacionEmpleadoClienteBean bean, int tipoConsulta) {
	String query = "call RELACIONCLIEMPLEADOCON(?,?,?,?,?,   ?,?,?,?,?);";
	Object[] parametros = {	Utileria.convierteEntero(bean.getClienteID()),
							Utileria.convierteEntero(bean.getProspectoID()),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"RelacionClienteEmpleadoDAO.consultaRelacionado",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONCLIEMPLEADOCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			RelacionEmpleadoClienteBean relacion = new RelacionEmpleadoClienteBean();

			relacion.setClienteID(resultSet.getString("ClienteID"));
			relacion.setClasificacion(resultSet.getString("Clasificacion"));

				return relacion;

		}
	});
	return matches.size() > 0 ? (RelacionEmpleadoClienteBean) matches.get(0) : null;

}// fin de consulta


	/* Consulta Relacionados Empresa */
	public RelacionEmpleadoClienteBean consultaRelacionadoEmp(RelacionEmpleadoClienteBean bean, int tipoConsulta) {
	String query = "call RELACIONPERSONASCON(?,?,?,?,?,   ?,?,?,?);";
	Object[] parametros = {	Utileria.convierteEntero(bean.getEmpleadoID()),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"RelacionClienteEmpleadoDAO.consultaRelacionadoEmp",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RELACIONPERSONASCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			RelacionEmpleadoClienteBean relacion = new RelacionEmpleadoClienteBean();

			relacion.setEmpleadoID(resultSet.getString("PersonaID"));
			relacion.setNombreEmpleado(resultSet.getString("NombrePersona"));
			relacion.setCURPEmpleado(resultSet.getString("CURP"));
			relacion.setRFCEmpleado(resultSet.getString("RFC"));
			relacion.setPuestoEmpleadoID(resultSet.getString("PuestoID"));
			relacion.setPorcAcciones(resultSet.getString("PorcAcciones"));
				return relacion;

		}
	});
	return matches.size() > 0 ? (RelacionEmpleadoClienteBean) matches.get(0) : null;

}// fin de consulta



}
