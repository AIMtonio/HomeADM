package originacion.dao;
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

import originacion.bean.ClasificaTipDocBean;
import originacion.bean.SolicitudCreditoBean;
import soporte.bean.OrganoDecisionBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ClasificaTipDocDAO  extends BaseDAO{

	public ClasificaTipDocDAO(){
		super();
	}

	// Lista principal
		public List listaClasificacionTiposDoc(ClasificaTipDocBean 	clasificaTipDocBean, int tipoLista){
			List listaPrincipal = null;
			try{
				String query = "call CLASIFICATIPDOCLIS(?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
							Utileria.convierteEntero(clasificaTipDocBean.getClasificaTipDocID()),
							clasificaTipDocBean.getClasificaDesc(),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ClasificaTipDocDAO.listaClasificacionTiposDoc",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICATIPDOCLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClasificaTipDocBean clasificaTipDocBean = new ClasificaTipDocBean();

						clasificaTipDocBean.setClasificaTipDocID(resultSet.getString(1));
						clasificaTipDocBean.setClasificaDesc(resultSet.getString(2));


						return clasificaTipDocBean;
					}
				});
				listaPrincipal= matches;

			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de clasificacion tipo documento", e);
			}
			return listaPrincipal;
		}

		// Lista los Documentos por Clasificacion de Grid
		public List listaDocPorClas (int tipoLista, int clasificaDocID ){
			List listaPrincipal = null;
			try{
				String query = "call DOCPORCLASLIS(?,?,?,?,?	,?,?,?,?);";
				Object[] parametros = {
							clasificaDocID,
							tipoLista,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ClasificaTipDocDAO.listaClasificacionTiposDoc",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOCPORCLASLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClasificaTipDocBean docClasificaBean = new ClasificaTipDocBean();

						docClasificaBean.setClasDocID(resultSet.getString(1));
						docClasificaBean.setTipoDocID(resultSet.getString(2));
						docClasificaBean.setDescDocumento(resultSet.getString(3));

						return docClasificaBean;
					}
				});
				listaPrincipal= matches;

			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clasificacion por documentos", e);
			}
			return listaPrincipal;
		}

		// Lista para Grid de documentos Existentes
		public List listaClasificacionGrid(int tipoLista){
			List listaPrincipal = null;
			try{
				String query = "call CLASIFICATIPDOCLIS(?,?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {
							Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ClasificaTipDocDAO.listaClasificacionGrid",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICATIPDOCLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClasificaTipDocBean clasificaTipDocBean = new ClasificaTipDocBean();

						clasificaTipDocBean.setClasificaTipDocID(resultSet.getString(1));
						clasificaTipDocBean.setClasificaDesc(resultSet.getString(2));
						clasificaTipDocBean.setClasificaTipo(resultSet.getString(3));
						clasificaTipDocBean.setTipoGrupInd(resultSet.getString(4));
						clasificaTipDocBean.setGrupoAplica(resultSet.getString(5));
						clasificaTipDocBean.setEsGarantia(resultSet.getString(6));

						return clasificaTipDocBean;
					}
				});
				listaPrincipal= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de clasificacion de grid", e);
			}
			return listaPrincipal;
		}

		// Lista para Grid de documentos Existentes
				public List listaDocumentosGrid(int tipoLista, ClasificaTipDocBean clasificaTipDocBean){
					List listaPrincipal = null;
					try{
						String query = "call CLASIFICATIPDOCLIS(?,?,?,?,?,?,?,?,?,?);";
						Object[] parametros = {
									Constantes.ENTERO_CERO,
									clasificaTipDocBean.getClasificaDesc(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClasificaTipDocDAO.listaClasificacionGrid",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICATIPDOCLIS(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								ClasificaTipDocBean clasificaTipDocBean = new ClasificaTipDocBean();

								clasificaTipDocBean.setTipoDocID(resultSet.getString(1));
								clasificaTipDocBean.setDescDocumento(resultSet.getString(2));

								return clasificaTipDocBean;
							}
						});
						listaPrincipal= matches;
					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Clasificacion de Documentos de grid", e);
					}
					return listaPrincipal;
				}


		// Alta de Clasificación de Documentos
		public MensajeTransaccionBean altaClasificacionDoc(final ClasificaTipDocBean 	clasificaTipDocBean,final int tipoTransaccion) {
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
									String query = "call CLASIFICATIPDOCALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClasTipDocID",Utileria.convierteEntero(clasificaTipDocBean.getClasificaTipDocID()));
									sentenciaStore.setString("Par_ClasificaDesc",clasificaTipDocBean.getClasificaDesc());
									sentenciaStore.setString("Par_ClasificaTipo",clasificaTipDocBean.getClasificaTipo());
									sentenciaStore.setString("Par_TipoGrupInd",clasificaTipDocBean.getTipoGrupInd());
									sentenciaStore.setString("Par_GrupoAplica",clasificaTipDocBean.getGrupoAplica());
									sentenciaStore.setString("Par_EsGarantia",clasificaTipDocBean.getEsGarantia());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de clasificacion de documento", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// Modifica  Clasificación de Documentos
		public MensajeTransaccionBean modificaClasificacionDoc(final ClasificaTipDocBean 	clasificaTipDocBean) {
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
									String query = "call CLASIFICATIPDOCMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClasTipDocID",Utileria.convierteEntero(clasificaTipDocBean.getClasificaTipDocID()));
									sentenciaStore.setString("Par_ClasificaDesc",clasificaTipDocBean.getClasificaDesc());
									sentenciaStore.setString("Par_ClasificaTipo",clasificaTipDocBean.getClasificaTipo());
									sentenciaStore.setString("Par_TipoGrupInd",clasificaTipDocBean.getTipoGrupInd());
									sentenciaStore.setString("Par_GrupoAplica",clasificaTipDocBean.getGrupoAplica());
									sentenciaStore.setString("Par_EsGarantia",clasificaTipDocBean.getEsGarantia());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de clasificacion de documentos", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// Baja  Clasificación de Documentos
		public MensajeTransaccionBean bajaClasificacionDoc(final ClasificaTipDocBean 	clasificaTipDocBean,final int tipoBaja) {
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
									String query = "call CLASIFICATIPDOCBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClasTipDocID",Utileria.convierteEntero(clasificaTipDocBean.getClasificaTipDocID()));
									sentenciaStore.setString("Par_ClasificaDesc",clasificaTipDocBean.getClasificaDesc());
									sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de clasificacion de documentos", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



		// Consuta Principal de la clasificación Tipos de Documentos
		public ClasificaTipDocBean consultaPrincipal(final ClasificaTipDocBean 	clasificaTipDocBean, int tipoConsulta) {
			List matches= null;
			try{
			String query = "call CLASIFICATIPDOCCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	clasificaTipDocBean.getClasificaTipDocID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClasificaTipDocDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICATIPDOCCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClasificaTipDocBean clasificaTipDoc = new ClasificaTipDocBean();

					clasificaTipDoc.setClasificaTipDocID(resultSet.getString(1));
					clasificaTipDoc.setClasificaDesc(resultSet.getString(2));
					clasificaTipDoc.setClasificaTipo(resultSet.getString(3));
					clasificaTipDoc.setTipoGrupInd(resultSet.getString(4));
					clasificaTipDoc.setGrupoAplica(resultSet.getString(5));
					clasificaTipDoc.setEsGarantia(resultSet.getString(6));

					return clasificaTipDoc;
				}
			});
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de clasificacion", e);
			}
			return matches.size() > 0 ? (ClasificaTipDocBean) matches.get(0) : null;
		}

		public ClasificaTipDocBean consultaDocumentos(final ClasificaTipDocBean 	clasificaTipDocBean, int tipoConsulta) {
			List matches= null;
			try{
			String query = "call CLASIFICATIPDOCCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	clasificaTipDocBean.getClasificaTipDocID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ClasificaTipDocDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLASIFICATIPDOCCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClasificaTipDocBean clasificaTipDoc = new ClasificaTipDocBean();

					clasificaTipDoc.setClasDocID(resultSet.getString(1));
					clasificaTipDoc.setDescDocumento(resultSet.getString(2));

					return clasificaTipDoc;
				}
			});
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de clasificacion", e);
			}
			return matches.size() > 0 ? (ClasificaTipDocBean) matches.get(0) : null;
		}

		//Metodo de alta de proyeccion de indicadores
				public MensajeTransaccionBean grabaListaClasDoc( final int clasDocID, final List listaParametros) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();

					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								ClasificaTipDocBean clasificaTipDocBean;
									mensajeBean= bajaClasificaDoc(clasDocID);

									if(listaParametros.size()>0){
										for(int i=0; i < listaParametros.size(); i++){
											clasificaTipDocBean = new ClasificaTipDocBean();
											clasificaTipDocBean = (ClasificaTipDocBean) listaParametros.get(i);

											// alta de proyeccion
											mensajeBean= altaClasificaDoc(clasDocID, clasificaTipDocBean);
											if(mensajeBean.getNumero()!=0){
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									 }else{
										mensajeBean.setDescripcion("Lista de Clasificación de Documentos esta Vacía");
										throw new Exception(mensajeBean.getDescripcion());
									}

							} catch (Exception e) {
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Alta de Clasificación de Documentos", e);
								if(mensajeBean.getNumero()==0){
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

		//Alta de Documentos por Clasificacion
		public MensajeTransaccionBean altaClasificaDoc(final int clasDocID, final ClasificaTipDocBean clasificaTipDocBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call CLASIFICADOCUMENTOSALT(" +
											"?,?,?,?,?,  ?,?,?,?,?," +
											"?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_clasDocID",clasDocID);
										sentenciaStore.setInt("Par_tipoDocID",Utileria.convierteEntero(clasificaTipDocBean.getTipoDocID()));

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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClasificaTipDocDAO.altaClasificaDoc");
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
								throw new Exception(Constantes.MSG_ERROR + " .ClasificaTipDocDAO.altaClasificaDoc");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Documentos" + e);
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

		//Alta de Documentos por Clasificacion
				public MensajeTransaccionBean bajaClasificaDoc(final int clasDocID) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								// Query con el Store Procedure
								mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query = "call CLASIFICADOCUMENTOSBAJ(" +
													"?,?,?,?,?,  ?,?,?,?,?," +
													"?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

												sentenciaStore.setInt("Par_clasDocID",clasDocID);

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
													mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClasificaTipDocDAO.bajaClasificaDoc");
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
										throw new Exception(Constantes.MSG_ERROR + " .ClasificaTipDocDAO.bajaClasificaDoc");
									}else if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								} catch (Exception e) {
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Documentos" + e);
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