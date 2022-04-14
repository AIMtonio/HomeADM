package soporte.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ParametrosSisBean;
import soporte.bean.TiposDocumentosBean;

public class TiposDocumentosDAO extends BaseDAO {

	public TiposDocumentosDAO() {
		super();
	}
		String SalidaPantalla="S";

	/* Consulta de Operacion de Escalamimento Interno */
	public TiposDocumentosBean consultaDescripcion(final TiposDocumentosBean tiposDocumentosBean,
																	 final int tipoConsulta) {
		TiposDocumentosBean TiposDocBean;


		try {

		//Query con el Store Procedure
			TiposDocBean = (TiposDocumentosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TIPOSDOCUMENTOSCON(?,?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(tiposDocumentosBean.getTipoDocumentoID()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaDescripcion");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								TiposDocumentosBean tiposDocuBean = new TiposDocumentosBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									tiposDocuBean.setDescripcion(resultadosStore.getString(1));
								}
								return tiposDocuBean;
							}
						});
			return TiposDocBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de descripcion", e);
			return null;
		}
	}

	//TIPOS DOCUMENTOS A MOSTRAR EN LA LISTA
	public List listaDocumentoFirma(TiposDocumentosBean tiposDocumentos, int tipoLista) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();

			//Query con el Store Procedure
		String query = "call TIPOSDOCUMENTOSLIS(?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				tiposDocumentos.getTipoDocumentoID(),
				tiposDocumentos.getRequeridoEn(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposDocumentosDAO.listaDocumentosFirma",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};


			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDOCUMENTOSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					parametrosSisBean.setDescripcionDoc(resultSet.getString("Descripcion"));

					return parametrosSisBean;

				}// trows ecexeption
			});//lista

		return matches;
	}

	//Lista de Tipos de Documentos
	public List listaTiposDocumentos(TiposDocumentosBean tiposDocumentos, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSDOCUMENTOSLIS(?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tiposDocumentos.getRequeridoEn(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposDocumentosDAO.listaTiposDocumentos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDOCUMENTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposDocumentosBean tiposDocumentosBean = new TiposDocumentosBean();
				tiposDocumentosBean.setTipoDocumentoID(String.valueOf(resultSet.getInt(1)));;
				tiposDocumentosBean.setDescripcion(resultSet.getString(2));
				return tiposDocumentosBean;
			}
		});
		return matches;
	}

	/* Alta de Tipos de Documentos */
	public MensajeTransaccionBean alta(final TiposDocumentosBean tiposDocumentosBean) {
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
									String query = "call TIPOSDOCUMENTOSALT	(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(tiposDocumentosBean.getTipoDocumentoID()));
									sentenciaStore.setString("Par_Descripcion",tiposDocumentosBean.getDescripcion());
									sentenciaStore.setString("Par_RequeridoEn",tiposDocumentosBean.getRequeridoEn());
									sentenciaStore.setString("Par_Estatus",tiposDocumentosBean.getEstatus());

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",SalidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaTiposDocumentos");
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
							throw new Exception(Constantes.MSG_ERROR + " .ClientesDAO.altaTiposDocumentos");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Captura de Tipo de Documentos" + e);
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


	/* Modifica  Tipos de Documentos */
	public MensajeTransaccionBean modifica(final TiposDocumentosBean tiposDocumentosBean) {
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
									String query = "call TIPOSDOCUMENTOSMOD	(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(tiposDocumentosBean.getTipoDocumentoID()));
									sentenciaStore.setString("Par_Descripcion",tiposDocumentosBean.getDescripcion());
									sentenciaStore.setString("Par_RequeridoEn",tiposDocumentosBean.getRequeridoEn());
									sentenciaStore.setString("Par_Estatus",tiposDocumentosBean.getEstatus());


									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",SalidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposDocumentosDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .TiposDocumentosDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Tipo de Documentos" + e);
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

	//Lista de Tipos de Documentos Principal
	public List listaPrincipal(TiposDocumentosBean tiposDocumentos, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSDOCUMENTOSLIS(?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {

				tiposDocumentos.getDescripcion(),
				Constantes.STRING_VACIO,
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposDocumentosDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSDOCUMENTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TiposDocumentosBean tiposDocumentosBean = new TiposDocumentosBean();
				tiposDocumentosBean.setTipoDocumentoID(String.valueOf(resultSet.getInt(1)));;
				tiposDocumentosBean.setDescripcion(resultSet.getString(2));
				return tiposDocumentosBean;
			}
		});
		return matches;
	}



	/* Consulta Principal */
	public TiposDocumentosBean consultaPrincipal(final TiposDocumentosBean tiposDocumentosBean,
																	 final int tipoConsulta) {
		TiposDocumentosBean TiposDocBean;
		try {

		//Query con el Store Procedure
			TiposDocBean = (TiposDocumentosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TIPOSDOCUMENTOSCON(?,?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(tiposDocumentosBean.getTipoDocumentoID()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","consultaDescripcion");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								TiposDocumentosBean tiposDocuBean = new TiposDocumentosBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									tiposDocuBean.setTipoDocumentoID(resultadosStore.getString(1));
									tiposDocuBean.setDescripcion(resultadosStore.getString(2));
									tiposDocuBean.setRequeridoEn(resultadosStore.getString(3));
									tiposDocuBean.setEstatus(resultadosStore.getString(4));
								}
								return tiposDocuBean;
							}
						});
			return TiposDocBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta Principal", e);
			return null;
		}
	}


	/* Modifica  Tipos de Documentos */
	public MensajeTransaccionBean elimina(final TiposDocumentosBean tiposDocumentosBean) {
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
									String query = "call TIPOSDOCUMENTOSBAJ	(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(tiposDocumentosBean.getTipoDocumentoID()));

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",SalidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposDocumentosDAO.elimina");
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
							throw new Exception(Constantes.MSG_ERROR + " .TiposDocumentosDAO.elimina");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Tipo de Documentos" + e);
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

	public MensajeTransaccionBean consultaAlerta(final TiposDocumentosBean tiposDocumentosBean, final int numConsulta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDDOCUMENTOSEXPIRACON("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?);";//parametros de auditoria
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(tiposDocumentosBean.getClienteID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(tiposDocumentosBean.getUsuario()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(tiposDocumentosBean.getSucursal()));
							sentenciaStore.setInt("Par_NumCon", numConsulta);
							sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Utileria.convierteFecha(Constantes.FECHA_VACIA));
							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);

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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TiposDocumentosDAO.consultaAlerta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Consulta de Alerta" + e);
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

}
