	package spei.dao;

import java.rmi.RemoteException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cardinal.seguridad.mars.Encryptor20;
import cliente.bean.ClienteBean;
import cuentas.bean.CuentasAhoBean;
import spei.bean.AutorizaSpeiBean;
import spei.bean.DescargaRemesasBean;
import spei.bean.PagoRemesaSPEIBean;
import spei.bean.ParametrosSpeiBean;
import spei.bean.RemesasBean;
import spei.bean.RemesasWSBean;
import spei.beanWS.request.SpeiEnvioBeanRequest;
import spei.beanWS.response.SpeiEnvioBeanResponse;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import spei.servicioweb.Service1SoapProxy;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;
import soporte.consumo.rest.ConsumidorRest;
import spei.dao.ParametrosSpeiDAO;
import com.google.gson.Gson;
import spei.bean.TarBitaSpeiRemesasBean;
import ventanilla.bean.SpeiEnvioBean;

	public class PagoRemesaSPEIDAO extends BaseDAO{

		private ParamGeneralesDAO paramGeneralesDAO = null;
		private Service1SoapProxy service1SoapProxy = null;
		private ParametrosSpeiDAO parametrosSpeiDAO = null;

		final String			saltoLinea				= " <br> ";
		private long			start					= 0;
		private double			tiempo					= 0;
		private double			end						= 0;
		final boolean			origenVent				= true;
		boolean 				excepcionTimedOut		= false;
		String 					rcode					= "";

		public final static String[] Error_TimeOut 	= {
			"Read timed out",
			"Connection timed out",
			"Expiró el tiempo de conexión (Connection timed out)",
			"Expiró el tiempo de conexión",
			"connect timed out"
		};

		public PagoRemesaSPEIDAO() {
			super();
		}

		   public MensajeTransaccionBean procesoRemesas(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoTransaccion, final List listaCodigosResp) {

				transaccionDAO.generaNumeroTransaccion();

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PagoRemesaSPEIBean pagoRemSPEIBean;
					SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();
					String STATUS_PorPagar = "3";

					int tipoTrans = 1;
					for(int i=0; i<listaCodigosResp.size(); i++){

						// BEAN DEL REGISTRO
						pagoRemSPEIBean = (PagoRemesaSPEIBean)listaCodigosResp.get(i);

						//CONSUMO WS METODO INFO PARA CONSULTAR EL ESTATUS DE LA REMESA
						mensajeBean = consultaINFO(pagoRemSPEIBean);

						if(mensajeBean.getNumero()!=0){
							loggerSAFI.info(mensajeBean.getDescripcion());
						} else {
							// SI EL ESTATUS DE LA ORDEN AUN ES "POR PAGAR" ENTONCES SE PROCEDE A APLICAR EL PAGO
							if (mensajeBean.getCampoGenerico().equals(STATUS_PorPagar)) {
								// APLICACION DE PAGO SAFI
								mensajeBean = pagoRemesaSpei(pagoRemSPEIBean, tipoTrans);

								if(mensajeBean.getNumero()!=0){
									loggerSAFI.info(mensajeBean.getDescripcion());
								} else {
									String folioSpeiID = mensajeBean.getCampoGenerico();
									// ENVIO PAGO STP
									speiEnvioBean.setFolioSpeiID(folioSpeiID);
									speiEnvioBean = consultaEnvioSPEI(speiEnvioBean, 1);

									try {
										Encryptor20 encryptor = new Encryptor20();
										String firmaSAFI = "";

							        	firmaSAFI = folioSpeiID + speiEnvioBean.getCuentaBeneficiario() + speiEnvioBean.getCuentaOrd();

							        	firmaSAFI = encryptor.generaFirmaStrong(firmaSAFI);

							        	speiEnvioBean.setFolioSpeiID(folioSpeiID);
							        	speiEnvioBean.setFirma(firmaSAFI);
									} catch (Exception e) {
										mensajeBean.setNumero(999);
										loggerSAFI.info("Ha ocurrido un error al generar la Firma del SPEI.");
									}

									if (mensajeBean.getNumero() == 0) {
										mensajeBean = actualizarFirmaRemesaSPEI(speiEnvioBean, 600);

										if(mensajeBean.getNumero()!=0){
											loggerSAFI.info(mensajeBean.getDescripcion());
										}
									}
								}
							}
						}
					}

					mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
					mensajeBean.setDescripcion("Remesas SPEI Actualizadas Exitosamente.");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
				}
				return mensajeBean;
			}

		   public MensajeTransaccionBean procesoAgentes(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoTransaccion, final List listaCodigosResp) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							PagoRemesaSPEIBean pagoRemesaSPEIBean;
							SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();
							String STATUS_PorPagar = "3";

							int tipoTransaccion=2;
							for(int i=0; i<listaCodigosResp.size(); i++){

								// BEAN DEL REGISTRO
								pagoRemesaSPEIBean = (PagoRemesaSPEIBean)listaCodigosResp.get(i);

								// APLICACION DE PAGO SAFI
								mensajeBean = pagoAgentesSpei(pagoRemesaSPEIBean, tipoTransaccion);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

								String folioSpeiID = mensajeBean.getCampoGenerico();
								// ENVIO PAGO STP
								speiEnvioBean.setFolioSpeiID(folioSpeiID);
								speiEnvioBean = consultaEnvioSPEI(speiEnvioBean, 1);

								try {
									Encryptor20 encryptor = new Encryptor20();
									String firmaSAFI = "";

							        firmaSAFI = folioSpeiID + speiEnvioBean.getCuentaBeneficiario() + speiEnvioBean.getCuentaOrd();

							        firmaSAFI = encryptor.generaFirmaStrong(firmaSAFI);

							        speiEnvioBean.setFolioSpeiID(folioSpeiID);
							        speiEnvioBean.setFirma(firmaSAFI);
								} catch (Exception e) {
									mensajeBean.setNumero(999);
									throw new Exception("Ha ocurrido un error al generar la Firma del SPEI.");
								}

								mensajeBean = actualizarFirmaRemesaSPEI(speiEnvioBean, 600);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
								mensajeBean.setDescripcion("Remesas SPEI Actualizadas Exitosamente.");
							}
						} catch (Exception e) {
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}

		   public MensajeTransaccionBean cancelaRemesas(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoTransaccion, final List listaCodigosResp) {
				transaccionDAO.generaNumeroTransaccion();

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PagoRemesaSPEIBean pagoRemSPEIBean;

					int tipoTrans=3;
					for(int i=0; i<listaCodigosResp.size(); i++){

						// BEAN DEL REGISTRO
						pagoRemSPEIBean = (PagoRemesaSPEIBean)listaCodigosResp.get(i);

						// CANCELACION REMESA SAFI
						mensajeBean = cancelacionRemesa(pagoRemSPEIBean, tipoTrans);

						if(mensajeBean.getNumero()!=0){
							loggerSAFI.info(mensajeBean.getDescripcion());
						}

						pagoRemSPEIBean.setMetodo("D");	// Devolucion
						mensajeBean = altaBitacora(pagoRemSPEIBean);

						if (mensajeBean.getNumero()!=0){
							loggerSAFI.info(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
					mensajeBean.setDescripcion("Remesas SPEI Actualizadas Exitosamente.");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de codigos", e);
				}

				return mensajeBean;
			}

			// Actualiza el estatus
			public MensajeTransaccionBean pagoRemesaSpei(final PagoRemesaSPEIBean pagoRemesaSPEIBean, final int tipoTransaccion) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
							// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SPEIREMESASPRO(?,?,?,?,?, ?,?,?,?,?,"
																 + "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_SpeiRemID",pagoRemesaSPEIBean.getSpeiRemID());
								sentenciaStore.setInt("Par_CuentaAhoID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_ClienteID",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_UsuarioAutoriza",pagoRemesaSPEIBean.getUsuarioAutoriza());
								sentenciaStore.setInt("Par_TipoOperacion",tipoTransaccion);

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
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}


			public MensajeTransaccionBean pagoAgentesSpei(final PagoRemesaSPEIBean pagoRemesaSPEIBean, final int tipoTransaccion) {
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
										String query = "call SPEIREMESASPRO(?,?,?,?,?, ?,?,?,?,?,"
																		 + "?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_SpeiRemID",pagoRemesaSPEIBean.getSpeiRemID());
										sentenciaStore.setString("Par_CuentaAhoID",pagoRemesaSPEIBean.getCuentaAhoID());
										sentenciaStore.setString("Par_ClienteID",pagoRemesaSPEIBean.getClienteID());
										sentenciaStore.setString("Par_UsuarioAutoriza",pagoRemesaSPEIBean.getUsuarioAutoriza());
										sentenciaStore.setInt("Par_TipoOperacion",tipoTransaccion);

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
											mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
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




			/* lista para traer  */
			public List listaPagoRemesaVentanilla(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoLista){
				String query = "call SPEIREMESASLIS(?,?,?,?,?, ?,?,?,?,?,"
												 + "?);";
				Object[] parametros = {
							pagoRemesaSPEIBean.getSpeiRemID(),
							pagoRemesaSPEIBean.getEstatus(),
							pagoRemesaSPEIBean.getCuentaAhoID(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIREMESASLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PagoRemesaSPEIBean pagoRemesaSPEIBean = new PagoRemesaSPEIBean();
						pagoRemesaSPEIBean.setSpeiRemID(resultSet.getString(1));
						pagoRemesaSPEIBean.setCuentaOrd(resultSet.getString(2));
						pagoRemesaSPEIBean.setCuentaBeneficiario(resultSet.getString(3));
						pagoRemesaSPEIBean.setNombreBeneficiario(resultSet.getString(4));
						pagoRemesaSPEIBean.setClaveRastreo(resultSet.getString(5));
						pagoRemesaSPEIBean.setMonto(resultSet.getString(6));

						return pagoRemesaSPEIBean;


					}
				});
				return matches;
			}



			/* lista para traer  */
			public List listaCuentasRemesas(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoLista){
				String query = "call SPEIREMESASLIS(?,?,?,?,?, ?,?,?,?,?,"
												 + "?);";
				Object[] parametros = {
							pagoRemesaSPEIBean.getSpeiRemID(),
							pagoRemesaSPEIBean.getEstatus(),
							pagoRemesaSPEIBean.getCuentaAhoID(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIREMESASLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PagoRemesaSPEIBean pagoRemesaSPEIBean = new PagoRemesaSPEIBean();
						pagoRemesaSPEIBean.setCuentaAho(Utileria.completaCerosIzquierda(resultSet.getInt(1),PagoRemesaSPEIBean.LONGITUD_ID));
						pagoRemesaSPEIBean.setNombreOrd(resultSet.getString(2));

						return pagoRemesaSPEIBean;


					}
				});
				return matches;
			}

			/* lista para traer  */
			public List listaAutorizacion(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoLista){
				String query = "call CARTAAUTORIZACIONLIS(?, ?,?,?,?,?,?,?);";
				Object[] parametros = {
							pagoRemesaSPEIBean.getSpeiRemID(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTAAUTORIZACIONLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						PagoRemesaSPEIBean pagoRemesaSPEIBean = new PagoRemesaSPEIBean();

						pagoRemesaSPEIBean.setCuentaClabe(resultSet.getString("CuentaClabe"));
						pagoRemesaSPEIBean.setBanco(resultSet.getString("Banco"));
						pagoRemesaSPEIBean.setSucursal(resultSet.getString("Sucursal"));
						pagoRemesaSPEIBean.setFechaHora(resultSet.getString("FechaHora"));
						pagoRemesaSPEIBean.setMonto(resultSet.getString("MontoTransferir"));
						pagoRemesaSPEIBean.setIvaPorPagar(resultSet.getString("IVAPorPagar"));
						pagoRemesaSPEIBean.setComision(resultSet.getString("ComisionTrans"));
						pagoRemesaSPEIBean.setConceptoPago(resultSet.getString("ConceptoPago"));
						pagoRemesaSPEIBean.setTotalCargo(resultSet.getString("TotalCargoCuenta"));
						pagoRemesaSPEIBean.setSumaTotalLetras(resultSet.getString("SumaTotalLet"));

						return pagoRemesaSPEIBean;
					}
				});
				return matches;
			}


			public PagoRemesaSPEIBean consultaCtasRem(PagoRemesaSPEIBean pagoRemesaSPEIBean, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call SPEIREMESASCON(?,?,?,?,?, ?,?,?,?,?,"
												 + "?,?,?,?);";
				Object[] parametros = {	Constantes.ENTERO_CERO,
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,

										pagoRemesaSPEIBean.getCuentaAhoID(),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"PagoRemesaSPEIDAO.consultaCtasRem",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIREMESASCON(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						PagoRemesaSPEIBean pagoRemesaSPEIBean = new PagoRemesaSPEIBean();

						pagoRemesaSPEIBean.setCuentaAho(Utileria.completaCerosIzquierda(resultSet.getInt(1),PagoRemesaSPEIBean.LONGITUD_ID));
						pagoRemesaSPEIBean.setCuentaAhoID(resultSet.getString("cuentaAhoID"));
						pagoRemesaSPEIBean.setEstatusCuenta(resultSet.getString("estatusCuenta"));
						pagoRemesaSPEIBean.setSaldoDisponible(resultSet.getString("SaldoDispon"));
						pagoRemesaSPEIBean.setClienteID(resultSet.getString("ClienteID"));
						pagoRemesaSPEIBean.setEstatusOrd(resultSet.getString("EstatusCliente"));
						pagoRemesaSPEIBean.setNombreOrd(resultSet.getString("NombreCompleto"));
						pagoRemesaSPEIBean.setRazonSocial(resultSet.getString("RazonSocial"));
						pagoRemesaSPEIBean.setTipoCuenta(resultSet.getString("TipoCuenta"));

						return pagoRemesaSPEIBean;
					}
				});
				return matches.size() > 0 ? (PagoRemesaSPEIBean) matches.get(0) : null;
			}

			public RemesasWSBean consultaCadenaInfo(PagoRemesaSPEIBean remesaBean, int tipoConsulta) {
				//Query con el Store Procedure
				RemesasWSBean remWSBean = new RemesasWSBean();
				try {
					String query = "call NOTIFICAREMSOFICON(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";
					Object[] parametros = {
								remesaBean.getClaveRastreo(),
								remesaBean.getVisa(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DescargaRemesasDAO.consultaCadenaInfo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call NOTIFICAREMSOFICON(" + Arrays.toString(parametros) + ")");

					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum)
										throws SQLException {
									RemesasWSBean remesasWSBean = new RemesasWSBean();
									remesasWSBean.setDatos(resultSet.getString("CadenaB64"));

									return remesasWSBean;
								}
							});
					return remWSBean = matches.size() > 0 ? (RemesasWSBean) matches
							.get(0) : null;
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de la cadena b64", e);
				}
				return remWSBean;
			}

			public RemesasWSBean consultaCadenaReportarPago(PagoRemesaSPEIBean remesaBean, int tipoConsulta) {
				//Query con el Store Procedure
				RemesasWSBean remWSBean = new RemesasWSBean();
				try {
					String query = "call NOTIFICAREMSOFICON(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";
					Object[] parametros = {
								remesaBean.getClaveRastreo(),
								remesaBean.getVisa(),
								remesaBean.getPasaporte(),
								remesaBean.getGreenCard(),
								remesaBean.getSegSocial(),
								remesaBean.getMatrConsular(),
								remesaBean.getIfe(),
								remesaBean.getLicencia(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DescargaRemesasDAO.consultaCadenaInfo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call NOTIFICAREMSOFICON(" + Arrays.toString(parametros) + ")");

					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum)
										throws SQLException {
									RemesasWSBean remesasWSBean = new RemesasWSBean();
									remesasWSBean.setDatos(resultSet.getString("CadenaB64"));

									return remesasWSBean;
								}
							});
					return remWSBean = matches.size() > 0 ? (RemesasWSBean) matches
							.get(0) : null;
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de la cadena b64", e);
				}
				return remWSBean;
			}

			public MensajeTransaccionBean enviaPagoSTP(SpeiEnvioBeanRequest envioSpeiBean, PagoRemesaSPEIBean pagoRem) {
				MensajeTransaccionBean mensaje = null;
				SpeiEnvioBean speiEnvio = new SpeiEnvioBean();
				String codigoExitoWS = "000000";

				ParametrosSpeiBean params = new ParametrosSpeiBean();
				params.setEmpresaID(String.valueOf(1));

				params = parametrosSpeiDAO.consultaPrincipal(params, 1);
				envioSpeiBean.setEmpresa(params.getEmpresaSTP());
				envioSpeiBean.setInstitucionOperanteId(params.getParticipanteSpei());

				// se obtiene la url del servicio web
				String urlWS = parametrosSpeiDAO.consultaParamsSpeiWS(1).getUrlWS();

				// Se obtiene el usuario y la contraseña ya codificados
				String autentificacionCodificada = parametrosSpeiDAO.consultaParamsSpeiWS(1).getUsuarioContraseniaWS();

				try{
					// se consume el servicio
					ConsumidorRest<SpeiEnvioBeanResponse> consumidorRest =  new ConsumidorRest<SpeiEnvioBeanResponse>();
					consumidorRest.addHeader("Autorizacion", autentificacionCodificada);

					loggerSAFI.info("Intentado realizar el consumo al WS de STP para el envio de una remesa");
					loggerSAFI.info("url:{" + urlWS + "}");
					Gson gson =  new Gson();
					String requestJSON = gson.toJson(envioSpeiBean);
					loggerSAFI.info("request : "+ requestJSON);
					SpeiEnvioBeanResponse speiEnvioBeanResponse =  consumidorRest.consumePost(urlWS,envioSpeiBean, SpeiEnvioBeanResponse.class);

					// si la respuesta del WS es exitoso
					if(codigoExitoWS.equals(speiEnvioBeanResponse.getCodigoRespuesta())){
						loggerSAFI.info(this.getClass()+" - "+"Respuesta del middlewareSTP : " + speiEnvioBeanResponse.getCodigoRespuesta() + " - " + speiEnvioBeanResponse.getMensajeRespuesta());

						pagoRem.setVisa(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						mensaje = reportaPago(pagoRem);

						// Si el metodo para reportar pago falla, se escribe en la bitacora
						if(mensaje.getNumero() > 0){	// TimeOut
							loggerSAFI.info(mensaje.getDescripcion());
							pagoRem.setMetodo("R");	// ReportarPago
							mensaje = altaBitacora(pagoRem);
						}
					}

					// si la respuesta del WS es un error
					if(!codigoExitoWS.equals(speiEnvioBeanResponse.getCodigoRespuesta())){
						loggerSAFI.info(this.getClass()+" - "+"Error al consultar el middlewareSTP : " + speiEnvioBeanResponse.getCodigoRespuesta() + " - " + speiEnvioBeanResponse.getMensajeRespuesta());

						mensaje = reportaDevolucion(pagoRem);

						// Si el metodo para reportar devolucion falla, se escribe en la bitacora
						if(mensaje.getNumero() > 0){	// TimeOut
							loggerSAFI.info(mensaje.getDescripcion());
							pagoRem.setMetodo("D");	// Devolucion
							mensaje = altaBitacora(pagoRem);
						}

						speiEnvio.setFolioSpeiID(pagoRem.getSpeiRemID());
						speiEnvio.setClabeRastreo(pagoRem.getClaveRastreo());
						//mensaje = cancelacionRemesa(pagoRem, 3); // Cancelacion de remesa
						mensaje = cancelaEnvioSpeiRem(speiEnvio);
						if(mensaje.getNumero()!=0){
							loggerSAFI.info(mensaje.getDescripcion());
						}
					}

					mensaje.setNumero(Constantes.CODIGO_SIN_ERROR);

				}catch(Exception e){
					if(mensaje == null){
						mensaje = new MensajeTransaccionBean();
					}
					loggerSAFI.info(mensaje.getDescripcion());
					mensaje.setNumero(404);
					mensaje.setDescripcion("No fue posible realizar el envio de la remesa SPEI por STP " + e.getMessage());
					loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de envio de remesa SPEI por STP [" + e.getMessage()+"]");
					e.printStackTrace();
					return mensaje;
				}

				 mensaje =  new MensajeTransaccionBean();
				 mensaje.setNumero(Constantes.CODIGO_SIN_ERROR);
				 mensaje.setDescripcion("Proceso de Envio Ejecutado Exitosamente");

				return mensaje;

			}

			public MensajeTransaccionBean consultaINFO(PagoRemesaSPEIBean pagoRemesaSPEIBean){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				RemesasWSBean remesasWSBean = new RemesasWSBean();
				List listaInfo = null;
				String STATUS_REM = "";

				//CONSULTA DE LA PARAMETRIZACION DE TIEMPOS
				DescargaRemesasBean descargaRemBean = new DescargaRemesasBean();
				ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
				int consultaURL		= 47;
				int consultsPort	= 48;
				int consultaTimeout = 49;

				String urlWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaURL).getValorParametro();
				String portWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultsPort).getValorParametro();
				String timedOut = paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaTimeout).getValorParametro();

				// DATOS REQUEST
				pagoRemesaSPEIBean.setVisa(Constantes.STRING_VACIO);
				remesasWSBean.setCadena(consultaCadenaInfo(pagoRemesaSPEIBean, 2).getDatos());
				remesasWSBean.setDatos("EX");
				remesasWSBean.setCorresponsales("SOFISPEI");
				remesasWSBean.setRuta_Ejecutar(Constantes.STRING_VACIO);

				try {
					String endPointWS = urlWS;

					loggerSAFI.info("Accediendo al endpoint WS: " + endPointWS);
					loggerSAFI.info("Request Info Remesas: \\( cadena: " + remesasWSBean.getCadena() + " Datos:" + remesasWSBean.getDatos() + " Corresponsales:" + remesasWSBean.getCorresponsales() + " ruta_ejecutar:" + remesasWSBean.getRuta_Ejecutar() + "\\)");

					tiempo = 0;
					start = Calendar.getInstance().getTimeInMillis();
					System.out.println("start: " +start);
					service1SoapProxy._ConfService1SoapProxy(endPointWS, portWS, timedOut);
					service1SoapProxy.setEndpoint();

					String Respuesta = service1SoapProxy.info(remesasWSBean.getCadena(), remesasWSBean.getDatos(), remesasWSBean.getCorresponsales(), remesasWSBean.getRuta_Ejecutar());
					loggerSAFI.info(" Resultado WS: " + Respuesta);
					loggerSAFI.info("Resultado WS: \\( cadena: " + remesasWSBean.getCadena() + " Datos:" + remesasWSBean.getDatos() + " Corresponsales:" + remesasWSBean.getCorresponsales() + " ruta_ejecutar:" + remesasWSBean.getRuta_Ejecutar() + "\\)");

					descargaRemBean.setCadenaRespuesta(Respuesta);
					listaInfo = listaInfoRemesas(descargaRemBean, 2);

					DescargaRemesasBean beanInfo = null;

					for(int i=0; i<listaInfo.size(); i++){

						// BEAN DEL REGISTRO
						beanInfo = new DescargaRemesasBean();
						beanInfo = (DescargaRemesasBean)listaInfo.get(i);
						STATUS_REM = beanInfo.getStatus();

					}

					end = Calendar.getInstance().getTimeInMillis();

				} catch (RemoteException e) {
					//mensajeBean.setNombreControl("Error");
					if (e.getCause() != null && (e.getCause().getLocalizedMessage().startsWith("Read timed out")) ||
						e.getCause().getLocalizedMessage().startsWith("Connection timed out") ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[2]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[3]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[4])) {
						excepcionTimedOut = true;
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");

						end = Calendar.getInstance().getTimeInMillis();
						loggerSAFI.info("Error en descarga de info de remesas. " + " Tiempo: " + ((end - start) / (1000)) + " Seg");

						return mensajeBean;
					}
					else {
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("El SAFI ha tenido un problema al concretar la operacion." + "Disculpe las molestias que esto le ocasiona. Ref: WS-stored");
					}
					mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");
					loggerSAFI.error(e.getMessage());
					return mensajeBean;
				}

				mensajeBean =  new MensajeTransaccionBean();
				mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
				mensajeBean.setDescripcion("Descarga de Info Ejecutada Exitosamente");
				mensajeBean.setCampoGenerico(STATUS_REM); // Este es el punto en el que devuelve el estatus de la orden
				return mensajeBean;
			}

			public MensajeTransaccionBean reportaPago(PagoRemesaSPEIBean pagoRemesaSPEIBean){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				RemesasWSBean remesasWSBean = new RemesasWSBean();

				//CONSULTA DE LA PARAMETRIZACION DE TIEMPOS
				ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
				int consultaURL		= 47;
				int consultsPort	= 48;
				int consultaTimeout = 49;

				String urlWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaURL).getValorParametro();
				String portWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultsPort).getValorParametro();
				String timedOut = paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaTimeout).getValorParametro();

				// DATOS REQUEST
				System.out.println(pagoRemesaSPEIBean.getClaveRastreo());
				pagoRemesaSPEIBean.setVisa(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
				remesasWSBean.setCadena(consultaCadenaInfo(pagoRemesaSPEIBean, 3).getDatos());
				remesasWSBean.setDatos("EX");
				remesasWSBean.setCorresponsales("SOFISPEI");
				remesasWSBean.setRuta_Ejecutar(Constantes.STRING_VACIO);

				try {
					String endPointWS = urlWS;

					loggerSAFI.info("Accediendo al endpoint WS: " + endPointWS);
					loggerSAFI.info("Request ReportarPago Remesas: \\( cadena: " + remesasWSBean.getCadena() + " Datos:" + remesasWSBean.getDatos() + " Corresponsales:" + remesasWSBean.getCorresponsales() + " ruta_ejecutar:" + remesasWSBean.getRuta_Ejecutar() + "\\)");

					tiempo = 0;
					start = Calendar.getInstance().getTimeInMillis();
					System.out.println("start: " +start);
					service1SoapProxy._ConfService1SoapProxy(endPointWS, portWS, timedOut);
					service1SoapProxy.setEndpoint();

					String Respuesta = service1SoapProxy.reportaPago(remesasWSBean.getCadena(), remesasWSBean.getDatos(), remesasWSBean.getCorresponsales(), remesasWSBean.getRuta_Ejecutar());
					loggerSAFI.info(" Resultado WS: " + Respuesta);

					// EN ESTE PUNTO SE DAN DE ALTA LOS REGISTROS DE REMESAS

					end = Calendar.getInstance().getTimeInMillis();

					pagoRemesaSPEIBean.setCadenaRespuesta(Respuesta);

					mensajeBean =  procesaCadenaPagoDevol(pagoRemesaSPEIBean, 3);

					if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						return mensajeBean;
					}

				} catch (RemoteException e) {
					mensajeBean.setNombreControl("Error");
					e.printStackTrace();
					if (e.getCause() != null && (e.getCause().getLocalizedMessage().startsWith("Read timed out")) ||
						e.getCause().getLocalizedMessage().startsWith("Connection timed out") ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[2]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[3]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[4])) {
						excepcionTimedOut = true;
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");

						end = Calendar.getInstance().getTimeInMillis();
						loggerSAFI.info("Error en descarga de info de remesa. " + " Tiempo: " + ((end - start) / (1000)) + " Seg");

						return mensajeBean;
					}
					else {
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("El SAFI ha tenido un problema al concretar la operacion." + "Disculpe las molestias que esto le ocasiona. Ref: WS-stored");
					}
					mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");
					loggerSAFI.error(e.getMessage());
					return mensajeBean;
				}

				mensajeBean =  new MensajeTransaccionBean();
				mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
				mensajeBean.setDescripcion("Proceso de Envio Ejecutado Exitosamente");

				return mensajeBean;
			}

			public MensajeTransaccionBean reportaDevolucion(PagoRemesaSPEIBean pagoRemesaSPEIBean){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				RemesasWSBean remesasWSBean = new RemesasWSBean();

				//CONSULTA DE LA PARAMETRIZACION DE TIEMPOS
				ParamGeneralesBean paramGenerales = new ParamGeneralesBean();
				int consultaURL		= 47;
				int consultsPort	= 48;
				int consultaTimeout = 49;

				String urlWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaURL).getValorParametro();
				String portWS	= paramGeneralesDAO.consultaPrincipal(paramGenerales, consultsPort).getValorParametro();
				String timedOut = paramGeneralesDAO.consultaPrincipal(paramGenerales, consultaTimeout).getValorParametro();

				// DATOS REQUEST
				pagoRemesaSPEIBean.setVisa(Constantes.STRING_VACIO);
				remesasWSBean.setCadena(consultaCadenaInfo(pagoRemesaSPEIBean, 4).getDatos());
				remesasWSBean.setDatos("EX");
				remesasWSBean.setCorresponsales("SOFISPEI");
				remesasWSBean.setRuta_Ejecutar(Constantes.STRING_VACIO);

				try {
					String endPointWS = urlWS;

					loggerSAFI.info("Accediendo al endpoint WS: " + endPointWS);
					loggerSAFI.info("Request Devolucion Remesas: \\( cadena: " + remesasWSBean.getCadena() + " Datos:" + remesasWSBean.getDatos() + " Corresponsales:" + remesasWSBean.getCorresponsales() + " ruta_ejecutar:" + remesasWSBean.getRuta_Ejecutar() + "\\)");

					tiempo = 0;
					start = Calendar.getInstance().getTimeInMillis();
					System.out.println("start: " +start);
					service1SoapProxy._ConfService1SoapProxy(endPointWS, portWS, timedOut);
					service1SoapProxy.setEndpoint();

					String restpDevolucion = service1SoapProxy.devolucion(remesasWSBean.getCadena(), remesasWSBean.getDatos(), remesasWSBean.getCorresponsales(), remesasWSBean.getRuta_Ejecutar());

					loggerSAFI.info("Resultado WS: " + restpDevolucion);

					// EN ESTE PUNTO SE DAN DE ALTA LOS REGISTROS DE REMESAS

					end = Calendar.getInstance().getTimeInMillis();

					pagoRemesaSPEIBean.setCadenaRespuesta(restpDevolucion);

					mensajeBean =  procesaCadenaPagoDevol(pagoRemesaSPEIBean, 4);

					if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						return mensajeBean;
					}

					// Aquí esperaría los OPCODE1 u OPCODE2

				} catch (RemoteException e) {
					mensajeBean.setNombreControl("Error");
					if (e.getCause() != null && (e.getCause().getLocalizedMessage().startsWith("Read timed out")) ||
						e.getCause().getLocalizedMessage().startsWith("Connection timed out") ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[2]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[3]) ||
						e.getCause().getLocalizedMessage().startsWith(Error_TimeOut[4])) {
						excepcionTimedOut = true;
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");

						end = Calendar.getInstance().getTimeInMillis();
						loggerSAFI.info("Error en devolucion de remesa. " + " Tiempo: " + ((end - start) / (1000)) + " Seg");

						return mensajeBean;
					}
					else {
						mensajeBean.setNumero(998);
						mensajeBean.setDescripcion("El SAFI ha tenido un problema al concretar la operacion." + "Disculpe las molestias que esto le ocasiona. Ref: WS-stored");
					}
					mensajeBean.setDescripcion("Por el momento no es posible realizar procesos de remesas.");
					loggerSAFI.error(e.getMessage());
					return mensajeBean;
				}

				mensajeBean.setNumero(0);
				mensajeBean =  new MensajeTransaccionBean();
				mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
				mensajeBean.setDescripcion("Proceso de Envio Ejecutado Exitosamente");

				return mensajeBean;
			}

			public MensajeTransaccionBean cancelacionRemesa(final PagoRemesaSPEIBean pagoRemesaSPEIBean, final int tipoTransaccion) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try{
							// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SPEIREMESASACT(?,?,?,?,?, ?,?,?,?,?,"
																		 + "?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_SpeiRemID", pagoRemesaSPEIBean.getSpeiRemID());
										sentenciaStore.setString("Par_ClaveRastreo", Constantes.STRING_VACIO);
										sentenciaStore.setLong("Par_FolioSpei", Constantes.ENTERO_CERO);
										sentenciaStore.setString("Par_UsuarioAutoriza", Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_NumAct", tipoTransaccion);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID", "PagoRemesaSPEIDAO.cancelacionRemesa");
										sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Remesa", e);
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
						}
				return mensajeBean;
			}

			public MensajeTransaccionBean altaBitacora(final PagoRemesaSPEIBean pagoRemesaSPEIBean) {

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
				// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARBITASPEIREMESASALT(?,?,?,?,?, ?,?,?,?,?,"
																 + "?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_SpeiRemID", pagoRemesaSPEIBean.getSpeiRemID());
								sentenciaStore.setString("Par_ClaveRastreo", pagoRemesaSPEIBean.getClaveRastreo());
								sentenciaStore.setString("Par_Metodo", pagoRemesaSPEIBean.getMetodo());
								sentenciaStore.setInt("Par_FolioSTP", Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "PagoRemesaSPEIDAO.cancelacionRemesa");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Remesa", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}

			public SpeiEnvioBeanRequest beanRequest (SpeiEnvioBean beanEntrada) {
				String canal = "V";
				SpeiEnvioBeanRequest speiEnviosBeanRequest = new SpeiEnvioBeanRequest();
				speiEnviosBeanRequest.setInstitucionBeneficiarioId(beanEntrada.getInstiReceptora());
				speiEnviosBeanRequest.setCuentaAho(beanEntrada.getCuentaAhoID());
				speiEnviosBeanRequest.setMonedaId(beanEntrada.getMonedaID());
				speiEnviosBeanRequest.setAreaEmiteId(beanEntrada.getAreaEmiteID());
				speiEnviosBeanRequest.setFechaoperacion(beanEntrada.getFecha());
				speiEnviosBeanRequest.setFolioOrigen(beanEntrada.getFolioSpeiID());
				speiEnviosBeanRequest.setClaveRastreo(beanEntrada.getClabeRastreo());
				speiEnviosBeanRequest.setMonto(beanEntrada.getMontoTransferir());

				speiEnviosBeanRequest.setTipoCuentaOrdenanteId(beanEntrada.getTipoCuentaOrd());
				speiEnviosBeanRequest.setNombreOrdenante(beanEntrada.getNombreOrd());
				speiEnviosBeanRequest.setCuentaOrdenante(beanEntrada.getCuentaOrd());
				speiEnviosBeanRequest.setRfcOrdenante(beanEntrada.getrFCOrd());
				speiEnviosBeanRequest.setTipoCuentaBeneficiarioId(beanEntrada.getTipoCuentaBen());
				speiEnviosBeanRequest.setNombreBeneficiario(beanEntrada.getNombreBeneficiario());
				speiEnviosBeanRequest.setCuentaBeneficiario(beanEntrada.getCuentaBeneficiario());
				speiEnviosBeanRequest.setRfcBeneficiario(beanEntrada.getrFCBeneficiario());
				speiEnviosBeanRequest.setConceptoPago(beanEntrada.getConceptoPago());
				speiEnviosBeanRequest.setReferenciaCobranza(beanEntrada.getReferenciaCobranza());
				speiEnviosBeanRequest.setReferenciaNumerica(beanEntrada.getReferenciaNum());
				speiEnviosBeanRequest.setCanalId(canal);	// Siempre se envia V para STP
				speiEnviosBeanRequest.setFirma(beanEntrada.getFirma());
				speiEnviosBeanRequest.setUsuariologueado(beanEntrada.getUsuario());
				speiEnviosBeanRequest.setIpUsuario(beanEntrada.getIpUsuario());
				speiEnviosBeanRequest.setSucursal(beanEntrada.getSucursal());

				return speiEnviosBeanRequest;
			}

			public MensajeTransaccionBean cancelaEnvioSpeiRem(final SpeiEnvioBean speiEnvioBean) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try{
							// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SPEIENVIOSCAN(?,?,?,?,?, ?,?,?,?,?,"
																		+ "?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_Folio",speiEnvioBean.getFolioSpeiID());
										sentenciaStore.setString("Par_ClaveRastreo",speiEnvioBean.getClabeRastreo());
										sentenciaStore.setString("Par_Comentario", Constantes.STRING_VACIO);

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la cancelacion de Envio Spei", e);
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

			// Consulta de SPEI
			public SpeiEnvioBean consultaEnvioSPEI(SpeiEnvioBean speiEnvioBean , int tipoConsulta) {
				String query = "CALL SPEIENVIOSCON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = {
						speiEnvioBean.getFolioSpeiID(),
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL SPEIENVIOSCON("+Arrays.toString(parametros) + ");");
				List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();

						speiEnvioBean.setInstiReceptora(resultSet.getString("InstiReceptoraID"));
						speiEnvioBean.setCuentaAhoID(resultSet.getString("CuentaAho"));
						speiEnvioBean.setMonedaID(resultSet.getString("MonedaID"));
						speiEnvioBean.setAreaEmiteID(resultSet.getString("AreaEmiteID"));
						speiEnvioBean.setFecha(resultSet.getString("FechaOperacion"));
						speiEnvioBean.setFolioSpeiID(resultSet.getString("FolioSpeiID"));
						speiEnvioBean.setClabeRastreo(resultSet.getString("ClaveRastreo"));
						speiEnvioBean.setMontoTransferir(resultSet.getString("MontoTransferir"));
						speiEnvioBean.setTipoCuentaOrd(resultSet.getString("TipoCuentaOrd"));
						speiEnvioBean.setNombreOrd(resultSet.getString("NombreOrd"));
						speiEnvioBean.setCuentaOrd(resultSet.getString("CuentaOrd"));
						speiEnvioBean.setrFCOrd(resultSet.getString("RFCOrd"));
						speiEnvioBean.setTipoCuentaBen(resultSet.getString("TipoCuentaBen"));
						speiEnvioBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
						speiEnvioBean.setCuentaBeneficiario(resultSet.getString("CuentaBeneficiario"));
						speiEnvioBean.setrFCBeneficiario(resultSet.getString("RFCBeneficiario"));
						speiEnvioBean.setConceptoPago(resultSet.getString("ConceptoPago"));
						speiEnvioBean.setReferenciaCobranza(resultSet.getString("ReferenciaCobranza"));
						speiEnvioBean.setReferenciaNum(resultSet.getString("ReferenciaNum"));
						speiEnvioBean.setOrigenOperacion(resultSet.getString("OrigenOperacion"));
						speiEnvioBean.setFirma(resultSet.getString("Firma"));
						speiEnvioBean.setUsuario(resultSet.getString("Usuario"));
						speiEnvioBean.setIpUsuario(resultSet.getString("DireccionIP"));
						speiEnvioBean.setSucursal(resultSet.getString("Sucursal"));

						return speiEnvioBean;
					}
				});

				return matches.size() > 0 ? (SpeiEnvioBean)matches.get(0) : null;
			}

			public List listaInfoRemesas(DescargaRemesasBean descargaRemesasBean, int tipoLista){
				String query = "call RESPREMSOFILIS(?,?,?,?,?, ?,?,?,?);";
				Object[] parametros = {
							descargaRemesasBean.getCadenaRespuesta(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							Constantes.STRING_VACIO,
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call RESPREMSOFILIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						DescargaRemesasBean descargaRemesasBean = new DescargaRemesasBean();
						descargaRemesasBean.setAuthoNumber(resultSet.getString("AuthoNumber"));
						descargaRemesasBean.setStatus(resultSet.getString("Status"));
						descargaRemesasBean.setOpCode1(resultSet.getString("OpCode1"));
						descargaRemesasBean.setOpCode2(resultSet.getString("OpCode2"));

						return descargaRemesasBean;
					}
				});
				return matches;
			}

			public MensajeTransaccionBean procesaCadenaPagoDevol(final PagoRemesaSPEIBean pagoRemBean, final int tipoTramsaccion) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call RESPREMSOFIPRO(?,?,?, ?,?,?,?,?,"
																   + "?,?,?,?,?,	?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SpeiSolDesID", Utileria.convierteLong(Constantes.STRING_CERO));
								sentenciaStore.setString("Par_AuthoNumber", Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_CadenaB64",pagoRemBean.getCadenaRespuesta());
								sentenciaStore.setInt("Par_TipoProceso",tipoTramsaccion);

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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento De Parsiado De Información.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta de remesas", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
				}
				return mensajeBean;
			}

			public MensajeTransaccionBean auxiliarProceso() {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try{
							// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "CALL AUXILIARPROCESO(?,?,?,?,?, ?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de Envio Spei", e);
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

			public MensajeTransaccionBean actualizarFirmaRemesaSPEI(final SpeiEnvioBean speiEnvioBean, final int tipoAct) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SPEIENVIOSSTPACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_Folio", Utileria.convierteLong(speiEnvioBean.getFolioSpeiID()));
									sentenciaStore.setString("Par_ClaveRastreo", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_EstatusEnv", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioSTP", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Firma", speiEnvioBean.getFirma());

									sentenciaStore.setString("Par_PIDTarea", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumIntentos", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_CausaDevol", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Comentario", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_UsuarioEnvio", Constantes.STRING_VACIO);

									sentenciaStore.setInt("Par_UsuarioAutoriza", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_UsuarioVerifica", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_NumAct", tipoAct);

									// Parametros de Salida
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									// Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SpeiEnvioDAO.actualizarFirmaEnvioSPEI");
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
						throw new Exception(Constantes.MSG_ERROR + " .SpeiEnvioDAO.actualizarFirmaEnvioSPEI");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de la Firma del SPEI " + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}

			public ParamGeneralesDAO getParamGeneralesDAO() {
				return paramGeneralesDAO;
			}

			public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
				this.paramGeneralesDAO = paramGeneralesDAO;
			}

			public Service1SoapProxy getService1SoapProxy() {
				return service1SoapProxy;
			}

			public void setService1SoapProxy(Service1SoapProxy service1SoapProxy) {
				this.service1SoapProxy = service1SoapProxy;
			}

			public ParametrosSpeiDAO getParametrosSpeiDAO() {
				return parametrosSpeiDAO;
			}

			public void setParametrosSpeiDAO(ParametrosSpeiDAO parametrosSpeiDAO) {
				this.parametrosSpeiDAO = parametrosSpeiDAO;
			}

			public long getStart() {
				return start;
			}

			public void setStart(long start) {
				this.start = start;
			}

			public double getTiempo() {
				return tiempo;
			}

			public void setTiempo(double tiempo) {
				this.tiempo = tiempo;
			}

			public double getEnd() {
				return end;
			}

			public void setEnd(double end) {
				this.end = end;
			}

			public boolean isExcepcionTimedOut() {
				return excepcionTimedOut;
			}

			public void setExcepcionTimedOut(boolean excepcionTimedOut) {
				this.excepcionTimedOut = excepcionTimedOut;
			}

			public String getRcode() {
				return rcode;
			}

			public void setRcode(String rcode) {
				this.rcode = rcode;
			}

			public String getSaltoLinea() {
				return saltoLinea;
			}

			public boolean isOrigenVent() {
				return origenVent;
			}

			public static String[] getErrorTimeout() {
				return Error_TimeOut;
			}
	}
