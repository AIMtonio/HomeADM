package soporte.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


import org.springframework.jdbc.core.JdbcTemplate;

import soporte.bean.CompaniaBean;
import soporte.bean.CompaniasBean;
import soporte.bean.UsuarioBean;

public class CompaniasDAO extends BaseDAO{

	public CompaniasDAO() {
		super();
	}



	public MensajeTransaccionBean altaCompania(final  CompaniasBean compania) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call COMPANIASALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt(	 "Par_CompaniaID",		 compania.getCompaniaID());
								sentenciaStore.setString("Par_RazonSocial",		 compania.getRazonSocial());
								sentenciaStore.setString("Par_DireccionCompleta",compania.getDireccionCompleta());
								sentenciaStore.setString("Par_OrigenDatos",		 compania.getOrigenDatos());
								sentenciaStore.setString("Par_Prefijo",			 compania.getPrefijo());

								sentenciaStore.setString("Par_MostrarPrefijo",	 compania.getMostrarPrefijo());
								sentenciaStore.setString("Par_Desplegado",		 compania.getDesplegado());
								sentenciaStore.setString("Par_Subdominio",		 compania.getSubdominio());


								sentenciaStore.setString("Par_Salida",			Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt(	"Par_EmpresaID",			parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt(	"Aud_Usuario", 				parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate(	"Aud_FechaActual", 			parametrosAuditoriaBean.getFecha());

								sentenciaStore.setString(	"Aud_DireccionIP",		parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString(	"Aud_ProgramaID",		parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt(		"Aud_Sucursal",			parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong(		"Aud_NumTransaccion",	parametrosAuditoriaBean.getNumeroTransaccion());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Compañias", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean modificaCompania(final CompaniasBean compania)  {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call COMPANIASMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt(	 "Par_CompaniaID",		 compania.getCompaniaID());
									sentenciaStore.setString("Par_RazonSocial",		 compania.getRazonSocial());
									sentenciaStore.setString("Par_DireccionCompleta",compania.getDireccionCompleta());
									sentenciaStore.setString("Par_OrigenDatos",		 compania.getOrigenDatos());
									sentenciaStore.setString("Par_Prefijo",			 compania.getPrefijo());

									sentenciaStore.setString("Par_MostrarPrefijo",	 compania.getMostrarPrefijo());
									sentenciaStore.setString("Par_Desplegado",		 compania.getDesplegado());
									sentenciaStore.setString("Par_Subdominio",		 compania.getSubdominio());


									sentenciaStore.setString("Par_Salida",			Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt(	"Par_EmpresaID",			parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt(	"Aud_Usuario", 				parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate(	"Aud_FechaActual", 			parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString(	"Aud_DireccionIP",		parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString(	"Aud_ProgramaID",		parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt(		"Aud_Sucursal",			parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong(		"Aud_NumTransaccion",	parametrosAuditoriaBean.getNumeroTransaccion());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificación de Compañias", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	//Lista de Plazos para Combo Box
	public List listaCombo(CompaniasBean companiasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call COMPANIASLIS(?,?,?,?,? ,?,?,?,?);";
		Object[] parametros = {	tipoLista,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMPANIASLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CompaniasBean companiasBean = new CompaniasBean();
				companiasBean.setDesplegado(resultSet.getString("Desplegado"));
				companiasBean.setOrigenDatos(resultSet.getString("OrigenDatos"));
				return companiasBean;
			}
		});

		return matches;
	}


	//Lista de Plazos para Combo Box
	public CompaniasBean principal(CompaniasBean companiasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call COMPANIASCON(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {	companiasBean.getCompaniaID(),
								tipoLista,
								Constantes.STRING_VACIO,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("principal-"+"call COMPANIASCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CompaniasBean companiasBean = new CompaniasBean();
				companiasBean.setCompaniaID(resultSet.getInt("CompaniaID"));
				companiasBean.setRazonSocial(resultSet.getString("RazonSocial"));
				companiasBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				companiasBean.setOrigenDatos(resultSet.getString("OrigenDatos"));
				companiasBean.setPrefijo(resultSet.getString("Prefijo"));
				companiasBean.setMostrarPrefijo(resultSet.getString("mostrarPrefijo"));
				companiasBean.setDesplegado(resultSet.getString("Desplegado"));
				companiasBean.setSubdominio(resultSet.getString("Subdominio"));
				return companiasBean;
			}
		});

		return  matches.size() > 0 ? (CompaniasBean) matches.get(0) : null;
	}


	public CompaniasBean conPrefijo(CompaniasBean companiasBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call COMPANIASCON(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getOrigenDatos(),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("principal-"+"call COMPANIASCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CompaniasBean companiasBean = new CompaniasBean();
				companiasBean.setPrefijo(resultSet.getString("Prefijo"));
				companiasBean.setDesplegado(resultSet.getString("Desplegado"));

				return companiasBean;
			}
		});

		return  matches.size() > 0 ? (CompaniasBean) matches.get(0) : null;
	}

	public List listaPrincipal(CompaniasBean compania, int tipoLista) {
		//Query con el Store Procedure
		String query = "call COMPANIASLIS(?,?,?,?,?  ,?,?,?,?);";
		Object[] parametros = {tipoLista,
								compania.getRazonSocial(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMPANIASLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CompaniasBean compania = new CompaniasBean();
				compania.setCompaniaID(resultSet.getInt(1));
				compania.setRazonSocial(resultSet.getString(2));
				return compania;
			}
		});
		return matches;
	}


	/* Consulta de Usuario: Para Pantalla de Login */
	public CompaniaBean consultaPorClave(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		CompaniaBean companiaBean = null;
		String query = "call COMPANIACON(?,?,?,?,?,	?,?,?);";
		Object[] parametros = {	tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,

								"UsuarioDAO.consultaPorClave",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(usuarioBean.getOrigenDatos()+"-"+"call COMPANIACON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CompaniaBean companiaBean = new CompaniaBean();
					companiaBean.setNombre(resultSet.getString("Nombre"));
					companiaBean.setLogoCtePantalla(resultSet.getString("LogoCtePantalla"));
					return companiaBean;
				}
			});

			companiaBean = matches.size() > 0 ? (CompaniaBean) matches.get(0) : null;
			companiaBean.setOrigenDatos(usuarioBean.getOrigenDatos());

		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de logo", e);
		}


		return companiaBean;

	}


}
