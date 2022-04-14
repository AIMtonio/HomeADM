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

import operacionesPDA.beanWS.request.SP_PDA_Segmentos_DescargaRequest;
import operacionesPDA.beanWS.request.SP_PDA_Socios_DescargaRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.GruposNosolidariosBean;

public class GruposNosolidariosDAO extends BaseDAO{

	/* Alta Grupo */
public MensajeTransaccionBean altaGrupo(final GruposNosolidariosBean gruposNosolidariosBean) {
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
									String query = "call GRUPOSNOSOLIDARIOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_NombreGrupo",gruposNosolidariosBean.getNombreGrupo());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(gruposNosolidariosBean.getSucursalID()));
									sentenciaStore.setInt("Par_NumIntegrantes",Utileria.convierteEntero(gruposNosolidariosBean.getNumIntegrantes()));
									sentenciaStore.setInt("Par_PromotorID",Utileria.convierteEntero(gruposNosolidariosBean.getPromotorID()));
									sentenciaStore.setString("Par_LugarReunion",gruposNosolidariosBean.getLugarReunion());

									sentenciaStore.setString("Par_DiaReunion",gruposNosolidariosBean.getDiaReunion());
									sentenciaStore.setString("Par_HoraReunion",gruposNosolidariosBean.getHoraReunion());
									sentenciaStore.setDouble("Par_AhoObligatorio",Utileria.convierteDoble(gruposNosolidariosBean.getAhoObligatorio()));
									sentenciaStore.setString("Par_PlazoCredito",gruposNosolidariosBean.getPlazoCredito());
									sentenciaStore.setDouble("Par_CostoAusencia",Utileria.convierteDoble(gruposNosolidariosBean.getCostoAusencia()));

									sentenciaStore.setDouble("Par_AhorroCompro",Utileria.convierteDoble(gruposNosolidariosBean.getAhorroCompro()));
									sentenciaStore.setDouble("Par_MoraCredito",Utileria.convierteDoble(gruposNosolidariosBean.getMoraCredito()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(gruposNosolidariosBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(gruposNosolidariosBean.getMunicipioID()));
									sentenciaStore.setString("Par_Ubicacion",gruposNosolidariosBean.getUbicacion());

									sentenciaStore.setString("Par_Estatus",gruposNosolidariosBean.getEstatus());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							throw new Exception(Constantes.MSG_ERROR + " .GruposNoSolidariosDAO.altaGrupo");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Grupo" + e);
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
/*Modificacion Grupo*/
public MensajeTransaccionBean modificaGrupo(final GruposNosolidariosBean gruposNosolidariosBean) {
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
									String query = "call GRUPOSNOSOLIDARIOSMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_GrupoID",Utileria.convierteLong(gruposNosolidariosBean.getGrupoID()));
									sentenciaStore.setString("Par_NombreGrupo",gruposNosolidariosBean.getNombreGrupo());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(gruposNosolidariosBean.getSucursalID()));
									sentenciaStore.setInt("Par_NumIntegrantes",Utileria.convierteEntero(gruposNosolidariosBean.getNumIntegrantes()));
									sentenciaStore.setInt("Par_PromotorID",Utileria.convierteEntero(gruposNosolidariosBean.getPromotorID()));

									sentenciaStore.setString("Par_LugarReunion",gruposNosolidariosBean.getLugarReunion());
									sentenciaStore.setString("Par_DiaReunion",gruposNosolidariosBean.getDiaReunion());
									sentenciaStore.setString("Par_HoraReunion",gruposNosolidariosBean.getHoraReunion());
									sentenciaStore.setDouble("Par_AhoObligatorio",Utileria.convierteDoble(gruposNosolidariosBean.getAhoObligatorio()));
									sentenciaStore.setString("Par_PlazoCredito",gruposNosolidariosBean.getPlazoCredito());

									sentenciaStore.setDouble("Par_CostoAusencia",Utileria.convierteDoble(gruposNosolidariosBean.getCostoAusencia()));
									sentenciaStore.setDouble("Par_AhorroCompro",Utileria.convierteDoble(gruposNosolidariosBean.getAhorroCompro()));
									sentenciaStore.setDouble("Par_MoraCredito",Utileria.convierteDoble(gruposNosolidariosBean.getMoraCredito()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(gruposNosolidariosBean.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(gruposNosolidariosBean.getMunicipioID()));

									sentenciaStore.setString("Par_Ubicacion",gruposNosolidariosBean.getUbicacion());


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							throw new Exception(Constantes.MSG_ERROR + " .GruposNoSolidariosDAO.modificaGrupo");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Grupo" + e);
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

/* Consuta Grupo*/
public GruposNosolidariosBean consultaGrupo(GruposNosolidariosBean gruposNosolidariosBean, int tipoConsulta) {
	GruposNosolidariosBean gruposNosolidarios = null;
try{
	//Query con el Store Procedure
	String query = "call GRUPOSNOSOLIDARIOSCON(?,?,?,?,?,?,?,?,?);";
	Object[] parametros = {	gruposNosolidariosBean.getGrupoID(),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ClienteDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
						};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSNOSOLIDARIOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			GruposNosolidariosBean gruposNosolidarios = new GruposNosolidariosBean();
			gruposNosolidarios.setGrupoID(resultSet.getString("GrupoID"));
			gruposNosolidarios.setNombreGrupo(resultSet.getString("NombreGrupo"));
			gruposNosolidarios.setSucursalID(resultSet.getString("SucursalID"));
			gruposNosolidarios.setNumIntegrantes(resultSet.getString("NumIntegrantes"));
			gruposNosolidarios.setPromotorID(resultSet.getString("PromotorID"));
			gruposNosolidarios.setLugarReunion(resultSet.getString("LugarReunion"));
			gruposNosolidarios.setDiaReunion(resultSet.getString("DiaReunion"));
			gruposNosolidarios.setHoraReunion(resultSet.getString("HoraReunion"));
			gruposNosolidarios.setAhoObligatorio(resultSet.getString("AhoObligatorio"));
			gruposNosolidarios.setPlazoCredito(resultSet.getString("PlazoCredito"));
			gruposNosolidarios.setCostoAusencia(resultSet.getString("CostoAusencia"));
			gruposNosolidarios.setAhorroCompro(resultSet.getString("AhorroCompro"));
			gruposNosolidarios.setMoraCredito(resultSet.getString("MoraCredito"));
			gruposNosolidarios.setEstadoID(resultSet.getString("EstadoID"));
			gruposNosolidarios.setMunicipioID(resultSet.getString("MunicipioID"));
			gruposNosolidarios.setUbicacion(resultSet.getString("Ubicacion"));
			gruposNosolidarios.setEstatus(resultSet.getString("Estatus"));



			return gruposNosolidarios;

				}
	});
	gruposNosolidarios= matches.size() > 0 ? (GruposNosolidariosBean) matches.get(0) : null;
}catch(Exception e){

	e.printStackTrace();
	loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

}
return gruposNosolidarios;
}



