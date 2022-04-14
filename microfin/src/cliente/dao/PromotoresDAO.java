package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
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

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.MonedasBean;
import cliente.bean.PromotoresBean;

public class PromotoresDAO extends BaseDAO{

	public PromotoresDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

// ------------------ Transacciones ------------------------------------------
	//alta de Promotores
	public MensajeTransaccionBean altaPromotor(final PromotoresBean promotor) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					promotor.setTelefono(promotor.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

					String query = "call PROMOTORESALT(?,?,?,?,?,?,?,?,?,?,"
													+ "?,?,?,?,?,?,?,?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_NombrPromot", promotor.getNombrePromotor());
							sentenciaStore.setString("Par_NombrCoordi", promotor.getNombreCoordinador());
							sentenciaStore.setString("Par_Telefono", promotor.getTelefono());
							sentenciaStore.setString("Par_Correo", promotor.getCorreo());
							sentenciaStore.setString("Par_Celular",promotor.getCelular());
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(promotor.getSucursalID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(promotor.getUsuarioID()));
							sentenciaStore.setString("Par_NumEmpleado", promotor.getNumeroEmpleado());
							sentenciaStore.setString("Par_ExtTelefonoPart", promotor.getExtTelefonoPart());
							sentenciaStore.setString("Par_AplicaPromotor", promotor.getAplicaPromotor());
							sentenciaStore.setInt("Par_GestorID", Utileria.convierteEntero(promotor.getGestorID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","PromotoresDAO.altaPromotor");
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{

										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PromotoresDAO.altaPromotor");
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
							throw new Exception(Constantes.MSG_ERROR + " .PromotoresDAO.altaPromotor");
						}else if(mensajeBean.getNumero()!=0){

							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Promotores" + e);
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

	//modificacion de promotores
	public MensajeTransaccionBean modificaPromotor(final PromotoresBean promotor) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					promotor.setTelefono(promotor.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					promotor.setCelular(promotor.getCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

					String query = "call PROMOTORESMOD(?,?,?,?,?, ?,?,?,?,?,"
													+ "?,?,?,?,?, ?,?,?,?,?,"
													+ "?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_PromotorID", Utileria.convierteEntero(promotor.getPromotorID()));
					sentenciaStore.setString("Par_NomPromotor", promotor.getNombrePromotor());
					sentenciaStore.setString("Par_NombCoordin", promotor.getNombreCoordinador());
					sentenciaStore.setString("Par_Telefono", promotor.getTelefono());
					sentenciaStore.setString("Par_Correo", promotor.getCorreo());

					sentenciaStore.setString("Par_Celular",promotor.getCelular());
					sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(promotor.getSucursalID()));
					sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(promotor.getUsuarioID()));
					sentenciaStore.setString("Par_NumEmpleado", promotor.getNumeroEmpleado());
					sentenciaStore.setString("Par_Estatus", promotor.getEstatus());

					sentenciaStore.setString("Par_ExtTelefonoPart", promotor.getExtTelefonoPart());
					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setString("Par_AplicaPromotor", promotor.getAplicaPromotor());

					sentenciaStore.setInt("Par_GestorID", Utileria.convierteEntero(promotor.getGestorID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID","PromotoresDAO.modificaPromotor");

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{

										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PromotoresDAO.modificaPromotor");
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
							throw new Exception(Constantes.MSG_ERROR + " .PromotoresDAO.modificaPromotor");
						}else if(mensajeBean.getNumero()!=0){

							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de promotor" + e);
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

	//consulta de Promotores
	public PromotoresBean consultaPrincipal(PromotoresBean promotor, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PROMOTORESCON(?,?,?,?,?	,?,?,?,?,?"
				+ "							,?);";
		Object[] parametros = {	Integer.parseInt(promotor.getPromotorID()),
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PromotoresDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESCON(" + Arrays.toString(parametros) + ")");

		PromotoresBean promotores = new PromotoresBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();

				promotores.setPromotorID(Utileria.completaCerosIzquierda(resultSet.getLong(1), 6));
				promotores.setNombrePromotor(resultSet.getString(2));
				promotores.setNombreCoordinador(resultSet.getString(3));
				promotores.setTelefono(resultSet.getString(4));
				promotores.setCorreo(resultSet.getString(5));
				promotores.setCelular(resultSet.getString(6));
				promotores.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getLong(7), 6));
				promotores.setUsuarioID(Utileria.completaCerosIzquierda(resultSet.getLong(8), 6));
				promotores.setNumeroEmpleado(resultSet.getString(9));
				promotores.setEstatus(resultSet.getString(10));
				promotores.setGestorID(resultSet.getString(11));
				promotores.setAplicaPromotor(resultSet.getString("AplicaPromotor"));
			    promotores.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
			    loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"extension"+resultSet.getString("ExtTelefonoPart")+"Estatus"+ resultSet.getString(10));
				return promotores;

			}
		});
		return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

	}

	//Consulta promotores foranea.
	public PromotoresBean consultaForanea(PromotoresBean promotor, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PROMOTORESCON(?,?,?,?,?	,?,?,?,?,?"
				+ "							,?);";
		Object[] parametros = {
								Integer.parseInt(promotor.getPromotorID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PromotoresDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO   };
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();
				promotores.setPromotorID(resultSet.getString(1));
				promotores.setNombrePromotor(resultSet.getString(2));
				promotores.setSucursalID(resultSet.getString(3));
				promotores.setEstatus(resultSet.getString(4));
				return promotores;

			}
		});
		return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

	}

