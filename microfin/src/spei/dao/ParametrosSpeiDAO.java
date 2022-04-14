package spei.dao;
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
import spei.bean.ParametrosSpeiBean;

public class ParametrosSpeiDAO extends BaseDAO  {

	public ParametrosSpeiDAO() {
		super();
	}

	// Modifica los parametros de spei
	public MensajeTransaccionBean modificaParametrosSpei(final ParametrosSpeiBean parametrosSpeiBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PARAMETROSSPEIMOD(?,?,?,?,?, " +
																	  "?,?,?,?,?, " +
																	  "?,?,?,?,?, " +
																	  "?,?,?,?,?," +
																	  "?,?,?,?,?, " +
																	  "?,?,?,?,?," +
																	  "?,?,?,?,?," +
																	  "?,?,?,?,?," +
																	  "?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosSpeiBean.getEmpresaID()));
								sentenciaStore.setString("Par_Clabe",parametrosSpeiBean.getClabe());
								sentenciaStore.setString("Par_CtaSpei",parametrosSpeiBean.getCtaSpei());
								sentenciaStore.setInt("Par_ParticipanteSpei",Utileria.convierteEntero(parametrosSpeiBean.getParticipanteSpei()));
								sentenciaStore.setString("Par_HorarioInicio",parametrosSpeiBean.getHorarioInicio());

								sentenciaStore.setString("Par_HorarioFin",parametrosSpeiBean.getHorarioFin());
								sentenciaStore.setString("Par_HorarioFinVen",parametrosSpeiBean.getHorarioFinVen());
								sentenciaStore.setString("Par_ParticipaPagoMovil",parametrosSpeiBean.getParticipaPagoMovil());
								sentenciaStore.setString("Par_FrecuenciaEnvio",parametrosSpeiBean.getFrecuenciaEnvio());
								sentenciaStore.setString("Par_Topologia",parametrosSpeiBean.getTopologia());
								sentenciaStore.setString("Par_TipoOperacion",parametrosSpeiBean.getTipoOperacion());
								sentenciaStore.setString("Par_SaldoMinimoCuentaSTP",parametrosSpeiBean.getSaldoMinimoCuentaSTP());
								sentenciaStore.setString("Par_RutaKeystoreStp",parametrosSpeiBean.getRutaKeystoreStp());
								sentenciaStore.setString("Par_AliasCertificadoStp",parametrosSpeiBean.getAliasCertificadoStp());
								sentenciaStore.setString("Par_PasswordKeystoreStp",parametrosSpeiBean.getPasswordKeystoreStp());
								sentenciaStore.setString("Par_EmpresaSTP",parametrosSpeiBean.getEmpresaSTP());

								sentenciaStore.setString("Par_NotificacionesCorreo",parametrosSpeiBean.getNotificacionesCorreo());
								sentenciaStore.setString("Par_CorreoNotificacion",parametrosSpeiBean.getCorreoNotificacion());
								sentenciaStore.setInt("Par_RemitenteID",Utileria.convierteEntero(parametrosSpeiBean.getRemitenteID()));


								sentenciaStore.setString("Par_Prioridad",parametrosSpeiBean.getPrioridad());
								sentenciaStore.setDouble("Par_MonMaxSpeiVen",Utileria.convierteDoble(parametrosSpeiBean.getMonMaxSpeiVen()));
								sentenciaStore.setDouble("Par_MonReqAutTeso",Utileria.convierteDoble(parametrosSpeiBean.getMonReqAutTeso()));
								sentenciaStore.setDouble("Par_MonMaxSpeiBcaMovil",Utileria.convierteDoble(parametrosSpeiBean.getMonMaxSpeiBcaMovil()));
								sentenciaStore.setString("Par_SpeiVenAutTeso",parametrosSpeiBean.getSpeiVenAutTes());
								sentenciaStore.setString("Par_BloqueoRecepcion",parametrosSpeiBean.getBloqueoRecepcion());
								sentenciaStore.setString("Par_MontoMinimoBloq",parametrosSpeiBean.getMontoMinimoBloq());
								sentenciaStore.setString("Par_CtaContableTesoreria",parametrosSpeiBean.getCtaContableTesoreria());
								sentenciaStore.setString("Par_IntentosMaxEnvio",parametrosSpeiBean.getIntentosMaxEnvio());
								sentenciaStore.setString("Par_URLWS",parametrosSpeiBean.getUrlWS());
								sentenciaStore.setString("Par_UsuarioContraseniaWS",parametrosSpeiBean.getUsuarioContraseniaWS());
								sentenciaStore.setString("Par_Habilitado", parametrosSpeiBean.getHabilitado());
								sentenciaStore.setDouble("Par_MonReqAutDesem", Utileria.convierteDoble(parametrosSpeiBean.getMonReqAutDesem()));
								sentenciaStore.setString("Par_URLWSPM", parametrosSpeiBean.getUrlWSPM());
								sentenciaStore.setString("Par_URLWSPF", parametrosSpeiBean.getUrlWSPF());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion de Parametros SPEI", e);
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


	//Consulta principal
	public ParametrosSpeiBean consultaPrincipal(ParametrosSpeiBean parametrosSpeiBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PARAMETROSSPEICON(?,?,	?,?,?,?,?,?);";
		Object[] parametros = { parametrosSpeiBean.getEmpresaID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSPEICON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSpeiBean parametrosSpeiBean = new ParametrosSpeiBean();
				parametrosSpeiBean.setEmpresaID(String.valueOf(resultSet.getInt("EmpresaID")));
				parametrosSpeiBean.setFolioEnvio(resultSet.getString("FolioEnvio"));
				parametrosSpeiBean.setClabe(resultSet.getString("Clabe"));
				parametrosSpeiBean.setCtaSpei(resultSet.getString("CtaSpei"));
				parametrosSpeiBean.setParticipanteSpei(resultSet.getString("ParticipanteSpei"));
				parametrosSpeiBean.setHorarioInicio(resultSet.getString("HorarioInicio"));
				parametrosSpeiBean.setHorarioFin(resultSet.getString("HorarioFin"));
				parametrosSpeiBean.setHorarioFinVen(resultSet.getString("HorarioFinVen"));
				parametrosSpeiBean.setFechaApertura(resultSet.getString("FechaApertura"));
				parametrosSpeiBean.setEstatusApertura(resultSet.getString("EstatusApertura"));
				parametrosSpeiBean.setParticipaPagoMovil(resultSet.getString("ParticipaPagoMovil"));
				parametrosSpeiBean.setFrecuenciaEnvio(resultSet.getString("FrecuenciaEnvio"));
				parametrosSpeiBean.setTopologia(resultSet.getString("Topologia"));
				parametrosSpeiBean.setPrioridad(resultSet.getString("Prioridad"));
				parametrosSpeiBean.setMonMaxSpeiBcaMovil(resultSet.getString("MonMaxSpeiBcaMovil"));
				parametrosSpeiBean.setMonMaxSpeiVen(resultSet.getString("MonMaxSpeiVen"));
				parametrosSpeiBean.setMonReqAutTeso(resultSet.getString("MonReqAutTeso"));
				parametrosSpeiBean.setSpeiVenAutTes(resultSet.getString("SpeiVenAutTes"));
				parametrosSpeiBean.setNombreInstitucion(resultSet.getString("Nombre"));
				parametrosSpeiBean.setBloqueoRecepcion(resultSet.getString("BloqueoRecepcion"));
				parametrosSpeiBean.setMontoMinimoBloq(resultSet.getString("MontoMinimoBloq"));
				parametrosSpeiBean.setCtaContableTesoreria(resultSet.getString("CtaContableTesoreria"));
				parametrosSpeiBean.setTipoOperacion(resultSet.getString("TipoOperacion"));
				parametrosSpeiBean.setSaldoMinimoCuentaSTP(resultSet.getString("SaldoMinimoCuentaSTP"));
				parametrosSpeiBean.setRutaKeystoreStp(resultSet.getString("RutaKeystoreStp"));
				parametrosSpeiBean.setAliasCertificadoStp(resultSet.getString("AliasCertificadoStp"));
				parametrosSpeiBean.setPasswordKeystoreStp(resultSet.getString("PasswordKeystoreStp"));
				parametrosSpeiBean.setEmpresaSTP(resultSet.getString("EmpresaSTP"));
				parametrosSpeiBean.setNotificacionesCorreo(resultSet.getString("NotificacionesCorreo"));
				parametrosSpeiBean.setCorreoNotificacion(resultSet.getString("CorreoNotificacion"));
				parametrosSpeiBean.setRemitenteID(String.valueOf(resultSet.getInt("RemitenteID")));
				parametrosSpeiBean.setRemitenteCorreo(resultSet.getString("CorreoSalida"));
				parametrosSpeiBean.setIntentosMaxEnvio(resultSet.getString("IntentosMaxEnvio"));
				parametrosSpeiBean.setUrlWS(resultSet.getString("URLWS"));
				parametrosSpeiBean.setUsuarioContraseniaWS(resultSet.getString("UsuarioContraseniaWS"));
				parametrosSpeiBean.setHabilitado(resultSet.getString("Habilitado"));
				parametrosSpeiBean.setMonReqAutDesem(resultSet.getString("MonReqAutDesem"));
				parametrosSpeiBean.setUrlWSPM(resultSet.getString("URLWSPM"));
				parametrosSpeiBean.setUrlWSPF(resultSet.getString("URLWSPF"));

				return parametrosSpeiBean;
			}
		});
		return matches.size() > 0 ? (ParametrosSpeiBean) matches.get(0) : null;
	}




