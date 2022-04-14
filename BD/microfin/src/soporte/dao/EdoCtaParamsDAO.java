package soporte.dao;
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

import soporte.bean.EdoCtaParamsBean;
import soporte.bean.SucursalesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class EdoCtaParamsDAO extends BaseDAO{
		public EdoCtaParamsDAO(){
			super();
		}


		/* Modificacion de la sucursal */
		public MensajeTransaccionBean modificarEdoCtaParams(final EdoCtaParamsBean edoCtaParamsBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						edoCtaParamsBean.setTelefonoUEAU(edoCtaParamsBean.getTelefonoUEAU().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
						edoCtaParamsBean.setOtrasCiuUEAU(edoCtaParamsBean.getOtrasCiuUEAU().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call EDOCTAPARAMSMOD(?,?,?,?,?,	 ?,?,?,?,?,"+
																"?,?,?,?,?,  ?,?,?,?,?,"+
																"?,?,?,?,?,	 ?,?,?,?,?,"+
																"?,?,?,?,?,  ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_MontoMin",edoCtaParamsBean.getMontoMin());
							sentenciaStore.setString("Par_RutaExpPDF",edoCtaParamsBean.getRutaExpPDF());
							sentenciaStore.setString("Par_RutaReporte",edoCtaParamsBean.getRutaReporte());
							sentenciaStore.setString("Par_CiudadUEAUID",edoCtaParamsBean.getCiudadUEAUID());
							sentenciaStore.setString("Par_CiudadUEAU",edoCtaParamsBean.getCiudadUEAU());

							sentenciaStore.setString("Par_TelefonoUEAU",edoCtaParamsBean.getTelefonoUEAU());
							sentenciaStore.setString("Par_OtrasCiuUEAU",edoCtaParamsBean.getOtrasCiuUEAU());
							sentenciaStore.setString("Par_HorarioUEAU",edoCtaParamsBean.getHorarioUEAU());
							sentenciaStore.setString("Par_DireccionUEAU",edoCtaParamsBean.getDireccionUEAU());
							sentenciaStore.setString("Par_CorreoUEAU",edoCtaParamsBean.getCorreoUEAU());

							sentenciaStore.setString("Par_RutaCBB",edoCtaParamsBean.getRutaCBB());
							sentenciaStore.setString("Par_RutaCFDI",edoCtaParamsBean.getRutaCFDI());
							sentenciaStore.setString("Par_RutaLogo",edoCtaParamsBean.getRutaLogo());
							sentenciaStore.setString("Par_TipoCuentas",edoCtaParamsBean.getTipoCuentaID());
							sentenciaStore.setString("Par_ExtTelefonoPart", edoCtaParamsBean.getExtTelefonoPart());
							sentenciaStore.setString("Par_ExtTelefono",edoCtaParamsBean.getExtTelefono());

							sentenciaStore.setString("Par_EnvioAutomatico",edoCtaParamsBean.getEnvioAutomatico());
							sentenciaStore.setString("Par_CorreoRemitente",edoCtaParamsBean.getCorreoRemitente());
							sentenciaStore.setString("Par_ServidorSMTP",edoCtaParamsBean.getServidorSMTP());
							sentenciaStore.setInt("Par_PuertoSMTP",Utileria.convierteEntero(edoCtaParamsBean.getPuertoSMTP()));
							sentenciaStore.setString("Par_UsuarioRemitente",edoCtaParamsBean.getUsuarioRemitente());
							sentenciaStore.setString("Par_Contrasenia",edoCtaParamsBean.getContraseniaRemitente());
							sentenciaStore.setString("Par_Asunto",edoCtaParamsBean.getAsunto());
							sentenciaStore.setString("Par_CuerpoTexto",edoCtaParamsBean.getCuerpoTexto());
							sentenciaStore.setString("Par_RequiereAut",edoCtaParamsBean.getRequiereAut());
							sentenciaStore.setString("Par_TipoAut",edoCtaParamsBean.getTipoAut());

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de sucursales", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		// consulta  principal de Cajeros ATM
				public EdoCtaParamsBean consultaPrincipal(int tipoConsulta) {
					EdoCtaParamsBean edoCtaParams = null;

					try{
						String query = "call EDOCTAPARAMSCON(?,?,?,?,?, ?,?,?);";
						Object[] parametros = {
												tipoConsulta,
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO,
												OperacionesFechas.FEC_VACIA,
												Constantes.STRING_VACIO,
												"consultaPrincipal",
												Constantes.ENTERO_CERO,
												Constantes.ENTERO_CERO};

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPARAMSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum)
									throws SQLException {
								EdoCtaParamsBean edoCtaParams = new EdoCtaParamsBean();

								edoCtaParams.setMontoMin(resultSet.getString("MontoMin"));
								edoCtaParams.setRutaExpPDF(resultSet.getString("RutaExpPDF"));
								edoCtaParams.setRutaReporte(resultSet.getString("RutaReporte"));
								edoCtaParams.setCiudadUEAUID(resultSet.getString("CiudadUEAUID"));
								edoCtaParams.setCiudadUEAU(resultSet.getString("CiudadUEAU"));
								edoCtaParams.setTelefonoUEAU(resultSet.getString("TelefonoUEAU"));
								edoCtaParams.setOtrasCiuUEAU(resultSet.getString("OtrasCiuUEAU"));
								edoCtaParams.setHorarioUEAU(resultSet.getString("HorarioUEAU"));
								edoCtaParams.setDireccionUEAU(resultSet.getString("DireccionUEAU"));
								edoCtaParams.setCorreoUEAU(resultSet.getString("CorreoUEAU"));
								edoCtaParams.setRutaCBB(resultSet.getString("RutaCBB"));
								edoCtaParams.setRutaCFDI(resultSet.getString("RutaCFDI"));
								edoCtaParams.setRutaLogo(resultSet.getString("RutaLogo"));
								edoCtaParams.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
								edoCtaParams.setExtTelefono(resultSet.getString("ExtTelefono"));
								edoCtaParams.setTipoCuentaID(resultSet.getString("TipoCuentaID"));

								edoCtaParams.setEnvioAutomatico(resultSet.getString("EnvioAutomatico"));
								edoCtaParams.setCorreoRemitente(resultSet.getString("CorreoRemitente"));
								edoCtaParams.setServidorSMTP(resultSet.getString("ServidorSMTP"));
								edoCtaParams.setPuertoSMTP(resultSet.getString("PuertoSMTP"));
								edoCtaParams.setUsuarioRemitente(resultSet.getString("UsuarioRemitente"));
								edoCtaParams.setContraseniaRemitente(resultSet.getString("ContraseniaRemitente"));
								edoCtaParams.setAsunto(resultSet.getString("Asunto"));
								edoCtaParams.setCuerpoTexto(resultSet.getString("CuerpoTexto"));
								edoCtaParams.setRequiereAut(resultSet.getString("RequiereAut"));
								edoCtaParams.setTipoAut(resultSet.getString("TipoAut"));
								edoCtaParams.setRutaPDI(resultSet.getString("RutaPDI"));

								return edoCtaParams;
							}
						});
						edoCtaParams= matches.size() > 0 ? (EdoCtaParamsBean) matches.get(0) : null;
					}catch(Exception e){
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal del Estado de Cuenta", e);
					}
					return edoCtaParams;
				}


		//Consulta de parametros SmarterWeb
		public EdoCtaParamsBean consultaParamSW(int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call EDOCTAPARAMSCON(?,? ,?,?,?,?,?,?);";
			Object[] parametros = {	tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaParamsDAO.consultaParamSW",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPARAMSCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					EdoCtaParamsBean edoCtaParams = new EdoCtaParamsBean();

					edoCtaParams.setTokenSW(resultSet.getString("TokenSW"));
					edoCtaParams.setuRLWSSmarterWeb(resultSet.getString("URLWSSmarterWeb"));

					return edoCtaParams;
				}
			});
			return matches.size() > 0 ? (EdoCtaParamsBean) matches.get(0) : null;
		}

		/* Modificacion del Prefijo utilizado en el EdoCta */
		public MensajeTransaccionBean modificarPrefijo(final EdoCtaParamsBean edoCtaParamsBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call EDOCTAPARAMSPREMOD( ?, ?,?,?, " +
									"								 ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString( "Par_Prefijo", edoCtaParamsBean.getPrefijoEmpresa() );

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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion del prefijo", e);
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

}
