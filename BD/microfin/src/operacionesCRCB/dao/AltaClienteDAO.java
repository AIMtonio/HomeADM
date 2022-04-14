package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.AltaClienteRequest;
import operacionesCRCB.beanWS.response.AltaClienteResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.PropiedadesSAFIBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class AltaClienteDAO extends BaseDAO{

	public AltaClienteDAO (){
		super();
	}


	public AltaClienteResponse altaClienteWS(final AltaClienteRequest requestBean ){

		AltaClienteResponse altaClienteResponse = new AltaClienteResponse();

		altaClienteResponse = (AltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					@SuppressWarnings("unchecked")
					public Object doInTransaction(TransactionStatus transaction){
						AltaClienteResponse response = new AltaClienteResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (AltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBCLIENTESWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);


									    		sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre());
												sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre());
												sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre());
												sentenciaStore.setString("Par_ApellidoPaterno",requestBean.getApellidoPaterno());
												sentenciaStore.setString("Par_ApellidoMaterno",requestBean.getApellidoMaterno());

												sentenciaStore.setString("Par_FechaNacimiento",Utileria.convierteFecha(requestBean.getFechaNacimiento()));
												sentenciaStore.setString("Par_CURP",requestBean.getCURP());
												sentenciaStore.setInt("Par_EstadoNacimientoID",Utileria.convierteEntero(requestBean.getEstadoNacimientoID()));
												sentenciaStore.setString("Par_Sexo",requestBean.getSexo());
												sentenciaStore.setString("Par_Telefono",requestBean.getTelefono());

												sentenciaStore.setString("Par_TelefonoCelular",requestBean.getTelefonoCelular());
												sentenciaStore.setString("Par_Correo",requestBean.getCorreo());
												sentenciaStore.setString("Par_RFC",requestBean.getRFC());
												sentenciaStore.setString("Par_OcupacionID",requestBean.getOcupacionID());
												sentenciaStore.setString("Par_LugardeTrabajo",requestBean.getLugardeTrabajo());

												sentenciaStore.setString("Par_Puesto",requestBean.getPuesto());
												sentenciaStore.setString("Par_TelTrabajo",requestBean.getTelTrabajo());
												sentenciaStore.setString("Par_NoEmpleado",requestBean.getNoEmpleado());
												sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(requestBean.getAntiguedadTra()));
												sentenciaStore.setString("Par_ExtTelefonoTrab",requestBean.getExtTelefonoTrab());

												sentenciaStore.setString("Par_TipoEmpleado",requestBean.getTipoEmpleado());
												sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(requestBean.getTipoPuesto()));
												sentenciaStore.setInt("Par_SucursalOrigen",Utileria.convierteEntero(requestBean.getSucursalOrigen()));
												sentenciaStore.setString("Par_TipoPersona",requestBean.getTipoPersona());
												sentenciaStore.setInt("Par_PaisNacionalidad", Utileria.convierteEntero(requestBean.getPaisNacionalidad()));

												sentenciaStore.setDouble("Par_IngresosMensuales", Utileria.convierteDoble(requestBean.getIngresosMensuales()));
												sentenciaStore.setInt("Par_TamanioAcreditado", Utileria.convierteEntero(requestBean.getTamanioAcreditado()));
												sentenciaStore.setString("Par_NiveldeRiesgo", requestBean.getNiveldeRiesgo());
												sentenciaStore.setString("Par_Titulo",requestBean.getTitulo());

												sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(requestBean.getPaisResidencia()));
												sentenciaStore.setInt("Par_SectorGeneral",Utileria.convierteEntero(requestBean.getSectorGeneral()));
												sentenciaStore.setString("Par_ActividadBancoMX",requestBean.getActividadBancoMX());
												sentenciaStore.setString("Par_EstadoCivil",requestBean.getEstadoCivil());
												sentenciaStore.setInt("Par_LugarNacimiento",Utileria.convierteEntero(requestBean.getLugarNacimiento()));

												sentenciaStore.setInt("Par_PromotorInicial",Utileria.convierteEntero(requestBean.getPromotorInicial()));
												sentenciaStore.setInt("Par_PromotorActual",Utileria.convierteEntero(requestBean.getPromotorActual()));
												sentenciaStore.setInt("Par_ExtTelefonoPart",Utileria.convierteEntero(requestBean.getExtTelefonoPart()));
												sentenciaStore.setInt("Par_TipoDireccionID",Utileria.convierteEntero(requestBean.getTipoDireccionID()));
												sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));

												sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));
												sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));
												sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
												sentenciaStore.setString("Par_Calle",requestBean.getCalle());
												sentenciaStore.setString("Par_Numero",requestBean.getNumero());

												sentenciaStore.setString("Par_CP",requestBean.getCP());
												sentenciaStore.setString("Par_Oficial",requestBean.getOficial());
												sentenciaStore.setString("Par_Fiscal",requestBean.getFiscal());
												sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior());
												sentenciaStore.setString("Par_Lote",requestBean.getLote());

												sentenciaStore.setString("Par_Manzana",requestBean.getManzana());
												sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(requestBean.getTipoIdentiID()));
												sentenciaStore.setString("Par_NumIdentific",requestBean.getNumIdentific());
												sentenciaStore.setDate("Par_FecExIden",OperacionesFechas.conversionStrDate(requestBean.getFecExIden()));
												sentenciaStore.setDate("Par_FecVenIden",OperacionesFechas.conversionStrDate(requestBean.getFecVenIden()));
												sentenciaStore.setInt("Par_ClienteId",Utileria.convierteEntero(requestBean.getClienteId()));

												sentenciaStore.setString("Par_Piso", requestBean.getPiso());
												sentenciaStore.setString("Par_PrimeraEntreCalle", requestBean.getPrimeraEntreCalle());
												sentenciaStore.setString("Par_SegundaEntreCalle", requestBean.getSegundaEntreCalle());

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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
												AltaClienteResponse responseBean = new AltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setClienteID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta(Constantes.MSG_ERROR + " .AltaClienteDAO.altaClienteWS");
													responseBean.setClienteID(Constantes.STRING_CERO);

												}
												return responseBean;
												}
											}

									);


								if(response ==  null){
									response = new AltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbAltaCliente");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									if(Integer.parseInt(response.getCodigoRespuesta())==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente: " + response.getMensajeRespuesta());
									} else {
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("TransacciÃ³n Rechazada.");
									}
								}

						} catch (Exception e) {
							// TODO: handle exception

							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");
							}

							response.setClienteID("00");
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return altaClienteResponse;
	}

	public AltaClienteResponse altaClienteVal(final AltaClienteRequest requestBean, final String origenReplica ){

		AltaClienteResponse altaClienteResponse = new AltaClienteResponse();

		altaClienteResponse = (AltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(
				new TransactionCallback<Object>() {
					@SuppressWarnings({ "unchecked", "rawtypes" })
					public Object doInTransaction(TransactionStatus transaction){
						AltaClienteResponse response = new AltaClienteResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (AltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBCLIENTESVAL(	?,?,?,?,?,  ?,?,?,?,?,"
													+ "								?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setInt("Par_TipoConsulta", 1);
												sentenciaStore.setString("Par_RFC", requestBean.getRFC());
												sentenciaStore.setString("Par_CURP", requestBean.getCURP());
												sentenciaStore.setString("Par_CP", requestBean.getCP());
												sentenciaStore.setString("Par_Salida", "S");

												sentenciaStore.registerOutParameter("Par_ClienteId", Types.INTEGER);
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
												AltaClienteResponse responseBean = new AltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setClienteID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta(Constantes.MSG_ERROR + " .AltaClienteDAO.altaClienteWS");
													responseBean.setClienteID(Constantes.STRING_CERO);

												}
												return responseBean;
												}
											}

									);


								if(response ==  null){
									response = new AltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbAltaCliente");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									if(Integer.parseInt(response.getCodigoRespuesta())!=1){
										loggerSAFI.error(origenReplica+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("TransacciÃ³n Rechazada.");
									}
								}

						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");
							}

							response.setClienteID("00");
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return altaClienteResponse;
	}

	public AltaClienteResponse altaClienteCartera(final AltaClienteRequest requestBean, final String origenReplica ){

		AltaClienteResponse altaClienteResponse = new AltaClienteResponse();

		altaClienteResponse = (AltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(
				new TransactionCallback<Object>() {
					@SuppressWarnings("unchecked")
					public Object doInTransaction(TransactionStatus transaction){
						AltaClienteResponse response = new AltaClienteResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (AltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBCLIENTESWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
								                        						+ "?,?,?,?,?, ?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

									    		sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre());
												sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre());
												sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre());
												sentenciaStore.setString("Par_ApellidoPaterno",requestBean.getApellidoPaterno());
												sentenciaStore.setString("Par_ApellidoMaterno",requestBean.getApellidoMaterno());

												sentenciaStore.setString("Par_FechaNacimiento",Utileria.convierteFecha(requestBean.getFechaNacimiento()));
												sentenciaStore.setString("Par_CURP",requestBean.getCURP());
												sentenciaStore.setInt("Par_EstadoNacimientoID",Utileria.convierteEntero(requestBean.getEstadoNacimientoID()));
												sentenciaStore.setString("Par_Sexo",requestBean.getSexo());
												sentenciaStore.setString("Par_Telefono",requestBean.getTelefono());

												sentenciaStore.setString("Par_TelefonoCelular",requestBean.getTelefonoCelular());
												sentenciaStore.setString("Par_Correo",requestBean.getCorreo());
												sentenciaStore.setString("Par_RFC",requestBean.getRFC());
												sentenciaStore.setString("Par_OcupacionID",requestBean.getOcupacionID());
												sentenciaStore.setString("Par_LugardeTrabajo",requestBean.getLugardeTrabajo());

												sentenciaStore.setString("Par_Puesto",requestBean.getPuesto());
												sentenciaStore.setString("Par_TelTrabajo",requestBean.getTelTrabajo());
												sentenciaStore.setString("Par_NoEmpleado",requestBean.getNoEmpleado());
												sentenciaStore.setInt("Par_AntiguedadTra",Utileria.convierteEntero(requestBean.getAntiguedadTra()));
												sentenciaStore.setString("Par_ExtTelefonoTrab",requestBean.getExtTelefonoTrab());

												sentenciaStore.setString("Par_TipoEmpleado",requestBean.getTipoEmpleado());
												sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(requestBean.getTipoPuesto()));
												sentenciaStore.setInt("Par_SucursalOrigen",Utileria.convierteEntero(requestBean.getSucursalOrigen()));
												sentenciaStore.setString("Par_TipoPersona",requestBean.getTipoPersona());
												sentenciaStore.setInt("Par_PaisNacionalidad", Utileria.convierteEntero(requestBean.getPaisNacionalidad()));

												sentenciaStore.setDouble("Par_IngresosMensuales", Utileria.convierteDoble(requestBean.getIngresosMensuales()));
												sentenciaStore.setInt("Par_TamanioAcreditado", Utileria.convierteEntero(requestBean.getTamanioAcreditado()));
												sentenciaStore.setString("Par_NiveldeRiesgo", requestBean.getNiveldeRiesgo());
												sentenciaStore.setString("Par_Titulo",requestBean.getTitulo());

												sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(requestBean.getPaisResidencia()));
												sentenciaStore.setInt("Par_SectorGeneral",Utileria.convierteEntero(requestBean.getSectorGeneral()));
												sentenciaStore.setString("Par_ActividadBancoMX",requestBean.getActividadBancoMX());
												sentenciaStore.setString("Par_EstadoCivil",requestBean.getEstadoCivil());
												sentenciaStore.setInt("Par_LugarNacimiento",Utileria.convierteEntero(requestBean.getLugarNacimiento()));

												sentenciaStore.setInt("Par_PromotorInicial",Utileria.convierteEntero(requestBean.getPromotorInicial()));
												sentenciaStore.setInt("Par_PromotorActual",Utileria.convierteEntero(requestBean.getPromotorActual()));
												sentenciaStore.setInt("Par_ExtTelefonoPart",Utileria.convierteEntero(requestBean.getExtTelefonoPart()));
												sentenciaStore.setInt("Par_TipoDireccionID",Utileria.convierteEntero(requestBean.getTipoDireccionID()));
												sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));

												sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));
												sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));
												sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
												sentenciaStore.setString("Par_Calle",requestBean.getCalle());
												sentenciaStore.setString("Par_Numero",requestBean.getNumero());

												sentenciaStore.setString("Par_CP",requestBean.getCP());
												sentenciaStore.setString("Par_Oficial",requestBean.getOficial());
												sentenciaStore.setString("Par_Fiscal",requestBean.getFiscal());
												sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior());
												sentenciaStore.setString("Par_Lote",requestBean.getLote());

												sentenciaStore.setString("Par_Manzana",requestBean.getManzana());
												sentenciaStore.setInt("Par_TipoIdentiID",Utileria.convierteEntero(requestBean.getTipoIdentiID()));
												sentenciaStore.setString("Par_NumIdentific",requestBean.getNumIdentific());
												sentenciaStore.setDate("Par_FecExIden",OperacionesFechas.conversionStrDate(requestBean.getFecExIden()));
												sentenciaStore.setDate("Par_FecVenIden",OperacionesFechas.conversionStrDate(requestBean.getFecVenIden()));
												sentenciaStore.setInt("Par_ClienteId",Utileria.convierteEntero(requestBean.getClienteId()));

												sentenciaStore.setString("Par_Piso", requestBean.getPiso());
												sentenciaStore.setString("Par_PrimeraEntreCalle", requestBean.getPrimeraEntreCalle());
												sentenciaStore.setString("Par_SegundaEntreCalle", requestBean.getSegundaEntreCalle());

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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

												loggerSAFI.info(origenReplica+"-"+sentenciaStore.toString());
												return sentenciaStore;
											}
										},new CallableStatementCallback() {
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																							DataAccessException {
												AltaClienteResponse responseBean = new AltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setClienteID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta(Constantes.MSG_ERROR + " .AltaClienteDAO.altaClienteWS");
													responseBean.setClienteID(Constantes.STRING_CERO);

												}
												return responseBean;
												}
											}

									);


								if(response ==  null){
									response = new AltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbAltaCliente");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									if(Integer.parseInt(response.getCodigoRespuesta())!=1){
										loggerSAFI.error(origenReplica+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("TransacciÃ³n Rechazada.");
									}
								}

						} catch (Exception e) {
							// TODO: handle exception

							loggerSAFI.error(origenReplica+"-"+"Error en Alta de Cliente " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, TransacciÃ³n Rechazada.");
							}

							response.setClienteID("00");
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return altaClienteResponse;
	}

	public AltaClienteRequest consultaClienteCRSB(final AltaClienteRequest requestBean, final String origenDatos) {

		AltaClienteRequest altaClienteResponse = new AltaClienteRequest();

		altaClienteResponse = (AltaClienteRequest) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenDatos)).execute(
		new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction){
				AltaClienteRequest response = new AltaClienteRequest();
				transaccionDAO.generaNumeroTransaccion();
				try {
					response = (AltaClienteRequest) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CRCBCLIENTESWSCON (?,?,?,?,?,"
																		+ "?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ClienteID",requestBean.getClienteId());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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

								loggerSAFI.info(origenDatos + "-" +sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
							DataAccessException {
								AltaClienteRequest responseBean = new AltaClienteRequest();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									responseBean.setClienteId(resultadosStore.getString("ClienteID"));
									responseBean.setCodigoRespuesta("0");
									responseBean.setPrimerNombre(resultadosStore.getString("PrimerNombre"));
									responseBean.setSegundoNombre(resultadosStore.getString("SegundoNombre"));
									responseBean.setTercerNombre(resultadosStore.getString("TercerNombre"));
									responseBean.setApellidoPaterno(resultadosStore.getString("ApellidoPaterno"));
									responseBean.setApellidoMaterno(resultadosStore.getString("ApellidoMaterno"));
									responseBean.setFechaNacimiento(resultadosStore.getString("FechaNacimiento"));
									responseBean.setCURP(resultadosStore.getString("CURP"));
									responseBean.setEstadoNacimientoID(resultadosStore.getString("EstadoNacimientoID"));
									responseBean.setSexo(resultadosStore.getString("Sexo"));
									responseBean.setTelefono(resultadosStore.getString("Telefono"));
									responseBean.setTelefonoCelular(resultadosStore.getString("TelefonoCelular"));
									responseBean.setCorreo(resultadosStore.getString("Correo"));
									responseBean.setRFC(resultadosStore.getString("RFC"));
									responseBean.setOcupacionID(resultadosStore.getString("OcupacionID"));
									responseBean.setLugardeTrabajo(resultadosStore.getString("LugardeTrabajo"));
									responseBean.setPuesto(resultadosStore.getString("Puesto"));
									responseBean.setTelTrabajo(resultadosStore.getString("TelTrabajo"));
									responseBean.setNoEmpleado(resultadosStore.getString("NoEmpleado"));
									responseBean.setAntiguedadTra(resultadosStore.getString("AntiguedadTra"));
									responseBean.setExtTelefonoTrab(resultadosStore.getString("ExtTelefonoTrab"));
									responseBean.setTipoEmpleado(resultadosStore.getString("TipoEmpleado"));
									responseBean.setTipoPuesto(resultadosStore.getString("TipoPuesto"));
									responseBean.setSucursalOrigen(resultadosStore.getString("SucursalOrigen"));
									responseBean.setTipoPersona(resultadosStore.getString("TipoPersona"));
									responseBean.setPaisNacionalidad(resultadosStore.getString("PaisNacionalidad"));
									responseBean.setIngresosMensuales(resultadosStore.getString("IngresosMensuales"));
									responseBean.setTamanioAcreditado(resultadosStore.getString("TamanioAcreditado"));
									responseBean.setNiveldeRiesgo(resultadosStore.getString("NiveldeRiesgo"));
									responseBean.setTitulo(resultadosStore.getString("Titulo"));
									responseBean.setPaisResidencia(resultadosStore.getString("PaisResidencia"));
									responseBean.setSectorGeneral(resultadosStore.getString("SectorGeneral"));
									responseBean.setActividadBancoMX(resultadosStore.getString("ActividadBancoMX"));
									responseBean.setEstadoCivil(resultadosStore.getString("EstadoCivil"));
									responseBean.setLugarNacimiento(resultadosStore.getString("LugarNAcimiento"));
									responseBean.setPromotorInicial(resultadosStore.getString("PromotorInicial"));
									responseBean.setPromotorActual(resultadosStore.getString("PromotorActual"));
									responseBean.setExtTelefonoPart(resultadosStore.getString("ExtTelefonoPart"));
									responseBean.setTipoDireccionID(resultadosStore.getString("TipoDireccionID"));
									responseBean.setEstadoID(resultadosStore.getString("EstadoID"));
									responseBean.setMunicipioID(resultadosStore.getString("MunicipioID"));
									responseBean.setLocalidadID(resultadosStore.getString("LocalidadID"));
									responseBean.setColoniaID(resultadosStore.getString("ColoniaID"));
									responseBean.setCalle(resultadosStore.getString("Calle"));
									responseBean.setNumero(resultadosStore.getString("Numero"));
									responseBean.setCP(resultadosStore.getString("CP"));
									responseBean.setOficial(resultadosStore.getString("Oficial"));
									responseBean.setFiscal(resultadosStore.getString("Fiscal"));
									responseBean.setNumInterior(resultadosStore.getString("NumInterior"));
									responseBean.setLote(resultadosStore.getString("Lote"));
									responseBean.setManzana(resultadosStore.getString("Manzana"));
									responseBean.setTipoIdentiID(resultadosStore.getString("TipoIdentiID"));
									responseBean.setNumIdentific(resultadosStore.getString("NumIdentific"));
									responseBean.setFecExIden(resultadosStore.getString("FecExIden"));
									responseBean.setFecVenIden(resultadosStore.getString("FecVenIden"));
									responseBean.setPiso(resultadosStore.getString("Piso"));
									responseBean.setPrimeraEntreCalle(resultadosStore.getString("PrimeraEntreCalle"));
									responseBean.setSegundaEntreCalle(resultadosStore.getString("SegundaEntreCalle"));

								}else{
									responseBean.setCodigoRespuesta("999");
									responseBean.setMensajeRespuesta(Constantes.MSG_ERROR + " .AltaClienteDAO.altaClienteWS");
									responseBean.setClienteId(Constantes.STRING_CERO);

								}
								return responseBean;
							}
						});
					if(response == null) {
						response = new AltaClienteRequest();
						response.setClienteId("00");
						response.setCodigoRespuesta("998");
						response.setMensajeRespuesta("El Cliente No se Encuentra en en Cartera");
						throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbConsultaCliente");
					}else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
						if(Integer.parseInt(response.getCodigoRespuesta())!=1){
							loggerSAFI.error(origenDatos+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
							throw new Exception("Transacción Rechazada.");
						}
					}
				}catch (Exception e) {
					loggerSAFI.error(origenDatos+"-"+"Error en la Cosnulta " + e);
					e.printStackTrace();
					if( response.getCodigoRespuesta() == null){
						response.setCodigoRespuesta("0");
					}
					if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
						response.setCodigoRespuesta("998");
						response.setMensajeRespuesta("Error, No existe el Cliente.");
					}
				}

				return response;
			}
		});
		return altaClienteResponse;
	}
}
