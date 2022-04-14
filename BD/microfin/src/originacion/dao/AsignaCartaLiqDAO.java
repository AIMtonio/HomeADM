package originacion.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.poi.ss.formula.functions.Replace;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.AsignaCartaLiqBean;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class AsignaCartaLiqDAO extends BaseDAO{

	public AsignaCartaLiqDAO(){
		super();
	}


	/**
	 * Método que elimina y registra las nuevas Asignaciones de Cartas de Liquidacion.
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las Cartas.
	 * @param listaDetalle : Lista de las nuevas Cartas a registrar.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean grabaDetalleInt(final AsignaCartaLiqBean cartaLiqBean,final List<AsignaCartaLiqBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{

					if(cartaLiqBean.getSolicitudCreditoID().equals("0"))
					{
						//Grabar en temporal
						mensajeBean=bajaTempInternas(cartaLiqBean);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						for(AsignaCartaLiqBean detalle : listaDetalle){
							mensajeBean=altaTempInternas(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
					else
					{
						//Grabar en operativas
						mensajeBean=bajaInternas(cartaLiqBean);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean = bajaInstDispersion(cartaLiqBean);
						if(mensajeBean.getNumero()!=0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						for(AsignaCartaLiqBean detalle : listaDetalle){
							mensajeBean=altaInternas(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						// Alta de Instruccion de Dispersion de acuerdo a las nuevas Cartas de Liquidacion.
						mensajeBean = altaInstDispersion(cartaLiqBean);
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



	/**
	 * Método que elimina y registra las nuevas Asignaciones de Cartas de Liquidacion.
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las Cartas.
	 * @param listaDetalle : Lista de las nuevas Cartas a registrar.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */

	public MensajeTransaccionBean grabaDetalle(final AsignaCartaLiqBean cartaLiqBean,final List<AsignaCartaLiqBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					String EstSolicitud = cartaLiqBean.getEstatusSolicitud();

					for(AsignaCartaLiqBean detalle : listaDetalle){
						MensajeTransaccionArchivoBean mensajeArchivo = null;
						int tipoBaja = 1;

						// Archivos de Carta de Liquidacion
						if(detalle.getModificaArchCarta().equalsIgnoreCase(Constantes.STRING_SI)){
							String DocumentoArchCarta = "9996";

							// metodo de baja Archivos Carta de Liq
							detalle.setTipoDocumentoID(DocumentoArchCarta);
							mensajeArchivo = bajaArchivos(detalle,tipoBaja);
							if (mensajeArchivo.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							File archivo=new File(detalle.getRecurso());
							archivo.renameTo(new File(detalle.getRutaFinal()));

							detalle.setRecurso(detalle.getRutaFinal());
							// metodo de Alta Archivos Carta de Liq
							mensajeArchivo = altaArchivos(detalle);
							if (mensajeArchivo.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							detalle.setArchivoIDCarta(mensajeArchivo.getConsecutivoString());

						}

						String archivoPago = detalle.getRecursoPago();

						// Archivos de Comprobante de Pago
						if(!archivoPago.trim().equalsIgnoreCase(Constantes.STRING_VACIO)
									&& detalle.getModificaArchPago().equalsIgnoreCase(Constantes.STRING_SI) ){
							String DocumentoArchPago = "9997";

							// metodo de baja Archivos de Comprobante de Pago
							detalle.setTipoDocumentoID(DocumentoArchPago);
							AsignaCartaLiqBean ArchivoPago = new AsignaCartaLiqBean();

							ArchivoPago.setSolicitudCreditoID(detalle.getSolicitudCreditoID());
							ArchivoPago.setTipoDocumentoID(DocumentoArchPago);
							ArchivoPago.setArchivoIDCarta(detalle.getArchivoIDPago());
							ArchivoPago.setComentario(detalle.getComentarioPago());
							ArchivoPago.setRecurso(detalle.getRutaFinalPago());
							ArchivoPago.setExtension(detalle.getExtensionPago());


							mensajeArchivo = bajaArchivos(ArchivoPago,tipoBaja);
							if (mensajeArchivo.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							File archivo=new File(detalle.getRecursoPago());
							archivo.renameTo(new File(detalle.getRutaFinalPago()));

							mensajeArchivo = altaArchivos(ArchivoPago);
							if (mensajeArchivo.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							detalle.setArchivoIDPago(mensajeArchivo.getConsecutivoString());


						}

						if(EstSolicitud.equalsIgnoreCase("A") || EstSolicitud.equalsIgnoreCase("D")){
							mensajeBean = modifica(detalle);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}else{
							mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}


						//-- cambio de nombre archivo
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

	/**
	 * Método que elimina y registra las nuevas Asignaciones de Cartas de Liquidacion externas
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las Cartas.
	 * @param listaDetalle : Lista de las nuevas Cartas a registrar.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean grabaDetalleGridExt(final AsignaCartaLiqBean cartaLiqBean,final List<AsignaCartaLiqBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				MensajeTransaccionArchivoBean mensajeArchivo = null;
				String DocumentoArchCarta 	= null;
				String DocumentoArchPago 	= null;
				int tipoBaja	 			= 1;

				try{
					if(cartaLiqBean.getSolicitudCreditoID().equals("0")){
						//Grabar en temporal
						mensajeBean=bajaTempExternas(cartaLiqBean);
						if (mensajeBean.getNumero() != 0) {throw new Exception(mensajeBean.getDescripcion());}
						for(AsignaCartaLiqBean detalle : listaDetalle){
							detalle.setConsolidacionID(cartaLiqBean.getConsolidacionID());
							mensajeBean=altaTempExternas(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}else{

						String EstSolicitud = cartaLiqBean.getEstatusSolicitud();
						String rutaFinal = cartaLiqBean.getRutaFiles()+"Solicitudes"+ System.getProperty("file.separator") + "Solicitud" +
								cartaLiqBean.getSolicitudCreditoID() + System.getProperty("file.separator");

						/*Generar la carpeta*/
						File directorio = new File( cartaLiqBean.getRutaFiles() + System.getProperty("file.separator")
						+"Solicitudes"+ System.getProperty("file.separator") + "Solicitud" +
						cartaLiqBean.getSolicitudCreditoID());
				        if (!directorio.exists()) {
				            if (directorio.mkdirs()) {
				                System.out.println("Directorio creado");
				            } else {
				                System.out.println("Error al crear directorio");
				            }
				        }

						DocumentoArchCarta = "9996";
						DocumentoArchPago = "9997";

						//Baja si existen datos en la operativa (detalles)
						mensajeBean = bajaDetExternas(cartaLiqBean);
						if(mensajeBean.getNumero()!=0 ) {throw new Exception(mensajeBean.getDescripcion());}
						//Baja de tabla operativa
						mensajeBean = bajaExternas(cartaLiqBean);
						if(mensajeBean.getNumero()!=0) {throw new Exception(mensajeBean.getDescripcion());}

						mensajeBean = bajaInstDispersion(cartaLiqBean);
						if(mensajeBean.getNumero()!=0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						File SourceO = null;
						File SourceD = null;

						FileChannel origen = null;
				        FileChannel destino = null;

				        long count = 0;
				        long size = 0;

						for(AsignaCartaLiqBean detalle : listaDetalle){
							//metodo de baja Archivos Carta de Liq
							detalle.setTipoDocumentoID(DocumentoArchCarta);
							mensajeArchivo = bajaArchivos(detalle,tipoBaja);
							if (mensajeArchivo.getNumero() != 0) {throw new Exception(mensajeBean.getDescripcion());}
							//Validacion nombre
							if(!detalle.getRecurso().equals(rutaFinal + detalle.getNombreCartaLiq())) {
								SourceO = new File(detalle.getRecurso());
								SourceD = new File(rutaFinal + detalle.getNombreCartaLiq());

								origen = new FileInputStream(SourceO).getChannel();
						        destino = new FileOutputStream(SourceD).getChannel();

						        count = 0;
						        size = origen.size();
						        while((count += destino.transferFrom(origen, count, size-count))<size);
						        origen.close(); destino.close();
							}

							detalle.setRecurso(rutaFinal);
							//metodo de Alta Archivos Carta de Liq
							mensajeArchivo = altaArchivos(detalle);
							if (mensajeArchivo.getNumero() != 0) {throw new Exception(mensajeBean.getDescripcion());}
							detalle.setArchivoIDCarta(mensajeArchivo.getConsecutivoString());

							//Cambiar nombre de archivo
							File carta = new File(rutaFinal + detalle.getNombreCartaLiq());
							boolean b = carta.renameTo(new File(mensajeArchivo.getRecursoOrigen()));
							if(b) {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ "El archivo de la carta se ha generado correctamente");
							}else {
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+ "El archivo de la carta no se ha generado correctamente");
							}
							if(!detalle.getExtensionPago().trim().isEmpty()) {
								//Comprobante de pago
								detalle.setTipoDocumentoID(DocumentoArchPago);
								AsignaCartaLiqBean ArchivoPago = new AsignaCartaLiqBean();
								ArchivoPago.setSolicitudCreditoID(detalle.getSolicitudCreditoID());
								ArchivoPago.setTipoDocumentoID(DocumentoArchPago);
								ArchivoPago.setArchivoIDCarta(detalle.getArchivoIDPago());
								ArchivoPago.setComentario(detalle.getComentarioPago());

								if(!detalle.getRecursoPago().equals(rutaFinal + detalle.getNombreComproPago())) {
									SourceO = new File(detalle.getRecursoPago());
									SourceD = new File(rutaFinal + detalle.getNombreComproPago());

									origen = new FileInputStream(SourceO).getChannel();
									destino = new FileOutputStream(SourceD).getChannel();

							        count = 0;
							        size = origen.size();
							        while((count += destino.transferFrom(origen, count, size-count))<size);
							        origen.close(); destino.close();
								}
								detalle.setRecursoPago(rutaFinal);

								ArchivoPago.setRecurso(detalle.getRecursoPago());
								ArchivoPago.setExtension(detalle.getExtensionPago());

								mensajeArchivo = bajaArchivos(ArchivoPago,tipoBaja);
								if (mensajeArchivo.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeArchivo = altaArchivos(ArchivoPago);
								if (mensajeArchivo.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								detalle.setArchivoIDPago(mensajeArchivo.getConsecutivoString());
								//Cambiar nombre de archivo
								File pagare = new File(rutaFinal + detalle.getNombreComproPago());
								b = pagare.renameTo(new File(mensajeArchivo.getRecursoOrigen()));
								if(b) {
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ "El archivo del pagaré se ha generado correctamente");
								}else {
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+ "El archivo del pagaré no se ha generado correctamente");
								}
							}
							detalle.setSolicitudCreditoID(cartaLiqBean.getSolicitudCreditoID());
							mensajeBean = altaExt(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							detalle.setAsignacionCartaID(mensajeBean.getConsecutivoString());
							detalle.setConsolidacionID(cartaLiqBean.getConsolidacionID());
							mensajeBean = altaDetExternas(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}


						}
						// Alta de Instruccion de Dispersion de acuerdo a las nuevas Cartas de Liquidacion.
						mensajeBean = altaInstDispersion(cartaLiqBean);
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

	/**
	 * Método de baja las Asignaciones de Cartas de Liquidacion Externas.(TMP)
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaTempExternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TMPASIGCARTASLIQUIDABAJ(?,"+
																				"?,?,?,"+
																				"?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID",Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de Alta las Asignaciones de Cartas de Liquidacion Externas.(TMP)
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaTempExternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									File carta= null;
									File pagare= null;
									FileInputStream cartas = null;
									FileInputStream pagares = null;
									int pagareLength = 0;

									String query = "call TMPASIGCARTASLIQUIDAALT(?,?,?,?,?,?,?,?,?,?,"+
																				"?,?,?,"+
																				"?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_ConsolidaCartaID"	,Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setInt("Par_CasaComercialID"		,Utileria.convierteEntero(cartaLiqBean.getCasaComercialID()));
									sentenciaStore.setFloat("Par_Monto"				,Utileria.convierteFlotante(cartaLiqBean.getMonto()));
									sentenciaStore.setString("Par_FechaVigencia"	,cartaLiqBean.getFechaVigencia());



									try {
										carta = new File(cartaLiqBean.getRecurso());
										cartas = new FileInputStream(carta);


										if(cartaLiqBean.getRecursoPago() == ""){
											pagare = new File(cartaLiqBean.getRecursoPago());
											pagares = new FileInputStream(pagare);
											pagareLength =  (int) pagare.length();
										}else{
											pagares = null;
											pagareLength = 0;
										}

									} catch (FileNotFoundException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									sentenciaStore.setBinaryStream("Par_RecursoCarta",cartas, (int) carta.length());
									sentenciaStore.setString("Par_ExtencionCarta"	,cartaLiqBean.getExtension());
									sentenciaStore.setString("Par_ComentarioCarta"	,cartaLiqBean.getComentario());
									sentenciaStore.setBinaryStream("Par_RecursoPagare",pagares, pagareLength);
									sentenciaStore.setString("Par_ExtencionPagare"	, cartaLiqBean.getExtensionPago());
									sentenciaStore.setString("Par_ComentarioPagare"	,cartaLiqBean.getComentarioPago());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPASIGCARTASLIQUIDAALT "+sentenciaStore.toString());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
					}else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Cartas de Liquidación: ", e);
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

	/**
	 * Método de alta las Asignaciones de Cartas de Liquidacion.
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean alta(final AsignaCartaLiqBean cartaLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACIONCARTALIQALT(?,?,?,?,?,  ?,?,?,?,?,  ?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(cartaLiqBean.getClienteID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLIDACIONCARTALIQALT "+sentenciaStore.toString());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
					}else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Cartas de Liquidación: ", e);
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

	/**
	 * Método que Modifica las Asignaciones de Cartas de Liquidacion.
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean modifica(final AsignaCartaLiqBean cartaLiqBean) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ASIGNACARTALIQMOD(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_AsignacionCartaID", Utileria.convierteEntero(cartaLiqBean.getAsignacionCartaID()));
									sentenciaStore.setInt("Par_CasaComercialID", Utileria.convierteEntero(cartaLiqBean.getCasaComercialID()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(cartaLiqBean.getMonto()));
									sentenciaStore.setDate("Par_FechaVigencia", OperacionesFechas.conversionStrDate(cartaLiqBean.getFechaVigencia()));
									sentenciaStore.setInt("Par_ArchivoCartaID", Utileria.convierteEntero(cartaLiqBean.getArchivoIDCarta()));
									sentenciaStore.setInt("Par_ArchivoPagoID", Utileria.convierteEntero(cartaLiqBean.getArchivoIDPago()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.modifica");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.modifica");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la Modificacion de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	/**
	 * Método de baja de Cartas de Liquidacion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean baja(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TMPASIGCARTASLIQUIDABAJ(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de alta las Asignaciones de Cartas de Liquidacion.
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaTempInternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TMPCARTASLIQUIDACIONALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setInt("Par_CartaLiquidaID", Utileria.convierteEntero(cartaLiqBean.getCartaLiquidaID()));
									sentenciaStore.setBytes("Par_RecursoCartaLiq", cartaLiqBean.getRecursoBlob());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPCARTASLIQUIDACIONALT "+sentenciaStore.toString());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
					}else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Cartas de Liquidación: ", e);
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

	/**
	 * Método de alta las Asignaciones de Cartas de Liquidacion.
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaInternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACARTALIQDETALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setInt("Par_AsigCartaID", Utileria.convierteEntero(cartaLiqBean.getAsignacionCartaID()));
//									sentenciaStore.setInt("Par_RecursoCartaLiq", Utileria.convierteEntero(cartaLiqBean.getRecurso()));
									sentenciaStore.setInt("Par_CartaLiquidaID", Utileria.convierteEntero(cartaLiqBean.getCartaLiquidaID()));
									sentenciaStore.setString("Par_TipoCarta", "I");

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPCARTASLIQUIDACIONALT "+sentenciaStore.toString());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
					}else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Cartas de Liquidación: ", e);
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

	/**
	 * Método de alta las Asignaciones de Cartas de Liquidacion.
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaExt(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ASIGNACARTALIQALT(?,?,?,?,?,?,  ?,?,?, ?,?,?,?,?,?,?)";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_CasaComercialID", 	Utileria.convierteEntero(cartaLiqBean.getCasaComercialID()));
									sentenciaStore.setDouble("Par_Monto", 			Utileria.convierteDoble(cartaLiqBean.getMonto()));
									sentenciaStore.setDate("Par_FechaVigencia", 	OperacionesFechas.conversionStrDate(cartaLiqBean.getFechaVigencia()));
									sentenciaStore.setInt("Par_ArchivoCartaID", 	Utileria.convierteEntero(cartaLiqBean.getArchivoIDCarta()));
									sentenciaStore.setInt("Par_ArchivoPagoID", 	    Utileria.convierteEntero(cartaLiqBean.getArchivoIDPago()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ASIGNACARTALIQALT "+sentenciaStore.toString());

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.alta");
					}else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Cartas de Liquidación: ", e);
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


	/**
	 * Método de baja de Cartas de Liquidacion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaTempInternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TMPCARTASLIQUIDACIONBAJ(?,?,?,?,?,"+
																			 	"?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID",Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de baja de Cartas de Liquidacion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaExternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ASIGNACARTALIQBAJ(?, ?,?,?, ?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Alta de los detalles de consolidacion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-CONSOLIDACARTALIQDETALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaDetExternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACARTALIQDETALT(?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ConsolidaCartaID",	Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setInt("Par_AsigCartaID",		Utileria.convierteEntero(cartaLiqBean.getAsignacionCartaID()));
									sentenciaStore.setInt("Par_CartaLiquidaID",		0);//Parametro para internas
									sentenciaStore.setString("Par_TipoCarta",	"E");

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Alta de los detalles de consolidacion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-CONSOLIDACARTALIQDETALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaDetExternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACARTALIQDETBAJ(?,?, ?,?,?, ?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID",	Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setString("Par_TipoCarta",		"E");

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de baja de Cartas de Liquidacion con
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-ASIGNACARTALIQBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaInternas(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACARTALIQDETBAJ(?,?,?,?,?,"+
																			 	"?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID",Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()));
									sentenciaStore.setString("Par_TipoCarta","I");
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaTempInternas");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Cartas de Liquidación: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 */
	public List<AsignaCartaLiqBean> lista(AsignaCartaLiqBean cartaLiqBean, int tipoLista) {
		List<AsignaCartaLiqBean> lista=new ArrayList<AsignaCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,?," +
											 "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()),
				Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AsignaCartaLiqDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ASIGNACARTALIQLIS(" + Arrays.toString(parametros) + ");");
		try{
			@SuppressWarnings("unchecked")
			List<AsignaCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AsignaCartaLiqBean parametro = new AsignaCartaLiqBean();
					parametro.setAsignacionCartaID(resultSet.getString("AsignacionCartaID"));
					parametro.setCasaComercialID(resultSet.getString("CasaComercialID"));
					parametro.setNombreCasa(resultSet.getString("NombreCasaCom"));
					parametro.setMonto(resultSet.getString("Monto"));
					parametro.setMontoAnterior(resultSet.getString("MontoDispersion"));
					parametro.setFechaVigencia(resultSet.getString("FechaVigencia"));
					parametro.setEstatus(resultSet.getString("Estatus"));
					parametro.setNombreCartaLiq(resultSet.getString("NombreCartaLiq"));

					parametro.setRecurso(resultSet.getString("RecursoCarta"));

					parametro.setExtension(resultSet.getString("ExtensionCarta"));
					parametro.setComentario(resultSet.getString("ComentarioCarta"));
					parametro.setArchivoIDCarta(resultSet.getString("ArchivoIDCarta"));
					parametro.setNombreComproPago(resultSet.getString("NombreComproPago"));

					parametro.setRecursoPago(resultSet.getString("RecursoPago"));

					parametro.setExtensionPago(resultSet.getString("ExtensionPago"));
					parametro.setComentarioPago(resultSet.getString("ComentarioPago"));
					parametro.setArchivoIDPago(resultSet.getString("ArchivoIDPago"));
					return parametro;

				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en AsignaCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 */
	public List<AsignaCartaLiqBean> listaExtTemp(final AsignaCartaLiqBean cartaLiqBean, int tipoLista) {
		List<AsignaCartaLiqBean> lista=new ArrayList<AsignaCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,?," +
				 "?,?,?,?,?);";
		Object[] parametros = {
			Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()),
			Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()),
			tipoLista,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"AsignaCartaLiqDAO.lista",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ASIGNACARTALIQLIS(" + Arrays.toString(parametros) + ");");
		try{
			@SuppressWarnings("unchecked")
			List<AsignaCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AsignaCartaLiqBean parametro = new AsignaCartaLiqBean();
					FileOutputStream output = null;
					File archivo = null;


					parametro.setCasaComercialID(resultSet.getString("CasaComercialID"));
					parametro.setNombreCasa(resultSet.getString("NombreCasaCom"));
					parametro.setMonto(resultSet.getString("Monto"));
					parametro.setFechaVigencia(resultSet.getString("FechaVigencia").replaceAll(" 00:00:00.0", ""));

			        try {
			        	String cartaname = "cartaLiq" + cartaLiqBean.getConsolidacionID() + resultSet.getInt("Consecutivo")   + resultSet.getString("ExtencionCarta");
				        String paganame  = "pagare"  +  cartaLiqBean.getConsolidacionID() + resultSet.getInt("Consecutivo") + resultSet.getString("ExtencionPagare");

				        Blob cartablob = resultSet.getBlob("RecursoCarta");
				        Blob pagareblob = resultSet.getBlob("RecursoPagare");

			        	InputStream streamCarta  = cartablob.getBinaryStream();
			        	InputStream streamPagare = pagareblob.getBinaryStream();


			        	File directorio = new File(cartaLiqBean.getRecurso() +System.getProperty("file.separator")+ "Consolidaciones"+
			        								System.getProperty("file.separator") +"Consolidacion" + cartaLiqBean.getConsolidacionID());
				        if (!directorio.exists()) {
				        	if (directorio.mkdirs()) {
				        		loggerSAFI.info("El directorio se ha creado para listar archivos temporales en SAFI");
				            } else {
				            	loggerSAFI.info("Error al crear el directorio");
				            }
				        }

				        archivo = new File(directorio +System.getProperty("file.separator")+ cartaname);
				        byte[] bytes = cartablob.getBytes(1, (int) cartablob.length());
				        FileOutputStream fos = new FileOutputStream(archivo);
				        fos.write(bytes);
				        fos.close();
				        if(!resultSet.getString("ExtencionPagare").trim().isEmpty()){ //Si la extencion del pagare no existe, no crear el pagare
				        	archivo = new File(directorio +System.getProperty("file.separator") + paganame);
				        	bytes = pagareblob.getBytes(1, (int) pagareblob.length());
					        fos = new FileOutputStream(archivo);
					        fos.write(bytes);
					        fos.close();
					        parametro.setRecursoPago(directorio + System.getProperty("file.separator") + paganame);
					        parametro.setNombreComproPago(paganame);
					        parametro.setExtensionPago(resultSet.getString("ExtencionPagare"));
				        }

				        parametro.setRecurso(directorio +System.getProperty("file.separator")+ cartaname);
				        parametro.setNombreCartaLiq(cartaname);
				        parametro.setExtension(resultSet.getString("ExtencionCarta"));

			        } catch (FileNotFoundException e) {
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("\nError en AsignaCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 */
	public List<AsignaCartaLiqBean> listaExtTransicion(final AsignaCartaLiqBean cartaLiqBean, int tipoLista) {
		List<AsignaCartaLiqBean> lista=new ArrayList<AsignaCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,?," +
				 "?,?,?,?,?);";
		Object[] parametros = {
			Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()),
			Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()),
			tipoLista,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"AsignaCartaLiqDAO.lista",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ASIGNACARTALIQLIS(" + Arrays.toString(parametros) + ");");
		try{
			@SuppressWarnings("unchecked")
			List<AsignaCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AsignaCartaLiqBean parametro = new AsignaCartaLiqBean();
					FileOutputStream output = null;
					File archivo = null;

					parametro.setAsignacionCartaID(resultSet.getString("AsignacionCartaID"));
					parametro.setCasaComercialID(resultSet.getString("CasaComercialID"));
					parametro.setNombreCasa(resultSet.getString("NombreCasaCom"));
					parametro.setMonto(resultSet.getString("Monto"));
					parametro.setFechaVigencia(resultSet.getString("FechaVigencia"));

					Blob cartablob = resultSet.getBlob("RecursoCarta");
					parametro.setRecursoBlob(cartablob.getBytes(1, (int) cartablob.length()));
					parametro.setExtension(resultSet.getString("ExtencionCarta"));
					parametro.setComentario(resultSet.getString("ComentarioCarta"));

					parametro.setExtensionPago(resultSet.getString("ExtencionPagare"));
					if(!resultSet.getString("ExtencionPagare").trim().isEmpty()) {
						Blob pagareblob = resultSet.getBlob("RecursoPagare");
						parametro.setRecursoBlobPago(pagareblob.getBytes(1, (int) pagareblob.length()));
				    	parametro.setComentarioPago(resultSet.getString("ComentarioPagare"));
					}
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("\nError en AsignaCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}
	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 */
	public List<AsignaCartaLiqBean> listaExtTempBlob(final AsignaCartaLiqBean cartaLiqBean, int tipoLista) {
		List<AsignaCartaLiqBean> lista=new ArrayList<AsignaCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,?," +
				 "?,?,?,?,?);";
		Object[] parametros = {
			Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()),
			Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()),
			tipoLista,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"AsignaCartaLiqDAO.lista",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ASIGNACARTALIQLIS(" + Arrays.toString(parametros) + ");");
		try{
			@SuppressWarnings("unchecked")
			List<AsignaCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					AsignaCartaLiqBean parametro = new AsignaCartaLiqBean();
					Blob cartablob = resultSet.getBlob("RecursoCarta");
			        Blob pagareblob = resultSet.getBlob("RecursoPagare");
		        	InputStream streamCarta  = cartablob.getBinaryStream();
		        	InputStream streamPagare = pagareblob.getBinaryStream();


					parametro.setCasaComercialID(resultSet.getString("CasaComercialID"));
					parametro.setNombreCasa(resultSet.getString("NombreCasaCom"));
					parametro.setMonto(resultSet.getString("Monto"));
					parametro.setFechaVigencia(resultSet.getString("FechaVigencia"));

					parametro.setRecursoBlob(cartablob.getBytes(1, (int) cartablob.length()));
					parametro.setRecursoBlobPago(pagareblob.getBytes(1, (int) pagareblob.length()));

					parametro.setExtension(resultSet.getString("ExtencionCarta"));
				    parametro.setExtensionPago(resultSet.getString("ExtencionPagare"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("\nError en AsignaCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}


	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 */
	public List<AsignaCartaLiqBean> listaInterna(AsignaCartaLiqBean cartaLiqBean, int tipoLista) {
		List<AsignaCartaLiqBean> lista=new ArrayList<AsignaCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,?," +
											 "?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cartaLiqBean.getConsolidacionID()),
				Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AsignaCartaLiqDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ASIGNACARTALIQLIS(" + Arrays.toString(parametros) + ");");
		try{
			@SuppressWarnings("unchecked")
			List<AsignaCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AsignaCartaLiqBean parametro = new AsignaCartaLiqBean();
					parametro.setConsolidacionID(resultSet.getString("consolidaCartaID"));
					parametro.setCartaLiquidaID(resultSet.getString("cartaLiquidaID"));
					parametro.setCreditoID (resultSet.getString("creditoID"));
					parametro.setMonto(resultSet.getString("montoCredito"));
					parametro.setFechaVigencia(resultSet.getString("fechaVencimiento"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en AsignaCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/* Alta de Archivo o Documento Digitalizado de la Solicitud de Crédito	 */
	public MensajeTransaccionArchivoBean altaArchivos(final AsignaCartaLiqBean cartaLiq) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(cartaLiq.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(cartaLiq.getTipoDocumentoID()));
							sentenciaStore.setString("Par_Comentario",cartaLiq.getComentario());
							sentenciaStore.setString("Par_Recurso",cartaLiq.getRecurso());
							sentenciaStore.setString("Par_Extension",cartaLiq.getExtension());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));

							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccionArchivoBean;
						}
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivo de credito ", e);
			}
			return mensajeBean;
			}
		});
	return mensaje;
	}

	/* Baja de Archivo o Documento Digitalizado de la Solicitud de Crédito con Respecto a los Archivos de Asignacion de Cartas */

	public MensajeTransaccionArchivoBean bajaArchivos(final AsignaCartaLiqBean cartaLiq, final int tipoBaja) {

		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();

		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();

				try {

			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SOLICITUDARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(cartaLiq.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(cartaLiq.getTipoDocumentoID()));
							sentenciaStore.setInt("Par_DigSolCreditoID",Utileria.convierteEntero(cartaLiq.getArchivoIDCarta()));
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditoArchivoDAO");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){

								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));

							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccionArchivoBean;
						}
					}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionArchivoBean();
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de archivos de Solicitud de Crédito", e);

			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	public AsignaCartaLiqBean consultaPrincipal(AsignaCartaLiqBean asignaCarta, int tipoConsulta){
		// Query con el Store Procedure
		String query = "call CONSOLIDACIONCARTALIQCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(asignaCarta.getConsolidacionID()),
				Utileria.convierteEntero(asignaCarta.getSolicitudCreditoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLIDACIONCARTALIQCON(" + Arrays.toString(parametros) + ")");
		@SuppressWarnings("unchecked")
		List<AsignaCartaLiqBean> matches=((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AsignaCartaLiqBean asignaCarta = null;
				try{

					asignaCarta = new AsignaCartaLiqBean();
					asignaCarta.setConsolidacionID(String.valueOf(resultSet.getString("ConsolidaCartaID")));
					asignaCarta.setClienteID(String.valueOf(resultSet.getString("ClienteID")));
					asignaCarta.setNombreCliente(String.valueOf(resultSet.getString("NombreCompleto")));
					asignaCarta.setSolicitudCreditoID(String.valueOf(resultSet.getString("SolicitudCreditoID")));

					asignaCarta.setEsConsolidado(String.valueOf(resultSet.getString("EsConsolidado")));
					asignaCarta.setTipoCredito(String.valueOf(resultSet.getString("TipoCredito")));
					asignaCarta.setRelacionado(String.valueOf(resultSet.getString("Relacionado")));
					asignaCarta.setMontoConsolida(String.valueOf(resultSet.getString("MontoConsolida")));


				} catch (Exception ex){
					loggerSAFI.info("Error al realizar consulta de Consolidacion:" + ex.getMessage(), ex);
					ex.printStackTrace();
				}
				return asignaCarta;
			}
		});
		return matches.size() > 0 ? (AsignaCartaLiqBean) matches.get(0) : null;
	}

	/**
	 * Método de baja de Instrucciones de Dispersion
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-CARTASLIQBENEFIDISCREBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean bajaInstDispersion(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CARTASLIQBENEFIDISCREBAJ(?, ?,?,?, ?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaInstDispersion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.bajaInstDispersion");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Instrucciones de Dispersión: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Alta de las Instrucciones de Dispersion de Cartas Internas y Externas
	 * @param cartaLiqBean : Clase bean que contiene los valores de los parámetros de entrada al SP-CARTASLIQBENEFIDISCREALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaInstDispersion(final AsignaCartaLiqBean cartaLiqBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CARTASLIQBENEFIDISCREALT(?, ?,?,?, ?,?,?,?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cartaLiqBean.getSolicitudCreditoID()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.altaInstDispersion");
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
						throw new Exception(Constantes.MSG_ERROR + " .AsignaCartaLiqDAO.altaInstDispersion");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta de Instrucciones de Dispersión: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}

