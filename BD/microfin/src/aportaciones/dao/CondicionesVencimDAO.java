package aportaciones.dao;

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

import aportaciones.bean.AportacionesBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CondicionesVencimDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	AportacionesBean aportacionesBean;

	public CondicionesVencimDAO(){
		super();
	}


	//Da de alta las condiciones de vencimiento de la aportacion //
	public MensajeTransaccionBean alta(final AportacionesBean aportBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONDICIONESVENCIMAPORTALT(?,?,?,?,?,	?,?,?,?,?,"
																				+ "?,?,?,?,?,	?,?,?,?,?,"
																				+ "?,?,?,?,?,	?,?,?,?,?,"
																				+ "?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setString("Par_ReinversionAutomatica",aportBean.getReinversionAutom());
									sentenciaStore.setString("Par_TipoReinversion", aportBean.getReinversion());
									sentenciaStore.setInt("Par_OpcionAport",Utileria.convierteEntero(aportBean.getOpcionAport()));
									sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(aportBean.getCantidadReno()));

									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(aportBean.getMontoNuevaAport()));
									sentenciaStore.setDouble("Par_MontoRenovacion",Utileria.convierteDoble(aportBean.getMontoRenovNuevaAport()));
									sentenciaStore.setDouble("Par_MontoGlobal",Utileria.convierteDoble(aportBean.getMontoGlobalNuevaAport()));
									sentenciaStore.setString("Par_TipoPago", aportBean.getTipoPagoNuevaAport());
									sentenciaStore.setInt("Par_DiaPago",Utileria.convierteEntero(aportBean.getDiaPagoNuevaAport()));

									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(aportBean.getPlazoNuevaAport()));
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(aportBean.getPlazoOriginalNuevaAport()));
									sentenciaStore.setString("Par_FechaInicio", Utileria.convierteFecha(aportBean.getFechaInicioNuevaAport()));
									sentenciaStore.setString("Par_FechaVencimiento", Utileria.convierteFecha(aportBean.getFechaVencimNuevaAport()));
									sentenciaStore.setDouble("Par_TasaBruta", Utileria.convierteDoble(aportBean.getTasaBrutaNuevaAport()));

									sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(aportBean.getTasaISRNuevaAport()));
									sentenciaStore.setDouble("Par_TasaNeta", Utileria.convierteDoble(aportBean.getTasaNetaNuevaAport()));
									sentenciaStore.setString("Par_CapitalizaInteres", aportBean.getCapitalizaNuevaAport());
									sentenciaStore.setDouble("Par_GatNominal", Utileria.convierteDoble(aportBean.getGatNominalNuevaAport()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(aportBean.getInteresGenNuevaAport()));

									sentenciaStore.setDouble("Par_ISRRetener", Utileria.convierteDoble(aportBean.getIsrRetenerNuevaAport()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(aportBean.getIntRecibirNuevaAport()));
									sentenciaStore.setDouble("Par_TotalRecibir", Utileria.convierteDoble(aportBean.getTotRecibirNuevaAport()));
									sentenciaStore.setString("Par_Notas", aportBean.getNotasNuevaAport());
									sentenciaStore.setString("Par_Especificaciones", aportBean.getEspecificacionesNuevaAport());

									sentenciaStore.setString("Par_Estatus", aportBean.getEstatus());
									sentenciaStore.setString("Par_Reinversion", aportBean.getReinvertir());
									sentenciaStore.setDouble("Par_GatReal", Utileria.convierteDoble(aportBean.getGatRealNuevaAport()));
									sentenciaStore.setString("Par_ConsolidarSaldos", aportBean.getConsolidarSaldos());
									sentenciaStore.setString("Par_Condiciones", aportBean.getCondiciones());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTALT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CondicionesVencimDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .CondicionesVencimDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Condiciones de Vencimiento de la Aportacion: " + e);
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


	/* Modificar Aportación. */
	public MensajeTransaccionBean modificar(final AportacionesBean aportBean,final int tipoTransaccion) {
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
									String query = "call CONDICIONESVENCIMAPORTMOD(?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?,"
											+ "?,?,?,?,?,	?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setString("Par_ReinversionAutomatica",aportBean.getReinversionAutom());
									sentenciaStore.setString("Par_TipoReinversion", aportBean.getReinversion());
									sentenciaStore.setInt("Par_OpcionAport",Utileria.convierteEntero(aportBean.getOpcionAport()));
									sentenciaStore.setDouble("Par_Cantidad",Utileria.convierteDoble(aportBean.getCantidadReno()));

									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(aportBean.getMontoNuevaAport()));
									sentenciaStore.setDouble("Par_MontoRenovacion",Utileria.convierteDoble(aportBean.getMontoRenovNuevaAport()));
									sentenciaStore.setDouble("Par_MontoGlobal",Utileria.convierteDoble(aportBean.getMontoGlobalNuevaAport()));
									sentenciaStore.setString("Par_TipoPago", aportBean.getTipoPagoNuevaAport());
									sentenciaStore.setInt("Par_DiaPago",Utileria.convierteEntero(aportBean.getDiaPagoNuevaAport()));


									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(aportBean.getPlazoNuevaAport()));
									sentenciaStore.setInt("Par_PlazoOriginal",Utileria.convierteEntero(aportBean.getPlazoOriginalNuevaAport()));
									sentenciaStore.setString("Par_FechaInicio", Utileria.convierteFecha(aportBean.getFechaInicioNuevaAport()));
									sentenciaStore.setString("Par_FechaVencimiento", Utileria.convierteFecha(aportBean.getFechaVencimNuevaAport()));
									sentenciaStore.setDouble("Par_TasaBruta", Utileria.convierteDoble(aportBean.getTasaBrutaNuevaAport()));

									sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(aportBean.getTasaISRNuevaAport()));
									sentenciaStore.setDouble("Par_TasaNeta", Utileria.convierteDoble(aportBean.getTasaNetaNuevaAport()));
									sentenciaStore.setString("Par_CapitalizaInteres", aportBean.getCapitalizaNuevaAport());
									sentenciaStore.setDouble("Par_GatNominal", Utileria.convierteDoble(aportBean.getGatNominalNuevaAport()));
									sentenciaStore.setDouble("Par_InteresGenerado", Utileria.convierteDoble(aportBean.getInteresGenNuevaAport()));

									sentenciaStore.setDouble("Par_ISRRetener", Utileria.convierteDoble(aportBean.getIsrRetenerNuevaAport()));
									sentenciaStore.setDouble("Par_InteresRecibir", Utileria.convierteDoble(aportBean.getIntRecibirNuevaAport()));
									sentenciaStore.setDouble("Par_TotalRecibir", Utileria.convierteDoble(aportBean.getTotRecibirNuevaAport()));
									sentenciaStore.setString("Par_Notas", aportBean.getNotasNuevaAport());
									sentenciaStore.setString("Par_Especificaciones", aportBean.getEspecificacionesNuevaAport());


									sentenciaStore.setString("Par_Estatus", aportBean.getEstatus());
									sentenciaStore.setString("Par_Reinversion", aportBean.getReinvertir());
									sentenciaStore.setDouble("Par_GatReal", Utileria.convierteDoble(aportBean.getGatRealNuevaAport()));
									sentenciaStore.setString("Par_ConsolidarSaldos", aportBean.getConsolidarSaldos());
									sentenciaStore.setString("Par_Condiciones", aportBean.getCondiciones());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTMOD "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CondicionesVencimDAO.modificar");
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
						throw new Exception(Constantes.MSG_ERROR + " .CondicionesVencimDAO.modificar");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de las condiciones de Vencimiento " + e);
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


	public MensajeTransaccionBean actualizarEstatus(final AportacionesBean aportBean, final int numTransaccion) {
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
									String query = "call CONDICIONESVENCIMAPORTACT(?,?,?,	?,?,?,	?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID",Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setString("Par_Estatus", aportBean.getEstatus());
									sentenciaStore.setInt("Par_NumAct", numTransaccion);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTACT "+ sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CondicionesVencimDAO.actualizarEstatus");
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
						throw new Exception(Constantes.MSG_ERROR + " .CondicionesVencimDAO.modificar");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de las condiciones de Vencimiento " + e);
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


	// Consulta principal de las condiciones de vencimiento //
		public AportacionesBean consultaPrincipal(final AportacionesBean aportBean, final int tipoConsulta){
			AportacionesBean aportacionBean =null;

			try{
				String query = "call CONDICIONESVENCIMAPORTCON(?,?,  ?,?,?,?,?,?,?);";

				Object[] parametros = {
						Utileria.convierteEntero(aportBean.getAportacionID()),
						tipoConsulta,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CondicionesVencimDAO.consultaPrincipal",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						AportacionesBean aportBean = new AportacionesBean();
						aportBean.setAportacionID(resultSet.getString("AportacionID"));
						aportBean.setReinversionAutom(resultSet.getString("ReinversionAutomatica"));
						aportBean.setReinversion(resultSet.getString("TipoReinversion"));
						aportBean.setOpcionAport(resultSet.getString("OpcionAportID"));
						aportBean.setCantidadReno(resultSet.getString("Cantidad"));

						aportBean.setMontoNuevaAport(resultSet.getString("Monto"));
						aportBean.setMontoRenovNuevaAport(resultSet.getString("MontoRenovacion"));
						aportBean.setMontoGlobalNuevaAport(resultSet.getString("MontoGlobal"));
						aportBean.setTipoPagoNuevaAport(resultSet.getString("TipoPago"));
						aportBean.setDiaPagoNuevaAport(resultSet.getString("DiaPago"));

						aportBean.setPlazoNuevaAport(resultSet.getString("Plazo"));
						aportBean.setPlazoOriginalNuevaAport(resultSet.getString("PlazoOriginal"));
						aportBean.setFechaInicioNuevaAport(resultSet.getString("FechaInicio"));
						aportBean.setFechaVencimNuevaAport(resultSet.getString("FechaVencimiento"));
						aportBean.setTasaBrutaNuevaAport(resultSet.getString("TasaBruta"));

						aportBean.setTasaISRNuevaAport(resultSet.getString("TasaISR"));
						aportBean.setTasaNetaNuevaAport(resultSet.getString("TasaNeta"));
						aportBean.setCapitalizaNuevaAport(resultSet.getString("CapitalizaInteres"));
						aportBean.setGatNominalNuevaAport(resultSet.getString("GatNominal"));
						aportBean.setInteresGenNuevaAport(resultSet.getString("InteresGenerado"));

						aportBean.setIsrRetenerNuevaAport(resultSet.getString("ISRRetener"));
						aportBean.setIntRecibirNuevaAport(resultSet.getString("InteresRecibir"));
						aportBean.setTotRecibirNuevaAport(resultSet.getString("TotalRecibir"));
						aportBean.setNotasNuevaAport(resultSet.getString("Notas"));
						aportBean.setEspecificacionesNuevaAport(resultSet.getString("Especificaciones"));

						aportBean.setEstatus(resultSet.getString("Estatus"));
						aportBean.setReinvertir(resultSet.getString("Reinversion"));
						aportBean.setGatRealNuevaAport(resultSet.getString("GatReal"));
						aportBean.setConsolidarSaldos(resultSet.getString("ConsolidarSaldos"));
						aportBean.setTipoAportacionID(resultSet.getString("TipoAportID"));
						aportBean.setTasaMontoGlobal(resultSet.getString("TasaSAFI"));
						aportBean.setCondiciones(resultSet.getString("Condiciones"));
						return aportBean;
					}
				});
				aportacionBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

			} catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de existencia de las condiciones de vencimiento", e);
			}
			return aportacionBean;
		}


	// Consulta si existe el registro de las condiciones de vencimiento //
	public AportacionesBean consultaExiste(final AportacionesBean aportBean, final int tipoConsulta){
		AportacionesBean aportacionBean =null;

		try{
			String query = "call CONDICIONESVENCIMAPORTCON(?,?,  ?,?,?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(aportBean.getAportacionID()),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CondicionesVencimDAO.consultaExiste",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AportacionesBean aportBean = new AportacionesBean();
					aportBean.setExiste(resultSet.getString("Existe"));
					return aportBean;
				}
			});
			aportacionBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

		} catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de existencia de las condiciones de vencimiento", e);
		}
		return aportacionBean;
	}


	// Consulta el estatus de las condiciones de vencimiento //
		public AportacionesBean consultaEstatus(final AportacionesBean aportBean, final int tipoConsulta){
			AportacionesBean aportacionBean =null;

			try{
				String query = "call CONDICIONESVENCIMAPORTCON(?,?,  ?,?,?,?,?,?,?);";

				Object[] parametros = {
						Utileria.convierteEntero(aportBean.getAportacionID()),
						tipoConsulta,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CondicionesVencimDAO.consultaEstatus",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESVENCIMAPORTCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						AportacionesBean aportBean = new AportacionesBean();
						aportBean.setEstatus(resultSet.getString("Estatus"));
						return aportBean;
					}
				});
				aportacionBean  = matches.size() > 0 ? (AportacionesBean) matches.get(0) : null;

			} catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de existencia de las condiciones de vencimiento", e);
			}
			return aportacionBean;
		}

	public List<AportacionesBean> listaConsolidaciones(AportacionesBean aportBean, int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		String query = "call APORTCONSOLIDALIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?);";
		Object[] parametros = {
				aportBean.getClienteID(),
				aportBean.getAportacionID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),

				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CondicionesVencimDAO.listaConsolidaciones",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTCONSOLIDALIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List<AportacionesBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AportacionesBean aportBean = new AportacionesBean();
				aportBean.setAportConsolID(resultSet.getString("AportacionID"));
				aportBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				aportBean.setMonto(resultSet.getString("Monto"));
				aportBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				aportBean.setInteresRetener(resultSet.getString("InteresRetener"));
				aportBean.setTotal(resultSet.getString("Total"));
				aportBean.setTotalFinal(resultSet.getString("TotalReinversion"));
				aportBean.setReinvertirC(resultSet.getString("Reinvertir"));
				aportBean.setReinvertirCI(resultSet.getString("Reinvertir"));
				return aportBean;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean grabaDetalle(final AportacionesBean aportBean,final List<AportacionesBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=bajaConsolida(aportBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(AportacionesBean detalle : listaDetalle){
						mensajeBean = altaConsolida(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar detalle: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	public MensajeTransaccionBean altaConsolida(final AportacionesBean aportBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTCONSOLIDADASALT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID", Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setInt("Par_AportConsID", Utileria.convierteEntero(aportBean.getAportConsolID()));
									sentenciaStore.setString("Par_FechaVencimiento", aportBean.getFechaVencimiento());
									sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(aportBean.getMonto()));
									sentenciaStore.setDouble("Par_Interes", Utileria.convierteDoble(aportBean.getInteresGenerado()));

									sentenciaStore.setDouble("Par_ISR", Utileria.convierteDoble(aportBean.getInteresRetener()));
									sentenciaStore.setDouble("Par_TotalAport", Utileria.convierteDoble(aportBean.getTotalCapital()));
									sentenciaStore.setString("Par_Reinvertir", (aportBean.getReinvertir()));
									sentenciaStore.setDouble("Par_TotalCons", Utileria.convierteDoble(aportBean.getTotalFinal()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.altaConsolida");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.altaConsolida");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta consolidaciones: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de alta en el histórico de paises tasas ISR residentes en el extranjero.
	 * @param aportBean : Clase bean que contiene los valores de los parámetros de entrada al SP-HISTASASISREXTALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean bajaConsolida(final AportacionesBean aportBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call APORTCONSOLIDADASBAJ("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_AportacionID", Utileria.convierteEntero(aportBean.getAportacionID()));
									sentenciaStore.setInt("Par_TipoBaja", 1);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AportacionesDAO.bajaConsolida");
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
						throw new Exception(Constantes.MSG_ERROR + " .AportacionesDAO.bajaConsolida");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de consolidaciones: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public AportacionesBean getAportacionesBean() {
		return aportacionesBean;
	}


	public void setAportacionesBean(AportacionesBean aportacionesBean) {
		this.aportacionesBean = aportacionesBean;
	}
}