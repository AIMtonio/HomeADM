package gestionComecial.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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

import gestionComecial.bean.EmpleadosBean;
import gestionComecial.bean.PuestosBean;


public class EmpleadosDAO extends BaseDAO{

	public EmpleadosDAO() {
		super();
	}

/*------------Alta de Empleados-------------*/

	public MensajeTransaccionBean alta(final EmpleadosBean empleadosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call EMPLEADOSALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?,"	+
									"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_ClavePuestoID",empleadosBean.getClavePuestoID());
								sentenciaStore.setString("Par_ApellidoPat",empleadosBean.getApellidoPat());
								sentenciaStore.setString("Par_ApellidoMat",empleadosBean.getApellidoMat());
								sentenciaStore.setString("Par_PrimerNombre",empleadosBean.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNombre",empleadosBean.getSegundoNombre());
								sentenciaStore.setString("Par_FechaNac",empleadosBean.getFechaNac());
								sentenciaStore.setString("Par_RFC",empleadosBean.getRFC());
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(empleadosBean.getSucursalID()));
								sentenciaStore.setString("Par_Nacion",empleadosBean.getNacion());
								sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(empleadosBean.getLugarNacimiento()));
								sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(empleadosBean.getEstadoID()));
								sentenciaStore.setString("Par_Genero",empleadosBean.getSexo());
								sentenciaStore.setString("Par_CURP",empleadosBean.getCURP());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString(1)));
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.STRING_VACIO);
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
						throw new Exception(Constantes.MSG_ERROR + " .EmpleadosDAO.altaEmpleado");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de empleado" + e);
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


