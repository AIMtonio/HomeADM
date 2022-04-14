package soporte.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.MenuBean;
import soporte.bean.OpcionesRolBean;
import soporte.bean.PlazasBean;
import soporte.bean.RolesBean;


public class RolesDAO extends BaseDAO{


	public RolesDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

// ------------------ Transacciones ------------------------------------------
	/* Alta de Rol */

	public MensajeTransaccionBean altaRoles(final RolesBean roles){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try{
				mensajeBean = alta(roles);

				if (mensajeBean.getNumero() == 0){
					roles.setRolID(mensajeBean.getCampoGenerico());
					mensajeBean = altaBDPrincipal(roles);
				}
				System.out.println("aqui ando="+mensajeBean.getNumero());
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Error en el Alta del Roles.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}

			}catch (Exception e) {
				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error("Error en el Alta de Roles." + e);
				}

			return mensajeBean;

			}
		});

		return mensaje;
	}

	public MensajeTransaccionBean modificaRoles(final RolesBean roles){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try{
				mensajeBean = modifica(roles);

				if (mensajeBean.getNumero() == 0){
					mensajeBean = modificaPrincipal(roles);
				}
				System.out.println("aqui ando="+mensajeBean.getNumero());
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Error en Modificacion del Rol.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}

			}catch (Exception e) {
				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error("Error en Modificacion del Roles." + e);
				}

			return mensajeBean;

			}
		});

		return mensaje;
	}
	public MensajeTransaccionBean alta(final RolesBean roles) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call ROLESALT(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							roles.getNombreRol(),
							roles.getDescripcion(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RolesDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESALT(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setCampoGenerico(resultSet.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de roles", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public MensajeTransaccionBean altaBDPrincipal(final RolesBean roles) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call ROLESALT(?,?,?,?,?, ?,?,?,?,?, "
												                   + "?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_RolID",Utileria.convierteEntero(roles.getRolID()));
										sentenciaStore.setString("Par_NombreRol",roles.getNombreRol());
										sentenciaStore.setString("Par_Descripcion", roles.getDescripcion());
										sentenciaStore.setString("Par_OrigenDatos", parametrosAuditoriaBean.getOrigenDatos());
										sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info("principal"+"-"+sentenciaStore.toString());
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RolesDao.altaBDPrincipal");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .ClienteDAO.actualizaCliente");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
				}catch (Exception e) {
					loggerSAFI.error("principal"+"-"+"Error en el Alta del Rol." + e);
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



	/* Modificacion de Rol */
	public MensajeTransaccionBean modifica(final RolesBean roles){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					String query = "call ROLESMOD(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(roles.getRolID()),
							roles.getNombreRol(),
							roles.getDescripcion(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RolesDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESMOD(" + Arrays.toString(parametros) +")");
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

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de roles", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaPrincipal(final RolesBean roles) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call ROLESMOD(?,?,?,?,?, ?,?,?,?,?, "
												                   + "?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setString("Par_RolID",roles.getRolID());
										sentenciaStore.setString("Par_NombreRol",roles.getNombreRol());
										sentenciaStore.setString("Par_Descripcion", roles.getDescripcion());
										sentenciaStore.setString("Par_OrigenDatos", parametrosAuditoriaBean.getOrigenDatos());
										sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info("principal"+"-"+sentenciaStore.toString());
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .RolesDao.modificaPrincipal");
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
								throw new Exception(Constantes.MSG_ERROR + " .ClienteDAO.modificaPrincipal");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
				}catch (Exception e) {
					loggerSAFI.error("principal"+"-"+"Error en Modificacion del Rol." + e);
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



	/* Alta de opciones de menu del Rol */

	public MensajeTransaccionBean altaOpcionRol(final RolesBean roles) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call OPCIONESROLALT(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							roles.getNombreRol(),
							roles.getDescripcion(),
							parametrosAuditoriaBean.getOrigenDatos(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RolesDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESROLALT(" + Arrays.toString(parametros) +")");
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
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de opcion de rol", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	//consulta principal  de Roles
		public RolesBean consultaRoles(RolesBean rol, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ROLESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getRolID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RolesDAO.consultaRoles",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean rol = new RolesBean();
				rol.setRolID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				rol.setNombreRol(resultSet.getString(2));
				rol.setDescripcion(resultSet.getString(3));

					return rol;

			}
		});
		return matches.size() > 0 ? (RolesBean) matches.get(0) : null;

	}
		//consulta foranea  de Roles
		public RolesBean consultaRolesForanea(RolesBean rol, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ROLESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getRolID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RolesDAO.consultaRoles",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean rol = new RolesBean();
				rol.setRolID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				rol.setNombreRol(resultSet.getString(2));
					return rol;

			}
		});
		return matches.size() > 0 ? (RolesBean) matches.get(0) : null;

	}

		//Consulta del Estatus de Autorización de Timbrado por Rol
		public RolesBean consultaAutTimbrado(RolesBean rol, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ROLESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getRolID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RolesDAO.consultaRoles",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean rol = new RolesBean();
				rol.setAutTimbrado(resultSet.getString("AutTimbrado"));
					return rol;

			}
		});
		return matches.size() > 0 ? (RolesBean) matches.get(0) : null;

	}


		//Lista  de opciones(pantallas) por rol
		public List listaOpcionesPorRol(OpcionesRolBean opcionesRolBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OPCIONESROLCON(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {	opcionesRolBean.getRolID(),
								Constantes.ENTERO_CERO, // OpcionMenuID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RolesDAO.listaOpcionesPorRol",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESROLCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionesRolBean opciones = new OpcionesRolBean();
				opciones.setOpcionMenuID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				opciones.setDesplegado(resultSet.getString(2));
				opciones.setRecurso(resultSet.getString(3));

					return opciones;

			}
		});
		return matches;

	}


	//Lista de Roles
	public List listaRoles(RolesBean rol, int tipoLista) {
		//Query con el Store Procedure
		String query = "call ROLESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getNombreRol(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"RolesDAO.listaRoles",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROLESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean roles = new RolesBean();
				roles.setRolID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				roles.setNombreRol(resultSet.getString(2));
				return roles;
			}
		});

		return matches;
	}






	//Lista de Todos los Roles o Perfiles de la Aplicacion
	public List listaTodosRoles(RolesBean rol, int tipoLista) {
		//Query con el Store Procedure
		String query = "call ROLESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getNombreRol(),
								tipoLista,

								Constantes.ENTERO_CERO,	 //Se mandan Vacio pq a este punto no hay Session
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								"localhost",
								"RolesDAO.listaRoles",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean roles = new RolesBean();
				roles.setRolID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				roles.setNombreRol(resultSet.getString(2));
				return roles;
			}
		});

		return matches;
	}



	public List listaTodosRolesPrincipal(RolesBean rol, int tipoLista) {
		String query = "call ROLESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	rol.getNombreRol(),
								tipoLista,

								Constantes.ENTERO_CERO,	 //Se mandan Vacio pq a este punto no hay Session
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								"localhost",
								"RolesDAO.listaRoles",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RolesBean roles = new RolesBean();
				roles.setRolID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 3));
				roles.setNombreRol(resultSet.getString(2));
				return roles;
			}
		});

		return matches;
	}
}