/* lista Grupos*/
public List listaPrincipal(GruposNosolidariosBean bean,int tipoLista){
	List gruposLis = null;
	try{
		String query = "call GRUPOSNOSOLIDARIOSLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								bean.getSucursal(),
								bean.getNombreGrupo(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposNosolidariosDAO.listaGrupos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSNOSOLIDARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				GruposNosolidariosBean grupo = new GruposNosolidariosBean();

				grupo.setGrupoID(resultSet.getString("GrupoID"));
				grupo.setNombreGrupo(resultSet.getString("NombreGrupo"));

				return grupo;
			}
		});

		gruposLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grupos", e);
	}
	return gruposLis;
}
/* lista Grupos*/
public List listaReporte(GruposNosolidariosBean bean){
	List gruposLis = null;
	try{
		String query = "call GRUPOSNOSOLREP(?,?,?,?,?,  ?,?,?,?,?,?);";
		Object[] parametros = {
								bean.getGrupoIni(),
								bean.getGrupoFin(),
								bean.getPromotorIni(),
								bean.getPromotorFin(),
								bean.getSucursal(),


								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposNosolidariosDAO.listaGrupos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSNOSOLREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				GruposNosolidariosBean grupo = new GruposNosolidariosBean();

				grupo.setClienteID(resultSet.getString("ClienteID"));
				grupo.setNombreCompleto(resultSet.getString("NombreCompleto"));
				grupo.setTipoIntegrante(resultSet.getString("TipoIntegrantes"));
				grupo.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
				grupo.setGrupoID(resultSet.getString("GrupoID"));
				grupo.setNombreGrupo(resultSet.getString("NombreGrupo"));
				grupo.setPromotorID(resultSet.getString("PromotorID"));
				grupo.setNombrePromotor(resultSet.getString("NombrePromotor"));
				grupo.setSucursalID(resultSet.getString("SucursalID"));
				grupo.setNombreSucursal(resultSet.getString("NombreSucurs"));
				grupo.setAhorro(resultSet.getString("Ahorro"));
				grupo.setExigibleDia(resultSet.getString("ExigDia"));
				grupo.setTotalDia(resultSet.getString("TotalDia"));
				grupo.setHoraEmision(resultSet.getString("HoraEmision"));

				return grupo;
			}
		});

		gruposLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de grupo no solidarios", e);
	}
	return gruposLis;
}

/* lista los grupos no solidarios que se encuentren activos par WS*/
public List listaGruposWS(SP_PDA_Segmentos_DescargaRequest bean,int tipoLista){
	List gruposLis = null;
	try{
		String query = "call GRUPOSNOSOLIDARIOSLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								Utileria.convierteEntero(bean.getId_Sucursal()),
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposNosolidariosDAO.listaGruposWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSNOSOLIDARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				GruposNosolidariosBean grupo = new GruposNosolidariosBean();

				grupo.setGrupoID(resultSet.getString("Id_Segmento"));
				grupo.setNombreGrupo(resultSet.getString("descSegmento"));

				return grupo;
			}
		});

		gruposLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grupos no solidarios para WS", e);
	}
	return gruposLis;
}// fin de lista para WS

/* lista de socios que pertenecen a un grupo no solidario para WS*/
public List listaSociosWS(SP_PDA_Socios_DescargaRequest bean,int tipoLista){
	List sociosLis = null;
	try{
		String query = "call GRUPOSNOSOLIDARIOSLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
		Object[] parametros = {	Utileria.convierteLong(bean.getId_Segmento()),
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposNosolidariosDAO.listaSociosWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSNOSOLIDARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				GruposNosolidariosBean socio = new GruposNosolidariosBean();

				socio.setNumSocio(resultSet.getString("NumSocio"));
				socio.setNombre(resultSet.getString("Nombre"));
				socio.setApPaterno(resultSet.getString("ApPaterno"));
				socio.setApMaterno(resultSet.getString("ApMaterno"));
				socio.setFecNacimiento(resultSet.getString("FecNacimiento"));
				socio.setRfc(resultSet.getString("Rfc"));

				return socio;
			}
		});

		sociosLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de socios que pertenecen a un grupo no solidario para WS", e);
	}
	return sociosLis;
}// fin de lista para WS

}
