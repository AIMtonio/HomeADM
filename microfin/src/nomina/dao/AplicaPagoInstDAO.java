package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
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

import nomina.bean.AplicaPagoInstBean;
import nomina.bean.InstitucionNominaBean;
import nomina.bean.PagoNominaBean;
import tesoreria.bean.TiposMovTesoBean;

public class AplicaPagoInstDAO extends BaseDAO{
	public AplicaPagoInstDAO() {
		super();
	}

	private static interface Enum_Act_PagoNomina{
		int cancelarPagos=1;
		int pagosMasivos = 2;
		int pagoIndividual = 3;
	}

	/* Alta de aplicación de pagos de instituciones */
	public MensajeTransaccionBean altaPagosInstituciones(final AplicaPagoInstBean pagoInstBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APLICAPAGOINSTALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstNominaID",Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_NumFolio",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(pagoInstBean.getFechaInicio()));
									sentenciaStore.setString("Par_FechaFin",Utileria.convierteFecha(pagoInstBean.getFechaFin()));
									sentenciaStore.setString("Par_FechaDesc",Utileria.convierteFecha(pagoInstBean.getFechaDescuento()));

									sentenciaStore.setDouble("Par_MontoTotDesc",Utileria.convierteDoble(pagoInstBean.getMontoTotalDesc()));
									sentenciaStore.setString("Par_EstPagoDesc",pagoInstBean.getEstatusPagoDesc());
									sentenciaStore.setString("Par_EstPagoInst",pagoInstBean.getEstatusPagoInst());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));
									sentenciaStore.setLong("Par_NumCuenta",Utileria.convierteLong(pagoInstBean.getNumCuenta()));

									sentenciaStore.setString("Par_MovConciliado",pagoInstBean.getMovConciliado());
									sentenciaStore.setDouble("Par_MontoPagoInst",Utileria.convierteDoble(pagoInstBean.getMontoPagoInst()));
									sentenciaStore.setString("Par_FechaPagoInst",Utileria.convierteFecha(pagoInstBean.getFechaPagoInst()));
									sentenciaStore.setDouble("Par_TotalPagos",Utileria.convierteDoble(pagoInstBean.getTotalPagos()));

									//Parametros de OutPut
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
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;


								} //public sql exception
							} // new CallableStatementCreator
							,new CallableStatementCallback() {
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
								}// public
							}// CallableStatementCallback
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de aplicación pagos institución", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}//catch
				return mensajeBean;
			} //public Object doInTransaction
		}); //men
		return mensaje;
	}

	// Lista para para mostrar folios de pago de  instituciones
		public List listaPrincipal(AplicaPagoInstBean aplicaPagoBean, int tipoLista) {
			List listaPagosNomina=null;
			try{
			String query = "call APLICAPAGOINSTLIS(?,?,?,?, ?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									aplicaPagoBean.getInstitNominaID(),
									aplicaPagoBean.getFechaInicio(),
									aplicaPagoBean.getFechaFin(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AplicaPagoInstDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					AplicaPagoInstBean listaPagos = new AplicaPagoInstBean();

					listaPagos.setFolioNum(resultSet.getString("FolioNominaID"));
					listaPagos.setFechaPagoInst(resultSet.getString("FechaPagoIns"));
					listaPagos.setEstatusPagoInst(resultSet.getString("Estatus"));

					return listaPagos;
				}
			});

			listaPagosNomina= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de pagos institución", e);
			}
			return listaPagosNomina;

			}

