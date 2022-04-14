package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Compress;
import herramientas.Constantes;
import herramientas.Correo;
import herramientas.Correo.SecureConexion;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
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
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.EdoCtaClavePDFBean;
import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.bean.EdoCtaParamsBean;
import soporte.bean.EdoCtaTmpEnvioCorreoBean;
import soporte.bean.ParamGeneralesBean;
import cliente.bean.ClienteBean;
import cliente.dao.ClienteDAO;



public class EdoCtaEnvioCorreoDAO extends BaseDAO {
	EdoCtaTmpEnvioCorreoDAO edoCtaTmpEnvioCorreoDAO;
	EdoCtaParamsDAO edoCtaParamsDAO = null;
	EdoCtaClavePDFDAO edoCtaClavePDFDAO;
	ClienteDAO clienteDAO;
	ParamGeneralesDAO paramGeneralesDAO;

	public MensajeTransaccionBean grabaDatosEnvioCorreo(final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean, final ArrayList listaDetalleGrid){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				EdoCtaEnvioCorreoBean iterEdoCtaEnvioCorreoBean = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					Correo envioCorreo;
					File archivoPDF;
					File archivoXML;
					Compress generadorZIP;
					int consultaParamsEdoCta = 1;
					int actEstatusEnvio = 1;
					int consultaClavePDF = 1;
					int consultaCliente = 1;
					EdoCtaClavePDFBean edoCtaClavePDFBean = null;
					EdoCtaClavePDFBean clavePDFBean = null;
					ClienteBean clienteBean = null;
					String rutaArchivoZip = "";
					String anio = "";
					String mes = "";
					String asunto = "";
					String clavePDF = "";
					int total = 0;
					int exitosos = 0;
					int fallidos = 0;
					String[] resultado = new String[2];
					boolean requiereAut;
					EdoCtaParamsBean edoCtaParamsBean = null;
					edoCtaParamsBean = edoCtaParamsDAO.consultaPrincipal(consultaParamsEdoCta);
					if (edoCtaParamsBean != null) {
						if (edoCtaParamsBean.getEnvioAutomatico().equals(Constantes.STRING_SI)) {
							if(!listaDetalleGrid.isEmpty()) {
								total = listaDetalleGrid.size();
								requiereAut = edoCtaParamsBean.getRequiereAut().equals(Constantes.STRING_SI);
								for(int bean = 0; bean < listaDetalleGrid.size(); bean++){
									iterEdoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) listaDetalleGrid.get(bean);
									if(iterEdoCtaEnvioCorreoBean.getCorreo().equals(Constantes.STRING_VACIO)) {
										fallidos++;
										loggerSAFI.error("El cliente " + iterEdoCtaEnvioCorreoBean.getClienteID() + " no cuenta con un correo");
										continue;
									}
									envioCorreo = new Correo();
									if (edoCtaParamsBean.getTipoAut().equals("SSL")) {
										resultado = envioCorreo.configuracion(	edoCtaParamsBean.getServidorSMTP(),
																				Utileria.convierteEntero(edoCtaParamsBean.getPuertoSMTP()),
																				edoCtaParamsBean.getCorreoRemitente(),
																				edoCtaParamsBean.getContraseniaRemitente(),
																				SecureConexion.SSL,
																				requiereAut,
																				false);
									} else if (edoCtaParamsBean.getTipoAut().equals("NINGUNA")) {
										resultado = envioCorreo.configuracion(	edoCtaParamsBean.getServidorSMTP(),
																				Utileria.convierteEntero(edoCtaParamsBean.getPuertoSMTP()),
																				edoCtaParamsBean.getCorreoRemitente(),
																				edoCtaParamsBean.getContraseniaRemitente(),
																				SecureConexion.NINGUNA,
																				requiereAut,
																				false);
									} else {
										throw new Exception("Error en la configuración de envio de correo");
									}
									mensajeBean.setNumero(Utileria.convierteEntero(resultado[0]));
									mensajeBean.setDescripcion(resultado[1]);
									if(mensajeBean.getNumero() != 0) {
										fallidos++;
										loggerSAFI.error(mensajeBean.getDescripcion());
										continue;
									}

									resultado = envioCorreo.anadirDestinatarios(iterEdoCtaEnvioCorreoBean.getCorreo());
									mensajeBean.setNumero(Utileria.convierteEntero(resultado[0]));
									mensajeBean.setDescripcion(resultado[1]);
									if(mensajeBean.getNumero() != 0) {
										fallidos++;
										loggerSAFI.error(mensajeBean.getDescripcion());
										continue;
									}

									archivoPDF = new File(iterEdoCtaEnvioCorreoBean.getRutaPDF());
									archivoXML = new File(iterEdoCtaEnvioCorreoBean.getRutaXML());

									if(!archivoPDF.exists() || archivoPDF.isDirectory()) {
										fallidos++;
										loggerSAFI.error("La ruta " + archivoPDF + " no existe");
										continue;
									}

									generadorZIP = new Compress();
									rutaArchivoZip = System.getProperty("java.io.tmpdir") + "/" + archivoPDF.getName().substring(0, archivoPDF.getName().length() - 4) + ".zip";

									edoCtaClavePDFBean = new EdoCtaClavePDFBean();
									edoCtaClavePDFBean.setClienteID(iterEdoCtaEnvioCorreoBean.getClienteID());

									clavePDFBean = edoCtaClavePDFDAO.consultaPrincipalClavePDF(edoCtaClavePDFBean, consultaClavePDF);

									if (clavePDFBean != null) {
										clavePDF = clavePDFBean.getClavePDF();
									} else {
										clienteBean = clienteDAO.consultaPrincipal(Utileria.convierteEntero(iterEdoCtaEnvioCorreoBean.getClienteID()), consultaCliente);
										if (clienteBean != null) {
											clavePDF = iterEdoCtaEnvioCorreoBean.getClienteID() + clienteBean.getFechaNacimiento().replaceAll("-", "");
										} else {
											fallidos++;
											loggerSAFI.error("El cliente especificado no existe");
											continue;
										}
									}

									if(!archivoXML.exists() || archivoXML.isDirectory()) {
										generadorZIP.comprimir(rutaArchivoZip, clavePDF, iterEdoCtaEnvioCorreoBean.getRutaPDF());
									} else {
										generadorZIP.comprimir(rutaArchivoZip, clavePDF, iterEdoCtaEnvioCorreoBean.getRutaPDF(), iterEdoCtaEnvioCorreoBean.getRutaXML());
									}

									resultado = envioCorreo.adjuntarArchivos(rutaArchivoZip);
									mensajeBean.setNumero(Utileria.convierteEntero(resultado[0]));
									mensajeBean.setDescripcion(resultado[1]);
									if(mensajeBean.getNumero() != 0) {
										fallidos++;
										loggerSAFI.error(mensajeBean.getDescripcion());
										continue;
									}

									anio = iterEdoCtaEnvioCorreoBean.getAnioMes().substring(0, 4);

									mes = iterEdoCtaEnvioCorreoBean.getAnioMes().substring(4);

									asunto = edoCtaParamsBean.getAsunto() + " " + mes + "/" + anio;

									resultado = envioCorreo.enviar(edoCtaParamsBean.getCuerpoTexto(), "Este cliente no soporta mensajes con formato HTML", asunto);
									mensajeBean.setNumero(Utileria.convierteEntero(resultado[0]));
									mensajeBean.setDescripcion(resultado[1]);
									if(mensajeBean.getNumero() != 0) {
										fallidos++;
										loggerSAFI.error(mensajeBean.getDescripcion());
										continue;
									}

									mensajeBean = null;

									mensajeBean = actualizaEstatusEnvioEdoCta(parametrosAuditoriaBean.getNumeroTransaccion(), actEstatusEnvio, iterEdoCtaEnvioCorreoBean);
									if(mensajeBean.getNumero() != 0) {
										fallidos++;
										loggerSAFI.error(mensajeBean.getDescripcion());
										continue;
									}
									exitosos++;
								}
							}
						} else {
							throw new Exception("Se debe habilitar primero el envio de correos de estado de cuenta. Diríjase a la pantalla de Parámetros de Estado de Cuenta");
						}
					} else {
						throw new Exception("Error en la consulta de parámetros de estado de cuenta");
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Proceso de envio de correo finalizado.\nTotal de estados de cuenta seleccionados: " + total
												+ "\nTotal de envios exitosos: " + exitosos
												+ "\nTotal de envios fallidos: " + fallidos);
					mensajeBean.setNombreControl("anioMes");
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error al grabar datos de envío de correo", e);
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	public MensajeTransaccionBean actualizaEstatusEnvioEdoCta(final long numeroTransaccion, final int numeroActualizacion, final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL EDOCTAENVIOCORREOACT(?,?,?,?,?, "	+ "?,?,?,?,?, "
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_AnioMes", Utileria.convierteEntero(edoCtaEnvioCorreoBean.getAnioMes()));
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(edoCtaEnvioCorreoBean.getClienteID()));
									sentenciaStore.setDate("Par_FechaEnvio", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_Productos",Constantes.STRING_VACIO );
									sentenciaStore.setInt("Par_NumAct", numeroActualizacion);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "EdoCtaEnvioCorreoDAO.actualizaEstatusEnvioEdoCta");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

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

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.actualizaEstatusEnvioEdoCta");
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
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaPDFDAO.actualizaEdoCtaPDF");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el estatus de envio del Estado de cuenta" + e);
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