/*-------Baja de Puestos-------*/

		public MensajeTransaccionBean  baja(final EmpleadosBean empleadosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
		/*--------Baja con SP---------*/
						String query = "call EMPLEADOSBAJ(?,?,?,?,?,?,?,?);";
						Object[] parametros = {

								empleadosBean.getEmpleadoID(),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSBAJ(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
											MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
											mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
											mensaje.setDescripcion(resultSet.getString(2));
											mensaje.setNombreControl(resultSet.getString(3));
											return mensaje;

							}
						});

						return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
					}catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de empleado", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public EmpleadosBean consultaPrincipal(EmpleadosBean empleados, int tipoConsulta){
			String query = "call EMPLEADOSCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					empleados.getEmpleadoID(),
					empleados.getRFC(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EmpleadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadosBean empleados = new EmpleadosBean();
					empleados.setEmpleadoID(resultSet.getString(1));
					empleados.setClavePuestoID(resultSet.getString(2));
					empleados.setApellidoPat(resultSet.getString(3));
					empleados.setApellidoMat(resultSet.getString(4));
					empleados.setPrimerNombre(resultSet.getString(5));
					empleados.setSegundoNombre(resultSet.getString(6));
					empleados.setFechaNac(resultSet.getString(7));
					empleados.setRFC(resultSet.getString(8));
					empleados.setNombreCompleto(resultSet.getString(9));
					empleados.setSucursalID(resultSet.getString(10));
					empleados.setEstatus(resultSet.getString(11));
					empleados.setNacion(resultSet.getString("Nacionalidad"));
					empleados.setLugarNacimiento(resultSet.getString("LugarNacimiento"));
					empleados.setEstadoID(resultSet.getString("EstadoID"));
					empleados.setSexo(resultSet.getString("Sexo"));
					empleados.setCURP(resultSet.getString("CURP"));

				return empleados;
				}
			});
			return matches.size() > 0 ? (EmpleadosBean) matches.get(0) : null;
		}



		public EmpleadosBean consultaPrincipalExterna(EmpleadosBean empleados, int tipoConsulta){
			String query = "call EMPLEADOSCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					empleados.getEmpleadoID(),
					empleados.getRFC(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EmpleadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(empleados.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadosBean empleados = new EmpleadosBean();
					empleados.setEmpleadoID(resultSet.getString(1));
					empleados.setClavePuestoID(resultSet.getString(2));
					empleados.setApellidoPat(resultSet.getString(3));
					empleados.setApellidoMat(resultSet.getString(4));
					empleados.setPrimerNombre(resultSet.getString(5));
					empleados.setSegundoNombre(resultSet.getString(6));
					empleados.setFechaNac(resultSet.getString(7));
					empleados.setRFC(resultSet.getString(8));
					empleados.setNombreCompleto(resultSet.getString(9));
					empleados.setSucursalID(resultSet.getString(10));
					empleados.setEstatus(resultSet.getString(11));
					empleados.setNacion(resultSet.getString("Nacionalidad"));
					empleados.setLugarNacimiento(resultSet.getString("LugarNacimiento"));
					empleados.setEstadoID(resultSet.getString("EstadoID"));
					empleados.setSexo(resultSet.getString("Sexo"));
					empleados.setCURP(resultSet.getString("CURP"));

				return empleados;
				}
			});
			return matches.size() > 0 ? (EmpleadosBean) matches.get(0) : null;
		}

		public List listaAlfanumerica(EmpleadosBean empleadosBean, int tipoLista){
			String query = "call EMPLEADOSLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						empleadosBean.getEmpleadoID(),
						empleadosBean.getNombreCompleto(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"EmpleadosDAO.listaAlfanumerica",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadosBean empleadosBean = new EmpleadosBean();
					empleadosBean.setEmpleadoID(resultSet.getString(1));
					empleadosBean.setNombreCompleto(resultSet.getString(2));
					return empleadosBean;

				}
			});
			return matches;
			}


		public EmpleadosBean consultaForanea(EmpleadosBean empleados, int tipoConsulta){
			String query = "call EMPLEADOSCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					empleados.getEmpleadoID(),
					empleados.getRFC(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EmpleadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadosBean empleados = new EmpleadosBean();
					empleados.setDescripcion(resultSet.getString(1));
				return empleados;
				}
			});
			return matches.size() > 0 ? (EmpleadosBean) matches.get(0) : null;
		}


		public EmpleadosBean consultaRFC(EmpleadosBean empleados, int tipoConsulta){
			String query = "call EMPLEADOSCON(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {

					empleados.getEmpleadoID(),
					empleados.getRFC(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EmpleadosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EmpleadosBean empleados = new EmpleadosBean();
					empleados.setRFC(resultSet.getString(1));
				return empleados;
				}
			});
			return matches.size() > 0 ? (EmpleadosBean) matches.get(0) : null;
		}


		/* Modificacion de EMPLEADOS */

		public MensajeTransaccionBean modifica(final EmpleadosBean empleadosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call EMPLEADOSMOD("
												+ "?,?,?,?,?, ?,?,?,?,?,"
												+ "?,?,?,?,?, ?,?,?,?,?,"
												+ "?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_EmpleadoID", empleadosBean.getEmpleadoID());
										sentenciaStore.setString("Par_ClavePuestoID", empleadosBean.getClavePuestoID());

										sentenciaStore.setString("Par_ApellidoPat",empleadosBean.getApellidoPat());
										sentenciaStore.setString("Par_ApellidoMat",empleadosBean.getApellidoMat());
										sentenciaStore.setString("Par_PrimerNombre",empleadosBean.getPrimerNombre());
										sentenciaStore.setString("Par_SegundoNombre",empleadosBean.getSegundoNombre());
										sentenciaStore.setString("Par_FechaNac",empleadosBean.getFechaNac());
										sentenciaStore.setString("Par_RFC",empleadosBean.getRFC());
										sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(empleadosBean.getSucursalID()));
										sentenciaStore.setString("Par_Nacion",empleadosBean.getNacion());
										sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(empleadosBean.getLugarNacimiento()));
										sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(empleadosBean.getEstadoID()));
										sentenciaStore.setString("Par_Genero",empleadosBean.getSexo());
										sentenciaStore.setString("Par_CURP",empleadosBean.getCURP());
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
										sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

										sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
										sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

										sentenciaStore.setString("Aud_ProgramaID", "CargosDAO.modifica");
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
											mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));


										} else {
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargosDAO.modifica");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								}
								);

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .EmpleadosDAO.modifica");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de empleado", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		/* Actualización  */
		public MensajeTransaccionBean actualizacion(final EmpleadosBean empleados) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						//Query cons el Store Procedure
						String query = "call EMPLEADOSACT(?,?,?,?,?,?,?,?);";
						Object[] parametros = {

								empleados.getEmpleadoID(),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSACT(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));

								return mensaje;

							}
						});
						return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
					}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actaluazacion de empleado", e);
				}
				return mensajeBean;
				}
			});
			return mensaje;
		}

	// Consulta datos del empleado y en el organigrama su jefe inmediato y cta contable y centro de costos
	public EmpleadosBean conOrganigrama(EmpleadosBean empleados, int tipoConsulta){
		String query = "call EMPLEADOSCON(?,?,?," +
										"?,?,?,?,?,?,?);"; //Parametros audditoria
		Object[] parametros = {

			Utileria.convierteEntero(empleados.getEmpleadoID()),
			Constantes.STRING_VACIO,
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"EmpleadosDAO.conOrganigrama",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EMPLEADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EmpleadosBean empleados = new EmpleadosBean();
				empleados.setNombreCompleto(resultSet.getString("NombreCompleto"));
				empleados.setPuesto(resultSet.getString("Puesto"));
				empleados.setCategoriaID(resultSet.getString("CategoriaID"));
				empleados.setCtaContable(resultSet.getString("CtaContable"));
				empleados.setCentroCostoID(resultSet.getString("CentroCostoID"));

				empleados.setJefeInmediato(resultSet.getString("JefeInmediato"));
				empleados.setEstatus(resultSet.getString("Estatus"));
			return empleados;
			}
		});
		return matches.size() > 0 ? (EmpleadosBean) matches.get(0) : null;
	}

}