// Lista para el grid de Aplicacion de Pagos de institucion
	public List listaPagosGrid(AplicaPagoInstBean aplicaPagoBean, int tipoLista) {
		List listaPagosNomina=null;
		try{
		String query = "call APLICAPAGOINSTLIS(?,?,?,?, ?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								aplicaPagoBean.getNumFolio(),
								aplicaPagoBean.getInstitNominaID(),
								Constantes.FECHA_VACIA,
								Constantes.FECHA_VACIA,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AplicaPagoInstDAO.listaPagosGrid",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				AplicaPagoInstBean listaPagos = new AplicaPagoInstBean();
				listaPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
				listaPagos.setFolioNum(resultSet.getString("FolioNum"));
				listaPagos.setCreditoID(resultSet.getString("CreditoID"));
				listaPagos.setClienteID(resultSet.getString("ClienteID"));
				listaPagos.setNomEmpleado(resultSet.getString("NomEmpleado"));
				listaPagos.setMontoPagos(resultSet.getString("MontoPagos"));
				listaPagos.setProductoCredito(resultSet.getString("ProductoCredito"));
				listaPagos.setEsSeleccionado(resultSet.getString("EsSeleccionado"));
				listaPagos.setEsAplicado(resultSet.getString("EsAplicado"));
				return listaPagos;
			}
		});

		listaPagosNomina= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de pagos institución", e);
		}
		return listaPagosNomina;

		}

	// Lista para el grid de Importar Creditos No Aplicados
		public List listaImportCreditosGrid(AplicaPagoInstBean aplicaPagoBean, int tipoLista) {
			List listaPagosNomina=null;
			try{
			String query = "call APLICAPAGOINSTLIS(?,?,?,?, ?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									aplicaPagoBean.getNumFolio(),
									aplicaPagoBean.getInstitNominaID(),
									Constantes.FECHA_VACIA,
									Constantes.FECHA_VACIA,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AplicaPagoInstDAO.listaPagosGrid",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					AplicaPagoInstBean listaPagos = new AplicaPagoInstBean();
					listaPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
					listaPagos.setFolioNum(resultSet.getString("FolioNum"));
					listaPagos.setCreditoID(resultSet.getString("CreditoID"));
					listaPagos.setClienteID(resultSet.getString("ClienteID"));
					listaPagos.setNomEmpleado(resultSet.getString("NomEmpleado"));
					listaPagos.setMontoPagos(resultSet.getString("MontoPagos"));
					listaPagos.setProductoCredito(resultSet.getString("ProductoCredito"));
					listaPagos.setEsSeleccionado(resultSet.getString("EsSeleccionado"));
					return listaPagos;
				}
			});

			listaPagosNomina= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de pagos institución", e);
			}
			return listaPagosNomina;

			}
   // metodo para aplicar los pagos de instituciones
   public MensajeTransaccionBean realizarPagosCredito(final AplicaPagoInstBean gridPagosInstBean,final AplicaPagoInstBean pagoInstBean,
		   												final long numTransaccion, final int numeroPoliza){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call APLICAPAGOINSTPRO(?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_FolioNominaID",Utileria.convierteEntero(gridPagosInstBean.getFolioNum()));
								sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
								sentenciaStore.setInt("Par_EmpresaNominaID",Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(gridPagosInstBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(gridPagosInstBean.getClienteID()));
								sentenciaStore.setString("Par_NomEmpleado", gridPagosInstBean.getNomEmpleado());
								sentenciaStore.setDouble("Par_MontoPago",Utileria.convierteDoble(gridPagosInstBean.getMontoPagos()));
								sentenciaStore.setString("Par_ProductoCredito",gridPagosInstBean.getProductoCredito());

								sentenciaStore.setString("Par_FechaPagoDesc",Utileria.convierteFecha(pagoInstBean.getFechaDescuento()));
								sentenciaStore.setDouble("Par_MontoTotDesc",Utileria.convierteDoble(pagoInstBean.getMontoTotalDesc()));
								sentenciaStore.setString("Par_EstPagoDesc",pagoInstBean.getEstatusPagoDesc());
								sentenciaStore.setString("Par_EstPagoInst",pagoInstBean.getEstatusPagoInst());
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));

								sentenciaStore.setLong("Par_NumCuenta",Utileria.convierteLong(pagoInstBean.getNumCuenta()));
								sentenciaStore.setString("Par_MovConciliado",pagoInstBean.getMovConciliado());
								sentenciaStore.setDouble("Par_MontoPagoInst",Utileria.convierteDoble(pagoInstBean.getMontoPagoInst()));
								sentenciaStore.setString("Par_FechaPagoInst",Utileria.convierteFecha(pagoInstBean.getFechaPagoInst()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.setLong("Par_Poliza",Constantes.ENTERO_CERO);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

								 }else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aplicación pagos institución DAO", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

// Metodo para reversar los pagos de instituciones
   public MensajeTransaccionBean reversarPagosInst(final AplicaPagoInstBean pagoInstBean,
		   										final long numTransaccion, final int tipoAct){
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
	   public Object doInTransaction(TransactionStatus transaction) {
		 MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		    try {
				// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				 new CallableStatementCreator() {
				  public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call APLICAPAGOINSTACT(?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?);";
					   CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_FolioNominaID",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
						sentenciaStore.setInt("Par_EmpresaNominaID", Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
						sentenciaStore.setLong("Par_CreditoID", Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);

						sentenciaStore.setDouble("Par_MontoPago",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_TipoAct",tipoAct);
						sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));
						sentenciaStore.setString("Par_NumCuenta",pagoInstBean.getNumCuenta());
						sentenciaStore.setInt("Par_TipoMovID",Utileria.convierteEntero(pagoInstBean.getMovConciliado()));

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

								 mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								 mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								 mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								 mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

							}else{
							     mensajeTransaccion.setNumero(999);
								 mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							}
							 return mensajeTransaccion;
							}
						});
					  if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							mensajeBean.setNombreControl(Constantes.STRING_VACIO);
							mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						}else if(mensajeBean.getNumero()!=0){
							mensajeBean.setNumero(mensajeBean.getNumero());
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
							mensajeBean.setNombreControl(mensajeBean.getNombreControl());
							mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion(e.getMessage());
						}else{
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						}
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la reversa de pagos institución.DAO", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

