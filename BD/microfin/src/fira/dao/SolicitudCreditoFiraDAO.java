package fira.dao;
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
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.ComentariosMonitorBean;
import fira.bean.SolicitudCreditoFiraBean;
import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolAgro;
import cliente.bean.CicloCreditoBean;
import credito.bean.SeguroVidaBean;
import credito.beanWS.response.SimuladorCuotaCreditoResponse;
import credito.dao.SeguroVidaDAO;

public class SolicitudCreditoFiraDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;
	SeguroVidaDAO seguroVidaDAO = null;
	MinistraCredAgroDAO ministraCredAgroDAO = null;

	public SolicitudCreditoFiraDAO() {
		super();
	}

	public MensajeTransaccionBean altaSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito) {
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
	public MensajeTransaccionBean altaSolicitudConSeguroVida(final SolicitudCreditoFiraBean solicitudCredito) {
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

	public MensajeTransaccionBean modificacionSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito) {
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
	public MensajeTransaccionBean modificacionSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito, final long numTransaccion) {
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
											"?,?,?,?,?,    " +
											"?,?,?,?,?,    " +
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
	public MensajeTransaccionBean modificacionSolicitudConSeguroVida(final SolicitudCreditoFiraBean solicitudCredito) {
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
	public MensajeTransaccionBean actualizaCalendarioSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito) {

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
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));

									sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(solicitudCredito.getProductoCreditoID()));
									sentenciaStore.setDouble("Par_MontoSolicitado",Utileria.convierteDoble(solicitudCredito.getMontoSolici()));
									sentenciaStore.setString("Par_Estatus",solicitudCredito.getEstatus());
									sentenciaStore.setString("Par_ForCobroSegVida",solicitudCredito.getForCobroSegVida());
									sentenciaStore.setDouble("Par_DescuentoSeguro",Utileria.convierteDoble(solicitudCredito.getDescuentoSeguro()));
									sentenciaStore.setDouble("Par_MontoSegOriginal",Utileria.convierteDoble(solicitudCredito.getMontoSegOriginal()));

									sentenciaStore.setInt("Par_NumAct",SolicitudCreditoFiraBean.Act_Calendario);

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


	public MensajeTransaccionBean autorizaSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito, final int tipoActualizacion) {
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
									sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));
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
	public MensajeTransaccionBean rechazarSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito, final int tipoActualizacion) {
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
									sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"erro en rechazo de solicitud de credito", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	// metodo de regreso a ejecutivo de solicitudes de credito
		public MensajeTransaccionBean regresarEjecSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito, final int tipoActualizacion) {
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
										sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en regresar la ejecucion de solicitud de credito", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}


		// metodo de liberacion de solicitudes de credito
		public MensajeTransaccionBean liberarSolicitudCredito(final SolicitudCreditoFiraBean solicitudCredito, final int tipoActualizacion) {
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
										sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));
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

				public MensajeTransaccionBean actComentarioEjecutivo(final SolicitudCreditoFiraBean solicitudCredito, final int tipoActualizacion) {
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
												sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCredito.getSolicitudCreditoID()));
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
				public SolicitudCreditoFiraBean consultaPrincipal(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
					//Query con el Store Procedure
					String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
							SolicitudCreditoFiraBean solicitudCredito = null;
							try{
								solicitudCredito = new SolicitudCreditoFiraBean();
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


							} catch(Exception ex){
								loggerSAFI.info("Error al realizar consulta de Solicitud de Credito:"+ex.getMessage(),ex);
								ex.printStackTrace();
							}
							return solicitudCredito;

						}
					});

					return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
				}

	/**
	 * Consuta Principal Solicitud de Credito Agropecuario
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean}
	 * @param tipoConsulta : Numero de Consulta 9
	 * @return  {@link SolicitudCreditoFiraBean}
	 */
	public SolicitudCreditoFiraBean consultaPrincipalAgro(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = null;
				try {
					solicitudCredito = new SolicitudCreditoFiraBean();
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

				} catch (Exception ex) {
					loggerSAFI.info("Error al realizar consulta de Solicitud de Credito:" + ex.getMessage(), ex);
					ex.printStackTrace();
				}
				return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	/* Consuta Foreanea Solicitud de credito */
	public SolicitudCreditoFiraBean consultaForeanea(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setMontoSolici(resultSet.getString(5));
				solicitudCredito.setMontoAutorizado(String.valueOf(resultSet.getString(6)));
				return solicitudCredito;
			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}


	/* Consuta para ver Solicitudes Asignadas */
	public SolicitudCreditoFiraBean consultaSolicitudAs(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setAsignaSol(String.valueOf(resultSet.getString(5)));



					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}


	/* Consuta para ver solicitudes Activas y de unsa sucursal en especifico */
	public SolicitudCreditoFiraBean consultaSolActYSuc(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setEstatus(resultSet.getString(5));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}


	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoFiraBean consultaSolPorSuc(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt(2)));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt(3)));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt(4)));
				solicitudCredito.setAsignaSol(String.valueOf(resultSet.getString(5)));
				solicitudCredito.setEstatusSol(String.valueOf(resultSet.getString(6)));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoFiraBean consultaSolPorOblSuc(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				solicitudCredito.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				solicitudCredito.setProspectoID(String.valueOf(resultSet.getInt("ProspectoID")));
				solicitudCredito.setAsignaOblSol(String.valueOf(resultSet.getString("Estatus")));
				solicitudCredito.setEstatusSol(String.valueOf(resultSet.getString("EstatusSol")));

					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	/* Consuta para ver Solicitudes por sucursal */
	public SolicitudCreditoFiraBean consultaDetalleGarFOGAFI(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call DETALLEGARLIQUIDACON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setMontoFOGAFI(resultSet.getString("MontoGarFOGAFI"));
				solicitudCredito.setPorcentajeFOGAFI(resultSet.getString("PorcGarFOGAFI"));
				solicitudCredito.setModalidadFOGAFI(resultSet.getString("ModalidadFOGAFI"));


					return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	/* Consulta Dias Primer Amortizacion para Tipo Pago Capital: LIBRES */
	public SolicitudCreditoFiraBean consultaDiasPrimerAmor(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call SOLICITUDCREDITOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	solicitudCredito.getSolicitudCreditoID(),
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setValorParametro(resultSet.getString("Var_ValorReqPrimerAmor"));
				solicitudCredito.setNumDiasVenPrimAmor(String.valueOf(resultSet.getInt("Var_NumDiasVenPrimAmor")));
				solicitudCredito.setDiasReqPrimerAmor(String.valueOf(resultSet.getInt("Var_DiasReqPrimerAmor")));
				solicitudCredito.setFechaActual(resultSet.getString("Var_FechaSistema"));
				solicitudCredito.setFechaVencimiento(resultSet.getString("Var_FecFinPrimerAmor"));

				return solicitudCredito;

			}
		});

		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	// Lista de solicitudes de credito
		public List listaPrincipal(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){

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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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
		public List listaIntegraGrupo(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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
		public List listaIntegraAvales(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();

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
		public List listaSolicitudesInactivas(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();

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
		public List listaSolicitudesAutorizadas(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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
		public List listaSolCheckListGrid(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();

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
		public List listaSolLiberadasPromotor(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();

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
		public List listaSolTratamiento(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();

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

		// Lista de solicitudes de credito que presentan un posible riesgo común
		public List listaSolRiesgoComun(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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

		public MensajeTransaccionBean altaSolicitudCreditoBE(final SolicitudCreditoFiraBean solicitudCredito) {
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

										sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(solicitudCredito.getProspectoID()));
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

	public SolicitudCreditoFiraBean consultaBancaEnLinea(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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
			return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
		}

	/* metodo para procesar los cambios de condiciones grupales*/
	public MensajeTransaccionBean auxActualizaCalendarioSolicitudCredito(final List listaBeanSolCred) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					SolicitudCreditoFiraBean bean;

					if(listaBeanSolCred!=null){
						for(int i=0; i<listaBeanSolCred.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (SolicitudCreditoFiraBean)listaBeanSolCred.get(i);
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

	public SolicitudCreditoFiraBean consultaExisSol(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setSolicitudCreditoID(resultSet.getString("CreditoID"));

				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	public SolicitudCreditoFiraBean consultaClienCre(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));

				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	// Consulta del Empleado para la carga de archivo para la aplicacion de pagos de nomina
	public SolicitudCreditoFiraBean consultaEmpleadoCre(SolicitudCreditoFiraBean solicitudCredito, int tipoConsulta) {
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
				SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
				solicitudCredito.setFolioCtrl(resultSet.getString("FolioCtrl"));


				return solicitudCredito;
			}
		});
		return matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;
	}

	// metodo para obtener el simulador de cuotas de credito en los web service
		public SimuladorCuotaCreditoResponse simuladorCuotaCredito(final SolicitudCreditoFiraBean solicitudCreditoBean) {
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
		public SolicitudCreditoFiraBean consultaStatus(SolicitudCreditoFiraBean solicitudCreditoBean, int tipoConsulta) {
			//Query con el Store Procedure
			SolicitudCreditoFiraBean solicitudCreditoBeanCon = null;
			String query = "call SOLICITUDCREDITOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	solicitudCreditoBean.getSolicitudCreditoID(),
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
						SolicitudCreditoFiraBean solicitudCreditoBean = new SolicitudCreditoFiraBean();

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

				solicitudCreditoBeanCon = matches.size() > 0 ? (SolicitudCreditoFiraBean) matches.get(0) : null;


			}catch (Exception e) {
				e.getMessage();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por Por SolicitudCreditoID", e);
			}


			return solicitudCreditoBeanCon;

		}

		// Actualiza las Tasa de Creditos
		public MensajeTransaccionBean actualizaTasa(final SolicitudCreditoFiraBean solicitudCreditoBean, final int tipoActualizacion) {
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
									String query = "call SOLICITUDCREDITOACT(?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCreditoBean.getSolicitudCreditoID()));
									sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(solicitudCreditoBean.getMontoFondeado()));
									sentenciaStore.setDouble("Par_PorceFondeo",Utileria.convierteDoble(solicitudCreditoBean.getPorcentajeFonde()));
									sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(solicitudCreditoBean.getTasaFija()));
									sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(solicitudCreditoBean.getFactorMora()));

									sentenciaStore.setDouble("Par_MontoPorComAper",Utileria.convierteDoble(solicitudCreditoBean.getMontoPorComAper()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(solicitudCreditoBean.getClienteID()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(solicitudCreditoBean.getProspectoID()));
									sentenciaStore.setString("Par_CuentaCLABE",solicitudCreditoBean.getCuentaCLABE());

									sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(solicitudCreditoBean.getSobreTasa()));
									sentenciaStore.setString("Par_FolioConSIC",solicitudCreditoBean.getFolioConsultaBC());

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
		public MensajeTransaccionBean actualizaSolicitud(final SolicitudCreditoFiraBean solicitudCreditoBean, final int tipoActualizacion) {
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
									String query = "call SOLICITUDCREDITOACT(?,?,?,?,?,		?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(solicitudCreditoBean.getSolicitudCreditoID()));
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
			transaccionDAO.generaNumeroTransaccion();
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
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(comentarios.getSolicitudCreditoID()));
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
	public MensajeTransaccionBean altaSolicitudAgro(final SolicitudCreditoFiraBean solicitudCredito, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDCREDITOALT(" +"?,?,?,?,?,    " +	"?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,     " +
																		"?,?,?,?,?,     " + "?,?,?,?,?,		" +
																		"?,?,?,?,?,		" + "?,?,?,?,?,		" +
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
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean} Bean con la informacion de la Solicitud
	 * @param numTransaccion : Número de Transacccion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean modificacionSolCreditoAgro(final SolicitudCreditoFiraBean solicitudCredito, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SOLICITUDCREDITOMOD(" + "?,?,?,?,?,    " + "?,?,?,?,?,     " +
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
	public MensajeTransaccionBean altaSolicitudCredAgro(final SolicitudCreditoFiraBean solicitudCredito, int tipoActualizacion) {
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
						MensajeTransaccionBean mensajeActualiza = actualizaSolCreditoAgro(solicitudCredito,Enum_Act_SolAgro.principal,numTransaccion);
						if(mensajeActualiza.getNumero()!=0){
							throw new Exception(mensajeActualiza.getDescripcion());
						}
						/*Alta de Ministraciones*/
						MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
						ministracionCredAgroBean.setClienteID(solicitudCredito.getClienteID());
						ministracionCredAgroBean.setProspectoID(solicitudCredito.getProspectoID());
						ministracionCredAgroBean.setSolicitudCreditoID(mensajeBean.getConsecutivoString());
						ministracionCredAgroBean.setCreditoID("0");


						String Renovacion = "O";
						if(!solicitudCredito.getTipoCredito().equals(Renovacion)){

							MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCredito.getDetalleMinistraAgro(), numTransaccion);
							if (mensajeMinistra.getNumero() != 0) {
								throw new Exception(mensajeMinistra.getDescripcion());
							}
						}else{

							MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCredito.getDetalleMinistraAgro(), numTransaccion);
							if (mensajeMinistra.getNumero() != 0) {
								throw new Exception(mensajeMinistra.getDescripcion());
							}
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
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean} Bean con la informacion del Crédito
	 * @param tipoActualizacion : Numero de Actualizacion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean modificacionCredAgro(final SolicitudCreditoFiraBean solicitudCredito, int tipoActualizacion) {
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
							MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, solicitudCredito.getDetalleMinistraAgro(), numeroTransaccion);
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
	 * @param solicitudCredito : {@link SolicitudCreditoFiraBean} Bean con la Informacion de la Solicitud
	 * @param numAct : Numero de Actualizacion
	 * @param numTransaccion : {@link Long} Número de Transacción
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean actualizaSolCreditoAgro(final SolicitudCreditoFiraBean solicitudCredito, final int numAct, final long numTransaccion) {
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
	public List listaGuardaValores(SolicitudCreditoFiraBean solicitudCredito, int tipoLista){

		List<SolicitudCreditoFiraBean> listaSolicitudCredito = null;
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
					SolicitudCreditoFiraBean solicitudCredito = new SolicitudCreditoFiraBean();
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
}