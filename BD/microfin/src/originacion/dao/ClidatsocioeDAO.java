package originacion.dao;
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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.CatdatsocioeBean;
import originacion.bean.ClidatsocioeBean;
import originacion.bean.GarantiaBean;
import soporte.bean.ParametrosCajaBean;


public class ClidatsocioeDAO extends BaseDAO{
	public int mensajeExito=0;
	public ClidatsocioeDAO() {
		super();
	}

	// metodo de alta de datos socioeconomicos
	public MensajeTransaccionBean altaDatosSocioeconomicos(final ClidatsocioeBean clidatsocioeBean, final Long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CLIDATSOCIOEALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_LinNegID",Utileria.convierteEntero(clidatsocioeBean.getLinNegID()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(clidatsocioeBean.getProspectoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(clidatsocioeBean.getClienteID()));
									sentenciaStore.setInt("Par_SolicCreID",Utileria.convierteEntero(clidatsocioeBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_CatSocioEID",Utileria.convierteEntero(clidatsocioeBean.getCatSocioEID()));
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(clidatsocioeBean.getMonto()));
									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(clidatsocioeBean.getFechaRegistro()));


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos socioeconomicos", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	// Metodo que llama el alta, baja y paso a historico de los datos socioeconomicos del cliente o prospecto
		public MensajeTransaccionBean grabaDatosSocioecoDetalles(final ClidatsocioeBean clidatsocioeBean, final List detalleSocioeconomicos) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();

					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					MensajeTransaccionBean mensajeBeanHis = new MensajeTransaccionBean();
					MensajeTransaccionBean mensajeBeanBaj = new MensajeTransaccionBean();
					try {
						ClidatsocioeBean clidatsocioe = null;

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean = validaDatosSocioeconomicos(clidatsocioeBean,numTransacc);
						if(mensajeBean.getNumero() == mensajeExito ){
								for(int i=0; i<detalleSocioeconomicos.size(); i++){
									clidatsocioe = (ClidatsocioeBean)detalleSocioeconomicos.get(i);
										mensajeBean = procesoAltaDatosSocioeconomicos(clidatsocioe,numTransacc);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

							}else{

							throw new Exception(mensajeBean.getDescripcion());
						}


					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar datos socioeconomicos", e);
					}
					return mensajeBean;
				}

/*Metodo para validar los datos socioeconomicos del cliente */
		public MensajeTransaccionBean validaDatosSocioeconomicos(final ClidatsocioeBean clidatsocioeBean, final Long numTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									int numValidacion = 2;
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

										String query = "call CLIDATSOCIOEVAL(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_LinNegID",Utileria.convierteEntero(clidatsocioeBean.getLinNegID()));
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(clidatsocioeBean.getClienteID()));
										sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(clidatsocioeBean.getProspectoID()));
										sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(clidatsocioeBean.getFechaRegistro()));
										sentenciaStore.setInt("Par_TipoVal",numValidacion);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en paso historico socioeconomico", e);

						}
						return mensajeBean;
					}
				});
				return mensaje;
			}


		// metodo de baja de datos socioeconomicos
				public MensajeTransaccionBean bajaDatosSocioeconomicos(final ClidatsocioeBean clidatsocioeBean, final Long numTransaccion) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

												String query = "call CLIDATSOCIOEBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_LinNeg",Utileria.convierteEntero(clidatsocioeBean.getLinNegID()));
												sentenciaStore.setInt("Par_Prospecto",Utileria.convierteEntero(clidatsocioeBean.getProspectoID()));
												sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero(clidatsocioeBean.getClienteID()));
												sentenciaStore.setInt("Par_SocioEID",Utileria.convierteEntero(clidatsocioeBean.getSocioEID()));

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
												sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
												sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeBean.setDescripcion(e.getMessage());
									transaction.setRollbackOnly();
									e.printStackTrace();
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de datos socioeconomico", e);
								}
								return mensajeBean;
							}
						});
						return mensaje;
					}



				public MensajeTransaccionBean procesoAltaDatosSocioeconomicos(final ClidatsocioeBean clidatsocioeBean, final Long numTransaccion) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

												String query = "call CLIDATSOCIOEPRO(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_LinNegID",Utileria.convierteEntero(clidatsocioeBean.getLinNegID()));
												sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(clidatsocioeBean.getProspectoID()));
												sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(clidatsocioeBean.getClienteID()));
												sentenciaStore.setInt("Par_SolicCreID",Utileria.convierteEntero(clidatsocioeBean.getSolicitudCreditoID()));
												sentenciaStore.setInt("Par_CatSocioEID",Utileria.convierteEntero(clidatsocioeBean.getCatSocioEID()));
												sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(clidatsocioeBean.getMonto()));
												sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(clidatsocioeBean.getFechaRegistro()));
												sentenciaStore.setInt("Par_SocioEID",Utileria.convierteEntero(clidatsocioeBean.getSocioEID()));

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
												sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
												sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
									mensajeBean.setDescripcion(e.getMessage());
									transaction.setRollbackOnly();
									e.printStackTrace();
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de datos socioeconomicos", e);
								}
								return mensajeBean;
							}
						});
						return mensaje;
					}


	/* Consuta Principal datos socioeconomicos */
	public ClidatsocioeBean consultaPrincipal(ClidatsocioeBean clidatsocioeBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {//	solicitudCredito.getSolicitudCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClidatsocioeBean clidatsocioeBean = new ClidatsocioeBean();
				/*solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setMonedaID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(5)));		*/

				return clidatsocioeBean;

			}
		});

		return matches.size() > 0 ? (ClidatsocioeBean) matches.get(0) : null;
	}





	/* Consuta los Ingresos y Egresos de un cliente */
	public ClidatsocioeBean consultaForanea(ClidatsocioeBean clidatsocioeBean, int tipoConsulta) {
		String query = "call CLIDATSOCIOECON(?,?,?,?,?,   ?,?,?,?,?,  ?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(clidatsocioeBean.getClienteID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,


								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClidatsocioeBean clidatsocioeBean = new ClidatsocioeBean();
				clidatsocioeBean.setIngresos(resultSet.getString("Ingresos"));
				clidatsocioeBean.setEgresos(resultSet.getString("Egresos"));

				return clidatsocioeBean;

			}
		});

		return matches.size() > 0 ? (ClidatsocioeBean) matches.get(0) : null;
	}





	public List listaDatosSocioeconomicosPantalla(ClidatsocioeBean clidatsocioeBean, int tipoLista){

		String query = "call CLIDATSOCIOELIS(?,?,?,?,?,?,  ?,?,?,?,? ,?,?);";
		Object[] parametros = {

					Utileria.convierteEntero(clidatsocioeBean.getLinNegID()),
					Utileria.convierteEntero(clidatsocioeBean.getClienteID()),
					Utileria.convierteEntero(clidatsocioeBean.getProspectoID()),
					clidatsocioeBean.getTipoPersona(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatdatsocioeBean catdatsocioeBean = new CatdatsocioeBean();
				catdatsocioeBean.setCatSocioEID(resultSet.getString(1));
				catdatsocioeBean.setDescripcion(resultSet.getString(2));
				catdatsocioeBean.setTipo(resultSet.getString(3));
				catdatsocioeBean.setMonto(resultSet.getString(4));
				return catdatsocioeBean;

			}
		});
		return matches;
		}

	public List listaGastosPasivos(ClidatsocioeBean clidatsocioeBean, int tipoLista){
		String query = "call CLIDATSOCIOELIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {

					Utileria.convierteEntero(clidatsocioeBean.getLinNegID()),
					Utileria.convierteEntero(clidatsocioeBean.getClienteID()),
					Utileria.convierteEntero(clidatsocioeBean.getProspectoID()),
					clidatsocioeBean.getTipoPersona(),
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClidatsocioeBean clidatsocio = new ClidatsocioeBean();
				clidatsocio.setCatSocioEID(resultSet.getString("CatSocioEID"));
				clidatsocio.setDescripcion(resultSet.getString("Descripcion"));
				clidatsocio.setTipo(resultSet.getString("Tipo"));
				clidatsocio.setMonto(resultSet.getString("Monto"));
				return clidatsocio;

			}
		});
		return matches;
		}


	public List listaDatosSocioeconomicosporCteProspec(ClidatsocioeBean clidatsocioeBean, int tipoLista){

		List listaResultado=null;
				try{


		String query = "call CLIDATSOCIOELIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {

					Utileria.convierteEntero(clidatsocioeBean.getLinNegID()),
					Utileria.convierteEntero(clidatsocioeBean.getClienteID()),
					Utileria.convierteEntero(clidatsocioeBean.getProspectoID()),
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClidatsocioeBean clidatsocioeBean = new ClidatsocioeBean();
				clidatsocioeBean.setSocioEID(resultSet.getString(1));
				clidatsocioeBean.setLinNegID(resultSet.getString(2));
				clidatsocioeBean.setProspectoID(resultSet.getString(3));
				clidatsocioeBean.setClienteID(resultSet.getString(4));
				clidatsocioeBean.setSolicitudCreditoID(resultSet.getString(5));
				clidatsocioeBean.setCatSocioEID(resultSet.getString(6));
				clidatsocioeBean.setMonto(resultSet.getString(7));
				clidatsocioeBean.setFechaRegistro(resultSet.getString(8));
				clidatsocioeBean.setTipoDatoSocioe(resultSet.getString(9));
				return clidatsocioeBean;

			}
		});listaResultado= matches;

				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de datos socioeconomico", e);
				}
				return listaResultado;
		}

	/* Consulta usada en la pantalla de ratios */
	public ClidatsocioeBean consultaDatoSocioEconomico(ClidatsocioeBean clidatsocioeBean, int tipoConsulta) {
		String query = "call CLIDATSOCIOECON(?,?,	 ?,?,?,?,?,?,?,  ?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(clidatsocioeBean.getClienteID()),
								Utileria.convierteEntero(clidatsocioeBean.getProspectoID()),
								Utileria.convierteEntero(clidatsocioeBean.getSolicitudCreditoID()),
								Utileria.convierteEntero(clidatsocioeBean.getCatSocioEID()),


								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClidatsocioeBean clidatsocioeBean = new ClidatsocioeBean();

				clidatsocioeBean.setMontoAlimentacion(resultSet.getString("MontoAlimentacion"));
				clidatsocioeBean.setEgresosPasivos(resultSet.getString("EgresosPasivos"));
				clidatsocioeBean.setIngresos(resultSet.getString("Ingresos"));
				clidatsocioeBean.setEgresos(resultSet.getString("Egresos"));

				return clidatsocioeBean;

			}
		});

		return matches.size() > 0 ? (ClidatsocioeBean) matches.get(0) : null;
	}


	/*lista para obtener los gastos alimenticios*/

	public List listaGastoAlimenticio(ClidatsocioeBean clidatsocioeBean, int tipoLista) {
		String query = "call CLIDATSOCIOELIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									clidatsocioeBean.getDescripcion(),
									tipoLista,


									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO
									};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOELIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosCajaBean gastoAlimenticio = new ParametrosCajaBean();
				gastoAlimenticio.setCatSocioEID(resultSet.getString("CatSocioEID"));
				gastoAlimenticio.setDescripcion(resultSet.getString("Descripcion"));
				return gastoAlimenticio;
			}
		});

		return matches;
	}


	/*llena combo de gastos */

	public List ComboGastos(ClidatsocioeBean clidatsocioeBean, int tipoLista) {
		String query = "call CLIDATSOCIOELIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									tipoLista,


									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO
									};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIDATSOCIOELIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosCajaBean gastoAlimenticio = new ParametrosCajaBean();
				gastoAlimenticio.setCatSocioEID(resultSet.getString("CatSocioEID"));
				gastoAlimenticio.setDescripcion(resultSet.getString("Descripcion"));
				return gastoAlimenticio;
			}
		});

		return matches;
	}











}