	public List listaPorPeriodo(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		List registros = null;
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAENVIOCORREOLIS(?,?,?,?, ?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(edoCtaEnvioCorreoBean.getAnioMes()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaEnvioCorreoDAO.listaPeriodos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaEnvioCorreoBean estatusEnvioCorreoBean = new EdoCtaEnvioCorreoBean();
					estatusEnvioCorreoBean.setAnioMes(resultSet.getString("AnioMes"));
					estatusEnvioCorreoBean.setSucursalID(resultSet.getString("SucursalID"));
					estatusEnvioCorreoBean.setClienteID(resultSet.getString("ClienteID"));
					estatusEnvioCorreoBean.setNombreCliente(resultSet.getString("NombreComple"));
					estatusEnvioCorreoBean.setCorreo(resultSet.getString("CorreoEnvio"));
					estatusEnvioCorreoBean.setRutaPDF(resultSet.getString("RutaPDF"));
					estatusEnvioCorreoBean.setRutaXML(resultSet.getString("RutaXML"));
					return estatusEnvioCorreoBean;
				}
			});
			return registros = matches.size() > 0 ? matches: null;

		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista.", e);
			e.printStackTrace();
		}
		return registros;
	}

	public List listaPorCliente(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		List registros = null;
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAENVIOCORREOLIS(?,?,?,?, ?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteEntero(edoCtaEnvioCorreoBean.getClienteID()),
									Constantes.STRING_VACIO,

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaEnvioCorreoDAO.listaPeriodos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaEnvioCorreoBean estatusEnvioCorreoBean = new EdoCtaEnvioCorreoBean();
					estatusEnvioCorreoBean.setAnioMes(resultSet.getString("AnioMes"));
					estatusEnvioCorreoBean.setSucursalID(resultSet.getString("SucursalID"));
					estatusEnvioCorreoBean.setClienteID(resultSet.getString("ClienteID"));
					estatusEnvioCorreoBean.setNombreCliente(resultSet.getString("NombreComple"));
					estatusEnvioCorreoBean.setCorreo(resultSet.getString("CorreoEnvio"));
					estatusEnvioCorreoBean.setRutaPDF(resultSet.getString("RutaPDF"));
					estatusEnvioCorreoBean.setRutaXML(resultSet.getString("RutaXML"));
					return estatusEnvioCorreoBean;
				}
			});
			return registros = matches.size() > 0 ? matches: null;

		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista.", e);
			e.printStackTrace();
		}
		return registros;
	}

	public List listaPeriodos(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		List periodos = null;
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAENVIOCORREOLIS(?,?,?,?, ?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									edoCtaEnvioCorreoBean.getAnioMes(),

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaEnvioCorreoDAO.listaPeriodos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaEnvioCorreoBean periodoBean = new EdoCtaEnvioCorreoBean();
					periodoBean.setAnioMes(resultSet.getString("AnioMes"));
					return periodoBean;
				}
			});
			return periodos = matches.size() > 0 ? matches: null;

		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de periodos.", e);
			e.printStackTrace();
		}
		return periodos;
	}


	/**
	 * Funcion para importar de la base de datos de MicrofinEdoCta a Microfin, los envio de correos
	 * de estados de cuenta.
	 *
	 * @param edoCtaEnvioCorreoBean
	 * @return
	 */
	public MensajeTransaccionBean importaEdoCtasGenerados(final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean) {
		loggerSAFI.info("EdoCtaEnvioCorreoDAO.importaEdoCtasGenerados()>>>>>>");
		final int listaPrincipal = 1;
		final int bajaCompleta = 1;
		final int procesoActualizacion = 1;
		final int consultaOrigenDatosEdoCta = 14;

		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				EdoCtaEnvioCorreoBean iterEdoCtaEnvioCorreoBean = null;
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				EdoCtaTmpEnvioCorreoBean edoCtaTmpEnvioCorreoBean = null;
				String nombreOrigenDatosMicrofin = parametrosAuditoriaBean.getOrigenDatos();
				//String nombreOrigenDatosProduccion = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosEdoCta");
				String nombreOrigenDatosProduccion = null;

				try {
					//Obtenemos el nombre del JNDI para conectarnos a Microfin Estados de cuenta
					ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
					ParamGeneralesBean paramGeneralesBeanResponse = paramGeneralesDAO.consultaPrincipal(paramGeneralesBean, consultaOrigenDatosEdoCta);
					nombreOrigenDatosProduccion = paramGeneralesBeanResponse.getValorParametro();

					//Listamos los correos por periodo
					List<EdoCtaEnvioCorreoBean> listaCorreos = (List<EdoCtaEnvioCorreoBean>) listaPrincipal(listaPrincipal, edoCtaEnvioCorreoBean, nombreOrigenDatosProduccion);
					if(listaCorreos == null || listaCorreos.size() == 0) {
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("No se encontraron registros por importar.");
						mensajeBean.setNombreControl("anioMes");

						return mensajeBean;
					}

					//Borramos en la temporal todos los correos actuales
					edoCtaTmpEnvioCorreoBean = new EdoCtaTmpEnvioCorreoBean();
					edoCtaTmpEnvioCorreoDAO.bajaCompletaEdoCtaTmpEnvioCorreo(bajaCompleta, edoCtaTmpEnvioCorreoBean, nombreOrigenDatosMicrofin);

					//Insertamos en la temporal todos los correos uno a uno.
					for(EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean: listaCorreos) {
						edoCtaTmpEnvioCorreoBean = new EdoCtaTmpEnvioCorreoBean();
						edoCtaTmpEnvioCorreoBean.setAnioMes(edoCtaEnvioCorreoBean.getAnioMes());
						edoCtaTmpEnvioCorreoBean.setClienteID(edoCtaEnvioCorreoBean.getClienteID());
						edoCtaTmpEnvioCorreoBean.setSucursalID(edoCtaEnvioCorreoBean.getSucursalID());
						edoCtaTmpEnvioCorreoBean.setCorreo(edoCtaEnvioCorreoBean.getCorreo());
						edoCtaTmpEnvioCorreoBean.setEstatusEdoCta(edoCtaEnvioCorreoBean.getEstatusEdoCta());
						edoCtaTmpEnvioCorreoBean.setEstatusEnvio(edoCtaEnvioCorreoBean.getEstatusEnvio());
						edoCtaTmpEnvioCorreoBean.setFechaEnvio(edoCtaEnvioCorreoBean.getFechaEnvio());
						edoCtaTmpEnvioCorreoBean.setUsuarioEnvia(edoCtaEnvioCorreoBean.getUsuarioEnvia());
						edoCtaTmpEnvioCorreoBean.setPdfGenerado(edoCtaEnvioCorreoBean.getPdfGenerado());

						mensajeBean = edoCtaTmpEnvioCorreoDAO.altaEdoCtaTmpEnvioCorreo(edoCtaTmpEnvioCorreoBean, nombreOrigenDatosMicrofin);
						if( mensajeBean.getNumero() != 0){
							return mensajeBean;
						}
					}

					//Procesamos la tabla temporal y actualizamos el envio de correos
					edoCtaTmpEnvioCorreoDAO.proEdoCtaEnvioCorreo(procesoActualizacion, edoCtaEnvioCorreoBean, nombreOrigenDatosMicrofin);


					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Se importó correctamente los Estatos de cuenta generados.");
					mensajeBean.setNombreControl("anioMes");
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error al dar de alta los correos ", e);
				}
				return mensajeBean;
			}
		});
		return mensajeResultado;
	}

	/**
	 * Funcion para la Sincronizacion de los documentos de EdoCta mendiante el RSync.
	 *
	 * Para la sincronizacion no se borran los archivos previamente sincronizados,
	 * solo se actualizan los archivos modificados y se copian los archivos nuevos
	 * de la carpeta de Origen a la carpeta destino.
	 *
	 * @return
	 */
	public MensajeTransaccionBean sincronizaCarpetaEdoCta(final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		loggerSAFI.info("sincronizando carpetas de EdoCta");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea = null;
		ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
		int consultaPrincipal = 1;

		EdoCtaParamsBean edoCtaParamsBean = edoCtaParamsDAO.consultaPrincipal(consultaPrincipal);
		if("".equals(edoCtaParamsBean.getRutaExpPDF()) || "".equals(edoCtaParamsBean.getRutaCFDI()) || "".equals(edoCtaParamsBean.getRutaCBB()) ){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique en los Param. Cta. las Rutas de los Directorios.");
			loggerSAFI.error(mensaje.getDescripcion());

			return mensaje;
		}

		ParamGeneralesBean paramIPServidorGeneracion =
				paramGeneralesDAO.consultaPrincipal(paramGenerales, ParamGeneralesDAO.Enum_Con_ParamGenerales.IPServidorGeneracionEdoCta);
		if(paramIPServidorGeneracion == null || "".equals(paramIPServidorGeneracion.getValorParametro())){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique en los Parametros generales la IP del Servidor de Generacion de Estados de Cuenta.");
			loggerSAFI.error(mensaje.getDescripcion());

			return mensaje;
		}

		ParamGeneralesBean paramUsuarioServidorGeneracion =
				paramGeneralesDAO.consultaPrincipal(paramGenerales, ParamGeneralesDAO.Enum_Con_ParamGenerales.UsuarioServidorGeneracionEdoCta);
		if(paramIPServidorGeneracion == null || "".equals(paramIPServidorGeneracion.getValorParametro())){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique en los Parametros generales el Usuario para la importacion de Estados de Cuenta del Servidor de Generacion.");
			loggerSAFI.error(mensaje.getDescripcion());

			return mensaje;
		}

		//Establecemos el Periodo
		edoCtaParamsBean.setAnioMes(edoCtaEnvioCorreoBean.getAnioMes());
		try{
			//Sincronizacion de Archivos PDF
			String rutaDestinoPDFs = edoCtaParamsBean.getRutaExpPDF() + edoCtaParamsBean.getAnioMes() + "/";
			String rutaOrigenPDFs = paramUsuarioServidorGeneracion.getValorParametro() + "@" + paramIPServidorGeneracion.getValorParametro()
					+ ":" + edoCtaParamsBean.getRutaExpPDF() + edoCtaParamsBean.getAnioMes() + "/";

			EdoCtaEnvioCorreoBean edoCtaSincronizacionArchivos = new EdoCtaEnvioCorreoBean();
			edoCtaSincronizacionArchivos.setRutaCompletaOrigen(rutaOrigenPDFs);
			edoCtaSincronizacionArchivos.setRutaCompletaDestino(rutaDestinoPDFs);
			loggerSAFI.info("Sincronizando carpeta de archivos PDF");
			MensajeTransaccionBean resultadoSincronizacion = sincronizaCarpeta(edoCtaSincronizacionArchivos);
			loggerSAFI.info("Sincronizacion terminada " + resultadoSincronizacion.getNumero() + " - " + resultadoSincronizacion.getDescripcion());
			if(resultadoSincronizacion.getNumero() != 0){
				mensaje.setNumero(1);
				mensaje.setDescripcion(resultadoSincronizacion.getDescripcion());

				return mensaje;
			}

			//Sincronizacion de Archivos XML
			String rutaDestinoXMLs = edoCtaParamsBean.getRutaCFDI() + edoCtaParamsBean.getAnioMes() + "/";
			String rutaOringenXMLs = paramUsuarioServidorGeneracion.getValorParametro() + "@" + paramIPServidorGeneracion.getValorParametro()
					+ ":" + edoCtaParamsBean.getRutaCFDI() + edoCtaParamsBean.getAnioMes() + "/";

			edoCtaSincronizacionArchivos = new EdoCtaEnvioCorreoBean();
			edoCtaSincronizacionArchivos.setRutaCompletaOrigen(rutaOringenXMLs);
			edoCtaSincronizacionArchivos.setRutaCompletaDestino(rutaDestinoXMLs);
			loggerSAFI.info("Sincronizando carpeta de archivos XML");
			resultadoSincronizacion = sincronizaCarpeta(edoCtaSincronizacionArchivos);
			loggerSAFI.info("Sincronizacion terminada " + resultadoSincronizacion.getNumero() + " - " + resultadoSincronizacion.getDescripcion());
			if(resultadoSincronizacion.getNumero() != 0){
				mensaje.setNumero(1);
				mensaje.setDescripcion(resultadoSincronizacion.getDescripcion());

				return mensaje;
			}

			//Sincronizacion de Archivos CBB
			String rutaDestCBBs = edoCtaParamsBean.getRutaCBB() + edoCtaParamsBean.getAnioMes() + "/";
			String rutaOrigenCBBs = paramUsuarioServidorGeneracion.getValorParametro() + "@" + paramIPServidorGeneracion.getValorParametro()
					+ ":" + edoCtaParamsBean.getRutaCBB() + edoCtaParamsBean.getAnioMes() + "/";

			edoCtaSincronizacionArchivos = new EdoCtaEnvioCorreoBean();
			edoCtaSincronizacionArchivos.setRutaCompletaOrigen(rutaOrigenCBBs);
			edoCtaSincronizacionArchivos.setRutaCompletaDestino(rutaDestCBBs);
			loggerSAFI.info("Sincronizando carpeta de archivos CBB");
			resultadoSincronizacion = sincronizaCarpeta(edoCtaSincronizacionArchivos);
			loggerSAFI.info("Sincronizacion terminada " + resultadoSincronizacion.getNumero() + " - " + resultadoSincronizacion.getDescripcion());
			if(resultadoSincronizacion.getNumero() != 0){
				mensaje.setNumero(1);
				mensaje.setDescripcion(resultadoSincronizacion.getDescripcion());

				return mensaje;
			}

			mensaje.setNumero(0);
			mensaje.setDescripcion("Sincronización de archivos exitosa!!");
		}
		catch(Exception e){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Error en la sincornización de archivos.");
			e.printStackTrace();
		}

		return mensaje;
	}

	/**
	 * Funcion para la Sincronizacion de dos directorios mediante el Uso del RSync.
	 *
	 * Para la sincronizacion no se borran los archivos previamente sincronizados,
	 * solo se actualizan los archivos modificados y se copian los archivos nuevos
	 * de la carpeta de Origen a la carpeta destino.
	 *
	 * @return
	 */
	private MensajeTransaccionBean sincronizaCarpeta(final EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String linea = null;

		try{

			String[] command = {"rsync", "--omit-dir-times", "--no-perms", "--quiet", "-avz",
					edoCtaEnvioCorreoBean.getRutaCompletaOrigen(), edoCtaEnvioCorreoBean.getRutaCompletaDestino()};
			loggerSAFI.info("origen:" + edoCtaEnvioCorreoBean.getRutaCompletaOrigen() + " destino:" + edoCtaEnvioCorreoBean.getRutaCompletaDestino());
			//String Builder con salidas de Error.
			StringBuilder salidaErrores = new StringBuilder();

			ProcessBuilder processBuilder = new ProcessBuilder(command);
			Process process = processBuilder.start();
			process.waitFor();

			//Leemos salida de error del RSync
			InputStream inputStream = process.getInputStream();
			InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
			BufferedReader salidaPrograma = new BufferedReader(inputStreamReader);
			while ((linea = salidaPrograma.readLine()) != null) {
				loggerSAFI.error(linea);
				salidaErrores.append(linea);
			}

			//Leemos cualquier otra salida de error
			inputStream = process.getErrorStream();
			inputStreamReader = new InputStreamReader(inputStream);
			BufferedReader errorReader = new BufferedReader(inputStreamReader);
			while ((linea = errorReader.readLine()) != null) {
				loggerSAFI.error(linea);
				salidaErrores.append(linea);
			}

			//Validamos que no exista salida de Error
			if(!"".equals(salidaErrores.toString())) {
				throw new Exception(salidaErrores.toString());
			}

			mensaje.setNumero(0);
			mensaje.setDescripcion("Sincronizacion de archivos exitoso!!");

		}
		catch(Exception e){
			mensaje.setNumero(1);
			mensaje.setDescripcion("Error en la sincornización de archivos.");
			e.printStackTrace();
		}

		return mensaje;
	}

	public List listaPrincipal(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean, final String nombreOrigenDatos){
		List periodos = null;
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAENVIOCORREOLIS(?,?,?,?,   ?,   ?,?,?,?,?,?,?);";
			Object[] parametros = {	edoCtaEnvioCorreoBean.getAnioMes(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaEnvioCorreoDAO.listaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(nombreOrigenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = new EdoCtaEnvioCorreoBean();

					edoCtaEnvioCorreoBean.setAnioMes(resultSet.getString("AnioMes"));
					edoCtaEnvioCorreoBean.setClienteID(resultSet.getString("ClienteID"));
					edoCtaEnvioCorreoBean.setSucursalID(resultSet.getString("SucursalID"));
					edoCtaEnvioCorreoBean.setCorreo(resultSet.getString("CorreoEnvio"));
					edoCtaEnvioCorreoBean.setEstatusEdoCta(resultSet.getString("EstatusEdoCta"));
					edoCtaEnvioCorreoBean.setEstatusEnvio(resultSet.getString("EstatusEnvio"));
					edoCtaEnvioCorreoBean.setFechaEnvio(resultSet.getString("FechaEnvio"));
					edoCtaEnvioCorreoBean.setPdfGenerado(resultSet.getString("PDFGenerado"));

					return edoCtaEnvioCorreoBean;
				}
			});
			return periodos = matches.size() > 0 ? matches: null;

		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista principal.", e);
			e.printStackTrace();
		}
		return periodos;
	}

	public List listaEdoCtas(int tipoLista, EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean){
		List registros = null;
		try{
			//Query con el Store Procedure
			String query = "call EDOCTAENVIOCORREOLIS(?,?,?,?, ?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteEntero(edoCtaEnvioCorreoBean.getClienteID()),
									Constantes.STRING_VACIO,

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"EdoCtaEnvioCorreoDAO.listaPeriodos",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAENVIOCORREOLIS(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EdoCtaEnvioCorreoBean estatusEnvioCorreoBean = new EdoCtaEnvioCorreoBean();
					estatusEnvioCorreoBean.setAnioMes(resultSet.getString("AnioMes"));
					estatusEnvioCorreoBean.setSucursalID(resultSet.getString("SucursalID"));
					estatusEnvioCorreoBean.setClienteID(resultSet.getString("ClienteID"));
					estatusEnvioCorreoBean.setNombreCliente(resultSet.getString("NombreComple"));
					estatusEnvioCorreoBean.setCorreo(resultSet.getString("CorreoEnvio"));
					estatusEnvioCorreoBean.setRutaPDF(resultSet.getString("RutaPDF"));
					estatusEnvioCorreoBean.setRutaXML(resultSet.getString("RutaXML"));
					return estatusEnvioCorreoBean;
				}
			});
			return registros = matches.size() > 0 ? matches: null;

		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista.", e);
			e.printStackTrace();
		}
		return registros;
	}


	public EdoCtaTmpEnvioCorreoDAO getEdoCtaTmpEnvioCorreoDAO() {
		return edoCtaTmpEnvioCorreoDAO;
	}

	public void setEdoCtaTmpEnvioCorreoDAO(
			EdoCtaTmpEnvioCorreoDAO edoCtaTmpEnvioCorreoDAO) {
		this.edoCtaTmpEnvioCorreoDAO = edoCtaTmpEnvioCorreoDAO;
	}

	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}

	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}

	public EdoCtaClavePDFDAO getEdoCtaClavePDFDAO() {
		return edoCtaClavePDFDAO;
	}

	public void setEdoCtaClavePDFDAO(EdoCtaClavePDFDAO edoCtaClavePDFDAO) {
		this.edoCtaClavePDFDAO = edoCtaClavePDFDAO;
	}

	public ClienteDAO getClienteDAO() {
		return clienteDAO;
	}

	public void setClienteDAO(ClienteDAO clienteDAO) {
		this.clienteDAO = clienteDAO;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

}
