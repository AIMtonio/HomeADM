package crowdfunding.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import crowdfunding.bean.FondeoSolicitudBean;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class FondeoSolicitudDAO extends BaseDAO{

	public FondeoSolicitudDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final FondeoSolicitudBean fondeoSolicitud) {
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

									String query = "call FONDEOSOLICITUDALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(fondeoSolicitud.getClienteID()));
									sentenciaStore.setInt("Par_CuentaAhoID",Utileria.convierteEntero(fondeoSolicitud.getCuentaID()));
									sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(fondeoSolicitud.getFechaRegistro()));
									sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()));

									sentenciaStore.setDouble("Par_PorceFondeo",Utileria.convierteDoble(fondeoSolicitud.getPorcentajeFondeo()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(fondeoSolicitud.getMonedaID()));
									sentenciaStore.setDouble("Par_TasaActiva",Utileria.convierteDoble(fondeoSolicitud.getTasaActiva()));
									sentenciaStore.setDouble("Par_TasaPasiva",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_TipoFondeadorID",Utileria.convierteEntero(fondeoSolicitud.getTipoFondeadorID()));

									sentenciaStore.setString("Par_TipoFondeo",FondeoSolicitudBean.fondeoPorSolicitud);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_NumSolFon", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_GAT", Types.DECIMAL);
									sentenciaStore.registerOutParameter("Par_GatReal", Types.DECIMAL);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
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
					}else if(mensajeBean.getNumero()!=0 && mensajeBean.getNumero()!=501 ){

						if(mensajeBean.getNumero()==Constantes.DETECCION_PLD){ // Error que corresponde a PLD
							loggerSAFI.error("Error en Alta Solicitud de Credito: " + mensajeBean.getDescripcion());
						}
						else{
							throw new Exception(mensajeBean.getDescripcion());
						}

					}
				} catch (Exception e) {
					e.printStackTrace();

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de solicitud de fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
/*
	public List proceso(final FondeoSolicitudBean fondeoSolicitud) {
		List<SolicitudInversionResponse> mensaje = null;
		transaccionDAO.generaNumeroTransaccion();
		mensaje =  (List) transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				List<SolicitudInversionResponse> mensajeBean = new   ArrayList<SolicitudInversionResponse>();
				try {
					// Query con el Store Procedure
					mensajeBean = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call FONDEOSOLICITUDPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteEntero(fondeoSolicitud.getCreditoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(fondeoSolicitud.getClienteID()));
									sentenciaStore.setInt("Par_CuentaAhoID",Utileria.convierteEntero(fondeoSolicitud.getCuentaID()));
									sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()));

									sentenciaStore.setDouble("Par_TasaPasiva",Utileria.convierteDoble(fondeoSolicitud.getTasaPasiva()));
									sentenciaStore.setString("Par_TipoFondeo",fondeoSolicitud.getTipoFondeo());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.CHAR);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getNombrePrograma()+"|"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									SolicitudInversionResponse mensajeTransaccion = null;
									List consultaDetalle = new ArrayList();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
										while (resultadosStore.next()){
											mensajeTransaccion = new SolicitudInversionResponse();

											mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString(1));
											if(Integer.parseInt(resultadosStore.getString(1))!=0){
												mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString(1));
												mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString(2));
												mensajeTransaccion.setGat(Constantes.STRING_CERO);
												mensajeTransaccion.setGatReal(Constantes.STRING_CERO);
												mensajeTransaccion.setSolicitudFondeo(Constantes.STRING_VACIO);
												mensajeTransaccion.setInfoDetalleCuotas(Constantes.STRING_VACIO);
												consultaDetalle.add(mensajeTransaccion);

											}else{
												mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString(1));
												mensajeTransaccion.setSolicitudFondeo(resultadosStore.getString(2));
												mensajeTransaccion.setGat(resultadosStore.getString("Gat"));
												mensajeTransaccion.setGatReal(resultadosStore.getString("GATReal"));
												mensajeTransaccion.setInfoDetalleCuotas(resultadosStore.getString(3)+"&;&"+
														resultadosStore.getString(4)+"&;&"+resultadosStore.getString(5)+"&;&"+
														resultadosStore.getString(6)+"&;&"+resultadosStore.getString(7)+"&;&"+
														resultadosStore.getString(8)+"&;&"+resultadosStore.getString(9)+"&;&"+
														resultadosStore.getString(10));
												consultaDetalle.add(mensajeTransaccion);
											}

										}
									}else{
										mensajeTransaccion.setCodigoRespuesta("99");
										mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										mensajeTransaccion.setSolicitudFondeo(Constantes.STRING_VACIO);
										mensajeTransaccion.setInfoDetalleCuotas(Constantes.STRING_VACIO);
										consultaDetalle.add(mensajeTransaccion);
									}
									return consultaDetalle;
								}
							});
					if(Integer.parseInt(mensajeBean.get(0).getCodigoRespuesta())!=0){
						if(Integer.parseInt(mensajeBean.get(0).getCodigoRespuesta())==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
						} else {
							try {
								throw new Exception(mensajeBean.get(0).getMensajeRespuesta());
							} catch (Exception e1) {
								// TODO Auto-generated catch block
								e1.printStackTrace();
							}
						}
					}else if(Integer.parseInt(mensajeBean.get(0).getCodigoRespuesta())!= 0){
						throw new Exception(mensajeBean.get(0).getMensajeRespuesta());
					}

				}catch (Exception e) {
					e.printStackTrace();
					SolicitudInversionResponse mensajeTransaccionBean = new SolicitudInversionResponse();
					if(mensajeBean == null){
						mensajeBean = new   ArrayList<SolicitudInversionResponse>();
						mensajeTransaccionBean.setCodigoRespuesta("999");
						mensajeTransaccionBean.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						mensajeTransaccionBean.setSolicitudFondeo(Constantes.STRING_VACIO);
						mensajeTransaccionBean.setInfoDetalleCuotas(Constantes.STRING_VACIO);
						mensajeBean.add(mensajeTransaccionBean);

					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		if(mensaje.get(0).getCodigoRespuesta().equals("020")){
			eliminaCredTienda(fondeoSolicitud);
		}

		return mensaje;
	}
*/
	public MensajeTransaccionBean cancelar(final FondeoSolicitudBean fondeoSolicitud) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call FONDEOSOLICITUDCAN(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolFondeoID",Utileria.convierteEntero(fondeoSolicitud.getSolFondeoID()));
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info("call FONDEOSOLICITUDCAN"+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .FondeoSolicitudDAO.fondeoSolicitud");
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
						throw new Exception(Constantes.MSG_ERROR + " .FondeoSolicitudDAO.fondeoSolicitud");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error("Error al crear Solicitud de Fondeo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl(Constantes.STRING_VACIO);
					mensajeBean.setConsecutivoString(Constantes.STRING_VACIO);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Lista de Solicitudes de Fondeo en la pantalla de alta de credito kubo*/
	public List listaGridFondeadores(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call CRWFONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRWFONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				fondeoSolicitud.setConsecutivo(resultSet.getString("Consecutivo"));
				fondeoSolicitud.setClienteID(resultSet.getString("NombreCompleto"));
				fondeoSolicitud.setFechaRegistro(resultSet.getString("FechaRegistro"));
				fondeoSolicitud.setMontoFondeo(resultSet.getString("MontoFondeo"));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString("PorcentajeFondeo"));
				fondeoSolicitud.setTasaPasiva(resultSet.getString("TasaPasiva"));
				fondeoSolicitud.setMontoTotal(resultSet.getString("TotalFondeo"));  //Monto total
				fondeoSolicitud.setPorcentaje(resultSet.getString("PorcFondeo")); //Porcentaje de monto total
				fondeoSolicitud.setMargen(resultSet.getString("TasaMargen")); // Margen .- Activo- Pasivo
				return fondeoSolicitud;
			}
		});

		return matches;
	}


	/* Lista de Solicitudes de Fondeo */
	public List listaGridInverKubo(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call CRWFONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRWFONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setSolFondeoID(resultSet.getString("SolFondeoID"));
				fondeoSolicitud.setClienteID(resultSet.getString("ClienteID"));
				fondeoSolicitud.setNombreCompleto(resultSet.getString("NombreCompleto"));
				fondeoSolicitud.setMontoFondeo(resultSet.getString("MontoFondeo"));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString("PorcentajeFondeo"));
				fondeoSolicitud.setTasaPasiva(resultSet.getString("TasaPasiva"));
				fondeoSolicitud.setGat(resultSet.getString("ValorGat"));
				return fondeoSolicitud;
			}
		});

		return matches;
	}

	/* Lista de Solicitudes de Fondeo con Inversionistas de Alto Riesgo */
	public List listaInversionistasAltoRiesgo(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure

		String query = "call CRWFONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRWFONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setSolFondeoID(resultSet.getString("SolFondeoID"));
				fondeoSolicitud.setClienteID(resultSet.getString("ClienteID"));
				fondeoSolicitud.setNombreCompleto(resultSet.getString("NombreCompleto"));
				fondeoSolicitud.setRfcCliente(resultSet.getString("RFCOficial"));
				fondeoSolicitud.setFechaRegistro(resultSet.getString("FechaRegistro"));
				fondeoSolicitud.setMontoFondeo(resultSet.getString("MontoFondeo"));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString("PorcentajeFondeo"));
				fondeoSolicitud.setNivelRiesgoCliente(resultSet.getString("NivelRiesgo"));
				return fondeoSolicitud;
			}
		});

		return matches;
	}


	// Elimiar credito de la tienda cuando no se puede fondear
	public MensajeTransaccionBean eliminaCredTienda(final FondeoSolicitudBean fondeoSolicitud) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ELIMINACREDTIENDAPRO(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteEntero(fondeoSolicitud.getCreditoID()));
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info("call ELIMINACREDTIENDAPRO"+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .FondeoSolicitudDAO.eliminaCredTienda");
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
						throw new Exception(Constantes.MSG_ERROR + " .FondeoSolicitudDAO.eliminaCredTienda");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error("Error al crear Eliminar Credito de la Tienda" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl(Constantes.STRING_VACIO);
					mensajeBean.setConsecutivoString(Constantes.STRING_VACIO);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



}
