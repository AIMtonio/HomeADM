package cobranza.dao;

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

import cobranza.bean.AsignaCarteraBean;
import cobranza.bean.RepAsignaCarteraBean;
import cobranza.bean.RepCarteraCobranzaBean;

public class AsignaCarteraDAO extends BaseDAO{
	private final static String salidaPantalla = "S";

	public AsignaCarteraDAO(){

	}

	public MensajeTransaccionBean altaAsignacionCreditos(final AsignaCarteraBean asignaCartera,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					AsignaCarteraBean bean;
					mensajeBean = altaAsignacion(asignaCartera);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String asignacionID = mensajeBean.getConsecutivoString();

					if(listaBean!=null && listaBean.size() > 0){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (AsignaCarteraBean)listaBean.get(i);
							bean.setAsignadoID(asignacionID);

							mensajeBean = detCredAsignados(bean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}else{
						mensajeBean.setDescripcion("Lista de Creditos vacia");
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Creditos Asignados", e);
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

	public MensajeTransaccionBean altaAsignacion(final AsignaCarteraBean asigCartera) {
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
									String query = "call COBCARTERAASIGALT(" +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?," +
													"?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_FechaAsig",OperacionesFechas.conversionStrDate(asigCartera.getFechaSis()));
									sentenciaStore.setInt("Par_GestorID",Utileria.convierteEntero(asigCartera.getGestorID()));
									sentenciaStore.setDouble("Par_PorcentajeComision",Utileria.convierteDoble(asigCartera.getPorcentajeComision()));
									sentenciaStore.setInt("Par_TipoAsigCobranzaID",Utileria.convierteEntero(asigCartera.getTipoAsigCobranzaID()));
									sentenciaStore.setInt("Par_UsuarioAsigID",Utileria.convierteEntero(asigCartera.getUsuarioLogeadoID()));

									sentenciaStore.setInt("Par_DiaAtrasoMin",Utileria.convierteEntero(asigCartera.getDiasAtrasoMin()));
									sentenciaStore.setInt("Par_DiaAtrasoMax",Utileria.convierteEntero(asigCartera.getDiasAtrasoMax()));
									sentenciaStore.setDouble("Par_AdeudoMin",Utileria.convierteDoble(asigCartera.getAdeudoMin()));
									sentenciaStore.setDouble("Par_AdeudoMax",Utileria.convierteDoble(asigCartera.getAdeudoMax()));
									sentenciaStore.setString("Par_EstCredito",asigCartera.getEstatusCreditos());

									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(asigCartera.getSucursalID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(asigCartera.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(asigCartera.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(asigCartera.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(asigCartera.getColoniaID()));

									sentenciaStore.setInt("Par_LimRenglones",Utileria.convierteEntero(asigCartera.getLimiteRenglones()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCarteraDAO.altaAsignacion");
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
							throw new Exception(Constantes.MSG_ERROR + " .AsignaCarteraDAO.altaAsignacion");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de asignacion de cartera" + e);
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

	public MensajeTransaccionBean detCredAsignados(final AsignaCarteraBean detCredAsig) {
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
									String query = "call DETCOBCARTERAASIGALT(" +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?, ?,?,?," +
													"?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_FolioAsigID",Utileria.convierteEntero(detCredAsig.getAsignadoID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(detCredAsig.getCreditoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(detCredAsig.getClienteID()));
									sentenciaStore.setString("Par_EstatusCred",detCredAsig.getEstatusCred());
									sentenciaStore.setInt("Par_DiasAtraso",Utileria.convierteEntero(detCredAsig.getDiasAtraso()));

									sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(detCredAsig.getMontoCredito()));
									sentenciaStore.setDate("Par_FechaDesembolso",OperacionesFechas.conversionStrDate(detCredAsig.getFechaDesembolso()));
									sentenciaStore.setDate("Par_FechaVencimien",OperacionesFechas.conversionStrDate(detCredAsig.getFechaVencimien()));
									sentenciaStore.setDouble("Par_SaldoCapital",Utileria.convierteDoble(detCredAsig.getSaldoCapital()));
									sentenciaStore.setDouble("Par_SaldoInteres",Utileria.convierteDoble(detCredAsig.getSaldoInteres()));

									sentenciaStore.setDouble("Par_SaldoMoratorio",Utileria.convierteDoble(detCredAsig.getSaldoMoratorio()));
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(detCredAsig.getSucursalID()));
									sentenciaStore.setString("Par_NombreCompleto",detCredAsig.getNombreCompleto());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCarteraDAO.detCredAsignados");
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
							throw new Exception(Constantes.MSG_ERROR + " .AsignaCarteraDAO.detCredAsignados");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de detalles asignacion de cartera" + e);
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

	public List listaAsignaCreditos(int tipoLista,AsignaCarteraBean asignaCartera){
		String query = "call ASIGNACREDITOLIS(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,  ?,?,?,?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteEntero(asignaCartera.getAsignadoID()),
				Utileria.convierteEntero(asignaCartera.getDiasAtrasoMin()),
				Utileria.convierteEntero(asignaCartera.getDiasAtrasoMax()),
				Utileria.convierteDoble(asignaCartera.getAdeudoMin()),
				Utileria.convierteDoble(asignaCartera.getAdeudoMax()),

				asignaCartera.getEstatusCreditos(),
				Utileria.convierteEntero(asignaCartera.getSucursalID()),
				Utileria.convierteEntero(asignaCartera.getEstadoID()),
				Utileria.convierteEntero(asignaCartera.getMunicipioID()),
				Utileria.convierteEntero(asignaCartera.getLocalidadID()),

				Utileria.convierteEntero(asignaCartera.getColoniaID()),
				Utileria.convierteEntero(asignaCartera.getLimiteRenglones()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"listaCreditosAsigna",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNACREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AsignaCarteraBean asignaCarteraBean = new AsignaCarteraBean();

				asignaCarteraBean.setClienteID(resultSet.getString("ClienteID"));
				asignaCarteraBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				asignaCarteraBean.setSucursalID(resultSet.getString("SucursalID"));
				asignaCarteraBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				asignaCarteraBean.setCreditoID(resultSet.getString("CreditoID"));

				asignaCarteraBean.setEstatusCred(resultSet.getString("EstatusCred"));
				asignaCarteraBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				asignaCarteraBean.setMontoCredito(resultSet.getString("MontoCredito"));
				asignaCarteraBean.setFechaDesembolso(resultSet.getString("FechaDesembolso"));
				asignaCarteraBean.setFechaVencimien(resultSet.getString("FechaVencimien"));

				asignaCarteraBean.setFechaProxVencim(resultSet.getString("FechaProxVencim"));
				asignaCarteraBean.setSaldoCapital(resultSet.getString("SaldoCapital"));
				asignaCarteraBean.setSaldoInteres(resultSet.getString("SaldoInteres"));
				asignaCarteraBean.setSaldoMoratorio(resultSet.getString("SaldoMoratorio"));
				asignaCarteraBean.setAsignado(resultSet.getString("Asignado"));

				return asignaCarteraBean;
			}
		});
		return matches;
	}

	public AsignaCarteraBean consultaPrincipal(int tipoConsulta, AsignaCarteraBean asignaCartera) {
		//Query con el Store Procedure
		String query = "call COBCARTERAASIGCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	asignaCartera.getAsignadoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"AsignaCarteraDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBCARTERAASIGCON(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AsignaCarteraBean asigna = new AsignaCarteraBean();

							asigna.setGestorID(String.valueOf(resultSet.getInt("GestorID")));
							asigna.setPorcentajeComision(resultSet.getString("PorcentajeComision"));
							asigna.setTipoAsigCobranzaID(resultSet.getString("TipoAsigCobranzaID"));

							asigna.setDiasAtrasoMin(String.valueOf(resultSet.getInt("DiaAtrasoMin")));
							asigna.setDiasAtrasoMax(String.valueOf(resultSet.getInt("DiaAtrasoMax")));
							asigna.setAdeudoMin(resultSet.getString("AdeudoMin"));
							asigna.setAdeudoMax(resultSet.getString("AdeudoMax"));
							asigna.setEstatusCreditos(resultSet.getString("EstCredito"));

							asigna.setSucursalID(String.valueOf(resultSet.getInt("SucursalID")));
							asigna.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));
							asigna.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
							asigna.setLocalidadID(String.valueOf(resultSet.getInt("LocalidadID")));
							asigna.setColoniaID(String.valueOf(resultSet.getInt("ColoniaID")));

							asigna.setLimiteRenglones(String.valueOf(resultSet.getInt("LimRenglones")));

							return asigna;
			}
		});

		return matches.size() > 0 ? (AsignaCarteraBean) matches.get(0) : null;
	}



	public List reporteCreditosAsignados(int tipoLista,AsignaCarteraBean asignaCartera){
		String query = "call COBCARTERAASIGREP(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {

				asignaCartera.getTipoGestor(),
				Utileria.convierteEntero(asignaCartera.getSucursalID()),
				Utileria.convierteEntero(asignaCartera.getGestorID()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"reporteCreditosAsignados",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBCARTERAASIGREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepAsignaCarteraBean repAsignaCarteraBean = new RepAsignaCarteraBean();

				repAsignaCarteraBean.setGestorID(resultSet.getString("GestorID"));
				repAsignaCarteraBean.setNombreGestor(resultSet.getString("NombreGestor"));
				repAsignaCarteraBean.setTipoAsignacion(resultSet.getString("DescripcionTipAsig"));
				repAsignaCarteraBean.setFechaAsignacion(resultSet.getString("FechaAsignacion"));
				repAsignaCarteraBean.setClienteID(resultSet.getString("ClienteID"));

				repAsignaCarteraBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				repAsignaCarteraBean.setSucursalCliente(resultSet.getString("NombreSucursal"));
				repAsignaCarteraBean.setCreditoID(resultSet.getString("CreditoID"));
				repAsignaCarteraBean.setNombreProducto(resultSet.getString("DescProductoCred"));
				repAsignaCarteraBean.setTelefonoFijo(resultSet.getString("TelefonoFijo"));

				repAsignaCarteraBean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				repAsignaCarteraBean.setDomicilio(resultSet.getString("Domicilio"));
				repAsignaCarteraBean.setNombreAval(resultSet.getString("NombreAval"));
				repAsignaCarteraBean.setDomicilioAval(resultSet.getString("DomicilioAval"));
				repAsignaCarteraBean.setTelefonoAval(resultSet.getString("TelefonoAval"));

				return repAsignaCarteraBean;
			}
		});
		return matches;
	}



