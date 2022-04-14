package tesoreria.dao;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
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

import soporte.bean.ParamGeneralesBean;
import tesoreria.bean.CuentasSantanderBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CuentasSantanderDAO extends BaseDAO{

	// ALTA DE CTAS DE SANTANDER
	public MensajeTransaccionBean altaCtasSantander(final CuentasSantanderBean cuentasSantander, final int tipoTransaccion) {
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
								String query = "call CUENTASSANTANDERPRO(?,?,?,?,?,				" +
																		"?,?,?,?,?,				" +
																		"?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(cuentasSantander.getFechaInicio()));
									sentenciaStore.setString("Par_FechaFin", Utileria.convierteFecha(cuentasSantander.getFechaFin()));
									sentenciaStore.setInt("Par_TipoTran", tipoTransaccion);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.altaCuentaNostro");
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasSantanderDAO.altaCtasSantander");
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
							throw new Exception(Constantes.MSG_ERROR + " .CuentasSantanderDAO.altaCtasSantander");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de alta la cuenta de santander" + e);
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

	// ACTUALIZA RESPUESTA CTAS DE SANTANDER
		public MensajeTransaccionBean actualizaCtasSantander(final CuentasSantanderBean cuentasSantander, final int tipoTransaccion) {
			  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CUENTASSANTANDERACT(?,?,?,?,?,			" +
																			"?,?,?,?,?,			" +
																			"?,?,?,?,?,		?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setString("Par_Estatus", cuentasSantander.getEstatus());
										sentenciaStore.setString("Par_NumeroCta", cuentasSantander.getNumeroCta());
										sentenciaStore.setString("Par_CodigoRechazo", cuentasSantander.getCodigoRechazo());
										sentenciaStore.setString("Par_NombreArchivo", cuentasSantander.getArchivoProceso());
										sentenciaStore.setString("Par_TipoArchivo", cuentasSantander.getTipoArchivo());

										sentenciaStore.setInt("Par_TipoAct", tipoTransaccion);
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.altaCuentaNostro");
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
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
											mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasSantanderDAO.actualizaCtasSantander");
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
								throw new Exception(Constantes.MSG_ERROR + " .CuentasSantanderDAO.actualizaCtasSantander");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el estaus de la cuenta de santander" + e);
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

		// BAJA DE ARCHIVOS DE RESPUESTA DE SANTANDER SI EXISTE UN ERROR
		public MensajeTransaccionBean bajaArchivoCtas(final CuentasSantanderBean cuentasSantander, final int tipoBaja) {
			  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DISPARCRESPUESTASANBAJ(?,?,?,?,?,			" +
																			    "?,?,?,?,?,		?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_NombreArchivo", cuentasSantander.getArchivoProceso());
										sentenciaStore.setInt("Par_TipoBaj", tipoBaja);
										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.altaCuentaNostro");
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
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasSantanderDAO.bajaArchivoCtas");
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
								throw new Exception(Constantes.MSG_ERROR + " .CuentasSantanderDAO.bajaArchivoCtas");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de baja la cuenta de santander" + e);
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
		//LISTA PRINCIPAL DE LAS CTAS DE SANTANDER
		public List listaPrincipal(CuentasSantanderBean cuentasSantanderBean, int tipoLista){

			String query = "call CUENTASSANTANDERLIS(?,?,?,?,?," +
													"?,?,?,?,?,		?,?);";

			Object[] parametros = {
						Utileria.convierteFecha(cuentasSantanderBean.getFechaInicio()),
						Utileria.convierteFecha(cuentasSantanderBean.getFechaFin()),
						cuentasSantanderBean.getTipoCta(),
						cuentasSantanderBean.getEstatus(),
	                	tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASSANTANDERLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasSantanderBean cuentasSantander = new CuentasSantanderBean();
					cuentasSantander.setTipoCta(resultSet.getString("TipoCuenta"));
					cuentasSantander.setNumeroCta(resultSet.getString("NumeroCta"));
					cuentasSantander.setTitular(resultSet.getString("Titular"));
					cuentasSantander.setClaveBanco(resultSet.getString("ClaveBanco"));
					cuentasSantander.setPazaBanxico(resultSet.getString("PazaBanxico"));
					cuentasSantander.setSucursal(resultSet.getString("SucursalID"));
					cuentasSantander.setTipoCtaID(resultSet.getString("TipoCta"));
					cuentasSantander.setBenefAppPaterno(resultSet.getString("BenefAppPaterno"));
					cuentasSantander.setBenefAppMaterno(resultSet.getString("BenefAppMaterno"));
					cuentasSantander.setBenefNombre(resultSet.getString("BenefNombre"));
					cuentasSantander.setBenefDireccion(resultSet.getString("BenefDireccion"));
					cuentasSantander.setBenefCiudad(resultSet.getString("BenefCiudad"));
					cuentasSantander.setEstatus(resultSet.getString("Estatus"));
					return cuentasSantander;
				}
			});
			return matches;
		}



		//EJETUTAMOS EL SH PARA EL PROCESO DE ARCHIVO
		public MensajeTransaccionBean procesaArchivoCtas(CuentasSantanderBean cuentasSantanderBean, String rutaProteties){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			try{
				//Generacion de archivos de Estado de Cuentas
				if(cuentasSantanderBean.getExtensionArch2().equals("txt")){
					cuentasSantanderBean.setDelimitador2("|");
				}
				if(cuentasSantanderBean.getExtensionArch2().equals("csv")){
					cuentasSantanderBean.setDelimitador2(",");
				}
				if(cuentasSantanderBean.getExtensionArch1().equals("txt")){
					cuentasSantanderBean.setDelimitador1("|");
				}
				if(cuentasSantanderBean.getExtensionArch1().equals("csv")){
					cuentasSantanderBean.setDelimitador1(",");
				}

				String shProcesaRespuesta = "/opt/SAFI/ETLS/TESORERIA/DISPSANTANDER/ProcesaArchSantander.sh";
				loggerSAFI.info("\nDatos:" + shProcesaRespuesta+
						"\n[\n	transaccion:"+parametrosAuditoriaBean.getNumeroTransaccion()+
						"\n	CtasActivas:"+cuentasSantanderBean.getRutaArchCtasActivas()+
						"\n	CtasPedientes:"+cuentasSantanderBean.getRutaArchCtasPendientes()+
						"\n	Transferencias: "+
						"\n	OrdenPago: "+
						"\n]");

				//Procesando el SH
				String[] command = {"bash",
						shProcesaRespuesta,
						cuentasSantanderBean.getRutaArchCtasActivas(),						//RUTA DE ARCHIVO DE CUENTAS ACTIVAS
						cuentasSantanderBean.getRutaArchCtasPendientes(),					//RUTA DE ARCHIVO DE CUENTAS PENDIENTES
						cuentasSantanderBean.getFechaSistema(),								//FECHA DEL SISTEMA
						cuentasSantanderBean.getArchCtasActivas(),							//NOMBRE DEL ARCHIVO DE CUENTAS ACTIVAS
						cuentasSantanderBean.getArchCtasPendientes(),						//NOMBRE DEL ARCHIVO DE CUENTAS PENDIENTES
						cuentasSantanderBean.getDelimitador1(),								//DELIMITADOR DEL ARCHIVO 1
						cuentasSantanderBean.getDelimitador2(),								//DELIMITADOR DEL ARCHIVO 2
						String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()),		// NUMERO DE TRANSACCION
						String.valueOf(parametrosAuditoriaBean.getFecha()),					// FECHA DEL SISTEMA
						rutaProteties,														// RUTA DE ARCHIVO DE CONFIGURACION DE CONEXIONES
						Constantes.STRING_VACIO,											// RUTA DEL ARCHIVO DE RESPUESTA DE SANTANDER TRANSFERENCIAS
						Constantes.STRING_VACIO,											// NOMBRE DEL ARCHIVO DE TRANSFERENCIAS SANTANDER
						Constantes.STRING_VACIO,											// RUTA DEL ARCHIVO DE ORDEN DE PAGO
						Constantes.STRING_VACIO												// NOMBRE DEL ARCHVIO DE ORDEN DE PAGO
				};

				ProcessBuilder pb = new ProcessBuilder(command);
				pb.command(command);
				loggerSAFI.info(this.getClass()+" - "+"Inicio Ejecucion ETL por SH");
				Process p = pb.start();
				p.waitFor();
				loggerSAFI.info(this.getClass()+" - "+"Fin Ejecucion ETL por SH");

				InputStream is = p.getInputStream();
				InputStreamReader isr = new InputStreamReader(is);
				BufferedReader bufferedR = new BufferedReader(isr);
				String line;
				String respuesta = null;

				while ((line = bufferedR.readLine()) != null) {
					respuesta = line;
				}
				String[] partes = respuesta.split("-");
				int codigoRespuesta = Utileria.convierteEntero(partes[0]);
				String mensajeRespuesta = partes[1];

				mensaje.setNumero(codigoRespuesta);
				mensaje.setDescripcion(mensajeRespuesta);

				//VALIDAMOS SI EXISTE UN ERROR AL PROCESAR LOS ARCHIVOS, LOS ELIMINAMOS
				if(mensaje.getNumero()!=0){
					if(cuentasSantanderBean.getRutaArchCtasActivas()!="" && cuentasSantanderBean.getRutaArchCtasActivas()!=null && (mensaje.getNumero()==1 || mensaje.getNumero()==2)){
						Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasActivas());
						mensaje.setNumero(999);
						mensaje.setDescripcion("Disculpe las molestias, a ocurrido un error al procesar el archivo ["+cuentasSantanderBean.getRutaArchCtasActivas()+"]. <br><br>"+mensajeRespuesta);
						throw new Exception(mensaje.getDescripcion());
					}
					if(cuentasSantanderBean.getRutaArchCtasPendientes()!="" && cuentasSantanderBean.getRutaArchCtasPendientes()!=null && (mensaje.getNumero()==1 || mensaje.getNumero()==3)){
						Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasPendientes());
						mensaje.setNumero(999);
						mensaje.setDescripcion("Disculpe las molestias, a ocurrido un error al procesar el archivo ["+cuentasSantanderBean.getRutaArchCtasActivas()+"]. <br><br>"+mensajeRespuesta);
						throw new Exception(mensaje.getDescripcion());
					}

				}

				if(cuentasSantanderBean.getRutaArchCtasActivas()!="" && cuentasSantanderBean.getRutaArchCtasActivas()!=null){
					// ACTUAIZAMOS EL ESTATUS DE LAS CTAS ACTIVAS
					cuentasSantanderBean.setArchivoProceso(cuentasSantanderBean.getArchCtasActivas());
					cuentasSantanderBean.setTipoArchivo("CA");
					mensaje = actualizaCtasSantander(cuentasSantanderBean, 1);
					if(mensaje.getNumero()!=0){
						//ELIMINAMOS LOS REGISTROS DE LA TABLA DISPCTAPENDIENTES
						mensaje = bajaArchivoCtas(cuentasSantanderBean, 1);
						mensaje.setNumero(200);
						mensaje.setDescripcion("Error al procesar el archivo ["+cuentasSantanderBean.getArchCtasActivas()+"].");
						Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasActivas());

					}
				}

				if(cuentasSantanderBean.getRutaArchCtasPendientes()!="" && cuentasSantanderBean.getRutaArchCtasPendientes()!=null && mensaje.getNumero()==0){
					// ACTUALIZAMOS LAS CTAS PENDIENTES
					cuentasSantanderBean.setArchivoProceso(cuentasSantanderBean.getArchCtasPendientes());
					cuentasSantanderBean.setTipoArchivo("CP");
					mensaje = actualizaCtasSantander(cuentasSantanderBean, 2);
					if(mensaje.getNumero()!=0){
						//ELIMINAMOS LOS REGISTROS DE LA TABLA DISPCTAPENDIENTES
						mensaje = bajaArchivoCtas(cuentasSantanderBean, 2);
						mensaje.setNumero(200);
						mensaje.setDescripcion("Error al procesar el archivo ["+cuentasSantanderBean.getArchCtasPendientes()+"].");
						//ELIMINAMOS EL ARCHIVO DE LA RUTA CORRESPONDIENTE
						Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasPendientes());
					}
				}
				else{
					Utileria.borraArchivo(cuentasSantanderBean.getRutaArchCtasPendientes());
				}

			}catch(IllegalThreadStateException e){
				mensaje.setNumero(Integer.valueOf("001"));
				mensaje.setDescripcion("Error al procesar los archivos.");
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar los archivos. ", e);
			}
			return mensaje;
		}

}
