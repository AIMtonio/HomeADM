package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import fira.bean.MinistracionCredAgroBean;
import fira.dao.MinistraCredAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.ComentariosMonitorBean;
import originacion.bean.ConsolidacionesBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolAgro;
import cliente.bean.CicloCreditoBean;
import credito.bean.SeguroVidaBean;
import credito.bean.ServiciosSolCredBean;
import credito.beanWS.response.SimuladorCuotaCreditoResponse;
import credito.dao.SeguroVidaDAO;
import credito.dao.ServiciosSolCredDAO;

public class SolicitudCreditoDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;
	SeguroVidaDAO seguroVidaDAO = null;
	MinistraCredAgroDAO ministraCredAgroDAO = null;
	ConsolidacionesDAO consolidacionesDAO = null;
	ServiciosSolCredDAO serviciosSolCredDAO = null;

	public SolicitudCreditoDAO() {
		super();
	}

	// Proceso de Alta de Solicitud de Credito
	public MensajeTransaccionBean procesoAltaSolicitudCredito(final SolicitudCreditoBean solicitudCredito){
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = null;
				try {

					MensajeTransaccionBean mensajeSol = null;
					MensajeTransaccionBean mensajeActualiza = null;
					ComentariosMonitorBean comentarios = new ComentariosMonitorBean();
					String estatusRegistro = "SI";
					int actualizaReacredita = 13;
					String solicitudCreditoID = "";

					if(solicitudCredito.getReqSeguroVida()!=null && solicitudCredito.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){
						mensaje = altaSolicitudConSeguroVida(solicitudCredito);
						if( mensaje.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensaje.getDescripcion());
						}

						solicitudCreditoID = mensaje.getConsecutivoString();
						comentarios.setSolicitudCreditoID(mensaje.getConsecutivoString());
						comentarios.setEstatus(estatusRegistro);
						comentarios.setComentario(solicitudCredito.getComentario());
						comentarios.setFecha(solicitudCredito.getFechaAutoriza());
						mensajeSol = altaComentario(comentarios);
						if( mensajeSol.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensajeSol.getDescripcion());
						}

						solicitudCredito.setSolicitudCreditoID(mensaje.getConsecutivoString());

						if(solicitudCredito.getEsReacreditado()!=null && solicitudCredito.getEsReacreditado().equalsIgnoreCase("S")){
							mensajeActualiza = actualizaSolicitud(solicitudCredito, actualizaReacredita);
							if( mensajeActualiza.getNumero() != Constantes.ENTERO_CERO){
								throw new Exception(mensajeActualiza.getDescripcion());
							}
						}

					}else{


						mensaje = altaSolicitudCredito(solicitudCredito);
						if( mensaje.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensaje.getDescripcion());
						}

						solicitudCreditoID = mensaje.getConsecutivoString();
						comentarios.setSolicitudCreditoID(mensaje.getConsecutivoString());
						comentarios.setEstatus(estatusRegistro);
						comentarios.setFecha(solicitudCredito.getFechaRegistro());
						comentarios.setComentario(solicitudCredito.getComentario());
						comentarios.setUsuarioAutoriza(solicitudCredito.getUsuarioAutoriza());
						mensajeSol = altaComentario(comentarios);
						if( mensajeSol.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensajeSol.getDescripcion());
						}

						solicitudCredito.setSolicitudCreditoID(mensaje.getConsecutivoString());
						if(solicitudCredito.getEsReacreditado()!=null && solicitudCredito.getEsReacreditado().equalsIgnoreCase("S")){
							mensajeActualiza = actualizaSolicitud(solicitudCredito, actualizaReacredita);
							if( mensajeActualiza.getNumero() != Constantes.ENTERO_CERO){
								throw new Exception(mensajeActualiza.getDescripcion());
							}
						}

					}

					if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
						if (solicitudCredito.getServiciosAdicionales() != null && !solicitudCredito.getServiciosAdicionales().isEmpty()) {
							List listaAltaServiciosAdicionales = obtenerListaServiciosAdicionales(solicitudCredito);
							serviciosSolCredDAO.altaListaServiciosAdicionales(solicitudCredito, listaAltaServiciosAdicionales);
						}
					}

					if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
						if(solicitudCredito.getTipoCredito().equalsIgnoreCase("R") && solicitudCredito.getEsAgropecuario()!= null && solicitudCredito.getEsAgropecuario().equalsIgnoreCase("S")){

							mensaje = actualizaDatosFIRA(solicitudCredito, Enum_Act_SolAgro.principal);
							if( mensaje.getNumero() != Constantes.ENTERO_CERO){
								throw new Exception(mensaje.getDescripcion());
							}
						}
					}

					mensaje.setDescripcion("Solicitud de Credito Agregada Exitosamente: "+solicitudCreditoID);

				} catch (Exception exception) {

					if( mensaje == null){
						mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(999);
					}else {
						if( mensaje.getNumero() == Constantes.ENTERO_CERO ){
							mensaje.setNumero(999);
						}
					}
					mensaje.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de la Solicitud de Crédito ", exception);
				}
				return mensaje;
			}
		});
		return mensajeTransaccion;
	}

	// Proceso de Modificacion de Solicitud de Credito
	public MensajeTransaccionBean procesoModificacionSolicitudCredito(final SolicitudCreditoBean solicitudCredito){
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensaje = null;
				try {

					if(solicitudCredito.getReqSeguroVida()!=null && solicitudCredito.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){
						mensaje = modificacionSolicitudConSeguroVida(solicitudCredito);
					}else{
						mensaje = modificacionSolicitudCredito(solicitudCredito);
					}

					if( mensaje.getNumero() != Constantes.ENTERO_CERO){
						throw new Exception(mensaje.getDescripcion());
					}

					if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
						if (solicitudCredito.getServiciosAdicionales() != null && !solicitudCredito.getServiciosAdicionales().isEmpty()) {
							List listaAltaServiciosAdicionales = obtenerListaServiciosAdicionales(solicitudCredito);
							serviciosSolCredDAO.altaListaServiciosAdicionales(solicitudCredito, listaAltaServiciosAdicionales);
						}
					}

					if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000){
						if(solicitudCredito.getTipoCredito().equalsIgnoreCase("R") && solicitudCredito.getEsAgropecuario().equalsIgnoreCase("S")){
							mensaje = actualizaDatosFIRA(solicitudCredito, Enum_Act_SolAgro.principal);
							if( mensaje.getNumero() != Constantes.ENTERO_CERO){
								throw new Exception(mensaje.getDescripcion());
							}
						}
					}

					mensaje.setDescripcion("Solicitud de Credito Modificada Exitosamente: "+solicitudCredito.getSolicitudCreditoID());

				} catch (Exception exception) {

					if( mensaje == null){
						mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(999);
					}else{
						if( mensaje.getNumero() == Constantes.ENTERO_CERO ){
							mensaje.setNumero(999);
						}
					}

					mensaje.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Modificación de la Solicitud de Crédito ", exception);
				}
				return mensaje;
			}
		});
		return mensajeTransaccion;
	}

	public MensajeTransaccionBean altaSolicitudCredito(final SolicitudCreditoBean solicitudCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDCREDITOALT(" +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ProspectoID",Utileria.convierteLong(solicitudCredito.getProspectoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCredito.getClienteID()));
									sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
									sentenciaStore.setInt("Par_Promotor",Utileria.convierteEntero(solicitudCredito.getPromotorID()));

									sentenciaStore.setString("Par_TipoCredito",solicitudCredito.getTipoCredito());
									sentenciaStore.setInt("Par_NumCreditos",Utileria.convierteEntero(solicitudCredito.getNumCreditos()));
									sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(solicitudCredito.getRelacionado()));
									sentenciaStore.setDouble("Par_AporCliente",Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
									sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(solicitudCredito.getMonedaID()));

									sentenciaStore.setInt("Par_DestinoCre",Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
									sentenciaStore.setString("Par_Proyecto",solicitudCredito.getProyecto());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(solicitudCredito.getSucursalID()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
									sentenciaStore.setString("Par_PlazoID",solicitudCredito.getPlazoID());

									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCredito.getFactorMora()));
									sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
									sentenciaStore.setDouble("Par_IVAComAper",Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
									sentenciaStore.setString("Par_TipoDisper",solicitudCredito.getTipoDispersion());
									sentenciaStore.setInt("Par_CalcInteres",Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));

									sentenciaStore.setDouble("Par_TasaBase",Utileria.convierteDoble(solicitudCredito.getTasaBase()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(solicitudCredito.getTasaFija()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(solicitudCredito.getTechoTasa()));

									sentenciaStore.setString("Par_FechInhabil",solicitudCredito.getFechInhabil());
									sentenciaStore.setString("Par_AjuFecExiVe",solicitudCredito.getAjusFecExiVen());
									sentenciaStore.setString("Par_CalIrreg",solicitudCredito.getCalendIrregular());
									sentenciaStore.setString("Par_AjFUlVenAm",solicitudCredito.getAjFecUlAmoVen());
									sentenciaStore.setString("Par_TipoPagCap",solicitudCredito.getTipoPagoCapital());

									sentenciaStore.setString("Par_FrecInter",solicitudCredito.getFrecuenciaInt());
									sentenciaStore.setString("Par_FrecCapital",solicitudCredito.getFrecuenciaCap());
									sentenciaStore.setInt("Par_PeriodInt",Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
									sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
									sentenciaStore.setString("Par_DiaPagInt",solicitudCredito.getDiaPagoInteres());

									sentenciaStore.setString("Par_DiaPagCap",solicitudCredito.getDiaPagoCapital());
									sentenciaStore.setInt("Par_DiaMesInter",Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));
									sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
									sentenciaStore.setInt("Par_NumAmorti",Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
									sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));

									sentenciaStore.setDouble("Par_CAT",Utileria.convierteDoble(solicitudCredito.getCAT()));
									sentenciaStore.setString("Par_CuentaClabe",solicitudCredito.getCuentaCLABE());
									sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));
									sentenciaStore.setString("Par_TipoFondeo",solicitudCredito.getTipoFondeo());
									sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));

									sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
									sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
									sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
									sentenciaStore.setDouble("Par_GrupoID",Utileria.convierteEntero(solicitudCredito.getGrupoID()));
									sentenciaStore.setDouble("Par_TipoIntegr",Utileria.convierteEntero(solicitudCredito.getTipoIntegrante()));

									sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
									sentenciaStore.setDouble("Par_MontoSeguroVida",Utileria.convierteDoble(solicitudCredito.getMontoSeguroVida()));
									sentenciaStore.setString("Par_ForCobroSegVida",solicitudCredito.getForCobroSegVida());
									sentenciaStore.setString("Par_ClasiDestinCred",solicitudCredito.getClasifiDestinCred());

									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));
									sentenciaStore.setString("Par_FolioCtrl",solicitudCredito.getFolioCtrl());
									sentenciaStore.setString("Par_HorarioVeri",solicitudCredito.getHorarioVeri());
									sentenciaStore.setDouble("Par_PorcGarLiq",Utileria.convierteDoble(solicitudCredito.getPorcGarLiq()));
									sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(solicitudCredito.getFechaInicioAmor()));
									sentenciaStore.setDouble("Par_DescuentoSeguro",Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));
									sentenciaStore.setDouble("Par_MontoSegOriginal",Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));
									sentenciaStore.setString("Par_TipoLiquidacion",solicitudCredito.getTipoLiquidacion());
									sentenciaStore.setDouble("Par_CantidadPagar",Utileria.convierteDoble(solicitudCredito.getCantidadPagar()));

									// consultaSIC
									sentenciaStore.setString("Par_TipoConsultaSIC",solicitudCredito.getTipoConsultaSIC());
									sentenciaStore.setString("Par_FolioConsultaBC",solicitudCredito.getFolioConsultaBC());
									sentenciaStore.setString("Par_FolioConsultaCC",solicitudCredito.getFolioConsultaCC());

									// Cobro de comision por apertura
									sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(solicitudCredito.getFechaCobroComision()));

									/* CREDITOS AUTOMATICOS */
									sentenciaStore.setInt("Par_InvCredAut",Utileria.convierteEntero(solicitudCredito.getInversionID()));
									sentenciaStore.setLong("Par_CtaCredAut",Utileria.convierteLong(solicitudCredito.getCuentaAhoID()));

									// Seguro de Vida (CONSOL)
									sentenciaStore.setString("Par_Cobertura",solicitudCredito.getCobertura());
									sentenciaStore.setString("Par_Prima",solicitudCredito.getPrima());
									sentenciaStore.setInt("Par_Vigencia",Utileria.convierteEntero(solicitudCredito.getVigencia()));

									//Convenio
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCredito.getConvenioNominaID()));
									sentenciaStore.setString("Par_FolioSolici",solicitudCredito.getFolioSolici());
									sentenciaStore.setInt("Par_QuinquenioID",Utileria.convierteEntero(solicitudCredito.getQuinquenioID()));
									//Domiciliacion
									sentenciaStore.setString("Par_ClabeDomiciliacion",solicitudCredito.getClabeDomiciliacion());
									sentenciaStore.setString("Par_TipoCtaSantander",solicitudCredito.getTipoCtaSantander());
									sentenciaStore.setString("Par_CtaSantander", solicitudCredito.getCtaSantander());
									sentenciaStore.setString("Par_CtaClabeDisp", solicitudCredito.getCtaClabeDisp());

									sentenciaStore.setInt("Par_DeudorOriginalID", Utileria.convierteEntero(solicitudCredito.getDeudorOriginalID()));
									sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(solicitudCredito.getLineaCreditoID()));
									sentenciaStore.setString("Par_ManejaComAdmon", solicitudCredito.getManejaComAdmon());
									sentenciaStore.setString("Par_ComAdmonLinPrevLiq", solicitudCredito.getComAdmonLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComAdmon", solicitudCredito.getForPagComAdmon());

									sentenciaStore.setDouble("Par_MontoPagComAdmon", Utileria.convierteDoble(solicitudCredito.getMontoPagComAdmon()));
									sentenciaStore.setString("Par_ManejaComGarantia", solicitudCredito.getManejaComGarantia());
									sentenciaStore.setString("Par_ComGarLinPrevLiq", solicitudCredito.getComGarLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComGarantia", solicitudCredito.getForPagComGarantia());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	//Alta de la Solicitud con Seguro de Vida Asociado al Credito
	public MensajeTransaccionBean altaSolicitudConSeguroVida(final SolicitudCreditoBean solicitudCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Llama al Metodo del Alta de Solicitud de Credito
					mensajeBean = altaSolicitudCredito(solicitudCredito);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SolicitudCreditoDAO.altaSolicitudConSeguroVida");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Llama al Metodo del Alta de Seguro de Vida
					SeguroVidaBean seguroVidaBean = new SeguroVidaBean();

					seguroVidaBean.setClienteID(solicitudCredito.getClienteID());
					seguroVidaBean.setBeneficiario(solicitudCredito.getBeneficiario());
					seguroVidaBean.setDireccionBeneficiario(solicitudCredito.getDireccionBen());
					seguroVidaBean.setRelacionBeneficiario(solicitudCredito.getParentescoID());
					seguroVidaBean.setForCobroSegVida(solicitudCredito.getForCobroSegVida());
					seguroVidaBean.setFechaVencimiento(solicitudCredito.getFechaVencimiento());
					seguroVidaBean.setFechaInicio(solicitudCredito.getFechaInicio());
					seguroVidaBean.setMontoPoliza(solicitudCredito.getMontoPolSegVida());
					seguroVidaBean.setSolicitudCreditoID(mensajeBean.getConsecutivoString());

					String consecutivo = mensajeBean.getConsecutivoString();
					String consecutivoInt = mensajeBean.getConsecutivoInt();

					mensajeBean = seguroVidaDAO.altaSeguroVida(seguroVidaBean);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SolicitudCreditoDAO.altaSolicitudConSeguroVida");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion("Solicitud de Credito Agregada Exitosamente. No: "  + consecutivo);
					mensajeBean.setConsecutivoString(consecutivo);
					mensajeBean.setConsecutivoInt(consecutivoInt);

					return mensajeBean;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Solicitud de Credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificacionSolicitudCredito(final SolicitudCreditoBean solicitudCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDCREDITOMOD(" +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,     " +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?,?,		" +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_Solicitud",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_ProspectoID",Utileria.convierteLong(solicitudCredito.getProspectoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCredito.getClienteID()));
									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
									sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
									sentenciaStore.setInt("Par_Promotor",Utileria.convierteEntero(solicitudCredito.getPromotorID()));
									sentenciaStore.setString("Par_TipoCredito",solicitudCredito.getTipoCredito());
									sentenciaStore.setInt("Par_NumCreditos",Utileria.convierteEntero(solicitudCredito.getNumCreditos()));
									sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(solicitudCredito.getRelacionado()));
									sentenciaStore.setDouble("Par_AporCliente",Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
									sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(solicitudCredito.getMonedaID()));

									sentenciaStore.setInt("Par_DestinoCre",Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
									sentenciaStore.setString("Par_Proyecto",solicitudCredito.getProyecto());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(solicitudCredito.getSucursalID()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
									sentenciaStore.setString("Par_PlazoID",solicitudCredito.getPlazoID());
									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCredito.getFactorMora()));
									sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
									sentenciaStore.setDouble("Par_IVAComAper",Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
									sentenciaStore.setString("Par_TipoDisper",solicitudCredito.getTipoDispersion());
									sentenciaStore.setInt("Par_CalcInteres",Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));

									sentenciaStore.setDouble("Par_TasaBase",Utileria.convierteDoble(solicitudCredito.getTasaBase()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(solicitudCredito.getTasaFija()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(solicitudCredito.getTechoTasa()));
									sentenciaStore.setString("Par_FechInhabil",solicitudCredito.getFechInhabil());
									sentenciaStore.setString("Par_AjuFecExiVe",solicitudCredito.getAjusFecExiVen());
									sentenciaStore.setString("Par_CalIrreg",solicitudCredito.getCalendIrregular());
									sentenciaStore.setString("Par_AjFUlVenAm",solicitudCredito.getAjFecUlAmoVen());
									sentenciaStore.setString("Par_TipoPagCap",solicitudCredito.getTipoPagoCapital());

									sentenciaStore.setString("Par_FrecInter",solicitudCredito.getFrecuenciaInt());
									sentenciaStore.setString("Par_FrecCapital",solicitudCredito.getFrecuenciaCap());
									sentenciaStore.setInt("Par_PeriodInt",Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
									sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
									sentenciaStore.setString("Par_DiaPagInt",solicitudCredito.getDiaPagoInteres());
									sentenciaStore.setString("Par_DiaPagCap",solicitudCredito.getDiaPagoCapital());
									sentenciaStore.setInt("Par_DiaMesInter",Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));
									sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
									sentenciaStore.setInt("Par_NumAmorti",Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
									sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));

									sentenciaStore.setDouble("Par_CAT",Utileria.convierteDoble(solicitudCredito.getCAT()));
									sentenciaStore.setString("Par_CuentaClabe",solicitudCredito.getCuentaCLABE());
									sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));
									sentenciaStore.setString("Par_TipoFondeo",solicitudCredito.getTipoFondeo());
									sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));
									sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
									sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
									sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
									sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(solicitudCredito.getGrupoID()));

									sentenciaStore.setDouble("Par_TipoIntegr",Utileria.convierteEntero(solicitudCredito.getTipoIntegrante()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
									sentenciaStore.setDouble("Par_MontoSeguroVida",Utileria.convierteDoble(solicitudCredito.getMontoSeguroVida()));
									sentenciaStore.setString("Par_ForCobroSegVida",solicitudCredito.getForCobroSegVida());
									sentenciaStore.setString("Par_ClasiDestinCred",solicitudCredito.getClasifiDestinCred());
									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));

									sentenciaStore.setString("Par_FolioCtrl",solicitudCredito.getFolioCtrl());
									sentenciaStore.setString("Par_HorarioVeri",solicitudCredito.getHorarioVeri());
									sentenciaStore.setDouble("Par_PorcGarLiq",Utileria.convierteDoble(solicitudCredito.getPorcGarLiq()));
									sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(solicitudCredito.getFechaInicioAmor()));
									sentenciaStore.setDouble("Par_DescuentoSeguro",Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));

									sentenciaStore.setDouble("Par_MontoSegOriginal",Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));
									sentenciaStore.setString("Par_Comentario",solicitudCredito.getComentario());

									sentenciaStore.setString("Par_TipoConsultaSIC",solicitudCredito.getTipoConsultaSIC());
									sentenciaStore.setString("Par_FolioConsultaBC",solicitudCredito.getFolioConsultaBC());
									sentenciaStore.setString("Par_FolioConsultaCC",solicitudCredito.getFolioConsultaCC());
									// Cobro de comision por apertura
									sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(solicitudCredito.getFechaCobroComision()));

									/* CREDITOS AUTOMATICOS */
									sentenciaStore.setInt("Par_InvCredAut",Utileria.convierteEntero(solicitudCredito.getInversionID()));
									sentenciaStore.setLong("Par_CtaCredAut",Utileria.convierteLong(solicitudCredito.getCuentaAhoID()));

									// Seguro de Vida CONSOL
									sentenciaStore.setString("Par_Cobertura",solicitudCredito.getCobertura());
									sentenciaStore.setString("Par_Prima",solicitudCredito.getPrima());
									sentenciaStore.setInt("Par_Vigencia",Utileria.convierteEntero(solicitudCredito.getVigencia()));

									//Convenio
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCredito.getConvenioNominaID()));
									sentenciaStore.setString("Par_FolioSolici",solicitudCredito.getFolioSolici());
									sentenciaStore.setInt("Par_QuinquenioID",Utileria.convierteEntero(solicitudCredito.getQuinquenioID()));
									//Domiciliacion
									sentenciaStore.setString("Par_ClabeDomiciliacion",solicitudCredito.getClabeDomiciliacion());

									sentenciaStore.setString("Par_TipoCtaSantander",solicitudCredito.getTipoCtaSantander());
									sentenciaStore.setString("Par_CtaSantander", solicitudCredito.getCtaSantander());
									sentenciaStore.setString("Par_CtaClabeDisp", solicitudCredito.getCtaClabeDisp());

									sentenciaStore.setInt("Par_DeudorOriginalID", Utileria.convierteEntero(solicitudCredito.getDeudorOriginalID()));
									sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(solicitudCredito.getLineaCreditoID()));
									sentenciaStore.setString("Par_ManejaComAdmon", solicitudCredito.getManejaComAdmon());
									sentenciaStore.setString("Par_ComAdmonLinPrevLiq", solicitudCredito.getComAdmonLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComAdmon", solicitudCredito.getForPagComAdmon());

									sentenciaStore.setDouble("Par_MontoPagComAdmon", Utileria.convierteDoble(solicitudCredito.getMontoPagComAdmon()));
									sentenciaStore.setString("Par_ManejaComGarantia", solicitudCredito.getManejaComGarantia());
									sentenciaStore.setString("Par_ComGarLinPrevLiq", solicitudCredito.getComGarLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComGarantia", solicitudCredito.getForPagComGarantia());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}

	/**
	 * Modificación pero con seguro de vida
	 * @param solicitudCredito
	 * @param numTransaccion
	 * @return
	 */
	public MensajeTransaccionBean modificacionSolicitudCredito(final SolicitudCreditoBean solicitudCredito, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDCREDITOMOD(" +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
											"?,?,?,?,?,	   " +
											"?,?,?,?,?,	   " +
											"?,?,?,?,?,	   " +
											"?,?,?,?,?,	   " +
											"?,?,?,?,?,	   " +
											"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_Solicitud",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
									sentenciaStore.setLong("Par_ProspectoID",Utileria.convierteLong(solicitudCredito.getProspectoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCredito.getClienteID()));
									sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
									sentenciaStore.setInt("Par_Promotor",Utileria.convierteEntero(solicitudCredito.getPromotorID()));

									sentenciaStore.setString("Par_TipoCredito",solicitudCredito.getTipoCredito());
									sentenciaStore.setInt("Par_NumCreditos",Utileria.convierteEntero(solicitudCredito.getNumCreditos()));
									sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(solicitudCredito.getRelacionado()));
									sentenciaStore.setDouble("Par_AporCliente",Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
									sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(solicitudCredito.getMonedaID()));

									sentenciaStore.setInt("Par_DestinoCre",Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
									sentenciaStore.setString("Par_Proyecto",solicitudCredito.getProyecto());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(solicitudCredito.getSucursalID()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
									sentenciaStore.setString("Par_PlazoID",solicitudCredito.getPlazoID());

									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCredito.getFactorMora()));
									sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
									sentenciaStore.setDouble("Par_IVAComAper",Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
									sentenciaStore.setString("Par_TipoDisper",solicitudCredito.getTipoDispersion());
									sentenciaStore.setInt("Par_CalcInteres",Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));

									sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(solicitudCredito.getTasaBase()));
									sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(solicitudCredito.getTasaFija()));
									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
									sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
									sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(solicitudCredito.getTechoTasa()));

									sentenciaStore.setString("Par_FechInhabil",solicitudCredito.getFechInhabil());
									sentenciaStore.setString("Par_AjuFecExiVe",solicitudCredito.getAjusFecExiVen());
									sentenciaStore.setString("Par_CalIrreg",solicitudCredito.getCalendIrregular());
									sentenciaStore.setString("Par_AjFUlVenAm",solicitudCredito.getAjFecUlAmoVen());
									sentenciaStore.setString("Par_TipoPagCap",solicitudCredito.getTipoPagoCapital());

									sentenciaStore.setString("Par_FrecInter",solicitudCredito.getFrecuenciaInt());
									sentenciaStore.setString("Par_FrecCapital",solicitudCredito.getFrecuenciaCap());
									sentenciaStore.setInt("Par_PeriodInt",Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
									sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
									sentenciaStore.setString("Par_DiaPagInt",solicitudCredito.getDiaPagoInteres());

									sentenciaStore.setString("Par_DiaPagCap",solicitudCredito.getDiaPagoCapital());
									sentenciaStore.setInt("Par_DiaMesInter",Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));
									sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
									sentenciaStore.setInt("Par_NumAmorti",Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
									sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));

									sentenciaStore.setDouble("Par_CAT",Utileria.convierteDoble(solicitudCredito.getCAT()));
									sentenciaStore.setString("Par_CuentaClabe",solicitudCredito.getCuentaCLABE());
									sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));
									sentenciaStore.setString("Par_TipoFondeo",solicitudCredito.getTipoFondeo());
									sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));

									sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
									sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
									sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
									sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(solicitudCredito.getGrupoID()));

									sentenciaStore.setDouble("Par_TipoIntegr",Utileria.convierteEntero(solicitudCredito.getTipoIntegrante()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
									sentenciaStore.setDouble("Par_MontoSeguroVida",Utileria.convierteDoble(solicitudCredito.getMontoSeguroVida()));
									sentenciaStore.setString("Par_ForCobroSegVida",solicitudCredito.getForCobroSegVida());
									sentenciaStore.setString("Par_ClasiDestinCred",solicitudCredito.getClasifiDestinCred());

									sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));
									sentenciaStore.setString("Par_FolioCtrl",solicitudCredito.getFolioCtrl());
									sentenciaStore.setString("Par_HorarioVeri",solicitudCredito.getHorarioVeri());
									sentenciaStore.setDouble("Par_PorcGarLiq",Utileria.convierteDoble(solicitudCredito.getPorcGarLiq()));
									sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(solicitudCredito.getFechaInicioAmor()));
									sentenciaStore.setDouble("Par_DescuentoSeguro",Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));
									sentenciaStore.setDouble("Par_MontoSegOriginal",Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));
									sentenciaStore.setString("Par_Comentario",solicitudCredito.getComentario());

									sentenciaStore.setString("Par_TipoConsultaSIC",solicitudCredito.getTipoConsultaSIC());
									sentenciaStore.setString("Par_FolioConsultaBC",solicitudCredito.getFolioConsultaBC());
									sentenciaStore.setString("Par_FolioConsultaCC",solicitudCredito.getFolioConsultaCC());

									// Cobro de comision por apertura
									sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(solicitudCredito.getFechaCobroComision()));

									/* CREDITOS AUTOMATICOS */
									sentenciaStore.setInt("Par_InvCredAut",Utileria.convierteEntero(solicitudCredito.getInversionID()));
									sentenciaStore.setLong("Par_CtaCredAut",Utileria.convierteLong(solicitudCredito.getCuentaAhoID()));

									// Seguro de Vida CONSOL
									sentenciaStore.setString("Par_Cobertura",solicitudCredito.getCobertura());
									sentenciaStore.setString("Par_Prima",solicitudCredito.getPrima());
									sentenciaStore.setInt("Par_Vigencia",Utileria.convierteEntero(solicitudCredito.getVigencia()));

									//Convenio
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCredito.getConvenioNominaID()));
									sentenciaStore.setString("Par_FolioSolici",solicitudCredito.getFolioSolici());
									sentenciaStore.setInt("Par_QuinquenioID",Utileria.convierteEntero(solicitudCredito.getQuinquenioID()));
									//Domiciliacion
									sentenciaStore.setString("Par_ClabeDomiciliacion",solicitudCredito.getClabeDomiciliacion());

									sentenciaStore.setString("Par_TipoCtaSantander",solicitudCredito.getTipoCtaSantander());
									sentenciaStore.setString("Par_CtaSantander", solicitudCredito.getCtaSantander());
									sentenciaStore.setString("Par_CtaClabeDisp", solicitudCredito.getCtaClabeDisp());

									sentenciaStore.setInt("Par_DeudorOriginalID", Utileria.convierteEntero(solicitudCredito.getDeudorOriginalID()));
									sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(solicitudCredito.getLineaCreditoID()));
									sentenciaStore.setString("Par_ManejaComAdmon", solicitudCredito.getManejaComAdmon());
									sentenciaStore.setString("Par_ComAdmonLinPrevLiq", solicitudCredito.getComAdmonLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComAdmon", solicitudCredito.getForPagComAdmon());

									sentenciaStore.setDouble("Par_MontoPagComAdmon", Utileria.convierteDoble(solicitudCredito.getMontoPagComAdmon()));
									sentenciaStore.setString("Par_ManejaComGarantia", solicitudCredito.getManejaComGarantia());
									sentenciaStore.setString("Par_ComGarLinPrevLiq", solicitudCredito.getComGarLinPrevLiq());
									sentenciaStore.setString("Par_ForPagComGarantia", solicitudCredito.getForPagComGarantia());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}
	//Modificacion de la Solicitud con Seguro de Vida Asociado al Credito
	public MensajeTransaccionBean modificacionSolicitudConSeguroVida(final SolicitudCreditoBean solicitudCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Llama al Metodo del Alta de Solicitud de Credito
					mensajeBean = modificacionSolicitudCredito(solicitudCredito,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SolicitudCreditoDAO.altaSolicitudConSeguroVida");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					// Llama al Metodo del Alta de Seguro de Vida
					SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
					seguroVidaBean.setSeguroVidaID(solicitudCredito.getSeguroVidaID());
					seguroVidaBean.setClienteID(solicitudCredito.getClienteID());
					seguroVidaBean.setBeneficiario(solicitudCredito.getBeneficiario());
					seguroVidaBean.setDireccionBeneficiario(solicitudCredito.getDireccionBen());
					seguroVidaBean.setRelacionBeneficiario(solicitudCredito.getParentescoID());
					seguroVidaBean.setForCobroSegVida(solicitudCredito.getForCobroSegVida());
					seguroVidaBean.setFechaVencimiento(solicitudCredito.getFechaVencimiento());
					seguroVidaBean.setFechaInicio(solicitudCredito.getFechaInicio());
					seguroVidaBean.setMontoPoliza(solicitudCredito.getMontoPolSegVida());
					seguroVidaBean.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
					String consecutivo = mensajeBean.getConsecutivoString();
					String consecutivoInt = mensajeBean.getConsecutivoInt();

					mensajeBean = seguroVidaDAO.modificaSeguroVida(seguroVidaBean,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SolicitudCreditoDAO.altaSolicitudConSeguroVida");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion("Solicitud de Credito Modificada Exitosamente. No: "  + consecutivo);
					mensajeBean.setConsecutivoString(consecutivo);
					mensajeBean.setConsecutivoInt(consecutivoInt);

					return mensajeBean;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Solicitud de Credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// metodo para actualizar calendario de Solicitud de credito
	public MensajeTransaccionBean actualizaCalendarioSolicitudCredito(final SolicitudCreditoBean solicitudCredito) {

		String formaCobro = solicitudCredito.getForCobroSegVida().substring(0,1);
		solicitudCredito.setForCobroSegVida(formaCobro);

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDGRUPALACT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(solicitudCredito.getGrupoID()));
									sentenciaStore.setString("Par_PlazoID",solicitudCredito.getPlazoID());
									sentenciaStore.setString("Par_TipoPagCap",solicitudCredito.getTipoPagoCapital());
									sentenciaStore.setString("Par_FrecInter",solicitudCredito.getFrecuenciaInt());
									sentenciaStore.setString("Par_FrecCapital",solicitudCredito.getFrecuenciaCap());

									sentenciaStore.setInt("Par_PeriodInt",Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
									sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
									sentenciaStore.setString("Par_DiaPagInt",solicitudCredito.getDiaPagoInteres());
									sentenciaStore.setString("Par_DiaPagCap",solicitudCredito.getDiaPagoCapital());
									sentenciaStore.setInt("Par_DiaMesInter",Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));

									sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
									sentenciaStore.setInt("Par_NumAmorti",Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
									sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
									sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
									sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));

									sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
									sentenciaStore.setDouble("Par_MontoSolicitado",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
									sentenciaStore.setString("Par_Estatus",solicitudCredito.getEstatus());
									sentenciaStore.setString("Par_ForCobroSegVida",solicitudCredito.getForCobroSegVida());
									sentenciaStore.setDouble("Par_DescuentoSeguro",Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));
									sentenciaStore.setDouble("Par_MontoSegOriginal",Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));

									sentenciaStore.setInt("Par_NumAct",SolicitudCreditoBean.Act_Calendario);

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cambio de condiciones grupales", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
	}


	public MensajeTransaccionBean autorizaSolicitudCredito(final SolicitudCreditoBean solicitudCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
									sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(solicitudCredito.getMontoAutorizado()));
									sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(solicitudCredito.getFechaAutoriza()));
									sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(solicitudCredito.getUsuarioAutoriza()));
									sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
									sentenciaStore.setString("Par_ComentEjecutivo", solicitudCredito.getComentarioEjecutivo());
									sentenciaStore.setString("Par_ComentMesaControl",solicitudCredito.getComentarioMesaControl());
									sentenciaStore.setString("Par_CadenaMotivo",Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_ComentMotivo",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en autorizacion de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// metodo de rechazo de solicitudes de credito
	public MensajeTransaccionBean rechazarSolicitudCredito(final SolicitudCreditoBean solicitudCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
									sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(solicitudCredito.getMontoAutorizado()));
									sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(solicitudCredito.getFechaAutoriza()));
									sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(solicitudCredito.getUsuarioAutoriza()));
									sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
									sentenciaStore.setString("Par_ComentEjecutivo", solicitudCredito.getComentarioEjecutivo());
									sentenciaStore.setString("Par_ComentMesaControl",solicitudCredito.getComentarioMesaControl());
									sentenciaStore.setString("Par_CadenaMotivo",solicitudCredito.getMotivoRechazoID());
									sentenciaStore.setString("Par_ComentMotivo",solicitudCredito.getComentarioEjecutivo());
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"erro en rechazo de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	// metodo de regreso a ejecutivo de solicitudes de credito
		public MensajeTransaccionBean regresarEjecSolicitudCredito(final SolicitudCreditoBean solicitudCredito, final int tipoActualizacion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
										sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(solicitudCredito.getMontoAutorizado()));
										sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(solicitudCredito.getFechaAutoriza()));
										sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(solicitudCredito.getUsuarioAutoriza()));
										sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
										sentenciaStore.setString("Par_ComentEjecutivo", solicitudCredito.getComentarioEjecutivo());
										sentenciaStore.setString("Par_ComentMesaControl",solicitudCredito.getComentarioMesaControl());
										sentenciaStore.setString("Par_CadenaMotivo",solicitudCredito.getMotivoDevolucionID());
										sentenciaStore.setString("Par_ComentMotivo",solicitudCredito.getComentarioEjecutivo());
										sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

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
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en regresar la ejecucion de solicitud de credito", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}


		// metodo de liberacion de solicitudes de credito
		public MensajeTransaccionBean liberarSolicitudCredito(final SolicitudCreditoBean solicitudCredito, final int tipoActualizacion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
										sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(solicitudCredito.getMontoAutorizado()));
										sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
										sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(solicitudCredito.getUsuarioAutoriza()));
										sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
										sentenciaStore.setString("Par_ComentEjecutivo", solicitudCredito.getComentarioEjecutivo());
										sentenciaStore.setString("Par_ComentMesaControl",solicitudCredito.getComentarioMesaControl());
										sentenciaStore.setString("Par_CadenaMotivo",Constantes.STRING_VACIO);
										sentenciaStore.setString("Par_ComentMotivo",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

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
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en liberar solicitud de credito", e);
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


		// metodo de liberacion de solicitudes de credito

				public MensajeTransaccionBean actComentarioEjecutivo(final SolicitudCreditoBean solicitudCredito, final int tipoActualizacion) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

					transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {
											public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
												sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
												sentenciaStore.setDouble("Par_MontoAutor",Constantes.DOUBLE_VACIO);
												sentenciaStore.setString("Par_FechAutoriz",Constantes.FECHA_VACIA);
												sentenciaStore.setInt("Par_UsuarioAut",Constantes.ENTERO_CERO);
												sentenciaStore.setDouble("Par_AporteCli", Constantes.DOUBLE_VACIO);
												sentenciaStore.setString("Par_ComentEjecutivo", solicitudCredito.getComentarioEjecutivo().trim());
												sentenciaStore.setString("Par_ComentMesaControl",Constantes.STRING_VACIO);
												sentenciaStore.setString("Par_CadenaMotivo",Constantes.STRING_VACIO);
												sentenciaStore.setString("Par_ComentMotivo",Constantes.STRING_VACIO);
												sentenciaStore.setInt("Par_NumAct", tipoActualizacion);


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
													mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de comentario ejecutivo", e);
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


				/* Consuta Principal Solicitud de credito */
				public SolicitudCreditoBean consultaPrincipal(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
					//Query con el Store Procedure
					String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							solicitudCredito.getUsuario(),
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
					//loggeo de jQuery en llamadas al store procedure
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							SolicitudCreditoBean solicitudCredito = null;
							try{
								solicitudCredito = new SolicitudCreditoBean();
								solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
								solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
								solicitudCredito.setNombreCompletoCliente(resultSet.getString(3));
								solicitudCredito.setMonedaID(String.valueOf(resultSet.getInt(4)));
								solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(5)));
								solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(6)));
								solicitudCredito.setNombreCompletoProspecto(resultSet.getString(7));
								solicitudCredito.setFechaRegistro(String.valueOf(resultSet.getDate(8)));
								solicitudCredito.setFechaAutoriza(String.valueOf(resultSet.getDate(9)));
								solicitudCredito.setMontoSolici(resultSet.getString(10));

								solicitudCredito.setMontoAutorizado(resultSet.getString(11));
								solicitudCredito.setPlazoID(String.valueOf(resultSet.getInt(12)));
								solicitudCredito.setEstatus(resultSet.getString(13));
								solicitudCredito.setTipoDispersion(resultSet.getString(14));
								solicitudCredito.setCuentaCLABE(resultSet.getString(15));
								solicitudCredito.setSucursalID(String.valueOf(resultSet.getInt(16)));
								solicitudCredito.setForCobroComAper(resultSet.getString(17));
								solicitudCredito.setMontoComApert(resultSet.getString(18));
								solicitudCredito.setIvaComApert(resultSet.getString(19));
								solicitudCredito.setDestinoCreID(String.valueOf(resultSet.getInt(20)));

								solicitudCredito.setPromotorID(String.valueOf(resultSet.getInt(21)));
								solicitudCredito.setCalcInteresID(String.valueOf(resultSet.getInt(22)));
								solicitudCredito.setTasaFija(String.valueOf(resultSet.getDouble(23)));
								solicitudCredito.setTasaBase(resultSet.getString(24));
								solicitudCredito.setSobreTasa(String.valueOf(resultSet.getDouble(25)));
								solicitudCredito.setPisoTasa(String.valueOf(resultSet.getDouble(26)));
								solicitudCredito.setTechoTasa(String.valueOf(resultSet.getDouble(27)));
								solicitudCredito.setFactorMora(String.valueOf(resultSet.getDouble(28)));
								solicitudCredito.setFrecuenciaCap(resultSet.getString(29));
								solicitudCredito.setPeriodicidadCap(String.valueOf(resultSet.getInt(30)));

								solicitudCredito.setFrecuenciaInt(resultSet.getString(31));
								solicitudCredito.setPeriodicidadInt(String.valueOf(resultSet.getInt(32)));
								solicitudCredito.setTipoPagoCapital(resultSet.getString(33));
								solicitudCredito.setNumAmortizacion(String.valueOf(resultSet.getInt(34)));
								solicitudCredito.setCalendIrregular(resultSet.getString(35));
								solicitudCredito.setDiaPagoInteres(resultSet.getString(36));
								solicitudCredito.setDiaPagoCapital(resultSet.getString(37));
								solicitudCredito.setDiaMesInteres(String.valueOf(resultSet.getInt(38)));
								solicitudCredito.setDiaMesCapital(String.valueOf(resultSet.getInt(39)));
								solicitudCredito.setAjFecUlAmoVen(resultSet.getString(40));

								solicitudCredito.setAjusFecExiVen(resultSet.getString(41));
								solicitudCredito.setNumTransacSim(String.valueOf(resultSet.getInt(42)));
								solicitudCredito.setCAT(String.valueOf(resultSet.getDouble(43)));
								solicitudCredito.setFechInhabil(resultSet.getString(44));
								solicitudCredito.setAporteCliente(resultSet.getString(45));
								solicitudCredito.setUsuarioAutoriza(String.valueOf(resultSet.getInt(46)));
								solicitudCredito.setFechaRechazo(String.valueOf(resultSet.getDate(47)));
								solicitudCredito.setUsuarioRechazo(String.valueOf(resultSet.getInt(48)));
								solicitudCredito.setComentarioRech(resultSet.getString(49));
								solicitudCredito.setMotivoRechazo(String.valueOf(resultSet.getInt(50)));

								solicitudCredito.setTipoCredito(resultSet.getString(51));
								solicitudCredito.setNumCreditos(String.valueOf(resultSet.getInt(52)));
								solicitudCredito.setRelacionado(resultSet.getString(53));
								solicitudCredito.setProyecto(resultSet.getString(54));
								solicitudCredito.setTipoFondeo(resultSet.getString(55));
								solicitudCredito.setInstitutFondID(String.valueOf(resultSet.getInt(56)));
								solicitudCredito.setLineaFondeoID(String.valueOf(resultSet.getInt(57)));
								solicitudCredito.setTipoCalInteres(String.valueOf(resultSet.getInt(58)));
								solicitudCredito.setCreditoID(resultSet.getString(59));
								solicitudCredito.setFechaFormalizacion(resultSet.getString(60));

								solicitudCredito.setMontoFondeado(resultSet.getString(61));
								solicitudCredito.setPorcentajeFonde(resultSet.getString(62));
								solicitudCredito.setNumeroFondeos(resultSet.getString(63));
								solicitudCredito.setNumAmortInteres(String.valueOf(resultSet.getInt(64)));
								solicitudCredito.setMontoCuota(resultSet.getString(65));
								solicitudCredito.setGrupoID(resultSet.getString(66));
								solicitudCredito.setNombreGrupo(resultSet.getString(67));
								solicitudCredito.setFechaRegistroGr(resultSet.getString(68));
								solicitudCredito.setCicloActual(resultSet.getString(69));

								solicitudCredito.setComentarioEjecutivo(resultSet.getString(70));
								solicitudCredito.setComentarioMesaControl(resultSet.getString(71));
								solicitudCredito.setSucursalPromotor(String.valueOf(resultSet.getString("SucursalPromot")));
								solicitudCredito.setPromAtiendeSuc(resultSet.getString("PromotAtiendeSucursal"));
								solicitudCredito.setNumCreditos(resultSet.getString(74));
								solicitudCredito.setFechaVencimiento(resultSet.getString(75));
								solicitudCredito.setFechaInicio(resultSet.getString(76));
								solicitudCredito.setMontoSeguroVida(resultSet.getString(77));
								solicitudCredito.setForCobroSegVida(resultSet.getString(78));
								solicitudCredito.setClasifiDestinCred(resultSet.getString(79));
								solicitudCredito.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
								solicitudCredito.setFolioCtrl(resultSet.getString("FolioCtrl"));
								solicitudCredito.setHorarioVeri(resultSet.getString("HorarioVeri"));
								solicitudCredito.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
								solicitudCredito.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
								solicitudCredito.setFechaInicioAmor(resultSet.getString("FechaInicioAmor"));
								solicitudCredito.setDiaPagoProd(resultSet.getString("DiaPagoProd")); // Dia de pago de capital-interes segun el producto de credito
								solicitudCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
								solicitudCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
								solicitudCredito.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
								solicitudCredito.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
								solicitudCredito.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
								solicitudCredito.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
								solicitudCredito.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));

								solicitudCredito.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
								solicitudCredito.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
								solicitudCredito.setSubramaFIRAID(resultSet.getString("SubramaFIRAID"));
								solicitudCredito.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
								solicitudCredito.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
								solicitudCredito.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
								solicitudCredito.setFechaCobroComision(resultSet.getString("FechaCobroComision"));

								solicitudCredito.setEsAutomatico(resultSet.getString("EsAutomatico"));
								solicitudCredito.setTipoAutomatico(resultSet.getString("TipoAutomatico"));
								solicitudCredito.setInversionID(resultSet.getString("InvCredAut"));
								solicitudCredito.setCuentaAhoID(resultSet.getString("CtaCredAut"));
								solicitudCredito.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
								solicitudCredito.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));
								solicitudCredito.setEsReacreditado(resultSet.getString("Reacreditado"));
								solicitudCredito.setCobraAccesorios(resultSet.getString("cobraAccesorios"));
								solicitudCredito.setCobertura(resultSet.getString("Cobertura"));
								solicitudCredito.setPrima(resultSet.getString("Prima"));
								solicitudCredito.setVigencia(resultSet.getString("Vigencia"));
								solicitudCredito.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
								solicitudCredito.setFolioSolici(resultSet.getString("FolioSolici"));
								solicitudCredito.setQuinquenioID(resultSet.getString("QuinquenioID"));
								solicitudCredito.setClabeDomiciliacion(resultSet.getString("ClabeDomiciliacion"));
								solicitudCredito.setTipoCtaSantander(resultSet.getString("TipoCtasantander"));
								solicitudCredito.setCtaSantander(resultSet.getString("CtaSantander"));
								solicitudCredito.setCtaClabeDisp(resultSet.getString("CtaClabeDisp"));
								solicitudCredito.setTipoPersona(resultSet.getString("TipoPersona"));
								solicitudCredito.setEsConsolidacionAgro(resultSet.getString("EsConsolidacionAgro"));
								solicitudCredito.setDeudorOriginalID(resultSet.getString("DeudorOriginalID"));
								solicitudCredito.setFlujoOrigen(resultSet.getString("FlujoOrigen"));
								// Lineas Credito Agro
								solicitudCredito.setLineaCreditoID(resultSet.getString("LineaCreditoID"));

								solicitudCredito.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
								solicitudCredito.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
								solicitudCredito.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
								solicitudCredito.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
								solicitudCredito.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
								solicitudCredito.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));

								solicitudCredito.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
								solicitudCredito.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
								solicitudCredito.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
								solicitudCredito.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
								solicitudCredito.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
								solicitudCredito.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));

							} catch(Exception ex){
								loggerSAFI.info("Error al realizar consulta de Solicitud de Credito:"+ex.getMessage(),ex);
								ex.printStackTrace();
							}
							return solicitudCredito;

						}
					});

					return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
				}

	/**
	 * Consuta Principal Solicitud de Credito Agropecuario
	 * @param solicitudCredito : {@link SolicitudCreditoBean}
	 * @param tipoConsulta : Numero de Consulta 9
	 * @return  {@link SolicitudCreditoBean}
	 */
	public SolicitudCreditoBean consultaPrincipalAgro(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
				tipoConsulta, Constantes.ENTERO_CERO,
				solicitudCredito.getUsuario(),
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		//loggeo de jQuery en llamadas al store procedure
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = null;
				try {
					solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
					solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
					solicitudCredito.setNombreCompletoCliente(resultSet.getString(3));
					solicitudCredito.setMonedaID(String.valueOf(resultSet.getInt(4)));
					solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(5)));
					solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(6)));
					solicitudCredito.setNombreCompletoProspecto(resultSet.getString(7));
					solicitudCredito.setFechaRegistro(String.valueOf(resultSet.getDate(8)));
					solicitudCredito.setFechaAutoriza(String.valueOf(resultSet.getDate(9)));
					solicitudCredito.setMontoSolici(resultSet.getString(10));

					solicitudCredito.setMontoAutorizado(resultSet.getString(11));
					solicitudCredito.setPlazoID(String.valueOf(resultSet.getInt(12)));
					solicitudCredito.setEstatus(resultSet.getString(13));
					solicitudCredito.setTipoDispersion(resultSet.getString(14));
					solicitudCredito.setCuentaCLABE(resultSet.getString(15));
					solicitudCredito.setSucursalID(String.valueOf(resultSet.getInt(16)));
					solicitudCredito.setForCobroComAper(resultSet.getString(17));
					solicitudCredito.setMontoComApert(resultSet.getString(18));
					solicitudCredito.setIvaComApert(resultSet.getString(19));
					solicitudCredito.setDestinoCreID(String.valueOf(resultSet.getInt(20)));

					solicitudCredito.setPromotorID(String.valueOf(resultSet.getInt(21)));
					solicitudCredito.setCalcInteresID(String.valueOf(resultSet.getInt(22)));
					solicitudCredito.setTasaFija(String.valueOf(resultSet.getDouble(23)));
					solicitudCredito.setTasaBase(resultSet.getString(24));
					solicitudCredito.setSobreTasa(String.valueOf(resultSet.getDouble(25)));
					solicitudCredito.setPisoTasa(String.valueOf(resultSet.getDouble(26)));
					solicitudCredito.setTechoTasa(String.valueOf(resultSet.getDouble(27)));
					solicitudCredito.setFactorMora(String.valueOf(resultSet.getDouble(28)));
					solicitudCredito.setFrecuenciaCap(resultSet.getString(29));
					solicitudCredito.setPeriodicidadCap(String.valueOf(resultSet.getInt(30)));

					solicitudCredito.setFrecuenciaInt(resultSet.getString(31));
					solicitudCredito.setPeriodicidadInt(String.valueOf(resultSet.getInt(32)));
					solicitudCredito.setTipoPagoCapital(resultSet.getString(33));
					solicitudCredito.setNumAmortizacion(String.valueOf(resultSet.getInt(34)));
					solicitudCredito.setCalendIrregular(resultSet.getString(35));
					solicitudCredito.setDiaPagoInteres(resultSet.getString(36));
					solicitudCredito.setDiaPagoCapital(resultSet.getString(37));
					solicitudCredito.setDiaMesInteres(String.valueOf(resultSet.getInt(38)));
					solicitudCredito.setDiaMesCapital(String.valueOf(resultSet.getInt(39)));
					solicitudCredito.setAjFecUlAmoVen(resultSet.getString(40));

					solicitudCredito.setAjusFecExiVen(resultSet.getString(41));
					solicitudCredito.setNumTransacSim(String.valueOf(resultSet.getInt(42)));
					solicitudCredito.setCAT(String.valueOf(resultSet.getDouble(43)));
					solicitudCredito.setFechInhabil(resultSet.getString(44));
					solicitudCredito.setAporteCliente(resultSet.getString(45));
					solicitudCredito.setUsuarioAutoriza(String.valueOf(resultSet.getInt(46)));
					solicitudCredito.setFechaRechazo(String.valueOf(resultSet.getDate(47)));
					solicitudCredito.setUsuarioRechazo(String.valueOf(resultSet.getInt(48)));
					solicitudCredito.setComentarioRech(resultSet.getString(49));
					solicitudCredito.setMotivoRechazo(String.valueOf(resultSet.getInt(50)));

					solicitudCredito.setTipoCredito(resultSet.getString(51));
					solicitudCredito.setNumCreditos(String.valueOf(resultSet.getInt(52)));
					solicitudCredito.setRelacionado(resultSet.getString(53));
					solicitudCredito.setProyecto(resultSet.getString(54));
					solicitudCredito.setTipoFondeo(resultSet.getString(55));
					solicitudCredito.setInstitutFondID(String.valueOf(resultSet.getInt(56)));
					solicitudCredito.setLineaFondeoID(String.valueOf(resultSet.getInt(57)));
					solicitudCredito.setTipoCalInteres(String.valueOf(resultSet.getInt(58)));
					solicitudCredito.setCreditoID(resultSet.getString(59));
					solicitudCredito.setFechaFormalizacion(resultSet.getString(60));

					solicitudCredito.setMontoFondeado(resultSet.getString(61));
					solicitudCredito.setPorcentajeFonde(resultSet.getString(62));
					solicitudCredito.setNumeroFondeos(resultSet.getString(63));
					solicitudCredito.setNumAmortInteres(String.valueOf(resultSet.getInt(64)));
					solicitudCredito.setMontoCuota(resultSet.getString(65));
					solicitudCredito.setGrupoID(resultSet.getString(66));
					solicitudCredito.setNombreGrupo(resultSet.getString(67));
					solicitudCredito.setFechaRegistroGr(resultSet.getString(68));
					solicitudCredito.setCicloActual(resultSet.getString(69));

					solicitudCredito.setComentarioEjecutivo(resultSet.getString(70));
					solicitudCredito.setComentarioMesaControl(resultSet.getString(71));
					solicitudCredito.setSucursalPromotor(String.valueOf(resultSet.getString("SucursalPromot")));
					solicitudCredito.setPromAtiendeSuc(resultSet.getString("PromotAtiendeSucursal"));
					solicitudCredito.setNumCreditos(resultSet.getString(74));
					solicitudCredito.setFechaVencimiento(resultSet.getString(75));
					solicitudCredito.setFechaInicio(resultSet.getString(76));
					solicitudCredito.setMontoSeguroVida(resultSet.getString(77));
					solicitudCredito.setForCobroSegVida(resultSet.getString(78));
					solicitudCredito.setClasifiDestinCred(resultSet.getString(79));
					solicitudCredito.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
					solicitudCredito.setFolioCtrl(resultSet.getString("FolioCtrl"));
					solicitudCredito.setHorarioVeri(resultSet.getString("HorarioVeri"));
					solicitudCredito.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
					solicitudCredito.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
					solicitudCredito.setFechaInicioAmor(resultSet.getString("FechaInicioAmor"));
					solicitudCredito.setDiaPagoProd(resultSet.getString("DiaPagoProd")); // Dia de pago de capital-interes segun el producto de credito
					solicitudCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
					solicitudCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
					solicitudCredito.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
					solicitudCredito.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
					solicitudCredito.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
					solicitudCredito.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));

					solicitudCredito.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
					solicitudCredito.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
					solicitudCredito.setSubramaFIRAID(resultSet.getString("SubramaFIRAID"));
					solicitudCredito.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
					solicitudCredito.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
					solicitudCredito.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
					solicitudCredito.setFechaCobroComision(resultSet.getString("FechaCobroComision"));

					solicitudCredito.setEsAutomatico(resultSet.getString("EsAutomatico"));
					solicitudCredito.setTipoAutomatico(resultSet.getString("TipoAutomatico"));
					solicitudCredito.setInversionID(resultSet.getString("InvCredAut"));
					solicitudCredito.setCuentaAhoID(resultSet.getString("CtaCredAut"));
					solicitudCredito.setTasaPasiva(resultSet.getString("TasaPasiva"));
					solicitudCredito.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
					solicitudCredito.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));
					solicitudCredito.setEsReacreditado(resultSet.getString("Reacreditado"));
					solicitudCredito.setEsConsolidacionAgro(resultSet.getString("EsConsolidacionAgro"));
					solicitudCredito.setDeudorOriginalID(resultSet.getString("DeudorOriginalID"));
					// Lineas Credito Agro
					solicitudCredito.setLineaCreditoID(resultSet.getString("LineaCreditoID"));

					solicitudCredito.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
					solicitudCredito.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
					solicitudCredito.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
					solicitudCredito.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
					solicitudCredito.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
					solicitudCredito.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));

					solicitudCredito.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
					solicitudCredito.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
					solicitudCredito.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
					solicitudCredito.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
					solicitudCredito.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
					solicitudCredito.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));

				} catch (Exception ex) {
					loggerSAFI.info("Error al realizar consulta de Solicitud de Credito:" + ex.getMessage(), ex);
					ex.printStackTrace();
				}
				return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	/* Consuta Foreanea Solicitud de credito */
	public SolicitudCreditoBean consultaForeanea(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setMontoSolici(resultSet.getString(5));
				solicitudCredito.setMontoAutorizado(String.valueOf(resultSet.getString(6)));
				return solicitudCredito;
			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}


	/* Consuta para ver Solicitudes Asignadas */
	public SolicitudCreditoBean consultaSolicitudAs(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setAsignaSol(String.valueOf(resultSet.getString(5)));



					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}


	/* Consuta para ver solicitudes Activas y de unsa sucursal en especifico */
	public SolicitudCreditoBean consultaSolActYSuc(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(solicitudCredito.getSucursal()),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setEstatus(resultSet.getString(5));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}


	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoBean consultaSolPorSuc(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(solicitudCredito.getSucursal()),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setAsignaSol(String.valueOf(resultSet.getString(5)));
				solicitudCredito.setEstatusSol(String.valueOf(resultSet.getString(6)));
				solicitudCredito.setTipoCredito(resultSet.getString("TipoCredito"));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoBean consultaSolPorOblSuc(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(solicitudCredito.getSucursal()),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt("ProspectoID")));
				solicitudCredito.setAsignaOblSol(String.valueOf(resultSet.getString("Estatus")));
				solicitudCredito.setEstatusSol(String.valueOf(resultSet.getString("EstatusSol")));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoBean consultaDetalleGarFOGAFI(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call DETALLEGARLIQUIDACON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(solicitudCredito.getSucursal()),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEGARLIQUIDACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setMontoFOGAFI(resultSet.getString("MontoGarFOGAFI"));
				solicitudCredito.setPorcentajeFOGAFI(resultSet.getString("PorcGarFOGAFI"));
				solicitudCredito.setModalidadFOGAFI(resultSet.getString("ModalidadFOGAFI"));


					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	/* Consulta Dias Primer Amortizacion para Tipo Pago Capital: LIBRES */
	public SolicitudCreditoBean consultaDiasPrimerAmor(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(solicitudCredito.getSucursal()),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setValorParametro(resultSet.getString("Var_ValorReqPrimerAmor"));
				solicitudCredito.setNumDiasVenPrimAmor(String.valueOf(resultSet.getInt("Var_NumDiasVenPrimAmor")));
				solicitudCredito.setDiasReqPrimerAmor(String.valueOf(resultSet.getInt("Var_DiasReqPrimerAmor")));
				solicitudCredito.setFechaActual(resultSet.getString("Var_FechaSistema"));
				solicitudCredito.setFechaVencimiento(resultSet.getString("Var_FecFinPrimerAmor"));

				return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	// Lista de solicitudes de credito
		public List listaPrincipal(SolicitudCreditoBean solicitudCredito, int tipoLista){

			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}


		// Lista de solicitudes de credito para Integrantes de Grupo
		public List listaIntegraGrupo(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}



		// Lista de solicitudes de credito para Integrantes de Grupo
		public List listaIntegraAvales(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();

					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}


		// Lista de solicitudes de credito estatus inactivas
		public List listaSolicitudesInactivas(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();

					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}


		// Lista de solicitudes de credito estatus Autorizadas
		public List listaSolicitudesAutorizadas(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}

		// Lista para ventana CheckList
		public List listaSolCheckListGrid(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					solicitudCredito.getClienteID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();

					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setEstatus(resultSet.getString(2));
					solicitudCredito.setMontoAutorizado(resultSet.getString(3));
					solicitudCredito.setFechaRegistro(resultSet.getString(4));
					solicitudCredito.setNombreCompletoCliente(resultSet.getString(5));



					return solicitudCredito;
				}
			});
			return matches;
		}

		// Lista de solicitudes de credito Liberadas  Filtradas por el Promotor si es que atiende a sucursal
		public List listaSolLiberadasPromotor(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					solicitudCredito.getClienteID(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();

					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setEstatus(resultSet.getString(2));
					solicitudCredito.setMontoSolici(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));
					solicitudCredito.setClienteID(resultSet.getString(6));
					solicitudCredito.setGrupoID(resultSet.getString(7));
					solicitudCredito.setNombreGrupo(resultSet.getString(8));


					return solicitudCredito;
				}
			});
			return matches;
		}



		// Lista de solicitudes de credito tratamient: Renovacion o Reestructura
		public List listaSolTratamiento(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();

					solicitudCredito.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCredito.setClienteID(resultSet.getString("NombreCompleto"));
					solicitudCredito.setEstatus(resultSet.getString("Estatus"));
					solicitudCredito.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					solicitudCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return solicitudCredito;
				}
			});
			return matches;
		}




	   /* LISTA COMBO MOTIVOS CANCELACION */
		public List listaComboMotCancelacion(int tipoLista) {
			// Query con el Store Procedure
			String query = "call CATALOGOMOTRECHAZOLIS(?,"
											   +"?,?,?,?,?,?,?);";

			Object[] parametros = {
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"analistasAsignacionesDAO.listaComboCatalogoAsig",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOMOTRECHAZOLIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

					SolicitudCreditoBean bean = new SolicitudCreditoBean();

					bean.setMotivoRechazoID(resultSet.getString("MotivoRechazoID"));
					bean.setDescripcionMotivo(resultSet.getString("Descripcion"));

					return bean;
				}
			});

			return matches;
		}

		/* Consuta Principal Solicitud de credito */
		public SolicitudCreditoBean consultaInstruccionDispersion(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					solicitudCredito.getUsuario(),
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			//loggeo de jQuery en llamadas al store procedure
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = null;
					try{
						solicitudCredito = new SolicitudCreditoBean();
						solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
						solicitudCredito.setClienteID(resultSet.getString(2));
						solicitudCredito.setNombreCompletoCliente(resultSet.getString(3));
						solicitudCredito.setMontoSolici(resultSet.getString(4));
						solicitudCredito.setEstatus(resultSet.getString(5));


					} catch(Exception ex){
						loggerSAFI.info("Error al realizar consulta de Solicitud de Credito:"+ex.getMessage(),ex);
						ex.printStackTrace();
					}
					return solicitudCredito;

				}
			});

			return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
		}


		//Lista de motivos sobre caso de solicitudes de crdito regresadas a ejecutvos
		public List listaComboMotDevolucion(int tipoLista) {

			//Query con el Store Procedure
			String query = "call CATALOGOMOTRECHAZOLIS(?,?,?,?,?,?,?,?);";
			Object[] parametros = {
									tipoLista,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SolicitudCreditoDAO.listaComboMotDevolucion",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOMOTRECHAZOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					SolicitudCreditoBean bean = new SolicitudCreditoBean();

					bean.setMotivoDevolucionID(resultSet.getString("MotivoRechazoID"));
					bean.setDescripcionMotivo(resultSet.getString("Descripcion"));
					return bean;
				}
			});

			return matches;
		}

		// Lista de solicitudes de credito que presentan un posible riesgo común
		public List listaSolRiesgoComun(SolicitudCreditoBean solicitudCredito, int tipoLista){
			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCredito.setClienteID(resultSet.getString("ClienteID"));
					solicitudCredito.setProspectoID(resultSet.getString("ProspectoID"));
					solicitudCredito.setNombreCompletoCliente(resultSet.getString("NombreCompletoCli"));
					solicitudCredito.setNombreCompletoProspecto(resultSet.getString("NombreCompletoPros"));
					solicitudCredito.setEstatus(resultSet.getString("Estatus"));
					solicitudCredito.setMontoAutorizado(resultSet.getString("montoAutorizado"));
					solicitudCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return solicitudCredito;
				}
			});
			return matches;
		}
		// Lista de solicitudes de credito
		public List listaInstruccionDispersion(SolicitudCreditoBean solicitudCredito, int tipoLista){

			String query = "call SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
						solicitudCredito.getClienteID(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString(1));
					solicitudCredito.setClienteID(resultSet.getString(2));
					solicitudCredito.setEstatus(resultSet.getString(3));
					solicitudCredito.setMontoAutorizado(resultSet.getString(4));
					solicitudCredito.setFechaRegistro(resultSet.getString(5));

					return solicitudCredito;
				}
			});
			return matches;
		}

		public CicloCreditoBean consultaCicloCredito(final CicloCreditoBean cicloClienteBean) {
			CicloCreditoBean mensaje = new CicloCreditoBean();
			mensaje = (CicloCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call CRECALCULOCICLOPRO(?,?,?,?,?, ?,?,?,?,?," +
																				"?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cicloClienteBean.getClienteID()));
										sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(cicloClienteBean.getProspectoID()));
										sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(cicloClienteBean.getProductoCreditoID()));
										sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(cicloClienteBean.getGrupoID()));

										sentenciaStore.registerOutParameter("Par_CicloCliente",Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_CicloPondGrupo",Types.INTEGER);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

										//Parametros de Auditoria
										sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
										sentenciaStore.setInt("Aud_Usuario",Constantes.ENTERO_CERO);
										sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
										sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
										sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
										sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										CicloCreditoBean cicloCliente = new CicloCreditoBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
																								//	CicloCliente
											cicloCliente.setCicloCliente(resultadosStore.getString("CicloCliente"));
											cicloCliente.setCicloPondGrupo(resultadosStore.getString("CicloPondGrupo"));
											}
										return cicloCliente;
									}
								});
				return mensaje;
			}

		public MensajeTransaccionBean altaSolicitudCreditoBE(final SolicitudCreditoBean solicitudCredito) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SOLICITUDCREDITOWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, " +
																			      "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setLong("Par_ProspectoID",Utileria.convierteLong(solicitudCredito.getProspectoID()));
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCredito.getClienteID()));
										sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
										sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
										sentenciaStore.setInt("Par_Promotor",Utileria.convierteEntero(solicitudCredito.getPromotorID()));
										sentenciaStore.setInt("Par_DestinoCre",Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
										sentenciaStore.setString("Par_Proyecto",solicitudCredito.getProyecto());
										sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(solicitudCredito.getSucursalID()));
										sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
										sentenciaStore.setString("Par_PlazoID",solicitudCredito.getPlazoID());

										sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCredito.getFactorMora()));
										sentenciaStore.setDouble("Par_ComApertura",Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
										sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(solicitudCredito.getTasaFija()));
										sentenciaStore.setString("Par_Frecuencia",solicitudCredito.getFrecuenciaCap());
										sentenciaStore.setDouble("Par_IVAComAper",Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
										sentenciaStore.setInt("Par_Periodicidad",Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
										sentenciaStore.setInt("Par_NumAmorti",Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
										sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));
										sentenciaStore.setDouble("Par_CAT",Utileria.convierteDoble(solicitudCredito.getCAT()));
										sentenciaStore.setString("Par_CuentaClabe",solicitudCredito.getCuentaCLABE());

										sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
										sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
										sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
										sentenciaStore.setString("Par_ClasiDestinCred",solicitudCredito.getClasifiDestinCred());
										sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));
										sentenciaStore.setInt("Par_NegocioAfiliadoID",Utileria.convierteEntero(solicitudCredito.getNegocioAfiliadoID()));
										sentenciaStore.setInt("Par_NumCreditos",Utileria.convierteEntero(solicitudCredito.getNumCreditos()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Solicitud de Credito BE", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}

	public SolicitudCreditoBean consultaBancaEnLinea(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call SOLICITUDCREDITOWSCON(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
									tipoConsulta,
									Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()),
									Utileria.convierteEntero(solicitudCredito.getNegocioAfiliadoID()),

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
					solicitudCredito.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					solicitudCredito.setNombreCompletoCliente(resultSet.getString("CliNombreCompleto"));
					solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt("ProspectoID")));
					solicitudCredito.setNombreCompletoProspecto(resultSet.getString("ProNombreCompleto"));
					solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
					solicitudCredito.setDescripcionProducto(resultSet.getString("Descripcion"));
					solicitudCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));
					solicitudCredito.setEstatus(resultSet.getString("Estatus"));
					solicitudCredito.setProyecto(resultSet.getString("Proyecto"));

					solicitudCredito.setMontoSolici(String.valueOf(resultSet.getDouble("MontoSolici")));
					solicitudCredito.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
					solicitudCredito.setFechaInicio(resultSet.getString("FechaInicio"));
					solicitudCredito.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					solicitudCredito.setFormaComApertura(resultSet.getString("ForCobroComAper"));
					solicitudCredito.setMontoComApert(String.valueOf(resultSet.getDouble("MontoPorComAper")));
					solicitudCredito.setPlazoID(String.valueOf(resultSet.getInt("PlazoID")));
					solicitudCredito.setFrecuenciaCap(resultSet.getString("FrecuenciaCap"));
					solicitudCredito.setNumAmortizacion(String.valueOf(resultSet.getInt("NumAmortizacion")));
					solicitudCredito.setCAT(String.valueOf(resultSet.getDouble("ValorCAT")));

					return solicitudCredito;
				}
			});
			return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
		}

	/* metodo para procesar los cambios de condiciones grupales*/
	public MensajeTransaccionBean auxActualizaCalendarioSolicitudCredito(final List listaBeanSolCred) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					SolicitudCreditoBean bean;

					if(listaBeanSolCred!=null){
						for(int i=0; i<listaBeanSolCred.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (SolicitudCreditoBean)listaBeanSolCred.get(i);
								mensajeBean = actualizaCalendarioSolicitudCredito(bean);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesa cambios de condiciones grupales", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de procesar

	public SolicitudCreditoBean consultaExisSol(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOWSCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),			// En este parametro va el numero de credito
								tipoConsulta,
								Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()),
								Utileria.convierteEntero(solicitudCredito.getNegocioAfiliadoID()),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setSolicitudCreditoID(resultSet.getString("CreditoID"));

				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	public SolicitudCreditoBean consultaClienCre(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOWSCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),
								tipoConsulta,
								Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()),
								Utileria.convierteEntero(solicitudCredito.getNegocioAfiliadoID()),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));

				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	// Consulta del Empleado para la carga de archivo para la aplicacion de pagos de nomina
	public SolicitudCreditoBean consultaEmpleadoCre(SolicitudCreditoBean solicitudCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOWSCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()),				// En este parametro va el numero de credito
								tipoConsulta,
								Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()),
								Utileria.convierteEntero(solicitudCredito.getNegocioAfiliadoID()),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOWSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
				solicitudCredito.setFolioCtrl(resultSet.getString("FolioCtrl"));


				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;
	}

	// metodo para obtener el simulador de cuotas de credito en los web service
		public SimuladorCuotaCreditoResponse simuladorCuotaCredito(final SolicitudCreditoBean solicitudCreditoBean) {
			SimuladorCuotaCreditoResponse mensaje = new SimuladorCuotaCreditoResponse();
			transaccionDAO.generaNumeroTransaccion();
					mensaje = (SimuladorCuotaCreditoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("microfin")).execute(

					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					SimuladorCuotaCreditoResponse mensajeBean = new SimuladorCuotaCreditoResponse();
					try {
						// Query con el Store Procedure
						mensajeBean = (SimuladorCuotaCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CREPAGCRECWSPRO(?,?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(solicitudCreditoBean.getMontoSolici()));
									sentenciaStore.setString("Par_PagoCuota",solicitudCreditoBean.getPeriodicidadCap());
									sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(solicitudCreditoBean.getPlazoID()));
									sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(solicitudCreditoBean.getTasaActiva()));
									sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(solicitudCreditoBean.getFechaInicio()));

									sentenciaStore.setString("Par_AjustaFecAmo",solicitudCreditoBean.getAjFecUlAmoVen());
									sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(solicitudCreditoBean.getMontoComApert()));
									sentenciaStore.setString("Par_ForCobComAp",solicitudCreditoBean.getForCobroComAper());
									sentenciaStore.setDouble("Par_ComAnualLin", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","solicitudCreditoDAO");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									SimuladorCuotaCreditoResponse mensaje = new SimuladorCuotaCreditoResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensaje.setMontoCuota(resultadosStore.getString(1));
										mensaje.setNumeroCuotas(resultadosStore.getString(2));
										mensaje.setTotalPagar(resultadosStore.getString(3));
										mensaje.setCat(resultadosStore.getString(4));
										mensaje.setCodigoRespuesta(resultadosStore.getString(5));
										mensaje.setMensajeRespuesta(resultadosStore.getString(6));

									}else{
										mensaje.setCodigoRespuesta("99");
										mensaje.setMontoCuota(Constantes.STRING_CERO);
										mensaje.setNumeroCuotas(Constantes.STRING_CERO);
										mensaje.setTotalPagar(Constantes.STRING_CERO);
										mensaje.setCat(Constantes.STRING_CERO);
										mensaje.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensaje;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new SimuladorCuotaCreditoResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
							mensajeBean.setCodigoRespuesta("99");
							mensajeBean.setMontoCuota(Constantes.STRING_CERO);
							mensajeBean.setNumeroCuotas(Constantes.STRING_CERO);
							mensajeBean.setTotalPagar(Constantes.STRING_CERO);
							mensajeBean.setCat(Constantes.STRING_CERO);
							throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if (Integer.parseInt(mensajeBean.getCodigoRespuesta()) == 0) {
							mensajeBean.setCodigoRespuesta("99");
							mensajeBean.setMontoCuota(Constantes.STRING_CERO);
							mensajeBean.setNumeroCuotas(Constantes.STRING_CERO);
							mensajeBean.setTotalPagar(Constantes.STRING_CERO);
							mensajeBean.setCat(Constantes.STRING_CERO);

						}
						mensajeBean.setMensajeRespuesta(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		//Consulta los status de las solicitudes
		public SolicitudCreditoBean consultaStatus(SolicitudCreditoBean solicitudCreditoBean, int tipoConsulta) {
			//Query con el Store Procedure
			SolicitudCreditoBean solicitudCreditoBeanCon = null;
			String query = "call SOLICITUDCREDITOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteLong(solicitudCreditoBean.getSolicitudCreditoID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CambioTasaDAO.consultaStatus",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) +")");

			try{
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						SolicitudCreditoBean solicitudCreditoBean = new SolicitudCreditoBean();

						solicitudCreditoBean.setClienteID(resultSet.getString("ClienteID"));
						solicitudCreditoBean.setNombreCompletoCliente(resultSet.getString("CliNombreCompleto"));
						solicitudCreditoBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
						solicitudCreditoBean.setDescripcionProducto(resultSet.getString("Descripcion"));
						solicitudCreditoBean.setCobraMora(resultSet.getString("CobraMora"));
						solicitudCreditoBean.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
						solicitudCreditoBean.setCalcInteresID(resultSet.getString("CalcInteres"));
						solicitudCreditoBean.setFechaInicio(resultSet.getString("FechaInicio"));
						solicitudCreditoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						solicitudCreditoBean.setPlazoID(resultSet.getString("PlazoID"));
						solicitudCreditoBean.setDesPlazo(resultSet.getString("DesPlazo"));
						solicitudCreditoBean.setTasaFija(resultSet.getString("TasaFija"));
						solicitudCreditoBean.setFactorMora(resultSet.getString("FactorMora"));
						solicitudCreditoBean.setCicloActual(resultSet.getString("CicloActual"));
						solicitudCreditoBean.setMontoPorComAper(resultSet.getString("MontoPorComAper"));
						solicitudCreditoBean.setTipoComXapert(resultSet.getString("TipoComXapert"));
						solicitudCreditoBean.setTasaBase(resultSet.getString("TasaBase"));
						solicitudCreditoBean.setSobreTasa(resultSet.getString("SobreTasa"));
						solicitudCreditoBean.setPisoTasa(resultSet.getString("PisoTasa"));
						solicitudCreditoBean.setTechoTasa(resultSet.getString("TechoTasa"));
						return solicitudCreditoBean;
					}
				});

				solicitudCreditoBeanCon = matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;


			}catch (Exception e) {
				e.getMessage();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por Por SolicitudCreditoID", e);
			}


			return solicitudCreditoBeanCon;

		}

		// Actualiza las Tasa de Creditos
		public MensajeTransaccionBean actualizaTasa(final SolicitudCreditoBean solicitudCreditoBean, final int tipoActualizacion) {
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
									String query = "call SOLICITUDCREDITOACT(?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCreditoBean.getSolicitudCreditoID()));
									sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(solicitudCreditoBean.getMontoFondeado()));
									sentenciaStore.setDouble("Par_PorceFondeo",Utileria.convierteDoble(solicitudCreditoBean.getPorcentajeFonde()));
									sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(solicitudCreditoBean.getTasaFija()));
									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCreditoBean.getFactorMora()));

									sentenciaStore.setDouble("Par_MontoPorComAper",Utileria.convierteDoble(solicitudCreditoBean.getMontoPorComAper()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCreditoBean.getClienteID()));
									sentenciaStore.setLong("Par_ProspectoID",Utileria.convierteLong(solicitudCreditoBean.getProspectoID()));
									sentenciaStore.setString("Par_CuentaCLABE",solicitudCreditoBean.getCuentaCLABE());

									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(solicitudCreditoBean.getSobreTasa()));
									sentenciaStore.setString("Par_FolioConSIC",solicitudCreditoBean.getFolioConsultaBC());
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCreditoBean.getConvenioNominaID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Actualización de Tasas de Credito", e);
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

		// Actualiza Solicitud de Credito
		public MensajeTransaccionBean actualizaSolicitud(final SolicitudCreditoBean solicitudCreditoBean, final int tipoActualizacion) {
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
									String query = "call SOLICITUDCREDITOACT(?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteLong(solicitudCreditoBean.getSolicitudCreditoID()));
									sentenciaStore.setDouble("Par_MontoFondeo", Constantes.DOUBLE_VACIO);
									sentenciaStore.setDouble("Par_PorceFondeo",Constantes.DOUBLE_VACIO);
									sentenciaStore.setDouble("Par_Tasa",Constantes.DOUBLE_VACIO);
									sentenciaStore.setDouble("Par_FactorMora",Constantes.DOUBLE_VACIO);

									sentenciaStore.setDouble("Par_MontoPorComAper",Constantes.DOUBLE_VACIO);
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
									sentenciaStore.setInt("Par_ClienteID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_ProspectoID",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_CuentaCLABE",Constantes.STRING_VACIO);

									sentenciaStore.setDouble("Par_SobreTasa",Constantes.DOUBLE_VACIO);
									sentenciaStore.setString("Par_FolioConSIC", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCreditoBean.getConvenioNominaID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Actualización de Tasas de Credito", e);
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

		/* Alta de Comentario de la Solicitud de Crédito */
		public MensajeTransaccionBean altaComentario(final ComentariosMonitorBean comentarios) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure

						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call COMENTARIOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";


									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(comentarios.getSolicitudCreditoID()));
									sentenciaStore.setString("Par_Estatus", comentarios.getEstatus());
									sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(comentarios.getFecha()));
									sentenciaStore.setString("Par_Comentario",comentarios.getComentario());
									sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());

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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Solicitud de Credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	/**
	 * Alta de Solicitud de Crédito Agropecuario, no se genera el número de transaccion en este método ya que se realiza en uno anterior
	 * @param solicitudCredito
	 * @return
	 */
	public MensajeTransaccionBean altaSolicitudAgro(final SolicitudCreditoBean solicitudCredito, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDCREDITOALT(" + "?,?,?,?,?,    " +	"?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,		" +
																		"?,?,?,?,?,		" + "?,?,?,?,?," +
																		"?,?,?,?,?,		" + "?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ProspectoID", Utileria.convierteLong(solicitudCredito.getProspectoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(solicitudCredito.getClienteID()));
							sentenciaStore.setInt("Par_ProduCredID", Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
							sentenciaStore.setString("Par_FechaReg", Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
							sentenciaStore.setInt("Par_Promotor", Utileria.convierteEntero(solicitudCredito.getPromotorID()));

							sentenciaStore.setString("Par_TipoCredito", solicitudCredito.getTipoCredito());
							sentenciaStore.setInt("Par_NumCreditos", Utileria.convierteEntero(solicitudCredito.getNumCreditos()));
							sentenciaStore.setLong("Par_Relacionado", Utileria.convierteLong(solicitudCredito.getRelacionado()));
							sentenciaStore.setDouble("Par_AporCliente", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
							sentenciaStore.setInt("Par_Moneda", Utileria.convierteEntero(solicitudCredito.getMonedaID()));

							sentenciaStore.setInt("Par_DestinoCre", Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
							sentenciaStore.setString("Par_Proyecto", solicitudCredito.getProyecto());
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(solicitudCredito.getSucursalID()));
							sentenciaStore.setDouble("Par_MontoSolic", Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
							sentenciaStore.setString("Par_PlazoID", solicitudCredito.getPlazoID());

							sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(solicitudCredito.getFactorMora()));
							sentenciaStore.setDouble("Par_ComApertura", Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
							sentenciaStore.setDouble("Par_IVAComAper", Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
							sentenciaStore.setString("Par_TipoDisper", solicitudCredito.getTipoDispersion());
							sentenciaStore.setInt("Par_CalcInteres", Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));

							sentenciaStore.setInt("Par_TasaBase", Utileria.convierteEntero(solicitudCredito.getTasaBase()));
							sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(solicitudCredito.getTasaFija()));
							sentenciaStore.setDouble("Par_SobreTasa", Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
							sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
							sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(solicitudCredito.getTechoTasa()));

							sentenciaStore.setString("Par_FechInhabil", solicitudCredito.getFechInhabil());
							sentenciaStore.setString("Par_AjuFecExiVe", solicitudCredito.getAjusFecExiVen());
							sentenciaStore.setString("Par_CalIrreg", solicitudCredito.getCalendIrregular());
							sentenciaStore.setString("Par_AjFUlVenAm", solicitudCredito.getAjFecUlAmoVen());
							sentenciaStore.setString("Par_TipoPagCap", solicitudCredito.getTipoPagoCapital());

							sentenciaStore.setString("Par_FrecInter", solicitudCredito.getFrecuenciaInt());
							sentenciaStore.setString("Par_FrecCapital", solicitudCredito.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodInt", Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
							sentenciaStore.setInt("Par_PeriodCap", Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
							sentenciaStore.setString("Par_DiaPagInt", solicitudCredito.getDiaPagoInteres());

							sentenciaStore.setString("Par_DiaPagCap", solicitudCredito.getDiaPagoCapital());
							sentenciaStore.setInt("Par_DiaMesInter", Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap", Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
							sentenciaStore.setInt("Par_NumAmorti", Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
							sentenciaStore.setInt("Par_NumTransacSim", Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));

							sentenciaStore.setDouble("Par_CAT", Utileria.convierteDoble(solicitudCredito.getCAT()));
							sentenciaStore.setString("Par_CuentaClabe", solicitudCredito.getCuentaCLABE());
							sentenciaStore.setInt("Par_TipoCalInt", Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));
							sentenciaStore.setString("Par_TipoFondeo", solicitudCredito.getTipoFondeo());
							sentenciaStore.setInt("Par_InstitFondeoID", Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));

							sentenciaStore.setInt("Par_LineaFondeo", Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
							sentenciaStore.setInt("Par_NumAmortInt", Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota", Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(solicitudCredito.getGrupoID()));
							sentenciaStore.setInt("Par_TipoIntegr", Utileria.convierteEntero(solicitudCredito.getTipoIntegrante()));

							sentenciaStore.setString("Par_FechaVencim", Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
							sentenciaStore.setString("Par_FechaInicio", Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
							sentenciaStore.setDouble("Par_MontoSeguroVida", Utileria.convierteDoble(solicitudCredito.getMontoSeguroVida()));
							sentenciaStore.setString("Par_ForCobroSegVida", solicitudCredito.getForCobroSegVida());
							sentenciaStore.setString("Par_ClasiDestinCred", solicitudCredito.getClasifiDestinCred());

							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));
							sentenciaStore.setString("Par_FolioCtrl", solicitudCredito.getFolioCtrl());
							sentenciaStore.setString("Par_HorarioVeri", solicitudCredito.getHorarioVeri());
							sentenciaStore.setDouble("Par_PorcGarLiq", Utileria.convierteDoble(solicitudCredito.getPorcGarLiq()));
							sentenciaStore.setString("Par_FechaInicioAmor", Utileria.convierteFecha(solicitudCredito.getFechaInicioAmor()));
							sentenciaStore.setDouble("Par_DescuentoSeguro", Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));
							sentenciaStore.setDouble("Par_MontoSegOriginal", Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));
							sentenciaStore.setString("Par_TipoLiquidacion", solicitudCredito.getTipoLiquidacion());
							sentenciaStore.setDouble("Par_CantidadPagar", Utileria.convierteDoble(solicitudCredito.getCantidadPagar()));

							// consultaSIC
							sentenciaStore.setString("Par_TipoConsultaSIC", solicitudCredito.getTipoConsultaSIC());
							sentenciaStore.setString("Par_FolioConsultaBC", solicitudCredito.getFolioConsultaBC());
							sentenciaStore.setString("Par_FolioConsultaCC", solicitudCredito.getFolioConsultaCC());

							// Cobro de comision por apertura
							sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(Constantes.FECHA_VACIA));
							/* CREDITOS AUTOMATICOS */
							sentenciaStore.setInt("Par_InvCredAut", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Par_CtaCredAut",Constantes.ENTERO_CERO);
							// Seguro de Vida CONSOL(No aplica para Cartera Agro)
							sentenciaStore.setDouble("Par_Cobertura",Constantes.DOUBLE_VACIO);
							sentenciaStore.setDouble("Par_Prima",Constantes.DOUBLE_VACIO);
							sentenciaStore.setInt("Par_Vigencia",Constantes.ENTERO_CERO);

							//Convenio
							sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCredito.getConvenioNominaID()));
							sentenciaStore.setString("Par_FolioSolici",solicitudCredito.getFolioSolici());
							sentenciaStore.setInt("Par_QuinquenioID",Utileria.convierteEntero(solicitudCredito.getQuinquenioID()));
							//Domiciliacion
							sentenciaStore.setString("Par_ClabeDomiciliacion",solicitudCredito.getClabeDomiciliacion());
							sentenciaStore.setString("Par_TipoCtaSantander",solicitudCredito.getTipoCtaSantander());
							sentenciaStore.setString("Par_CtaSantander", solicitudCredito.getCtaSantander());
							sentenciaStore.setString("Par_CtaClabeDisp", solicitudCredito.getCtaClabeDisp());

							sentenciaStore.setInt("Par_DeudorOriginalID", Utileria.convierteEntero(solicitudCredito.getDeudorOriginalID()));
							sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(solicitudCredito.getLineaCreditoID()));
							sentenciaStore.setString("Par_ManejaComAdmon", solicitudCredito.getManejaComAdmon());
							sentenciaStore.setString("Par_ComAdmonLinPrevLiq", solicitudCredito.getComAdmonLinPrevLiq());
							sentenciaStore.setString("Par_ForPagComAdmon", solicitudCredito.getForPagComAdmon());

							sentenciaStore.setDouble("Par_MontoPagComAdmon", Utileria.convierteDoble(solicitudCredito.getMontoPagComAdmon()));
							sentenciaStore.setString("Par_ManejaComGarantia", solicitudCredito.getManejaComGarantia());
							sentenciaStore.setString("Par_ComGarLinPrevLiq", solicitudCredito.getComGarLinPrevLiq());
							sentenciaStore.setString("Par_ForPagComGarantia", solicitudCredito.getForPagComGarantia());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "SolicitudCreditoDAO.altaSolicitudAgro");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de solicitud de credito Agropecuario", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método llamado desde la pantalla de Solicitud Credito Agro del Modulo de Creditos Agro
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Bean con la informacion de la Solicitud
	 * @param numTransaccion : Número de Transacccion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean modificacionSolCreditoAgro(final SolicitudCreditoBean solicitudCredito, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDCREDITOMOD(" +"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,		" + "?,?,?,?,?,		" +
																		"?,?,?,?,?,		" + "?,?,?,?,?,		" +
																		"?,?,?,?,?,		" + "?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_Solicitud", Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
							sentenciaStore.setLong("Par_ProspectoID", Utileria.convierteLong(solicitudCredito.getProspectoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(solicitudCredito.getClienteID()));
							sentenciaStore.setString("Par_FechaReg", Utileria.convierteFecha(solicitudCredito.getFechaRegistro()));
							sentenciaStore.setInt("Par_ProduCredID", Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
							sentenciaStore.setInt("Par_Promotor", Utileria.convierteEntero(solicitudCredito.getPromotorID()));
							sentenciaStore.setString("Par_TipoCredito", solicitudCredito.getTipoCredito());
							sentenciaStore.setInt("Par_NumCreditos", Utileria.convierteEntero(solicitudCredito.getNumCreditos()));
							sentenciaStore.setLong("Par_Relacionado", Utileria.convierteLong(solicitudCredito.getRelacionado()));
							sentenciaStore.setDouble("Par_AporCliente", Utileria.convierteDoble(solicitudCredito.getAporteCliente()));
							sentenciaStore.setInt("Par_Moneda", Utileria.convierteEntero(solicitudCredito.getMonedaID()));

							sentenciaStore.setInt("Par_DestinoCre", Utileria.convierteEntero(solicitudCredito.getDestinoCreID()));
							sentenciaStore.setString("Par_Proyecto", solicitudCredito.getProyecto());
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(solicitudCredito.getSucursalID()));
							sentenciaStore.setDouble("Par_MontoSolic", Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
							sentenciaStore.setString("Par_PlazoID", solicitudCredito.getPlazoID());
							sentenciaStore.setDouble("Par_FactorMora", Utileria.convierteDoble(solicitudCredito.getFactorMora()));
							sentenciaStore.setDouble("Par_ComApertura", Utileria.convierteDoble(solicitudCredito.getMontoComApert()));
							sentenciaStore.setDouble("Par_IVAComAper", Utileria.convierteDoble(solicitudCredito.getIvaComApert()));
							sentenciaStore.setString("Par_TipoDisper", solicitudCredito.getTipoDispersion());
							sentenciaStore.setInt("Par_CalcInteres", Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));

							sentenciaStore.setInt("Par_TasaBase", Utileria.convierteEntero(solicitudCredito.getTasaBase()));
							sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(solicitudCredito.getTasaFija()));
							sentenciaStore.setDouble("Par_SobreTasa", Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
							sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
							sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(solicitudCredito.getTechoTasa()));
							sentenciaStore.setString("Par_FechInhabil", solicitudCredito.getFechInhabil());
							sentenciaStore.setString("Par_AjuFecExiVe", solicitudCredito.getAjusFecExiVen());
							sentenciaStore.setString("Par_CalIrreg", solicitudCredito.getCalendIrregular());
							sentenciaStore.setString("Par_AjFUlVenAm", solicitudCredito.getAjFecUlAmoVen());
							sentenciaStore.setString("Par_TipoPagCap", solicitudCredito.getTipoPagoCapital());

							sentenciaStore.setString("Par_FrecInter", solicitudCredito.getFrecuenciaInt());
							sentenciaStore.setString("Par_FrecCapital", solicitudCredito.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodInt", Utileria.convierteEntero(solicitudCredito.getPeriodicidadInt()));
							sentenciaStore.setInt("Par_PeriodCap", Utileria.convierteEntero(solicitudCredito.getPeriodicidadCap()));
							sentenciaStore.setString("Par_DiaPagInt", solicitudCredito.getDiaPagoInteres());
							sentenciaStore.setString("Par_DiaPagCap", solicitudCredito.getDiaPagoCapital());
							sentenciaStore.setInt("Par_DiaMesInter", Utileria.convierteEntero(solicitudCredito.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap", Utileria.convierteEntero(solicitudCredito.getDiaMesCapital()));
							sentenciaStore.setInt("Par_NumAmorti", Utileria.convierteEntero(solicitudCredito.getNumAmortizacion()));
							sentenciaStore.setInt("Par_NumTransacSim", Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));

							sentenciaStore.setDouble("Par_CAT", Utileria.convierteDoble(solicitudCredito.getCAT()));
							sentenciaStore.setString("Par_CuentaClabe", solicitudCredito.getCuentaCLABE());
							sentenciaStore.setInt("Par_TipoCalInt", Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));
							sentenciaStore.setString("Par_TipoFondeo", solicitudCredito.getTipoFondeo());
							sentenciaStore.setInt("Par_InstitFondeoID", Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));
							sentenciaStore.setInt("Par_LineaFondeo", Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
							sentenciaStore.setInt("Par_NumAmortInt", Utileria.convierteEntero(solicitudCredito.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota", Utileria.convierteDoble(solicitudCredito.getMontoCuota()));
							sentenciaStore.setString("Par_FechaVencim", Utileria.convierteFecha(solicitudCredito.getFechaVencimiento()));
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(solicitudCredito.getGrupoID()));

							sentenciaStore.setDouble("Par_TipoIntegr", Utileria.convierteEntero(solicitudCredito.getTipoIntegrante()));
							sentenciaStore.setString("Par_FechaInicio", Utileria.convierteFecha(solicitudCredito.getFechaInicio()));
							sentenciaStore.setDouble("Par_MontoSeguroVida", Utileria.convierteDoble(solicitudCredito.getMontoSeguroVida()));
							sentenciaStore.setString("Par_ForCobroSegVida", solicitudCredito.getForCobroSegVida());
							sentenciaStore.setString("Par_ClasiDestinCred", solicitudCredito.getClasifiDestinCred());
							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(solicitudCredito.getInstitucionNominaID()));

							sentenciaStore.setString("Par_FolioCtrl", solicitudCredito.getFolioCtrl());
							sentenciaStore.setString("Par_HorarioVeri", solicitudCredito.getHorarioVeri());
							sentenciaStore.setDouble("Par_PorcGarLiq", Utileria.convierteDoble(solicitudCredito.getPorcGarLiq()));
							sentenciaStore.setString("Par_FechaInicioAmor", Utileria.convierteFecha(solicitudCredito.getFechaInicioAmor()));
							sentenciaStore.setDouble("Par_DescuentoSeguro", Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));

							sentenciaStore.setDouble("Par_MontoSegOriginal", Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));
							sentenciaStore.setString("Par_Comentario", solicitudCredito.getComentario());

							sentenciaStore.setString("Par_TipoConsultaSIC", solicitudCredito.getTipoConsultaSIC());
							sentenciaStore.setString("Par_FolioConsultaBC", solicitudCredito.getFolioConsultaBC());
							sentenciaStore.setString("Par_FolioConsultaCC", solicitudCredito.getFolioConsultaCC());

							// Cobro de comision por apertura
							sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(Constantes.FECHA_VACIA));

							/* CREDITOS AUTOMATICOS */
							sentenciaStore.setInt("Par_InvCredAut",Utileria.convierteEntero(solicitudCredito.getInversionID()));
							sentenciaStore.setLong("Par_CtaCredAut",Utileria.convierteLong(solicitudCredito.getCuentaAhoID()));
							// Seguro de Vida CONSOL(No aplica para Cartera Agro)
							sentenciaStore.setString("Par_Cobertura",solicitudCredito.getCobertura());
							sentenciaStore.setString("Par_Prima",solicitudCredito.getPrima());
							sentenciaStore.setInt("Par_Vigencia", Utileria.convierteEntero(solicitudCredito.getVigencia()));

							//Convenio
							sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(solicitudCredito.getConvenioNominaID()));
							sentenciaStore.setString("Par_FolioSolici",solicitudCredito.getFolioSolici());
							sentenciaStore.setInt("Par_QuinquenioID",Utileria.convierteEntero(solicitudCredito.getQuinquenioID()));
							//Domiciliacion
							sentenciaStore.setString("Par_ClabeDomiciliacion",solicitudCredito.getClabeDomiciliacion());

							sentenciaStore.setString("Par_TipoCtaSantander",solicitudCredito.getTipoCtaSantander());
							sentenciaStore.setString("Par_CtaSantander", solicitudCredito.getCtaSantander());
							sentenciaStore.setString("Par_CtaClabeDisp", solicitudCredito.getCtaClabeDisp());

							sentenciaStore.setInt("Par_DeudorOriginalID", Utileria.convierteEntero(solicitudCredito.getDeudorOriginalID()));
							sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(solicitudCredito.getLineaCreditoID()));
							sentenciaStore.setString("Par_ManejaComAdmon", solicitudCredito.getManejaComAdmon());
							sentenciaStore.setString("Par_ComAdmonLinPrevLiq", solicitudCredito.getComAdmonLinPrevLiq());
							sentenciaStore.setString("Par_ForPagComAdmon", solicitudCredito.getForPagComAdmon());

							sentenciaStore.setDouble("Par_MontoPagComAdmon", Utileria.convierteDoble(solicitudCredito.getMontoPagComAdmon()));
							sentenciaStore.setString("Par_ManejaComGarantia", solicitudCredito.getManejaComGarantia());
							sentenciaStore.setString("Par_ComGarLinPrevLiq", solicitudCredito.getComGarLinPrevLiq());
							sentenciaStore.setString("Par_ForPagComGarantia", solicitudCredito.getForPagComGarantia());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "modificacionSolCreditoAgro");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de solicitud de credito Agro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para dar de Alta los Créditos Agropecuarios
	 * @param solicitudCredito : Bean con la información de los creditos Agropecuarios
	 * @param tipoActualizacion : Tipo de Actualizacion
	 * @return
	 */
	public MensajeTransaccionBean altaSolicitudCredAgro(final SolicitudCreditoBean solicitudCredito, int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		transaccionDAO.generaNumeroTransaccion();
		final long numTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = null;
					try {
						mensajeBean = altaSolicitudAgro(solicitudCredito, numTransaccion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						solicitudCredito.setSolicitudCreditoID(mensajeBean.getConsecutivoString());

						MensajeTransaccionBean mensajeSol = null;
						ComentariosMonitorBean comentarios = new ComentariosMonitorBean();
						comentarios.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
						comentarios.setEstatus("SI");
						comentarios.setComentario(solicitudCredito.getComentario());
						comentarios.setFecha(solicitudCredito.getFechaAutoriza());
						mensajeSol = altaComentario(comentarios);
						if( mensajeSol.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensajeSol.getDescripcion());
						}

						MensajeTransaccionBean mensajeActualiza = actualizaSolCreditoAgro(solicitudCredito,Enum_Act_SolAgro.principal,numTransaccion);
						if(mensajeActualiza.getNumero()!=0){
							throw new Exception(mensajeActualiza.getDescripcion());
						}

						/*Alta de Ministraciones*/
						MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
						ministracionCredAgroBean.setClienteID(solicitudCredito.getClienteID());
						ministracionCredAgroBean.setProspectoID(solicitudCredito.getProspectoID());
						ministracionCredAgroBean.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
						ministracionCredAgroBean.setCreditoID(solicitudCredito.getCreditoID());
						MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCredito.getDetalleMinistraAgro(), Utileria.convierteLong(solicitudCredito.getNumTransacSim()));
						if (mensajeMinistra.getNumero() != 0) {
							throw new Exception(mensajeMinistra.getDescripcion());
						}

						return mensajeBean;
					} catch (Exception ex) {
						ex.printStackTrace();
						transaction.setRollbackOnly();
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
						}
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}

						mensajeBean.setDescripcion(ex.getMessage());
						mensajeBean.setCampoGenerico("agrega");
						mensajeBean.setConsecutivoString("");
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al dar de Alta la Solicitud de Credito Agropecuario."+ex.getMessage());
		}
		return mensaje;
	}

	/**
	 * Modificacion de Solicitud de Créditos Agropecuarios
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Bean con la informacion del Crédito
	 * @param tipoActualizacion : Numero de Actualizacion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean modificacionCredAgro(final SolicitudCreditoBean solicitudCredito, int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		transaccionDAO.generaNumeroTransaccion();
		final long numTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = null;
					try {
						mensajeBean = modificacionSolCreditoAgro(solicitudCredito, numTransaccion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						solicitudCredito.setSolicitudCreditoID(mensajeBean.getConsecutivoString());

						MensajeTransaccionBean mensajeSol = null;
						ComentariosMonitorBean comentarios = new ComentariosMonitorBean();
						comentarios.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
						comentarios.setEstatus("SI");
						comentarios.setComentario(solicitudCredito.getComentario());
						comentarios.setFecha(solicitudCredito.getFechaAutoriza());
						mensajeSol = altaComentario(comentarios);
						if( mensajeSol.getNumero() != Constantes.ENTERO_CERO){
							throw new Exception(mensajeSol.getDescripcion());
						}

						MensajeTransaccionBean mensajeActualiza = actualizaSolCreditoAgro(solicitudCredito,Enum_Act_SolAgro.principal, numTransaccion);
						if(mensajeActualiza.getNumero()!=0){
							throw new Exception(mensajeActualiza.getDescripcion());
						}

						/*Alta de Ministraciones*/
						MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
						ministracionCredAgroBean.setClienteID(solicitudCredito.getClienteID());
						ministracionCredAgroBean.setProspectoID(solicitudCredito.getProspectoID());
						ministracionCredAgroBean.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
						ministracionCredAgroBean.setCreditoID(solicitudCredito.getCreditoID());
						long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
						MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCredito.getDetalleMinistraAgro(), Utileria.convierteLong(solicitudCredito.getNumTransacSim()));
						if (mensajeMinistra.getNumero() != 0) {
							throw new Exception(mensajeMinistra.getDescripcion());
						}

					} catch (Exception ex) {
						ex.printStackTrace();
						transaction.setRollbackOnly();
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
						}
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(ex.getMessage());
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al dar de Alta la Solicitud de Credito Agropecuario."+ex.getMessage());
			}
		}
		return mensaje;
	}

	/**
	 * Método para Actualizar los campos de las Solicitudes de Créditos Agropecuarios
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Bean con la Informacion de la Solicitud
	 * @param numAct : Numero de Actualizacion
	 * @param numTransaccion : {@link Long} Número de Transacción
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean actualizaSolCreditoAgro(final SolicitudCreditoBean solicitudCredito, final int numAct, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SOLICITUDCREDITOAGROACT("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"

										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"

										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"

										+ "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NumAct", numAct);
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_CadenaProductivaID", Utileria.convierteEntero(solicitudCredito.getCadenaProductivaID()));
								sentenciaStore.setInt("Par_RamaFIRAID", Utileria.convierteEntero(solicitudCredito.getRamaFIRAID()));
								sentenciaStore.setInt("Par_SubramaFIRAID", Utileria.convierteEntero(solicitudCredito.getSubramaFIRAID()));

								sentenciaStore.setInt("Par_ActividadFIRAID", Utileria.convierteEntero(solicitudCredito.getActividadFIRAID()));
								sentenciaStore.setInt("Par_TipoGarantiaFIRAID", Utileria.convierteEntero(solicitudCredito.getTipoGarantiaFIRAID()));
								sentenciaStore.setString("Par_ProgEspecialFIRAID", solicitudCredito.getProgEspecialFIRAID());
								sentenciaStore.setInt("Par_CalcInteres", Utileria.convierteEntero(solicitudCredito.getCalcInteresID()));
								sentenciaStore.setInt("Par_TasaBase", Utileria.convierteEntero(solicitudCredito.getTasaBase()));

								sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(solicitudCredito.getTasaFija()));
								sentenciaStore.setDouble("Par_SobreTasa", Utileria.convierteDoble(solicitudCredito.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa", Utileria.convierteDoble(solicitudCredito.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa", Utileria.convierteDoble(solicitudCredito.getTechoTasa()));
								sentenciaStore.setInt("Par_TipoCalInt", Utileria.convierteEntero(solicitudCredito.getTipoCalInteres()));

								sentenciaStore.setString("Par_TipoFondeo", solicitudCredito.getTipoFondeo());
								sentenciaStore.setInt("Par_InstitFondeoID", Utileria.convierteEntero(solicitudCredito.getInstitutFondID()));
								sentenciaStore.setInt("Par_NumTransacSim", Utileria.convierteEntero(solicitudCredito.getNumTransacSim()));
								sentenciaStore.setInt("Par_LineaFondeo", Utileria.convierteEntero(solicitudCredito.getLineaFondeoID()));
								sentenciaStore.setDouble("Par_TasaPasiva", Utileria.convierteDoble(solicitudCredito.getTasaPasiva()));

								sentenciaStore.setLong("Par_AcreditadoIDFIRA", Utileria.convierteLong(solicitudCredito.getAcreditadoIDFIRA()));
								sentenciaStore.setLong("Par_CreditoIDFIRA", Utileria.convierteLong(solicitudCredito.getCreditoIDFIRA()));
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								try {
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
								} catch (Exception ex) {
									ex.printStackTrace();
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(ex.getMessage());
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Actualizacion Solicitud Agropecuaria.", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Actualizar la Solicitud Agropecuaria: " + ex.getMessage());
		}
		return mensaje;
	}

	// Lista solicitudes en Guarda valores
	public List listaGuardaValores(SolicitudCreditoBean solicitudCredito, int tipoLista){

		List<SolicitudCreditoBean> listaSolicitudCredito = null;
		//Query con el Store Procedure
		try{
			String query = "CALL SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				solicitudCredito.getClienteID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCredito.setClienteID(resultSet.getString("NombreCompleto"));
					solicitudCredito.setTipoCredito(resultSet.getString("TipoSolicitud"));
					solicitudCredito.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					solicitudCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return solicitudCredito;
				}
			});

			listaSolicitudCredito = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de ayuda de Solicitud de Credido para Guarda Valores", exception);
			listaSolicitudCredito = null;
		}

		return listaSolicitudCredito;
	}

	/*********************************************************************************************************************/
	/****************** METODO PARA EL LISTADO DE LAS SOLICITUDES POR CONVENIO DE NOMINA ********************************/
	public List listaSolCredInstConv(SolicitudCreditoBean solicitudCredito, int tipoLista){

		List<SolicitudCreditoBean> listaSolicitudCredito = null;
		//Query con el Store Procedure
		try{
			String query = "CALL SOLICITUDCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				solicitudCredito.getClienteID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCredito.setClienteID(resultSet.getString("NombreCompleto"));
					solicitudCredito.setEstatus(resultSet.getString("Estatus"));
					solicitudCredito.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					solicitudCredito.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return solicitudCredito;
				}
			});

			listaSolicitudCredito = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de ayuda de Solicitud de Credido para las solicitudes por convenio de nomina", exception);
			listaSolicitudCredito = null;
		}

		return listaSolicitudCredito;
	}

	/*********************************************************************************************************************/
	/****************** METODO PARA DE CONSULTA DE LAS SOLICITUDES POR CONVENIO DE NOMINA ********************************/

	public SolicitudCreditoBean consultaSolCredInstConv(SolicitudCreditoBean solicitudCreditoBean, int tipoConsulta) {
		//Query con el Store Procedure
		SolicitudCreditoBean solicitudCreditoBeanCon = null;
		String query = "call SOLICITUDCREDITOCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteLong(solicitudCreditoBean.getSolicitudCreditoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CambioTasaDAO.conSolCredInstConv",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDCREDITOCON(" + Arrays.toString(parametros) +")");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean solicitudCreditoBean = new SolicitudCreditoBean();

					solicitudCreditoBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCreditoBean.setProspectoID(resultSet.getString("ProspectoID"));
					solicitudCreditoBean.setClienteID(resultSet.getString("ClienteID"));
					solicitudCreditoBean.setNombreCompletoCliente(resultSet.getString("NombreCompleto"));
					solicitudCreditoBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));

					solicitudCreditoBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					solicitudCreditoBean.setDescripcionConvenio(resultSet.getString("Descripcion"));
					solicitudCreditoBean.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
					solicitudCreditoBean.setNombreInstit(resultSet.getString("NombreInstit"));
					solicitudCreditoBean.setNoEmpleado(resultSet.getString("NoEmpleado"));

					solicitudCreditoBean.setTipoCredito(resultSet.getString("TipoCredito"));
					solicitudCreditoBean.setTipoEmpleado(resultSet.getString("TipoEmpleado"));
					solicitudCreditoBean.setMontoSolici(resultSet.getString("MontoSolici"));
					solicitudCreditoBean.setSucursalID(resultSet.getString("SucursalID"));
					solicitudCreditoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					solicitudCreditoBean.setManejaCapPago(resultSet.getString("ManejaCapPago"));
					solicitudCreditoBean.setEstatus(resultSet.getString("Estatus"));
					solicitudCreditoBean.setResguardo(resultSet.getString("Resguardo"));
					solicitudCreditoBean.setPorcentajeCapacidad(resultSet.getString("PorcentajeCapacidad"));

					return solicitudCreditoBean;
				}
			});

			solicitudCreditoBeanCon = matches.size() > 0 ? (SolicitudCreditoBean) matches.get(0) : null;


		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Solicitud de Credido para las solicitudes por convenio de nomina", e);
		}


		return solicitudCreditoBeanCon;

	}

	/**
	 * Método para Actualizar los campos de FIRA de las Solicitudes de Créditos Agropecuarios cuando se trata de una Reestructura
	 * @param solicitudCredito : {@link SolicitudCreditoBean} Bean con la Informacion de la Solicitud
	 * @param numAct : Numero de Actualizacion
	 * @param numTransaccion : {@link Long} Número de Transacción
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean actualizaDatosFIRA(final SolicitudCreditoBean solicitudCredito, final int numAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SOLICITUDREESTAGROACT("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(solicitudCredito.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(solicitudCredito.getRelacionado()));
								sentenciaStore.setLong("Par_AcreditadoIDFIRA", Utileria.convierteLong(solicitudCredito.getAcreditadoIDFIRA()));
								sentenciaStore.setLong("Par_CreditoIDFIRA", Utileria.convierteLong(solicitudCredito.getCreditoIDFIRA()));
								sentenciaStore.setInt("Par_NumAct", numAct);

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								// Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								return sentenciaStore;
							}
						}, new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								try {
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
								} catch (Exception ex) {
									ex.printStackTrace();
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(ex.getMessage());
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Actualizacion Solicitud Agropecuaria.", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Actualizar la Solicitud Agropecuaria: " + ex.getMessage());
		}
		return mensaje;
	}


	// Proceso de Alta de Consolidación Agro
	public MensajeTransaccionBean procesoAltaConsolidacionAgro(final SolicitudCreditoBean solicitudCreditoBean){
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				ComentariosMonitorBean comentariosMonitorBean = new ComentariosMonitorBean();
				String solicitudCreditoID = "";
				String estatusRegistro = "SI";
				int actualizaReacredita = 13;

				try {

					mensajeTransaccionBean = altaSolicitudAgro(solicitudCreditoBean, numeroTransaccion);
					if( mensajeTransaccionBean.getNumero()!= Constantes.ENTERO_CERO ){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					solicitudCreditoID = mensajeTransaccionBean.getConsecutivoString();
					solicitudCreditoBean.setSolicitudCreditoID(solicitudCreditoID);

					mensajeTransaccionBean = actualizaSolCreditoAgro(solicitudCreditoBean, Enum_Act_SolAgro.principal, numeroTransaccion);
					if(mensajeTransaccionBean.getNumero()!=0){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					/*Alta de Ministraciones*/
					MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
					ministracionCredAgroBean.setClienteID(solicitudCreditoBean.getClienteID());
					ministracionCredAgroBean.setProspectoID(solicitudCreditoBean.getProspectoID());
					ministracionCredAgroBean.setSolicitudCreditoID(solicitudCreditoID);
					ministracionCredAgroBean.setCreditoID(solicitudCreditoBean.getCreditoID());

					mensajeTransaccionBean = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCreditoBean.getDetalleMinistraAgro(), Utileria.convierteLong(solicitudCreditoBean.getNumTransacSim()));
					if (mensajeTransaccionBean.getNumero() != 0) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

				 	// Actualizacion de Creditos consolidados con la Solicitud de Crédito
					ConsolidacionesBean consolidacionesBean = new ConsolidacionesBean();
					consolidacionesBean.setSolicitudCreditoID(solicitudCreditoID);
					consolidacionesBean.setFolioConsolidaID(solicitudCreditoBean.getFolioConsolidaID());
					consolidacionesBean.setTransaccion(solicitudCreditoBean.getNumTransaccion());
					consolidacionesBean.setFechaDesembolso(solicitudCreditoBean.getFechaDesembolso());
					consolidacionesBean.setAltaGarAval(Constantes.salidaSI);

					mensajeTransaccionBean = consolidacionesDAO.procesoSolicitudConsolidacion(consolidacionesBean);
					if(mensajeTransaccionBean.getNumero()!=0){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					comentariosMonitorBean.setSolicitudCreditoID(solicitudCreditoID);
					comentariosMonitorBean.setEstatus(estatusRegistro);
					comentariosMonitorBean.setComentario(solicitudCreditoBean.getComentario());
					comentariosMonitorBean.setFecha(solicitudCreditoBean.getFechaRegistro());
					comentariosMonitorBean.setUsuarioAutoriza(solicitudCreditoBean.getUsuarioAutoriza());

					if( solicitudCreditoBean.getReqSeguroVida() != null &&
						solicitudCreditoBean.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){

						// Llama al Metodo del Alta de Seguro de Vida
						SeguroVidaBean seguroVidaBean = new SeguroVidaBean();

						seguroVidaBean.setClienteID(solicitudCreditoBean.getClienteID());
						seguroVidaBean.setBeneficiario(solicitudCreditoBean.getBeneficiario());
						seguroVidaBean.setDireccionBeneficiario(solicitudCreditoBean.getDireccionBen());
						seguroVidaBean.setRelacionBeneficiario(solicitudCreditoBean.getParentescoID());
						seguroVidaBean.setForCobroSegVida(solicitudCreditoBean.getForCobroSegVida());
						seguroVidaBean.setFechaVencimiento(solicitudCreditoBean.getFechaVencimiento());
						seguroVidaBean.setFechaInicio(solicitudCreditoBean.getFechaInicio());
						seguroVidaBean.setMontoPoliza(solicitudCreditoBean.getMontoPolSegVida());
						seguroVidaBean.setSolicitudCreditoID(solicitudCreditoID);

						mensajeTransaccionBean = seguroVidaDAO.altaSeguroVida(seguroVidaBean);
						if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}

						comentariosMonitorBean.setFecha(solicitudCreditoBean.getFechaAutoriza());
					}

					mensajeTransaccionBean = altaComentario(comentariosMonitorBean);
					if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					if( solicitudCreditoBean.getEsReacreditado() !=null &&
						solicitudCreditoBean.getEsReacreditado().equalsIgnoreCase(Constantes.STRING_SI) ){
						mensajeTransaccionBean = actualizaSolicitud(solicitudCreditoBean, actualizaReacredita);
						if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}

					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion("Solicitud de Crédito Agregada Exitosamente: "+solicitudCreditoID+ ".");
					mensajeTransaccionBean.setNombreControl("solicitudCreditoID");
					mensajeTransaccionBean.setCampoGenerico("solicitudCreditoID");
					mensajeTransaccionBean.setConsecutivoInt(solicitudCreditoID);
					mensajeTransaccionBean.setConsecutivoString(solicitudCreditoID);

				} catch (Exception exception) {

					if( mensajeTransaccionBean == null){
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
					}else
						if( mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO ){
							mensajeTransaccionBean.setNumero(999);
					}

					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de la Solicitud de Crédito de Consolidación ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensajeTransaccion;
	}

	//Proceso de Modificacion de Consolidación Agro
	public MensajeTransaccionBean procesoModificaConsolidacionAgro(final SolicitudCreditoBean solicitudCreditoBean){
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {


				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				ComentariosMonitorBean comentariosMonitorBean = new ComentariosMonitorBean();
				String solicitudCreditoID = solicitudCreditoBean.getSolicitudCreditoID();

				try {

					mensajeTransaccionBean = modificacionSolicitudCredito(solicitudCreditoBean, numeroTransaccion);
					if( mensajeTransaccionBean.getNumero()!= Constantes.ENTERO_CERO ){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					solicitudCreditoBean.setSolicitudCreditoID(solicitudCreditoID);
					mensajeTransaccionBean = actualizaSolCreditoAgro(solicitudCreditoBean, Enum_Act_SolAgro.principal, numeroTransaccion);
					if(mensajeTransaccionBean.getNumero()!=0){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					/*Alta de Ministraciones*/
					MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
					ministracionCredAgroBean.setClienteID(solicitudCreditoBean.getClienteID());
					ministracionCredAgroBean.setProspectoID(solicitudCreditoBean.getProspectoID());
					ministracionCredAgroBean.setSolicitudCreditoID(solicitudCreditoID);
					ministracionCredAgroBean.setCreditoID(solicitudCreditoBean.getCreditoID());

					mensajeTransaccionBean = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCreditoBean.getDetalleMinistraAgro(), Utileria.convierteLong(solicitudCreditoBean.getNumTransacSim()));
					if (mensajeTransaccionBean.getNumero() != 0) {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

				 	// Actualizacion de Creditos consolidados con la Solicitud de Crédito
					ConsolidacionesBean consolidacionesBean = new ConsolidacionesBean();
					consolidacionesBean.setSolicitudCreditoID(solicitudCreditoID);
					consolidacionesBean.setFolioConsolidaID(solicitudCreditoBean.getFolioConsolidaID());
					consolidacionesBean.setTransaccion(solicitudCreditoBean.getNumTransaccion());
					consolidacionesBean.setFechaDesembolso(solicitudCreditoBean.getFechaDesembolso());
					consolidacionesBean.setAltaGarAval(Constantes.salidaNO);

					mensajeTransaccionBean = consolidacionesDAO.procesoSolicitudConsolidacion(consolidacionesBean);
					if(mensajeTransaccionBean.getNumero()!=0){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

					if( solicitudCreditoBean.getReqSeguroVida() != null &&
						solicitudCreditoBean.getReqSeguroVida().equalsIgnoreCase(SeguroVidaBean.Requiere_Seguro_SI)){

						// Llama al Metodo del Alta de Seguro de Vida
						SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
						seguroVidaBean.setSeguroVidaID(solicitudCreditoBean.getSeguroVidaID());
						seguroVidaBean.setClienteID(solicitudCreditoBean.getClienteID());
						seguroVidaBean.setBeneficiario(solicitudCreditoBean.getBeneficiario());
						seguroVidaBean.setDireccionBeneficiario(solicitudCreditoBean.getDireccionBen());
						seguroVidaBean.setRelacionBeneficiario(solicitudCreditoBean.getParentescoID());
						seguroVidaBean.setForCobroSegVida(solicitudCreditoBean.getForCobroSegVida());
						seguroVidaBean.setFechaVencimiento(solicitudCreditoBean.getFechaVencimiento());
						seguroVidaBean.setFechaInicio(solicitudCreditoBean.getFechaInicio());
						seguroVidaBean.setMontoPoliza(solicitudCreditoBean.getMontoPolSegVida());
						seguroVidaBean.setSolicitudCreditoID(solicitudCreditoID);

						mensajeTransaccionBean = seguroVidaDAO.modificaSeguroVida(seguroVidaBean, numeroTransaccion);
						if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
							throw new Exception(mensajeTransaccionBean.getDescripcion());
						}
					}

					mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
					mensajeTransaccionBean.setDescripcion("Solicitud de Crédito Modificada Exitosamente: "+solicitudCreditoID+ ".");
					mensajeTransaccionBean.setNombreControl("solicitudCreditoID");
					mensajeTransaccionBean.setCampoGenerico("solicitudCreditoID");
					mensajeTransaccionBean.setConsecutivoInt(solicitudCreditoID);
					mensajeTransaccionBean.setConsecutivoString(solicitudCreditoID);

				} catch (Exception exception) {
					if(mensajeTransaccionBean.getNumero()==0){
						mensajeTransaccionBean.setNumero(999);
					}
					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Modificación de la Solicitud de Crédito de Consolidación ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensajeTransaccion;
	}

	// Lista Solicitudes consolidadas
	public List<SolicitudCreditoBean> listaSolicitudConsolidada(final SolicitudCreditoBean solicitudCreditoBean, final int tipoLista) {

		List<SolicitudCreditoBean> listaSolicitudCreditoBean = null;
		//Query con el Store Procedure
		try{
			String query = "CALL SOLICITUDCREDITOLIS( ?,?,"
										    		+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				solicitudCreditoBean.getClienteID(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SolicitudCreditoDAO.listaSolicitudConsolidada",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SOLICITUDCREDITOLIS(" + Arrays.toString(parametros) + ")");
			List<SolicitudCreditoBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SolicitudCreditoBean  solicitudCreditoBean = new SolicitudCreditoBean();

					solicitudCreditoBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					solicitudCreditoBean.setClienteID(resultSet.getString("NombreCompleto"));
					solicitudCreditoBean.setEstatus(resultSet.getString("Estatus"));
					solicitudCreditoBean.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
					solicitudCreditoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return solicitudCreditoBean;
				}
			});

			listaSolicitudCreditoBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Solicitud de Crédito Consolidado Agro ", exception);
			listaSolicitudCreditoBean = null;
		}

		return listaSolicitudCreditoBean;
	}

	public List obtenerListaServiciosAdicionales(SolicitudCreditoBean solicitudCredito) {
		List listaServiciosAdicionales = new ArrayList();
			if (!solicitudCredito.getServiciosAdicionales().isEmpty()) {
			String[] cadena = solicitudCredito.getServiciosAdicionales().split(",");
			if (cadena.length > 0) {
				for (int i = 0; i < cadena.length; i++) {
					ServiciosSolCredBean serviciosSolCredBean = new ServiciosSolCredBean();
					serviciosSolCredBean.setServicioID(cadena[i]);
					serviciosSolCredBean.setSolicitudCreditoID(solicitudCredito.getSolicitudCreditoID());
					serviciosSolCredBean.setCreditoID(solicitudCredito.getCreditoID());
					listaServiciosAdicionales.add(serviciosSolCredBean);
				}
			}
		}
		return listaServiciosAdicionales;
	}

	public MensajeTransaccionBean procesoCiclosClienteGrupal(final SolicitudCreditoBean solicitudCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL CICLOSCTEGRUPALPRO(?,?,?,?,"
																			+ "?,?,?," // 3 ->Par_Salida,Par_NumErr,Par_ErrMen
																			+ "?,?,?,?,?,?,?);"; // 7 ->Parametros de Auditoria basicos
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(solicitudCredito.getClienteID()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(solicitudCredito.getProspectoID()));
									sentenciaStore.setInt("Par_CicloBase", Utileria.convierteEntero(solicitudCredito.getCicloActual()));
									sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(solicitudCredito.getGrupoID()));

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
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el registro del ciclo de cliente grupal", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public MinistraCredAgroDAO getMinistraCredAgroDAO() {
		return ministraCredAgroDAO;
	}

	public void setMinistraCredAgroDAO(MinistraCredAgroDAO ministraCredAgroDAO) {
		this.ministraCredAgroDAO = ministraCredAgroDAO;
	}

	public ConsolidacionesDAO getConsolidacionesDAO() {
		return consolidacionesDAO;
	}

	public void setConsolidacionesDAO(ConsolidacionesDAO consolidacionesDAO) {
		this.consolidacionesDAO = consolidacionesDAO;
	}

	public ServiciosSolCredDAO getServiciosSolCredDAO() {
		return serviciosSolCredDAO;
	}

	public void setServiciosSolCredDAO(ServiciosSolCredDAO serviciosSolCredDAO) {
		this.serviciosSolCredDAO = serviciosSolCredDAO;
	}
}