	public List listaAsignacion(int tipoLista, AsignaCarteraBean asignaBean){

		String query = "call COBCARTERAASIGLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				asignaBean.getNombreGestor(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBCARTERAASIGLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AsignaCarteraBean asigna = new AsignaCarteraBean();
				asigna.setAsignadoID(resultSet.getString("FolioAsigID"));
				asigna.setNombreGestor(resultSet.getString("NombreCompleto"));
				asigna.setFechaAsig(resultSet.getString("FechaAsig"));


				return asigna;
			}
		});

		return matches;

	}

	public List reporteCarteraCobranza(int tipoLista,RepCarteraCobranzaBean repCarteraCobranzaBean){


		String query = "call CARTERACOBRANZAREP(?,?,?,?,?,?,?);";
		Object[] parametros = {

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"reporteCarteraCobranza",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTERACOBRANZAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				RepCarteraCobranzaBean reportCarteraCobranzaBean = new RepCarteraCobranzaBean();
				reportCarteraCobranzaBean.setSucEjecutivo(resultSet.getString("SucursalEjecutivo"));
				reportCarteraCobranzaBean.setNumUsuario(resultSet.getString("NumUsuario"));
				reportCarteraCobranzaBean.setNombreUsuario(resultSet.getString("NombreUsuario"));
				reportCarteraCobranzaBean.setNumSocio(resultSet.getString("ClienteID"));
				reportCarteraCobranzaBean.setNombreSocio(resultSet.getString("NombreCompleto"));
				reportCarteraCobranzaBean.setFechaNac(resultSet.getString("FechaNacimiento"));
				reportCarteraCobranzaBean.setEdadSocio(resultSet.getString("Edad"));
				reportCarteraCobranzaBean.setGpoNoSolidario(resultSet.getString("GrupoNOSolidario"));
				reportCarteraCobranzaBean.setFechaIngreso(resultSet.getString("FechaIngreso"));
				reportCarteraCobranzaBean.setPerRelacionada(resultSet.getString("PersonaRelacionada"));
				reportCarteraCobranzaBean.setOcupacion(resultSet.getString("Ocupacion"));
				reportCarteraCobranzaBean.setMunicipio(resultSet.getString("Municipio"));
				reportCarteraCobranzaBean.setLocalidad(resultSet.getString("Localidad"));
				reportCarteraCobranzaBean.setDomicilio(resultSet.getString("DireccionCompleta"));
				reportCarteraCobranzaBean.setNumCredito(resultSet.getString("CreditoID"));
				reportCarteraCobranzaBean.setSucCredito(resultSet.getString("SucursalCredito"));
				reportCarteraCobranzaBean.setNumProdCretito(resultSet.getString("ProductoCreditoID"));
				reportCarteraCobranzaBean.setDesProdCredito(resultSet.getString("ProductoCredito"));
				reportCarteraCobranzaBean.setEstatusCredito(resultSet.getString("EstatusCredito"));
				reportCarteraCobranzaBean.setFechaInicio(resultSet.getString("FechaInicio"));
				reportCarteraCobranzaBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				reportCarteraCobranzaBean.setFrecuenciaPagoCap(resultSet.getString("FrecuenciaCap"));
				reportCarteraCobranzaBean.setMontoAhorroOrd(resultSet.getString("AhorroOrd"));
				reportCarteraCobranzaBean.setMontoAhorroVista(resultSet.getString("AhorroVista"));
				reportCarteraCobranzaBean.setSaldoInversiones(resultSet.getString("SaldoInversiones"));
				reportCarteraCobranzaBean.setMontoOtorgado(resultSet.getString("MontoCredito"));
				reportCarteraCobranzaBean.setSaldoCapital(resultSet.getString("Total"));
				reportCarteraCobranzaBean.setSaldoCapitalVigente(resultSet.getString("SalCapVigente"));
				reportCarteraCobranzaBean.setSaldoCapitalAtradaso(resultSet.getString("SalCapAtrasado"));
				reportCarteraCobranzaBean.setSaldoCapitalVencido(resultSet.getString("SalCapVencido"));
				reportCarteraCobranzaBean.setSaldoInteresOrdinario(resultSet.getString("SalIntOrdinario"));
				reportCarteraCobranzaBean.setSaldoInteresMora(resultSet.getString("SalMoratorios"));
				reportCarteraCobranzaBean.setCuotasPagadas(resultSet.getString("CuotasPagadas"));
				reportCarteraCobranzaBean.setCuotasVencidas(resultSet.getString("CuotasVencidas"));
				reportCarteraCobranzaBean.setCuotasVigentes(resultSet.getString("CuotasVigentes"));
				reportCarteraCobranzaBean.setFechaUltPago(resultSet.getString("FechaUltimoPago"));
				reportCarteraCobranzaBean.setMontGarantiaLiquida(resultSet.getString("MontoGarantia"));
				reportCarteraCobranzaBean.setGarPrendHipotecaria(resultSet.getString("GarPrendHipot"));
				reportCarteraCobranzaBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				reportCarteraCobranzaBean.setTelefono(resultSet.getString("Telefono"));
				reportCarteraCobranzaBean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				reportCarteraCobranzaBean.setTelefonoTrabajo(resultSet.getString("TelTrabajo"));
				reportCarteraCobranzaBean.setAvales(resultSet.getString("Avales"));
				reportCarteraCobranzaBean.setGestor(resultSet.getString("NombreGes"));
				reportCarteraCobranzaBean.setFechaAsignacion(resultSet.getString("FechaAsig"));
				reportCarteraCobranzaBean.setPromesasPago(resultSet.getString("PromesasPago"));





				return reportCarteraCobranzaBean;
			}
		});
		return matches;

	}

}