	//Consulta para verificar la existencia de promotor activo.
	public PromotoresBean consultaTienePromAct(PromotoresBean promotor, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PROMOTORESCON(?,?,?,?,?	,?,?,?,?,?"
				+ "							,?);";
		Object[] parametros = {	Integer.parseInt(promotor.getPromotorID()),
			                	Integer.parseInt(promotor.getUsuarioID()),
			                	Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PromotoresDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();
				promotores.setEstatus(resultSet.getString(1));
				return promotores;

			}
		});
		return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

	}



	//consulta promotor con estatus = activo
	public PromotoresBean consultaProActivo(PromotoresBean promotor, int tipoConsulta) {
		String query = "call PROMOTORESCON(?,?,?,?,?	,?,?,?,?,?"
				+ "							,?);";
		Object[] parametros = {	Integer.parseInt(promotor.getPromotorID()),
				                Constantes.ENTERO_CERO,
				                Utileria.convierteEntero(promotor.getSucursalID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PromotoresDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESCON(" + Arrays.toString(parametros) + ")");

		PromotoresBean promotores = new PromotoresBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();

				promotores.setPromotorID(Utileria.completaCerosIzquierda(resultSet.getLong("PromotorID"), 6));
				promotores.setNombrePromotor(resultSet.getString("NombrePromotor"));
				promotores.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getLong("SucursalID"), 6));
				promotores.setEstatus(resultSet.getString("Estatus"));
				return promotores;

			}
		});
		return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

	}

	//Lista de Promotores
	public List listaPromotores(PromotoresBean promotores, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				promotores.getNombrePromotor(),
				Utileria.convierteEntero(promotores.getSucursalID()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PromotoresDAO.listaPromotores",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();
				promotores.setPromotorID(String.valueOf(resultSet.getInt(1)));;
				promotores.setNombrePromotor(resultSet.getString(2));
				return promotores;
			}
		});

		return matches;
	}

	public List listaPromotoresActivos(PromotoresBean promotores, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	promotores.getNombrePromotor(),
								Utileria.convierteEntero(promotores.getSucursalID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"PromotoresDAO.listaPromotores",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();
				promotores.setPromotorID(String.valueOf(resultSet.getInt(1)));;
				promotores.setNombrePromotor(resultSet.getString(2));
				promotores.setNombreSucursal(resultSet.getString(3));
				return promotores;
			}
		});

		return matches;
	}


	public List listaPromotores(int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO,
				                Constantes.FECHA_VACIA,
				                Constantes.STRING_VACIO,
				                "PromotoresDAO.consultaPrincipal",
				                Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();
				promotores.setPromotorID(String.valueOf(resultSet.getInt(1)));;
				promotores.setNombrePromotor(resultSet.getString(2));
				return promotores;
			}
		});

		return matches;
	}


	//Lista de Promotores que pertenecen a una Sucursal
	public List listaPromSucur(PromotoresBean promotores, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				promotores.getNombrePromotor(),
				Utileria.convierteEntero(promotores.getSucursalID()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"PromotoresDAO.listaPromotores",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();

				promotores.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));;
				promotores.setNombrePromotor(resultSet.getString("NombrePromotor"));
				promotores.setNombreSucursal(resultSet.getString("NombreSucurs"));

				return promotores;
			}
		});
		return matches;
		}

	//consulta para
		public PromotoresBean consultaTipoInstitucion(PromotoresBean promotor, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call TIPOSINSTITUCIONCON(?,?,?, ?,?,?,?,?,?);";
			ResultSet resultSet;
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"PromotoresDAO.consultaTipoInstitucion",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSINSTITUCIONCON(" + Arrays.toString(parametros) + ")");

			PromotoresBean promotores = new PromotoresBean();

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();

					promotores.setAplicaPromotor(resultSet.getString("AplicaPromotor"));
					return promotores;

				}
			});
			return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

		}

		//lista de promotores de captacion

		public List listaPromotoresCaptacion(PromotoresBean promotores, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					promotores.getNombrePromotor(),
					Utileria.convierteEntero(promotores.getSucursalID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PromotoresDAO.listaPromotores",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();

					promotores.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));;
					promotores.setNombrePromotor(resultSet.getString("NombrePromotor"));
					//promotores.setNombreSucursal(resultSet.getString("NombreSucurs"));

					return promotores;
				}
			});
			return matches;
			}


		public List listaPromotoresExterno(PromotoresBean promotores, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PROMOTOREXTERNOLIS(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					promotores.getNombre(),
					Utileria.convierteEntero(promotores.getNumero()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PromotoresDAO.listaPromotores",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTOREXTERNOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();

					promotores.setNumero(String.valueOf(resultSet.getInt("Numero")));;
					promotores.setNombre(resultSet.getString("Nombre"));
					//promotores.setNombreSucursal(resultSet.getString("NombreSucurs"));

					return promotores;
				}
			});
			return matches;
			}

		//Consulta para verificar la existencia de promotor activo.
		public PromotoresBean consultaPromotorCaptacion(PromotoresBean promotor, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call PROMOTORESCON(?,?,?,?,?, ?,?,?,?,?"
					+ "							,?);";
			Object[] parametros = {
									Utileria.convierteEntero(promotor.getPromotorID()),
									Utileria.convierteEntero(promotor.getSucursalID()),
									Utileria.convierteEntero(promotor.getUsuarioID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"PromotoresDAO.consultaSocioMenor",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();

					promotores.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));;
					promotores.setNombrePromotor(resultSet.getString("NombrePromotor"));
					promotores.setVarSucursalID(resultSet.getString("Var_SucursalID"));
					promotores.setVarPromotorID(resultSet.getString("Var_PromotorID"));

					return promotores;

				}
			});
			return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

		}

		public PromotoresBean consultaPromotorExterno(PromotoresBean promotor, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call PROMOTOREXTERNOCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(promotor.getNumero()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"PromotoresDAO.consultaExtSocioMenor",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTOREXTERNOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();

					promotores.setNumero(String.valueOf(resultSet.getInt("Numero")));;
					promotores.setNombre(resultSet.getString("Nombre"));
					promotores.setVarEstatus(resultSet.getString("Var_Estatus"));
					return promotores;

				}
			});
			return matches.size() > 0 ? (PromotoresBean) matches.get(0) : null;

		}


		//Lista de Promotores Activos para Solicitud de crédito
		public List listaPromotoresAct(PromotoresBean promotores, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PROMOTORESLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					promotores.getNombrePromotor(),
					Utileria.convierteEntero(promotores.getSucursalID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PromotoresDAO.listaPromotores",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PromotoresBean promotores = new PromotoresBean();
					promotores.setPromotorID(String.valueOf(resultSet.getInt(1)));;
					promotores.setNombrePromotor(resultSet.getString(2));
					return promotores;
				}
			});

			return matches;
		}




}

