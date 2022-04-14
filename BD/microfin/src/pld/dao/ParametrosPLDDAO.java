package pld.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.ParametrosPLDBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ParametrosPLDDAO extends BaseDAO{

	public ParametrosPLDDAO() {
		// TODO Auto-generated constructor stub
	}

	/* Alta de Parámetros Transferencias internacionales del Fondos */
	public MensajeTransaccionBean altaParametrosLimites(final ParametrosPLDBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSPLDALT(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_ClaveEntCasfim", paramPLDBean.getClaveEntCasfim());
							sentenciaStore.setString("Par_ClaveOrgSupervisor", paramPLDBean.getClaveOrgSupervisor());
							sentenciaStore.setString("Par_ClaveOrgSupervisorExt", paramPLDBean.getClaveOrgSupervisorExt());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosPLDDAO.altaParametrosLimites");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosPLDDAO.altaParametrosLimites");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parametros de limites", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de Parámetros Transferencias internacionales del Fondos */
	public MensajeTransaccionBean modificaParametrosLimites(final ParametrosPLDBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSPLDMOD(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(paramPLDBean.getFolioID()));
							sentenciaStore.setString("Par_ClaveEntCasfim", paramPLDBean.getClaveEntCasfim());
							sentenciaStore.setString("Par_ClaveOrgSupervisor", paramPLDBean.getClaveOrgSupervisor());
							sentenciaStore.setString("Par_ClaveOrgSupervisorExt", paramPLDBean.getClaveOrgSupervisorExt());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosPLDDAO.modificaParametrosLimites");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosPLDDAO.modificaParametrosLimites");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros de limites", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Baja de Parámetros Transferencias internacionales del Fondos */
	public MensajeTransaccionBean bajaParametrosLimites(final ParametrosPLDBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSPLDBAJ(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(paramPLDBean.getFolioID()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosPLDDAO.bajaParametrosLimites");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosPLDDAO.bajaParametrosLimites");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros de limites", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consuta Parametros PLD folio vigente*/
	public ParametrosPLDBean consultaPrincipal(ParametrosPLDBean paramPLD, int tipoConsulta) {
		ParametrosPLDBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSPLDCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(paramPLD.getFolioID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,

									Constantes.STRING_VACIO,
									"ParametrosPLDDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSPLDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosPLDBean parametrosPLD = new ParametrosPLDBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setClaveEntCasfim(resultSet.getString("ClaveEntCasfim"));
					parametrosPLD.setClaveOrgSupervisor(resultSet.getString("ClaveOrgSupervisor"));
					parametrosPLD.setClaveOrgSupervisorExt(resultSet.getString("ClaveOrgSupervisorExt"));
					parametrosPLD.setFechaVigencia(resultSet.getString("FechaVigencia"));
					parametrosPLD.setEstatus(resultSet.getString("Estatus"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParametrosPLDBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}

	/* Consuta Parametros PLD por folio*/
	public ParametrosPLDBean consultaPorFolio(ParametrosPLDBean paramPLD, int tipoConsulta) {
		ParametrosPLDBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSPLDCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(paramPLD.getFolioID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,

									Constantes.STRING_VACIO,
									"ParametrosPLDDAO.consultaPorFolio",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSPLDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosPLDBean parametrosPLD = new ParametrosPLDBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setClaveEntCasfim(resultSet.getString("ClaveEntCasfim"));
					parametrosPLD.setClaveOrgSupervisor(resultSet.getString("ClaveOrgSupervisor"));
					parametrosPLD.setClaveOrgSupervisorExt(resultSet.getString("ClaveOrgSupervisorExt"));
					parametrosPLD.setFechaVigencia(resultSet.getString("FechaVigencia"));
					parametrosPLD.setEstatus(resultSet.getString("Estatus"));

					parametrosPLD.setFolioVigente(resultSet.getString("FolioVigente"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParametrosPLDBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}

	/* Consuta Parametros PLD por folio*/
	public ParametrosPLDBean consultaExisteFolio(ParametrosPLDBean paramPLD, int tipoConsulta) {
		ParametrosPLDBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSPLDCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(paramPLD.getFolioID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,

									Constantes.STRING_VACIO,
									"ParametrosPLDDAO.consultaExisteFolio",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSPLDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosPLDBean parametrosPLD = new ParametrosPLDBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setFolioVigente(resultSet.getString("FolioVigente"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParametrosPLDBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);
		}
		return paramPLDBean;
	}

	/* Consuta Los montos limites para operaciones en efectivo del folio vigente*/
	public ParametrosPLDBean consultaMontosLimite(ParametrosPLDBean paramPLD, int tipoConsulta) {
		ParametrosPLDBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSPLDCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,

									Constantes.STRING_VACIO,
									"ParametrosPLDDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSPLDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosPLDBean parametrosPLD = new ParametrosPLDBean();

					parametrosPLD.setMontoLimEfecF(resultSet.getString("MontoLimEfecF"));
					parametrosPLD.setMontoLimEfecM(resultSet.getString("MontoLimEfecM"));
					parametrosPLD.setMontoLimEfecMes(resultSet.getString("MontoLimEfecMes"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParametrosPLDBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}


}