	//Lista Principal
	public List listaPrincipal(ParametrosSpeiBean parametrosSpeiBean, int tipoLista) {
		List ParametrosSpeiBeanCon = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSSPEILIS(?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = { parametrosSpeiBean.getEmpresaID(),
									parametrosSpeiBean.getNombreInstitucion(),
									tipoLista,

									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									Constantes.STRING_VACIO,
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSPEILIS(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ParametrosSpeiBean parametrosSpeiBean = new ParametrosSpeiBean();

					parametrosSpeiBean.setEmpresaID(resultSet.getString("EmpresaID"));
					parametrosSpeiBean.setNombreInstitucion(resultSet.getString("Nombre"));
					return parametrosSpeiBean;
				}
			});
			ParametrosSpeiBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Registro de ParametrosSPEI", e);

		}
		return ParametrosSpeiBeanCon;
	}

	//Lista de cuentas de Tesoreria
	public List listaTesoreria(ParametrosSpeiBean parametrosSpeiBean, int tipoLista) {
		List ParametrosSpeiBeanCon = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMETROSSPEILIS(?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = { parametrosSpeiBean.getEmpresaID(),
									parametrosSpeiBean.getDescripcion(),
									tipoLista,

									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									Constantes.STRING_VACIO,
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSPEILIS(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ParametrosSpeiBean parametrosSpeiBean = new ParametrosSpeiBean();

					parametrosSpeiBean.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
					parametrosSpeiBean.setDescripcion(resultSet.getString("Descripcion"));
					return parametrosSpeiBean;
				}
			});
			ParametrosSpeiBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Registro de ParametrosSPEI", e);

		}
		return ParametrosSpeiBeanCon;
	}

	//Lista remitentes
		public List listaRemitentes(ParametrosSpeiBean parametrosSpeiBean, int tipoLista) {
			List ParametrosSpeiBeanCon = null;
			try{
				//Query con el Store Procedure
				String query = "call PARAMETROSSPEILIS(?,?,?, ?,?,?,?,?,?);";
				Object[] parametros = { parametrosSpeiBean.getEmpresaID(),
										parametrosSpeiBean.getRemitenteID(),
										tipoLista,

										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										Constantes.STRING_VACIO,
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSPEILIS(" + Arrays.toString(parametros) +")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						ParametrosSpeiBean parametrosSpeiBean = new ParametrosSpeiBean();

						parametrosSpeiBean.setRemitenteID(resultSet.getString("RemitenteID"));
						parametrosSpeiBean.setRemitenteCorreo(resultSet.getString("CorreoSalida"));
						return parametrosSpeiBean;
					}
				});
				ParametrosSpeiBeanCon = matches;

			}catch(Exception e){

				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Registro de ParametrosSPEI", e);

			}
			return ParametrosSpeiBeanCon;
		}

		public ParametrosSpeiBean consultaParamsSpeiWS(int tipoConsulta) {
			ParametrosSpeiBean paramsSpeinBean = null;
			try {
				String query = "call PARAMETROSSPEICON(?,?,	?,?,?,?,?,?);";
				Object[] parametros = { parametrosAuditoriaBean.getEmpresaID(),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO
										};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL PARAMSCREDELIMINACON (" + Arrays.toString(parametros) +")");
				List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ParametrosSpeiBean resultado = new ParametrosSpeiBean();
						resultado.setUrlWS(resultSet.getString("urlWS"));
						resultado.setUsuarioContraseniaWS(resultSet.getString("usuarioContraseniaWS"));
						return resultado;
					}
				});
				paramsSpeinBean = matches.size() > 0 ? (ParametrosSpeiBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de PARAMETROSSPEI", e);
			}
			return paramsSpeinBean;
		}

}





