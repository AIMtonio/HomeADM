package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import credito.dao.CreditosDAO;
import fondeador.bean.RedesCuentoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class RedesCuentoDAO extends BaseDAO{
	java.sql.Date fecha = null;
	CreditosDAO creditosDAO;

	public RedesCuentoDAO() {
		super();
	}
	/* Alta del Cliente */
	public MensajeTransaccionBean alta(final RedesCuentoBean redesCuentoBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREDITOFONDEOASIGALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()));
									sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()));
									sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()));
									sentenciaStore.setDouble("Par_SaldoCapFon",Utileria.convierteDoble(redesCuentoBean.getSaldoCapFon()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(redesCuentoBean.getCreditoID()));

									sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(redesCuentoBean.getMontoCredito()));
									sentenciaStore.setDouble("Par_SaldoCapCre",Utileria.convierteDoble(redesCuentoBean.getSaldoCapCre()));
									sentenciaStore.setDouble("Par_PorcenExtra",Utileria.convierteDoble(redesCuentoBean.getPorcentajeExtraCob()));
									sentenciaStore.setDouble("Par_CantidadIntegrar",Utileria.convierteDoble(redesCuentoBean.getCantidadIntegrar()));
									sentenciaStore.setDate("Par_FechaAsignacion",OperacionesFechas.conversionStrDate(redesCuentoBean.getFechaAsignacion()));
									sentenciaStore.setString("Par_UsuarioAsigna",redesCuentoBean.getUsuarioAsigna());
									sentenciaStore.setString("Par_FormaSeleccion",redesCuentoBean.getFormaSeleccion());

									sentenciaStore.setString("Par_CondicionesCum",redesCuentoBean.getCondicionesCum());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " RedesCuentoDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " RedesCuentoDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Asignacion de Creditos de Fondeo" + e);
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
	/* Baja de condiciones de descuento para estados, municipios, localidades */
	public MensajeTransaccionBean baja(final RedesCuentoBean redesCuentoBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOFONDEOASIGBAJ(" +
									"?,?,?,?,?,?,?, ?,?,?,?,?," +
									"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()));
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()));
								sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()));
								sentenciaStore.setString("Par_FechaAsig",redesCuentoBean.getFechaAsignacion());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " RedesCuentoDAO.baja");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " RedesCuentoDAO.baja");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de de Asignacion de Creditos de Fondeo" + e);
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
	/* Alta de las condiciones de descuento para estados, municipios, localidades de credito grid*/
	public MensajeTransaccionBean altaCredFondAsig(final RedesCuentoBean redesCuentoBean, final ArrayList listaCreditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean=baja(redesCuentoBean,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
					RedesCuentoBean redesCuentoFonBean = new RedesCuentoBean();
					if(!listaCreditos.isEmpty()){
						for(int i=0; i < listaCreditos.size(); i++){
							redesCuentoFonBean = (RedesCuentoBean) listaCreditos.get(i);
							if(redesCuentoFonBean.getCreditoID().isEmpty()){
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}else{
								mensajeBean=alta(redesCuentoFonBean,parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}


					}
//					else{
//						mensajeBean.setNumero(999);
//						mensajeBean.setDescripcion("Especificar Creditos");
//						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
//						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);
//						throw new Exception("Especificar Creditos ");
//					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Asignacion de Creditos de Fondeo" + e);
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

	public RedesCuentoBean consultaPrincipal(RedesCuentoBean redesCuentoBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call CREDITOFONDEOASIGCON(?,?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
				                redesCuentoBean.getCreditoID(),
				                redesCuentoBean.getFechaAsignacion(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RedesCuentoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
				redesCuentoBean.setPrevioReporte(resultSet.getString("PrevioReporte"));
				redesCuentoBean.setCreditoID(resultSet.getString("CreditoID"));
				redesCuentoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				redesCuentoBean.setFechaInicio(resultSet.getString("FechaInicio"));
				redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
				redesCuentoBean.setMontoCredito(String.valueOf(resultSet.getDouble("MontoCredito")));
				redesCuentoBean.setSaldoCapital(String.valueOf(resultSet.getDouble("SaldoCapital")));
				redesCuentoBean.setDescripcion(resultSet.getString("Descripcion"));
				redesCuentoBean.setTipoPersona(resultSet.getString("TIPO"));
				redesCuentoBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				redesCuentoBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				redesCuentoBean.setActividadBancoMx(resultSet.getString("ActividadBancoMx"));
				redesCuentoBean.setActDescrip(resultSet.getString("ActDescrip"));
				redesCuentoBean.setSexo(resultSet.getString("Sexo"));
				redesCuentoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				redesCuentoBean.setDestinoCreID(String.valueOf(resultSet.getInt("DestinoCreID")));
				redesCuentoBean.setDestino(resultSet.getString("Destino"));
				redesCuentoBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));

				return redesCuentoBean;

			}
		});

		return matches.size() > 0 ? (RedesCuentoBean) matches.get(0) : null;
	}

	public RedesCuentoBean consultaForanea(RedesCuentoBean redesCuentoBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call CREDITOFONDEOASIGCON(?,?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { Constantes.ENTERO_CERO,
				                Constantes.ENTERO_CERO,
					            redesCuentoBean.getCreditoID(),
                                redesCuentoBean.getFechaAsignacion(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RedesCuentoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
				redesCuentoBean.setCreditoID((resultSet.getString(1)));
				redesCuentoBean.setCreditoFondeoID((resultSet.getString(2)));

				return redesCuentoBean;

			}
		});

		return matches.size() > 0 ? (RedesCuentoBean) matches.get(0) : null;
	}

	public RedesCuentoBean consultaCredAsig(RedesCuentoBean redesCuentoBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call CREDITOFONDEOASIGCON(?,?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
				                redesCuentoBean.getInstitutFondeoID(),
				                redesCuentoBean.getLineaFondeoID(),
				                redesCuentoBean.getCreditoFondeoID(),
				                redesCuentoBean.getFechaAsignacion(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"RedesCuentoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
				redesCuentoBean.setCreditoID(resultSet.getString(1));
				redesCuentoBean.setCreditoFondeoID(resultSet.getString(2));
				redesCuentoBean.setPorcentajeExtraCob(String.valueOf(resultSet.getDouble(3)));
				return redesCuentoBean;

			}
		});

		return matches.size() > 0 ? (RedesCuentoBean) matches.get(0) : null;
	}

	public List listaPrincipal(RedesCuentoBean redesCuentoBean, int tipoLista){
		String query = "call CREDITOFONDEOASIGLIS(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					redesCuentoBean.getInstitutFondeoID(),
	                redesCuentoBean.getLineaFondeoID(),
	                redesCuentoBean.getCreditoID(),
	                redesCuentoBean.getFechaAsignacion(),
	                redesCuentoBean.getCantidadIntegrar(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RedesCuentoDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
				redesCuentoBean.setPrevioReporte(resultSet.getString("PrevioReporte"));
				redesCuentoBean.setFormaSeleccion(resultSet.getString("FormaSeleccion"));
				redesCuentoBean.setCreditoID(resultSet.getString("CreditoID"));
				redesCuentoBean.setNombreCompleto(resultSet.getString("NombreCliente"));
				redesCuentoBean.setFechaInicio(resultSet.getString("FechaInicio"));
				redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencim"));
				redesCuentoBean.setMontoCredito(String.valueOf(resultSet.getDouble("MontoCredito")));
				redesCuentoBean.setSaldoCapital(String.valueOf(resultSet.getDouble("SaldoCapital")));
				redesCuentoBean.setTipoPersona(resultSet.getString("TipoPersona"));
				redesCuentoBean.setDescripcion(resultSet.getString("ProductoCredito"));
				redesCuentoBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				redesCuentoBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				redesCuentoBean.setActividadBancoMx(resultSet.getString("ActividadBancoMx"));
				redesCuentoBean.setActDescrip(resultSet.getString("ActDescrip"));
				redesCuentoBean.setSexo(resultSet.getString("Sexo"));
				redesCuentoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				redesCuentoBean.setDestinoCreID(String.valueOf(resultSet.getInt("DestinoCreID")));
				redesCuentoBean.setDestino(resultSet.getString("Destino"));
				redesCuentoBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));

				return redesCuentoBean;

			}
		});
		return matches;
		}

	public List listaForanea(RedesCuentoBean redesCuentoBean, int tipoLista){
		String query = "call CREDITOFONDEOASIGLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					redesCuentoBean.getInstitutFondeoID(),
	                redesCuentoBean.getLineaFondeoID(),
	                redesCuentoBean.getCreditoID(),
	                redesCuentoBean.getFechaAsignacion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RedesCuentoDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
				redesCuentoBean.setCreditoID(resultSet.getString("CreditoID"));
				redesCuentoBean.setNombreCompleto(resultSet.getString("NombreCliente"));
				redesCuentoBean.setFechaInicio(resultSet.getString("FechaInicio"));
				redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencim"));
				redesCuentoBean.setMontoCredito(String.valueOf(resultSet.getDouble("MontoCredito")));
				redesCuentoBean.setSaldoCapital(String.valueOf(resultSet.getDouble("SaldoCapital")));
				redesCuentoBean.setTipoPersona(resultSet.getString("TipoPersona"));
				redesCuentoBean.setDescripcion(resultSet.getString("ProductoCredito"));
				redesCuentoBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));

				return redesCuentoBean;

			}
		});
		return matches;
		}

	// reporte de detalle asignacion de credito
			public List reporteCreditofondeoExcel(final RedesCuentoBean redesCuentoBean, int tipoLista){
				List ListaResultado=null;
				try{
				String query = "call CREDITOFONDEOASIGREP (?,?,?,?,?    ,?,?,?,?,?,?,?)";

				Object[] parametros ={

									Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()),
									Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()),
									Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()),
									Utileria.convierteFecha(redesCuentoBean.getFechaAsignacion()),
									tipoLista,


						    		parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
						redesCuentoBean.setPrevioReporte(resultSet.getString("PrevioReporte"));
						redesCuentoBean.setFormaSeleccion(resultSet.getString("FormaSeleccion"));
						redesCuentoBean.setCreditoID(resultSet.getString("CreditoID"));
						redesCuentoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						redesCuentoBean.setFechaInicio(resultSet.getString("FechaInicio"));
						redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
						redesCuentoBean.setMontoCredito(String.valueOf(resultSet.getDouble("MontoCredito")));
						redesCuentoBean.setSaldoCapital(String.valueOf(resultSet.getDouble("SaldoCapital")));
						redesCuentoBean.setTipoPersona(resultSet.getString("TIPO"));
						redesCuentoBean.setDescripcion(resultSet.getString("Descripcion"));
						redesCuentoBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
						redesCuentoBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
						redesCuentoBean.setActividadBancoMx(resultSet.getString("ActividadBancoMx"));
						redesCuentoBean.setActDescrip(resultSet.getString("ActDescrip"));
						redesCuentoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
						redesCuentoBean.setDestinoCreID(String.valueOf(resultSet.getInt("DestinoCreID")));
						redesCuentoBean.setDestino(resultSet.getString("Destino"));
						redesCuentoBean.setSexo(resultSet.getString("Sexo"));
						redesCuentoBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));
						redesCuentoBean.setHora(resultSet.getString("HoraEmision"));

						return redesCuentoBean ;

					}
				});
				ListaResultado= matches;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de vencimientos pasivos", e);
				}
				return ListaResultado;
			}

			// reporte de detalle asignacion de credito
		public List repBaseCreditoFommurExcel(final RedesCuentoBean redesCuentoBean, int tipoLista){
			List ListaResultado=null;
			try{
			String query = "call CREDITOFONDEOASIGREP (?,?,?,?,?    ,?,?,?,?,?,?,?)";

			Object[] parametros ={

								Utileria.convierteEntero(redesCuentoBean.getInstitutFondeoID()),
								Utileria.convierteEntero(redesCuentoBean.getLineaFondeoID()),
								Utileria.convierteLong(redesCuentoBean.getCreditoFondeoID()),
								Utileria.convierteFecha(redesCuentoBean.getFechaAsignacion()),
								tipoLista,


					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOASIGREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RedesCuentoBean redesCuentoBean = new RedesCuentoBean();
					redesCuentoBean.setPrevioReporte(resultSet.getString("PrevioReporte"));
					redesCuentoBean.setFormaSeleccion(resultSet.getString("FormaSeleccion"));
					redesCuentoBean.setClienteID(String.valueOf(resultSet.getInt("ClienteSAFI")));
					redesCuentoBean.setTipoPersona(resultSet.getString("TipoPersona"));
					redesCuentoBean.setTitulo(resultSet.getString("Titulo"));
					redesCuentoBean.setNombres(resultSet.getString("Nombres"));
					redesCuentoBean.setApellidoPat(resultSet.getString("ApellidoPaterno"));

					redesCuentoBean.setApellidoMat(resultSet.getString("ApellidoMaterno"));
					redesCuentoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					redesCuentoBean.setSexo(resultSet.getString("Sexo"));
					redesCuentoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
					redesCuentoBean.setRfc(resultSet.getString("RFC"));

					redesCuentoBean.setCurp(resultSet.getString("CURP"));
					redesCuentoBean.setTelefonoCasa(resultSet.getString("TelefonoCasa"));
					redesCuentoBean.setTelefonoCel(resultSet.getString("TelefonoCelular"));
					redesCuentoBean.setCorreo(resultSet.getString("Correo"));
					redesCuentoBean.setGradoEscolar(resultSet.getString("GradoEscolar"));

					redesCuentoBean.setTipoIdenti(resultSet.getString("TipoIdentificacion"));
					redesCuentoBean.setNumeroIdenti(resultSet.getString("NumeroIdentificacion"));
					redesCuentoBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					redesCuentoBean.setEntidadFedNacim(resultSet.getString("EntidadFederativaNacimiento"));
					redesCuentoBean.setOcupacionID(String.valueOf(resultSet.getInt("OcupacionID")));

					redesCuentoBean.setDesOcupacion(resultSet.getString("DescripcionOcupacion"));
					redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencimiento"));
					redesCuentoBean.setLugarTrabajo(resultSet.getString("LugarTrabajo"));
					redesCuentoBean.setAntiguedadTrab(resultSet.getString("AntiguedadEnTrabajo"));
					redesCuentoBean.setPuestoTrabajo(resultSet.getString("PuestoTrabajo"));

					redesCuentoBean.setActividadFR(resultSet.getString("ActividadFR"));
					redesCuentoBean.setDesActividadFR(resultSet.getString("ActividadFRDescripcion"));
					redesCuentoBean.setActividadFomurID(String.valueOf(resultSet.getInt("ActividadFOMURID")));
					redesCuentoBean.setDesActividadFomur(resultSet.getString("ActividadFOMURDescripcion"));
					redesCuentoBean.setTipoDirOficial(resultSet.getString("TipoDireccionOficial"));

					redesCuentoBean.setEstadoDirOficial(resultSet.getString("EstadoDirOficial"));
					redesCuentoBean.setMunicipioDirOficial(resultSet.getString("MunicipioDirOficial"));
					redesCuentoBean.setLocalidadDirOficial(resultSet.getString("LocalidadDirOficial"));
					redesCuentoBean.setAsentamientoColoniaDir(resultSet.getString("AsentamientoColoniaDirOficial"));
					redesCuentoBean.setColoniaDirOficial(resultSet.getString("ColoniaDirOficial"));

					redesCuentoBean.setCalleDirOficial(resultSet.getString("CalleDirOficial"));
					redesCuentoBean.setNumeroIntDirOf(resultSet.getString("NumeroInteriorDirOficial"));
					redesCuentoBean.setNumeroExtDirOf(resultSet.getString("NumeroExteriorDirOficial"));
					redesCuentoBean.setCodigoPostalDir(resultSet.getString("CodigoPostalDirOficial"));
					redesCuentoBean.setDireccionCompleta(resultSet.getString("DireccionCompletaDirOficial"));

					redesCuentoBean.setEstadoDirNegocio(resultSet.getString("EstadoDirNegocio"));
					redesCuentoBean.setMunicipioDirNegocio(resultSet.getString("MunicipioDirNegocio"));
					redesCuentoBean.setLocalidadDirNegocio(resultSet.getString("LocalidadDirNegocio"));
					redesCuentoBean.setAsentamientoColoniaNeg(resultSet.getString("AsentamientoColoniaDirNegocio"));
					redesCuentoBean.setColoniaDirNegocio(resultSet.getString("ColoniaDirNegocio"));

					redesCuentoBean.setActividadBancoMx(resultSet.getString("CalleDirNegocio"));
					redesCuentoBean.setNumeroIntDirNeg(resultSet.getString("NumeroInteriorDirNegocio"));
					redesCuentoBean.setNumeroExtDirNeg(resultSet.getString("NumeroExteriorDirNegocio"));
					redesCuentoBean.setCodigoPostalDirNeg(resultSet.getString("CodigoPostalDirNegocio"));
					redesCuentoBean.setDireccionCompletaNeg(resultSet.getString("DireccionCompletaDirNegocio"));

					redesCuentoBean.setNumeroEmpleados(resultSet.getString("NumeroEmpleados"));
					redesCuentoBean.setSucursalID(String.valueOf(resultSet.getInt("SucursalID")));
					redesCuentoBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					redesCuentoBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					redesCuentoBean.setCreditoID(resultSet.getString("CreditoID"));

					redesCuentoBean.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
					redesCuentoBean.setDescripcion(resultSet.getString("NombreProducto"));
					redesCuentoBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));
					redesCuentoBean.setRangoDias(resultSet.getString("RangoDeDias"));
					redesCuentoBean.setDestinoCreID(String.valueOf(resultSet.getInt("DestinoCreditoID")));

					redesCuentoBean.setDestino(resultSet.getString("DestinoCredito"));
					redesCuentoBean.setDestinoFomurID(String.valueOf(resultSet.getInt("DestinoFOMURID")));
					redesCuentoBean.setDestinoFomur(resultSet.getString("DestinoFOMUR"));
					redesCuentoBean.setDestinoFRID(resultSet.getString("DestinoFRID"));
					redesCuentoBean.setDestinoFR(resultSet.getString("DestinoFR"));

					redesCuentoBean.setTipoCredito(resultSet.getString("TipoDeCredito"));
					redesCuentoBean.setTasaAnual(String.valueOf(resultSet.getDouble("TasaAnual")));
					redesCuentoBean.setTasaMensual(String.valueOf(resultSet.getDouble("TasaMensual")));
					redesCuentoBean.setFechaDesembolso(resultSet.getString("FechaDesembolso"));
					redesCuentoBean.setFechaVencimien(resultSet.getString("FechaVencimiento"));

					redesCuentoBean.setNumeroCuotas(String.valueOf(resultSet.getString("NumeroCuotas")));
					redesCuentoBean.setGrupoID(String.valueOf(resultSet.getString("GrupoID")));
					redesCuentoBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					redesCuentoBean.setEstatus(resultSet.getString("Estatus"));
					redesCuentoBean.setFrecuencia(resultSet.getString("Frecuencia"));

					redesCuentoBean.setModalidadPago(resultSet.getString("ModalidadDePago"));
					redesCuentoBean.setGarantiaExhibida(String.valueOf(resultSet.getDouble("GarantiaExhibida")));
					redesCuentoBean.setGarantiaAdicional(String.valueOf(resultSet.getDouble("GarantiaAdicional")));
					redesCuentoBean.setMontoDesembolsado(String.valueOf(resultSet.getDouble("MontoDesembolsado")));
					redesCuentoBean.setSaldo(String.valueOf(resultSet.getDouble("SALDO")));

					redesCuentoBean.setCapitalExigible(String.valueOf(resultSet.getDouble("CapitalExigible")));
					redesCuentoBean.setInteresVigente(String.valueOf(resultSet.getDouble("InteresVigente")));
					redesCuentoBean.setInteresProvisionado(String.valueOf(resultSet.getDouble("InteresProvisionado")));
					redesCuentoBean.setInteresVencido(String.valueOf(resultSet.getDouble("InteresVencido")));
					redesCuentoBean.setInteresOrdinario(String.valueOf(resultSet.getDouble("InteresOrdinarios")));

					redesCuentoBean.setSaldoMora(String.valueOf(resultSet.getDouble("SaldoEnMora")));
					redesCuentoBean.setComisiones(String.valueOf(resultSet.getDouble("Comisiones")));
					redesCuentoBean.setCapital(String.valueOf(resultSet.getDouble("CAPITAL")));
					redesCuentoBean.setColumnasSaldoSafi(resultSet.getString("ColumnasSaldosSAFI"));
					redesCuentoBean.setSaldoCapitalVigente(String.valueOf(resultSet.getDouble("SaldoCapVigente")));

					redesCuentoBean.setSaldoCapitalAtrasado(String.valueOf(resultSet.getDouble("SaldoCapAtrasado")));
					redesCuentoBean.setSaldoCapitalVencido(String.valueOf(resultSet.getDouble("SaldoCapVencido")));
					redesCuentoBean.setSaldoCapitalVencidonoExi(String.valueOf(resultSet.getDouble("SaldoCapitalVencidoNoExigible")));
					redesCuentoBean.setSaldoInteresAtrasado(String.valueOf(resultSet.getDouble("SaldoInteresAtrasado")));
					redesCuentoBean.setSaldoInteresVencido(String.valueOf(resultSet.getDouble("SaldoInteresVencido")));

					redesCuentoBean.setSaldoInteresDevengado(String.valueOf(resultSet.getDouble("SaldoInteresDevengado")));
					redesCuentoBean.setSaldIntDevengadoCtaOrden(String.valueOf(resultSet.getDouble("SaldoInteresDevengadoEnCuentasDeOrden")));
					redesCuentoBean.setSaldoMoratorio(String.valueOf(resultSet.getDouble("SaldosMoratorios")));
					redesCuentoBean.setSaldoComFaltaPago(String.valueOf(resultSet.getDouble("SaldoComFaltaPago")));
					redesCuentoBean.setSaldoOtrasComisiones(String.valueOf(resultSet.getDouble("SaldoOtrasComisiones")));

					redesCuentoBean.setIngresos(String.valueOf(resultSet.getDouble("Ingresos")));
					redesCuentoBean.setEgresos(String.valueOf(resultSet.getDouble("Egresos")));

					return redesCuentoBean ;

				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de base credito fomur", e);
			}
			return ListaResultado;
		}

	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}
	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}
}
