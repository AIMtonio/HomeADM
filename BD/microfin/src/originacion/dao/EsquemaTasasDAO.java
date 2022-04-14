package originacion.dao;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.EsquemaTasasBean;

public class EsquemaTasasDAO  extends BaseDAO{

	public EsquemaTasasDAO() {
		super();
	}

	// Alta de Esquema de Tasas
		public MensajeTransaccionBean altaEsquemaTasas(final EsquemaTasasBean esquemaTasasBean) {
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
									String query = "call ESQUEMATASASALT(" +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(esquemaTasasBean.getSucursalID()));
									sentenciaStore.setInt("Par_ProdCreID",Utileria.convierteEntero(esquemaTasasBean.getProductoCreditoID()));
									sentenciaStore.setInt("Par_MinCredito",Utileria.convierteEntero(esquemaTasasBean.getMinCredito()));
									sentenciaStore.setInt("Par_MaxCredito",Utileria.convierteEntero(esquemaTasasBean.getMaxCredito()));
									sentenciaStore.setString("Par_Califi",(esquemaTasasBean.getCalificacion()));

									sentenciaStore.setDouble("Par_MontoInf",Utileria.convierteDoble(esquemaTasasBean.getMontoInferior()));
									sentenciaStore.setDouble("Par_MontoSup",Utileria.convierteDoble(esquemaTasasBean.getMontoSuperior()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(esquemaTasasBean.getTasaFija()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(esquemaTasasBean.getSobreTasa()));
									sentenciaStore.setString("Par_PlazoID",(esquemaTasasBean.getPlazoID()));

									sentenciaStore.setInt("Par_InstitNominaID",(Utileria.convierteEntero(esquemaTasasBean.getInstitNominaID())));
									sentenciaStore.setInt("Par_NivelID",Utileria.convierteEntero(esquemaTasasBean.getNivelID()));

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
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call error en alta de esquema de tasas", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		/*Modificacion de esquema de tasas*/
		public MensajeTransaccionBean modificaEsquemaTasas(final EsquemaTasasBean esquemaTasasBean) {
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
									String query = "call ESQUEMATASASMOD(" +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?,?,?,?,       " +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(esquemaTasasBean.getSucursalID()));
									sentenciaStore.setInt("Par_ProdCreID",Utileria.convierteEntero(esquemaTasasBean.getProductoCreditoID()));
									sentenciaStore.setInt("Par_MinCredito",Utileria.convierteEntero(esquemaTasasBean.getMinCredito()));
									sentenciaStore.setInt("Par_MaxCredito",Utileria.convierteEntero(esquemaTasasBean.getMaxCredito()));
									sentenciaStore.setString("Par_Califi",(esquemaTasasBean.getCalificacion()));

									sentenciaStore.setDouble("Par_MontoInf",Utileria.convierteDoble(esquemaTasasBean.getMontoInferior()));
									sentenciaStore.setDouble("Par_MontoSup",Utileria.convierteDoble(esquemaTasasBean.getMontoSuperior()));
									sentenciaStore.setString("Par_PlazoID",(esquemaTasasBean.getPlazoID()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(esquemaTasasBean.getTasaFija()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(esquemaTasasBean.getSobreTasa()));

									sentenciaStore.setInt("Par_InstitNominaID",(Utileria.convierteEntero(esquemaTasasBean.getInstitNominaID())));
									sentenciaStore.setInt("Par_NivelID",Utileria.convierteEntero(esquemaTasasBean.getNivelID()));

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
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de esquema de tasas", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		// Elimina  Esquema de Tasas
		public MensajeTransaccionBean eliminaEsquemaTasas(final EsquemaTasasBean esquemaTasasBean) {
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
											String query = "call ESQUEMATASASBAJ(" +
													"?,?,?,?,?,     " +
													"?,?,?,?,?,     " +
													"?,?,?,?,?,     " +
													"?,?,?,?,?,     "
													+ "?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(esquemaTasasBean.getSucursalID()));
											sentenciaStore.setInt("Par_ProdCreID",Utileria.convierteEntero(esquemaTasasBean.getProductoCreditoID()));
											sentenciaStore.setInt("Par_MinCredito",Utileria.convierteEntero(esquemaTasasBean.getMinCredito()));
											sentenciaStore.setInt("Par_MaxCredito",Utileria.convierteEntero(esquemaTasasBean.getMaxCredito()));
											sentenciaStore.setString("Par_Califi",(esquemaTasasBean.getCalificacion()));

											sentenciaStore.setDouble("Par_MontoInf",Utileria.convierteDoble(esquemaTasasBean.getMontoInferior()));
											sentenciaStore.setDouble("Par_MontoSup",Utileria.convierteDoble(esquemaTasasBean.getMontoSuperior()));
											sentenciaStore.setString("Par_PlazoID",(esquemaTasasBean.getPlazoID()));
											sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(esquemaTasasBean.getTasaFija()));
											sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(esquemaTasasBean.getSobreTasa()));

											sentenciaStore.setInt("Par_InstitNominaID",(Utileria.convierteEntero(esquemaTasasBean.getInstitNominaID())));
											sentenciaStore.setInt("Par_NivelID",(Utileria.convierteEntero(esquemaTasasBean.getNivelID())));

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
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en eliminacion de esquema de tasas", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}

	/**
	 * Consulta el esquema de tasas de un producto de crédito
	 * @param esquemaTasasBean Bean EsquemaTasasBean
	 * @param tipoConsulta Consulta Principal
	 * @return
	 */
	public EsquemaTasasBean consultaPrincipal(EsquemaTasasBean esquemaTasasBean, int tipoConsulta) {
		// Query con el Store Procedure

		String query = "call ESQUEMATASASCON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(esquemaTasasBean.getSucursalID()),
				Utileria.convierteEntero(esquemaTasasBean.getProductoCreditoID()),
				Utileria.convierteEntero(esquemaTasasBean.getMinCredito()),
				Utileria.convierteEntero(esquemaTasasBean.getMaxCredito()),
				esquemaTasasBean.getCalificacion(),

				Utileria.convierteDoble(esquemaTasasBean.getMontoInferior()),
				Utileria.convierteDoble(esquemaTasasBean.getMontoSuperior()),
				esquemaTasasBean.getPlazoID(),
				Utileria.convierteDoble(esquemaTasasBean.getTasaFija()),
				Utileria.convierteDoble(esquemaTasasBean.getSobreTasa()),

				Utileria.convierteEntero(esquemaTasasBean.getInstitNominaID()),
				Utileria.convierteEntero(esquemaTasasBean.getNivelID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ESQUEMATASASCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaTasasBean esquemaTasasBean = new EsquemaTasasBean();
				esquemaTasasBean.setSucursalID(String.valueOf(resultSet.getInt("SucursalID")));
				esquemaTasasBean.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				esquemaTasasBean.setMinCredito(String.valueOf(resultSet.getInt("MinCredito")));
				esquemaTasasBean.setMaxCredito(String.valueOf(resultSet.getInt("MaxCredito")));
				esquemaTasasBean.setCalificacion(resultSet.getString("Calificacion"));
				esquemaTasasBean.setMontoInferior(resultSet.getString("MontoInferior"));
				esquemaTasasBean.setMontoSuperior(resultSet.getString("MontoSuperior"));
				esquemaTasasBean.setPlazoID(resultSet.getString("PlazoID"));
				esquemaTasasBean.setTasaFija(String.valueOf(resultSet.getDouble("TasaFija")));
				esquemaTasasBean.setSobreTasa(String.valueOf(resultSet.getDouble("SobreTasa")));
				esquemaTasasBean.setInstitNominaID(String.valueOf(resultSet.getInt("InstitNominaID")));
				esquemaTasasBean.setNombreInst(String.valueOf(resultSet.getString("NombreInstit")));
				esquemaTasasBean.setNivelID(String.valueOf(resultSet.getString("NivelID")));
				return esquemaTasasBean;

			}
		});

		return matches.size() > 0 ? (EsquemaTasasBean) matches.get(0) : null;
	}


	/* Consuta Solicitud de credito para el alta de credito*/
	public List consultaListaPrincipal(EsquemaTasasBean esquemaTasasBean, int tipoLista) {
		//Query con el Store Procedure
		List listaResultado = null;
		try{
		String query = "call ESQUEMATASASLIS(?,?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(esquemaTasasBean.getSucursalID()),
								Utileria.convierteEntero(esquemaTasasBean.getProductoCreditoID()),
								Utileria.convierteDoble(esquemaTasasBean.getMontoInferior()),
								esquemaTasasBean.getCalificacion(),
								esquemaTasasBean.getPlazoID(),

								Utileria.convierteDoble(esquemaTasasBean.getTasaFija()),
								Utileria.convierteEntero(esquemaTasasBean.getInstitNominaID()),
 								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMATASASLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaTasasBean esquemaTasasBean = new EsquemaTasasBean();

				esquemaTasasBean.setSucursalID(String.valueOf(resultSet.getInt("SucursalID")));
				esquemaTasasBean.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				esquemaTasasBean.setMinCredito(String.valueOf(resultSet.getInt("MinCredito")));
				esquemaTasasBean.setMaxCredito(String.valueOf(resultSet.getInt("MaxCredito")));
				esquemaTasasBean.setCalificacion(resultSet.getString("Calificacion"));

				esquemaTasasBean.setMontoInferior(resultSet.getString("MontoInferior"));
				esquemaTasasBean.setMontoSuperior(resultSet.getString("MontoSuperior"));
				esquemaTasasBean.setPlazoID(resultSet.getString("PlazoID"));
				esquemaTasasBean.setTasaFija(String.valueOf(resultSet.getDouble("TasaFija")));
				esquemaTasasBean.setSobreTasa(String.format("%.4f",resultSet.getDouble("SobreTasa")));

				esquemaTasasBean.setInstitNominaID(String.valueOf(resultSet.getInt("InstitNominaID")));
				esquemaTasasBean.setNombreInst(String.valueOf(resultSet.getString("NombreInst")));
				esquemaTasasBean.setDescripcionNivel(resultSet.getString("DescripcionNivel"));
				esquemaTasasBean.setNivelID(resultSet.getString("NivelID"));
				esquemaTasasBean.setCalcInt(resultSet.getString("CalcInteres"));

				return esquemaTasasBean;
			}
		});

		listaResultado = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error consulta de lista principal", e);
			listaResultado=null;
		}

		return listaResultado;
	}

}