//Lista de los movimientos No concilados en Tesoreria
	public List listaMovsTeso(AplicaPagoInstBean pagoInstBean, int tipoConsulta){
			String query = "call TESOMOVCONCILIALIS(?,?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(pagoInstBean.getInstitucionID()),
					pagoInstBean.getNumCuenta(),
					Utileria.convierteEntero(pagoInstBean.getInstitNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AplicaPagoInstDAO.listaMovsTeso",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOMOVCONCILIALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AplicaPagoInstBean pagoBean = new AplicaPagoInstBean();

					pagoBean.setMovConciliado(resultSet.getString("Descripcion"));
					pagoBean.setFolioNum(resultSet.getString("FolioCargaID"));

					return pagoBean;
				}
			});
			return matches;
		}

	//Lista de los tipos de movimientos de tesoreria
		public List listaTiposMovNomina(AplicaPagoInstBean pagoInstBean, int tipoConsulta){
				String query = "call TIPOMOVNOMINALIS(?,?,?,?,	?,?,?,?,?,?);";
				Object[] parametros = {
						pagoInstBean.getMovConciliado(),
						pagoInstBean.getNumCuenta(),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"AplicaPagoInstDAO.listaTiposMovNomina",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOMOVNOMINALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						TiposMovTesoBean tiposMovTesoBean = new TiposMovTesoBean();

						tiposMovTesoBean.setTipoMovTesoID(resultSet.getString("TipoMovTesoID"));
						tiposMovTesoBean.setDescripcion(resultSet.getString("Descripcion"));

						return tiposMovTesoBean;
					}
				});
				return matches;
			}


	public AplicaPagoInstBean consultaPrincipal(int tipoConsulta, AplicaPagoInstBean institucionNominaBean){
			String query = "call APLICAPAGOINSTCON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(institucionNominaBean.getFolioNum()),
					Utileria.convierteEntero(institucionNominaBean.getInstitNominaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"AplicaPagoInsDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AplicaPagoInstBean institNomina = new AplicaPagoInstBean();

					institNomina.setFechaDescuento(resultSet.getString("FechaAplicacion"));
					institNomina.setMontoPagos(resultSet.getString("montoPagos"));
					institNomina.setEstatusPagoInst(resultSet.getString("EstatusInst"));
					institNomina.setEstatusPagoDesc(resultSet.getString("EstatusDesc"));
					return institNomina;
			}
		});

		return matches.size() > 0 ? (AplicaPagoInstBean) matches.get(0) : null;
	}


	public AplicaPagoInstBean consultaMovTeso(int tipoConsulta, AplicaPagoInstBean institucionNominaBean){
		String query = "call APLICAPAGOINSTCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionNominaBean.getFolioNum()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AplicaPagoInsDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AplicaPagoInstBean institNomina = new AplicaPagoInstBean();

				institNomina.setFechaDescuento(resultSet.getString("FechaOperacion"));
				institNomina.setMontoPagos(resultSet.getString("MontoMov"));

				return institNomina;
		}
		});

			return matches.size() > 0 ? (AplicaPagoInstBean) matches.get(0) : null;
	}

	// Metodo para consultar el Monto Aplicado del Folio de Instalación
	public AplicaPagoInstBean consultaMontoAplicado(int tipoConsulta, AplicaPagoInstBean aplicaPagoInstBean){
		String query = "call APLICAPAGOINSTCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(aplicaPagoInstBean.getFolioNum()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AplicaPagoInsDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APLICAPAGOINSTCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				AplicaPagoInstBean PagoBean = new AplicaPagoInstBean();

				PagoBean.setMontoPagoInst(resultSet.getString("MontoTotal"));

				return PagoBean;
		}
		});

			return matches.size() > 0 ? (AplicaPagoInstBean) matches.get(0) : null;
	}


	// Metodo para Actualizar el Folio de Proceso, esto cuando es un Proceso Masivo o Individual
   public MensajeTransaccionBean actFolioProcesoMasivo(final AplicaPagoInstBean pagoInstBean, final long numTransaccion, final int tipoAct){
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
	   public Object doInTransaction(TransactionStatus transaction) {
		 MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		    try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				 new CallableStatementCreator() {
				  public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call APLICAPAGOINSTACT(?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?);";
					   CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_FolioNominaID",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
						sentenciaStore.setInt("Par_EmpresaNominaID", Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
						sentenciaStore.setLong("Par_CreditoID", Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);

						sentenciaStore.setDouble("Par_MontoPago",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_TipoAct",tipoAct);
						sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));
						sentenciaStore.setString("Par_NumCuenta",pagoInstBean.getNumCuenta());
						sentenciaStore.setInt("Par_TipoMovID",Utileria.convierteEntero(pagoInstBean.getMovConciliado()));

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

								 mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								 mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								 mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								 mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

							}else{
							     mensajeTransaccion.setNumero(999);
								 mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							}
							 return mensajeTransaccion;
							}
						});
					  if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							mensajeBean.setNombreControl(Constantes.STRING_VACIO);
							mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						}else if(mensajeBean.getNumero()!=0){
							mensajeBean.setNumero(mensajeBean.getNumero());
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
							mensajeBean.setNombreControl(mensajeBean.getNombreControl());
							mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion(e.getMessage());
						}else{
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						}
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la reversa de pagos institución.DAO", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

