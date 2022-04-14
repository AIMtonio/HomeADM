package originacion.dao;

import java.io.File;
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

import originacion.bean.ConsolidacionCartaLiqBean;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class ConsolidacionCartaLiqDAO extends BaseDAO{

	public ConsolidacionCartaLiqDAO(){
		super();
	}

	public MensajeTransaccionBean grabaDetalle(final ConsolidacionCartaLiqBean consolidaCarLiqBean, final List<ConsolidacionCartaLiqBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					String EstSolicitud = consolidaCarLiqBean.getEstatusSolicitud();
					if (EstSolicitud.equalsIgnoreCase("I") || EstSolicitud.equalsIgnoreCase("L")){
						mensajeBean = baja(consolidaCarLiqBean);
						if (mensajeBean.getNumero() != 0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					for (ConsolidacionCartaLiqBean detalle : listaDetalle){
						MensajeTransaccionArchivoBean mensajeArchivo = null;
						int tipoBaja = 1;

						if(detalle.getModificaArchCarta().equalsIgnoreCase(Constantes.STRING_SI)){
							String DocumentoArchCarta = "9996";

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

						if(!archivoPago.trim().equalsIgnoreCase(Constantes.STRING_VACIO)
								&& detalle.getModificaArchPago().equalsIgnoreCase(Constantes.STRING_SI) ){
							String DocumentoArchPago = "9997";

							// metodo de baja Archivos de Comprobante de Pago
							detalle.setTipoDocumentoID(DocumentoArchPago);
							ConsolidacionCartaLiqBean ArchivoPago = new ConsolidacionCartaLiqBean();

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
							mensajeBean = modifica(detalle, parametrosAuditoriaBean.getNumeroTransaccion());

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

	public MensajeTransaccionBean alta(final ConsolidacionCartaLiqBean consolidaCarLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACIONCARTALIQALT(?,?,?,?,?,  ?,?,?,?,?,  ?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_ClienteID", Utileria.convierteLong(consolidaCarLiqBean.getClienteID()));

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CartaLiquidacionDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " CartaLiquidacionDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el alta" + e);
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

	public MensajeTransaccionBean modifica(final ConsolidacionCartaLiqBean consolidaCarLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ASIGNACARTALIQMOD(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(consolidaCarLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_AsignacionCartaID", Utileria.convierteEntero(consolidaCarLiqBean.getAsignacionCartaID()));
									sentenciaStore.setInt("Par_CasaComercialID", Utileria.convierteEntero(consolidaCarLiqBean.getCasaComercialID()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(consolidaCarLiqBean.getMonto()));
									sentenciaStore.setDate("Par_FechaVigencia", OperacionesFechas.conversionStrDate(consolidaCarLiqBean.getFechaVigencia()));
									sentenciaStore.setInt("Par_ArchivoCartaID", Utileria.convierteEntero(consolidaCarLiqBean.getArchivoIDCarta()));
									sentenciaStore.setInt("Par_ArchivoPagoID", Utileria.convierteEntero(consolidaCarLiqBean.getArchivoIDPago()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConsolidacionCartaLiqDAO.modifica");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConsolidacaionCartaLiqDAO.modifica");
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

	public MensajeTransaccionBean modificaInternas(final ConsolidacionCartaLiqBean consolidaCarLiqBean) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACARTALIQDETMOD(?,?,?,?,?,"
																			  + "?,?,?,?,?,"
																			  + "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(consolidaCarLiqBean.getConsolidacionCartaID()));
									sentenciaStore.setInt("Par_CartaLiquidaID", Utileria.convierteEntero(consolidaCarLiqBean.getCartaLiquidaId()));
									sentenciaStore.setInt("Par_ArchivoCartaID", Utileria.convierteEntero(consolidaCarLiqBean.getArchivoIDCarta()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConsolidacionCartaLiqDAO.modifica");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConsolidacaionCartaLiqDAO.modifica");
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


	public MensajeTransaccionBean baja(final ConsolidacionCartaLiqBean consolidaCarLiqBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ASIGNACARTALIQBAJ(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(consolidaCarLiqBean.getSolicitudCreditoID()));

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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConsolidacionCartaLiqDAO.baja");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConsolidacionCartaLiqDAO.baja");
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

	public List<ConsolidacionCartaLiqBean> lista(ConsolidacionCartaLiqBean consolidaCarLicBean, int tipoLista){
		List<ConsolidacionCartaLiqBean> lista = new ArrayList<ConsolidacionCartaLiqBean>();
		String query = "CALL ASIGNACARTALIQLIS(?,?,?,?,   " +
				 							"?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(consolidaCarLicBean.getSolicitudCreditoID()),
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
			List<ConsolidacionCartaLiqBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsolidacionCartaLiqBean parametro = new ConsolidacionCartaLiqBean();
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
			loggerSAFI.info("Error en ConsolidacionCartaLiqDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	public MensajeTransaccionArchivoBean altaArchivos(final ConsolidacionCartaLiqBean consolidaCarLiqBean){
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDARCHIVOSALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(consolidaCarLiqBean.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(consolidaCarLiqBean.getTipoDocumentoID()));
							sentenciaStore.setString("Par_Comentario",consolidaCarLiqBean.getComentario());
							sentenciaStore.setString("Par_Recurso",consolidaCarLiqBean.getRecurso());
							sentenciaStore.setString("Par_Extension",consolidaCarLiqBean.getExtension());

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

	public MensajeTransaccionArchivoBean bajaArchivos(final ConsolidacionCartaLiqBean cosnolidaCarLiqBean, final int tipoBaja) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();

				try {

			mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					 new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SOLICITUDARCHIVOSBAJ(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(cosnolidaCarLiqBean.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_TipoDocumentoID",Utileria.convierteEntero(cosnolidaCarLiqBean.getTipoDocumentoID()));
							sentenciaStore.setInt("Par_DigSolCreditoID",Utileria.convierteEntero(cosnolidaCarLiqBean.getArchivoIDCarta()));
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

	public List<ConsolidacionCartaLiqBean> listaPrincipal(ConsolidacionCartaLiqBean consolidaCarLiqBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONSOLIDACARTALIQDETLIS(?,?,?,?,?,  ?,?,?,?,?,  ?);";
		Object[] parametros = {
			Utileria.convierteEntero(consolidaCarLiqBean.getConsolidacionCartaID()),
			consolidaCarLiqBean.getConsolidacionCartaID(),
			Constantes.ENTERO_CERO,
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			parametrosAuditoriaBean.getNombrePrograma(),
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSOLIDACARTALIQDETLIS(" + Arrays.toString(parametros) + ")");
		List<ConsolidacionCartaLiqBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConsolidacionCartaLiqBean consolida = new ConsolidacionCartaLiqBean();
				consolida.setConsolidacionCartaID(resultSet.getString("FolioConsolidacion"));
				consolida.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return consolida;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean actualizaDatosConsol(final ConsolidacionCartaLiqBean consolidacionCartaLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACIONCARTALIQACT(?,?,?,?,?,"
																				+ "?,?,?,?,?,"
																				+ "?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicCredID", Utileria.convierteEntero(consolidacionCartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(consolidacionCartaLiqBean.getConsolidacionCartaID()));
									sentenciaStore.setString("Par_TipoCredito", consolidacionCartaLiqBean.getTipoCredito());
									sentenciaStore.setInt("Par_NumAct",1);

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

	public MensajeTransaccionBean actualizaDatosSolic(final ConsolidacionCartaLiqBean consolidacionCartaLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACIONCARTALIQACT(?,?,?,?,?,"
																				+ "?,?,?,?,?,"
																				+ "?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicCredID", Utileria.convierteEntero(consolidacionCartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(consolidacionCartaLiqBean.getConsolidacionCartaID()));
									sentenciaStore.setString("Par_TipoCredito", consolidacionCartaLiqBean.getTipoCredito());
									sentenciaStore.setInt("Par_NumAct",2);

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

	public MensajeTransaccionBean actualizaDatosTemp(final ConsolidacionCartaLiqBean consolidacionCartaLiqBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONSOLIDACIONCARTALIQACT(?,?,?,?,?,"
																				+ "?,?,?,?,?,"
																				+ "?,?,?,?)";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicCredID", Utileria.convierteEntero(consolidacionCartaLiqBean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ConsolidaCartaID", Utileria.convierteEntero(consolidacionCartaLiqBean.getConsolidacionCartaID()));
									sentenciaStore.setString("Par_TipoCredito", consolidacionCartaLiqBean.getTipoCredito());
									sentenciaStore.setInt("Par_NumAct",3);

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


	public ConsolidacionCartaLiqBean consultaPrincipal(ConsolidacionCartaLiqBean consolidacion, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";

		return null;
	}
}
