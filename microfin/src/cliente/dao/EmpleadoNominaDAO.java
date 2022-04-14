package cliente.dao;

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

import cliente.BeanWS.Request.ListaEmpleadoNomRequest;
import cliente.BeanWS.Request.ListaReporteNomBitacoEstEmpRequest;
import cliente.bean.EmpleadoNominaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class EmpleadoNominaDAO extends BaseDAO {

	public EmpleadoNominaDAO(){
		super();
	}

	public MensajeTransaccionBean altaEmpleadoNominaBanca(final EmpleadoNominaBean empleadoNom, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call NOMINAEMPLEADOSALT(?,?,?, ?,?,?, ?,?,?,?,?,?,? );";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(empleadoNom.getInstitNominaID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(empleadoNom.getClienteID()));
								sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(empleadoNom.getProspectoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",  parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaEmpleadoNomina");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Alta de Empleado de Nómina", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public EmpleadoNominaBean consultaEstatus(int tipoConsulta, EmpleadoNominaBean empleadoBean){
		String query = "call NOMINAEMPLEADOSCON(" +
				"?,?,?,?,?,		?,?,?,?,?," +
				"?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(empleadoBean.getInstitNominaID()),
				Utileria.convierteEntero(empleadoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaEstatus",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMINAEMPLEADOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				EmpleadoNominaBean empleadoNom = new EmpleadoNominaBean();

				empleadoNom.setNombreCompleto(resultSet.getString(1));
				empleadoNom.setEstatusEmp(resultSet.getString(2));
				empleadoNom.setFechaInicialInca(resultSet.getString(3));
				empleadoNom.setFechaFinInca(resultSet.getString(4));
				empleadoNom.setFechaBaja(resultSet.getString(5));
				empleadoNom.setMotivoBaja(resultSet.getString(6));
				empleadoNom.setCodigoRespuesta(String.valueOf(resultSet.getInt(7)));
				empleadoNom.setMensajeRespuesta(resultSet.getString(8));

				return empleadoNom;
			}
		});

		return matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
	}

	/*
	 * Utilizada para WS
	 */
	public EmpleadoNominaBean consultaEstatusWS(int tipoConsulta, EmpleadoNominaBean empleadoBean){
		String query = "call NOMINAEMPLEADOSCON(" +
				"?,?,?,?,?,		?,?,?,?,?," +
				"?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(empleadoBean.getInstitNominaID()),
				Utileria.convierteEntero(empleadoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaEstatus",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMINAEMPLEADOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				EmpleadoNominaBean empleadoNom = new EmpleadoNominaBean();

				empleadoNom.setNombreCompleto(resultSet.getString(1));
				empleadoNom.setEstatusEmp(resultSet.getString(2));
				empleadoNom.setFechaInicialInca(resultSet.getString(3));
				empleadoNom.setFechaFinInca(resultSet.getString(4));
				empleadoNom.setFechaBaja(resultSet.getString(5));
				empleadoNom.setMotivoBaja(resultSet.getString(6));
				empleadoNom.setCodigoRespuesta(String.valueOf(resultSet.getInt(7)));
				empleadoNom.setMensajeRespuesta(resultSet.getString(8));

				return empleadoNom;
			}
		});

		return matches.size() > 0 ? (EmpleadoNominaBean) matches.get(0) : null;
	}


	public MensajeTransaccionBean actualizaEstatus(final EmpleadoNominaBean empleadoNom) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL NOMINAEMPLEADOSMOD (?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?);			";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NominaEmpleadoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(empleadoNom.getInstitNominaID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(empleadoNom.getClienteID()));
								sentenciaStore.setLong("Par_ProspectoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_ConvNominaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_TipoEmpleadoID", Constantes.ENTERO_CERO);

								sentenciaStore.setInt("Par_TipoPuestoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NoEmpleado", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_QuinquenioID", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_CenAdscripcion", Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechaIngreso", Constantes.FECHA_VACIA);

								sentenciaStore.setString("Par_Estatus",empleadoNom.getEstatusEmp());
								sentenciaStore.setString("Par_FechaInicioInca",Utileria.convierteFecha(empleadoNom.getFechaInicialInca()));
								sentenciaStore.setString("Par_FechaFinInca",Utileria.convierteFecha(empleadoNom.getFechaFinInca()));
								sentenciaStore.setString("Par_FechaBaja",Utileria.convierteFecha(empleadoNom.getFechaBaja()));
								sentenciaStore.setString("Par_MotivoBaja",empleadoNom.getMotivoBaja());

								sentenciaStore.setString("Par_NoPension", Constantes.STRING_VACIO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaEmpleadoNomina");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
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
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la actualizacion de estatus", e);
				}
				return mensajeBean;
			}
		  });
		return mensaje;
		}

	/*
	 * Utilizada para WS.
	 */
	public MensajeTransaccionBean actualizaEstatusWS(final EmpleadoNominaBean empleadoNom) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
		mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call NOMINAEMPLEADOSMOD(?,?,?,?,?," +
																	   "?,?,?,?,?," +
																	   "?,?,?,?,?," +
																	   "?,? );";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NominaEmpleadoID", Constantes.ENTERO_CERO);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(empleadoNom.getInstitNominaID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(empleadoNom.getClienteID()));
								sentenciaStore.setString("Par_Estatus",empleadoNom.getEstatusEmp());
								sentenciaStore.setString("Par_FechaInicioInca",Utileria.convierteFecha(empleadoNom.getFechaInicialInca()));
								sentenciaStore.setString("Par_FechaFinInca",Utileria.convierteFecha(empleadoNom.getFechaFinInca()));
								sentenciaStore.setString("Par_FechaBaja",Utileria.convierteFecha(empleadoNom.getFechaBaja()));
								sentenciaStore.setString("Par_MotivoBaja",empleadoNom.getMotivoBaja());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaEmpleadoNomina");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
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
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la actualizacion de estatus", e);
				}
				return mensajeBean;
			}
		  });
		return mensaje;
		}

	public List listaEmpleadosWS(ListaEmpleadoNomRequest listaEmpleadoNomRequest, int tipoLista){

		String query = "call NOMINAEMPLEADOSLIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				listaEmpleadoNomRequest.getNombreCompleto(),
				Utileria.convierteEntero(listaEmpleadoNomRequest.getInstitNominaID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleadoWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMINAEMPLEADOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EmpleadoNominaBean nominaBean = new EmpleadoNominaBean();

				nominaBean.setClienteID(resultSet.getString("ClienteID"));
				nominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

				return nominaBean;

			}
		});
		return matches;
	}
	///CONSULTA AL STORE NOMBITACOESTEMPLIS para la lista del cambio de estatus WS
		public List listaEstatEmpleadosWS(ListaReporteNomBitacoEstEmpRequest listaReporteNomBitacoEstEmpRequest, int tipoLista){
				String query = "call NOMBITACOESTEMPLIS(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?);";//mapeo de los campos
				Object[] parametros = {
						Utileria.convierteEntero(listaReporteNomBitacoEstEmpRequest.getInstitNominaID()),
						tipoLista,
						OperacionesFechas.conversionStrDate(listaReporteNomBitacoEstEmpRequest.getFechaInicio()),
						OperacionesFechas.conversionStrDate(listaReporteNomBitacoEstEmpRequest.getFechaFin()),
						Utileria.convierteEntero(listaReporteNomBitacoEstEmpRequest.getClienteID()),
						listaReporteNomBitacoEstEmpRequest.getEstatus(),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"EmpleadoNominaDAO.listaEmpleadoWS",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMBITACOESTEMPLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						EmpleadoNominaBean nominaBean = new EmpleadoNominaBean();
						nominaBean.setNombreInstNomina(resultSet.getString("NombreInstit"));//aqui me quedé
						nominaBean.setFechaAct(resultSet.getString("Fecha"));
						nominaBean.setClienteID(resultSet.getString("ClienteID"));
						nominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						nominaBean.setEstatusAnterior(resultSet.getString("EstatusAnterior"));
						nominaBean.setEstatusEmp(resultSet.getString("EstatusNuevo"));
						nominaBean.setFechaInicialInca((resultSet.getString("FechaInicioIncapacidad")));
						nominaBean.setFechaFinInca((resultSet.getString("FechaInicioIncapacidad")));
						nominaBean.setFechaBaja((resultSet.getString("FechaInicioIncapacidad")));
						nominaBean.setMotivoBaja((resultSet.getString("MotivoBaja")));

						return nominaBean;

					}
				});
				return matches;
			}
		///CONSULTA AL STORE NOMBITACOESTEMPLIS para la lista del cambio de estatus Microfin
			public List listaEstatEmpleados(int tipoLista, final EmpleadoNominaBean nominaBean){

					String query = "call NOMBITACOESTEMPLIS(?,?,?,?, ?,?,?,?,?,?,?);";//mapeo de los campos
					Object[] parametros = {
							Utileria.convierteEntero(nominaBean.getInstitNominaID()),
							tipoLista,
							Utileria.convierteFecha(nominaBean.getFechaInicio()),
							Utileria.convierteFecha(nominaBean.getFechaFin()),
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"EmpleadoNominaDAO.listaEmpleado",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMBITACOESTEMPLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							EmpleadoNominaBean nominaBean = new EmpleadoNominaBean();
							nominaBean.setNombreInstNomina(resultSet.getString("NombreInstit"));//aqui me quedé
							nominaBean.setFechaAct(resultSet.getString("Fecha"));
							nominaBean.setClienteID(resultSet.getString("ClienteID"));
							nominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
							nominaBean.setEstatusAnterior(resultSet.getString("EstatusAnterior"));
							nominaBean.setEstatusEmp(resultSet.getString("EstatusNuevo"));
							nominaBean.setFechaInicialInca((resultSet.getString("FechaInicioIncapacidad")));
							nominaBean.setFechaFinInca((resultSet.getString("FechaInicioIncapacidad")));
							nominaBean.setFechaBaja((resultSet.getString("FechaInicioIncapacidad")));
							nominaBean.setMotivoBaja((resultSet.getString("MotivoBaja")));

							return nominaBean;

						}
					});
					return matches;
				}
}


