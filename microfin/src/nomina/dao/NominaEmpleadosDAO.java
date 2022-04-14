package nomina.dao;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.EmpleadoNominaBean;

public class NominaEmpleadosDAO extends BaseDAO {

	//ALTA DE EMPLEADO DE NOMINA
	public MensajeTransaccionBean altaEmpleadosNomina(final EmpleadoNominaBean empleadoNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL NOMINAEMPLEADOSALT (?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(empleadoNominaBean.getClienteID()));
									sentenciaStore.setLong("Par_ProspectoID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_ConvNominaID", Utileria.convierteEntero(empleadoNominaBean.getConvenioNominaID()));
									sentenciaStore.setString("Par_TipoEmpleadoID", empleadoNominaBean.getTipoEmpleadoID());

									sentenciaStore.setInt("Par_TipoPuestoID", Utileria.convierteEntero(empleadoNominaBean.getPuestoOcupacionID()));
									sentenciaStore.setString("Par_NoEmpleado", empleadoNominaBean.getNoEmpleado());
									sentenciaStore.setInt("Par_QuinquenioID",  Utileria.convierteEntero(empleadoNominaBean.getQuinquenioID()));
									sentenciaStore.setString("Par_CenAdscripcion", empleadoNominaBean.getCentroAdscripcion());
									sentenciaStore.setString("Par_FechaIngreso", Utileria.convierteFecha(empleadoNominaBean.getFechaIngreso()));
									sentenciaStore.setString("Par_NoPension", empleadoNominaBean.getNoPension());


									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NominaEmpleadosDAO.altaEmpleadosNomina");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NominaEmpleadosDAO.altaEmpleadosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NominaEmpleadosDAO.altaEmpleadosNomina");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al registrar el empleado" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	//MODIFICACION DE EMPLEADO DE NOMINA
	public MensajeTransaccionBean modificacionEmpleadosNomina(final EmpleadoNominaBean empleadoNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL NOMINAEMPLEADOSMOD (?,?,?,?,?,		"
																		  + "?,?,?,?,?,		"
																		  + "?,?,?,?,?,		"
																		  + "?,?,?,?,?,		"
																		  + "?,?,?,?,?,		"
																		  + "?,?);			";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_NominaEmpleadoID", Utileria.convierteEntero(empleadoNominaBean.getNominaEmpleadoID()));

									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(empleadoNominaBean.getClienteID()));
									sentenciaStore.setLong("Par_ProspectoID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_ConvNominaID", Utileria.convierteEntero(empleadoNominaBean.getConvenioNominaID()));
									sentenciaStore.setString("Par_TipoEmpleadoID", empleadoNominaBean.getTipoEmpleadoID());

									sentenciaStore.setInt("Par_TipoPuestoID", Utileria.convierteEntero(empleadoNominaBean.getPuestoOcupacionID()));
									sentenciaStore.setString("Par_NoEmpleado", empleadoNominaBean.getNoEmpleado());
									sentenciaStore.setInt("Par_QuinquenioID", Utileria.convierteEntero(empleadoNominaBean.getQuinquenioID()));
									sentenciaStore.setString("Par_CenAdscripcion", empleadoNominaBean.getCentroAdscripcion());
									sentenciaStore.setString("Par_FechaIngreso", Utileria.convierteFecha(empleadoNominaBean.getFechaIngreso()));

									sentenciaStore.setString("Par_Estatus", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_FechaInicioInca",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Par_FechaFinInca",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Par_FechaBaja",Constantes.FECHA_VACIA);
									sentenciaStore.setString("Par_MotivoBaja",Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_NoPension",empleadoNominaBean.getNoPension());


									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NominaEmpleadosDAO.altaEmpleadosNomina");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NominaEmpleadosDAO.altaEmpleadosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NominaEmpleadosDAO.altaEmpleadosNomina");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al registrar el empleado" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public MensajeTransaccionBean bajaEmpleadosNomina(final EmpleadoNominaBean empleadoNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL NOMINAEMPLEADOSBAJ (?,?,?,?,?,	?,?,?,?,?,	?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_NominaEmpleadoID", Utileria.convierteEntero(empleadoNominaBean.getNominaEmpleadoID()));
									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()));

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NominaEmpleadosDAO.bajaEmpleadosNomina");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NominaEmpleadosDAO.bajaEmpleadosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NominaEmpleadosDAO.bajaEmpleadosNomina");
					} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al eliminar el registro del empleado" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public EmpleadoNominaBean consultaEmpleadoNomina(int tipoConsulta, EmpleadoNominaBean empleadoNominaBean) {
		EmpleadoNominaBean registro = null;
		try {
			String query = "CALL NOMINAEMPLEADOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {

					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getNominaEmpleadoID()),
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.consultaEmpleadoNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();

					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setNombreInstNomina(resultSet.getString("NombreInstit"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setPuestoOcupacionID(resultSet.getString("TipoPuestoID"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setEstatusEmp(resultSet.getString("Estatus"));
					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setCentroAdscripcion(resultSet.getString("CentroAdscripcion"));
					resultado.setFechaIngreso(resultSet.getString("FechaIngreso"));
					resultado.setNoPension(resultSet.getString("NoPension"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de empleados", e);
		}
		return registro;
	}

	public EmpleadoNominaBean consultaEmpleadoBaja(int tipoConsulta, EmpleadoNominaBean empleadoNominaBean) {
		EmpleadoNominaBean registro = null;
		try {
			String query = "CALL NOMINAEMPLEADOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getConvenioNominaID()),
					Constantes.DOUBLE_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.consultaEmpleadoReasignacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();

					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setEstatusEmp(resultSet.getString("Estatus"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de empleados", e);
		}
		return registro;
	}

	public EmpleadoNominaBean consultaEmpleadoCliente(int tipoConsulta, EmpleadoNominaBean empleadoNominaBean) {
		EmpleadoNominaBean registro = null;
		try {
			String query = "CALL NOMINAEMPLEADOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getConvenioNominaID()),
					Constantes.DOUBLE_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.consultaEmpleadoCliente",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();
					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setPuestoOcupacionID(resultSet.getString("TipoPuestoID"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setEstatusEmp(resultSet.getString("Estatus"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de empleado nomina por cliente", e);
		}
		return registro;
	}

	public List<?> listaAyudaEmpleadosNomina(int tipoLista, EmpleadoNominaBean empleadoNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL NOMINAEMPLEADOSLIS (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					empleadoNominaBean.getNombreInstNomina(),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.DOUBLE_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.listaAyudaEmpleadosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSLIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();
					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreInstNomina(resultSet.getString("NombreInstit"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));

					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de empleados", e);
		}
		return lista;
	}

	public List<?> listaGridEmpleadosNomina(int tipoLista, EmpleadoNominaBean empleadoNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL NOMINAEMPLEADOSLIS (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.DOUBLE_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.listaGridEmpleadosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSLIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();
					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setNombreInstNomina(resultSet.getString("NombreInstit"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setDescripcionTipoEmpleado(resultSet.getString("DescTipoEmpleado"));
					resultado.setPuestoOcupacionID(resultSet.getString("TipoPuestoID"));
					resultado.setDescripcionTipoPuesto(resultSet.getString("DesPuestoOcupacion"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setEstatusEmp(resultSet.getString("Estatus"));

					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de empleados", e);
		}
		return lista;
	}

	public List<?> listaAyudaEmpleados(int tipoLista, EmpleadoNominaBean empleadoNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
												  + "?,?,?,?,?,	"
												  + "?);";
			Object[] parametros = {
					empleadoNominaBean.getInstitNominaID(),
					Constantes.STRING_VACIO,
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.listaGridEmpleadosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSLIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcionConvenio(resultSet.getString("Descripcion"));

					return resultado;
				}
			});
			lista = matches;
		} catch (Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de empleados", e);
		}
		return lista;
	}

	public List reporteClientesEmpresaNomina(int tipoLista, EmpleadoNominaBean empleadoNominaBean) {
		List lista = null;
		try {
			String query = "CALL NOMINAEMPLEADOSREP (?,?,?,?,?,		?,?,?,?,?,		?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(empleadoNominaBean.getConvenioNominaID()),
					Utileria.convierteFecha(empleadoNominaBean.getFechaInicio()),
					Utileria.convierteFecha(empleadoNominaBean.getFechaFin()),
					Utileria.convierteEntero(empleadoNominaBean.getSucursalID()),

					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.reporteClientesEmpresaNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSREP (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setNombreInstNomina(resultSet.getString("NombreInstNomina"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setDescripcionConvenio(resultSet.getString("DescripcionConvenio"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setCURP(resultSet.getString("CURP"));
					resultado.setRFC(resultSet.getString("RFC"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setDesTipoEmpleado(resultSet.getString("DesTipoEmpleado"));
					resultado.setPuestoOcupacionID(resultSet.getString("PuestoOcupacionID"));
					resultado.setDesPuestoOcupacion(resultSet.getString("DesPuestoOcupacion"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setDesQuinquenio(resultSet.getString("DesQuinquenio"));
					resultado.setFechaIngreso(resultSet.getString("FechaIngreso"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de clientes de nomina", e);
		}
		return lista;
	}


	public EmpleadoNominaBean consultaClienteEmpNomina(int tipoConsulta, EmpleadoNominaBean empleadoNominaBean) {
		EmpleadoNominaBean registro = null;
		try {
			String query = "CALL NOMINAEMPLEADOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getClienteID()),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(empleadoNominaBean.getNominaEmpleadoID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NominaEmpleadosDAO.consultaEmpleadoNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOMINAEMPLEADOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadoNominaBean resultado = new EmpleadoNominaBean();

					resultado.setNominaEmpleadoID(resultSet.getString("NominaEmpleadoID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setTipoEmpleadoID(resultSet.getString("TipoEmpleadoID"));
					resultado.setPuestoOcupacionID(resultSet.getString("TipoPuestoID"));
					resultado.setNoEmpleado(resultSet.getString("NoEmpleado"));


					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de empleados", e);
		}
		return registro;
	}


}
