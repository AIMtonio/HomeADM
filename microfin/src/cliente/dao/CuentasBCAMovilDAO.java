package cliente.dao;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.ParametrosPDMBean;
import soporte.dao.ParametrosPDMDAO;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import cliente.bean.ClienteBean;
import cliente.bean.CuentasBCAMovilBean;
import cliente.servicio.CuentasBCAMovilServicio.Enum_Act_Cue;
import cliente.servicio.CuentasBCAMovilServicio.Enum_Con_Cue;
import cliente.servicioweb.CuentasBCAMovilWS;

public class CuentasBCAMovilDAO extends BaseDAO{

	protected final Logger loggerPDM = Logger.getLogger("PDM");

	ParametrosPDMDAO parametrosPDMDAO = null;
	public CuentasBCAMovilDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MensajeTransaccionBean procesaAltaPDM(final CuentasBCAMovilBean cuentasBCAMovilBean){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		try {
			cuentasBCAMovilBean.setTelefono(cuentasBCAMovilBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

			// VALIDACION PARAMETROS PDM
			if(cuentasBCAMovilBean.getRegistroPDM().equalsIgnoreCase(Constantes.STRING_SI)){
				ParametrosPDMBean parametrosPDMBeanCon = new ParametrosPDMBean();
				ParametrosPDMBean parametrosPDMBean = new ParametrosPDMBean();

				parametrosPDMBean.setEmpresaID(Integer.toString(parametrosAuditoriaBean.getEmpresaID()));

				parametrosPDMBeanCon = parametrosPDMDAO.consultaPrincipal(parametrosPDMBean, Enum_Con_Cue.principal);

				if(parametrosPDMBeanCon == null){

					mensaje.setNumero(1);
					mensaje.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
					mensaje.setNombreControl("cuentasBcaMovID");
					throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");

				}else if(parametrosPDMBeanCon.getUrlWSDLAlta().isEmpty()){

					mensaje.setNumero(1);
					mensaje.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
					mensaje.setNombreControl("cuentasBcaMovID");
					throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");
				}

				// VALIDACION DATOS SAFI ANTES DEL CONSUMO
				mensaje = validaAltaUsuarioPDM(cuentasBCAMovilBean);
				if(mensaje.getNumero()!=0){
					throw new Exception(mensaje.getDescripcion());
				}

				// CONSUMO WS
				CuentasBCAMovilWS post = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLAlta(), parametrosPDMBeanCon.getTimeOut());

				post.add("codigo_pais", "MX");
				post.add("telefono", cuentasBCAMovilBean.getTelefono());
				post.add("pin", cuentasBCAMovilBean.getNip());
				post.add("NumSocio_Sofi", cuentasBCAMovilBean.getClienteID());
				post.add("NumCta_Sofi", cuentasBCAMovilBean.getCuentaAhoID());

				MensajeTransaccionBean mensajeResponse = new MensajeTransaccionBean();
				mensajeResponse = post.getRespueta();

				if(mensajeResponse.getNumero()!= 0){
					throw new Exception(mensajeResponse.getDescripcion());
				}

				System.out.println("Respuesta del WS de Pademobile==>"+mensajeResponse.getDescripcion());
				loggerPDM.info("Respuesta del WS de Pademobile==>"+mensajeResponse.getDescripcion());

				JSONParser parser = new JSONParser();

				Object obj = parser.parse(mensajeResponse.getDescripcion());
				JSONObject jsonObject = (JSONObject) obj;

				if(jsonObject != null){

					Boolean status = (Boolean) jsonObject.get("status");

					if(status == false){

						String message = (String) jsonObject.get("message");
						mensaje.setNumero(1);
						mensaje.setDescripcion(message);
						mensaje.setNombreControl("cuentasBcaMovID");
						throw new Exception(message);

					}else{

						JSONObject resultado = (JSONObject) jsonObject.get("resultado");

						if(resultado == null){

							mensaje.setNumero(1);
							mensaje.setDescripcion("El usuario se encuentra registrado, Favor de realizar la activación");
							throw new Exception("El usuario se encuentra registrado, Favor de realizar la activación");

						}else{
							String idUsuarioPDM = Long.toString( (Long) resultado.get("id_usuario_alta"));
							cuentasBCAMovilBean.setUsuarioPDMID(idUsuarioPDM);

							// ALTA USUARIO Y ACTUALIZACION
							mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
								public Object doInTransaction(TransactionStatus transaction) {

									MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

									try {
										mensajeBean = altaUsuarioPDM(cuentasBCAMovilBean);
										String consecutivo = mensajeBean.getConsecutivoString();
										if(mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion());
										}

										cuentasBCAMovilBean.setCuentasBcaMovID(consecutivo);
										mensajeBean = bloDesUsuaPDM(cuentasBCAMovilBean,Enum_Act_Cue.alta);
										if(mensajeBean.getNumero()!=0){
											throw new Exception(mensajeBean.getDescripcion());
										}

									} catch (Exception e) {
										if(mensajeBean.getNumero()==0){
											mensajeBean.setNumero(999);
										}
										mensajeBean.setDescripcion(e.getMessage());
										transaction.setRollbackOnly();
										e.printStackTrace();
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Dar de Alta un Cliente en Pademobile", e);
										loggerPDM.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Dar de Alta un Cliente en Pademobile", e);
									}
									return mensajeBean;
								}
							});
						}
					}
				}
			}else{

				// VALIDACION DATOS SAFI ANTES DEL CONSUMO
				mensaje = validaAltaUsuarioPDM(cuentasBCAMovilBean);
				if(mensaje.getNumero()!=0){
					throw new Exception(mensaje.getDescripcion());
				}

				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {

						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

						try {
							mensajeBean = altaUsuarioPDM(cuentasBCAMovilBean);
							String consecutivo = mensajeBean.getConsecutivoString();
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

						} catch (Exception e) {
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Dar de Alta un Cliente en JPMOVIL", e);
						}
						return mensajeBean;
					}
				});
			}
		} catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Dar de Alta un Cliente en Pademobile", e);
			loggerPDM.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Dar de Alta un Cliente en Pademobile", e);
		}

		return mensaje;
	}

	// Guarda el usuario dado de alta en PADEMOBILE
	public MensajeTransaccionBean altaUsuarioPDM(final CuentasBCAMovilBean cuentasBCAMovilBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				cuentasBCAMovilBean.setTelefono(cuentasBCAMovilBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASBCAMOVILALT(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasBCAMovilBean.getCuentaAhoID()));
								sentenciaStore.setString("Par_Telefono",cuentasBCAMovilBean.getTelefono());
								sentenciaStore.setInt("Par_UsuarioPDMID",Utileria.convierteEntero(cuentasBCAMovilBean.getUsuarioPDMID()));
								sentenciaStore.setString("Par_RegistroPDM", cuentasBCAMovilBean.getRegistroPDM());

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta a PADEMOBILE", e);
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

	public MensajeTransaccionBean procesaBloquePDM(final CuentasBCAMovilBean cuentasBCAMovilBean, final int tipoActualizacion){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				cuentasBCAMovilBean.setTelefonoBD1(cuentasBCAMovilBean.getTelefonoBD1().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				ParametrosPDMBean parametrosPDMBeanCon = new ParametrosPDMBean();
				ParametrosPDMBean parametrosPDMBean = new ParametrosPDMBean();
				JSONParser parser = new JSONParser();

				try {

					parametrosPDMBean.setEmpresaID(Integer.toString(parametrosAuditoriaBean.getEmpresaID()));
					parametrosPDMBeanCon = parametrosPDMDAO.consultaPrincipal(parametrosPDMBean, Enum_Con_Cue.principal);

					if(parametrosPDMBeanCon == null){

						mensajeBean.setNumero(1);
						mensajeBean.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
						mensajeBean.setNombreControl("cuentasBcaMovID");
						throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");

					}else if(parametrosPDMBeanCon.getUrlWSDLAlta().isEmpty()){

						mensajeBean.setNumero(1);
						mensajeBean.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
						mensajeBean.setNombreControl("cuentasBcaMovID");
						throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");
					}


					mensajeBean = bloDesUsuaPDM(cuentasBCAMovilBean,tipoActualizacion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}else{

						CuentasBCAMovilWS postLoguin = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogin(), parametrosPDMBeanCon.getTimeOut());

						postLoguin.add("codigo_pais", "MX");
						postLoguin.add("nick", cuentasBCAMovilBean.getAdmin());
						postLoguin.add("pin", cuentasBCAMovilBean.getNipadmin());

						MensajeTransaccionBean responseLogin = new MensajeTransaccionBean();
						responseLogin = postLoguin.getRespueta();

						if(responseLogin.getNumero()!= 0){
							throw new Exception(responseLogin.getDescripcion());
						}

						System.out.println("Respuesta del WS Login de Pademobile==>"+responseLogin.getDescripcion());
						loggerPDM.info("Respuesta del WS Login de Pademobile==>"+responseLogin.getDescripcion());
						Object obj = parser.parse(responseLogin.getDescripcion());
						JSONObject jsonObject = (JSONObject) obj;

						if(jsonObject != null){

							boolean status = (Boolean) jsonObject.get("status");

							if(status == false){

								String message = (String) jsonObject.get("message");
								mensajeBean.setNumero(1);
								mensajeBean.setDescripcion(message);
								mensajeBean.setNombreControl("cuentasBcaMovID");
								throw new Exception(message);

							}else{

								String idUsuario = Long.toString((Long) jsonObject.get("id_usuario"));
								String idSesion = (String) jsonObject.get("id_sesion");

								if(idSesion != null){

									CuentasBCAMovilWS postBloquep = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLBloqueo(), parametrosPDMBeanCon.getTimeOut());

									postBloquep.add("codigo_pais", "MX");
									postBloquep.add("telefono", cuentasBCAMovilBean.getTelefonoBD1());
									postBloquep.add("id_usuario", idUsuario);
									postBloquep.add("id_sesion", idSesion);

									MensajeTransaccionBean responseBloqueo = new MensajeTransaccionBean();
									responseBloqueo = postBloquep.getRespueta();

									if(responseBloqueo.getNumero()!= 0){
										throw new Exception(responseBloqueo.getDescripcion());
									}

									System.out.println("Respuesta del WS Bloqueo de Pademobile==>"+responseBloqueo.getDescripcion());
									loggerPDM.info("Respuesta del WS Bloqueo de Pademobile==>"+responseBloqueo.getDescripcion());
									Object objBloqueo = parser.parse(responseBloqueo.getDescripcion());
									JSONObject jsonObjectBloqueo = (JSONObject) objBloqueo;

									if(jsonObjectBloqueo != null){

										boolean statusBloqueo = (Boolean) jsonObjectBloqueo.get("status");

										if(statusBloqueo == false){

											CuentasBCAMovilWS postLogout = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogout(), parametrosPDMBeanCon.getTimeOut());
											postLogout.add("codigo_pais", "MX");
											postLogout.add("id_usuario", idUsuario);
											postLogout.add("id_sesion", idSesion);

											MensajeTransaccionBean responseLogout = new MensajeTransaccionBean();
											responseLogout = postLogout.getRespueta();

											System.out.println("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());
											loggerPDM.info("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());

											String messageBloqueo = (String) jsonObjectBloqueo.get("message");
											mensajeBean.setNumero(2);
											mensajeBean.setDescripcion(messageBloqueo);
											mensajeBean.setNombreControl("cuentasBcaMovID");
											throw new Exception(messageBloqueo);

										}else{

											CuentasBCAMovilWS postLogout = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogout(), parametrosPDMBeanCon.getTimeOut());
											postLogout.add("codigo_pais", "MX");
											postLogout.add("id_usuario", idUsuario);
											postLogout.add("id_sesion", idSesion);

											MensajeTransaccionBean responseLogout = new MensajeTransaccionBean();
											responseLogout = postLogout.getRespueta();


											System.out.println("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());
											loggerPDM.info("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());

											mensajeBean.setNumero(0);
											mensajeBean.setDescripcion("Cuenta Bloqueada Exitosamente");
											mensajeBean.setNombreControl("cuentasBcaMovID");

										}
									}
								}
							}
						}
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Bloquear un Cliente en Pademobile", e);
					loggerPDM.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Bloquear un Cliente en Pademobile", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean procesaDesbloqueoPDM(final CuentasBCAMovilBean cuentasBCAMovilBean, final int tipoActualizacion){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				cuentasBCAMovilBean.setTelefonoBD1(cuentasBCAMovilBean.getTelefonoBD1().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				ParametrosPDMBean parametrosPDMBeanCon = new ParametrosPDMBean();
				ParametrosPDMBean parametrosPDMBean = new ParametrosPDMBean();

				JSONParser parser = new JSONParser();

				try{

					parametrosPDMBean.setEmpresaID(Integer.toString(parametrosAuditoriaBean.getEmpresaID()));
					parametrosPDMBeanCon = parametrosPDMDAO.consultaPrincipal(parametrosPDMBean, Enum_Con_Cue.principal);

					if(parametrosPDMBeanCon == null){

						mensajeBean.setNumero(1);
						mensajeBean.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
						mensajeBean.setNombreControl("cuentasBcaMovID");
						throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");

					}else if(parametrosPDMBeanCon.getUrlWSDLAlta().isEmpty()){

						mensajeBean.setNumero(1);
						mensajeBean.setDescripcion("No se Tiene Configurado los Parametros de PADEMOBILE");
						mensajeBean.setNombreControl("cuentasBcaMovID");
						throw new Exception("No se Tiene Configurado los Parametros de PADEMOBILE");
					}

					mensajeBean = bloDesUsuaPDM(cuentasBCAMovilBean,tipoActualizacion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}else{

						CuentasBCAMovilWS postLoguin = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogin(), parametrosPDMBeanCon.getTimeOut());

						postLoguin.add("codigo_pais", "MX");
						postLoguin.add("nick", cuentasBCAMovilBean.getAdmin());
						postLoguin.add("pin", cuentasBCAMovilBean.getNipadmin());

						MensajeTransaccionBean responseLoguin = new MensajeTransaccionBean();
						responseLoguin = postLoguin.getRespueta();

						if(responseLoguin.getNumero()!= 0){
							throw new Exception(responseLoguin.getDescripcion());
						}


						System.out.println("Respuesta del WS Login de Pademobile==>"+responseLoguin.getDescripcion());
						loggerPDM.info("Respuesta del WS Login de Pademobile==>"+responseLoguin.getDescripcion());

						Object obj = parser.parse(responseLoguin.getDescripcion());
						JSONObject jsonObject = (JSONObject) obj;

						if(jsonObject != null){

							boolean status = (Boolean) jsonObject.get("status");

							if(status == false){

								String message = (String) jsonObject.get("message");
								mensajeBean.setNumero(1);
								mensajeBean.setDescripcion(message);
								mensajeBean.setNombreControl("cuentasBcaMovID");
								throw new Exception(message);

							}else{

								String idUsuario = Long.toString((Long) jsonObject.get("id_usuario"));
								String idSesion = (String) jsonObject.get("id_sesion");

								if(idSesion != null){

									CuentasBCAMovilWS postDesbloqueo = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLDesBloqueo(), parametrosPDMBeanCon.getTimeOut());

									postDesbloqueo.add("codigo_pais", "MX");
									postDesbloqueo.add("telefono", cuentasBCAMovilBean.getTelefonoBD1());
									postDesbloqueo.add("id_usuario", idUsuario);
									postDesbloqueo.add("id_sesion", idSesion);

									MensajeTransaccionBean responseDesbloqueo = new MensajeTransaccionBean();
									responseDesbloqueo = postDesbloqueo.getRespueta();

									if(responseDesbloqueo.getNumero()!= 0){
										throw new Exception(responseDesbloqueo.getDescripcion());
									}


									System.out.println("Respuesta del WS Desbloqueo de Pademobile==>"+responseDesbloqueo.getDescripcion());
									loggerPDM.info("Respuesta del WS Desbloqueo de Pademobile==>"+responseDesbloqueo.getDescripcion());

									Object objDesbloqueo = parser.parse(responseDesbloqueo.getDescripcion());
									JSONObject jsonObjectDesbloqueo = (JSONObject) objDesbloqueo;

									if(jsonObjectDesbloqueo != null){

										boolean statusDesbloqueo = (Boolean) jsonObjectDesbloqueo.get("status");

										if(statusDesbloqueo == false){

											CuentasBCAMovilWS postLogout = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogout(), parametrosPDMBeanCon.getTimeOut());
											postLogout.add("codigo_pais", "MX");
											postLogout.add("id_usuario", idUsuario);
											postLogout.add("id_sesion", idSesion);

											MensajeTransaccionBean responseLogout = new MensajeTransaccionBean();
											responseLogout = postLogout.getRespueta();

											System.out.println("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());
											loggerPDM.info("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());

											String messageBloqueo = (String) jsonObjectDesbloqueo.get("message");
											mensajeBean.setNumero(2);
											mensajeBean.setDescripcion(messageBloqueo);
											mensajeBean.setNombreControl("cuentasBcaMovID");


										}else{

											CuentasBCAMovilWS postLogout = new CuentasBCAMovilWS(parametrosPDMBeanCon.getUrlWSDLLogout(), parametrosPDMBeanCon.getTimeOut());
											postLogout.add("codigo_pais", "MX");
											postLogout.add("id_usuario", idUsuario);
											postLogout.add("id_sesion", idSesion);

											MensajeTransaccionBean responseLogout = new MensajeTransaccionBean();
											responseLogout = postLogout.getRespueta();

											System.out.println("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());
											loggerPDM.info("Respuesta del WS Logout de Pademobile==>"+responseLogout.getDescripcion());

											mensajeBean.setNumero(0);
											mensajeBean.setDescripcion("Cuenta Desbloqueada Exitosamente");
											mensajeBean.setNombreControl("cuentasBcaMovID");

										}
									}
								}
							}
						}
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Desbloquear un Cliente en Pademobile", e);
					loggerPDM.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Intentar Desbloquear un Cliente en Pademobile", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Altualiza Estatus de el Usario que fue Bloqueado/Desbloqueado en PADEMOBILE
	public MensajeTransaccionBean bloDesUsuaPDM(final CuentasBCAMovilBean cuentasBCAMovilBean, final int tipoActualizacion) {
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
								String query = "call CUENTASBCAMOVILACT(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CuentasBcaMovID",Utileria.convierteEntero(cuentasBCAMovilBean.getCuentasBcaMovID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()));
								sentenciaStore.setInt("Par_UsuarioPDMID",Utileria.convierteEntero(cuentasBCAMovilBean.getUsuarioPDMID()));
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Actualización a PADEMOBILE", e);
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

	// Modificacion de Preguntas de Seguridad
	 public MensajeTransaccionBean guardaPreguntasSeguridad(final CuentasBCAMovilBean cuentasBCAMovilBean,final List listaCodigosResp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					CuentasBCAMovilBean preguntasBean;
					mensajeBean = bajaPreguntasSeguridad(cuentasBCAMovilBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						for(int i=0; i<listaCodigosResp.size(); i++){
							preguntasBean = (CuentasBCAMovilBean)listaCodigosResp.get(i);
							mensajeBean = guardaPreguntasSeguridad(preguntasBean);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar preguntas de seguridad", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

		// Baja Preguntas de Seguridad
		public MensajeTransaccionBean bajaPreguntasSeguridad(final CuentasBCAMovilBean cuentasBCAMovilBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PREGUNTASSEGURIDADBAJ(?,?,?,?,?,	?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al dar de baja Preguntas de Seguridad", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Actualiza Lista Preguntas de Seguridad
	public MensajeTransaccionBean guardaPreguntasSeguridad(final CuentasBCAMovilBean cuentasBCAMovilBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					cuentasBCAMovilBean.setRespuestas(SeguridadRecursosServicio.encriptaPass(Constantes.STRING_VACIO, cuentasBCAMovilBean.getRespuestas()));
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PREGUNTASSEGURIDADALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasBCAMovilBean.getCuentaAhoID()));
								sentenciaStore.setInt("Par_PreguntaID",Utileria.convierteEntero(cuentasBCAMovilBean.getPreguntaID()));
								sentenciaStore.setString("Par_Respuestas",cuentasBCAMovilBean.getRespuestas());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de Preguntas de Seguridad", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	public CuentasBCAMovilBean consultaPrincipal(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoConsulta) {
		//Query con el Store Procedure
		CuentasBCAMovilBean cuentasBCAMovilBeanCon = null;
		String query = "call CUENTASBCAMOVILCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(cuentasBCAMovilBean.getCuentasBcaMovID()),
								Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentasBCAMovilDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASBCAMOVILCON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setCuentasBcaMovID(resultSet.getString("CuentasBcaMovID"));
					cuentasBCAMovilBean.setClienteID(Utileria.completaCerosIzquierda(
    						resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
					cuentasBCAMovilBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasBCAMovilBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cuentasBCAMovilBean.setRegistroPDM(resultSet.getString("RegistroPDM"));
					cuentasBCAMovilBean.setTelefono(resultSet.getString("TelefonoCelular"));
					cuentasBCAMovilBean.setEstatus(resultSet.getString("Estatus"));

					return cuentasBCAMovilBean;
				}
			});

			cuentasBCAMovilBeanCon = matches.size() > 0 ? (CuentasBCAMovilBean) matches.get(0) : null;


		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Usuario PDM", e);
		}


		return cuentasBCAMovilBeanCon;

	}

	// Consulta de Preguntas de Seguridad
	public CuentasBCAMovilBean consultaPreguntas(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoConsulta) {
		//Query con el Store Procedure
		CuentasBCAMovilBean cuentasBCAMovilBeanCon = null;
		String query = "call PREGUNTASSEGURIDADCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
								tipoConsulta,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CuentasBCAMovilDAO.consultaPreguntas",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PREGUNTASSEGURIDADCON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setNumPreguntas(resultSet.getString("NumPreguntas"));

					return cuentasBCAMovilBean;
				}
			});

			cuentasBCAMovilBeanCon = matches.size() > 0 ? (CuentasBCAMovilBean) matches.get(0) : null;


		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Número de Preguntas de Seguridad", e);
		}
		return cuentasBCAMovilBeanCon;
	}

	// Consulta Telefono Celular del Cliente para la validacion de Preguntas de Seguridad
	public CuentasBCAMovilBean consultaTelefonoCelular(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoConsulta) {
		//Query con el Store Procedure
		CuentasBCAMovilBean cuentasBCAMovilBeanCon = null;
		String query = "call CUENTASBCAMOVILCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
								tipoConsulta,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CuentasBCAMovilDAO.consultaTelCelular",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASBCAMOVILCON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setClienteID(resultSet.getString("ClienteID"));
					cuentasBCAMovilBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cuentasBCAMovilBean.setTelefono(resultSet.getString("Telefono"));

					return cuentasBCAMovilBean;
				}
			});

			cuentasBCAMovilBeanCon = matches.size() > 0 ? (CuentasBCAMovilBean) matches.get(0) : null;


		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar Número de Preguntas de Seguridad", e);
		}
		return cuentasBCAMovilBeanCon;
	}


	/* lista para traer los usuarios de PADEMOBIL */
	public List listaUsuario(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoLista){
		List cuentasBCAMovilBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call CUENTASBCAMOVILLIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { cuentasBCAMovilBean.getNombreCompleto(),
									Utileria.convierteEntero(cuentasBCAMovilBean.getCuentasBcaMovID()),
									Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
									Utileria.convierteFecha(cuentasBCAMovilBean.getFechaInicial()),
									Utileria.convierteFecha(cuentasBCAMovilBean.getFechaFinal()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									Constantes.STRING_VACIO,
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASBCAMOVILLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setCuentasBcaMovID(resultSet.getString("CuentasBcaMovID"));
					cuentasBCAMovilBean.setClienteID(Utileria.completaCerosIzquierda(
    						resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
					cuentasBCAMovilBean.setTelefono(resultSet.getString("Telefono"));
					cuentasBCAMovilBean.setUsuarioPDMID(resultSet.getString("UsuarioPDMID"));
					cuentasBCAMovilBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasBCAMovilBean.setEstatus(resultSet.getString("Estatus"));

					return cuentasBCAMovilBean;
				}
			});
			cuentasBCAMovilBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Usuarios PADEMOBILE", e);

		}
		return cuentasBCAMovilBeanCon;

	}




	//Consulta Registros de Uusarios PADEMOBIL
	public List listaGridRegistro(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoLista) {
		List cuentasBCAMovilBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call CUENTASBCAMOVILLIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { cuentasBCAMovilBean.getNombreCompleto(),
									Utileria.convierteEntero(cuentasBCAMovilBean.getCuentasBcaMovID()),
									Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
									Utileria.convierteFecha(cuentasBCAMovilBean.getFechaInicial()),
									Utileria.convierteFecha(cuentasBCAMovilBean.getFechaFinal()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									Constantes.STRING_VACIO,
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASBCAMOVILLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setCuentasBcaMovID(resultSet.getString("CuentasBcaMovID"));
					cuentasBCAMovilBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					cuentasBCAMovilBean.setUsuarioPDMID(resultSet.getString("UsuarioPDMID"));
					cuentasBCAMovilBean.setTelefono(resultSet.getString("Telefono"));
					cuentasBCAMovilBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					cuentasBCAMovilBean.setClienteID(resultSet.getString("ClienteID"));
					cuentasBCAMovilBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasBCAMovilBean.setEstatus(resultSet.getString("Estatus"));

					return cuentasBCAMovilBean;
				}
			});
			cuentasBCAMovilBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Registro de Usuarios PADEMOBILE", e);

		}
		return cuentasBCAMovilBeanCon;
	}

	// Consulta Registros de Preguntas de Seguridad
	public List listaGridPreguntaSeguridad(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoLista) {
		List cuentasBCAMovilBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call PREGUNTASSEGURIDADLIS(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CuentasBCAMovilDAO.listaPreguntas",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PREGUNTASSEGURIDADLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setPreguntaID(resultSet.getString("PreguntaID"));
					cuentasBCAMovilBean.setRespuestas(resultSet.getString("Respuestas"));

					return cuentasBCAMovilBean;
				}
			});
			cuentasBCAMovilBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Preguntas de Seguridad", e);

		}
		return cuentasBCAMovilBeanCon;
	}

	// Consulta Registros de Preguntas de Seguridad
	public List listaPreguntaSeguridad(CuentasBCAMovilBean cuentasBCAMovilBean, int tipoLista) {
		List cuentasBCAMovilBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call PREGUNTASSEGURIDADLIS(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CuentasBCAMovilDAO.listaPreguntas",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PREGUNTASSEGURIDADLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setPreguntaID(resultSet.getString("PreguntaID"));
					cuentasBCAMovilBean.setRespuestas(resultSet.getString("Respuestas"));

					return cuentasBCAMovilBean;
				}
			});
			cuentasBCAMovilBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Preguntas de Seguridad", e);

		}
		return cuentasBCAMovilBeanCon;
	}

	// Consulta Registros de Preguntas de Seguridad
	public List listaPreguntasSeguridad(int tipoLista,CuentasBCAMovilBean cuentasBCAMovilBean) {
		List cuentasBCAMovilBeanCon = null;
		try{
			//Query con el Store Procedure

			String query = "call PREGUNTASSEGURIDADLIS(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = { Constantes.ENTERO_CERO,
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CuentasBCAMovilDAO.listaCombo",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PREGUNTASSEGURIDADLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasBCAMovilBean cuentasBCAMovilBean = new CuentasBCAMovilBean();

					cuentasBCAMovilBean.setPreguntaID(resultSet.getString("PreguntaID"));
					cuentasBCAMovilBean.setDescripcion(resultSet.getString("Descripcion"));

					return cuentasBCAMovilBean;
				}
			});
			cuentasBCAMovilBeanCon = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista Combo de Preguntas de Seguridad", e);

		}
		return cuentasBCAMovilBeanCon;
	}

	// Valida el usuario que se va a dar de alta en PADEMOBILE
	public MensajeTransaccionBean validaAltaUsuarioPDM(final CuentasBCAMovilBean cuentasBCAMovilBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				cuentasBCAMovilBean.setTelefono(cuentasBCAMovilBean.getTelefono().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASBCAMOVILVAL(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasBCAMovilBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasBCAMovilBean.getCuentaAhoID()));
								sentenciaStore.setString("Par_Telefono",cuentasBCAMovilBean.getTelefono());
								sentenciaStore.setInt("Par_UsuarioPDMID",Utileria.convierteEntero(cuentasBCAMovilBean.getUsuarioPDMID()));

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validaciones en Alta para PADEMOBILE", e);
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

	public ParametrosPDMDAO getParametrosPDMDAO() {
		return parametrosPDMDAO;
	}

	public void setParametrosPDMDAO(ParametrosPDMDAO parametrosPDMDAO) {
		this.parametrosPDMDAO = parametrosPDMDAO;
	}


}
