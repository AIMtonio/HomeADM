package guardaValores.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.drools.process.command.GetObjectCommand;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.servicio.SeguridadRecursosServicio;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class DocumentosGuardaValoresDAO extends BaseDAO {

	public DocumentosGuardaValoresDAO(){
		super();
	}

	// Proceso de Alta de Documentos de Guarda Valores
	public MensajeTransaccionBean altaDocumentosGuardaValores(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final List listaDocumentos) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String numeroExpedienteID = "";
				String numeroDocumentos = "";
				String documentoID = "";
				try {

					// Alta del Expediente en Guarda Valores
					mensajeBean = altaExpediente(documentosGuardaValoresBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Obtengo el Número de Expediente
					numeroExpedienteID = mensajeBean.getConsecutivoString();

					// Valido que la lista de facultados tenga un elemento
					if(listaDocumentos.size() == 0 || listaDocumentos.isEmpty()) {
						mensajeBean.setNumero(1);
						mensajeBean.setDescripcion("La lista de Documentos esta Vacia");
						mensajeBean.setNombreControl("agregaEsquemaDocumento");
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Alta de Documento
					DocumentosGuardaValoresBean documentoBean;
					for(int iteracion=0; iteracion<listaDocumentos.size(); iteracion++){

						documentoBean = (DocumentosGuardaValoresBean)listaDocumentos.get(iteracion);
						documentoBean.setNumeroExpedienteID(numeroExpedienteID);
						mensajeBean = altaDocumento(documentoBean);
						if(mensajeBean.getNumero()!=0){
							iteracion = iteracion+1;
							throw new Exception(mensajeBean.getDescripcion()+"<br>No. Consecutivo: <b>"+ iteracion+ "</b>");
						}
						documentoID = mensajeBean.getConsecutivoString();
						if(iteracion == 0){
							numeroDocumentos = numeroDocumentos+documentoID;
						} else {
							numeroDocumentos = numeroDocumentos+", "+documentoID;
						}
					}
					mensajeBean.setConsecutivoInt(numeroExpedienteID);
					mensajeBean.setConsecutivoString(numeroExpedienteID);
					mensajeBean.setDescripcion("El Expediente: <b>"+ numeroExpedienteID + "</b> Se ha Registrado Correctamente.<br>"
											  +"Los Documentos asociados al No. Expediente "+numeroExpedienteID +" son los siguientes: <b>" +numeroDocumentos+"</b>");
					mensajeBean.setNombreControl("numeroExpedienteID");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta del Expediente del Cliente de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Proceso de Alta de Documentos de Guarda Valores

	// Alta de Expediente
	public MensajeTransaccionBean altaExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL EXPEDIENTEGRDVALORESALT(?,?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()));
								sentenciaStore.setLong("Par_NumeroInstrumento", Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()));
								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_SucursalID", parametrosAuditoriaBean.getSucursal());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Documento de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Alta de Expediente

	// Alta de Documentos
	public MensajeTransaccionBean altaDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL DOCUMENTOSGRDVALORESALT(?,?,?,?,?,"
																		   +"?,?,?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_NumeroExpedienteID", Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()));
								sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()));
								sentenciaStore.setLong("Par_NumeroInstrumento", Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()));
								sentenciaStore.setInt("Par_OrigenDocumento", Utileria.convierteEntero(documentosGuardaValoresBean.getOrigenDocumento()));
								sentenciaStore.setInt("Par_GrupoDocumentoID", Utileria.convierteEntero(documentosGuardaValoresBean.getGrupoDocumentoID()));

								sentenciaStore.setInt("Par_TipoDocumentoID", Utileria.convierteEntero(documentosGuardaValoresBean.getTipoDocumentoID()));
								sentenciaStore.setString("Par_NombreDocumento", documentosGuardaValoresBean.getNombreDocumento());
								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()));
								sentenciaStore.setLong("Par_ArchivoID", Utileria.convierteLong(documentosGuardaValoresBean.getArchivoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Documento de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Alta Documento

	// Proceso de Préstamo de Documentos de Guarda Valores
	public MensajeTransaccionBean prestamoDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				String password = "";
				String clave = "";
				String contrasenia = "";
				String documentoID = "";
				String prestamoDocGrdValoresID = "";

				try {

					documentoID = documentosGuardaValoresBean.getDocumentoID();
					password = documentosGuardaValoresBean.getContrasenia();
					clave =  documentosGuardaValoresBean.getClaveUsuario();
					contrasenia = SeguridadRecursosServicio.encriptaPass(clave, password); // manda de pantalla
					documentosGuardaValoresBean.setContrasenia(contrasenia);

					// Valido la Autorización de Préstamo
					mensajeBean = autorizacionDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Val_Documento.autorizacionOperacion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Registro el Préstamo de documento
					mensajeBean = altaPrestamoDocumento(documentosGuardaValoresBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					prestamoDocGrdValoresID = mensajeBean.getConsecutivoString();
					documentosGuardaValoresBean.setPrestamoDocGrdValoresID(prestamoDocGrdValoresID);

					// Actualizo el estatus de Custodia a Préstamo
					mensajeBean = actualizaEstatusDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Act_Documento.prestamoDocumento);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setConsecutivoInt(documentoID);
					mensajeBean.setConsecutivoString(documentoID);
					mensajeBean.setDescripcion("La Autorización de préstamo del Documento: "+ documentoID + " Se ha realizado Correctamente.<br>"
												+"Número de Préstamo: "+prestamoDocGrdValoresID);
					mensajeBean.setNombreControl("catMovimientoID");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Préstamo de Documentos de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Proceso de Préstamo de Documentos de Guarda Valores

	// Proceso de Devolución de Documentos de Guarda Valores
	public MensajeTransaccionBean devolucionDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				String documentoID = "";
				String prestamoDocGrdValoresID = "";

				try {

					documentoID = documentosGuardaValoresBean.getDocumentoID();

					// Finalizo el Préstamo de documento
					mensajeBean = finalizaPrestamoDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Tran_PrestamoDocumento.prestamoDocumento);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					prestamoDocGrdValoresID = documentosGuardaValoresBean.getPrestamoDocGrdValoresID();
					// Actualizo el estatus de Préstamo a Custodia
					mensajeBean = actualizaEstatusDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Act_Documento.devolucionDocumento);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setConsecutivoInt(documentoID);
					mensajeBean.setConsecutivoString(documentoID);
					mensajeBean.setDescripcion("La Devolución del Préstamo: "+ prestamoDocGrdValoresID + " Se ha realizado Correctamente.");
					mensajeBean.setNombreControl("catMovimientoID");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en al Devolución del Préstamo de Documentos de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Proceso de Devolución de Documentos de Guarda Valores

	// Proceso de Sustitución de Documentos de Guarda Valores
	public MensajeTransaccionBean sustitucionDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				String password = "";
				String clave = "";
				String contrasenia = "";
				String documentoID = "";

				try {

					documentoID = documentosGuardaValoresBean.getDocumentoID();
					password = documentosGuardaValoresBean.getContrasenia();
					clave =  documentosGuardaValoresBean.getClaveUsuario();
					contrasenia = SeguridadRecursosServicio.encriptaPass(clave, password);
					documentosGuardaValoresBean.setContrasenia(contrasenia);

					// Valido la Autorización de Sustitución
					mensajeBean = autorizacionDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Val_Documento.autorizacionSustitucionBaja);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Actualizo el estatus de Custodia a Baja
					mensajeBean = actualizaEstatusDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Act_Documento.sustitucionDocumento);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setConsecutivoInt(documentoID);
					mensajeBean.setConsecutivoString(documentoID);
					mensajeBean.setDescripcion("La Sustitución del Documento: "+ documentoID + " Se ha realizado Correctamente.");
					mensajeBean.setNombreControl("catMovimientoID");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Sustitución de Documentos de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Sustitución de Documentos de Guarda Valores

	// Proceso de Baja de Documentos de Guarda Valores
	public MensajeTransaccionBean bajaDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				String password = "";
				String clave = "";
				String contrasenia = "";
				String documentoID = "";

				try {

					documentoID = documentosGuardaValoresBean.getDocumentoID();
					password = documentosGuardaValoresBean.getContrasenia();
					clave =  documentosGuardaValoresBean.getClaveUsuario();
					contrasenia = SeguridadRecursosServicio.encriptaPass(clave, password);
					documentosGuardaValoresBean.setContrasenia(contrasenia);

					// Valido la Autorización de Baja
					mensajeBean = autorizacionDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Val_Documento.autorizacionSustitucionBaja);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Actualizo el estatus de Custodia a Baja
					mensajeBean = actualizaEstatusDocumento(documentosGuardaValoresBean, DocumentosGuardaValoresServicio.Enum_Act_Documento.bajaDocumento);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setConsecutivoInt(documentoID);
					mensajeBean.setConsecutivoString(documentoID);
					mensajeBean.setDescripcion("La Baja del Documento: "+ documentoID + " Se ha realizado Correctamente.");
					mensajeBean.setNombreControl("catMovimientoID");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en al Baja de Documentos de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Baja de Documentos de Guarda Valores

	// 1.- Asignacion de Ubicación de Documento(R->C): Registrado --> Custodia
	public MensajeTransaccionBean asignaUbicacionGuardaValores(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoActualizacion) {
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
								String query = "CALL DOCUMENTOSGRDVALORESACT(?,?,?,?,?,"
																		   +"?,?,?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_DocumentoID", Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()));
								sentenciaStore.setInt("Par_AlmacenID", Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()));
								sentenciaStore.setString("Par_Ubicacion", documentosGuardaValoresBean.getUbicacion());
								sentenciaStore.setString("Par_Seccion", documentosGuardaValoresBean.getSeccion());
								sentenciaStore.setString("Par_Observaciones", documentosGuardaValoresBean.getObservaciones());

								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_UsuarioPrestamoID", Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Par_PrestamoDocGrdValoresID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_SucursalID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_DocSustitucionID",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_NombreDocSustitucion", Constantes.STRING_VACIO);
								sentenciaStore.setLong("Par_ArchivoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NumeroActualizacion", tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Asignación de Ubicación del Documento de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Asignación de Ubicación de Documento

	// Operaciones del Documento
	// 2.- Préstamo de Documento	(C -> P): Custodia --> Préstamo
	// 3.- Devolución de Documento	(C -> P): Préstamo --> Custodia
	// 4.- sustitución de Documento (C -> B): Custodia --> Baja
	// 5.- Baja de Documento		(C -> B): Custodia --> Baja
	public MensajeTransaccionBean actualizaEstatusDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL DOCUMENTOSGRDVALORESACT(?,?,?,?,?,"
																		   +"?,?,?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_DocumentoID", Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()));
								sentenciaStore.setInt("Par_AlmacenID", Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()));
								sentenciaStore.setString("Par_Ubicacion", documentosGuardaValoresBean.getUbicacion());
								sentenciaStore.setString("Par_Seccion", documentosGuardaValoresBean.getSeccion());
								sentenciaStore.setString("Par_Observaciones", documentosGuardaValoresBean.getObservaciones());

								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_UsuarioPrestamoID", Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioPrestamoID()));
								sentenciaStore.setLong("Par_PrestamoDocGrdValoresID", Utileria.convierteLong(documentosGuardaValoresBean.getPrestamoDocGrdValoresID()));
								sentenciaStore.setInt("Par_SucursalID", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setInt("Par_DocSustitucionID", Utileria.convierteEntero(documentosGuardaValoresBean.getDocSustitucionID()));

								sentenciaStore.setString("Par_NombreDocSustitucion", documentosGuardaValoresBean.getNombreDocSustitucion());
								sentenciaStore.setLong("Par_ArchivoID", Utileria.convierteLong(documentosGuardaValoresBean.getArchivoID()));
								sentenciaStore.setInt("Par_NumeroActualizacion", tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la actualización del Documento de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Operaciones de Documento

	//  Alta Préstamo Documento
	public MensajeTransaccionBean altaPrestamoDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PRESTAMODOCGRDVALORESALT(?,?,?,?,?,"
																		    +"?,?,"
																		    +"?,?,?,"
																		    +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CatMovimientoID", Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()));
								sentenciaStore.setLong("Par_DocumentoID", Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()));
								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_UsuarioPrestamoID", Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioPrestamoID()));
								sentenciaStore.setString("Par_ClaveUsuario", documentosGuardaValoresBean.getClaveUsuario());

								sentenciaStore.setString("Par_Observaciones", documentosGuardaValoresBean.getObservaciones());
								sentenciaStore.setInt("Par_SucursalID", parametrosAuditoriaBean.getSucursal());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Préstamo de Documento en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Alta Préstamo Documento

	//  Autorización de Operación de Documento
	public MensajeTransaccionBean autorizacionDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoValidacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL DOCUMENTOSGRDVALORESVAL(?,?,?,?,?,"
																		   +"?,?,?,?,?,"
																		   +"?,?,?,?,?,"
																		   +"?,?,?,"
																		   +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_DocumentoID", Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()));
								sentenciaStore.setInt("Par_AlmacenID", Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()));
								sentenciaStore.setString("Par_Ubicacion", documentosGuardaValoresBean.getUbicacion());
								sentenciaStore.setString("Par_Seccion", documentosGuardaValoresBean.getSeccion());
								sentenciaStore.setString("Par_Observaciones", documentosGuardaValoresBean.getObservaciones());
								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_UsuarioPrestamoID", Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioPrestamoID()));
								sentenciaStore.setLong("Par_PrestamoDocGrdValoresID", Utileria.convierteLong(documentosGuardaValoresBean.getPrestamoDocGrdValoresID()));
								sentenciaStore.setInt("Par_SucursalID", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setInt("Par_DocSustitucionID", Utileria.convierteEntero(documentosGuardaValoresBean.getDocSustitucionID()));

								sentenciaStore.setString("Par_NombreDocSustitucion", documentosGuardaValoresBean.getNombreDocSustitucion());
								sentenciaStore.setString("Par_ClaveUsuario", documentosGuardaValoresBean.getClaveUsuario());
								sentenciaStore.setString("Par_Contrasenia", documentosGuardaValoresBean.getContrasenia());
								sentenciaStore.registerOutParameter("Par_Control", Types.VARCHAR);
								sentenciaStore.setInt("Par_NumeroValidacion", tipoValidacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Validación de Autorización de Documento en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Autorización de Operación de Documento

	// Finalización de Préstamo Documento
	public MensajeTransaccionBean finalizaPrestamoDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PRESTAMODOCGRDVALORESACT(?,?,?,?,"
																			+"?,?,?,"
																		    +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_PrestamoDocGrdValoresID", Utileria.convierteLong(documentosGuardaValoresBean.getPrestamoDocGrdValoresID()));
								sentenciaStore.setInt("Par_UsuarioRegistroID", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setString("Par_Observaciones", documentosGuardaValoresBean.getObservaciones());
								sentenciaStore.setInt("Par_NumeroActualizacion", tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Actualización del Préstamo del Documento en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Finalización de Préstamo Documento

	// Notificación de Correo por Documentos.
	public MensajeTransaccionBean notificacionCorreo(final DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL NOTIFCACORREOGRDVALPRO(?,?,"
																		  +"?,?,?,"
																		  +"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()));
								sentenciaStore.setString("Par_TipoPersona", documentosGuardaValoresBean.getTipoPersona());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Notificación del Documentos en Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Notificación de Correo por Documentos.


	// Consulta Principal de Expediente
	public DocumentosGuardaValoresBean consultaPrincipalExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean expediente = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESCON(?,?,?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL EXPEDIENTEGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();
					documento.setNumeroExpedienteID(resultSet.getString("NumeroExpedienteID"));
					documento.setTipoInstrumento(resultSet.getString("TipoInstrumento"));
					documento.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documento.setSucursalID(resultSet.getString("SucursalID"));

					documento.setFechaRegistro(resultSet.getString("FechaRegistro"));
					documento.setHoraRegistro(resultSet.getString("HoraRegistro"));
					documento.setParticipanteID(resultSet.getString("ParticipanteID"));
					documento.setTipoPersona(resultSet.getString("TipoPersona"));
					documento.setUsuarioRegistroID(resultSet.getString("UsuarioRegistroID"));

					documento.setEstatus(resultSet.getString("Estatus"));
					return documento;
				}
			});

			expediente = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Expediente de Guarda Valores ", exception);
			expediente = null;
		}

		return expediente;
	}

	// Consulta Expediente por Cliete
	public DocumentosGuardaValoresBean consultaForaneaExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean expediente = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESCON(?,?,?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL EXPEDIENTEGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();
					documento.setNumeroExpedienteID(resultSet.getString("NumeroExpedienteID"));
					documento.setParticipanteID(resultSet.getString("ParticipanteID"));

					return documento;
				}
			});

			expediente = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta foranea de Expediente de Guarda Valores ", exception);
			expediente = null;
		}

		return expediente;
	}

	// Consulta Principal de Documentos
	public DocumentosGuardaValoresBean consultaPrincipalDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean documento = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESCON(?,?,?,?,?,"
													   +"?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),

				documentosGuardaValoresBean.getEstatus(),
				Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL DOCUMENTOSGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();

					documento.setDocumentoID(resultSet.getString("DocumentoID"));
					documento.setNumeroExpedienteID(resultSet.getString("NumeroExpedienteID"));
					documento.setTipoInstrumento(resultSet.getString("TipoInstrumento"));
					documento.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documento.setOrigenDocumento(resultSet.getString("OrigenDocumento"));

					documento.setGrupoDocumentoID(resultSet.getString("GrupoDocumentoID"));
					documento.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					documento.setNombreDocumento(resultSet.getString("NombreDocumento"));
					documento.setParticipanteID(resultSet.getString("ParticipanteID"));
					documento.setTipoPersona(resultSet.getString("TipoPersona"));

					documento.setAlmacenID(resultSet.getString("AlmacenID"));
					documento.setUbicacion(resultSet.getString("Ubicacion"));
					documento.setSeccion(resultSet.getString("Seccion"));
					documento.setObservaciones(resultSet.getString("Observaciones"));
					documento.setEstatus(resultSet.getString("Estatus"));

					documento.setUsuarioRegistroID(resultSet.getString("UsuarioRegistroID"));
					documento.setUsuarioProcesaID(resultSet.getString("UsuarioProcesaID"));
					documento.setSucursalID(resultSet.getString("SucursalID"));
					documento.setFechaRegistro(resultSet.getString("FechaRegistro"));
					documento.setHoraRegistro(resultSet.getString("HoraRegistro"));

					documento.setFechaCustodia(resultSet.getString("FechaCustodia"));
					documento.setUsuarioBajaID(resultSet.getString("UsuarioBajaID"));
					documento.setSucursalBajaID(resultSet.getString("SucursalBajaID"));
					documento.setFechaBaja(resultSet.getString("FechaBaja"));
					documento.setPrestamoDocGrdValoresID(resultSet.getString("PrestamoDocGrdValoresID"));

					documento.setDocSustitucionID(resultSet.getString("DocSustitucionID"));
					documento.setNombreDocSustitucion(resultSet.getString("NombreDocSustitucion"));
					return documento;
				}
			});

			documento = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Documentos de Guarda Valores ", exception);
			documento = null;
		}

		return documento;
	}

	// Consulta Principal de Préstamo de Documentos
	public DocumentosGuardaValoresBean consultaPrincipalPrestamoDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean documento = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PRESTAMODOCGRDVALORESCON(?,?,?,"
														+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getPrestamoDocGrdValoresID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.consultaPrincipalPres",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL PRESTAMODOCGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();

					documento.setPrestamoDocGrdValoresID(resultSet.getString("PrestamoDocGrdValoresID"));
					documento.setCatMovimientoID(resultSet.getString("CatMovimientoID"));
					documento.setDocumentoID(resultSet.getString("DocumentoID"));
					documento.setHoraRegistro(resultSet.getString("HoraRegistro"));
					documento.setFechaRegistro(resultSet.getString("FechaRegistro"));

					documento.setUsuarioRegistroID(resultSet.getString("UsuarioRegistroID"));
					documento.setUsuarioPrestamoID(resultSet.getString("UsuarioPrestamoID"));
					documento.setUsuarioAutorizaID(resultSet.getString("UsuarioAutorizaID"));
					documento.setUsuarioDevolucionID(resultSet.getString("UsuarioDevolucionID"));
					documento.setFechaDevolucion(resultSet.getString("FechaDevolucion"));

					documento.setObservaciones(resultSet.getString("Observaciones"));
					documento.setSucursalID(resultSet.getString("SucursalID"));
					documento.setEstatus(resultSet.getString("Estatus"));

					return documento;
				}
			});

			documento = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Documentos de Guarda Valores ", exception);
			documento = null;
		}

		return documento;
	}

	// Consulta foranea de Documento
	public DocumentosGuardaValoresBean consultaForanea(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean documento = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESCON(?,?,?,?,?,"
													   +"?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),

				documentosGuardaValoresBean.getEstatus(),
				Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL DOCUMENTOSGRDVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();

					documento.setDocumentoID(resultSet.getString("DocumentoID"));
					documento.setFechaRegistro(resultSet.getString("FechaRegistro"));
					documento.setParticipanteID(resultSet.getString("ParticipanteID"));
					documento.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documento.setTipoInstrumento(resultSet.getString("TipoInstrumento"));

					documento.setOrigenDocumento(resultSet.getString("OrigenDocumento"));
					documento.setGrupoDocumentoID(resultSet.getString("GrupoDocumento"));
					documento.setNombreDocumento(resultSet.getString("NombreDocumento"));
					documento.setEstatus(resultSet.getString("Estatus"));
					documento.setSucursalID(resultSet.getString("SucursalID"));

					documento.setTipoPersona(resultSet.getString("TipoPersona"));
					documento.setPrestamoDocGrdValoresID(resultSet.getString("prestamoDocGrdValoresID"));

					return documento;
				}
			});

			documento = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de foranea de Documentos de Guarda Valores ", exception);
			documento = null;
		}

		return documento;
	}

	// Consulta foranea de Documento
	public DocumentosGuardaValoresBean consultaRegistroDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoConsulta) {

		DocumentosGuardaValoresBean documento = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCINSTRUMENTOCON(?,?,?,?,?,"
												 +"?,?,?,"
												 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(documentosGuardaValoresBean.getOrigenDocumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getGrupoDocumentoID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),

				Utileria.convierteLong(documentosGuardaValoresBean.getArchivoID()),
				documentosGuardaValoresBean.getNombreDocumento(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.registroDocumento",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL DOCINSTRUMENTOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean documento = new DocumentosGuardaValoresBean();

					documento.setDocumentoID(resultSet.getString("ClasificaTipDocID"));
					documento.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					documento.setDescripcion(resultSet.getString("Descripcion"));

					return documento;
				}
			});

			documento = matches.size() > 0 ? (DocumentosGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de foranea de Documentos de Guarda Valores ", exception);
			documento = null;
		}
		return documento;
	}

	// Lista Principal Expediente
	public List<DocumentosGuardaValoresBean> listaPrincipalExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaExpediente = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),

				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaExpediente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL EXPEDIENTEGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setNumeroExpedienteID(resultSet.getString("NumeroExpedienteID"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setDescripcion(resultSet.getString("NombreInstrumento"));
					documentos.setSucursalID(resultSet.getString("SucursalID"));
					documentos.setNombreParticipante(resultSet.getString("NombreCompleto"));
					return documentos;

				}
			});

			listaExpediente = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de principal de Expediente de Guarda Valores", exception);
			listaExpediente = null;
		}

		return listaExpediente;
	}

	// Lista Principal Documento
	public List<DocumentosGuardaValoresBean> listaPrincipalDocumentos(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),

				documentosGuardaValoresBean.getEstatus(),
				Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()),
				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaPrincipalDocumento",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCUMENTOSGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setDescripcion(resultSet.getString("NombreInstrumento"));
					documentos.setSucursalID(resultSet.getString("SucursalID"));
					documentos.setNombreParticipante(resultSet.getString("NombreCompleto"));
					return documentos;
				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de principal de Documentos de Guarda Valores", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

	// Lista Ayuda de Documentos
	public List<DocumentosGuardaValoresBean> listaPantalla(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,?,?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),

				documentosGuardaValoresBean.getEstatus(),
				Utileria.convierteEntero(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getCatMovimientoID()),
				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaPantalla",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCUMENTOSGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setDescripcion(resultSet.getString("NombreInstrumento"));
					documentos.setNombreParticipante(resultSet.getString("NombreCompleto"));
					documentos.setGrupoDocumentoID(resultSet.getString("GrupoDocumento"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));

					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					return documentos;
				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de ayuda de Documentos de Guarda Valores", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}


	// Lista Ayuda de Documentos
	public List<DocumentosGuardaValoresBean> listaRegistroDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCINSTRUMENTOLIS(?,?,?,?,?,"
												 +"?,?,"
												 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(documentosGuardaValoresBean.getOrigenDocumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getGrupoDocumentoID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoDocumentoID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),

				documentosGuardaValoresBean.getNombreDocumento(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaRegistro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCINSTRUMENTOLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("ArchivoID"));
					documentos.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					documentos.setDescripcion(resultSet.getString("Descripcion"));
					return documentos;
				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de ayuda de Documentos de Guarda Valores", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}


	// Lista de Grid de Expediente
	public List<DocumentosGuardaValoresBean> listaExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),

				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaExpediente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL EXPEDIENTEGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));
					documentos.setEstatus(resultSet.getString("Estatus"));
					documentos.setUbicacion(resultSet.getString("Ubicacion"));
					return documentos;


				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Expediente por Instrumento en Guarda Valores", exception);
			listaDocumentos = null;
		}
		return listaDocumentos;
	}

	// Lista de Grid de Registro de Expediente
	public List<DocumentosGuardaValoresBean> listaRegistroExpediente(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),

				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.lisRegExpediente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL EXPEDIENTEGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNumeroInstrumento(resultSet.getString("NombreInstrumento"));
					documentos.setGrupoDocumentoID(resultSet.getString("GrupoDocumento"));
					documentos.setTipoDocumentoID(resultSet.getString("TipoDocumentoID"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));
					documentos.setEstatus(resultSet.getString("Estatus"));
					return documentos;


				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Expediente por Instrumento en Guarda Valores", exception);
			listaDocumentos = null;
		}
		return listaDocumentos;
	}

	// Lista Ayuda de Expediente
	public List<DocumentosGuardaValoresBean> listaExpedienteForanea(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoLista) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL EXPEDIENTEGRDVALORESLIS(?,?,?,?,?,"
													   +"?,?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroExpedienteID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getTipoInstrumento()),
				Utileria.convierteLong(documentosGuardaValoresBean.getNumeroInstrumento()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getUsuarioAutorizaID()),

				documentosGuardaValoresBean.getNombreParticipante(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.listaExpediente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL EXPEDIENTEGRDVALORESLIS(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setNumeroExpedienteID(resultSet.getString("NumeroExpedienteID"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setNombreParticipante(resultSet.getString("NombreCompleto"));
					documentos.setTipoPersona(resultSet.getString("TipoPersona"));
					return documentos;
				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de ayuda de Expediente por Instrumento en Guarda Valores", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

	// Reporte de Ingreso de Documentos
	// Reporte de Ingreso de Documentos
	public List<DocumentosGuardaValoresBean> reporteIngresoDocumentos(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoReporte) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESREP(?,?,?,?,?,"
													   +"?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaInicio()),
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaFin()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getEstatus()),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.repIngresoDocumentos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCUMENTOSGRDVALORESREP(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNombreParticipante(resultSet.getString("NombreParticipante"));
					documentos.setTipoInstrumento(resultSet.getString("NombreInstrumento"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));

					documentos.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					documentos.setUbicacion(resultSet.getString("Ubicacion"));
					documentos.setNombreUsuarioRegistroID(resultSet.getString("UsuarioRegistro"));
					return documentos;

				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Ingreso de Documentos en Guarda Valores ", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

	// Reporte de Estatus de Documentos
	// Reporte de Estatus de Documentos
	public List<DocumentosGuardaValoresBean> reporteEstatusDocumentos(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoReporte) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCUMENTOSGRDVALORESREP(?,?,?,?,?,"
													   +"?,"
													   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaInicio()),
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaFin()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getAlmacenID()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getEstatus()),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.repEstatusDocumentos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCUMENTOSGRDVALORESREP(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNombreParticipante(resultSet.getString("NombreParticipante"));
					documentos.setTipoInstrumento(resultSet.getString("NombreInstrumento"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));

					documentos.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					documentos.setUbicacion(resultSet.getString("Ubicacion"));
					documentos.setNombreUsuarioRegistroID(resultSet.getString("UsuarioRegistro"));
					documentos.setEstatus(resultSet.getString("Estatus"));
					documentos.setObservaciones(resultSet.getString("Observaciones"));

					return documentos;

				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Documentos por Estatus de Guarda Valores ", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

	// Reporte de Préstamo de Documentos
	public List<DocumentosGuardaValoresBean> reportePrestamoDocumentos(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoReporte) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PRESTAMODOCGRDVALORESREP(?,?,?,?,?,"
													    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaInicio()),
				Utileria.convierteFecha(documentosGuardaValoresBean.getFechaFin()),
				Utileria.convierteEntero(documentosGuardaValoresBean.getSucursalID()),
				Utileria.convierteLong(documentosGuardaValoresBean.getAlmacenID()),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.repPrestamoDocumentos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PRESTAMODOCGRDVALORESREP(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("DocumentoID"));
					documentos.setNombreParticipante(resultSet.getString("NombreParticipante"));
					documentos.setTipoInstrumento(resultSet.getString("NombreInstrumento"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));

					documentos.setNombreAlmacen(resultSet.getString("NombreAlmacen"));
					documentos.setUbicacion(resultSet.getString("Ubicacion"));
					documentos.setFechaRegistro(resultSet.getString("FechaPrestamo"));
					documentos.setHoraRegistro(resultSet.getString("HoraPrestamo"));
					documentos.setNombreUsuarioRegistroID(resultSet.getString("NombreUsuarioPresto"));

					documentos.setNombreUsuarioAutorizaID(resultSet.getString("NombreUsuarioAutoriza"));
					documentos.setNombreUsuarioProcesaID(resultSet.getString("NombreUsuarioPrestamo"));
					documentos.setFechaDevolucion(resultSet.getString("FechaDevolucion"));
					documentos.setObservaciones(resultSet.getString("Observaciones"));
					return documentos;

				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Préstamos de Documentos en Guarda Valores ", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

	// Reporte de Bitacora de Documentos
	// Reporte de Bitacora por Documento
	public List<DocumentosGuardaValoresBean> reporteBitacoraDocumento(final DocumentosGuardaValoresBean documentosGuardaValoresBean, final int tipoReporte) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL BITACORADOCGRDVALORESREP(?,?,"
													    +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(documentosGuardaValoresBean.getDocumentoID()),
				tipoReporte,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"DocumentosGuardaValoresDAO.repBitacoraDocumento",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL BITACORADOCGRDVALORESREP(" + Arrays.toString(parametros) + ")");
			List<DocumentosGuardaValoresBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DocumentosGuardaValoresBean  documentos = new DocumentosGuardaValoresBean();

					documentos.setDocumentoID(resultSet.getString("Consecutivo"));
					documentos.setTipoInstrumento(resultSet.getString("TipoInstrumento"));
					documentos.setNumeroInstrumento(resultSet.getString("NumeroInstrumento"));
					documentos.setNombreParticipante(resultSet.getString("NombreParticipante"));
					documentos.setNombreDocumento(resultSet.getString("NombreDocumento"));

					documentos.setEstatusPrevio(resultSet.getString("EstatusPrevio"));
					documentos.setEstatus(resultSet.getString("EstatusActual"));
					documentos.setUsuarioRegistroID(resultSet.getString("UsuarioRegistroID"));
					documentos.setFechaRegistro(resultSet.getString("FechaRegistro"));
					documentos.setObservaciones(resultSet.getString("Observaciones"));

					return documentos;

				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Documentos Pendientes de Resguardo de Guarda Valores ", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}

}