// Metodo para Actualizar el Folio de Proceso, esto cuando es un Proceso Masivo o Individual
   public MensajeTransaccionBean actFolioProcesoIndividual(final AplicaPagoInstBean pagoInstBean, final AplicaPagoInstBean gridPagosInstBean, final long numTransaccion, final int tipoAct){
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
	   public Object doInTransaction(TransactionStatus transaction) {
		 MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		    try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				 new CallableStatementCreator() {
				  public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call APLICAPAGOINSTACT(?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?,"
														+ "?,?,?,?,?);";
					   CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_FolioNominaID",Utileria.convierteEntero(gridPagosInstBean.getFolioNum()));
						sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
						sentenciaStore.setInt("Par_EmpresaNominaID", Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
						sentenciaStore.setLong("Par_CreditoID", Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_ClienteID", Constantes.ENTERO_CERO);

						sentenciaStore.setDouble("Par_MontoPago",Constantes.ENTERO_CERO);
						sentenciaStore.setInt("Par_TipoAct",tipoAct);
						sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));
						sentenciaStore.setString("Par_NumCuenta",pagoInstBean.getNumCuenta());
						sentenciaStore.setInt("Par_TipoMovID",Utileria.convierteEntero(pagoInstBean.getMovConciliado()));

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

								 mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								 mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								 mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								 mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

							}else{
							     mensajeTransaccion.setNumero(999);
								 mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							}
							 return mensajeTransaccion;
							}
						});
					  if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
							mensajeBean.setNombreControl(Constantes.STRING_VACIO);
							mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
						}else if(mensajeBean.getNumero()!=0){
							mensajeBean.setNumero(mensajeBean.getNumero());
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
							mensajeBean.setNombreControl(mensajeBean.getNombreControl());
							mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion(e.getMessage());
						}else{
							mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						}
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la reversa de pagos institución.DAO", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

   // metodo para aplicar los pagos de instituciones de todo el Folio de Carga
   public MensajeTransaccionBean realizarPagosMasivo(final AplicaPagoInstBean pagoInstBean,final long numTransaccion){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call APLICAPAGOINSTMASIVOPRO(?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(pagoInstBean.getNumFolio()));
								sentenciaStore.setInt("Par_EmpresaNominaID",Utileria.convierteEntero(pagoInstBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(pagoInstBean.getInstitucionID()));
								sentenciaStore.setString("Par_FechaPagoDesc",Utileria.convierteFecha(pagoInstBean.getFechaDescuento()));
								sentenciaStore.setLong("Par_NumCuenta",Utileria.convierteLong(pagoInstBean.getNumCuenta()));
								sentenciaStore.setString("Par_MovConciliado",pagoInstBean.getMovConciliado());

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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));

								 }else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.DAO");
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
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la aplicación pagos institución DAO", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

   // Método para aplicar los pagos Seleccionados en el Grid
   public MensajeTransaccionBean realizarPagosGrid(final AplicaPagoInstBean pagosInstBean,final List listaPagos, final List listaPagosNoAplicados){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean)transactionTemplate .execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(0);
					AplicaPagoInstBean gridPagosInstBean =null;
					AplicaPagoInstBean gridPagosNoAplicadosBean =null;
					PolizaBean polizaBean = new PolizaBean();

					int numeroPoliza = 0;
					int polizaGenerada = 1;
					try{
						if(!listaPagos.isEmpty()){
							if(pagosInstBean.getAplicaTodos().equalsIgnoreCase("S")){
								// Proceso que realiza la Aplicacion de Pago a todos los Registros
								// Se manda a llamar el método para Actualizar el Proceso de Carga

								mensajeTransaccionBean= actFolioProcesoMasivo(pagosInstBean, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Act_PagoNomina.pagosMasivos );

								if(mensajeTransaccionBean.getNumero()!=0){
									throw new Exception(mensajeTransaccionBean.getDescripcion());
								}

							}else{
								// Si el Pago de Institución es mediante los Checks Individuales
		 						for(int i=0; i < listaPagos.size(); i++){
									gridPagosInstBean = (AplicaPagoInstBean) listaPagos.get(i);

									if( gridPagosInstBean.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI)){
										// Se manda a llamar el método para aplicar la Actualizacion de Folio de Proceso
										mensajeTransaccionBean= actFolioProcesoIndividual(pagosInstBean, gridPagosInstBean, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Act_PagoNomina.pagoIndividual );

										if(mensajeTransaccionBean.getNumero()!=0){
											throw new Exception(mensajeTransaccionBean.getDescripcion());
										}
									}
								}
							}

							// Lista 2 Grid No Aplicados
							if(!listaPagosNoAplicados.isEmpty()){
		 						for(int i=0; i < listaPagosNoAplicados.size(); i++){
		 							gridPagosNoAplicadosBean = (AplicaPagoInstBean) listaPagosNoAplicados.get(i);

									if( gridPagosNoAplicadosBean.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI)){
										// Se manda a llamar el método para aplicar la Actualizacion de Folio de Proceso
										mensajeTransaccionBean= actFolioProcesoIndividual(pagosInstBean, gridPagosNoAplicadosBean, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Act_PagoNomina.pagoIndividual );

										if(mensajeTransaccionBean.getNumero()!=0){
											throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										}
									}
								}
							}

							if(mensajeTransaccionBean.getNumero()==0){
								// Si todo fue Exitoso se Realiza el Pago de Institucion de Acuerdo al Folio de Proceso
								mensajeTransaccionBean= realizarPagosMasivo(pagosInstBean, parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeTransaccionBean.getNumero()!=0){
									throw new Exception(mensajeTransaccionBean.getDescripcion());
								}
							}

						}else{
							mensajeTransaccionBean.setNumero(999);
							mensajeTransaccionBean.setDescripcion("No hay movimientos para los datos proporcionados");
							mensajeTransaccionBean.setNombreControl(Constantes.STRING_VACIO);
							mensajeTransaccionBean.setConsecutivoString(Constantes.STRING_CERO);
							throw new Exception("No hay movimientos para los datos proporcionados");
						}


					}catch(Exception e){
						if (mensajeTransaccionBean.getNumero() == 0) {
							mensajeTransaccionBean.setNumero(999);
							mensajeTransaccionBean.setNombreControl(mensajeTransaccionBean.getNombreControl());
							mensajeTransaccionBean.setConsecutivoString(Constantes.STRING_CERO);
						}
						mensajeTransaccionBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en aplicación pago de instituciones servicio", e);
					}

					return mensajeTransaccionBean;
				}
			});
			return mensaje;
		}

// Método para cancelar los pagos Seleccionados en el Grid
   public MensajeTransaccionBean cancelarPagosGrid(final AplicaPagoInstBean pagosInstBean, final int tipoAct){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
				resultadoBean.setNumero(0);
				AplicaPagoInstBean gridPagosInstBean =null;

				try{

					resultadoBean= reversarPagosInst(pagosInstBean, parametrosAuditoriaBean.getNumeroTransaccion(),tipoAct);

					if(resultadoBean.getNumero()!=0){
						throw new Exception(resultadoBean.getDescripcion());
					}

				}catch(Exception e){
						if (resultadoBean.getNumero() == 0) {
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion(e.getMessage());
							resultadoBean.setNombreControl(resultadoBean.getNombreControl());
							resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
						}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al reversar aplicación de pagos institución", e);
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});
		return resultado;
	}


}