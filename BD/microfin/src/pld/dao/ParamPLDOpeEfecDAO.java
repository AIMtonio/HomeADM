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

import pld.bean.ParamPLDOpeEfecBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParamPLDOpeEfecDAO extends BaseDAO{

	public ParamPLDOpeEfecDAO() {
		// TODO Auto-generated constructor stub
	}

	/* Alta de Parámetros Transferencias internacionales del Fondos */
	public MensajeTransaccionBean altaParametrosLimites(final ParamPLDOpeEfecBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMPLDOPEEFECALT(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_MontoRemesaUno", paramPLDBean.getMontoRemesaUno());
							sentenciaStore.setString("Par_MontoRemesaDos", paramPLDBean.getMontoRemesaDos());
							sentenciaStore.setString("Par_MontoRemesaTres", paramPLDBean.getMontoRemesaTres());
							sentenciaStore.setInt("Par_RemesaMonedaID", Utileria.convierteEntero(paramPLDBean.getRemesaMonedaID()));
							sentenciaStore.setString("Par_MontoLimEfecF", paramPLDBean.getMontoLimEfecF());

							sentenciaStore.setString("Par_MontoLimEfecM", paramPLDBean.getMontoLimEfecM());
							sentenciaStore.setString("Par_MontoLimEfecMes", paramPLDBean.getMontoLimEfecMes());
							sentenciaStore.setInt("Par_MontoLimMonedaID", Utileria.convierteEntero(paramPLDBean.getMontoLimMonedaID()));
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
	public MensajeTransaccionBean modificaParametrosLimites(final ParamPLDOpeEfecBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMPLDOPEEFECMOD(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(paramPLDBean.getFolioID()));;
							sentenciaStore.setString("Par_MontoRemesaUno", paramPLDBean.getMontoRemesaUno());
							sentenciaStore.setString("Par_MontoRemesaDos", paramPLDBean.getMontoRemesaDos());
							sentenciaStore.setString("Par_MontoRemesaTres", paramPLDBean.getMontoRemesaTres());
							sentenciaStore.setInt("Par_RemesaMonedaID", Utileria.convierteEntero(paramPLDBean.getRemesaMonedaID()));

							sentenciaStore.setString("Par_MontoLimEfecF", paramPLDBean.getMontoLimEfecF());
							sentenciaStore.setString("Par_MontoLimEfecM", paramPLDBean.getMontoLimEfecM());
							sentenciaStore.setString("Par_MontoLimEfecMes", paramPLDBean.getMontoLimEfecMes());
							sentenciaStore.setInt("Par_MontoLimMonedaID", Utileria.convierteEntero(paramPLDBean.getMontoLimMonedaID()));
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
	public MensajeTransaccionBean bajaParametrosLimites(final ParamPLDOpeEfecBean paramPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMPLDOPEEFECBAJ(?,?,?,?,?,"
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
	public ParamPLDOpeEfecBean consultaPrincipal(ParamPLDOpeEfecBean paramPLD, int tipoConsulta) {
		ParamPLDOpeEfecBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMPLDOPEEFECCON(?,?,?,?,?,?,?,?,?);";
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMPLDOPEEFECCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamPLDOpeEfecBean parametrosPLD = new ParamPLDOpeEfecBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setMontoRemesaUno(resultSet.getString("MontoRemesaUno"));
					parametrosPLD.setMontoRemesaDos(resultSet.getString("MontoRemesaDos"));
					parametrosPLD.setMontoRemesaTres(resultSet.getString("MontoRemesaTres"));
					parametrosPLD.setMontoLimPagoRem(resultSet.getString("MontoLimPagoRem"));

					parametrosPLD.setRemesaMonedaID(resultSet.getString("RemesaMonedaID"));
					parametrosPLD.setMontoLimEfecF(resultSet.getString("MontoLimEfecF"));
					parametrosPLD.setMontoLimEfecM(resultSet.getString("MontoLimEfecM"));
					parametrosPLD.setMontoLimEfecMes(resultSet.getString("MontoLimEfecMes"));
					parametrosPLD.setMontoLimMonedaID(resultSet.getString("MontoLimMonedaID"));

					parametrosPLD.setFechaVigencia(resultSet.getString("FechaVigencia"));
					parametrosPLD.setEstatus(resultSet.getString("Estatus"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParamPLDOpeEfecBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}

	/* Consuta Parametros PLD por folio*/
	public ParamPLDOpeEfecBean consultaPorFolio(ParamPLDOpeEfecBean paramPLD, int tipoConsulta) {
		ParamPLDOpeEfecBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMPLDOPEEFECCON(?,?,?,?,?,?,?,?,?);";
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMPLDOPEEFECCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamPLDOpeEfecBean parametrosPLD = new ParamPLDOpeEfecBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setMontoRemesaUno(resultSet.getString("MontoRemesaUno"));
					parametrosPLD.setMontoRemesaDos(resultSet.getString("MontoRemesaDos"));
					parametrosPLD.setMontoRemesaTres(resultSet.getString("MontoRemesaTres"));
					parametrosPLD.setMontoLimPagoRem(resultSet.getString("MontoLimPagoRem"));

					parametrosPLD.setRemesaMonedaID(resultSet.getString("RemesaMonedaID"));
					parametrosPLD.setMontoLimEfecF(resultSet.getString("MontoLimEfecF"));
					parametrosPLD.setMontoLimEfecM(resultSet.getString("MontoLimEfecM"));
					parametrosPLD.setMontoLimEfecMes(resultSet.getString("MontoLimEfecMes"));
					parametrosPLD.setMontoLimMonedaID(resultSet.getString("MontoLimMonedaID"));

					parametrosPLD.setFechaVigencia(resultSet.getString("FechaVigencia"));
					parametrosPLD.setEstatus(resultSet.getString("Estatus"));

					parametrosPLD.setFolioVigente(resultSet.getString("FolioVigente"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParamPLDOpeEfecBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}

	/* Consuta Parametros PLD por folio*/
	public ParamPLDOpeEfecBean consultaExisteFolio(ParamPLDOpeEfecBean paramPLD, int tipoConsulta) {
		ParamPLDOpeEfecBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMPLDOPEEFECCON(?,?,?,?,?,?,?,?,?);";
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMPLDOPEEFECCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamPLDOpeEfecBean parametrosPLD = new ParamPLDOpeEfecBean();
					parametrosPLD.setFolioID(resultSet.getString("FolioID"));
					parametrosPLD.setFolioVigente(resultSet.getString("FolioVigente"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParamPLDOpeEfecBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);
		}
		return paramPLDBean;
	}

	/* Consuta Los montos limites para operaciones en efectivo del folio vigente*/
	public ParamPLDOpeEfecBean consultaMontosLimite(ParamPLDOpeEfecBean paramPLD, int tipoConsulta) {
		ParamPLDOpeEfecBean paramPLDBean = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMPLDOPEEFECCON(?,?,?,?,?,?,?,?,?);";
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMPLDOPEEFECCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamPLDOpeEfecBean parametrosPLD = new ParamPLDOpeEfecBean();

					parametrosPLD.setMontoLimEfecF(resultSet.getString("MontoLimEfecF"));
					parametrosPLD.setMontoLimEfecM(resultSet.getString("MontoLimEfecM"));
					parametrosPLD.setMontoLimEfecMes(resultSet.getString("MontoLimEfecMes"));

					return parametrosPLD;
				}
			});
			paramPLDBean= matches.size() > 0 ? (ParamPLDOpeEfecBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de parameros de PLD", e);

		}
		return paramPLDBean;
	}


}
