package credito.dao;
import fira.bean.MinistracionCredAgroBean;
import fira.dao.MinistraCredAgroDAO;
import fira.servicio.MinistraCredAgroServicio.Enum_Act_MinistraCredAgro;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.CalculosyOperaciones;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;


/* Eliminar esta seccion*/
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.codehaus.groovy.ast.stmt.CatchStatement;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import com.google.gson.Gson;

import originacion.bean.SolicitudCreditoBean;
import originacion.dao.SolicitudCreditoDAO;
import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolAgro;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.UsuarioServicio;
import ventanilla.bean.SpeiEnvioBean;
import WSkubo.WsSgbCrm;
import WSkubo.WsSgbCrmServiceLocator;
import WSkubo.responses.WsSgbResponse;
import cardinal.seguridad.mars.Encryptor20;
import cliente.bean.CicloCreditoBean;
import cliente.bean.ClienteBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.BitacoraCobAutoBean;
import credito.bean.CobranzaAutomaticaBean;
import credito.bean.ConciliadoPagBean;
import credito.bean.ContratoCredEncBean;
import credito.bean.CreditosBean;
import credito.bean.DetallePagoBean;
import credito.bean.PagosAnticipadosBean;
import credito.bean.PagosConciliadoBean;
import credito.bean.PagosxReferenciaBean;
import credito.bean.RazonesNoPagoBean;
import credito.bean.RepAntSaldosBean;
import credito.bean.RepCalificacionPorcResBean;
import credito.bean.RepComisionBean;
import credito.bean.RepEstimacionesCredPrevBean;
import credito.bean.RepMasivoFRBean;
import credito.bean.RepVencimiBean;
import credito.bean.ReporteCreditosBean;
import credito.bean.ReporteMinistraBean;
import credito.bean.ReporteMovimientosCreditosBean;
import credito.bean.SaldosCarteraAvaRefRepBean;
import credito.bean.SeguroVidaBean;
import credito.bean.ReporteServiciosAdicionalesBean;
import credito.beanWS.request.ConsultaActividadCreditoRequest;
import credito.beanWS.request.ConsultaDescuentosNominaRequest;
import credito.beanWS.request.ConsultaPagosAplicadosRequest;
import credito.beanWS.request.ListaCreditosBERequest;
import credito.beanWS.request.ListaSolicitudCreditoRequest;
import credito.beanWS.request.SimuladorCreditoRequest;
import credito.beanWS.response.ConsultaActividadCreditoResponse;
import credito.beanWS.response.ConsultaDescuentosNominaResponse;
import credito.beanWS.response.ConsultaPagosAplicadosResponse;
import credito.servicio.CreditosServicio.Enum_Act_Creditos;
import credito.servicio.CreditosServicio.Enum_Sim_PagAmortizaciones;
import credito.servicio.CreditosServicio.Enum_Tra_Creditos;
import cuentas.bean.CuentasAhoBean;


public class CreditosDAO extends BaseDAO {
	AmortizacionCreditoDAO	amortizacionCreditoDAO	= null;
	PolizaDAO				polizaDAO				= null;
	SeguroVidaDAO			seguroVidaDAO			= null;
	MinistraCredAgroDAO		ministraCredAgroDAO		= null;
	ParametrosSesionBean	parametrosSesionBean;
	PolizaBean				polizaBean;
	SolicitudCreditoDAO		solicitudCreditoDAO		= null;
	private UsuarioDAO		usuarioDAO				= null;
	Logger					log						= Logger.getLogger(this.getClass());
	public CreditosDAO() {
		super();
	}
	private final static String salidaPantalla = "S";
	private final static String esPrepago = "N";
	private final static String altaEnPolizaNo = "N";
	private final static String altaEnPolizaSi = "S";
	String numcredito = "";  // guarda el numero del credito que se a dado de alta
	String mensajedes = "";  // mesaje del credito
	private static interface tiposDispersionCredito {
		String SPEI = "S";
	}
	private static interface Enum_NumConSPEI {
		int consultaCtaBenOrd = 11;
	}
	private static interface Enum_NumActualizacionSPEI {
		int actualizaFirma = 504;
	}

	/**
	 * Alta de Créditos
	 * @param creditos bean del credito
	 * @return
	 */

	public MensajeTransaccionBean pagoComisionMasivo(final CreditosBean creditosBean,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		CreditosBean bean;

		int aux=0;
		try{
			if(listaBean.size() > 0){
				int contadorExito = 0;
				int contadorError = 0;
				int lista = listaBean.size();

				for(int i=0; i<listaBean.size(); i++){
					/* obtenemos un bean de la lista */
					bean = new CreditosBean();
					bean = (CreditosBean)listaBean.get(i);
					bean.setTipoComisionM(creditosBean.getTipoComisionM());
					bean.setTipoCobro(creditosBean.getTipoCobro());

					//Se registra cada credito que se notificara
					mensaje = altaPagoComisionMasivo(bean);
					if(mensaje.getNumero()!=0){
						contadorError++;
					}
					else{
						contadorExito++;
					}


					//Se da un retardo de 10 segundos
					if(aux == 5){
						try{
							Thread.sleep(10000);
							aux=0;
						}catch(InterruptedException e){
							e.printStackTrace();
						}
					}else{
						aux++;
					}
				}
				mensaje.setDescripcion("Pagados: "+ contadorExito +" de "+ lista + " Créditos." );

			}else{
				mensaje.setDescripcion("No existen Créditos con Adeudo de Comisiones");
				throw new Exception(mensaje.getDescripcion());
			}
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Comisiones con Cargo a Cuenta", e);
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}







		return mensaje;
	}

	public MensajeTransaccionBean alta(final CreditosBean creditos) {

		String fechInha = creditos.getFechaInhabil().substring(0, 1);
		String ajusVenAm = creditos.getAjusFecUlVenAmo().substring(0, 1);
		String ajusVenExi = creditos.getAjusFecExiVen().substring(0, 1);
		creditos.setFechaInhabil(fechInha);
		creditos.setAjusFecUlVenAmo(ajusVenAm);
		creditos.setAjusFecExiVen(ajusVenExi);
		creditos.setTipoFondeo(((creditos.getTipoFondeo().equalsIgnoreCase("F"))||(creditos.getTipoFondeo().equalsIgnoreCase("P") && Utileria.convierteEntero(creditos.getInstitFondeoID())>0 && Utileria.convierteEntero(creditos.getLineaFondeo())>0))?"F":"P");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
								sentenciaStore.setInt("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
								sentenciaStore.setDouble("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
								sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));
								sentenciaStore.setString("Par_TipoCredito",creditos.getTipoCredito());
								sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
								sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
								sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(creditos.getFechaInicio()));
								sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(creditos.getFechaVencimien()));

								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
								sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
								sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());
								sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));
								sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());

								sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
								sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
								sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));
								sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
								sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
								sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
								sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
								sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));
								sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));
								sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());

								sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
								sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
								sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
								sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));
								sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));
								sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
								sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
								sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
								sentenciaStore.setString("Par_CuentaCABLE",creditos.getCuentaCLABE()); // Agregado para el tipo de Dispersion SPEI
								sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));

								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));
								sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
								sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));
								sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
								sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
								sentenciaStore.setDouble("Par_MontoSegVida",Utileria.convierteDoble(creditos.getMontoSeguroVida()));
								sentenciaStore.setDouble("Par_AportaCliente",Utileria.convierteDoble(creditos.getAporteCliente()));
								sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(creditos.getFechaInicioAmor()));

								sentenciaStore.setString("Par_ForCobroSegVida",creditos.getForCobroSegVida());
								sentenciaStore.setDouble("Par_DescSeguro",Utileria.convierteDoble(creditos.getDescuentoSeguro()));
								sentenciaStore.setDouble("Par_MontoSegOri",Utileria.convierteDoble(creditos.getMontoSegOriginal()));

								// consultaSIC
								sentenciaStore.setString("Par_TipoConsultaSIC",creditos.getTipoConsultaSIC());
								sentenciaStore.setString("Par_FolioConsultaBC",creditos.getFolioConsultaBC());
								sentenciaStore.setString("Par_FolioConsultaCC",creditos.getFolioConsultaCC());

								// Cobro de comision por apertura
								sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(creditos.getFechaCobroComision()));

								//Pago Referenciado
								sentenciaStore.setString("Par_ReferenciaPago",creditos.getReferenciaPago());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("NumCreditoID", Types.BIGINT);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());

								sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Par_ProgramaID","CreditosDAO");
								sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Par_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean alta(final CreditosBean creditos, final long numTransaccion) {
		String fechInha = creditos.getFechaInhabil().substring(0, 1);
		String ajusVenAm = creditos.getAjusFecUlVenAmo().substring(0, 1);
		String ajusVenExi = creditos.getAjusFecExiVen().substring(0, 1);
		creditos.setFechaInhabil(fechInha);
		creditos.setAjusFecUlVenAmo(ajusVenAm);
		creditos.setAjusFecExiVen(ajusVenExi);
		creditos.setTipoFondeo(((creditos.getTipoFondeo().equalsIgnoreCase("F"))||(creditos.getTipoFondeo().equalsIgnoreCase("P") && Utileria.convierteEntero(creditos.getInstitFondeoID())>0 && Utileria.convierteEntero(creditos.getLineaFondeo())>0))?"F":"P");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
									    "?,?,?,?, ?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
								sentenciaStore.setInt("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
								sentenciaStore.setDouble("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
								sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));
								sentenciaStore.setString("Par_TipoCredito",creditos.getTipoCredito());
								sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
								sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
								sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(creditos.getFechaInicio()));
								sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(creditos.getFechaVencimien()));

								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
								sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
								sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());
								sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));
								sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());

								sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
								sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
								sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));
								sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
								sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
								sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
								sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
								sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));
								sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));
								sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());

								sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
								sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
								sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
								sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));
								sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));
								sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
								sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
								sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
								sentenciaStore.setString("Par_CuentaCABLE",creditos.getCuentaCLABE()); // Agregado para el tipo de Dispersion SPEI
								sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));

								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));
								sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
								sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));
								sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
								sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
								sentenciaStore.setDouble("Par_MontoSegVida",Utileria.convierteDoble(creditos.getMontoSeguroVida()));
								sentenciaStore.setDouble("Par_AportaCliente",Utileria.convierteDoble(creditos.getAporteCliente()));
								sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(creditos.getFechaInicioAmor()));

								sentenciaStore.setString("Par_ForCobroSegVida",creditos.getForCobroSegVida());
								sentenciaStore.setDouble("Par_DescSeguro",Utileria.convierteDoble(creditos.getDescuentoSeguro()));
								sentenciaStore.setDouble("Par_MontoSegOri",Utileria.convierteDoble(creditos.getMontoSegOriginal()));

								// consultaSIC
								sentenciaStore.setString("Par_TipoConsultaSIC",creditos.getTipoConsultaSIC());
								sentenciaStore.setString("Par_FolioConsultaBC",creditos.getFolioConsultaBC());
								sentenciaStore.setString("Par_FolioConsultaCC",creditos.getFolioConsultaCC());

								// Cobro de comision por apertura
								sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(creditos.getFechaCobroComision()));
								sentenciaStore.setString("Par_ReferenciaPago",creditos.getReferenciaPago());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("NumCreditoID", Types.BIGINT);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Par_ProgramaID","CreditosDAO");
								sentenciaStore.setInt("Par_SucursalID",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Par_NumTransaccion",numTransaccion);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// metodo para dar de alta el credito y el seguro de vida si es que se requiere
	public MensajeTransaccionBean altaCredito(final CreditosBean creditos, final String requiereSeguroVida) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = alta(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}else{
						if(requiereSeguroVida.equalsIgnoreCase(Constantes.STRING_SI) && creditos.getTipoCredito().equalsIgnoreCase(CreditosBean.creditoNuevo)){
							SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
							seguroVidaBean.setClienteID(creditos.getClienteID());
							seguroVidaBean.setCuentaAhoID(creditos.getCuentaID());
							seguroVidaBean.setBeneficiario(creditos.getBeneficiario());
							seguroVidaBean.setDireccionBeneficiario(creditos.getDireccionBen());
							seguroVidaBean.setRelacionBeneficiario(creditos.getParentescoID());
							seguroVidaBean.setForCobroSegVida(creditos.getForCobroSegVida());
							seguroVidaBean.setFechaVencimiento(creditos.getFechaVencimien());
							seguroVidaBean.setFechaInicio(creditos.getFechaInicio());
							seguroVidaBean.setMontoPoliza(creditos.getMontoPolSegVida());
							numcredito = mensajeBean.getConsecutivoString();
							mensajedes = mensajeBean.getDescripcion();
							seguroVidaBean.setCreditoID(numcredito); // se guarda el numero de credito que se dio de alta

							mensajeBean = seguroVidaDAO.altaSeguroVida(seguroVidaBean,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}else{
								mensajeBean.setConsecutivoString(numcredito);
								mensajeBean.setDescripcion(mensajedes);
							}
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaCreditoAgropecuario(final CreditosBean creditos, final String requiereSeguroVida, final int numActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
					mensajeBean = alta(creditos, numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
					numcredito = mensajeBean.getConsecutivoString();
					ministracionCredAgroBean.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
					ministracionCredAgroBean.setCreditoID(numcredito);
					//Se actualiza las ministraciones para que tengan su número de crédito.
					MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.actualizaAgro(ministracionCredAgroBean, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Act_MinistraCredAgro.actualizaCredito, false);
					if (mensajeMinistra.getNumero() != 0) {
						throw new Exception(mensajeMinistra.getDescripcion());
					}

					//Se actualiza los datos del credito para el caso de creditos agropecuarios
					SolicitudCreditoBean solicitudCredito=new SolicitudCreditoBean();
					solicitudCredito.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
					solicitudCredito.setTasaPasiva(creditos.getTasaPasiva());
					MensajeTransaccionBean mensajeSolicitud = solicitudCreditoDAO.actualizaSolCreditoAgro(solicitudCredito, Enum_Act_SolAgro.actualizacionCreditoAgro, numeroTransaccion);
					if (mensajeSolicitud.getNumero() != 0) {
						throw new Exception(mensajeSolicitud.getDescripcion());
					}

					if (requiereSeguroVida.equalsIgnoreCase(Constantes.STRING_SI) && creditos.getTipoCredito().equalsIgnoreCase(CreditosBean.creditoNuevo)) {
						SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
						seguroVidaBean.setClienteID(creditos.getClienteID());
						seguroVidaBean.setCuentaAhoID(creditos.getCuentaID());
						seguroVidaBean.setBeneficiario(creditos.getBeneficiario());
						seguroVidaBean.setDireccionBeneficiario(creditos.getDireccionBen());
						seguroVidaBean.setRelacionBeneficiario(creditos.getParentescoID());
						seguroVidaBean.setForCobroSegVida(creditos.getForCobroSegVida());
						seguroVidaBean.setFechaVencimiento(creditos.getFechaVencimien());
						seguroVidaBean.setFechaInicio(creditos.getFechaInicio());
						seguroVidaBean.setMontoPoliza(creditos.getMontoPolSegVida());

						mensajedes = mensajeBean.getDescripcion();
						seguroVidaBean.setCreditoID(numcredito); // se guarda el numero de credito que se dio de alta

						mensajeBean = seguroVidaDAO.altaSeguroVida(seguroVidaBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						} else {
							mensajeBean.setConsecutivoString(numcredito);
							mensajeBean.setDescripcion(mensajedes);
						}

					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion del credito */
	public MensajeTransaccionBean modifica(final CreditosBean creditos) {
		String fechInha = creditos.getFechaInhabil().substring(0, 1);
		String ajusVenAm = creditos.getAjusFecUlVenAmo().substring(0, 1);
		String ajusVenExi = creditos.getAjusFecExiVen().substring(0, 1);
		creditos.setFechaInhabil(fechInha);
		creditos.setAjusFecUlVenAmo(ajusVenAm);
		creditos.setAjusFecExiVen(ajusVenExi);
		creditos.setTipoFondeo(((creditos.getTipoFondeo().equalsIgnoreCase("F"))||(creditos.getTipoFondeo().equalsIgnoreCase("P") && Utileria.convierteEntero(creditos.getInstitFondeoID())>0 && Utileria.convierteEntero(creditos.getLineaFondeo())>0))?"F":"P");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?,"	+
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
								sentenciaStore.setInt("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
								sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
								sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));

								sentenciaStore.setString("Par_TipoCredito",creditos.getTipoCredito());
								sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
								sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));

								sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(creditos.getFechaInicio()));
								sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(creditos.getFechaVencimien()));
								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
								sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));

								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
								sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());

								sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));
								sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());
								sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
								sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
								sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));

								sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
								sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
								sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
								sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
								sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));

								sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));
								sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());
								sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
								sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
								sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));

								sentenciaStore.setDate("Par_FecTraspVen",OperacionesFechas.conversionStrDate(creditos.getFechTraspasVenc()));
								sentenciaStore.setDate("Par_FechTermina",OperacionesFechas.conversionStrDate(creditos.getFechTerminacion()));
								sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
								sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
								sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));

								sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));
								sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
								sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
								sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
								sentenciaStore.setString("Par_CuentaCABLE",creditos.getCuentaCLABE()); // Agregado para el tipo de Dispersion SPEI

								sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));
								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));
								sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
								sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
								sentenciaStore.setDouble("Par_MontoSegVida",Utileria.convierteDoble(creditos.getMontoSeguroVida()));

								sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(creditos.getFechaInicioAmor()));
								sentenciaStore.setString("Par_ForCobroSegVida",creditos.getForCobroSegVida());
								sentenciaStore.setDouble("Par_DescSeguro",Utileria.convierteDoble(creditos.getDescuentoSeguro()));

								sentenciaStore.setDouble("Par_MontoSegOri",Utileria.convierteDoble(creditos.getMontoSegOriginal()));
								sentenciaStore.setString("Par_ComentarioAlt",creditos.getComentarioAlt());
								// consultaSIC
								sentenciaStore.setString("Par_TipoConsultaSIC",creditos.getTipoConsultaSIC());
								sentenciaStore.setString("Par_FolioConsultaBC",creditos.getFolioConsultaBC());
								sentenciaStore.setString("Par_FolioConsultaCC",creditos.getFolioConsultaCC());

								// Cobro de comision por apertura
								sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(creditos.getFechaCobroComision()));
								sentenciaStore.setString("Par_ReferenciaPago", creditos.getReferenciaPago());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifcacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion del credito */
	public MensajeTransaccionBean modifica(final CreditosBean creditos, final long numTransaccion) {
		String fechInha = creditos.getFechaInhabil().substring(0, 1);
		String ajusVenAm = creditos.getAjusFecUlVenAmo().substring(0, 1);
		String ajusVenExi = creditos.getAjusFecExiVen().substring(0, 1);
		creditos.setFechaInhabil(fechInha);
		creditos.setAjusFecUlVenAmo(ajusVenAm);
		creditos.setAjusFecExiVen(ajusVenExi);
		creditos.setTipoFondeo(((creditos.getTipoFondeo().equalsIgnoreCase("F"))||(creditos.getTipoFondeo().equalsIgnoreCase("P") && Utileria.convierteEntero(creditos.getInstitFondeoID())>0 && Utileria.convierteEntero(creditos.getLineaFondeo())>0))?"F":"P");
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
								sentenciaStore.setInt("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
								sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
								sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));

								sentenciaStore.setString("Par_TipoCredito",creditos.getTipoCredito());
								sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
								sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));

								sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(creditos.getFechaInicio()));
								sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(creditos.getFechaVencimien()));
								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
								sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));

								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
								sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());

								sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));
								sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());
								sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
								sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
								sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));

								sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
								sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
								sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
								sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
								sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));

								sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));
								sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());
								sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
								sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
								sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));

								sentenciaStore.setDate("Par_FecTraspVen",OperacionesFechas.conversionStrDate(creditos.getFechTraspasVenc()));
								sentenciaStore.setDate("Par_FechTermina",OperacionesFechas.conversionStrDate(creditos.getFechTerminacion()));
								sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
								sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
								sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));

								sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));
								sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
								sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
								sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
								sentenciaStore.setString("Par_CuentaCABLE",creditos.getCuentaCLABE()); // Agregado para el tipo de Dispersion SPEI

								sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));
								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));
								sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
								sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
								sentenciaStore.setDouble("Par_MontoSegVida",Utileria.convierteDoble(creditos.getMontoSeguroVida()));

								sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(creditos.getFechaInicioAmor()));
								sentenciaStore.setString("Par_ForCobroSegVida",creditos.getForCobroSegVida());
								sentenciaStore.setDouble("Par_DescSeguro",Utileria.convierteDoble(creditos.getDescuentoSeguro()));

								sentenciaStore.setDouble("Par_MontoSegOri",Utileria.convierteDoble(creditos.getMontoSegOriginal()));
								sentenciaStore.setString("Par_ComentarioAlt",creditos.getComentarioAlt());
								// consultaSIC
								sentenciaStore.setString("Par_TipoConsultaSIC",creditos.getTipoConsultaSIC());
								sentenciaStore.setString("Par_FolioConsultaBC",creditos.getFolioConsultaBC());
								sentenciaStore.setString("Par_FolioConsultaCC",creditos.getFolioConsultaCC());

								sentenciaStore.setString("Par_FechaCobroComision",Utileria.convierteFecha(creditos.getFechaCobroComision()));
								sentenciaStore.setString("Par_ReferenciaPago", creditos.getReferenciaPago());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								// Cobro de comision por apertura


								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifcacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaCreditoAgro(final CreditosBean creditos, final HttpServletRequest request,final int numActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
					mensajeBean = modifica(creditos, numeroTransaccion);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					} else {
						MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
						numcredito = mensajeBean.getConsecutivoString();
						ministracionCredAgroBean.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
						ministracionCredAgroBean.setCreditoID(creditos.getCreditoID());
						//Se actualiza las ministraciones para que tengan su número de crédito.
						MensajeTransaccionBean mensajeMinistra = ministraCredAgroDAO.actualizaAgro(ministracionCredAgroBean, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Act_MinistraCredAgro.actualizaCredito, false);
						if (mensajeMinistra.getNumero() != 0) {
							throw new Exception(mensajeMinistra.getDescripcion());
						}

						//Se actualiza los datos del credito para el caso de creditos agropecuarios
						SolicitudCreditoBean solicitudCredito=new SolicitudCreditoBean();
						solicitudCredito.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
						solicitudCredito.setCreditoID(numcredito);
						solicitudCredito.setTasaPasiva(creditos.getTasaPasiva());
						MensajeTransaccionBean mensajeSolicitud = solicitudCreditoDAO.actualizaSolCreditoAgro(solicitudCredito, Enum_Act_SolAgro.actualizacionCreditoAgro, numeroTransaccion);
						if (mensajeSolicitud.getNumero() != 0) {
							throw new Exception(mensajeSolicitud.getDescripcion());
						}

						String requiereSeguroVida = request.getParameter("reqSeguroVida");
						if (requiereSeguroVida.equalsIgnoreCase(Constantes.STRING_SI) && creditos.getTipoCredito().equalsIgnoreCase(CreditosBean.creditoNuevo)) {
							SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
							seguroVidaBean.setSeguroVidaID(request.getParameter("seguroVidaID"));
							seguroVidaBean.setCreditoID(creditos.getCreditoID()); // se guarda el numero de credito que se dio de alta
							seguroVidaBean.setFechaVencimiento(creditos.getFechaVencimien());
							seguroVidaBean.setFechaInicio(creditos.getFechaInicio());
							seguroVidaBean.setBeneficiario(creditos.getBeneficiario());
							seguroVidaBean.setDireccionBeneficiario(creditos.getDireccionBen());
							seguroVidaBean.setRelacionBeneficiario(creditos.getParentescoID());
							seguroVidaBean.setForCobroSegVida(creditos.getForCobroSegVida());
							seguroVidaBean.setMontoPoliza(creditos.getMontoPolSegVida());

							numcredito = mensajeBean.getConsecutivoString();
							mensajedes = mensajeBean.getDescripcion();
							mensajeBean = seguroVidaDAO.modificaSeguroVida(seguroVidaBean, parametrosAuditoriaBean.getNumeroTransaccion());

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							} else {
								mensajeBean.setConsecutivoString(numcredito);
								mensajeBean.setDescripcion(mensajedes);
							}
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean modificaCredito(final CreditosBean creditos, final  HttpServletRequest request) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = modifica(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}else{
						String requiereSeguroVida = request.getParameter("reqSeguroVida");
						if(requiereSeguroVida.equalsIgnoreCase(Constantes.STRING_SI) && creditos.getTipoCredito().equalsIgnoreCase(CreditosBean.creditoNuevo)){
							SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
							seguroVidaBean.setSeguroVidaID(request.getParameter("seguroVidaID"));
							seguroVidaBean.setCreditoID(creditos.getCreditoID()); // se guarda el numero de credito que se dio de alta
							seguroVidaBean.setFechaVencimiento(creditos.getFechaVencimien());
							seguroVidaBean.setFechaInicio(creditos.getFechaInicio());
							seguroVidaBean.setBeneficiario(creditos.getBeneficiario());
							seguroVidaBean.setDireccionBeneficiario(creditos.getDireccionBen());
							seguroVidaBean.setRelacionBeneficiario(creditos.getParentescoID());
							seguroVidaBean.setForCobroSegVida(creditos.getForCobroSegVida());
							seguroVidaBean.setMontoPoliza(creditos.getMontoPolSegVida());

							numcredito = mensajeBean.getConsecutivoString();
							mensajedes = mensajeBean.getDescripcion();
							mensajeBean = seguroVidaDAO.modificaSeguroVida(seguroVidaBean,parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}else{
								mensajeBean.setConsecutivoString(numcredito);
								mensajeBean.setDescripcion(mensajedes);
							}
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Autorizacion del credito */
	public MensajeTransaccionBean autoriza(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call CREDITOSACT(?,?,?,?,?,   ?,?,?,?,?," +
																"?,?,?,?,?,	  ?,?,?,?,?," +
																"?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_NumTransSim",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_FechaAutoriza",creditos.getFechaAutoriza());
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(creditos.getUsuarioAutoriza()));
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_FechaInicio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_FechaVencim",Constantes.FECHA_VACIA);
								sentenciaStore.setDouble("Par_ValorCAT",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_MontoRetDes",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_FolioDisper",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoDisper",Constantes.STRING_CERO);
								sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Actualiza tipo de Prepago (Creditos Grupales) */
	public MensajeTransaccionBean actualizaPrepago(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call CREDITOSACT(?,?,?,?,?,   ?,?,?,?,?," +
																"?,?,?,?,?,	  ?,?,?,?,?," +
																"?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_NumTransSim",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_FechaAutoriza",Constantes.FECHA_VACIA);
								sentenciaStore.setInt("Par_UsuarioAutoriza",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setString("Par_FechaInicio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_FechaVencim",Constantes.FECHA_VACIA);
								sentenciaStore.setDouble("Par_ValorCAT",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_MontoRetDes",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_FolioDisper",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoDisper",Constantes.STRING_CERO);
								sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Actualizacion para controlar los montos que retire o se le deposite al Cliente/Socio por desembolso se ocupa en ingresos de operaciones
	 * @param creditos : {@link CreditosBean} con la Información del Crédito
	 * @param tipoActualizacion : Tipo de Actualización
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean actualizarMontosDesembolsados(final CreditosBean creditos, final int tipoActualizacion, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSACT(" + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_NumTransSim", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_FechaAutoriza", creditos.getFechaAutoriza());
							sentenciaStore.setInt("Par_UsuarioAutoriza", Utileria.convierteEntero(creditos.getUsuarioAutoriza()));
							sentenciaStore.setString("Par_TipoPrepago", creditos.getTipoPrepago());
							sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

							sentenciaStore.setString("Par_FechaInicio", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Par_FechaVencim", Constantes.FECHA_VACIA);
							sentenciaStore.setDouble("Par_ValorCAT", Constantes.ENTERO_CERO);
							sentenciaStore.setDouble("Par_MontoRetDes", Utileria.convierteDoble(creditos.getMontoRetDes()));
							sentenciaStore.setDouble("Par_FolioDisper", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_TipoDisper", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));

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
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actalizacion de credito", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actalizacion de credito", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*Graba amortizaciones definitivas del  credito*/
	public MensajeTransaccionBean generarAmortizaciones(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call CREGENAMORTIZAPRO(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setString("Par_FecMinist",Utileria.convierteFecha(creditos.getFechaMinistrado()));
								sentenciaStore.setString("Par_FechaInicioAmor",Utileria.convierteFecha(creditos.getFechaInicioAmor()));

								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la grabacion de amortizacion definitiva del credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que realiza la autorización de la Impresión del Pagaré del Crédito
	 * @param creditos : {@link CreditosBean} Bean con la información del crédito
	 * @param tipoActualizacion : Número de Actualizacion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean autorizaPagImp(final CreditosBean creditos, final int tipoActualizacion, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if(numTransaccion>0){
			parametrosAuditoriaBean.setNumeroTransaccion(numTransaccion);
		} else {
			transaccionDAO.generaNumeroTransaccion();
		}
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSACT(?,?,?,?,?,   ?,?,?,?,?," + "?,?,?,?,?,	  ?,?,?,?,?," + "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_NumTransSim", Utileria.convierteLong(creditos.getNumTransacSim()));
							sentenciaStore.setString("Par_FechaAutoriza", creditos.getFechaAutoriza());
							sentenciaStore.setInt("Par_UsuarioAutoriza", Utileria.convierteEntero(creditos.getUsuarioAutoriza()));
							sentenciaStore.setString("Par_FechaAutoriza", creditos.getFechaAutoriza());
							sentenciaStore.setString("Par_TipoPrepago", creditos.getTipoPrepago());
							sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
							sentenciaStore.setString("Par_FechaInicio", creditos.getFechaInicio());
							sentenciaStore.setString("Par_FechaVencim", creditos.getFechaVencimien());
							sentenciaStore.setDouble("Par_ValorCAT", Utileria.convierteDoble(creditos.getCat()));
							sentenciaStore.setDouble("Par_MontoRetDes", Constantes.ENTERO_CERO);
							sentenciaStore.setDouble("Par_FolioDisper", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_TipoDisper", Constantes.STRING_CERO);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
							if (callableStatement.execute()) {

								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en autorzacion de pagare", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Tipo de Dispersion */

	public MensajeTransaccionBean actuaTipoDisper(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call CREDITOSACT(?,?,?,?,?,   ?,?,?,?,?," +
																"?,?,?,?,?,	  ?,?,?,?,?," +
																"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_NumTransSim",Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Par_FechaAutoriza",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setInt("Par_UsuarioAutoriza",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoPrepago",creditos.getTipoPrepago());

								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
								sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
								sentenciaStore.setDouble("Par_ValorCAT",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_MontoRetDes",Utileria.convierteDoble(creditos.getMontoCredito()));
								sentenciaStore.setDouble("Par_FolioDisper",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());//Tipo Dispersion
								sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tiposde dispersion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*fin Tipo Dispersion*/

	/**
	 * Desembolso de creditos individuales
	 * @param creditos
	 * @return
	 */
	public MensajeTransaccionBean desembolsaCredito(final CreditosBean creditos){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		int numErrDesembolso = Constantes.ENTERO_CERO;
		String errMenDesembolso = Constantes.STRING_VACIO;
		String controlDesembolso = Constantes.STRING_VACIO;
		String consecutivoDesembolso = Constantes.STRING_VACIO;

		try{
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean=new PolizaBean();

			polizaBean.setConceptoID(CreditosBean.desembolsoCredito);
			polizaBean.setConcepto(CreditosBean.desDesembolsoCredito);
			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							creditos.setPolizaID(poliza);
							mensajeBean = desembolsoCredito(creditos, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CreditosDAO.desembolsaCredito: Error en desembolso de credito", e);
						}
						return mensajeBean;
					}
				});
				/* Baja de Poliza en caso de que haya ocurrido un error */
				if (mensaje.getNumero() != 0) {
					try {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("CreditosDAO.desembolsoCredito");
						bajaPolizaBean.setPolizaID(creditos.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error("CreditosDAO.desembolsoCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				/* Fin Baja de la Poliza Contable*/

				// Se actualiza la Firma en caso de que el tipo de dispersion del crédito sea por SPEI
				if(creditos.getTipoDispersion().equals(tiposDispersionCredito.SPEI)){
					SpeiEnvioBean speiEnvioBean = consultaCtaBenOrdSPEI(Enum_NumConSPEI.consultaCtaBenOrd, parametrosAuditoriaBean.getNumeroTransaccion());
					// Se asigna al objeto mensaje los valores de éxito del desembolso
					numErrDesembolso = mensaje.getNumero();
					errMenDesembolso = mensaje.getDescripcion();
					controlDesembolso = mensaje.getNombreControl();
					consecutivoDesembolso = mensaje.getConsecutivoString();

					if(speiEnvioBean != null){
						try {
							Encryptor20 encryptor = new Encryptor20();
							String firmaSAFI = "";

				        	firmaSAFI = speiEnvioBean.getFolioSpeiID() + speiEnvioBean.getCuentaBeneficiario() + speiEnvioBean.getCuentaOrd();

				        	firmaSAFI = encryptor.generaFirmaStrong(firmaSAFI);

				        	speiEnvioBean.setFirma(firmaSAFI);
						} catch (Exception e) {
							mensaje.setNumero(999);
							throw new Exception("Ha ocurrido un error al generar la Firma del SPEI.");
						}

						mensaje = actualizarFirmaEnvioSPEI(speiEnvioBean, parametrosAuditoriaBean.getNumeroTransaccion());

						if (mensaje.getNumero() != Constantes.CODIGO_SIN_ERROR) {
							throw new Exception(mensaje.getDescripcion());
						}

						mensaje.setNumero(numErrDesembolso);
						mensaje.setDescripcion(errMenDesembolso);
						mensaje.setNombreControl(controlDesembolso);
						mensaje.setConsecutivoString(consecutivoDesembolso);
					}
				}
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}


		}catch(Exception ex){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Realizar desembolso de Crédito.");
			ex.printStackTrace();
		}
		return mensaje;
	}
	/**
	 * Método para realizar el proceso de desembolso del crédito.
	 * @param creditos
	 * @param ministracion
	 * @return
	 */
	public MensajeTransaccionBean desembolsaCreditoAgro(final CreditosBean creditos, final MinistracionCredAgroBean ministracion, final boolean validaUsuario){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean=new PolizaBean();
			final long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

			polizaBean.setConceptoID(CreditosBean.desembolsoCredito);
			polizaBean.setConcepto(CreditosBean.desDesembolsoCredito);
			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							creditos.setPolizaID(poliza);
							// Se actualiza la ministracion para marcarla como desembolsada
							MensajeTransaccionBean mensajeActualizaDes = ministraCredAgroDAO.actualizaAgro(ministracion, numeroTransaccion, Enum_Act_MinistraCredAgro.desembolso, validaUsuario);
							if (mensajeActualizaDes.getNumero() != 0) {
								throw new Exception(mensajeActualizaDes.getDescripcion());
							}

							//Se Procede a realizar el desembolso.
							mensajeBean = desembolsoCreditoAgro(creditos, parametrosAuditoriaBean.getNumeroTransaccion(), ministracion);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CreditosDAO.desembolsaCreditoAgro: Error en desembolso de credito", e);
						}
						return mensajeBean;
					}
				});
				/* Baja de Poliza en caso de que haya ocurrido un error */
				if (mensaje.getNumero() != 0) {
					try {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("CreditosDAO.desembolsoCredito");
						bajaPolizaBean.setPolizaID(creditos.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error("CreditosDAO.desembolsoCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				/* Fin Baja de la Poliza Contable*/
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}


		}catch(Exception ex){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Realizar desembolso de Crédito.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Ministracion o desembolso del credito
	 * @param creditos Bean de Creditos (CreditosBean)
	 * @param numTransaccion	Numero de Transacción
	 * @return Retorna Mensaje de Exito o Error (MensajeTransaccionBean)
	 */
	public MensajeTransaccionBean desembolsoCredito(final CreditosBean creditos, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call MINISTRACREPRO(?,?,?,?,?,    "
											+ "?,?,?,?,?,    "
											+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
									sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(creditos.getPolizaID()));
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CreditosDAO.desembolsoCredito: Error en ministracion o desembolso de credito", e);
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
	 * Ministracion o desembolso del credito
	 * @param creditos Bean de Creditos (CreditosBean)
	 * @param numTransaccion	Numero de Transacción
	 * @return Retorna Mensaje de Exito o Error (MensajeTransaccionBean)
	 */
	public MensajeTransaccionBean desembolsoCreditoAgro(final CreditosBean creditos, final long numTransaccion, final MinistracionCredAgroBean ministracion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		long numTransaccionPasivo = transaccionDAO.generaNumeroTransaccionOut();
		ministracion.setNumTransaccionPasivo(String.valueOf(numTransaccionPasivo));
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call MINISTRACREAGROPRO("
											+ "?,?,?,?,?,    "
											+ "?,?,?,?,?,    "
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_NumeroMinistracion", Utileria.convierteEntero(ministracion.getNumero()));
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
									sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(creditos.getPolizaID()));
									sentenciaStore.setString("Par_TipoCalculoInteres",ministracion.getTipoCalculoInteres());
									sentenciaStore.setLong("Par_NumTransacionPasivo", Utileria.convierteLong(ministracion.getNumTransaccionPasivo()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CreditosDAO.desembolsoCredito: Error en ministracion o desembolso de credito", e);
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

	/* Pago del credito individual con cargo a cuenta */
	public MensajeTransaccionBean PagoCreditoCargoCuenta(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=PagoCreditoCargo(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de credito", e);
				}
				return mensajeBean;
			}
		});
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}

public MensajeTransaccionBean PagoCreditoCargo(final CreditosBean creditos,final long numeroTransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

				// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOCREDITOPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,	?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_EsPrePago",esPrepago);

							sentenciaStore.setString("Par_Finiquito",creditos.getFiniquito());
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Salida",salidaPantalla);
							sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);

							sentenciaStore.setInt("Var_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
							sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_CARGO_CUENTA);

							sentenciaStore.setString("Par_Origen","S" );
							sentenciaStore.setString("Par_RespaldaCred","S" );

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
								mensajeTransaccion.setNombreControl("numeroTransaccion");
								mensajeTransaccion.setConsecutivoString(String.valueOf(numeroTransaccion));

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
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago del credito", e);
				transaction.setRollbackOnly();
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

/**
 * Crea en encabezado de la póliza y realiza el Pago de Crédito Agro con Cargo a Cuenta.
 * @param creditos : Clase bean con los parámetros de entrada al SP-PAGOCREDITOAGROPRO.
 * @return {@link MensajeTransaccionBean} con el resultado de la trasacción.
 * @author avelasco
 */
public MensajeTransaccionBean pagoAgroCargoCuenta(final CreditosBean creditos) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();
	final PolizaBean polizaBean=new PolizaBean();

	polizaBean.setConceptoID(CreditosBean.pagoCredito);
	polizaBean.setConcepto(CreditosBean.desPagoCredito);

	int	contador  = 0;
	while(contador <= PolizaBean.numIntentosGeneraPoliza){
		contador ++;
		polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
			break;
		}
	}
	if(Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoAgroCargoCta(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de credito", e);
				}
				return mensajeBean;
			}
		});

		if(mensaje.getNumero() != 0){
			polizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
			polizaDAO.bajaPoliza(polizaBean);
		}

	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}


	return mensaje;
}
/**
 * Pago de Crédito Agro con Cargo a Cuenta.
 * @param creditos : Clase bean con los parámetros de entrada al SP-PAGOCREDITOAGROPRO.
 * @param numeroTransaccion : Número de Transacción.
 * @return {@link MensajeTransaccionBean} con el resultado de la trasacción.
 * @author avelasco
 */
public MensajeTransaccionBean pagoAgroCargoCta(final CreditosBean creditos,final long numeroTransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PAGOCREDITOAGROPRO("
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?,?,?,?,	"
										+ "?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
								sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
								sentenciaStore.setString("Par_EsPrePago",esPrepago);

								sentenciaStore.setString("Par_Finiquito",creditos.getFiniquito());
								sentenciaStore.setInt("Par_CreditoR", Utileria.convierteEntero(creditos.getCreditoR()));
								sentenciaStore.setInt("Par_CreditoRC", Utileria.convierteEntero(creditos.getCreditoRC()));
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setString("Par_Salida",salidaPantalla);

								sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);
								sentenciaStore.registerOutParameter("Par_MontoPago", Types.DECIMAL);
								sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
								sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_CARGO_CUENTA);
								sentenciaStore.setString("Par_Origen","S" );
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
									mensajeTransaccion.setNombreControl("numeroTransaccion");
									mensajeTransaccion.setConsecutivoString(String.valueOf(numeroTransaccion));

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
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago del credito agro: ", e);
				transaction.setRollbackOnly();
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

	/* Pago de Credito Individual Cobranza Automatica */
	public MensajeTransaccionBean PagoCredito(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=PagoCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de credito", e);
				}
				return mensajeBean;
			}
		});
		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("CreditosDAO.PagoCredito");
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("CreditosDAO.PagoCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/

	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
	}

	public MensajeTransaccionBean PagoCredito(final CreditosBean creditos,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					if(creditos.getOrigen() == null){
						creditos.setOrigen("S"); // Se evalua que el Origen no sea nulo
					}
					if(!creditos.getOrigen().equalsIgnoreCase("A")){
						creditos.setOrigen("S"); // Se evalua que sea diferente de Cobranza Automatica
					}
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PAGOCREDITOPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,   ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
								sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
								sentenciaStore.setString("Par_EsPrePago",esPrepago);

								sentenciaStore.setString("Par_Finiquito",creditos.getFiniquito());
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);
								sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);

								sentenciaStore.setInt("Var_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
								sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_CARGO_CUENTA);

								sentenciaStore.setString("Par_Origen", creditos.getOrigen());
								sentenciaStore.setString("Par_RespaldaCred","S" );
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago del credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método para el Pago de Crédito en Efectivo
	 * @param creditos : Bean CreditosBean con la Información del Crédito a Pagar
	 * @param numTransaccion : Número de Transaccion
	 * @param numPoliza: Número de Poliza
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean PagoCredito(final CreditosBean creditos, final long numTransaccion, final int numPoliza, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOCREDITOPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,	 ?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_EsPrePago", esPrepago);

							sentenciaStore.setString("Par_Finiquito", creditos.getFiniquito());
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);

							sentenciaStore.setLong("Var_Poliza", numPoliza);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
							sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_EFECTIVO);

							sentenciaStore.setString("Par_Origen",creditos.getOrigenPago());
							sentenciaStore.setString("Par_RespaldaCred","S" );
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.PagoCreditoEfectivo");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

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
						mensajeBean.setDescripcion(e.getMessage());
					}
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago del credito en efectivo", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago del credito en efectivo", e);
					}
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para realizar el Proceso de Pago de Crédito Grupal, Método que se llama desde la ventanilla
	 * @param creditos : Bean CreditosBean con la Información de los Créditos
	 * @param numTransaccion : Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoGrupalCredito(final CreditosBean creditos, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOGRUPALCREPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setLong("Par_CuentaPago", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_EsPrePago", esPrepago);
							sentenciaStore.setString("Par_Finiquito", creditos.getFiniquito());
							sentenciaStore.setString("Par_FormaPago", creditos.getFormaPago());
							sentenciaStore.setInt("Par_CicloGrupo", Utileria.convierteEntero(creditos.getCicloGrupo()));

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							sentenciaStore.setLong("Var_Poliza", Utileria.convierteLong(creditos.getPolizaID()));
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);
							sentenciaStore.setString("Par_OrigenPago",creditos.getOrigenPago());

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.PagoGrupalCredito");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
						mensajeBean.setDescripcion(e.getMessage());
					}

					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago grupal de credito", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago grupal de credito", e);
					}
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Pago Grupal del Credito con Cargo a Cuenta */
		public MensajeTransaccionBean pagoGrupalCreditoCargoCuenta(final CreditosBean creditos) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean=new PolizaBean();

			polizaBean.setConceptoID(CreditosBean.pagoCredito);
			polizaBean.setConcepto(CreditosBean.desPagoCredito);

			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String poliza =polizaBean.getPolizaID();
					try {
						creditos.setPolizaID(poliza);
						mensajeBean=pagoGrupalCreditoCargoCuenta(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago grupal de credito", e);
					}
					return mensajeBean;
				}
			});
		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
		}

	public MensajeTransaccionBean pagoGrupalCreditoCargoCuenta(final CreditosBean creditos, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOGRUPALCREPRO(" +
								  "?,?,?,?,?,		"
								+ "?,?,?,?,?,		"
								+ "?,?,?,?,?,		"
								+ "?,?,?,?,?,		"
								+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setLong("Par_CuentaPago", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_EsPrePago", esPrepago);
							sentenciaStore.setString("Par_Finiquito", creditos.getFiniquito());
							sentenciaStore.setString("Par_FormaPago", creditos.getFormaPago());
							sentenciaStore.setInt("Par_CicloGrupo", Utileria.convierteEntero(creditos.getCicloGrupo()));

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							sentenciaStore.setLong("Var_Poliza", Utileria.convierteLong(creditos.getPolizaID()));
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);
							sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_CARGOCTA);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.pagoGrupalCreditoCargoCuenta");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl("numeroTransaccion"); // para el ticket
								mensajeTransaccion.setConsecutivoString(String.valueOf(numeroTransaccion)); // para el ticket
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago grupal de credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Pago Grupal del Credito Cobranza Automatica */
	public MensajeTransaccionBean pagoGrupalCredito(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoGrupalCreditos(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de credito", e);
				}
				return mensajeBean;
			}
		});
		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0 || mensaje.getDescripcion().equals("ELIMINAPOLIZA")) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("CreditosDAO.pagoGrupalCredito");
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("CreditosDAO.pagoGrupalCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
	}

	public MensajeTransaccionBean pagoGrupalCreditos(final CreditosBean creditos, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOGRUPALCREPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setLong("Par_CuentaPago", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_EsPrePago", esPrepago);
							sentenciaStore.setString("Par_Finiquito", creditos.getFiniquito());
							sentenciaStore.setString("Par_FormaPago", creditos.getFormaPago());
							sentenciaStore.setInt("Par_CicloGrupo", Utileria.convierteEntero(creditos.getCicloGrupo()));

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							sentenciaStore.setLong("Var_Poliza", Utileria.convierteLong(creditos.getPolizaID()));
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);
							sentenciaStore.setString("Par_OrigenPago", Constantes.ORIGEN_PAGO_COBRANZA);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.pagoGrupalCreditos");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago grupal de credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	// ALTA DE CREDITO GRUPAL
	public MensajeTransaccionBean altaCreditoGrupalPro(final CreditosBean creditos, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final Long numTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Se realizan validaciones
					mensajeBean = validaSolicitud(creditos);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if(tipoTransaccion == Enum_Tra_Creditos.altaGrupal){
						// se da de alta el credito grupal
						mensajeBean = altaCreditoGrupal(creditos,tipoTransaccion,numTransaccion);
					}else{
						// se da de alta el credito grupalAgro
						mensajeBean = altaCreditoGrupalAgro(creditos,tipoTransaccion,numTransaccion);
					}

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Credito Grupal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Alta de Credito Grupal
	public MensajeTransaccionBean altaCreditoGrupal(final CreditosBean creditos, final int tipoTransaccion, final Long numTransaccion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSGRUPALPRO("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Grupo",Utileria.convierteEntero(creditos.getGrupoID()));
								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditos.getPolizaID()));
								sentenciaStore.setString("Par_FechaMinis",Utileria.convierteFecha(creditos.getFechaMinistrado()));
								sentenciaStore.setString("Par_OrigenPago",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
								// logea el call enviado al Stored Procedure
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito grupal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Alta de Credito Grupal Agropecuario
	public MensajeTransaccionBean altaCreditoGrupalAgro(final CreditosBean creditos, final int tipoTransaccion, final Long numTransaccion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSGRUPOSAGROALT(?,  ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(creditos.getGrupoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
								// logea el call enviado al Stored Procedure
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito grupal Agro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// Autorizacion de Credito Grupal
		public MensajeTransaccionBean autorizaCreditoGrupal(final CreditosBean creditos, final int tipoTransaccion) {
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
									String query = "call CREDITOSGRUPALPRO("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Grupo",Utileria.convierteEntero(creditos.getGrupoID()));
									sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditos.getPolizaID()));
									sentenciaStore.setString("Par_FechaMinis",Utileria.convierteFecha(creditos.getFechaMinistrado()));
									sentenciaStore.setString("Par_OrigenPago",Constantes.STRING_VACIO);
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
									// logea el call enviado al Stored Procedure
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en autorizacion de credito grupal", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// METODO GENERAL PARA CREDITOS AGRO GRUPALES
	public MensajeTransaccionBean creditosGrupalesAgro(final CreditosBean creditos, final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			final long numTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							mensajeBean = creditosGrupalesAgroTrans(creditos, tipoTransaccion, numTransaccion);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if(mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en credito grupal", e);
						}
						return mensajeBean;
					}
				});

		} catch(Exception ex){
			ex.printStackTrace();
		}
		return mensaje;
	}

	public MensajeTransaccionBean pagareCreditoGrupal(final CreditosBean creditos, final int tipoTransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	final String formaPrepago= creditos.getFormaPago();
	transaccionDAO.generaNumeroTransaccion();

	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSGRUPALPRO("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Grupo",Utileria.convierteEntero(creditos.getGrupoID()));
								sentenciaStore.setInt("Par_TipoTran",tipoTransaccion);
								sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditos.getPolizaID()));
								sentenciaStore.setString("Par_FechaMinis",Utileria.convierteFecha(creditos.getFechaMinistrado()));
								sentenciaStore.setString("Par_OrigenPago",Constantes.STRING_VACIO);
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

									//GRABA EL TIPO DE PREPAGO POR CREDITO

									if(formaPrepago.equals("S")){
									 ArrayList listaCreditos = (ArrayList) listaGrid(creditos);
									 if(!listaCreditos.isEmpty() &&  listaCreditos.get(1) != null){
										 	CreditosBean creditos= new CreditosBean();
											for(int i=0; i < listaCreditos.size(); i++){
												creditos = (CreditosBean) listaCreditos.get(i);
												if(!creditos.getTipoPrepago().isEmpty() && creditos.getTipoPrepago() !=null ){
												actualizaPrepago(creditos, Enum_Act_Creditos.actTipoPrepago);
												}
											}
										}

									}

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pagare de credito grupal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//pagare de CreditoGrupal Agro
	public MensajeTransaccionBean creditosGrupalesAgroTrans(final CreditosBean creditos, final int tipoActualizacion, final long numTransacion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREDITOSGRUPOSAGROPRO("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(creditos.getGrupoID()));
								sentenciaStore.setString("Par_FechaMinistra",Utileria.convierteFecha(creditos.getFechaMinistrado()));
								sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditos.getPolizaID()));
								sentenciaStore.setInt("Par_TipoActualiza",tipoActualizacion);
								sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_OTROS);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransacion);
								// logea el call enviado al Stored Procedure
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de credito grupal Agro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Desembolso de crédito grupal este llama al otro método sobrecargado de desembolsoCreditoGrupal pero que le pasan el mismo número de transaccion
	 * @param creditos
	 * @param tipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean desembolsoCreditoGrupal(final CreditosBean creditos, final int tipoTransaccion, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();
			final long numTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
			polizaBean.setConceptoID(CreditosBean.desembolsoCredito);
			polizaBean.setConcepto(CreditosBean.desDesembolsoCredito);

			int contador = 0;
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, numTransaccion);
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String poliza = polizaBean.getPolizaID();
						try {
							creditos.setPolizaID(poliza);
							if(tipoTransaccion== Enum_Tra_Creditos.desembolsoGrupal){
								mensajeBean = desembolsoCreditoGrupales(creditos, tipoTransaccion, numTransaccion);
							}else if(tipoTransaccion== Enum_Tra_Creditos.desembolsoGrupalAgro){
								mensajeBean = creditosGrupalesAgroTrans(creditos, tipoActualizacion, numTransaccion);
							}
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if(mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en desembolso de credito grupal", e);
						}
						return mensajeBean;
					}
				});
				/* Baja de Poliza en caso de que haya ocurrido un error */
				if (mensaje.getNumero() != 0) {
					try {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("CreditosDAO.desembolsoCreditoGrupal");
						bajaPolizaBean.setPolizaID(creditos.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error("CreditosDAO.desembolsoCreditoGrupal: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				/* Fin Baja de la Poliza Contable*/
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		} catch(Exception ex){
			ex.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Desembolso de creditos grupales
	 * @param creditos Bean del credito
	 * @param tipoTransaccion tipo de transaccion 16
	 * @param numTransaccion Numero de transaccion
	 * @return
	 */
	public MensajeTransaccionBean desembolsoCreditoGrupales(final CreditosBean creditos, final int tipoTransaccion, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREDITOSGRUPALPRO("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_Grupo", Utileria.convierteEntero(creditos.getGrupoID()));
									sentenciaStore.setInt("Par_TipoTran", tipoTransaccion);
									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditos.getPolizaID()));
									sentenciaStore.setString("Par_FechaMinis", Utileria.convierteFecha(creditos.getFechaMinistrado()));
									sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_OTROS);
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
										DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en desembolso de credito grupal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean altaAccesorios(final CreditosBean creditos) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETALLEACCESORIOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								sentenciaStore.setDouble("Par_ProductoCreditoID",Utileria.convierteEntero(creditos.getProducCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
								sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteLong(creditos.getNumTransacSim()));

								sentenciaStore.setString("Par_PlazoID",creditos.getPlazoID());
								sentenciaStore.setString("Par_TipoOperacion",creditos.getTipoOpera());
								sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(creditos.getMontoCredito())); //Monto solicitud
								sentenciaStore.setLong("Par_ConvenioNominaID", Utileria.convierteLong(creditos.getConvenioNominaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de detalle de Accesorios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean EvaluaGarantiaLiquida(final CreditosBean creditos,final long numeroTransaccion) {
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
								String query = "call GARANTIALIQUIDAPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
								sentenciaStore.setString("Par_EsPrePago",esPrepago);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setString("Par_Salida",salidaPantalla);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
								sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_CARGO_CUENTA);

								sentenciaStore.setString("Par_Origen", "S");
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago del credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/* Consulta Transacciones y actualizacion del campo numTransacSim de la tabla creditos*/
	public CreditosBean consultaNumTransaccion(CreditosBean creditosBean,
			int tipoConsulta) {
		bajaEnTemporal(creditosBean);
		// Query con el Store Procedure
		String query = " call TRANSACCIONESCON(?,?);";
		Object[] parametros = {
							 creditosBean.getCreditoID(),
							 tipoConsulta};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setNumTransacSim(String.valueOf(resultSet.getString(1)));

			return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/* Consuta Creditos por Llave Principal */
	public CreditosBean consultaPrincipal(CreditosBean creditosBean, int tipoConsulta) {
		// Query con el Store Procedure
		try {
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(String.valueOf(resultSet.getLong(1)));
						creditosBean.setClienteID(String.valueOf(resultSet.getInt(2)));
						creditosBean.setLineaCreditoID(String.valueOf(resultSet.getInt(3)));
						creditosBean.setProducCreditoID(String.valueOf(resultSet.getInt(4)));
						creditosBean.setCuentaID(String.valueOf(resultSet.getLong(5)));
						creditosBean.setRelacionado(String.valueOf(resultSet.getLong(6)));
						creditosBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(7)));
						creditosBean.setMontoCredito(resultSet.getString(8));
						creditosBean.setMonedaID(String.valueOf(resultSet.getInt(9)));
						creditosBean.setFechaInicio(resultSet.getString(10));
						creditosBean.setFechaVencimien(resultSet.getString(11));
						creditosBean.setFactorMora(String.valueOf(resultSet.getDouble(12)));
						creditosBean.setCalcInteresID(String.valueOf(resultSet.getInt(13)));
						creditosBean.setTasaBase(String.valueOf(resultSet.getInt(14)));
						creditosBean.setTasaFija(String.valueOf(resultSet.getDouble(15)));
						creditosBean.setSobreTasa(String.valueOf(resultSet.getDouble(16)));
						creditosBean.setPisoTasa(String.valueOf(resultSet.getDouble(17)));
						creditosBean.setTechoTasa(String.valueOf(resultSet.getDouble(18)));
						creditosBean.setFechaInhabil(resultSet.getString(19));
						creditosBean.setAjusFecExiVen(resultSet.getString(20));
						creditosBean.setCalendIrregular(resultSet.getString(21));
						creditosBean.setAjusFecUlVenAmo(resultSet.getString(22));
						creditosBean.setTipoPagoCapital(resultSet.getString(23));
						creditosBean.setFrecuenciaInt(resultSet.getString(24));
						creditosBean.setFrecuenciaCap(resultSet.getString(25));
						creditosBean.setPeriodicidadInt(String.valueOf(resultSet.getInt(26)));
						creditosBean.setPeriodicidadCap(String.valueOf(resultSet.getInt(27)));
						creditosBean.setDiaPagoInteres(resultSet.getString(28));
						creditosBean.setDiaPagoCapital(resultSet.getString(29));
						creditosBean.setDiaMesInteres(String.valueOf(resultSet.getInt(30)));
						creditosBean.setDiaMesCapital(String.valueOf(resultSet.getInt(31)));
						creditosBean.setInstitFondeoID(String.valueOf(resultSet.getInt(32)));
						creditosBean.setLineaFondeo(String.valueOf(resultSet.getInt(33)));
						creditosBean.setEstatus(resultSet.getString(34));
						creditosBean.setFechTraspasVenc(resultSet.getString(35));
						creditosBean.setFechTerminacion(resultSet.getString(36));
						creditosBean.setNumAmortizacion(String.valueOf(resultSet.getInt(37)));
						creditosBean.setNumTransacSim(String.valueOf(resultSet.getInt(38)));
						creditosBean.setFactorMora(resultSet.getString(39));
						creditosBean.setFechaMinistrado(resultSet.getString(40));
						creditosBean.setTipoFondeo(resultSet.getString(41));
						creditosBean.setFechaAutoriza(resultSet.getString(42));
						creditosBean.setUsuarioAutoriza(String.valueOf(resultSet.getInt(43)));
						creditosBean.setMontoComision(resultSet.getString(44));
						creditosBean.setIVAComApertura(resultSet.getString(45));
						creditosBean.setCat(String.valueOf(resultSet.getDouble(46)));
						creditosBean.setPlazoID(resultSet.getString(47));
						creditosBean.setTipoDispersion(resultSet.getString(48));
						creditosBean.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
						creditosBean.setTipoCalInteres(String.valueOf(resultSet.getInt(50)));
						creditosBean.setDestinoCreID(String.valueOf(resultSet.getInt(51)));
						creditosBean.setNumAmortInteres(String.valueOf(resultSet.getInt(52)));
						creditosBean.setMontoCuota(String.valueOf(resultSet.getString(53)));
						creditosBean.setComentarioMesaControl(resultSet.getString(54));
						creditosBean.setTotalAdeudo(resultSet.getString(55));
						creditosBean.setTotalExigible(resultSet.getString(56));
						creditosBean.setDiasFaltaPago(resultSet.getString(57));
						creditosBean.setMontoSeguroVida(resultSet.getString(58));
						creditosBean.setAporteCliente(resultSet.getString("AporteCliente"));
						creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
						creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
						creditosBean.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
						creditosBean.setMontoGLAho(resultSet.getString("MontoGLAho")); // monto de garantia liquida que son bloqueos de saldo de la cuenta
						creditosBean.setMontoGLInv(resultSet.getString("MontoGLInv")); // monto de garantia liquida que son por inversiones
						creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiq")); // monto total depositado por garantia liquida de inversion o de cuenta
						creditosBean.setGrupoID(resultSet.getString("GrupoID")); // Grupo de credito
						creditosBean.setFechaInicioAmor(resultSet.getString("FechaInicioAmor")); // Fecha de inicio de amortizaciones creditos
						creditosBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida")); // Forma de cobro del seguro de vida
						creditosBean.setForCobroComAper(resultSet.getString("ForCobroComAper")); // Forma de cobro de comision por apertura
						creditosBean.setDiaPagoProd(resultSet.getString("DiaPagoProd")); // Dia de pago de capital-interes segun el producto de credito
						creditosBean.setTipoCredito(resultSet.getString("TipoCredito")); // Tipo de credito Nuevo, Renovacion, Reestructura
						creditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
						creditosBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
						creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
						creditosBean.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
						creditosBean.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
						creditosBean.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
						creditosBean.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));
						creditosBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
						creditosBean.setTipoCancelacion(resultSet.getString("TipoCancelacion"));
						creditosBean.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
						creditosBean.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
						creditosBean.setSubramaFIRAID(resultSet.getString("SubramaFIRAID"));
						creditosBean.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
						creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
						creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
						creditosBean.setFechaCobroComision(resultSet.getString("FechaCobroComision"));
						creditosBean.setEsAutomatico(resultSet.getString("EsAutomatico"));
						creditosBean.setTipoAutomatico(resultSet.getString("TipoAutomatico"));
						creditosBean.setInversionID(resultSet.getString("InvCredAut"));
						creditosBean.setCuentaAhoID(resultSet.getString("CtaCredAut"));
						creditosBean.setEsReacreditado(resultSet.getString("Reacreditado"));
						creditosBean.setCobraAccesorios(resultSet.getString("cobraAccesorios"));
						creditosBean.setReferenciaPago(resultSet.getString("ReferenciaPago"));
						creditosBean.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
						creditosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
						creditosBean.setFolioSolici(resultSet.getString("FolioSolici"));
						creditosBean.setQuinquenioID(resultSet.getString("QuinquenioID"));
						creditosBean.setClabeDomiciliacion(resultSet.getString("ClabeDomiciliacion"));
						creditosBean.setEsConsolidacionAgro(resultSet.getString("EsConsolidacionAgro"));
						creditosBean.setFlujoOrigen(resultSet.getString("FlujoOrigen"));

						creditosBean.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
						creditosBean.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
						creditosBean.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
						creditosBean.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
						creditosBean.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
						creditosBean.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));
						creditosBean.setMontoCobComAdmon(resultSet.getString("MontoCobComAdmon"));

						creditosBean.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
						creditosBean.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
						creditosBean.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
						creditosBean.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
						creditosBean.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
						creditosBean.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));
						creditosBean.setMontoCobComGarantia(resultSet.getString("MontoCobComGarantia"));
						creditosBean.setMontoPagComGarantiaSim(resultSet.getString("MontoPagComGarantiaSim"));
						creditosBean.setRefPayCash(resultSet.getString("RefPayCash"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;

				}
			});

			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/**
	 * Método que permite realizar la consulta del credito en búsqueda por su institución y convenio.
	 * @param creditosBean Parámetro que guarda el identificador por el cual se realizará la consulta.
	 * @param tipoConsulta Tipo de consulta.
	 * @return Objeto con la información consultada.
	 */
	public CreditosBean consultaInstitucionConvenio(CreditosBean creditosBean, int tipoConsulta) {
		// Query con el Store Procedure
		try {
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(resultSet.getString("CreditoID"));
						creditosBean.setInstitucionNominaID(resultSet.getString("InstitNominaID"));
						creditosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
						creditosBean.setEstatusNomina(resultSet.getString("EstatusNomina"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;

				}
			});

			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/* Consuta Creditos por Llave Principal */
	public CreditosBean consultaPrincipalAgro(CreditosBean creditosBean, int tipoConsulta) {
		// Query con el Store Procedure
		try {
			String query = "call CREDITOSAGROCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSAGROCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(String.valueOf(resultSet.getLong(1)));
						creditosBean.setClienteID(String.valueOf(resultSet.getInt(2)));
						creditosBean.setLineaCreditoID(String.valueOf(resultSet.getInt(3)));
						creditosBean.setProducCreditoID(String.valueOf(resultSet.getInt(4)));
						creditosBean.setCuentaID(String.valueOf(resultSet.getLong(5)));
						creditosBean.setRelacionado(String.valueOf(resultSet.getLong(6)));
						creditosBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(7)));
						creditosBean.setMontoCredito(resultSet.getString(8));
						creditosBean.setMonedaID(String.valueOf(resultSet.getInt(9)));
						creditosBean.setFechaInicio(resultSet.getString(10));
						creditosBean.setFechaVencimien(resultSet.getString(11));
						creditosBean.setFactorMora(String.valueOf(resultSet.getDouble(12)));
						creditosBean.setCalcInteresID(String.valueOf(resultSet.getInt(13)));
						creditosBean.setTasaBase(String.valueOf(resultSet.getInt(14)));
						creditosBean.setTasaFija(String.valueOf(resultSet.getDouble(15)));
						creditosBean.setSobreTasa(String.valueOf(resultSet.getDouble(16)));
						creditosBean.setPisoTasa(String.valueOf(resultSet.getDouble(17)));
						creditosBean.setTechoTasa(String.valueOf(resultSet.getDouble(18)));
						creditosBean.setFechaInhabil(resultSet.getString(19));
						creditosBean.setAjusFecExiVen(resultSet.getString(20));
						creditosBean.setCalendIrregular(resultSet.getString(21));
						creditosBean.setAjusFecUlVenAmo(resultSet.getString(22));
						creditosBean.setTipoPagoCapital(resultSet.getString(23));
						creditosBean.setFrecuenciaInt(resultSet.getString(24));
						creditosBean.setFrecuenciaCap(resultSet.getString(25));
						creditosBean.setPeriodicidadInt(String.valueOf(resultSet.getInt(26)));
						creditosBean.setPeriodicidadCap(String.valueOf(resultSet.getInt(27)));
						creditosBean.setDiaPagoInteres(resultSet.getString(28));
						creditosBean.setDiaPagoCapital(resultSet.getString(29));
						creditosBean.setDiaMesInteres(String.valueOf(resultSet.getInt(30)));
						creditosBean.setDiaMesCapital(String.valueOf(resultSet.getInt(31)));
						creditosBean.setInstitFondeoID(String.valueOf(resultSet.getInt(32)));
						creditosBean.setLineaFondeo(String.valueOf(resultSet.getInt(33)));
						creditosBean.setEstatus(resultSet.getString(34));
						creditosBean.setFechTraspasVenc(resultSet.getString(35));
						creditosBean.setFechTerminacion(resultSet.getString(36));
						creditosBean.setNumAmortizacion(String.valueOf(resultSet.getInt(37)));
						creditosBean.setNumTransacSim(String.valueOf(resultSet.getInt(38)));
						creditosBean.setFactorMora(resultSet.getString(39));
						creditosBean.setFechaMinistrado(resultSet.getString(40));
						creditosBean.setTipoFondeo(resultSet.getString(41));
						creditosBean.setFechaAutoriza(resultSet.getString(42));
						creditosBean.setUsuarioAutoriza(String.valueOf(resultSet.getInt(43)));
						creditosBean.setMontoComision(resultSet.getString(44));
						creditosBean.setIVAComApertura(resultSet.getString(45));
						creditosBean.setCat(String.valueOf(resultSet.getDouble(46)));
						creditosBean.setPlazoID(resultSet.getString(47));
						creditosBean.setTipoDispersion(resultSet.getString(48));
						creditosBean.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
						creditosBean.setTipoCalInteres(String.valueOf(resultSet.getInt(50)));
						creditosBean.setDestinoCreID(String.valueOf(resultSet.getInt(51)));
						creditosBean.setNumAmortInteres(String.valueOf(resultSet.getInt(52)));
						creditosBean.setMontoCuota(String.valueOf(resultSet.getString(53)));
						creditosBean.setComentarioMesaControl(resultSet.getString(54));
						creditosBean.setTotalAdeudo(resultSet.getString(55));
						creditosBean.setTotalExigible(resultSet.getString(56));
						creditosBean.setDiasFaltaPago(resultSet.getString(57));
						creditosBean.setMontoSeguroVida(resultSet.getString(58));
						creditosBean.setAporteCliente(resultSet.getString("AporteCliente"));
						creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
						creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
						creditosBean.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
						creditosBean.setMontoGLAho(resultSet.getString("MontoGLAho")); // monto de garantia liquida que son bloqueos de saldo de la cuenta
						creditosBean.setMontoGLInv(resultSet.getString("MontoGLInv")); // monto de garantia liquida que son por inversiones
						creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiq")); // monto total depositado por garantia liquida de inversion o de cuenta
						creditosBean.setGrupoID(resultSet.getString("GrupoID")); // Grupo de credito
						creditosBean.setFechaInicioAmor(resultSet.getString("FechaInicioAmor")); // Fecha de inicio de amortizaciones creditos
						creditosBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida")); // Forma de cobro del seguro de vida
						creditosBean.setForCobroComAper(resultSet.getString("ForCobroComAper")); // Forma de cobro de comision por apertura
						creditosBean.setDiaPagoProd(resultSet.getString("DiaPagoProd")); // Dia de pago de capital-interes segun el producto de credito
						creditosBean.setTipoCredito(resultSet.getString("TipoCredito")); // Tipo de credito Nuevo, Renovacion, Reestructura
						creditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
						creditosBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
						creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
						creditosBean.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
						creditosBean.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
						creditosBean.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
						creditosBean.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));
						creditosBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
						creditosBean.setTipoCancelacion(resultSet.getString("TipoCancelacion"));
						creditosBean.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
						creditosBean.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
						creditosBean.setSubramaFIRAID(resultSet.getString("SubramaFIRAID"));
						creditosBean.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
						creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
						creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
						creditosBean.setFechaCobroComision(resultSet.getString("FechaCobroComision"));
						creditosBean.setEsAutomatico(resultSet.getString("EsAutomatico"));
						creditosBean.setTipoAutomatico(resultSet.getString("TipoAutomatico"));
						creditosBean.setInversionID(resultSet.getString("InvCredAut"));
						creditosBean.setCuentaAhoID(resultSet.getString("CtaCredAut"));
						creditosBean.setTasaPasiva(resultSet.getString("TasaPasiva"));
						creditosBean.setEsReacreditado(resultSet.getString("Reacreditado"));
						creditosBean.setEsConsolidacionAgro(resultSet.getString("EsConsolidacionAgro"));

						creditosBean.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
						creditosBean.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
						creditosBean.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
						creditosBean.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
						creditosBean.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
						creditosBean.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));
						creditosBean.setMontoCobComAdmon(resultSet.getString("MontoCobComAdmon"));

						creditosBean.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
						creditosBean.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
						creditosBean.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
						creditosBean.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
						creditosBean.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
						creditosBean.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));
						creditosBean.setMontoCobComGarantia(resultSet.getString("MontoCobComGarantia"));
						creditosBean.setMontoPagComGarantiaSim(resultSet.getString("MontoPagComGarantiaSim"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;

				}
			});

			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public CreditosBean consultaContingente(CreditosBean creditosBean, int tipoConsulta) {
		// Query con el Store Procedure
		try {
			String query = "call CREDITOSAGROCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSAGROCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(String.valueOf(resultSet.getLong("CreditoID")));
						creditosBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
						creditosBean.setProducCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
						creditosBean.setCuentaID(String.valueOf(resultSet.getLong("CuentaID")));
						creditosBean.setRelacionado(String.valueOf(resultSet.getLong("Relacionado")));
						creditosBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
						creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
						creditosBean.setMonedaID(String.valueOf(resultSet.getInt("MonedaID")));
						creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
						creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
						creditosBean.setEstatus(resultSet.getString("Estatus"));
						creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
						creditosBean.setTipoFondeo(resultSet.getString("TipoFondeo"));
						creditosBean.setTotalAdeudo(resultSet.getString("TotalAdeudo"));

						creditosBean.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
						creditosBean.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
						creditosBean.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
						creditosBean.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
						creditosBean.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
						creditosBean.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));
						creditosBean.setMontoCobComAdmon(resultSet.getString("MontoCobComAdmon"));

						creditosBean.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
						creditosBean.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
						creditosBean.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
						creditosBean.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
						creditosBean.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
						creditosBean.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));
						creditosBean.setMontoCobComGarantia(resultSet.getString("MontoCobComGarantia"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;

				}
			});

			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	/* Consuta los datos de un credito a renovar agro */
	public CreditosBean consultaCreditoRenovarAgro(CreditosBean creditosBean, int tipoConsulta) {
		try{
		String query = "call CREDITOSAGROCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaCreditoRenovarAgro",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSAGROCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				creditosBean.setRelacionado(resultSet.getString("Relacionado"));
				creditosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				creditosBean.setMonedaID(resultSet.getString("MonedaID"));
				creditosBean.setEstatus(resultSet.getString("Estatus"));
				creditosBean.setDestinoCreID(resultSet.getString("DestinoCreID"));
				creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
				creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				creditosBean.setTipoCredito(resultSet.getString("TipoCredito"));
				creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				creditosBean.setNumRenovaciones(resultSet.getString("NumRenovaciones"));
				creditosBean.setProyecto(resultSet.getString("Proyecto"));
				creditosBean.setEstatusSolici(resultSet.getString("EstatusSolici"));
				creditosBean.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
				creditosBean.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
				creditosBean.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));
				creditosBean.setEstatusGarantiaFIRA(resultSet.getString("EstatusGarantiaFIRA"));
				creditosBean.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
				creditosBean.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
				creditosBean.setSubramaFIRAID(resultSet.getString("SubramaFIRAID"));
				creditosBean.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
				creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
				creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
				creditosBean.setInstitFondeoID(resultSet.getString("InstitFondeoID"));
				creditosBean.setTipoFondeo(resultSet.getString("LineaFondeo"));
				creditosBean.setLineaFondeo(resultSet.getString("TipoFondeo"));
				creditosBean.setPasivoID(resultSet.getString("PasivoID"));
				creditosBean.setAdeudoPasivo(resultSet.getString("AdeudoPasivo"));
				creditosBean.setTotalInteres(resultSet.getString("MontoInteres"));
				creditosBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
				creditosBean.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
				creditosBean.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));

				creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
				creditosBean.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
				creditosBean.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
				creditosBean.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
				creditosBean.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
				creditosBean.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
				creditosBean.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));
				creditosBean.setMontoCobComAdmon(resultSet.getString("MontoCobComAdmon"));

				creditosBean.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
				creditosBean.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
				creditosBean.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
				creditosBean.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
				creditosBean.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
				creditosBean.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));
				creditosBean.setMontoCobComGarantia(resultSet.getString("MontoCobComGarantia"));
				creditosBean.setMontoPagComGarantiaSim(resultSet.getString("MontoPagComGarantiaSim"));

				return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch (Exception ex) {
			ex.printStackTrace();
		}
		return creditosBean;
	}

	/* Consuta impresion de pagare */
	public CreditosBean consultaPagareImp(CreditosBean creditosBean,
			int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagareImp",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setPagareImpreso(resultSet.getString(1));

			return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}



	/* Consuta Creditos por Llave Foranea */
	public CreditosBean consultaForanea(CreditosBean creditosBean,
			int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDISTOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(String.valueOf(resultSet.getLong(1)));
				creditosBean.setLineaCreditoID(String.valueOf(resultSet.getInt(2)));
				creditosBean.setClienteID(String.valueOf(resultSet.getInt(3)));
				creditosBean.setCuentaID(String.valueOf(resultSet.getLong(4)));
				creditosBean.setMonedaID(String.valueOf(resultSet.getInt(5)));
				creditosBean.setEstatus(resultSet.getString(6));
				creditosBean.setEsGrupal(resultSet.getString(7));
				return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/*Consulta Exigible sin proyectar*/
	public CreditosBean consultaExigibleSinProy(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaExigibleSinProy",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try {
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldoCapVenNExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInteresOrd"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInteresVen"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInteresPro"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorato"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SaldoIVAComFalP"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					creditosBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
					creditosBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));

					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));

					creditosBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));
					/* Comision Anual */
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/* Fin Comision Anual */
					/* Nota de cargo */
					creditosBean.setSaldoNotasCargos(resultSet.getString("SaldoNotasCargos"));
				} catch (Exception ex) {
					ex.printStackTrace();
					return null;
				}
				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}


	/**
	 * Consulta para Pago de Crédito,Consulta detalle del total de la deuda SCA
	 * N°7: Consulta de Pago de Crédito
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta;7
	 * @return
	 */
	public CreditosBean consultaPagoCredito(final CreditosBean creditosBean, final int tipoConsulta) {
		//Query con el Store Procedure
		CreditosBean creditosBeanCon = null;
		try{
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	creditosBean.getCreditoID(),
									tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagoCredito",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditosBean creditoBean = new CreditosBean();
					creditoBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					creditoBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					creditoBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditoBean.setSaldCapVenNoExi(resultSet.getString("SaldCapVenNoExi"));
					creditoBean.setSaldNotasCargo(resultSet.getString("SaldoNotasCargo"));

					creditoBean.setSaldoInterOrdin(resultSet.getString("SaldoInterOrdin"));
					creditoBean.setSaldoInterAtras(resultSet.getString("SaldoInterAtras"));
					creditoBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditoBean.setSaldoInterProvi(resultSet.getString("SaldoInterProvi"));
					creditoBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));

					creditoBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
					creditoBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditoBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorator"));
					creditoBean.setSaldoComFaltPago(resultSet.getString("SaldComFaltPago"));
					creditoBean.setSalIVAComFalPag(resultSet.getString("SalIVAComFalPag"));

					creditoBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					/*Comision Anual*/
					creditoBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditoBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/*Fin Comision Anual*/
					creditoBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditoBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditoBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditoBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditoBean.setTotalIVACom(resultSet.getString("totalIVACom"));
					creditoBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));
					return creditoBean;
				}
			});
			creditosBeanCon = matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}
		catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de pago", e);
		}
		return creditosBeanCon;
	}

	/**
	 * Consulta detalle exigible con proyeccion
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta;8
	 * @return
	 */
	public CreditosBean consultaPagoCredExigible(CreditosBean creditosBean, int tipoConsulta) {
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPagoCredExigible",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try {
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldoCapVenNExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInteresOrd"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInteresVen"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInteresPro"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorato"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SaldoIVAComFalP"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));

					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));
					creditosBean.setPagoExigible(resultSet.getString("adeudoTotal"));
					creditosBean.setTotalCuotaAdelantada(Utileria.convierteDoble((resultSet.getString("TotalAdelanto")).replace(",", "")));
					creditosBean.setCuotasAtraso(resultSet.getString("CuotasAtraso"));
					creditosBean.setUltCuotaPagada(resultSet.getString("UltCuotaPagada"));
					creditosBean.setFechaUltCuota(resultSet.getString("FechaUltCuota"));
					creditosBean.setTotalPrimerCuota(resultSet.getString("totalPrimerCuota"));
					//SEGUROS
					creditosBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
					creditosBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));
					creditosBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
					/* Comision Anual */
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/* Fin Comision Anual */

					double totalExigible = Utileria.convierteDoble((resultSet.getString("adeudoTotal")).replace(",", ""));
					if (totalExigible > Constantes.DOUBLE_VACIO) {

						creditosBean.setTotalExigibleDia(CalculosyOperaciones.resta(totalExigible, creditosBean.getTotalCuotaAdelantada()));
					} else {
						creditosBean.setTotalExigibleDia(Constantes.DOUBLE_VACIO);
					}
				} catch (Exception ex) {
					ex.printStackTrace();
					return null;
				}
				return creditosBean;
			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/*Consulta para pantalla pago de credito (pago exigible (segun amortizaciones vencidas))*/
	public CreditosBean consultaExigibleCondonacion(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosBean.getCreditoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagoCredExigible",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
			    creditosBean.setSaldoCapVigent(resultSet.getString(1));
				creditosBean.setSaldoCapAtrasad(resultSet.getString(2));
				creditosBean.setSaldoCapVencido(resultSet.getString(3));
				creditosBean.setSaldCapVenNoExi(resultSet.getString(4));
			    creditosBean.setSaldoInterOrdin(resultSet.getString(5));
			    creditosBean.setSaldoInterAtras(resultSet.getString(6));
			    creditosBean.setSaldoInterVenc(resultSet.getString(7));
				creditosBean.setSaldoInterProvi(resultSet.getString(8));
				creditosBean.setSaldoIntNoConta(resultSet.getString(9));
				creditosBean.setSaldoIVAInteres(resultSet.getString(10));
				creditosBean.setSaldoMoratorios(resultSet.getString(11));
			    creditosBean.setSaldoIVAMorator(resultSet.getString(12));
			    creditosBean.setSaldoComFaltPago(resultSet.getString(13));
			    creditosBean.setSalIVAComFalPag(resultSet.getString(14));
				creditosBean.setSaldoOtrasComis(resultSet.getString(15));
			    creditosBean.setSaldoIVAComisi(resultSet.getString(16));
			    creditosBean.setTotalCapital(resultSet.getString(17));
			    creditosBean.setTotalInteres(resultSet.getString(18));
			    creditosBean.setTotalComisi(resultSet.getString(19));
			    creditosBean.setTotalIVACom(resultSet.getString(20));
			    creditosBean.setPagoExigible(resultSet.getString(21));
				} catch(Exception ex){
					ex.printStackTrace();
					return null;
				}
				return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/**
	 * Consulta detalle total deuda CCA, Liquidacion anticipada
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta; 17
	 * @return
	 */
	public CreditosBean consultaFiniquitoLiqAnticipada(CreditosBean creditosBean, int tipoConsulta) {
		try {
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { creditosBean.getCreditoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaFiniquitoLiqAnticipada",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
						creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
						creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
						creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldoCapVenNExi"));
						creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInteresOrd"));

						creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
						creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInteresVen"));
						creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInteresPro"));
						creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
						creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

						creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
						creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorato"));
						creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
						creditosBean.setSalIVAComFalPag(resultSet.getString("SaldoIVAComFalP"));
						creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));

						creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
						creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
						creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
						creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
						creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));

						creditosBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));
						creditosBean.setSaldoAdmonComis(resultSet.getString("ComLiqAntici"));
						creditosBean.setSaldoIVAAdmonComisi(resultSet.getString("IVAComLiqAntici"));
						creditosBean.setPermiteFiniquito(resultSet.getString("PermiteLiqAnt"));
						creditosBean.setAdeudoTotalSinIVA(resultSet.getString("adeudoTotalSinIVA"));
						creditosBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
						creditosBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));
						/* Comision Anual */
						creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
						creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
						/* Fin Comision Anual */

						// Notas de cargo
						creditosBean.setSaldoNotasCargo(resultSet.getString("SaldoNotasCargo"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;
				}
			});
			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/* Consulta ventanilla comision por apertura y desembolso de credito*/
	public CreditosBean consultaComDesVent(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(creditosBean.getCreditoID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				    creditosBean.setCuentaID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaID"),CuentasAhoBean.LONGITUD_ID));
				    creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
					creditosBean.setMontoComision(resultSet.getString("MontoComApert"));
					creditosBean.setIVAComApertura(resultSet.getString("IVAComApertura"));
					creditosBean.setForCobroComAper(resultSet.getString("ForCobroComAper"));
					creditosBean.setTotalComAper(resultSet.getString("TotalComision"));
					creditosBean.setMontoPorDesemb(resultSet.getString("MontoPorDesemb"));
					creditosBean.setMontoDesemb(resultSet.getString("MontoDesemb"));
				    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				    creditosBean.setSucursal(resultSet.getString("SucursalID"));
				    creditosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				    creditosBean.setEstatus(resultSet.getString("Estatus"));
				    creditosBean.setTipoDispersion(resultSet.getString("TipoDispersion"));
				    creditosBean.setMontoSeguroVida(resultSet.getString("MontoSeguroVida"));
				    creditosBean.setSeguroVidaPagado(resultSet.getString("SeguroVidaPagado"));
				    creditosBean.setComAperPagado(resultSet.getString("ComAperPagado"));
				    creditosBean.setAporteCliente(resultSet.getString("AporteCliente"));
				    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));



					return creditosBean;

				}
			});
			consultaBean= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de comision porapertura y rembolso", e);
		}
		return consultaBean;
	}

	/*Consulta datos generales del credito y DÃ­as de Atraso*/
	public CreditosBean consultaDiasAtraso(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { Utileria.convierteLong(creditosBean.getCreditoID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditosDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				    creditosBean.setCuentaID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaID"),CuentasAhoBean.LONGITUD_ID));
				    creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
					creditosBean.setMontoComision(resultSet.getString("MontoComApert"));
					creditosBean.setIVAComApertura(resultSet.getString("IVAComApertura"));
					creditosBean.setForCobroComAper(resultSet.getString("ForCobroComAper"));
					creditosBean.setTotalComAper(resultSet.getString("TotalComision"));
					creditosBean.setMontoPorDesemb(resultSet.getString("MontoPorDesemb"));
					creditosBean.setMontoDesemb(resultSet.getString("MontoDesemb"));
				    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				    creditosBean.setSucursal(resultSet.getString("SucursalID"));
				    creditosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				    creditosBean.setEstatus(resultSet.getString("Estatus"));
				    creditosBean.setTipoDispersion(resultSet.getString("TipoDispersion"));
				    creditosBean.setDiasAtraso(resultSet.getString("diasAtraso"));
				    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));


					return creditosBean;

				}
			});
			consultaBean= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos generales del credito y dias de atraso", e);
		}
		return consultaBean;
	}

	/* Consulta ventanilla Datos para el pago de Garantia Liquida. */
	public CreditosBean consultaGLVentanilla(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditosDAO.consultaGLVentanilla",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(2),ClienteBean.LONGITUD_ID));
					creditosBean.setProducCreditoID(resultSet.getString(3));
				    creditosBean.setMontoCredito(resultSet.getString(4));
					creditosBean.setMontoGLDepositado(resultSet.getString(5));
					creditosBean.setMontoPorcGL(resultSet.getString(6));
					creditosBean.setMontoGLSugerido(resultSet.getString(7));
				    creditosBean.setGrupoID(resultSet.getString(8));
				    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
					return creditosBean;
				}
			});
			consultaBean= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de ventanilla para el pago de garantia liquida", e);
		}
		return consultaBean;
	}

	// Consulta de resumen de credito de cliente y su adeudo total
	public CreditosBean consultaResumenClienteCredito(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(2),ClienteBean.LONGITUD_ID));
					creditosBean.setProducCreditoID(resultSet.getString(3));
				    creditosBean.setMontoCredito(resultSet.getString(4));
					creditosBean.setMonedaID(resultSet.getString(5));
					creditosBean.setEstatus(resultSet.getString(6));
					creditosBean.setFechaMinistrado(resultSet.getString(7));
				    creditosBean.setAdeudoTotal(resultSet.getString(8));
					return creditosBean;
				}
			});
			consultaBean= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de regimen del cliente y su adeudo total", e);
		}
		return consultaBean;
	}

	/**
	 * Consulta general de crédito
	 * N°18: Consulta General
	 * @param creditosBean: Bean para realizar la consulta
	 * @param tipoConsulta: Consulta 8
	 * @return
	 */
	public CreditosBean consultaGeneralesCredito(CreditosBean creditosBean, int tipoConsulta) {
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaGeneralesCredito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
			    creditosBean.setCuentaID(resultSet.getString("CuentaID"));

			    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
			    creditosBean.setEstatus(resultSet.getString("Estatus"));
			    creditosBean.setDiasFaltaPago(resultSet.getString("diasFaltaPago"));
			    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
			    creditosBean.setSucursal(resultSet.getString("SucursalID"));

			    creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
			    creditosBean.setMontoCredito(resultSet.getString("montoCredito"));
			    creditosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
			    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
			    creditosBean.setTasaFija(resultSet.getString("TasaFija"));

			    creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
			    creditosBean.setOrigen(resultSet.getString("Origen"));
			    creditosBean.setTasaBase(resultSet.getString("TasaBase"));
			    creditosBean.setSobreTasa(resultSet.getString("SobreTasa"));
			    creditosBean.setPisoTasa(resultSet.getString("PisoTasa"));

			    creditosBean.setTechoTasa(resultSet.getString("TechoTasa"));
			    creditosBean.setCalcInteresID(resultSet.getString("CalcInteresID"));
			    creditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
			    creditosBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
			    creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
			    creditosBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
			    creditosBean.setIdenCreditoCNBV(resultSet.getString("IdenCreditoCNBV"));
			    creditosBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
				} catch(Exception ex){

					ex.printStackTrace();
				}
				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/*Consulta para generales de credito */
	public CreditosBean consultaCreditoPagoVertical(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaCreditoPagoVertical",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
			    creditosBean.setCuentaID(resultSet.getString("CuentaID"));

			    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
			    creditosBean.setEstatus(resultSet.getString("Estatus"));
			    creditosBean.setDiasFaltaPago(resultSet.getString("diasFaltaPago"));
			    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
			    creditosBean.setSucursal(resultSet.getString("SucursalID"));

			    creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
			    creditosBean.setMontoCredito(resultSet.getString("montoCredito"));
			    creditosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
			    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
			    creditosBean.setTasaFija(resultSet.getString("TasaFija"));

			    creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
			    creditosBean.setOrigen(resultSet.getString("Origen"));
				} catch(Exception ex){
					ex.printStackTrace();
					return  null;
				}

			    return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/**
	 * Consulta No. 26: Regresa el número de créditos vigentes, pagados y vencidos que cobran seguro por cuota.
	 * @author avelasco
	 * @param creditosBean : Clase bean con los valores de los parámetros de entrada al sp (No se ocupa).
	 * @param tipoConsulta : Número de consulta.
	 * @return CreditosBean : Resultado de la consulta (total de créditos que sí cobran seguro por cuota).
	 */
	public CreditosBean consultaCredConSeguro(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"CreditosDAO.consultaCredConSeguro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setTotalCreditos(resultSet.getString("TotalCreditos"));
			    return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	// Consulta de tasa de creditos (de esquema de tasas) cuando el credito es sin solicitud
		public CreditosBean consultaTasaCredito(CreditosBean creditosBean, int tipoConsulta) {
			//Query con el Store Procedure

			String query = "call CREDITOSTASASCON(?,?, ?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	creditosBean.getClienteID(),
									creditosBean.getSucursal(),
									creditosBean.getProducCreditoID(),
									creditosBean.getMontoCredito(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									creditosBean.getFechaActual(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSTASASCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditosBean creditosBean = new CreditosBean();
				    creditosBean.setTasaFija(String.valueOf(resultSet.getDouble(1)));
					creditosBean.setSobreTasa(String.valueOf(resultSet.getDouble(2)));
					return creditosBean;
				}
			});
			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}


	// Consulta que devuelve la ultima Fecha de corte solo si la fecha indicada no devuelve datos
	public CreditosBean consultaFechaCorte(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		CreditosBean creditosBeanCon = null;
		try{
		String query = "call SALDOSCREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosBean.getFechaCorte(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								creditosBean.getFechaActual(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setFechaCorte(resultSet.getString(1));
				return creditosBean;
			}
		});
		creditosBeanCon = matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}
		catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de ultima fecha de corte", e);
		}
		return creditosBeanCon;
	}

	/*Consulta de CreditosWS para carga de archivo de pagos */
	public CreditosBean consultaCreditoWS(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaCreditoWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(Utileria.completaCerosIzquierda(
						resultSet.getInt("ClienteID"),CreditosBean.LONGITUD_ID));
				creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));

			    return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}


	/*Consulta detalle exigible con proyeccion  para mostrarlos en banca en linea*/
	public CreditosBean consultaCreditosBEWS(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure

		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosBean.getCreditoID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagoCredExigible",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();

				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setCuentaID(resultSet.getString("CuentaID"));
				creditosBean.setEstatus(resultSet.getString("Estatus"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				creditosBean.setDescripcionCredito(resultSet.getString("DescripcionCredito"));
				creditosBean.setMonedaID(resultSet.getString("TipoMoneda"));
				creditosBean.setValorCat(resultSet.getString("ValorCat"));
				creditosBean.setTasaFija(resultSet.getString("TasaFija"));
				creditosBean.setDiasAtraso(resultSet.getString("DiasFaltaPago"));
				creditosBean.setTotalAdeudo(resultSet.getString("TotalDeuda"));
				creditosBean.setMontoExigible(resultSet.getString("MontoExigible"));
				creditosBean.setFechaProxPago(resultSet.getString("ProxFechaPag"));
				creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
				creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
				creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
				creditosBean.setSaldoInteresVig(resultSet.getString("SaldoInteresVig"));
				creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAIntVig"));
				creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
				creditosBean.setSaldoIVAMorato(resultSet.getString("SaldoIVAMorato"));
				creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
				creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
				creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
				creditosBean.setSaldoIVAComFaltaP(resultSet.getString("SaldoIVAComFalP"));

				creditosBean.setSaldoIVAAtrasa(resultSet.getString("SaldoIVAAtrasa"));
			    return creditosBean;
			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}




	/* Consuta los datos de un credito a renovar */
	public CreditosBean consultaCreditoRenovar(CreditosBean creditosBean, int tipoConsulta) {
		String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaCreditoRenovar",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				creditosBean.setRelacionado(resultSet.getString("Relacionado"));
				creditosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				creditosBean.setMonedaID(resultSet.getString("MonedaID"));
				creditosBean.setEstatus(resultSet.getString("Estatus"));
				creditosBean.setDestinoCreID(resultSet.getString("DestinoCreID"));
				creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
				creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				creditosBean.setTipoCredito(resultSet.getString("TipoCredito"));
				creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				creditosBean.setNumRenovaciones(resultSet.getString("NumRenovaciones"));
				creditosBean.setProyecto(resultSet.getString("Proyecto"));
				creditosBean.setEstatusSolici(resultSet.getString("EstatusSolici"));
				creditosBean.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
				creditosBean.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
				creditosBean.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));

				return creditosBean;
			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/* Consuta los datos de un credito a reestructurar */
	public CreditosBean consultaCreditoReestructurar(final CreditosBean creditosBean, final int tipoConsulta) {
		//Query con el Store Procedure
		CreditosBean creditosBeanCon = null;
		try{
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaCreditoReestructurar",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditoBean = new CreditosBean();
					creditoBean.setCreditoID(resultSet.getString("CreditoID"));
					creditoBean.setClienteID(resultSet.getString("ClienteID"));
					creditoBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					creditoBean.setRelacionado(resultSet.getString("Relacionado"));
					creditoBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					creditoBean.setMonedaID(resultSet.getString("MonedaID"));
					creditoBean.setEstatus(resultSet.getString("Estatus"));
					creditoBean.setDestinoCreID(resultSet.getString("DestinoCreID"));
					creditoBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
					creditoBean.setGrupoID(resultSet.getString("GrupoID"));
					creditoBean.setTipoCredito(resultSet.getString("TipoCredito"));
					creditoBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditoBean.setHoraVeri(resultSet.getString("HorarioVeri"));
					creditoBean.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
					creditoBean.setFolioCtrl(resultSet.getString("FolioCtrl"));
					creditoBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditoBean.setFechaInicioAmor(resultSet.getString("FechaInicioAmor"));
					creditoBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					creditoBean.setPlazoID(resultSet.getString("PlazoID"));
					creditoBean.setAporteCliente(resultSet.getString("AporteCliente"));
					creditoBean.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
					creditoBean.setTipoCalInteres(resultSet.getString("TipoCalInteres"));
					creditoBean.setCalcInteresID(resultSet.getString("CalcInteresID"));
					creditoBean.setTasaBase(resultSet.getString("TasaBase"));
					creditoBean.setTasaFija(resultSet.getString("TasaFija"));
					creditoBean.setSobreTasa(resultSet.getString("SobreTasa"));
					creditoBean.setPisoTasa(resultSet.getString("PisoTasa"));
					creditoBean.setTechoTasa(resultSet.getString("TechoTasa"));
					creditoBean.setFactorMora(resultSet.getString("FactorMora"));
					creditoBean.setFechaInhabil(resultSet.getString("FechaInhabil"));
					creditoBean.setNumReestructuras(resultSet.getString("NumReestructuras"));
					creditoBean.setProyecto(resultSet.getString("Proyecto"));
					creditoBean.setEstatusSolici(resultSet.getString("EstatusSolici"));
					creditoBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
					creditoBean.setTipoConsultaSIC(resultSet.getString("TipoConsultaSIC"));
					creditoBean.setFolioConsultaBC(resultSet.getString("FolioConsultaBC"));
					creditoBean.setFolioConsultaCC(resultSet.getString("FolioConsultaCC"));
					creditoBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					/* Datos para Credito Agropecuaros FIRA */
					creditoBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
					creditoBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
					creditoBean.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
					creditoBean.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));

					creditoBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					creditoBean.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
					creditoBean.setComAdmonLinPrevLiq(resultSet.getString("ComAdmonLinPrevLiq"));
					creditoBean.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
					creditoBean.setForPagComAdmon(resultSet.getString("ForPagComAdmon"));
					creditoBean.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));
					creditoBean.setMontoPagComAdmon(resultSet.getString("MontoPagComAdmon"));
					creditoBean.setMontoCobComAdmon(resultSet.getString("MontoCobComAdmon"));

					creditoBean.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
					creditoBean.setComGarLinPrevLiq(resultSet.getString("ComGarLinPrevLiq"));
					creditoBean.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
					creditoBean.setForPagComGarantia(resultSet.getString("ForPagComGarantia"));
					creditoBean.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
					creditoBean.setMontoPagComGarantia(resultSet.getString("MontoPagComGarantia"));
					creditoBean.setMontoCobComGarantia(resultSet.getString("MontoCobComGarantia"));
					creditoBean.setMontoPagComGarantiaSim(resultSet.getString("MontoPagComGarantiaSim"));
					return creditoBean;
				}
			});

			creditosBeanCon = matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}
		catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Reestructuras", e);
		}
		return creditosBeanCon;
	}



	/* Consuta Creditos por Llave Principal */
	public CreditosBean consultaCredCond(CreditosBean creditosBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaCredCond",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
				creditosBean.setCreditoID(String.valueOf(resultSet.getLong(1)));
				creditosBean.setClienteID(String.valueOf(resultSet.getInt(2)));
				creditosBean.setLineaCreditoID(String.valueOf(resultSet.getInt(3)));
				creditosBean.setProducCreditoID(String.valueOf(resultSet.getInt(4)));
			    creditosBean.setCuentaID(String.valueOf(resultSet.getLong(5)));
			    creditosBean.setRelacionado(String.valueOf(resultSet.getLong(6)));
			    creditosBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt(7)));
			    creditosBean.setMontoCredito(resultSet.getString(8));
			    creditosBean.setMonedaID(String.valueOf(resultSet.getInt(9)));
			    creditosBean.setFechaInicio(resultSet.getString(10));
			    creditosBean.setFechaVencimien(resultSet.getString(11));
			    creditosBean.setFactorMora(String.valueOf( resultSet.getDouble(12)));
			    creditosBean.setCalcInteresID(String.valueOf(resultSet.getInt(13)));
			    creditosBean.setTasaBase(String.valueOf(resultSet.getInt(14)));
			    creditosBean.setTasaFija(String.valueOf(resultSet.getDouble(15)));
			    creditosBean.setSobreTasa(String.valueOf(resultSet.getDouble(16)));
			    creditosBean.setPisoTasa(String.valueOf(resultSet.getDouble(17)));
			    creditosBean.setTechoTasa(String.valueOf(resultSet.getDouble(18)));
			    creditosBean.setFechaInhabil(resultSet.getString(19));
			    creditosBean.setAjusFecExiVen(resultSet.getString(20));
				creditosBean.setCalendIrregular(resultSet.getString(21));
				creditosBean.setAjusFecUlVenAmo(resultSet.getString(22));
			    creditosBean.setTipoPagoCapital(resultSet.getString(23));
				creditosBean.setFrecuenciaInt(resultSet.getString(24));
			    creditosBean.setFrecuenciaCap(resultSet.getString(25));
			    creditosBean.setPeriodicidadInt(String.valueOf(resultSet.getInt(26)));
			    creditosBean.setPeriodicidadCap(String.valueOf(resultSet.getInt(27)));
				creditosBean.setDiaPagoInteres(resultSet.getString(28));
				creditosBean.setDiaPagoCapital(resultSet.getString(29));
				creditosBean.setDiaMesInteres(String.valueOf(resultSet.getInt(30)));
				creditosBean.setDiaMesCapital(String.valueOf(resultSet.getInt(31)));
				creditosBean.setInstitFondeoID(String.valueOf(resultSet.getInt(32)));
				creditosBean.setLineaFondeo(String.valueOf(resultSet.getInt(33)));
				creditosBean.setEstatus(resultSet.getString(34));
				creditosBean.setFechTraspasVenc(resultSet.getString(35));
				creditosBean.setFechTerminacion(resultSet.getString(36));
				creditosBean.setNumAmortizacion(String.valueOf(resultSet.getInt(37)));
				creditosBean.setNumTransacSim(String.valueOf(resultSet.getInt(38)));
				creditosBean.setFactorMora(resultSet.getString(39));
				creditosBean.setFechaMinistrado(resultSet.getString(40));
				creditosBean.setTipoFondeo(resultSet.getString(41));
				creditosBean.setFechaAutoriza(resultSet.getString(42));
				creditosBean.setUsuarioAutoriza(String.valueOf(resultSet.getInt(43)));
				creditosBean.setMontoComision(resultSet.getString(44));
				creditosBean.setIVAComApertura(resultSet.getString(45));
				creditosBean.setCat(String.valueOf(resultSet.getDouble(46)));
				creditosBean.setPlazoID(resultSet.getString(47));
				creditosBean.setTipoDispersion(resultSet.getString(48));
				creditosBean.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
				creditosBean.setTipoCalInteres(String.valueOf(resultSet.getInt(50)));
				creditosBean.setDestinoCreID(String.valueOf(resultSet.getInt(51)));
				creditosBean.setNumAmortInteres(String.valueOf(resultSet.getInt(52)));
				creditosBean.setMontoCuota(String.valueOf(resultSet.getString(53)));
				creditosBean.setComentarioMesaControl(resultSet.getString(54));
				creditosBean.setTotalAdeudo(resultSet.getString(55));
				creditosBean.setTotalExigible(resultSet.getString(56));
				creditosBean.setDiasFaltaPago(resultSet.getString(57));
				creditosBean.setMontoSeguroVida(resultSet.getString(58));
				creditosBean.setAporteCliente(resultSet.getString(59));
				creditosBean.setClasiDestinCred(resultSet.getString(60));
				creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
				creditosBean.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
				creditosBean.setMontoGLAho(resultSet.getString("MontoGLAho")); // monto de garantia liquida que son bloqueos de saldo de la cuenta
				creditosBean.setMontoGLInv(resultSet.getString("MontoGLInv")); // monto de garantia liquida que son por inversiones
				creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiq")); // monto total depositado por garantia liquida de inversion o de cuenta
				creditosBean.setGrupoID(resultSet.getString("GrupoID")); // Grupo de credito
				creditosBean.setFechaInicioAmor(resultSet.getString("FechaInicioAmor")); // Fecha de inicio de amortizaciones creditos
				creditosBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida")); // Forma de cobro del seguro de vida
				creditosBean.setForCobroComAper(resultSet.getString("ForCobroComAper")); // Forma de cobro de comision por apertura
				creditosBean.setDiaPagoProd(resultSet.getString("DiaPagoProd")); // Dia de pago de capital-interes segun el producto de credito
				creditosBean.setTipoCredito(resultSet.getString("TipoCredito")); // Tipo de credito Nuevo, Renovacion, Reestructura
				creditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
				creditosBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
				creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				creditosBean.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
				creditosBean.setEstCondicionado(resultSet.getString("Condicionada")); // Estatus de la Solicitud de Credito, si esta condicionada o no.
				creditosBean.setInstitucionNominaID(resultSet.getString("InstitucionNominaID"));
				creditosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				creditosBean.setFolioSolici(resultSet.getString("FolioSolici"));
				creditosBean.setQuinquenioID(resultSet.getString("QuinquenioID"));
				} catch(Exception ex){
					ex.printStackTrace();
					return null;
				}

				return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/*Consulta para generales de credito */
	public CreditosBean consultaCobComApertCargoCta(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaGeneralesCredito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
				creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
			    creditosBean.setCuentaID(resultSet.getString("CuentaID"));

			    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
			    creditosBean.setEstatus(resultSet.getString("Estatus"));
			    creditosBean.setDiasFaltaPago(resultSet.getString("diasFaltaPago"));
			    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
			    creditosBean.setSucursal(resultSet.getString("SucursalID"));

			    creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
			    creditosBean.setMontoCredito(resultSet.getString("montoCredito"));
			    creditosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
			    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
			    creditosBean.setTasaFija(resultSet.getString("TasaFija"));

			    creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));
			    creditosBean.setOrigen(resultSet.getString("Origen"));
			    creditosBean.setTasaBase(resultSet.getString("TasaBase"));
			    creditosBean.setSobreTasa(resultSet.getString("SobreTasa"));
			    creditosBean.setPisoTasa(resultSet.getString("PisoTasa"));

			    creditosBean.setTechoTasa(resultSet.getString("TechoTasa"));
			    creditosBean.setCalcInteresID(resultSet.getString("CalcInteresID"));
			    creditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
			    creditosBean.setCobraIVASeguroCuota(resultSet.getString("CobraIVASeguroCuota"));
			    creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
			    creditosBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
			    creditosBean.setMontoComApertura(resultSet.getString("MontoComApertura"));
			    creditosBean.setIVAComisionApert(resultSet.getString("MontoIVAComApertura"));
			    creditosBean.setOtrasComAnt(resultSet.getString("OtrasComAntic"));
			    creditosBean.setOtrasComAntIVA(resultSet.getString("IVAOtrasComAnt"));

				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/* Consuta Creditos por Llave Foranea */
	public CreditosBean consultaFinMes(CreditosBean creditosBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "select FNOBTIENEFINMES(?);";

		Object[] parametros = { creditosBean.getFechaFinRep()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FNOBTIENEFINMES(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setFechaFinRep(resultSet.getString(1));


				return creditosBean;

			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/**
	 * Metodo para obtener la lista de accesorios, temporal para la narrativa SantaFe
	 * @param tipoConsulta
	 * @param credito
	 * @return Lista de accesorios
	 */
	public CreditosBean consultaAccesorios(CreditosBean credito, int tipoConsulta) {
		CreditosBean creditoBean = null;
		try {
			String query = "CALL ACCESORIOSCON("
								+ "?,?,?,?,?,"
								+ "?,?,?,?,?,"
								+ "?,?,?);";
			Object[] parametros = {
					tipoConsulta,
					Utileria.convierteEntero(credito.getProducCreditoID()),
					Utileria.convierteEntero(credito.getPlazoID()),
					Utileria.convierteEntero(credito.getCicloCliente()),
					Utileria.convierteDoble(credito.getMontoPorDesemb()), //monto solicitud
					Utileria.convierteEntero(credito.getConvenioNominaID()),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaAccesorios",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ACCESORIOSCON(  " + Arrays.toString(parametros) + ")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CreditosBean creditosBean = new CreditosBean();
						try {
							creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
							creditosBean.setPlazoID(resultSet.getString("PlazoID"));
						}catch(Exception ex) {
							ex.printStackTrace();
							return null;
						}
						return creditosBean;
					}
				});
			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al obtener Accesorios" + e);
		}
		return null;
	}

	/* Consulta para obtener datos del aduedo de Garantia FOGAFI de un Crédito */
	public CreditosBean consultaGarFOGAFI(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean consultaBean = null;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSCON(?,?,?,?,?,?,?,?,?);";

			Object[] parametros = { creditosBean.getCreditoID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditosDAO.consultaGLVentanilla",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				    creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setMontoGLDepositado(resultSet.getString("MontoBloqueadoFOGAFI"));
					creditosBean.setMontoPorcGL(resultSet.getString("MontoGarFOGAFI"));
					creditosBean.setMontoGLSugerido(resultSet.getString("SaldoFOGAFI"));
				    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
				    creditosBean.setModalidadFOGAFI(resultSet.getString("ModalidadFOGAFI"));
				    creditosBean.setPorcentajeFOGAFI(resultSet.getString("PorcGarFOGAFI"));

					return creditosBean;
				}
			});
			consultaBean= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de ventanilla para el pago de garantia liquida", e);
		}
		return consultaBean;
	}

	public CreditosBean consultaFOGAFI(CreditosBean creditosBean, int tipoConsulta){
		CreditosBean consultaBean = null;
		try{
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaVentanilla",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON("+ Arrays.toString(parametros) +")");
			List matches = ( (JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos()) ).query(query, parametros, new RowMapper(){
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					CreditosBean creditosBean = new CreditosBean();

					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setMontoFOGAFI(resultSet.getString("montoFOGAFI"));

					return creditosBean;
				}
			});

			consultaBean = matches.size() > 0 ? (CreditosBean) matches.get(0) : null ;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en consulta de FOGAFI");
		}
		return consultaBean;
	}

	// Consulta de Créditos con Montos Autorizados Modificados
	public CreditosBean consultaMontoAutoMod(CreditosBean creditosBean, int tipoConsulta){
		CreditosBean consultaBean = null;
		try{
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaMontoAutoMod",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON("+ Arrays.toString(parametros) +")");
			List matches = ( (JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos()) ).query(query, parametros, new RowMapper(){
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					CreditosBean creditosBean = new CreditosBean();

					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setMontoCredito(resultSet.getString("MontoOriginal"));
					creditosBean.setMontoModificado(resultSet.getString("MontoModificado"));
					creditosBean.setSimulado(resultSet.getString("Simulado"));

					return creditosBean;
				}
			});

			consultaBean = matches.size() > 0 ? (CreditosBean) matches.get(0) : null ;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en consulta de Créditos con Montos Autorizados Modificados.");
		}
		return consultaBean;
	}

	/* Lista de Linea Creditos */
	public List listaPrincipal(CreditosBean creditosBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getCreditoID(),
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString(1));
				creditosBean.setClienteID(resultSet.getString(2));
				creditosBean.setEstatus(resultSet.getString(3));
				creditosBean.setFechaInicio(resultSet.getString(4));
				creditosBean.setFechaVencimien(resultSet.getString(5));
				creditosBean.setNombreProducto(resultSet.getString(6));
				return creditosBean;
			}
		});

		return matches;
	}


	/* Lista de creditos vigentes*/
	public List listaCreditosVigentes(CreditosBean creditosBean, int tipoLista) {
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos vigentes", e);
		}
		return listaCredVig;
	}

	/* Listado de Creditos por Clientes */
	public List listaCreditosCliente(CreditosBean creditosBean, int tipoLista) {
		List creditosLis = null;
		try{
			// Query con el Store Procedure

			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.STRING_CERO,
						    		creditosBean.getClienteID(),
						    		Constantes.FECHA_VACIA,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCreditosCliente",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setCreditoProductoMonto(resultSet.getString(2));
					return creditosBean;
				}
			});

			creditosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de clientes vigentes", e);
		}
		return creditosLis;
	}

	/* Listado de Creditos que se puedan usar como referencia en bloqueo de saldo por garantia liquida*/
	public List listaCreditoBloqueaSaldo(CreditosBean creditosBean, int tipoLista) {
		List creditosLis = null;
		try{
			// Query con el Store Procedure

			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.STRING_CERO,
						    		creditosBean.getClienteID(),
						    		Constantes.FECHA_VACIA,
									tipoLista,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaTipoBloq",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setCredito_Descripcion_Monto(resultSet.getString("Credito_Descripcion_Monto"));
					return creditosBean;
				}
			});
			creditosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para garantia liquida", e);
		}
		return creditosLis;
	}


	public List listaCreditosBean(CreditosBean creditosBean, int tipoLista) {
		String query = "call CALAMORTIPRO(?,? ,?,?);";
		Object[] parametros = { creditosBean.getMontoCredito(),
				creditosBean.getTasaFija(), creditosBean.getNumAmortizacion(),
				creditosBean.getFrecuenciaCap() };
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
				amortizacionCredito.setFechaInicio(resultSet.getString(1));
				amortizacionCredito.setFechaVencim(resultSet.getString(2));
				amortizacionCredito.setFechaExigible(resultSet.getString(3));
				amortizacionCredito.setCapital(resultSet.getString(4));
				amortizacionCredito.setInteres(resultSet.getString(5));
				amortizacionCredito.setIvaInteres(resultSet.getString(6));
				amortizacionCredito.setTotalPago(resultSet.getString(7));
				amortizacionCredito.setSaldoInsoluto(resultSet.getString(8));
				return amortizacionCredito;
			}
		});
		return matches;
	}


	/* Lista de creditos Autorizados o Inactivos*/
	public List listaCreditosAutInac(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?,?,?  ,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error el la lista de creditos autorizados e inactivos", e);
		}
		return listaCredAutInac;
	}

	// Lista para Resumen Cliente de Creditos
	public List listaCreditosResumCte(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getNombreCliente(),
					creditosBean.getClienteID(),
					Constantes.FECHA_VACIA,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("Tmp_CreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("Tmp_ProdCre"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setFechaMinistrado(resultSet.getString("Tmp_FechaMinis"));
					creditosBean.setFechaVencimien(resultSet.getString("Tmp_FechaVenc"));
					creditosBean.setMontoPagar(resultSet.getString("MontoSolici"));  // monto Sol
					creditosBean.setMontoDesemb(resultSet.getString("Tmp_SaldoTot"));   // Saldo Total
					creditosBean.setPagoExigible(resultSet.getString("Tmp_MontoExi"));
					creditosBean.setFechaCorte(resultSet.getString("Tmp_ProxVenc"));  //prox venc
					creditosBean.setFechaAutoriza(resultSet.getString("Tmp_FechaSolici")); //fecha solici
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setOrigen(resultSet.getString("Origen"));

					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el resumen de cliente de credito", e);
		}
		return listaCredAutInac;
	}


	/* Lista de creditos vigentes o vencidos*/
	public List listaCreditosVigentesOVencidos(CreditosBean creditosBean, int tipoLista) {
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Utileria.convierteEntero(creditosBean.getClienteID()),
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos vigentes o vencidos", e);
		}
		return listaCredVig;
	}



	/* Lista de creditos Inactivos*/
	public List listaCreditosInactivos(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos inactivos", e);
		}
		return listaCredAutInac;
	}

	/* Lista de creditos Autorizados con estatus de pagare impreso*/
	public List listaCreditosAutorizadosPagareImp(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos autorizados con estatus de pagare impreso", e);
		}
		return listaCredAutInac;
	}

	/* Lista de creditos Individuales (todos los estatus)*/
	public List listaCreditosIndividuales(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de credito individual", e);
		}
		return listaCredAutInac;
	}

	/* Lista de creditos vigentes o vencidos para el combo*/
	public List listaCreditosVigentesOVencidosCombo(CreditosBean creditosBean, int tipoLista) {
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Utileria.convierteEntero(creditosBean.getClienteID()),
									Constantes.FECHA_VACIA,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setCreditoProducto(resultSet.getString(2));
					return creditosBean;
				}
			});
			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos vigentes o vencidos", e);
		}
		return listaCredVig;
	}

	/* SIMULADOR DE PAGOS CRECIENTES CON TASA FIJA */
	public List SimPagCrecientes (final CreditosBean creditosBean){
		transaccionDAO.generaNumeroTransaccion();

		creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

		String cobraAccesorios = creditosBean.getCobraAccesorios();
		String cobraAccesoriosGen = creditosBean.getCobraAccesoriosGen();

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			altaAccesorios(creditosBean);
		}

		 List matches =new  ArrayList();
		 final List matches2 =new  ArrayList();
		AmortizacionCreditoBean amortizacionCred = null;
		final AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
		matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CREPAGCRECAMORPRO(" +
									"?,?,?,?,?,         " +
									"?,?,?,?,?,         " +
									"?,?,?,?,?,         " +
									"?,?,?,?,?,         " +
									"?,?,?,?,?,         " +
									"?,?,?,?,?,         " +
									"?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(creditosBean.getConvenioNominaID()));

							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
							sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditosBean.getTasaFija()));
							sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditosBean.getPeriodicidadCap()));
							sentenciaStore.setString("Par_PagoCuota",creditosBean.getFrecuenciaCap());
							sentenciaStore.setString("Par_PagoFinAni",creditosBean.getDiaPagoCapital());

							sentenciaStore.setInt("Par_DiaMes",Utileria.convierteEntero(creditosBean.getDiaMesCapital()));
							sentenciaStore.setString("Par_FechaInicio",(creditosBean.getFechaInicio()));
							sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditosBean.getNumAmortizacion()));
							sentenciaStore.setInt("Par_ProdCredID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));

							sentenciaStore.setString("Par_DiaHabilSig",creditosBean.getFechaInhabil());
							sentenciaStore.setString("Par_AjustaFecAmo",creditosBean.getAjusFecUlVenAmo());
							sentenciaStore.setString("Par_AjusFecExiVen",creditosBean.getAjusFecExiVen());
							sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(creditosBean.getMontoComision()));
							sentenciaStore.setDouble("Par_MontoGL",Utileria.convierteDoble(creditosBean.getMontoGarLiq()));

							sentenciaStore.setString("Par_CobraSeguroCuota",creditosBean.getCobraSeguroCuota());
							sentenciaStore.setString("Par_CobraIVASeguroCuota",creditosBean.getCobraIVASeguroCuota());
							sentenciaStore.setDouble("Par_MontoSeguroCuota",Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
							sentenciaStore.setDouble("Par_ComAnualLin", Utileria.convierteDoble(creditosBean.getComAnualLin()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_Cat", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREPAGCRECAMORPRO(  " + sentenciaStore.toString() + ")");
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

							 while (resultadosStore.next()) {

									AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
								amortizacionCredito.setAmortizacionID(resultadosStore.getString(1));
								amortizacionCredito.setFechaInicio(resultadosStore.getString(2));
								amortizacionCredito.setFechaVencim(resultadosStore.getString(3));
								amortizacionCredito.setFechaExigible(resultadosStore.getString(4));
								amortizacionCredito.setCapital(resultadosStore.getString(5));
								amortizacionCredito.setInteres(resultadosStore.getString(6));
								amortizacionCredito.setIvaInteres(resultadosStore.getString(7));
								amortizacionCredito.setTotalPago(resultadosStore.getString(8));
								amortizacionCredito.setSaldoInsoluto(resultadosStore.getString(9));
								amortizacionCredito.setDias(resultadosStore.getString(10));
								amortizacionCredito.setCuotasCapital(resultadosStore.getString(11));
								amortizacionCredito.setNumTransaccion(resultadosStore.getString(12));
								amortizacionCredito.setCat(resultadosStore.getString(13));
								amortizacionCredito.setFecUltAmor(resultadosStore.getString(14));
								amortizacionCredito.setFecInicioAmor(resultadosStore.getString(15));
								amortizacionCredito.setMontoCuota(resultadosStore.getString(16));
								amortizacionCredito.setTotalCap(resultadosStore.getString(17));
								amortizacionCredito.setTotalInteres(resultadosStore.getString(18));
								amortizacionCredito.setTotalIva(resultadosStore.getString(19));
								amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
								amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
								amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
								amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
								amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
								amortizacionCredito.setSaldoOtrasComisiones(resultadosStore.getString("OtrasComisiones"));
								amortizacionCredito.setSaldoIVAOtrasCom(resultadosStore.getString("IVAOtrasComisiones"));
								amortizacionCredito.setTotalOtrasComisiones(resultadosStore.getString("TotalOtrasComisiones"));
								amortizacionCredito.setTotalIVAOtrasComisiones(resultadosStore.getString("TotalIVAOtrasComisiones"));
								amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
								amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));
								matches2.add(amortizacionCredito);
							}
						}
							return matches2;

						}
					});
			 		CreditosBean creditos = new  CreditosBean();
			 		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
			 		bajaEnTemporal(creditos);

			 		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
				 		bajaAccesorios(creditos);
					}

			return matches;
	}

	public List listaCreditosCobCom(CreditosBean creditosBean, int tipoLista){
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("NombreCompleto"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					creditosBean.setNombreProducto(resultSet.getString("Descripcion"));
					creditosBean.setCuentaID(resultSet.getString("CuentaID"));
					creditosBean.setComFaltaPago(resultSet.getString("ComFaltaPago"));
					creditosBean.setComSeguroCuota(resultSet.getString("ComSeguroCuota"));
					creditosBean.setComAperturaCred(resultSet.getString("ComAperturaCred"));
					creditosBean.setComAnualLin(resultSet.getString("ComAnualLin"));
					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos vigentes o vencidos", e);
		}
		return listaCredVig;
	}

	public void bajaEnTemporal(final CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TMPPAGAMORSIMBAJ(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_NumTranSim",Utileria.convierteLong(creditosBean.getNumTransacSim()));
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


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMBAJ(  " + sentenciaStore.toString() + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en borrado de amortizaciones temporales ", e);
				}
				return mensajeBean;
			}
		});
	}

   /*Elimina las amortizaciones temporales*/
	public MensajeTransaccionBean bajaTmpPagAmor(final CreditosBean creditosBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TMPPAGAMORSIMBAJ(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setLong("Par_NumTranSim",Utileria.convierteLong(creditosBean.getNumTransacSim()));
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


										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMBAJ(  " + sentenciaStore.toString() + ")");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en borrado de amortizaciones temporales ", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	public void bajaAccesorios(final CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure  54

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETALLEACCESORIOSBAJ(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteLong(creditosBean.getNumTransacSim()));
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


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEACCESORIOSBAJ(  " + sentenciaStore.toString() + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en borrado de accesorios.", e);
				}
				return mensajeBean;
			}
		});
	}
	/**
	 * Simulador de pagos iguales con tasa fija
	 * @param creditosBean
	 * @return
	 */
	public List SimPagIguales (final CreditosBean creditosBean){

		transaccionDAO.generaNumeroTransaccion();
		creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

		String cobraAccesorios = creditosBean.getCobraAccesorios();
		String cobraAccesoriosGen = creditosBean.getCobraAccesoriosGen();

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			altaAccesorios(creditosBean);
		}


		 List matches =new  ArrayList();
		 final List matches2 =new  ArrayList();
		 matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PRINCIPALSIMPAGIGUAPRO(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?," +
									"?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(creditosBean.getConvenioNominaID()));

							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
							sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditosBean.getTasaFija()));
							sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditosBean.getPeriodicidadCap()));
							sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditosBean.getPeriodicidadInt()));
							sentenciaStore.setString("Par_PagoCuota",creditosBean.getFrecuenciaCap());

							sentenciaStore.setString("Par_PagoInter",creditosBean.getFrecuenciaInt());
							sentenciaStore.setString("Par_PagoFinAni",creditosBean.getDiaPagoCapital());
							sentenciaStore.setString("Par_PagoFinAniInt",creditosBean.getDiaPagoInteres());
							sentenciaStore.setString("Par_FechaInicio",(creditosBean.getFechaInicio()));
							sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditosBean.getNumAmortizacion()));

							sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditosBean.getNumAmortInteres()));
							sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
							sentenciaStore.setString("Par_DiaHabilSig",creditosBean.getFechaInhabil());
							sentenciaStore.setString("Par_AjustaFecAmo",creditosBean.getAjusFecUlVenAmo());

							sentenciaStore.setString("Par_AjusFecExiVen",creditosBean.getAjusFecExiVen());
							sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditosBean.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditosBean.getDiaMesCapital()));
							sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(creditosBean.getMontoComision()));
							sentenciaStore.setDouble("Par_MontoGL",Utileria.convierteDoble(creditosBean.getMontoGarLiq()));

							sentenciaStore.setString("Par_CobraSeguroCuota",creditosBean.getCobraSeguroCuota());
							sentenciaStore.setString("Par_CobraIVASeguroCuota",creditosBean.getCobraIVASeguroCuota());
							sentenciaStore.setDouble("Par_MontoSeguroCuota",Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
							sentenciaStore.setDouble("Par_ComAnualLin",Utileria.convierteDoble(creditosBean.getComAnualLin()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_CuotasInt", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_Cat", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);
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

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
							 while (resultadosStore.next()) {

								AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
								 	amortizacionCredito.setAmortizacionID(resultadosStore.getString(1));
									amortizacionCredito.setFechaInicio(resultadosStore.getString(2));
									amortizacionCredito.setFechaVencim(resultadosStore.getString(3));
									amortizacionCredito.setFechaExigible(resultadosStore.getString(4));
									amortizacionCredito.setCapital(resultadosStore.getString(5));
									amortizacionCredito.setInteres(resultadosStore.getString(6));
									amortizacionCredito.setIvaInteres(resultadosStore.getString(7));
									amortizacionCredito.setTotalPago(resultadosStore.getString(8));
									amortizacionCredito.setSaldoInsoluto(resultadosStore.getString(9));
									amortizacionCredito.setDias(resultadosStore.getString(10));
									amortizacionCredito.setCapitalInteres(resultadosStore.getString(11));
									amortizacionCredito.setCuotasCapital(resultadosStore.getString(12));
									amortizacionCredito.setCuotasInteres(resultadosStore.getString(13));
									amortizacionCredito.setNumTransaccion(resultadosStore.getString(14));
									amortizacionCredito.setCat(resultadosStore.getString(15));
									amortizacionCredito.setFecUltAmor(resultadosStore.getString(16));
									amortizacionCredito.setFecInicioAmor(resultadosStore.getString(17));
									amortizacionCredito.setMontoCuota(resultadosStore.getString(18));
									amortizacionCredito.setTotalCap(resultadosStore.getString(19));
									amortizacionCredito.setTotalInteres(resultadosStore.getString(20));
									amortizacionCredito.setTotalIva(resultadosStore.getString(21));
									amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
									amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
									amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
									amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
									amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
									amortizacionCredito.setSaldoOtrasComisiones(resultadosStore.getString("OtrasComisiones"));
									amortizacionCredito.setSaldoIVAOtrasCom(resultadosStore.getString("IVAOtrasComisiones"));
									amortizacionCredito.setTotalOtrasComisiones(resultadosStore.getString("TotalOtrasComisiones"));
									amortizacionCredito.setTotalIVAOtrasComisiones(resultadosStore.getString("TotalIVAOtrasComisiones"));
									amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
									amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));
								matches2.add(amortizacionCredito);
							}
						}
					return matches2;
						}
					});
					CreditosBean creditos = new  CreditosBean();
			 		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
			 		bajaEnTemporal(creditos);
			 		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
				 		bajaAccesorios(creditos);
					}
			return matches;
}


	/* SIMULADOR DE PAGOS LIBRES CON TASA FIJA SOLO MUESTRA LAS FECHAS */
	public List SimPagLibres (final CreditosBean creditosBean){
		transaccionDAO.generaNumeroTransaccion();


		creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

		String cobraAccesorios = creditosBean.getCobraAccesorios();
		String cobraAccesoriosGen = creditosBean.getCobraAccesoriosGen();

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			altaAccesorios(creditosBean);
		}

		List listaSimPagosLibres =new  ArrayList();
		final List listaSimuladorPagosLibres =new  ArrayList();
		listaSimPagosLibres = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CREPAGLIBAMORPRO(" +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?," +
						"?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);

				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditosBean.getPeriodicidadCap()));
				sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditosBean.getPeriodicidadInt()));
				sentenciaStore.setString("Par_PagoCuota",creditosBean.getFrecuenciaCap());
				sentenciaStore.setString("Par_PagoInter",creditosBean.getFrecuenciaInt());
				sentenciaStore.setString("Par_PagoFinAni",creditosBean.getDiaPagoCapital());
				sentenciaStore.setString("Par_PagoFinAniInt",creditosBean.getDiaPagoInteres());
				sentenciaStore.setString("Par_FechaInicio",(creditosBean.getFechaInicio()));
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditosBean.getNumAmortizacion()));
				sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
				sentenciaStore.setString("Par_DiaHabilSig",creditosBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditosBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditosBean.getAjusFecExiVen());
				sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditosBean.getDiaMesInteres()));
				sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditosBean.getDiaMesCapital()));
				sentenciaStore.setString("Par_CobraSeguroCuota",creditosBean.getCobraSeguroCuota());
				sentenciaStore.setString("Par_CobraIVASeguroCuota",creditosBean.getCobraIVASeguroCuota());
				sentenciaStore.setDouble("Par_MontoSeguroCuota",Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
				sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
				sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
				sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);

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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
						try{
						amortizacionCredito.setAmortizacionID(resultadosStore.getString("Tmp_Consecutivo"));
						amortizacionCredito.setFechaInicio(resultadosStore.getString("Tmp_FecIni"));
						amortizacionCredito.setFechaVencim(resultadosStore.getString("Tmp_FecFin"));
						amortizacionCredito.setFechaExigible(resultadosStore.getString("Tmp_FecVig"));
						amortizacionCredito.setCapital(resultadosStore.getString("Tmp_Capital"));

						amortizacionCredito.setInteres(resultadosStore.getString("Tmp_Interes"));
						amortizacionCredito.setIvaInteres(resultadosStore.getString("Tmp_Iva"));
						amortizacionCredito.setTotalPago(resultadosStore.getString("Tmp_SubTotal"));
						amortizacionCredito.setSaldoInsoluto(resultadosStore.getString("Tmp_Insoluto"));
						amortizacionCredito.setDias(resultadosStore.getString("Tmp_Dias"));

						amortizacionCredito.setCapitalInteres(resultadosStore.getString("Tmp_CapInt"));
						amortizacionCredito.setCuotasCapital(resultadosStore.getString("Tmp_CuotasCap"));
						amortizacionCredito.setCuotasInteres(resultadosStore.getString("Tmp_CuotasInt"));
						amortizacionCredito.setNumTransaccion(resultadosStore.getString("NumTransaccion"));
						amortizacionCredito.setFecUltAmor(resultadosStore.getString("Par_FechaVenc"));

						amortizacionCredito.setFecInicioAmor(resultadosStore.getString("Par_FechaInicio"));
						amortizacionCredito.setMontoCuota(resultadosStore.getString("MontoCuota"));
						amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
						amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
						amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
						amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
						amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
						amortizacionCredito.setSaldoOtrasComisiones(resultadosStore.getString("OtrasComisiones"));
						amortizacionCredito.setSaldoIVAOtrasCom(resultadosStore.getString("IVAOtrasComisiones"));
						amortizacionCredito.setTotalOtrasComisiones(resultadosStore.getString("TotalOtrasComisiones"));
						amortizacionCredito.setTotalIVAOtrasComisiones(resultadosStore.getString("TotalIVAOtrasComisiones"));
						amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
						amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));
						} catch(Exception ex){
							ex.printStackTrace();
							return null;
						}
						listaSimuladorPagosLibres.add(amortizacionCredito);
					}
				}
				return listaSimuladorPagosLibres;
			}
		});
		return listaSimPagosLibres;
	}

	/* consulta de amortizaciones temporales   TEMPPAGAMORSIM
	 * Se utiliza cuando se trata de un calendario de pagos libre de capital
	 * o irregular en capital y fecha */
	public List consultaSimuladorPagosTemporal(final CreditosBean creditosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call TMPPAGAMORSIMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getNumTransacSim(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.ConTempPagAmort",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
				amortizacionCredito.setAmortizacionID(String.valueOf(resultSet.getInt("Tmp_Consecutivo")));
				amortizacionCredito.setFechaInicio(resultSet.getString("Tmp_FecIni"));
				amortizacionCredito.setFechaVencim(resultSet.getString("Tmp_FecFin"));
				amortizacionCredito.setFechaExigible(resultSet.getString("Tmp_FecVig"));
				amortizacionCredito.setCapital(resultSet.getString("Tmp_Capital"));

				amortizacionCredito.setInteres(resultSet.getString("Tmp_Interes"));
				amortizacionCredito.setIvaInteres(resultSet.getString("Tmp_Iva"));
				amortizacionCredito.setTotalPago(resultSet.getString("Tmp_SubTotal"));
				amortizacionCredito.setSaldoInsoluto(resultSet.getString("Tmp_Insoluto"));
				amortizacionCredito.setCuotasCapital(resultSet.getString("Tmp_CuotasCap"));
				amortizacionCredito.setCat(resultSet.getString("Tmp_Cat"));
				amortizacionCredito.setCobraSeguroCuota(creditosBean.getCobraSeguroCuota());
				amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
				amortizacionCredito.setNumTransaccion(resultSet.getString("NumTransaccion"));
				amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
				amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				amortizacionCredito.setSaldoOtrasComisiones(resultSet.getString("OtrasComisiones"));
				amortizacionCredito.setSaldoIVAOtrasCom(resultSet.getString("IVAOtrasComisiones"));
				amortizacionCredito.setTotalOtrasComisiones(resultSet.getString("TotalOtrasComisiones"));
				amortizacionCredito.setTotalIVAOtrasComisiones(resultSet.getString("TotalIVAOtrasComisiones"));

				return amortizacionCredito;
			}
		});

		return matches;
	}

	public List consAmortPagosTemporalGrupFormales(final CreditosBean creditosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call TMPPAGAMORSIMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getNumTransacSim(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.ConTempPagAmort",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
				amortizacionCredito.setAmortizacionID(String.valueOf(resultSet.getInt("Tmp_Consecutivo")));
				amortizacionCredito.setFechaInicio(resultSet.getString("Tmp_FecIni"));
				amortizacionCredito.setFechaVencim(resultSet.getString("Tmp_FecFin"));
				amortizacionCredito.setFechaExigible(resultSet.getString("Tmp_FecVig"));
//				amortizacionCredito.setCapital(resultSet.getString("Tmp_Capital"));
//
//				amortizacionCredito.setInteres(resultSet.getString("Tmp_Interes"));
//				amortizacionCredito.setIvaInteres(resultSet.getString("Tmp_Iva"));
//				amortizacionCredito.setTotalPago(resultSet.getString("Tmp_SubTotal"));
//				amortizacionCredito.setSaldoInsoluto(resultSet.getString("Tmp_Insoluto"));
//				amortizacionCredito.setCuotasCapital(resultSet.getString("Tmp_CuotasCap"));
//				amortizacionCredito.setCat(resultSet.getString("Tmp_Cat"));
//				amortizacionCredito.setCobraSeguroCuota(creditosBean.getCobraSeguroCuota());
//				amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
//				amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
//				amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
//				amortizacionCredito.setNumTransaccion(resultSet.getString("NumTransaccion"));
//				amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
//				amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				return amortizacionCredito;
			}
		});

		return matches;
	}



	//para grabar los montos de capital para generar el simulador de pagos libres
	public MensajeTransaccionBean grabaListaSimPagLib(final CreditosBean creditosBean, final List listaSimPagLib, final int tipoActualizacion, final String diaHabil) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					List listaCreditosSimPagLib = null;
					try {
						AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
						amortizacionCreditoBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						if (tipoActualizacion == Enum_Sim_PagAmortizaciones.actPagLibFecCap) {
							transaccionDAO.generaNumeroTransaccion();
							creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						}
						for (int i = 0; i < listaSimPagLib.size(); i++) {
							amortizacionCreditoBean = (AmortizacionCreditoBean) listaSimPagLib.get(i);
							if (tipoActualizacion == Enum_Sim_PagAmortizaciones.actPagLib) {
								mensajeBean = amortizacionCreditoDAO.actualizacionSimuladorCapital(amortizacionCreditoBean);
							} else {
								mensajeBean = amortizacionCreditoDAO.altaSimuladorFechaCapital(amortizacionCreditoBean, diaHabil);
							}
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("monto actualizado.");
						mensajeBean.setNombreControl("polizaID");
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabacion de los montos del capital", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			mensaje.setNumero(999);
			mensaje.setDescripcion(ex.getMessage());
			ex.printStackTrace();
		}
		return mensaje;
	}

	/* recalculo DE PAGOS LIBRES CON TASA FIJA*/
	public List<AmortizacionCreditoBean> recalculoSimPagLibresFecCap(final CreditosBean creditosBean) {
		transaccionDAO.generaNumeroTransaccion();

		String cobraAccesorios = creditosBean.getCobraAccesorios();
		String cobraAccesoriosGen = creditosBean.getCobraAccesoriosGen();

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			altaAccesorios(creditosBean);
		}

		List<AmortizacionCreditoBean> listaSimPagosLibres=null;
		final List<AmortizacionCreditoBean> listaSimuladorPagosLibres=new ArrayList<AmortizacionCreditoBean>();
		try{
		listaSimPagosLibres = (List<AmortizacionCreditoBean>)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CRERECPAGLIBPRO(" +
						"?,?,?,?,?,     " +
						"?,?,?,?,?,     " +
						"?,?,?,?,?,     " +
						"?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);

				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditosBean.getTasaFija()));
				sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
				sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
				sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(creditosBean.getMontoComision()));

				sentenciaStore.setString("Par_CobraSeguroCuota",creditosBean.getCobraSeguroCuota());
				sentenciaStore.setString("Par_CobraIVASeguroCuota",creditosBean.getCobraIVASeguroCuota());
				sentenciaStore.setDouble("Par_MontoSeguroCuota",Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
				sentenciaStore.setDouble("Par_ComAnualLin", Utileria.convierteDoble(creditosBean.getComAnualLin()));
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

				sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
				sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
				sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
				sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.SimPagCrecientes");
				sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

				sentenciaStore.setString("Aud_NumTransaccion",creditosBean.getNumTransacSim());
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
				return sentenciaStore;
			}
		},new CallableStatementCallback() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultSet = callableStatement.getResultSet();
					while (resultSet.next()) {

						AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
						try{
						amortizacionCredito.setAmortizacionID(resultSet.getString("Consecutivo"));
						amortizacionCredito.setFechaInicio(resultSet.getString("FechaInicio"));
						amortizacionCredito.setFechaVencim(resultSet.getString("FechaVencim"));
						amortizacionCredito.setFechaExigible(resultSet.getString("FechaExigible"));
						amortizacionCredito.setCapital(resultSet.getString("Capital"));

						amortizacionCredito.setInteres(resultSet.getString("Interes"));
						amortizacionCredito.setIvaInteres(resultSet.getString("Iva"));
						amortizacionCredito.setTotalPago(resultSet.getString("SubTotal"));
						amortizacionCredito.setSaldoInsoluto(resultSet.getString("Insoluto"));
						amortizacionCredito.setDias(resultSet.getString("Dias"));

						amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
						amortizacionCredito.setNumTransaccion(resultSet.getString("Aud_NumTransaccion"));
						amortizacionCredito.setCuotasCapital(resultSet.getString("CuotaCapital"));
						amortizacionCredito.setCuotasInteres(resultSet.getString("CuotaInteres"));
						amortizacionCredito.setCat(resultSet.getString("Var_CAT"));

						amortizacionCredito.setFecUltAmor(resultSet.getString("Par_FechaVenc"));
						amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
						amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
						amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
						amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
						amortizacionCredito.setSaldoOtrasComisiones(resultSet.getString("OtrasComisiones"));
						amortizacionCredito.setSaldoIVAOtrasCom(resultSet.getString("IVAOtrasComisiones"));
						amortizacionCredito.setTotalOtrasComisiones(resultSet.getString("TotalOtrasComisiones"));
						amortizacionCredito.setTotalIVAOtrasComisiones(resultSet.getString("TotalIVAOtrasComisiones"));
						amortizacionCredito.setCodigoError(resultSet.getString("NumErr"));
						amortizacionCredito.setMensajeError(resultSet.getString("ErrMen"));
						} catch(Exception ex){
							ex.printStackTrace();
							return null;
						}
						listaSimuladorPagosLibres.add(amortizacionCredito);
					}
					return listaSimuladorPagosLibres;
				}
				return listaSimuladorPagosLibres;
			}
		});
		} catch(Exception ex){
			ex.printStackTrace();
		}
		return listaSimuladorPagosLibres;
	}

	/* SIMULADOR DE PAGOS IGUALES CON TASA VARIABLE */
	public List SimPagTasaVar (final CreditosBean creditosBean){
		transaccionDAO.generaNumeroTransaccion();
		 List matches =new  ArrayList();
		 final List matches2 =new  ArrayList();

		 matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CRETASVARAMORPRO(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
							sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditosBean.getPeriodicidadCap()));
							sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditosBean.getPeriodicidadInt()));
							sentenciaStore.setString("Par_PagoCuota",creditosBean.getFrecuenciaCap());
							sentenciaStore.setString("Par_PagoInter",creditosBean.getFrecuenciaInt());
							sentenciaStore.setString("Par_PagoFinAni",creditosBean.getDiaPagoCapital());
							sentenciaStore.setString("Par_PagoFinAniInt",creditosBean.getDiaPagoInteres());
							sentenciaStore.setString("Par_FechaInicio",(creditosBean.getFechaInicio()));
							sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditosBean.getNumAmortizacion()));
							sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditosBean.getNumAmortInteres()));

							sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditosBean.getNumAmortInteres()));
							sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));
							sentenciaStore.setString("Par_DiaHabilSig",creditosBean.getFechaInhabil());
							sentenciaStore.setString("Par_AjustaFecAmo",creditosBean.getAjusFecUlVenAmo());
							sentenciaStore.setString("Par_AjusFecExiVen",creditosBean.getAjusFecExiVen());
							sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditosBean.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditosBean.getDiaMesCapital()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_CuotasInt", Types.INTEGER);

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

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
							 while (resultadosStore.next()) {
								AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
								amortizacionCredito.setAmortizacionID(resultadosStore.getString(1));
								amortizacionCredito.setFechaInicio(resultadosStore.getString(2));
								amortizacionCredito.setFechaVencim(resultadosStore.getString(3));
								amortizacionCredito.setFechaExigible(resultadosStore.getString(4));
								amortizacionCredito.setCapital(resultadosStore.getString(5));
								amortizacionCredito.setSaldoInsoluto(resultadosStore.getString(6));
								amortizacionCredito.setDias(resultadosStore.getString(7));
								amortizacionCredito.setCapitalInteres(resultadosStore.getString(8));
								amortizacionCredito.setCuotasCapital(resultadosStore.getString(9));
								amortizacionCredito.setCuotasInteres(resultadosStore.getString(10));
								amortizacionCredito.setNumTransaccion(resultadosStore.getString(11));
								amortizacionCredito.setFecUltAmor(resultadosStore.getString(12));
								amortizacionCredito.setFecInicioAmor(resultadosStore.getString(13));
								amortizacionCredito.setMontoCuota(resultadosStore.getString(14));
								amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
								amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
								amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
								amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
								amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
								amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
								amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));

								matches2.add(amortizacionCredito);
							}
						}
						return matches2;

						}
					});
					CreditosBean creditos = new  CreditosBean();
			 		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
			 		bajaEnTemporal(creditos);
			return matches;
}

	public void setAmortizacionCreditoDAO(
			AmortizacionCreditoDAO amortizacionCreditoDAO) {
		this.amortizacionCreditoDAO = amortizacionCreditoDAO;
	}


	public List listaConsultaCreditos(final CreditosBean creditosBean, int tipoLista){

		String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
				    		creditosBean.getCreditoID(),
				    		Constantes.ENTERO_CERO,
				    		Constantes.FECHA_VACIA,
				    		tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditosDAO.listaConsultaCreditos",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean= new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString(1));
				creditosBean.setClienteID(resultSet.getString(2));
				creditosBean.setEstatus(resultSet.getString(3));
				creditosBean.setFechaInicio(resultSet.getString(4));
				creditosBean.setFechaVencimien(resultSet.getString(5));

				return creditosBean ;
			}

		});
		return null;
	}







public List  consultaSaldosCapitalExcel(final CreditosBean creditosBean, int tipoLista){



	List listaResultado = null;
	try{

		String query = "call SALDOSCAPITALREP(?,?,?,?,?,	?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteEntero(creditosBean.getSucursal()),
							Utileria.convierteEntero(creditosBean.getMonedaID()),
							Utileria.convierteEntero(creditosBean.getProducCreditoID()),
							Utileria.convierteEntero(creditosBean.getPromotorID()),
							creditosBean.getSexo(),
							Utileria.convierteEntero(creditosBean.getEstadoID()),
							Utileria.convierteEntero(creditosBean.getMunicipioID()),
							creditosBean.getCriterio(),

							Utileria.convierteEntero(creditosBean.getAtrasoInicial()),
							Utileria.convierteEntero(creditosBean.getAtrasoFinal()),
							Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),
							Utileria.convierteEntero(creditosBean.getConvenioNominaID()),


							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditosDAO.consultaSaldosCapitalExcel",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCAPITALREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteCreditosBean creditosBean= new ReporteCreditosBean();

				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				creditosBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				creditosBean.setProductoCreDescri(resultSet.getString("Descripcion"));
				creditosBean.setTasaFija(resultSet.getString("TasaFija"));
				creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
				creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				creditosBean.setCapitalVigente(resultSet.getString("CapitalVigente"));
				creditosBean.setInteresesVigente(resultSet.getString("InteresesVigente"));
				creditosBean.setMoraVigente(resultSet.getString("MoraVigente"));
				creditosBean.setCargosVigente(resultSet.getString("CargosVigente"));
				creditosBean.setIvaVigente(resultSet.getString("IvaVigente"));
				creditosBean.setTotalVigente(resultSet.getString("TotalVigente"));
			    creditosBean.setCapitalVencido(resultSet.getString("CapitalVencido"));
				creditosBean.setInteresesVencido(resultSet.getString("InteresesVencido"));
				creditosBean.setMoraVencido(resultSet.getString("MoraVencido"));
				creditosBean.setCargosVencido(resultSet.getString("CargosVencido"));
				creditosBean.setIvaVencido(resultSet.getString("IvaVencido"));
				creditosBean.setTotalVencido(resultSet.getString("TotalVencido"));
				creditosBean.setCapitalAtrasado(resultSet.getString("CapitalAtrasado"));


				creditosBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				creditosBean.setFecha(resultSet.getString("FechaEmision"));
				creditosBean.setHora(resultSet.getString("HoraEmision"));
				creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				creditosBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
				creditosBean.setNombreInstit(resultSet.getString("NombreInstit"));
				creditosBean.setDesConvenio(resultSet.getString("DesConvenio"));
				creditosBean.setComisiones(resultSet.getString("MontoOtrasComisiones"));
				creditosBean.setIvaComisiones(resultSet.getString("MontoIVAOtrasComisiones"));
				creditosBean.setNotasCargo(resultSet.getString("MontoNotasCargo"));
				creditosBean.setIvaNotasCargo(resultSet.getString("MontoIVANotasCargo"));
				creditosBean.setTotalNotasCargo(resultSet.getString("TotalNotasCargo"));

				creditosBean.setAccesorios(resultSet.getString("Accesorio"));
				creditosBean.setInteresAccesorios(resultSet.getString("InteresAccesorio"));
				creditosBean.setIvaInteresAccesorios(resultSet.getString("IvaInteresAccesorio"));


				return creditosBean ;
			}
		});
		listaResultado = matches;

	} catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte Saldos Capital ", e);

	}
		return listaResultado;
	}


//Reporte de Pagos realizados
public List  consultaPagosRealizadosExcel(final CreditosBean creditosBean, int tipoLista){



List listaResultado = null;
try{

	String query = "call PAGOSREALIZADOSREP(?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?,	?,?,?,?)";

	Object[] parametros ={
						Utileria.convierteFecha(creditosBean.getFechaInicio()),
						Utileria.convierteFecha(creditosBean.getFechaVencimien()),
						Utileria.convierteEntero(creditosBean.getSucursal()),
						Utileria.convierteEntero(creditosBean.getMonedaID()),
						Utileria.convierteEntero(creditosBean.getProducCreditoID()),
						Utileria.convierteEntero(creditosBean.getPromotorID()),
						creditosBean.getSexo(),
						Utileria.convierteEntero(creditosBean.getEstadoID()),
						Utileria.convierteEntero(creditosBean.getMunicipioID()),
						creditosBean.getModalidadPagoID(),
						Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),
						Utileria.convierteEntero(creditosBean.getConvenioNominaID()),

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CreditosDAO.consultaSaldosCapitalExcel",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOSREALIZADOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			ReporteCreditosBean creditosBean= new ReporteCreditosBean();


			creditosBean.setCreditoID(resultSet.getString("CreditoID"));
			creditosBean.setClienteID(resultSet.getString("ClienteID"));
			creditosBean.setNombreCompleto(resultSet.getString("NombreCliente"));
			creditosBean.setProductoCreDescri(resultSet.getString("NombreProducto"));
			creditosBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
			creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
			creditosBean.setFechaPago(resultSet.getString("FechaPago"));
			creditosBean.setFechaVencimiento(resultSet.getString("FechaVencim"));
			creditosBean.setCapital(resultSet.getString("Capital"));
			creditosBean.setIntereses(resultSet.getString("Intereses"));
			creditosBean.setMoratorios(resultSet.getString("Moratorios"));
			creditosBean.setComisiones(resultSet.getString("Comisiones"));
			creditosBean.setIVA(resultSet.getString("IVA"));
			creditosBean.setTotalPagado(resultSet.getString("TotalPagado"));
			creditosBean.setFecha(resultSet.getString("FechaEmision"));
			creditosBean.setHora(resultSet.getString("HoraEmision"));
			creditosBean.setGrupoID(resultSet.getString("GrupoID"));
			creditosBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
			creditosBean.setRefPago(resultSet.getString("RefPago"));
			creditosBean.setModalidadPago(resultSet.getString("OrigenPago"));
			creditosBean.setNombreInstit(resultSet.getString("NombreInstit"));
			creditosBean.setDesConvenio(resultSet.getString("DesConvenio"));
			creditosBean.setIvaComisiones(resultSet.getString("IVA_Comisiones"));


			creditosBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
			creditosBean.setFuenteFondeo(resultSet.getString("FuenteFondeo"));
			creditosBean.setLineaFondeo(resultSet.getString("LineaFondeo"));
			creditosBean.setFolioFondeo(resultSet.getString("FolioFondeo"));
			creditosBean.setNotasCargo(resultSet.getString("NotasCargo"));
			creditosBean.setIvaNotasCargo(resultSet.getString("IvaNotasCargo"));

			creditosBean.setAccesorios(resultSet.getString("Accesorios"));
			creditosBean.setInteresAccesorios(resultSet.getString("InteresAccesorio"));
			creditosBean.setIvaInteresAccesorios(resultSet.getString("IvaInteresAccesorio"));


			return creditosBean ;
		}
	});
	listaResultado = matches;

} catch (Exception e) {
	 e.printStackTrace();
	 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reportede pagos realizados", e);
}
	return listaResultado;
}



public List  consultaMasivoFR_Excel(final CreditosBean creditosBean, int tipoLista){



List listaResultado = null;
try{

	String query = "call REPORTEMASIVOFR(?, ?,?,?,?,?,?,?)";

	Object[] parametros ={
						Utileria.convierteFecha(creditosBean.getFechaInicio()),

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CreditosDAO.consultaSaldosCapitalExcel",
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPORTEMASIVOFR(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			RepMasivoFRBean creditosBean= new RepMasivoFRBean();
			//MAX(Sal.FechaCorte),TipoOperacion,NumCliIntermediario,NumeroLinea,
			creditosBean.setTipoOperacion(resultSet.getString("TipoOperacion"));
			creditosBean.setNumCliIntermediario(resultSet.getString("NumCliIntermediario"));
			creditosBean.setNumeroLinea(resultSet.getString("NumeroLinea"));

			//NumDisposicion,ClienteID,CreditoID,NombreCompleto,TipoPersona,Sexo,
			creditosBean.setNumDisposicion( resultSet.getString("NumDisposicion"));
			creditosBean.setClienteID( resultSet.getString("ClienteID"));
			creditosBean.setCreditoID( resultSet.getString("CreditoID"));
			creditosBean.setNombreCompleto( resultSet.getString("NombreCompleto"));
			creditosBean.setTipoPersona(resultSet.getString("TipoPersona"));
			creditosBean.setSexo( resultSet.getString("Sexo"));

			//CURP,RFC,EstadoID,TipoProductor,FiguraJuridica,TipoCredito,ActividadFR,
			creditosBean.setCURP(resultSet.getString("CURP"));
			creditosBean.setRFC(resultSet.getString("RFC"));
			creditosBean.setEstadoID(resultSet.getString("EstadoID"));
			creditosBean.setTipoProductor(resultSet.getString("TipoProductor"));
			creditosBean.setFiguraJuridica(resultSet.getString("FiguraJuridica"));
			creditosBean.setTipoCredito(resultSet.getString("TipoCredito"));
			creditosBean.setActividadFR(resultSet.getString("ActividadFR"));

			//DestinoCredito,TipoUnidad,UnidHabilitar,RiegoTemporal,CicloAgricola,FechaApertura,  resultSet.getString("")
			creditosBean.setDestinoCredito(resultSet.getString("DestinoCredito"));
			creditosBean.setTipoUnidad(resultSet.getString("TipoUnidad"));
			creditosBean.setUnidHabilitar(resultSet.getString("UnidHabilitar"));
			creditosBean.setRiegoTemporal(resultSet.getString("RiegoTemporal"));
			creditosBean.setCicloAgricola(resultSet.getString("CicloAgricola"));
			creditosBean.setFechaApertura(resultSet.getString("FechaApertura"));

			//FechaVencimiento,MontoCredito,TipoMoneda,PeriodicidadPagos,EstatusCredito,DiasAtraso,
			creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
			creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
			creditosBean.setTipoMoneda(resultSet.getString("TipoMoneda"));
			creditosBean.setPeriodicidadPagos(resultSet.getString("PeriodicidadPagos"));
			creditosBean.setEstatusCredito(resultSet.getString("EstatusCredito"));
			creditosBean.setDiasAtraso(resultSet.getString("DiasAtraso"));

			//CapitalVigente,InteresesVigente,CapitalVencido,InteresesVencido,SaldoTotal,FechaSaldo,
			creditosBean.setCapitalVigente(resultSet.getString("CapitalVigente"));
			creditosBean.setInteresesVigente(resultSet.getString("InteresesVigente"));
			creditosBean.setCapitalVencido(resultSet.getString("CapitalVencido"));
			creditosBean.setInteresesVencido(resultSet.getString("InteresesVencido"));
			creditosBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
			creditosBean.setFechaSaldo(resultSet.getString("FechaSaldo"));

			//TipoTasa,BaseReferencia,PuntsAdicionales,TasaFija,MunicipioID,MontoOtorgadoFR,ApoyoFONAGA,ProgEspeciales,NumMinistracion
			creditosBean.setTipoTasa(resultSet.getString("TipoTasa"));
			creditosBean.setBaseReferencia(resultSet.getString("BaseReferencia"));
			creditosBean.setPuntsAdicionales(resultSet.getString("PuntsAdicionales"));
			creditosBean.setTasaFija(resultSet.getString("TasaFija"));
			creditosBean.setMunicipioID(resultSet.getString("MunicipioID"));
			creditosBean.setMontoOtorgadoFR(resultSet.getString("MontoOtorgadoFR"));
			creditosBean.setApoyoFONAGA(resultSet.getString("ApoyoFONAGA"));
			creditosBean.setProgEspeciales(resultSet.getString("ProgEspeciales"));
			creditosBean.setNumMinistracion(resultSet.getString("NumMinistracion"));



			return creditosBean ;
		}
	});
	listaResultado = matches;

} catch (Exception e) {
	 e.printStackTrace();
	 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte masivo ", e);
}
	return listaResultado;
}
	/**
	 * Método que obtiene la lista para el reporte de analitico de cartera
	 * @param creditosBean : {@link CreditosBean} bean con la información para filtrar el reporte
	 * @param tipoLista : 3
	 * @return List <{@link CreditosBean}>
	 */
	public List<CreditosBean> consultaSaldosTotalesExcel(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List listaSaldosTot = null;
		try {
			String query = "call SALDOSTOTALESREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?,		"
					+ "?, ?,?,?,?,		"
					+ "?,?,?,?,?,		"
					+ "?)";

			Object[] parametros = {
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteEntero(creditosBean.getSucursal()),
					Utileria.convierteEntero(creditosBean.getMonedaID()),
					Utileria.convierteEntero(creditosBean.getProducCreditoID()),
					Utileria.convierteEntero(creditosBean.getPromotorID()),

					creditosBean.getSexo(),
					Utileria.convierteEntero(creditosBean.getEstadoID()),
					Utileria.convierteEntero(creditosBean.getMunicipioID()),
					Utileria.convierteEntero(creditosBean.getClasificacion()),
					Utileria.convierteEntero(creditosBean.getAtrasoInicial()),

					Utileria.convierteEntero(creditosBean.getAtrasoFinal()),
					Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),
					Utileria.convierteLong(creditosBean.getConvenioNominaID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),

					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.consultaSaldosTotalesExcel",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SALDOSTOTALESREP(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					creditosBean.setDescripcion(resultSet.getString("Descripcion"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldCapVenNoExi"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInterProvi"));
					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInterAtras"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldComFaltPago"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorator"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SalIVAComFalPag"));
					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setPasoCapAtraDia(resultSet.getString("PasoCapAtraDia"));
					creditosBean.setPasoCapVenDia(resultSet.getString("PasoCapVenDia"));
					creditosBean.setPasoCapVNEDia(resultSet.getString("PasoCapVNEDia"));
					creditosBean.setPasoIntAtraDia(resultSet.getString("PasoIntAtraDia"));
					creditosBean.setPasoIntVenDia(resultSet.getString("PasoIntVenDia"));
					creditosBean.setCapRegularizado(resultSet.getString("CapRegularizado"));
					creditosBean.setIntOrdDevengado(resultSet.getString("IntOrdDevengado"));
					creditosBean.setIntMorDevengado(resultSet.getString("IntMorDevengado"));
					creditosBean.setComisiDevengado(resultSet.getString("ComisiDevengado"));
					creditosBean.setPagoCapVigDia(resultSet.getString("PagoCapVigDia"));
					creditosBean.setPagoCapAtrDia(resultSet.getString("PagoCapAtrDia"));
					creditosBean.setPagoCapVenDia(resultSet.getString("PagoCapVenDia"));
					creditosBean.setPagoCapVenNexDia(resultSet.getString("PagoCapVenNexDia"));
					creditosBean.setPagoIntOrdDia(resultSet.getString("PagoIntOrdDia"));
					creditosBean.setPagoIntAtrDia(resultSet.getString("PagoIntAtrDia"));
					creditosBean.setPagoIntVenDia(resultSet.getString("PagoIntVenDia"));
					creditosBean.setPagoIntCalNoCon(resultSet.getString("PagoIntCalNoCon"));
					creditosBean.setPagoComisiDia(resultSet.getString("PagoComisiDia"));
					creditosBean.setPagoMoratorios(resultSet.getString("PagoMoratorios"));
					creditosBean.setPagoIvaDia(resultSet.getString("PagoIvaDia"));
					creditosBean.setIntCondonadoDia(resultSet.getString("IntCondonadoDia"));
					creditosBean.setMorCondonadoDia(resultSet.getString("MorCondonadoDia"));
					creditosBean.setIntDevCtaOrden(resultSet.getString("IntDevCtaOrden"));
					creditosBean.setCapCondonadoDia(resultSet.getString("CapCondonadoDia"));
					creditosBean.setComAdmonPagDia(resultSet.getString("ComAdmonPagDia"));
					creditosBean.setComCondonadoDia(resultSet.getString("ComCondonadoDia"));
					creditosBean.setDesembolsosDia(resultSet.getString("DesembolsosDia"));
					creditosBean.setFrecuenciaCap(resultSet.getString("FrecuenciaCap"));
					creditosBean.setFrecuenciaInt(resultSet.getString("FrecuenciaInt"));
					creditosBean.setCapVigenteExi(resultSet.getString("CapVigenteExi"));
					creditosBean.setMontoTotalExi(resultSet.getString("MontoTotalExi"));
					creditosBean.setTasaFija(resultSet.getString("TasaFija"));

					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaPago(resultSet.getString("FechaProxPago"));
					creditosBean.setEstatus(resultSet.getString("EstatusAmortiza"));
					creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					creditosBean.setFechaUltAbonoCre(resultSet.getString("FechaUltAbonoCre"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));
					creditosBean.setSaldoDispon(resultSet.getString("SaldoDispon"));
					creditosBean.setSaldoBloq(resultSet.getString("SaldoBloq"));
					creditosBean.setFechaUltDepCta(resultSet.getString("FechaUltDepCta"));
					creditosBean.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
					creditosBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					creditosBean.setFecha(resultSet.getString("FechaEmision"));
					creditosBean.setHora(resultSet.getString("HoraEmision"));

					creditosBean.setMoraVencido(resultSet.getString("MoraVencido"));
					creditosBean.setMoraCarVen(resultSet.getString("MoraCarVen"));
					creditosBean.setFormula(resultSet.getString("Formula"));
					creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
					creditosBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
					creditosBean.setCobraSeguroCuota(resultSet.getString("ExisteCredCobraSeguro"));
					creditosBean.setFolioFondeo(resultSet.getString("FolioFondeo"));
					creditosBean.setDestinoCreID(resultSet.getString("DestinoCredID"));
					creditosBean.setDesDestinoCredito(resultSet.getString("DesDestino"));

					creditosBean.setGrupoID(resultSet.getString("GrupoID"));
					creditosBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					creditosBean.setSucursal(resultSet.getString("SucursalNombreGrupo"));
					creditosBean.setInstitFondeoID(resultSet.getString("InstFondeo"));
					creditosBean.setNombreInstit(resultSet.getString("NombreInstit"));
					creditosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));

					creditosBean.setNotasCargo(resultSet.getString("NotasCargo"));
					creditosBean.setIvaNotasCargo(resultSet.getString("IvaNotasCargo"));

					return creditosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte Analitico de cartera activa " + e);
		}
		return listaSaldosTot;
	}

	// consulta para reporte en excel de ministraciones
		public List consultaMinistracionesExcel(final CreditosBean creditosBean, int tipoLista){
			List ListaResultado=null;
			try{
			String query = "call MINISTRACREREP(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteFecha(creditosBean.getFechaVencimien()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),
								Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),
								Utileria.convierteEntero(creditosBean.getConvenioNominaID()),
					    		Utileria.convierteEntero(creditosBean.getNumLista()),

					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MINISTRACREREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteMinistraBean repMinistraBean= new ReporteMinistraBean();

					repMinistraBean.setTipoFondeo(resultSet.getString("TipoFondeo"));
					repMinistraBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
					repMinistraBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					repMinistraBean.setClienteID(resultSet.getString("ClienteID"));
					repMinistraBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					//SOLICITUD
					repMinistraBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					repMinistraBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					repMinistraBean.setMontoSolici(resultSet.getString("MontoSolici"));
					//CREDItos
					repMinistraBean.setCreditoID(resultSet.getString("CreditoID"));
					repMinistraBean.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					repMinistraBean.setMontoCredito(resultSet.getString("MontoCredito"));
					//DESEMBOLSO
					repMinistraBean.setMontoDesembolso(resultSet.getString("MontoDesembolso"));
					repMinistraBean.setFechaInicio(resultSet.getString("FechaInicio"));
					repMinistraBean.setTipoDispersion(resultSet.getString("TipoDispersion"));

                    repMinistraBean.setFecha(resultSet.getString("FechaEmision"));
				    repMinistraBean.setHora(resultSet.getString("HoraEmision"));

				    repMinistraBean.setGrupoID(resultSet.getString("GrupoID"));
				    repMinistraBean.setNombreGrupo(resultSet.getString("NombreGrupo"));

				    //InstiNomina, ConvenioNomina
				    repMinistraBean.setInstitucionNominaID(resultSet.getString("InstitNominaID"));
				    repMinistraBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));



					return repMinistraBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reprte de ministraciones", e);
			}
			return ListaResultado;
		}


	// consulta para reporte en excel de vencimientos
	public List consultaRepProxVencimientos(final CreditosBean creditosBean, int tipoLista){
		List ListaResultado=null;
		try{
		String query = 	"call VENCIMIENTOSREP(	 ?,?,?,?,?,	?,?,?,?,?, ?,?,?," +

												"?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteFecha(creditosBean.getFechaVencimien()),
							Utileria.convierteEntero(creditosBean.getSucursal()),
							Utileria.convierteEntero(creditosBean.getMonedaID()),
							Utileria.convierteEntero(creditosBean.getProducCreditoID()),

							Utileria.convierteEntero(creditosBean.getPromotorID()),
							creditosBean.getSexo(),
							Utileria.convierteEntero(creditosBean.getEstadoID()),
							Utileria.convierteEntero(creditosBean.getMunicipioID()),
							Utileria.convierteEntero(creditosBean.getAtrasoInicial()),

							Utileria.convierteEntero(creditosBean.getAtrasoFinal()),
							Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),
							Utileria.convierteEntero(creditosBean.getConvenioNominaID()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VENCIMIENTOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepVencimiBean repVencimiBean= new RepVencimiBean();
				//CreditoID	ClienteID	NombreCompleto	MontoCredito	FechaInicio
				repVencimiBean.setCreditoID(resultSet.getString("CreditoID"));
				repVencimiBean.setEstatus(resultSet.getString("EstatusCredito"));
				repVencimiBean.setClienteID(resultSet.getString("ClienteID"));
				repVencimiBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				repVencimiBean.setMontoCredito(resultSet.getString("MontoCredito"));
				repVencimiBean.setFechaInicio(resultSet.getString("FechaInicio"));
				//FechaVencimien	FechaVencim	Capital	Interes	Moratorios	Comisiones
				repVencimiBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
				repVencimiBean.setFechaVencim(resultSet.getString("FechaVencim"));
				repVencimiBean.setCapital(resultSet.getString("Capital"));
				repVencimiBean.setInteres(resultSet.getString("Interes"));
				repVencimiBean.setMoratorios(resultSet.getString("Moratorios"));
				repVencimiBean.setComisiones(resultSet.getString("Comisiones"));
				//Cargos	AmortizacionID	IVATotal
				repVencimiBean.setCargos(resultSet.getString("Cargos"));
				repVencimiBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				repVencimiBean.setIVATotal(resultSet.getString("IVATotal"));
				// 	ProductoCreditoID
				repVencimiBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				// 	TotalCuota	Pago	FechaPago	DiasAtraso	SaldoTotal
				repVencimiBean.setTotalCuota(resultSet.getString("TotalCuota"));
				if(resultSet.getString("Pago")==null){
					repVencimiBean.setPago("0.00");
				}
				else{
				repVencimiBean.setPago(resultSet.getString("Pago"));
				}
				if (resultSet.getString("FechaPago")==null){
					repVencimiBean.setFechaPago("");
				}
				else{
					repVencimiBean.setFechaPago(resultSet.getString("FechaPago"));
				}

				repVencimiBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
				repVencimiBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
				repVencimiBean.setFecha(resultSet.getString("FechaEmision"));
				repVencimiBean.setHora(resultSet.getString("HoraEmision"));
				repVencimiBean.setGrupoID(resultSet.getString("GrupoID"));
				repVencimiBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
				repVencimiBean.setInstitucionNominaID(resultSet.getString("InstitNominaID"));
				repVencimiBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));

				return repVencimiBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de vencimiento", e);
		}
		return ListaResultado;
	}

	// consulta para reporte en excel de Comisiones Pendientes de Pago
		public List consultaRepComisiones(final CreditosBean creditosBean, int tipoLista){
			List ListaResultado=null;
			try{
			String query = "call COMPENDPAGOREP(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteEntero(creditosBean.getClienteID()),
								Utileria.convierteEntero(creditosBean.getGrupoID()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),

					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMPENDPAGOREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepComisionBean repComisionBean= new RepComisionBean();
					// CreditoID	ClienteID	NombreCompleto
					repComisionBean.setCreditoID(resultSet.getString("CreditoID"));
					repComisionBean.setGrupoID(resultSet.getString("GrupoID"));
					repComisionBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					repComisionBean.setClienteID(resultSet.getString("ClienteID"));
					repComisionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					// 	ProducCreditoID	 DescripciÃ³n FechaDesembolso
					repComisionBean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
					repComisionBean.setDescripcion(resultSet.getString("Descripcion"));
					repComisionBean.setFechaInicio(resultSet.getString("FechaDesembolso"));
					// FechaVtoFinal FechaInicio FechaVencimiento No. Cuota Comisiones
					repComisionBean.setFechaVencimien(resultSet.getString("FechaVtoFinal"));
					repComisionBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
					repComisionBean.setFechaInicio(resultSet.getString("Inicio"));
					repComisionBean.setFechaVencim(resultSet.getString("Vencimiento"));
					repComisionBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
					repComisionBean.setComisiones(resultSet.getString("Comisiones"));
					// IVA
					repComisionBean.setIVATotal(resultSet.getString("IVA"));
					// Total
					repComisionBean.setTotal(resultSet.getString("Total"));

					return repComisionBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de comisiones pendientes de pago", e);
			}
			return ListaResultado;
		}


	// reporte de vencimientos pasivos 2013-01-20
	public List consultaRepVencimientosPasivos(final CreditosBean creditosBean, int tipoLista){
		List ListaResultado=null;
		try{
		String query = "call CARPASVENCIMREP(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteFecha(creditosBean.getFechaVencimien()),
							Utileria.convierteEntero(creditosBean.getSucursal()),
							Utileria.convierteEntero(creditosBean.getMonedaID()),
							Utileria.convierteEntero(creditosBean.getProducCreditoID()),
							Utileria.convierteEntero(creditosBean.getPromotorID()),
							creditosBean.getSexo(),
							Utileria.convierteEntero(creditosBean.getEstadoID()),
							Utileria.convierteEntero(creditosBean.getMunicipioID()),


				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARPASVENCIMREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepVencimiBean repVencimiBean= new RepVencimiBean();
				//CreditoID	ClienteID	NombreCompleto	MontoCredito	FechaInicio
				repVencimiBean.setInstitucionFondeo(resultSet.getString("NombreFondeador"));
				repVencimiBean.setCreditoID(resultSet.getString("CreditoID"));
				repVencimiBean.setClienteID(resultSet.getString("ClienteID"));
				repVencimiBean.setNombreCompleto(resultSet.getString("NombreCliente"));
				repVencimiBean.setMontoCredito(resultSet.getString("MontoFondeo"));
				repVencimiBean.setFechaInicio(resultSet.getString("FechaInicio"));
				//FechaVencimien	FechaVencim	Capital	Interes	Moratorios	Comisiones
				repVencimiBean.setFechaVencimien(resultSet.getString("FechaVencimiento"));
				repVencimiBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
				repVencimiBean.setFechaVencim(resultSet.getString("FechaExigible"));
				repVencimiBean.setCapital(resultSet.getString("Capital"));
				repVencimiBean.setInteres(resultSet.getString("InteresGenerado"));
				repVencimiBean.setMoratorios(resultSet.getString("Moratorios"));
				repVencimiBean.setComisiones(resultSet.getString("Comisiones"));
				//Cargos	AmortizacionID	IVATotal
				repVencimiBean.setCargos(resultSet.getString("Cargos"));
				repVencimiBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				repVencimiBean.setIVATotal(resultSet.getString("IVA"));
				// 	ProductoCreditoID
				repVencimiBean.setProductoCreditoID(resultSet.getString("ProductoCreID"));
				// 	TotalCuota	Pago	FechaPago	DiasAtraso	SaldoTotal
				repVencimiBean.setTotalCuota(resultSet.getString("TotCuota"));
				if(resultSet.getString("MontoPago")==null){
					repVencimiBean.setPago("0.00");
				}
				else{
				repVencimiBean.setPago(resultSet.getString("MontoPago"));
				}
				if (resultSet.getString("FechaPago")==null){
					repVencimiBean.setFechaPago("");
				}
				else{
					repVencimiBean.setFechaPago(resultSet.getString("FechaPago"));
				}

				repVencimiBean.setDiasAtraso(resultSet.getString("DiasAtraso"));

				repVencimiBean.setFecha(resultSet.getString("FechaEmision"));
				repVencimiBean.setHora(resultSet.getString("HoraEmision"));

				return repVencimiBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de vencimientos pasivos", e);
		}
		return ListaResultado;
	}


	//reporte de antiguedad de saldos 2013-01-20
	public List consultaRepAntDeSaldos(final CreditosBean creditosBean, int tipoLista){
		List ListaResultado=null;
		try{
		String query = "call CREANTSALDOSREP(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteEntero(creditosBean.getSucursal()),
							Utileria.convierteEntero(creditosBean.getMonedaID()),
							Utileria.convierteEntero(creditosBean.getProducCreditoID()),
							Utileria.convierteEntero(creditosBean.getPromotorID()),
							creditosBean.getSexo(),
							Utileria.convierteEntero(creditosBean.getEstadoID()),
							Utileria.convierteEntero(creditosBean.getMunicipioID()),

							Utileria.convierteEntero(creditosBean.getAtrasoInicial()),
							Utileria.convierteEntero(creditosBean.getAtrasoFinal()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREANTSALDOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepAntSaldosBean repAntSaldos= new RepAntSaldosBean();
		 //Credito	Cliente	NomCliente	MontoOriginal	FechaIni
				repAntSaldos.setCreditoID(resultSet.getString("Credito"));
				repAntSaldos.setClienteID(resultSet.getString("Cliente"));
				repAntSaldos.setNomCliente(resultSet.getString("NomCliente"));
				repAntSaldos.setMontoOriginal(resultSet.getString("MontoOriginal"));
				repAntSaldos.setFechaIni(resultSet.getString("FechaIni"));
		//FechaVencim	TotCap	CapVig	CapVen	ProdCredID
				repAntSaldos.setFechaVencim(resultSet.getString("FechaVencim"));
				repAntSaldos.setTotCap(resultSet.getString("TotCap"));
				repAntSaldos.setCapVig(resultSet.getString("CapVig"));
				repAntSaldos.setCapVen(resultSet.getString("CapVen"));
				repAntSaldos.setProdCredID(resultSet.getString("ProdCredID"));

		//NombrePromotor	PromotorID	NombreSucursal	SucursalID
				repAntSaldos.setNombrePromotor(resultSet.getString("NombrePromotor"));
				repAntSaldos.setPromotorID(resultSet.getString("PromotorID"));
				repAntSaldos.setNombreSucursal(resultSet.getString("NombreSucursal"));
				repAntSaldos.setSucursalID(resultSet.getString("SucursalID"));

		//ProductoCreID	NombreProducto	Bucket1	Bucket2	Bucket3	Bucket4
				repAntSaldos.setProductoCreID(resultSet.getString("ProductoCreID"));
				repAntSaldos.setNombreProducto(resultSet.getString("NombreProducto"));
				repAntSaldos.setBucket1(resultSet.getString("Bucket1"));
				repAntSaldos.setBucket2(resultSet.getString("Bucket2"));
				repAntSaldos.setBucket3(resultSet.getString("Bucket3"));
				repAntSaldos.setBucket4(resultSet.getString("Bucket4"));
		//Bucket5	Bucket6	Bucket7	Bucket8	Bucket9	MaxDiaAtr	FechaEmision	HoraEmision

				repAntSaldos.setBucket5(resultSet.getString("Bucket5"));
				repAntSaldos.setBucket6(resultSet.getString("Bucket6"));
				repAntSaldos.setBucket7(resultSet.getString("Bucket7"));
				repAntSaldos.setBucket8(resultSet.getString("Bucket8"));
				repAntSaldos.setBucket9(resultSet.getString("Bucket9"));
				repAntSaldos.setMaxDiaAtr(resultSet.getString("MaxDiaAtr"));
				repAntSaldos.setFecha(resultSet.getString("FechaEmision"));
				repAntSaldos.setHora(resultSet.getString("HoraEmision"));

				return repAntSaldos ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de anguedad de saldos", e);
		}
		return ListaResultado;
	}

// consulta para reporte en excel de Reporte de movimientos  2013-01-20
	public List consultaReporteMovimientosCredito(final CreditosBean creditosBean, int tipoLista){
		List ListaResultado=null;
		try{
			String query = "call CREDMOVIMIREP(?,?,?,?,?, ?,?,?,?,?)";

			Object[] parametros ={
					Utileria.convierteLong(creditosBean.getCreditoID()),
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaVencimien()),

		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDMOVIMIREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteMovimientosCreditosBean reporteMovimientosCreditosBean= new ReporteMovimientosCreditosBean();
					reporteMovimientosCreditosBean.setAmortiCreID(resultSet.getString("AmortiCreID"));
					reporteMovimientosCreditosBean.setTransaccion(resultSet.getString("Transaccion"));
					reporteMovimientosCreditosBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
					reporteMovimientosCreditosBean.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
					reporteMovimientosCreditosBean.setDescripcion(resultSet.getString("Descripcion"));
					reporteMovimientosCreditosBean.setTipoMovCreID(resultSet.getString("TipoMovCreID"));
					reporteMovimientosCreditosBean.setNatMovimiento(resultSet.getString("NatMovimiento"));
					reporteMovimientosCreditosBean.setMonedaID(resultSet.getString("MonedaID"));
					reporteMovimientosCreditosBean.setCantidad(resultSet.getString("Cantidad"));
					reporteMovimientosCreditosBean.setReferencia(resultSet.getString("Referencia"));
					reporteMovimientosCreditosBean.setTipoMov(resultSet.getString("TipoMov"));
					reporteMovimientosCreditosBean.setHoraMov(resultSet.getString("HoraMov"));
					reporteMovimientosCreditosBean.setFechaEmision(resultSet.getString("FechaEmision"));
					reporteMovimientosCreditosBean.setCuentaID(resultSet.getString("CuentaID"));
					reporteMovimientosCreditosBean.setHoraEmision(resultSet.getString("HoraEmision"));
					return reporteMovimientosCreditosBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de movimientos", e);
		}
		return ListaResultado;
	}


	// consulta para reporte en excel de Reporte de pagos por movimientos de credito
		public List consultaReporteMovimientosCreditoSum(final CreditosBean creditosBean, int tipoLista){
			List ListaResultado=null;
			try{
				String query = "call CREDMOVIMISUMREP(?,?,?,?,?, ?,?,?,?,?)";

				Object[] parametros ={
						Utileria.convierteLong(creditosBean.getCreditoID()),
						Utileria.convierteFecha(creditosBean.getFechaInicio()),
						Utileria.convierteFecha(creditosBean.getFechaVencimien()),

			    		parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDMOVIMISUMREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReporteMovimientosCreditosBean reporteMovimientosCreditosBean= new ReporteMovimientosCreditosBean();
						reporteMovimientosCreditosBean.setFecha(resultSet.getString("Fecha"));
						reporteMovimientosCreditosBean.setDescripcions(resultSet.getString("Descripcion"));
						reporteMovimientosCreditosBean.setMonto(Double.valueOf(resultSet.getString("Monto")).doubleValue());
						reporteMovimientosCreditosBean.setCapital(Double.valueOf(resultSet.getString("PagoCapital")).doubleValue());
						reporteMovimientosCreditosBean.setInteresNormal(Double.valueOf(resultSet.getString("PagoInteres")).doubleValue());
						reporteMovimientosCreditosBean.setIvainteresNormal(Double.valueOf(resultSet.getString("IVAInteres")).doubleValue());
						reporteMovimientosCreditosBean.setInteresMoratorio(Double.valueOf(resultSet.getString("PagoMora")).doubleValue());
						reporteMovimientosCreditosBean.setIvainteresMoratorio(Double.valueOf(resultSet.getString("IVAMora")).doubleValue());
						reporteMovimientosCreditosBean.setComisionFaltapago(Double.valueOf(resultSet.getString("PagoComisiones")).doubleValue());
						reporteMovimientosCreditosBean.setIvaComisiones(Double.valueOf(resultSet.getString("IVAComisiones")).doubleValue());
						reporteMovimientosCreditosBean.setHoraMov(resultSet.getString("HoraEmision"));
						reporteMovimientosCreditosBean.setMonedaID(resultSet.getString("MonedaID"));
						reporteMovimientosCreditosBean.setCuentaID(resultSet.getString("CuentaID"));
						reporteMovimientosCreditosBean.setMontoSeguroCuota(Double.valueOf(resultSet.getString("MontoSeguroCuota")));
						reporteMovimientosCreditosBean.setMontoIVASeguroCuota(Double.valueOf(resultSet.getString("MontoSeguroCuota")));
						reporteMovimientosCreditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
						return reporteMovimientosCreditosBean ;
					}
				});
				ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de movimientos", e);
			}
			return ListaResultado;
		}




	/* Lista de Creditos para Proceso de Cobranza Automatica */
	public List listaParaCobranzaAutomatica(int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call COBRANZAAUTOCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBRANZAAUTOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CobranzaAutomaticaBean cobranzaAutomaticaBean  =  new CobranzaAutomaticaBean();
				cobranzaAutomaticaBean.setCreditoID(resultSet.getString(1));
				cobranzaAutomaticaBean.setGrupoCreditoID(String.valueOf(resultSet.getInt(2)));
				cobranzaAutomaticaBean.setCicloGrupo(resultSet.getInt(3));
				cobranzaAutomaticaBean.setCuentaID(String.valueOf(resultSet.getLong(4)));
				cobranzaAutomaticaBean.setMontoExigible(resultSet.getDouble(5));
				cobranzaAutomaticaBean.setMonedaID(String.valueOf(resultSet.getInt(6)));
				cobranzaAutomaticaBean.setProrratea(String.valueOf(resultSet.getString("ProrrateaPago")));
				cobranzaAutomaticaBean.setEsAutomatico(String.valueOf(resultSet.getString("EsAutomatico")));
				cobranzaAutomaticaBean.setCobraGarFOGA(String.valueOf(resultSet.getString("GarantiaFOGA")));
				cobranzaAutomaticaBean.setCobraGarFOGAFI(String.valueOf(resultSet.getString("GarantiaFOGAFI")));

				return cobranzaAutomaticaBean;
			}
		});

		return matches;
	}

	/* Lista de Creditos para Proceso de Cobranza Automatica */
	public List listaParaCobranzaAutRefe(int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call COBRANZAAUTOCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBRANZAAUTOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CobranzaAutomaticaBean cobranzaAutomaticaBean  =  new CobranzaAutomaticaBean();
				cobranzaAutomaticaBean.setCreditoID(resultSet.getString(1));
				cobranzaAutomaticaBean.setGrupoCreditoID(String.valueOf(resultSet.getInt(2)));
				cobranzaAutomaticaBean.setCicloGrupo(resultSet.getInt(3));
				cobranzaAutomaticaBean.setCuentaID(String.valueOf(resultSet.getLong(4)));
				cobranzaAutomaticaBean.setMontoExigible(resultSet.getDouble(5));
				cobranzaAutomaticaBean.setMonedaID(String.valueOf(resultSet.getInt(6)));
				cobranzaAutomaticaBean.setProrratea(String.valueOf(resultSet.getString("ProrrateaPago")));
				cobranzaAutomaticaBean.setEsAutomatico(String.valueOf(resultSet.getString("EsAutomatico")));

				return cobranzaAutomaticaBean;
			}
		});

		return matches;
	}

	// Lista de Creditos para Proceso de Cobranza Automatica de Fin de DÃ­a
	// La que busca saldo en las cuentas de ahorro y aplica los pagos por el total
	// del adeudo del Grupo
	public List listaParaCobranzaAutomaticaFinDia(int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call COBRANZAAUTOCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBRANZAAUTOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CobranzaAutomaticaBean cobranzaAutomaticaBean  =  new CobranzaAutomaticaBean();
				cobranzaAutomaticaBean.setGrupoCreditoID(String.valueOf(resultSet.getInt(1)));
				cobranzaAutomaticaBean.setMontoExigible(resultSet.getDouble(2));
				cobranzaAutomaticaBean.setMonedaID(String.valueOf(resultSet.getInt(3)));
				cobranzaAutomaticaBean.setCicloGrupo(resultSet.getInt(4));

				return cobranzaAutomaticaBean;
			}
		});

		return matches;
	}

	// reporte de Estimaciones en excel
		public List consultaRepEstimacionesCredPrev(final CreditosBean creditosBean, int tipoLista){
			List ListaResultado=null;
			try{
			String query = "call ESTIMACREDPREVREP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getClienteID()),
								Utileria.convierteEntero(creditosBean.getGrupoID()),

								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),


					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESTIMACREDPREVREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepEstimacionesCredPrevBean repEstimacionesBean= new RepEstimacionesCredPrevBean();
					//CreditoID	ClienteID	NombreCompleto	MontoCredito	FechaInicio

					repEstimacionesBean.setCreditoID(resultSet.getString("CreditoID"));
					repEstimacionesBean.setClienteID(resultSet.getString("ClienteID"));
					repEstimacionesBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repEstimacionesBean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
					repEstimacionesBean.setDescripcion(resultSet.getString("Descripcion"));
					repEstimacionesBean.setFechaInicio(resultSet.getString("FechaInicio"));
					repEstimacionesBean.setFechaVencim(resultSet.getString("FechaVencimien"));
					repEstimacionesBean.setCapital(resultSet.getString("Capital"));
					repEstimacionesBean.setInteres(resultSet.getString("Interes"));
					repEstimacionesBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
					repEstimacionesBean.setCalificacion(resultSet.getString("Calificacion"));
					repEstimacionesBean.setPorcReserva(resultSet.getString("PorcReserva"));
					repEstimacionesBean.setMontoGarantia(resultSet.getString("MontoGarantia"));
					repEstimacionesBean.setReserva(resultSet.getString("Reserva"));
					repEstimacionesBean.setReservaInteres(resultSet.getString("ReservaInteres"));
					repEstimacionesBean.setTotalReserva(resultSet.getString("TotalReserva"));

					repEstimacionesBean.setSucursalID(resultSet.getString("SucursalID"));
					repEstimacionesBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					repEstimacionesBean.setPromotorID(resultSet.getString("PromotorActual"));
					repEstimacionesBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					repEstimacionesBean.setGrupoID(resultSet.getString("GrupoID"));
					repEstimacionesBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					repEstimacionesBean.setMonedaID(resultSet.getString("MonedaID"));
					repEstimacionesBean.setSexo(resultSet.getString("Sexo"));
					repEstimacionesBean.setHora(resultSet.getString("HoraEmision"));
					repEstimacionesBean.setReservaTotCubierto(resultSet.getString("ReservaTotCubierto"));
					repEstimacionesBean.setReservaTotExpuesto(resultSet.getString("ReservaTotExpuesto"));

					repEstimacionesBean.setEstatus(resultSet.getString("EstatusCredito"));
					repEstimacionesBean.setSaldoInteresVencido(resultSet.getString("SaldoInteresVencido"));
					repEstimacionesBean.setSaldoInteresAnterior(resultSet.getString("SaldoInteresAnterior"));
					repEstimacionesBean.setEsHipotecado(resultSet.getString("EsHipotecado"));
					repEstimacionesBean.setClasificacion(resultSet.getString("Clasificacion"));
					repEstimacionesBean.setTipoCredito(resultSet.getString("TipoCredito"));

					repEstimacionesBean.setPorcReservaCub(resultSet.getString("PorcReservaCub"));
					repEstimacionesBean.setZonaMarginada(resultSet.getString("ZonaMarginada"));
					repEstimacionesBean.setMontoBaseEstCub(resultSet.getString("MontoBaseEstCub"));
					repEstimacionesBean.setMontoBaseEstExp(resultSet.getString("MontoBaseEstExp"));
					repEstimacionesBean.setSubClasificacion(resultSet.getString("SubClasificacion"));

					return repEstimacionesBean ;

				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de vencimientos pasivos", e);
			}
			return ListaResultado;
		}

		// reporte de vencimientos pasivos 2013-01-20
		public List consultaRepCalificacionesPorcRes(final CreditosBean creditosBean, int tipoLista){
			List ListaResultado=null;
			try{
			String query = "call CALIFICAPORCENTRESREP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getClienteID()),
								Utileria.convierteEntero(creditosBean.getGrupoID()),

								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),


					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALIFICAPORCENTRESREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCalificacionPorcResBean repCalificacionsBean= new RepCalificacionPorcResBean();
					//CreditoID	ClienteID	NombreCompleto	MontoCredito	FechaInicio

					repCalificacionsBean.setCreditoID(resultSet.getString("CreditoID"));
					repCalificacionsBean.setClienteID(resultSet.getString("ClienteID"));
					repCalificacionsBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repCalificacionsBean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
					repCalificacionsBean.setDescripcion(resultSet.getString("Descripcion"));
					repCalificacionsBean.setFechaInicio(resultSet.getString("FechaInicio"));
					repCalificacionsBean.setFechaVencim(resultSet.getString("FechaVencimien"));
					repCalificacionsBean.setCapital(resultSet.getString("Capital"));
					repCalificacionsBean.setInteres(resultSet.getString("Interes"));
					repCalificacionsBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
					repCalificacionsBean.setClasificacion(resultSet.getString("Clasifica"));
					repCalificacionsBean.setCalificacion(resultSet.getString("Calificacion"));
					repCalificacionsBean.setPorcReserva(resultSet.getString("PorcReserva"));
					repCalificacionsBean.setSucursalID(resultSet.getString("SucursalID"));
					repCalificacionsBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
					repCalificacionsBean.setPromotorID(resultSet.getString("PromotorActual"));
					repCalificacionsBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					repCalificacionsBean.setGrupoID(resultSet.getString("GrupoID"));
					repCalificacionsBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					repCalificacionsBean.setMonedaID(resultSet.getString("MonedaID"));
					repCalificacionsBean.setSexo(resultSet.getString("Sexo"));
					repCalificacionsBean.setHora(resultSet.getString("HoraEmision"));
					repCalificacionsBean.setSubClasificacion(resultSet.getString("SubClasificacion"));

					return repCalificacionsBean ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de Calificación y Porcentaje de Reservas", e);
			}
			return ListaResultado;
		}
	/*CONSULTA PARA OBTENER DATOS ADICIONALES DE LA ACTIVIDAD DE CREDITO EN KUBO, USASO EN WS*/
	public ConsultaActividadCreditoResponse consultaActividadCredito(ConsultaActividadCreditoRequest consultaActividadCredito,int tipoConsulta) {
		//Query con el Store Procedure
		String query = 	"call CREDITOSWSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(consultaActividadCredito.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaActividadCredito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSWSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ConsultaActividadCreditoResponse consultaActividadCreditoResponse = new ConsultaActividadCreditoResponse();
				consultaActividadCreditoResponse.setActivosTotal(resultSet.getString(1));
				consultaActividadCreditoResponse.setTotalPrestado(resultSet.getString(2));
				consultaActividadCreditoResponse.setSaldoActual(resultSet.getString(3));
				consultaActividadCreditoResponse.setPesosenMora(resultSet.getString(4));
				consultaActividadCreditoResponse.setMoraMayor(resultSet.getString(5));
				consultaActividadCreditoResponse.setQuebrantos(resultSet.getString(6));
				consultaActividadCreditoResponse.setPagosPuntuales(resultSet.getString(7));
				consultaActividadCreditoResponse.setPagosRealizados(resultSet.getString(8));
				consultaActividadCreditoResponse.setMoraMenorTreintaDias(resultSet.getString(9));
				consultaActividadCreditoResponse.setMoraMayorTreintaDias(resultSet.getString(10));

				consultaActividadCreditoResponse.setCodigoRespuesta(resultSet.getString(11));
				consultaActividadCreditoResponse.setMensajeRespuesta(resultSet.getString(12));
				return consultaActividadCreditoResponse;
			}
		});
		return matches.size() > 0 ? (ConsultaActividadCreditoResponse) matches.get(0) : null;
	}

	/* Alta de la Bitacora de la Cobranza Automatica de Cartera */
	public MensajeTransaccionBean altaBitacoraCobAuto(final BitacoraCobAutoBean cobAutoBean) {
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
								String query = "call BITACORACOBAUTALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setDate("Par_FechaProceso", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_Estatus",cobAutoBean.getEstatus());
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(cobAutoBean.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cobAutoBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(cobAutoBean.getCuentaID()));
								sentenciaStore.setDouble("Par_SaldoDisponCta",cobAutoBean.getDisponibleCuenta());
								sentenciaStore.setDouble("Par_MontoExigible",cobAutoBean.getMontoExigible());
								sentenciaStore.setDouble("Par_MontoAplicado",cobAutoBean.getMontoAplicado());
								sentenciaStore.setDouble("Par_TiempoProceso",cobAutoBean.getTiempoProceso());
								sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(cobAutoBean.getGrupoID()));
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setString("Par_Salida",salidaPantalla);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
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

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CreditosDAO.altaBitacoraCobAuto");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CreditosDAO.altaBitacoraCobAuto");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de bitacora de cobranza automatica de cartera ", e);
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

	//Consulta la Bitacora de la Cobranza Automatica del dÃ­a
	public BitacoraCobAutoBean consultaCobranzaAutDelDia(final BitacoraCobAutoBean cobAutoBean,
												  int tipoConsulta) {
		// Query con el Store Procedure
		String query = " call BITACORACOBAUTCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cobAutoBean.getFechaProceso(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORACOBAUTCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				BitacoraCobAutoBean bitacoraBean = new BitacoraCobAutoBean();
				bitacoraBean.setNumeroPagosPorFecha(resultSet.getInt(1));
				bitacoraBean.setTiempoProceso(resultSet.getDouble(2));

			return bitacoraBean;

			}
		});

		return matches.size() > 0 ? (BitacoraCobAutoBean) matches.get(0) : null;
	}





	//Consulta datos generales para el contrato grupal
	public ContratoCredEncBean consultaEncContratoCred(final ContratoCredEncBean ContratoCredEncBean,
												  int tipoConsulta) {
		// Query con el Store Procedure
		String query = " call CONTRATOSCREDREP(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONTRATOSCREDREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ContratoCredEncBean contratoCredEncBean  = new ContratoCredEncBean();
				contratoCredEncBean.setRepresentanteLegal(resultSet.getString("Var_RepresentanteLegal"));
				contratoCredEncBean.setDireccionInstitucion(resultSet.getString("Var_DirccionInstitucion"));
				contratoCredEncBean.setGeneroRepresentante(resultSet.getString("Var_SexoRepteLegal"));
				contratoCredEncBean.setTelefonoInstitucion(resultSet.getString("Var_TelInstitucion"));
				contratoCredEncBean.setEstadoinstitucion(resultSet.getString("Var_NombreEstado"));
				contratoCredEncBean.setRFCOficial(resultSet.getString("Var_RFCOficial"));
				contratoCredEncBean.setDiaSistema(resultSet.getString("Var_DiaSistema"));
				contratoCredEncBean.setMesSistema(resultSet.getString("Var_MesSistema"));
				contratoCredEncBean.setAnioSistema(resultSet.getString("Var_AnioSistema"));
				contratoCredEncBean.setNombreCortoInstit(resultSet.getString("Var_NomCortoInstit"));
				contratoCredEncBean.setFirmaRepresentante(resultSet.getString("Var_Recurso"));


				return contratoCredEncBean;

			}
		});

		return matches.size() > 0 ? (ContratoCredEncBean) matches.get(0) : null;
	}
	//Consulta datos generales para el contrato grupal
		public ContratoCredEncBean consultaEncContratoCredInd(final ContratoCredEncBean ContratoCredEncBean,
													  int tipoConsulta) {
			// Query con el Store Procedure
			String query = " call CONTRATCREDINDREP(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONTRATOSCREDREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ContratoCredEncBean contratoCredEncBean  = new ContratoCredEncBean();
					contratoCredEncBean.setRepresentanteLegal(resultSet.getString("Var_RepresentanteLegal"));
					contratoCredEncBean.setDireccionInstitucion(resultSet.getString("Var_DirccionInstitucion"));
					contratoCredEncBean.setGeneroRepresentante(resultSet.getString("Var_SexoRepteLegal"));
					contratoCredEncBean.setTelefonoInstitucion(resultSet.getString("Var_TelInstitucion"));
					contratoCredEncBean.setEstadoinstitucion(resultSet.getString("Var_NombreEstado"));
					contratoCredEncBean.setRFCOficial(resultSet.getString("Var_RFCOficial"));
					contratoCredEncBean.setDiaSistema(resultSet.getString("Var_DiaSistema"));
					contratoCredEncBean.setMesSistema(resultSet.getString("Var_MesSistema"));
					contratoCredEncBean.setAnioSistema(resultSet.getString("Var_AnioSistema"));
					contratoCredEncBean.setNombreCortoInstit(resultSet.getString("Var_NomCortoInstit"));


					return contratoCredEncBean;

				}
			});

			return matches.size() > 0 ? (ContratoCredEncBean) matches.get(0) : null;
		}


	//Consulta la Bitacora de la Cobranza Automatica de Fin de DÃ­a
	//La que aplica los cargos Grupales


	public WsSgbResponse consumiendoWSKuboNotificacionPag(String Credito){

		 WsSgbResponse w= new WsSgbResponse();
		 try {

		WsSgbCrmServiceLocator serviceLocator = new WsSgbCrmServiceLocator();
           //WsSgbCrm	prueba =  serviceLocator.getWsSgbCrm();
           WsSgbCrm	prueba =  serviceLocator.getWsSgbCrm();
           w = prueba.paymentNotification(Credito);

				  } catch (Exception e) {

	                  e.printStackTrace();
	                  loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de bitacora de la cobranza automatica de fin de dia", e);

	            }
		 return w;
	}




	/* SIMULADOR DE PAGOS CON SALDOS GLOBALES */
	public List SimSaldosGlobales (final CreditosBean creditosBean){
		transaccionDAO.generaNumeroTransaccion();

		creditosBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

		String cobraAccesorios = creditosBean.getCobraAccesorios();
		String cobraAccesoriosGen = creditosBean.getCobraAccesoriosGen();

		if(cobraAccesorios.equalsIgnoreCase("S") && cobraAccesoriosGen.equalsIgnoreCase("S")) {
			altaAccesorios(creditosBean);
		}

		 List matches =new  ArrayList();
		 final List matches2 =new  ArrayList();

		 matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call PRINCIPALSIMSALGLOPRO(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,		" +
									"?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(creditosBean.getConvenioNominaID()));

							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getMontoCredito()));
							sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditosBean.getTasaFija()));
							sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditosBean.getPeriodicidadCap()));
							sentenciaStore.setString("Par_PagoCuota",creditosBean.getFrecuenciaCap());
							sentenciaStore.setString("Par_PagoFinAni",creditosBean.getDiaPagoCapital());

							sentenciaStore.setInt("Par_DiaMes",Utileria.convierteEntero(creditosBean.getDiaMesCapital()));
							sentenciaStore.setString("Par_FechaInicio",(creditosBean.getFechaInicio()));
							sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditosBean.getNumAmortizacion()));
							sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(creditosBean.getProducCreditoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditosBean.getClienteID()));

							sentenciaStore.setString("Par_DiaHabilSig",creditosBean.getFechaInhabil());
							sentenciaStore.setString("Par_AjustaFecAmo",creditosBean.getAjusFecUlVenAmo());
							sentenciaStore.setString("Par_AjusFecExiVen",creditosBean.getAjusFecExiVen());
							sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(creditosBean.getMontoComision()));
							sentenciaStore.setDouble("Par_MontoGL",Utileria.convierteDoble(creditosBean.getMontoGarLiq()));

							sentenciaStore.setString("Par_CobraSeguroCuota",creditosBean.getCobraSeguroCuota());
							sentenciaStore.setString("Par_CobraIVASeguroCuota",creditosBean.getCobraIVASeguroCuota());
							sentenciaStore.setDouble("Par_MontoSeguroCuota",Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
							sentenciaStore.setDouble("Par_ComAnualLin",Utileria.convierteDoble(creditosBean.getComAnualLin()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_Cat", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
							sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);

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

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();
							 while (resultadosStore.next()) {

								AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
								amortizacionCredito.setAmortizacionID(resultadosStore.getString(1));
								amortizacionCredito.setFechaInicio(resultadosStore.getString(2));
								amortizacionCredito.setFechaVencim(resultadosStore.getString(3));
								amortizacionCredito.setFechaExigible(resultadosStore.getString(4));
								amortizacionCredito.setCapital(resultadosStore.getString(5));
								amortizacionCredito.setInteres(resultadosStore.getString(6));
								amortizacionCredito.setIvaInteres(resultadosStore.getString(7));
								amortizacionCredito.setTotalPago(resultadosStore.getString(8));
								amortizacionCredito.setSaldoInsoluto(resultadosStore.getString(9));
								amortizacionCredito.setDias(resultadosStore.getString(10));
								amortizacionCredito.setCuotasCapital(resultadosStore.getString(11));
								amortizacionCredito.setNumTransaccion(resultadosStore.getString(12));
								amortizacionCredito.setCat(resultadosStore.getString(13));
								amortizacionCredito.setFecUltAmor(resultadosStore.getString(14));
								amortizacionCredito.setFecInicioAmor(resultadosStore.getString(15));
								amortizacionCredito.setMontoCuota(resultadosStore.getString(16));
								amortizacionCredito.setTotalCap(resultadosStore.getString(17));
								amortizacionCredito.setTotalInteres(resultadosStore.getString(18));
								amortizacionCredito.setTotalIva(resultadosStore.getString(19));
								amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
								amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
								amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
								amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
								amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
								amortizacionCredito.setSaldoOtrasComisiones(resultadosStore.getString("OtrasComisiones"));
								amortizacionCredito.setSaldoIVAOtrasCom(resultadosStore.getString("IVAOtrasComisiones"));
								amortizacionCredito.setTotalOtrasComisiones(resultadosStore.getString("TotalOtrasComisiones"));
								amortizacionCredito.setTotalIVAOtrasComisiones(resultadosStore.getString("TotalIVAOtrasComisiones"));
								amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
								amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));
								matches2.add(amortizacionCredito);
							}
						}
						return matches2;

						}
					});
			return matches;
}

	/**
	 * Método para consultar la informacion para el reporte de envío buró de crédito y el nombre del archivo a generar.
	 * @author avelasco
	 * @param creditosBean : Clase bean con los parámetros de entrada al SP.
	 * @param tipoLista : Número de lista para generar el reporte de la Cinta de Buró.
	 * @return List : Lista que contiene los registros del reporte.
	 */
	public List consultaReporteEnvioBuroCredito(final CreditosBean creditosBean, int tipoLista){
		List listaResultado = null;
		try{

			String query = "call BUROCREDINTFREP(?,?,?,?,?,		?,?,?,?,?, ?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								creditosBean.getTiempoReporte(),
								creditosBean.getTipoPersona(),
								Utileria.convierteEntero(creditosBean.getTipoFormatoCinta()),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BUROCREDINTFREP(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();
					creditosBean.setCinta(resultSet.getString("Cinta"));
					creditosBean.setNombreArchivoRepCinta(resultSet.getString("NombreArchivoCinta"));
					creditosBean.setHeaderINTL(resultSet.getString("HeaderINTL"));
					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de envio de buro de credito", e);
		}
		return listaResultado;
	}

	/* Proceso para reestructura de credito*/
	public MensajeTransaccionBean altaReestructura(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					if(creditos.getFrecuenciaInt().length()==3){
						creditos.setFrecuenciaInt(creditos.getFrecuenciaInt().substring(0,1));
					}

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOREESTALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?,	?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
							sentenciaStore.setLong("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
							sentenciaStore.setDouble("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
							sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
							sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
							sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(creditos.getFechaInicio()));
							sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(creditos.getFechaVencimien()));

							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
							sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
							sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));
							sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
							sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
							sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
							sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
							sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));
							sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());

							sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
							sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
							sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));
							sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
							sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
							sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
							sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
							sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));
							sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());

							sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
							sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
							sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
							sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));
							sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));
							sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
							sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
							sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
							sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));
							sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));

							sentenciaStore.setInt("Par_InstitFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
							sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));
							sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());
							sentenciaStore.registerOutParameter("Par_CreditoID", Types.BIGINT);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
						});
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de proceso de reestructura de credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin proceso reestructura

	/* Proceso para modificacion de  reestructura de credito*/
	public MensajeTransaccionBean modificaReestructura(final CreditosBean creditos) {
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
							String query = "call CREDITOREESTMOD(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(creditos.getClienteID()));
							sentenciaStore.setInt("Par_LinCreditoID",Utileria.convierteEntero(creditos.getLineaCreditoID()));
							sentenciaStore.setDouble("Par_ProduCredID",Utileria.convierteEntero(creditos.getProducCreditoID()));
							sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setLong("Par_Relacionado",Utileria.convierteLong(creditos.getRelacionado()));
							sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
							sentenciaStore.setDouble("Par_MontoCredito",Utileria.convierteDoble(creditos.getMontoCredito()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(creditos.getFechaInicio()));

							sentenciaStore.setString("Par_FechaVencim",Utileria.convierteFecha(creditos.getFechaVencimien()));
							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditos.getFactorMora()));
							sentenciaStore.setInt("Par_CalcInterID",Utileria.convierteEntero(creditos.getCalcInteresID()));
							sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditos.getTasaBase()));
							sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditos.getTasaFija()));
							sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditos.getSobreTasa()));
							sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditos.getPisoTasa()));
							sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditos.getTechoTasa()));
							sentenciaStore.setString("Par_FrecuencCap",creditos.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodCap",Utileria.convierteEntero(creditos.getPeriodicidadCap()));

							sentenciaStore.setString("Par_FrecuencInt",creditos.getFrecuenciaInt());
							sentenciaStore.setInt("Par_PeriodicInt",Utileria.convierteEntero(creditos.getPeriodicidadInt()));
							sentenciaStore.setString("Par_TPagCapital",creditos.getTipoPagoCapital());
							sentenciaStore.setInt("Par_NumAmortiza",Utileria.convierteEntero(creditos.getNumAmortizacion()));
							sentenciaStore.setString("Par_FecInhabil",creditos.getFechaInhabil());
							sentenciaStore.setString("Par_CalIrregul",creditos.getCalendIrregular());
							sentenciaStore.setString("Par_DiaPagoInt",creditos.getDiaPagoInteres());
							sentenciaStore.setString("Par_DiaPagoCap",creditos.getDiaPagoCapital());
							sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditos.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditos.getDiaMesCapital()));

							sentenciaStore.setString("Par_AjFUlVenAm",creditos.getAjusFecUlVenAmo());
							sentenciaStore.setString("Par_AjuFecExiVe",creditos.getAjusFecExiVen());
							sentenciaStore.setInt("Par_InsFondeoID",Utileria.convierteEntero(creditos.getInstitFondeoID()));
							sentenciaStore.setInt("Par_LineaFondeo",Utileria.convierteEntero(creditos.getLineaFondeo()));
							sentenciaStore.setDate("Par_FecTraspVen",OperacionesFechas.conversionStrDate(creditos.getFechTraspasVenc()));
							sentenciaStore.setDate("Par_FechTermina",OperacionesFechas.conversionStrDate(creditos.getFechTerminacion()));
							sentenciaStore.setInt("Par_NumTransacSim",Utileria.convierteEntero(creditos.getNumTransacSim()));
							sentenciaStore.setString("Par_TipoFondeo",creditos.getTipoFondeo());
							sentenciaStore.setDouble("Par_MonComApe",Utileria.convierteDoble(creditos.getMontoComision()));
							sentenciaStore.setDouble("Par_IVAComApe",Utileria.convierteDoble(creditos.getIVAComApertura()));

						    sentenciaStore.setDouble("Par_ValorCAT",Utileria.convierteDoble(creditos.getCat()));
							sentenciaStore.setString("Par_Plazo",creditos.getPlazoID());
							sentenciaStore.setString("Par_TipoDisper",creditos.getTipoDispersion());
							sentenciaStore.setInt("Par_TipoCalInt",Utileria.convierteEntero(creditos.getTipoCalInteres()));
							sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(creditos.getDestinoCreID()));
							sentenciaStore.setInt("Par_NumAmortInt",Utileria.convierteEntero(creditos.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.setString("Par_ClasiDestinCred",creditos.getClasiDestinCred());


							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
						});
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de proceso de reestructura de credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin proceso reestructura

	// llama al store que calcula el esquema de tasa
	/**
	 * Obtiene la tasa que le corresponde al crédito
	 * @param cicloClienteBean
	 * @return
	 */
	public CicloCreditoBean consultaTasaCredPrin(final CicloCreditoBean cicloClienteBean) {
		CicloCreditoBean mensaje = new CicloCreditoBean();

		mensaje = (CicloCreditoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				CicloCreditoBean mensajeBean = new CicloCreditoBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (CicloCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ESQUEMATASACALPRO("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cicloClienteBean.getSucursal()));
									sentenciaStore.setInt("Par_ProdCreID",Utileria.convierteEntero(cicloClienteBean.getProductoCreditoID()));
									sentenciaStore.setInt("Par_NumCreditos",cicloClienteBean.getNumCreditos());
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(cicloClienteBean.getMontoCredito()));
									sentenciaStore.setString("Par_Califi",cicloClienteBean.getCalificaCliente());

									sentenciaStore.registerOutParameter("Par_TasaFija",Types.DOUBLE);
									sentenciaStore.registerOutParameter("Par_NivelID",Types.INTEGER);
									sentenciaStore.setString("Par_PlazoID",cicloClienteBean.getPlazoID());
									sentenciaStore.setInt("Par_EmpresaNomina",Utileria.convierteEntero(cicloClienteBean.getEmpresaNomina()));
									sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(cicloClienteBean.getConvenioNominaID()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Aud_FechaActual",Constantes.FECHA_VACIA);

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
										cicloCliente.setValorTasa(resultadosStore.getString("ValorTasa"));

									}
									return cicloCliente;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new CicloCreditoBean();
							throw new Exception(Constantes.MSG_ERROR + " .CreditosDAO.consultaTasaCredPrin");
						}
					} catch (Exception e) {


						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en calcular el esquema de tasa", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	//1.-  para consultar los detalles del pago de Credito
	public DetallePagoBean consultaDetallePagoCredito(final DetallePagoBean detallePagoBean, final int tipoConsulta) {
		DetallePagoBean detallePago = null;
		try {
			String query = "call DETALLEPAGCRECON(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteLong(detallePagoBean.getCreditoID()),
					detallePagoBean.getFechaPago(),

					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"Creditos DAO ",
					Constantes.ENTERO_CERO,
					detallePagoBean.getTransaccion() };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call DETALLEPAGCRECON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					try {
						DetallePagoBean detallePagoBean = new DetallePagoBean();

						detallePagoBean.setMontoTotal(resultSet.getString("MontoTotal"));
						detallePagoBean.setCapital(resultSet.getString("Capital"));
						detallePagoBean.setInteres(resultSet.getString("Interes"));
						detallePagoBean.setMontoIntMora(resultSet.getString("MontoIntMora"));

						detallePagoBean.setMontoIVA(resultSet.getString("MontoIVA"));
						detallePagoBean.setMontoComision(resultSet.getString("MontoComision"));
						detallePagoBean.setMontoGastoAdmon(resultSet.getString("MontoGastoAdmon"));
						detallePagoBean.setTotalPago(resultSet.getString("TotalPago"));

						detallePagoBean.setTransaccion(resultSet.getString("Transaccion"));
						detallePagoBean.setNombreCompelto(resultSet.getString("NombreCompleto"));

						detallePagoBean.setTotalAdeudo(resultSet.getString("OutTotalAde"));
						detallePagoBean.setMontoPagado(resultSet.getString("OutMontoPag"));
						detallePagoBean.setProximaFechaPago(resultSet.getString("OutProxFecPag"));

						detallePagoBean.setHora(resultSet.getString("Hora"));
						detallePagoBean.setClienteID(resultSet.getString("ClienteID"));
						detallePagoBean.setTotalDeudaPend(resultSet.getString("TotalDeuda"));
						detallePagoBean.setCapitalInsoluto(resultSet.getString("CapitalInsoluto"));
						//SEGUROS
						detallePagoBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
						detallePagoBean.setiVASeguroCuota(resultSet.getString("MontoIVASeguroCuota"));
						//COM ANUAL
						detallePagoBean.setSaldoComAnual(resultSet.getString("MontoComAnual"));
						detallePagoBean.setSaldoComAnualIVA(resultSet.getString("MontoComAnualIVA"));
						return detallePagoBean;
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					return null;
				}
			});
			detallePago = matches.size() > 0 ? (DetallePagoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar datos del pago", e);
		}
		return detallePago;
	}


public MensajeTransaccionBean validaSolicitud(final CreditosBean creditos) {
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
								String query = "call CREDGRUPALALTAVAL(?,?,?,?,?,    ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Grupo",Utileria.convierteEntero(creditos.getGrupoID()));
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(creditos.getSucursalID()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de credito grupal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// prepago de credito individual con cargo a cuenta
		public MensajeTransaccionBean prepagoCredito(final CreditosBean creditos) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean=new PolizaBean();

			polizaBean.setConceptoID(CreditosBean.pagoCredito);
			polizaBean.setConcepto(CreditosBean.desPagoCredito);

			int	contador  = 0;
			while(contador <= PolizaBean.numIntentosGeneraPoliza){
				contador ++;
				polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
					break;
				}
			}
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String poliza =polizaBean.getPolizaID();
					try {
						creditos.setPolizaID(poliza);
						mensajeBean=prepagoCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion(), Constantes.ORIGEN_PAGO_CARGOCTA);
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en prepago de credito", e);
					}
					return mensajeBean;
				}

			});
			/* Baja de Poliza en caso de que haya ocurrido un error */
			if (mensaje.getNumero() != 0) {
				try {
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
					bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
					bajaPolizaBean.setDescProceso("CreditosDAO.prepagoCredito");
					bajaPolizaBean.setPolizaID(creditos.getPolizaID());
					MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
					mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
					loggerSAFI.error("CreditosDAO.prepagoCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			/* Fin Baja de la Poliza Contable*/
		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
		}
public MensajeTransaccionBean prepagoCredito(final CreditosBean creditos,final long numeroTransaccion, final String origenPago) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {

						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PREPAGOCREDITOPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);
							sentenciaStore.setDouble("Par_MontoPago",Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.setInt("Var_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo",Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_CARGO_CUENTA);
							sentenciaStore.setString("Par_Origen", origenPago);
							sentenciaStore.setString("Par_RespaldaCred","S" );

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
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

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl("numeroTransaccion");
								mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString("consecutivo")));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}

			} catch (Exception e) {
				if (mensajeBean.getNumero()==0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en prepago de credito", e);
				transaction.setRollbackOnly();
			}

			return mensajeBean;
		}

	});
	return mensaje;
}
	/**
	 * Método para realizar el proceso de Pago de Crédito Individual
	 * @param creditos : Bean CreditosBean con la información del Crédito a prepagar
	 * @param numeroTransaccion : Número de Transacción
	 * @param numeroPoliza : Número de Poliza
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean prepagoCredito(final CreditosBean creditos, final long numeroTransaccion, final int numeroPoliza, final boolean origenVentanilla, final String origenPago) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PREPAGOCREDITOPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo); // no damos de alta la poliza ya que se da de alta en CARGOABONOCTAPRO
							sentenciaStore.setDouble("Par_MontoPago", Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.setInt("Var_Poliza", numeroPoliza);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_EFECTIVO);
							sentenciaStore.setString("Par_Origen",	origenPago );
							sentenciaStore.setString("Par_RespaldaCred","S" );

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(String.valueOf(numeroTransaccion));

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
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en prepago de credito", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en prepago de credito", e);
					}
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
	}

	//  Prepago de Credito GRUPAL con cargo a cuenta
	public MensajeTransaccionBean prepagoCreditoGrupal(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					creditos.setOrigenPago(Constantes.ORIGEN_PAGO_CARGOCTA);
					mensajeBean=prepagoCreditoGrupo(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en prepago de credito grupal", e);
				}
				return mensajeBean;
			}
		});
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
	mensaje.setNombreControl("numeroTransaccion");
	mensaje.setConsecutivoString("0");
	}
	return mensaje;
	}

	/**
	 * Pago de Crédito Grupal con Cargo a Cta
	 * @param creditos
	 * @param numeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean prepagoCreditoGrupo(final CreditosBean creditos, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		creditos.setOrigenPago(Constantes.ORIGEN_PAGO_CARGOCTA);

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						String formaPago = "C";

						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PREPAGOGRUPALCREPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setLong("Par_CuentaPago", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_FormaPago", formaPago);

							sentenciaStore.setInt("Par_CicloGrupo", Utileria.convierteEntero(creditos.getCicloGrupo()));
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_OrigenPago", creditos.getOrigenPago());
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Var_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
							sentenciaStore.setDouble("Var_MontoPago", Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl("numeroTransaccion"); // para el ticket
								mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString("consecutivo"))); // para el ticket

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en prepago de credito", e);
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
	}

	/**
	 * Prepago de credito GRUPAL en efectivo (Ventanilla)
	 * @param creditos : Bean {@link CreditosBean} con la información del Crédito Grupal a pagar
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean prepagoCreditoGrupal(final CreditosBean creditos, final long NumeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PREPAGOGRUPALCREPRO("
									+ "?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(creditos.getGrupoID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(creditos.getMontoPagar()));
							sentenciaStore.setLong("Par_CuentaPago", Utileria.convierteLong(creditos.getCuentaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(creditos.getMonedaID()));
							sentenciaStore.setString("Par_FormaPago", creditos.getFormaPago());

							sentenciaStore.setInt("Par_CicloGrupo", Utileria.convierteEntero(creditos.getCicloGrupo()));
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_AltaEncPoliza", CreditosDAO.altaEnPolizaNo);
							sentenciaStore.setString("Par_OrigenPago", creditos.getOrigenPago());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Var_Poliza", Utileria.convierteEntero(creditos.getPolizaID()));
							sentenciaStore.setDouble("Var_MontoPago", Utileria.convierteDoble(creditos.getMontoCuota()));
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", NumeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control")); // para el ticket
								mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString("consecutivo"))); // para el ticket

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
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en prepago de credito", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en prepago de credito", e);
					}
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
	}

/* Lista todos los creditos de un cliente */
public List listaTodosCreditoCte(CreditosBean creditosBean, int tipoLista) {
	List listaCredVig = null ;
	try{
		// Query con el Store Procedure
		String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getCreditoID(),
								Utileria.convierteEntero(creditosBean.getClienteID()),
								Constantes.FECHA_VACIA,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString(1));
				creditosBean.setClienteID(resultSet.getString(2));
				creditosBean.setEstatus(resultSet.getString(3));
				creditosBean.setFechaInicio(resultSet.getString(4));
				creditosBean.setFechaVencimien(resultSet.getString(5));
				creditosBean.setNombreProducto(resultSet.getString(6));
				return creditosBean;
			}
		});

		listaCredVig= matches;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos", e);
	}
	return listaCredVig;
}
/* Lista de creditos vigentes o vencidos de un cliente*/

	public List listaCreditosVigentesOVencidosCli(CreditosBean creditosBean, int tipoLista) {
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Utileria.convierteEntero(creditosBean.getClienteID()),
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de creditos", e);
		}
		return listaCredVig;
	}

public List listaTipoBloq(CreditosBean creditosBean, int tipoLista) {
	List creditosLis = null;
	try{
		// Query con el Store Procedure

		String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.STRING_CERO,
					    		creditosBean.getClienteID(),
					    		Constantes.FECHA_VACIA,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								OperacionesFechas.FEC_VACIA,
								Constantes.STRING_VACIO,
								"listaTipoBloq",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				creditosBean.setCreditoID(resultSet.getString(1));
				creditosBean.setClienteID(resultSet.getString(2));
				creditosBean.setCredito_Descripcion_Monto(resultSet.getString(3));
				return creditosBean;
			}
		});

		creditosLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos no Desembolsados", e);
	}
	return creditosLis;
}




	// Lista de Creditos Vigenres de un Cliente
	public List listaCreditosVigentesCte(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getNombreCliente(),
					creditosBean.getClienteID(),
					Constantes.FECHA_VACIA,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("DescripPro"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setTotalAdeudo(resultSet.getString("TotalAdeConIVA"));
					creditosBean.setTotalAdeudoSinIva(resultSet.getString("TotalAdeSinIVA"));

					creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
					creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Creditos Vigentes por Cliente", e);
		}
		return listaCredAutInac;
	}

//lista de creditos con su tipo de prepago (Grid de creditos Grupales)
	public List listaGrid(CreditosBean creditosBean){

		List<String> creditosLis  = creditosBean.getLcreditos();
		List<String> tipoPrepagoLis   = creditosBean.getLtipoPrepago();
		ArrayList listaDetalle = new ArrayList();
		CreditosBean creditos = new CreditosBean();
		if(tipoPrepagoLis !=null){
			try{
			int tamanio = tipoPrepagoLis.size();
				for(int i=0; i<tamanio; i++){

					creditos = new CreditosBean();
					creditos.setCreditoID(creditosLis.get(i));
					creditos.setTipoPrepago(tipoPrepagoLis.get(i));
					listaDetalle.add(i,creditos);
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de Creditos Grupales", e);
		}
	}
	return listaDetalle;
}

// fin de lista para WS
	/* Lista de Linea Creditos Lista 21, 22, 23,24,25, 26,28*/
	public List listaCreditos(CreditosBean creditosBean, int tipoLista) {
		String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getNombreCliente(),
								Utileria.convierteEntero(creditosBean.getClienteID()),
								Constantes.FECHA_VACIA,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditosBean creditosBean = new CreditosBean();

				creditosBean.setCreditoID(Utileria.completaCerosIzquierda(resultSet.getString("CreditoID"),CreditosBean.LONGITUD_ID));
				creditosBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),10));
				creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
				creditosBean.setEstatus(resultSet.getString("Estatus"));
				creditosBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
				creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
				creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
				creditosBean.setNombreProducto(resultSet.getString("Descripcion"));
				creditosBean.setFecha(resultSet.getString("FechaNacimiento"));


				return creditosBean;
			}
		});

		return matches;
	}// fin de la lista



	/* Lista de creditos avalados por un cliente, para grid*/
	public List listaCreditosAvalados(CreditosBean bean, int tipoLista) {
		String query = "call CREDITOSLIS(?,?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Utileria.convierteEntero(bean.getClienteID()),
								Constantes.FECHA_VACIA,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditos = new CreditosBean();

				creditos.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
				creditos.setCreditoID(Utileria.completaCerosIzquierda(resultSet.getString("CreditoID"),ClienteBean.LONGITUD_ID));
				creditos.setNombreCliente(resultSet.getString("NombreCompleto"));
				creditos.setProducCreditoID(resultSet.getString("Descripcion"));
				creditos.setEstatus(resultSet.getString("Estatus"));
				creditos.setDiasAtraso(resultSet.getString("DiasAtraso"));
				creditos.setMontoCredito(resultSet.getString("MontoCredito"));
				creditos.setSaldoCapVigent(resultSet.getString("SaldoCapitalDia"));

				return creditos;
			}
		});
		return matches;
	} // fin de lista


	// ***************************LISTA DE METODOS QUE NO TIENE QA**************************
	//--------LISTA SOLICITUD DE CREDITOS WS
	public List listaSolCreditos(final ListaSolicitudCreditoRequest creditosBean){

		List creditosLis = null;
		try{
			// Query con el Store Procedure

			String query = "call SOLICICREDITOWSREP(?,?,?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(creditosBean.getNegocioAfiliadoID()),
									Utileria.convierteEntero(creditosBean.getInstitNominaID()),
									Utileria.convierteEntero(creditosBean.getClienteID()),
									Utileria.convierteEntero(creditosBean.getProspectoID()),
						    		creditosBean.getEstatus(),
						    		Utileria.convierteEntero(creditosBean.getTipoCon()),

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCreditosCliente",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICICREDITOWSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("SolicitudID"));
					creditosBean.setClienteID(resultSet.getString("Cliente"));
					creditosBean.setDescripcionCredito(resultSet.getString("ProductoCRedito"));
					creditosBean.setFechaInicio(resultSet.getString("FechaSolicitud"));
					creditosBean.setMontoCredito(resultSet.getString("MontoSolicitado"));
					creditosBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					creditosBean.setTelefonoInst(resultSet.getString("TelPromotor"));
					return creditosBean;
				}
			});

			creditosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de clientes vigentes", e);
		}
		return creditosLis;
	}
 //Lista de Creditos para Descuentos de Nomina
	public List listaDescuentoNominaWS(ConsultaDescuentosNominaRequest consultaDescuentosNominaRequest, int tipoLista){
		final ConsultaDescuentosNominaResponse mensajeBean = new ConsultaDescuentosNominaResponse();
		String query = "call CREDITONOMINABEREP(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(consultaDescuentosNominaRequest.getInstitNominaID()),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.listaDescuentoNominaWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITONOMINABEREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
		CreditosBean creditosBean = new CreditosBean();

		creditosBean.setClienteID(resultSet.getString("ClienteID"));
		creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
		creditosBean.setCreditoID(resultSet.getString("CreditoID"));
		creditosBean.setFechaPago(resultSet.getString("FechaExigible"));
		creditosBean.setMontoExigible(resultSet.getString("MontoExigible"));
			return creditosBean;
			}
	});
		return matches;
	}


	// Lista de Pagos Aplicados de Credito
		public List pagosAplicados(ConsultaPagosAplicadosRequest consultaPagosAplicadosRequest){
			final ConsultaPagosAplicadosResponse mensajeBean = new ConsultaPagosAplicadosResponse();
			String query = "call PAGOCREDITOWSREP(?,?,?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(consultaPagosAplicadosRequest.getNegocioAfiliadoID()),
					Utileria.convierteEntero(consultaPagosAplicadosRequest.getInstitNominaID()),
					Utileria.convierteEntero(consultaPagosAplicadosRequest.getClienteID()),
					OperacionesFechas.conversionStrDate(consultaPagosAplicadosRequest.getFechaInicio()),
					OperacionesFechas.conversionStrDate(consultaPagosAplicadosRequest.getFechaFin()),
					Utileria.convierteEntero(consultaPagosAplicadosRequest.getTipoCon()),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.pagosAplicados",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOCREDITOWSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CreditosBean creditosBean = new CreditosBean();

			creditosBean.setClienteID(resultSet.getString("Cliente"));
			creditosBean.setCreditoID(resultSet.getString("Credito"));
			creditosBean.setFechaPago(resultSet.getString("FechaPago"));
			creditosBean.setMontoPagar(resultSet.getString("MontoPago"));
			creditosBean.setProducCreditoID(resultSet.getString("ProductoCredito"));
				return creditosBean;
				}
		});
			return matches;
		}


 // Simulador para la Solicitud de CrÃ©dito en Banca en Linea
 public List SimPagCrecientesWS(final SimuladorCreditoRequest simuladorCreditosRequest){
   transaccionDAO.generaNumeroTransaccion();
	 List matches =new  ArrayList();
	 final List matches2 =new  ArrayList();
	 AmortizacionCreditoBean amortizacionCred = null;
	 final AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
	 matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			 new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

				String query = "call CREPAGCRECAMORPROWS(" +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?,?,    " +
						"?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(simuladorCreditosRequest.getMonto()));
					sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(simuladorCreditosRequest.getTasa()));
					sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(simuladorCreditosRequest.getPeriodicidad()));
					sentenciaStore.setString("Par_PagoCuota",simuladorCreditosRequest.getFrecuencia());
					sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(simuladorCreditosRequest.getFechaInicio()));
					sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(simuladorCreditosRequest.getNumeroCuotas()));
					sentenciaStore.setInt("Par_ProdCredID",Utileria.convierteEntero(simuladorCreditosRequest.getProductoCreditoID()));
					sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(simuladorCreditosRequest.getClienteID()));
					sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(simuladorCreditosRequest.getComisionApertura()));
					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
					sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
					sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_Cat", Types.DOUBLE);
					sentenciaStore.registerOutParameter("Par_MontoCuo", Types.DOUBLE);
					sentenciaStore.registerOutParameter("Par_FechaVen", Types.CHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
					// log.info(parametrosAuditoriaBean.getNombrePrograma()+"|"+sentenciaStore.toString());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
				},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

							 while (resultadosStore.next()) {

						AmortizacionCreditoBean	amortizacionCredito	=new AmortizacionCreditoBean();
								amortizacionCredito.setAmortizacionID(resultadosStore.getString(1));
								amortizacionCredito.setFechaInicio(resultadosStore.getString(2));
								amortizacionCredito.setFechaVencim(resultadosStore.getString(3));
								amortizacionCredito.setFechaExigible(resultadosStore.getString(4));
								amortizacionCredito.setCapital(resultadosStore.getString(5));
								amortizacionCredito.setInteres(resultadosStore.getString(6));
								amortizacionCredito.setIvaInteres(resultadosStore.getString(7));
								amortizacionCredito.setTotalPago(resultadosStore.getString(8));
								amortizacionCredito.setSaldoInsoluto(resultadosStore.getString(9));
								amortizacionCredito.setDias(resultadosStore.getString(10));
								amortizacionCredito.setCuotasCapital(resultadosStore.getString(11));
								amortizacionCredito.setNumTransaccion(resultadosStore.getString(12));
								amortizacionCredito.setCat(resultadosStore.getString(13));
								amortizacionCredito.setFecUltAmor(resultadosStore.getString(14));
								amortizacionCredito.setFecInicioAmor(resultadosStore.getString(15));
								amortizacionCredito.setMontoCuota(resultadosStore.getString(16));
								amortizacionCredito.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
								amortizacionCredito.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
								amortizacionCredito.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
								amortizacionCredito.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
								amortizacionCredito.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
								amortizacionCredito.setCodigoError(resultadosStore.getString("NumErr"));
								amortizacionCredito.setMensajeError(resultadosStore.getString("ErrMen"));
								matches2.add(amortizacionCredito);
							}
						}
							return matches2;

						}
					});
			 		CreditosBean creditos = new  CreditosBean();
			 		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
			 		bajaEnTemporal(creditos);
			return matches;
	}

	//--------LISTA CREDITOS WS
	public List listaCreditos(final ListaCreditosBERequest creditosBean, int tipoLista){

		List creditosLis = null;
		try{
			// Query con el Store Procedure

			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.STRING_CERO,
						    		creditosBean.getClienteID(),
						    		Constantes.FECHA_VACIA,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCreditosCliente",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setCreditoProductoMonto(resultSet.getString(2));
					return creditosBean;
				}
			});

			creditosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de clientes vigentes", e);
		}
		return creditosLis;
	}


	/* Lista de creditos Individuales para Reestructuras (todos los estatus)*/
	public List listaCreditosReestructura(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString(1));
					creditosBean.setClienteID(resultSet.getString(2));
					creditosBean.setEstatus(resultSet.getString(3));
					creditosBean.setFechaInicio(resultSet.getString(4));
					creditosBean.setFechaVencimien(resultSet.getString(5));
					creditosBean.setNombreProducto(resultSet.getString(6));
					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de credito individual", e);
		}
		return listaCredAutInac;
	}


	/*LISTA TODOS LOS CREDITOS QUE UN CLIENTE ESTE AVALANDO Y QUE ESTEN VENCIDOS, CASTIGADOS O QUE TENGAN DIAS DE ATRASO
										  SI EL CLIENTE FUE PROSPECTO Y QUE AVALO UN CREDITO TAMBIEN SE MUESTRA EL CREDITO SI SE ENCUENTRA EN LAS CONDICIONES
										  ANTERIORES*/
	public List listaCreditosAvaladosCte(CreditosBean bean, int tipoLista) {
		String query = "call CREDITOSLIS(?,?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Utileria.convierteEntero(bean.getClienteID()),
								Constantes.FECHA_VACIA,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditos = new CreditosBean();
				creditos.setCreditoID(Utileria.completaCerosIzquierda(resultSet.getString("CreditoID"),ClienteBean.LONGITUD_ID));
				creditos.setEstatus(resultSet.getString("Estatus"));
				creditos.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID));
				creditos.setDiasAtraso(resultSet.getString("DiasAtraso"));
				return creditos;
			}
		});
		return matches;
	} // fin de lista

	// Lista para Ultimos 5 Creditos Liquidados usado en pantalla de operaciones Inusuales
	public List listaCreditosLiq(CreditosBean creditosBean, int tipoLista) {
		List listaCredAutInac = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					creditosBean.getClienteID(),
					creditosBean.getFechaDeteccion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID")+ " " +resultSet.getString("DesProductoCredito"));
					creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
					creditosBean.setFechTerminacion(resultSet.getString("FechTerminacion"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setNombreUsuario(resultSet.getString("UsuarioAltaSol")+" "+resultSet.getString("NombreCompleto"));
					creditosBean.setDesDestinoCredito(resultSet.getString("DestinoCredito"));
					creditosBean.setProyecto(resultSet.getString("Proyecto"));

					return creditosBean;
				}
			});

			listaCredAutInac= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Generear Creditos Liquidados", e);
		}
		return listaCredAutInac;
	}

	// Pago de Interes con Cargo a Cuenta
	public MensajeTransaccionBean pagoInteresCredito(final CreditosBean creditos, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	//	transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {

							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PAGOINTERESCREPRO("
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?,?,?,?,?,		"
										+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
								sentenciaStore.setString("Par_ModoPago","C");
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
								sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_CARGOCTA);
								sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(creditos.getPolizaID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
										resultadosStore.next();

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(String.valueOf(NumeroTransaccion));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});


					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Interes  con Cargo a Cuenta en Credito", e);
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
	}



	// Pago de Crédito Vertical con Cargo a Cuenta
		public MensajeTransaccionBean pagoVerticalCredito(final CreditosBean creditos, final long NumeroTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//	transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PAGOCREVERTICALPRO("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
									sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
									sentenciaStore.setString("Par_ModoPago","C");
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
									sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(creditos.getPolizaID()));
									sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_CARGOCTA);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
											resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(NumeroTransaccion));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});


						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero()==0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Interes  con Cargo a Cuenta en Credito", e);
						transaction.setRollbackOnly();
					}

					return mensajeBean;
				}

			});
			return mensaje;
		}


		// Pago de Comisiones con Cargo a Cuenta
		public MensajeTransaccionBean pagoComisionCredito(final CreditosBean creditos, final long NumeroTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//	transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PAGOCOMISIONCREPRO("
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?,		"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoCobro",creditos.getTipoCobro());
									sentenciaStore.setString("Par_TipoComision",creditos.getTipoComision());
									sentenciaStore.setInt("Par_AccesorioID",Utileria.convierteEntero(creditos.getAccesorioID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
									sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));

									sentenciaStore.setString("Par_ModoPago","C");
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
									sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(creditos.getPolizaID()));
									sentenciaStore.setString("Par_OrigenPago",Constantes.ORIGEN_PAGO_CARGOCTA);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
											resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(NumeroTransaccion));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});


						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero()==0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Comisión  con Cargo a Cuenta en Crédito", e);
						transaction.setRollbackOnly();
					}

					return mensajeBean;
				}

			});
			return mensaje;
		}



		// Pago de Comisiones con Cargo a Cuenta
				public MensajeTransaccionBean pagoComisionCreditoMasivo(final CreditosBean creditos, final long NumeroTransaccion) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
										new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call PAGCOMMASIVOCREPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setString("Par_TipoCobro",creditos.getTipoCobro());
											sentenciaStore.setString("Par_TipoComision",creditos.getTipoComisionM());
											sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
											sentenciaStore.setString("Par_ModoPago","C");
											sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(creditos.getCuentaID()));
											sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(creditos.getPolizaID()));
											sentenciaStore.setDouble("Par_ComFaltPag",Utileria.convierteDoble(creditos.getComFaltaPago()));
											sentenciaStore.setDouble("Par_ComSeguroCuota",Utileria.convierteDoble(creditos.getComSeguroCuota()));
											sentenciaStore.setDouble("Par_ComApCred",Utileria.convierteDoble(creditos.getComAperturaCred()));
											sentenciaStore.setDouble("Par_ComAnual",Utileria.convierteDoble(creditos.getComAnual()));
											sentenciaStore.setDouble("Par_ComAnualLin",Utileria.convierteDoble(creditos.getComAnualLin()));

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
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
										public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																														DataAccessException {
											MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
											if(callableStatement.execute()){
												ResultSet resultadosStore = callableStatement.getResultSet();
													resultadosStore.next();

												mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
												mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
												mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
												mensajeTransaccion.setConsecutivoString(String.valueOf(NumeroTransaccion));

											}else{
												mensajeTransaccion.setNumero(999);
												mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
											}
											return mensajeTransaccion;
										}
									});


								if(mensajeBean ==  null){
									mensajeBean = new MensajeTransaccionBean();
									mensajeBean.setNumero(999);
									throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}else if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}

							} catch (Exception e) {
								if (mensajeBean.getNumero()==0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Pago de Comisiones  con Cargo a Cuenta en Crédito", e);
								transaction.setRollbackOnly();
							}

							return mensajeBean;
						}

					});
					return mensaje;
				}


	/* Pago del credito individual con cargo a cuenta */
	public MensajeTransaccionBean PagoInteresCreditoCargoCuenta(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoInteresCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de Interes con cargo a cuenta en creditos", e);
				}
				return mensajeBean;
			}
		});
		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("CreditosDAO.PagoInteresCreditoCargoCuenta");
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("CreditosDAO.PagoInteresCreditoCargoCuenta: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}



	/* Pago del credito Vertica con cargo a cuenta */
	public MensajeTransaccionBean PagoVerticalCreditoCargoCuenta(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoVerticalCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago vertical con cargo a cuenta en creditos", e);
				}
				return mensajeBean;
			}
		});
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}


	/* Pago de Comisiones de Credito individual con cargo a cuenta */
	public MensajeTransaccionBean PagoComisionCreditoCargoCuenta(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();
				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoComisionCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de Comisión con cargo a cuenta en créditos", e);
				}
				return mensajeBean;
			}
		});

		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("CreditosDAO.pagoComisionCredito");
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("CreditosDAO.pagoComisionCredito: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}

	/* Pago de Comisiones de Credito individual con cargo a cuenta */
	public MensajeTransaccionBean altaPagoComisionMasivo(final CreditosBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditosBean.pagoCredito);
		polizaBean.setConcepto(CreditosBean.desPagoCredito);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza =polizaBean.getPolizaID();

				try {
					creditos.setPolizaID(poliza);
					mensajeBean=pagoComisionCreditoMasivo(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de Comisión con cargo a cuenta en créditos", e);
				}
				return mensajeBean;
			}
		});

		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("CreditosDAO.pagoComisionCreditoMasivo");
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("CreditosDAO.pagoComisionCreditoMasivo: Credito: " + creditos.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/

	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
}

	/* Actualiza el valor de la ejecucion de cobranza automatica */
	public MensajeTransaccionBean actualizaCobranza(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call PARAMGENERALESACT(?,?,?,?,?,	?,?,?,?,?, ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NumActualiza",tipoActualizacion);
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
						});
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
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	// Se utiliza para sugerir un calendario de pagos para reestructura de un credito en modalida de pagos LIBRES
	public List calendarioSugeridoReestructura(CreditosBean creditosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call AMORTICREDITOLIS(?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getCreditoID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.calendarioSugeridoReestructura",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
				amortizacionCredito.setAmortizacionID(String.valueOf(resultSet.getInt("AmortizacionID")));
				amortizacionCredito.setFechaInicio(resultSet.getString("FechaInicio"));
				amortizacionCredito.setFechaVencim(resultSet.getString("FechaVencim"));
				amortizacionCredito.setFechaExigible(resultSet.getString("FechaExigible"));
				amortizacionCredito.setCapital(resultSet.getString("Capital"));
				amortizacionCredito.setInteres(resultSet.getString("Interes"));
				amortizacionCredito.setIvaInteres(resultSet.getString("IVAInteres"));
				amortizacionCredito.setTotalPago(resultSet.getString("TotalPago"));
				amortizacionCredito.setSaldoInsoluto(resultSet.getString("SaldoCapital"));
				amortizacionCredito.setNumTransaccion(resultSet.getString("NumTransaccion"));

				return amortizacionCredito;
			}
		});

		return matches;
	}

	// consulta para reporte en excel de saldos de cartera, avales y referencias para la gestion de cobranza
	public List consultaSaldosCarteraAvaReferencias(final CreditosBean creditosBean, int tipoLista){
		List ListaResultado=null;
		transaccionDAO.generaNumeroTransaccion();
		try{
			String query = 	"call SALDOSGESTIONCOBREP(" +
					"?,?,?,?,?,		?,?,?,?,?,		" +
					"?,?,?,?,?,		?,?)";

			Object[] parametros ={
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteEntero(creditosBean.getSucursal()),
					Utileria.convierteEntero(creditosBean.getMonedaID()),
					Utileria.convierteEntero(creditosBean.getProducCreditoID()),
					Utileria.convierteEntero(creditosBean.getPromotorID()),

					creditosBean.getSexo(),
					Utileria.convierteEntero(creditosBean.getEstadoID()),
					Utileria.convierteEntero(creditosBean.getMunicipioID()),
					Utileria.convierteEntero(creditosBean.getAtrasoInicial()),
					Utileria.convierteEntero(creditosBean.getAtrasoFinal()),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSGESTIONCOBREP(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SaldosCarteraAvaRefRepBean reporteBean= new SaldosCarteraAvaRefRepBean();

					// DATOS DEL CREDITO Y DEL CLIENTE
					reporteBean.setGrupoID(resultSet.getString("GrupoID"));
					reporteBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					reporteBean.setCreditoID(resultSet.getString("CreditoID"));
					reporteBean.setClienteID(resultSet.getString("ClienteID"));
					reporteBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					reporteBean.setMontoCredito(resultSet.getString("MontoCredito"));
					reporteBean.setFechaInicio(resultSet.getString("FechaInicio"));
					reporteBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					reporteBean.setFechaVencim(resultSet.getString("FechaVencim"));
					reporteBean.setEstatusCredito(resultSet.getString("EstatusCredito"));
					reporteBean.setCapital(resultSet.getString("Capital"));
					reporteBean.setCapitalVencido(resultSet.getString("CapitalVencido"));
					reporteBean.setInteres(resultSet.getString("Interes"));
					reporteBean.setMoratorios(resultSet.getString("Moratorios"));
					reporteBean.setComisiones(resultSet.getString("Comisiones"));
					reporteBean.setCargos(resultSet.getString("Cargos"));
					reporteBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
					reporteBean.setiVATotal(resultSet.getString("IVATotal"));
					reporteBean.setSeguro(resultSet.getString("Seguro"));
					reporteBean.setiVASeguro(resultSet.getString("IVASeguro"));
					reporteBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
					reporteBean.setTotalCuota(resultSet.getString("TotalCuota"));
					reporteBean.setPago(resultSet.getString("Pago"));
					reporteBean.setFechaPago(resultSet.getString("FechaPago"));
					reporteBean.setDiasAtraso(resultSet.getString("DiasAtraso"));
					reporteBean.setSaldoTotal(resultSet.getString("SaldoTotal"));

					// DATOS DEL DOMICILIO DEL CLIENTE
					reporteBean.setCalleNumero(resultSet.getString("CalleNumero"));
					reporteBean.setTelefono(resultSet.getString("Telefono"));
					reporteBean.setCelular(resultSet.getString("Celular"));
					reporteBean.setNombreColonia(resultSet.getString("NombreColonia"));
					reporteBean.setcP(resultSet.getString("CP"));
					reporteBean.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					reporteBean.setNombreEstado(resultSet.getString("NombreEstado"));

					// DATOS DE LAS REFERENCIAS
					reporteBean.setNombreReferencia1(resultSet.getString("NombreReferencia1"));
					reporteBean.setCalleNumeroRef1(resultSet.getString("CalleNumeroRef1"));
					reporteBean.setNombreColoniaRef1(resultSet.getString("NombreColoniaRef1"));
					reporteBean.setcPRef1(resultSet.getString("CPRef1"));
					reporteBean.setNombreLocalidadRef1(resultSet.getString("NombreLocalidadRef1"));
					reporteBean.setNombreEstadoRef1(resultSet.getString("NombreEstadoRef1"));
					reporteBean.setTelefonoRef1(resultSet.getString("TelefonoRef1"));

					reporteBean.setNombreReferencia2(resultSet.getString("NombreReferencia2"));
					reporteBean.setCalleNumeroRef2(resultSet.getString("CalleNumeroRef2"));
					reporteBean.setNombreColoniaRef2(resultSet.getString("NombreColoniaRef2"));
					reporteBean.setcPRef2(resultSet.getString("CPRef2"));
					reporteBean.setNombreLocalidadRef2(resultSet.getString("NombreLocalidadRef2"));
					reporteBean.setNombreEstadoRef2(resultSet.getString("NombreEstadoRef2"));
					reporteBean.setTelefonoRef2(resultSet.getString("TelefonoRef2"));

					reporteBean.setNombreReferencia3(resultSet.getString("NombreReferencia3"));
					reporteBean.setCalleNumeroRef3(resultSet.getString("CalleNumeroRef3"));
					reporteBean.setNombreColoniaRef3(resultSet.getString("NombreColoniaRef3"));
					reporteBean.setcPRef3(resultSet.getString("CPRef3"));
					reporteBean.setNombreLocalidadRef3(resultSet.getString("NombreLocalidadRef3"));
					reporteBean.setNombreEstadoRef3(resultSet.getString("NombreEstadoRef3"));
					reporteBean.setTelefonoRef3(resultSet.getString("TelefonoRef3"));

					reporteBean.setNombreReferencia4(resultSet.getString("NombreReferencia4"));
					reporteBean.setCalleNumeroRef4(resultSet.getString("CalleNumeroRef4"));
					reporteBean.setNombreColoniaRef4(resultSet.getString("NombreColoniaRef4"));
					reporteBean.setcPRef4(resultSet.getString("CPRef4"));
					reporteBean.setNombreLocalidadRef4(resultSet.getString("NombreLocalidadRef4"));
					reporteBean.setNombreEstadoRef4(resultSet.getString("NombreEstadoRef4"));
					reporteBean.setTelefonoRef4(resultSet.getString("TelefonoRef4"));

					//DATOS DE LOS AVALES
					reporteBean.setNombreAval1(resultSet.getString("NombreAval1"));
					reporteBean.setCalleNumeroAval1(resultSet.getString("CalleNumeroAval1"));
					reporteBean.setNombreColoniaAval1(resultSet.getString("NombreColoniaAval1"));
					reporteBean.setcPAval1(resultSet.getString("CPAval1"));
					reporteBean.setNombreLocalidadAval1(resultSet.getString("NombreLocalidadAval1"));
					reporteBean.setNombreEstadoAval1(resultSet.getString("NombreEstadoAval1"));
					reporteBean.setTelefonoAval1(resultSet.getString("TelefonoAval1"));

					reporteBean.setNombreAval2(resultSet.getString("NombreAval2"));
					reporteBean.setCalleNumeroAval2(resultSet.getString("CalleNumeroAval2"));
					reporteBean.setNombreColoniaAval2(resultSet.getString("NombreColoniaAval2"));
					reporteBean.setcPAval2(resultSet.getString("CPAval2"));
					reporteBean.setNombreLocalidadAval2(resultSet.getString("NombreLocalidadAval2"));
					reporteBean.setNombreEstadoAval2(resultSet.getString("NombreEstadoAval2"));
					reporteBean.setTelefonoAval2(resultSet.getString("TelefonoAval2"));
					return reporteBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de saldos de gestion de cobranza: ", e);
		}
		return ListaResultado;
	}

	public List<CreditosBean> consultaCancelacionCred(final CreditosBean creditosBean, int tipoLista) {
		List<CreditosBean> ListaResultado = null;
		transaccionDAO.generaNumeroTransaccion();
		try {
			String query = "call BITACORACREDCANCELREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?,		"
					+ "?,?)";

			Object[] parametros = {
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaFinal()),
					Utileria.convierteEntero(creditosBean.getSucursalID()),
					Utileria.convierteEntero(creditosBean.getProducCreditoID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call BITACORACREDCANCELREP(" + Arrays.toString(parametros) + ");");
			List<CreditosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean reporteBean = new CreditosBean();

					// DATOS DEL CREDITO Y DEL CLIENTE
					reporteBean.setGrupoID(resultSet.getString("GrupoID"));
					reporteBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					reporteBean.setCreditoID(resultSet.getString("CreditoID"));
					reporteBean.setClienteID(resultSet.getString("ClienteID"));
					reporteBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					reporteBean.setMontoCredito(resultSet.getString("MontoCancel"));
					reporteBean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					reporteBean.setNombreProducto(resultSet.getString("NombreProducto"));
					reporteBean.setSucursalID(resultSet.getString("SucursalID"));
					reporteBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
					reporteBean.setFechaCancel(resultSet.getString("FechaCancel"));
					reporteBean.setMotivoCancel(resultSet.getString("MotivoCancel"));
					reporteBean.setPolizaID(resultSet.getString("PolizaID"));
					reporteBean.setNombreUsuario(resultSet.getString("NombreUsuario"));

					return reporteBean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta de reporte de Cancelacion de Creditos: ", e);
		}
		return ListaResultado;
	}

	public List  consultaCarteraCNBV(final CreditosBean creditosBean, int tipoLista){



		List listaResultado = null;
		try{

			String query = "call SALDOSCARTERACNBVREP(?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.consultaReporteCNBV",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCARTERACNBVREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();

					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					creditosBean.setCURP(resultSet.getString("CURP"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setSucursalID(resultSet.getString("SucursalID"));
					creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setFechaOtorgamiento(resultSet.getString("FechaOtorgamiento"));
					creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					creditosBean.setTasaFija(resultSet.getString("TasaInteres"));
					creditosBean.setFormaPago(resultSet.getString("FormaPago"));
					creditosBean.setFechaUltPagoCap(resultSet.getString("FechaUltimoPagoCap"));
					creditosBean.setMontoUltPagoCap(resultSet.getString("MontoUltimoPagoCap"));
					creditosBean.setFechaUltPagoInt(resultSet.getString("FechaUltimoPagoInt"));
					creditosBean.setMontoUltPagoInt(resultSet.getString("MontoUltimoPagoInt"));
					creditosBean.setFechaPrimerAmortCub(resultSet.getString("FechaPrimerAmortCub"));
					creditosBean.setDiasAtraso(resultSet.getString("DiasMora"));
					creditosBean.setSaldoInsolutoCartera(resultSet.getString("SaldoInsoluto"));
					creditosBean.setInteresVencido(resultSet.getString("InteresesVencido"));
					creditosBean.setInteresMoratorio(resultSet.getString("InteresMoratorio"));
					creditosBean.setInteresRefinanciado(resultSet.getString("InteresRefinanciado"));
					creditosBean.setTipoAcreditadoRel(resultSet.getString("TipoAcreditadoRel"));
					creditosBean.setMontoEPRC(resultSet.getString("MontoEPRC"));
					creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiquida"));
					creditosBean.setFechaConsultaSIC(resultSet.getString("FechaConsultaSIC"));
					creditosBean.setTipoCobranza(resultSet.getString("TipoCobranza"));
					creditosBean.setFechaFinRep(resultSet.getString("FechaEncFin"));

					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte Cartera CNBV", e);

		}
			return listaResultado;
		}


	public List  consultaCarteraCNBVCsv(final CreditosBean creditosBean, int tipoLista){



		List listaResultado = null;
		try{

			String query = "call SALDOSCARTERACNBVREP(?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.consultaReporteCNBV",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCARTERACNBVREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();

					creditosBean.setRenglon(resultSet.getString("Valor"));

					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte Cartera CNBV", e);

		}
			return listaResultado;
		}

public List  consultaCastigosQuitasCNBV(final CreditosBean creditosBean, int tipoLista){



		List listaResultado = null;
		try{

			String query = "call CASTIGOSQUITASCNBVREP(?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.consultaCastigosQuitasCNBV",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CASTIGOSQUITASCNBVREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();

					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setSucursalID(resultSet.getString("SucursalID"));
					creditosBean.setClasiDestinCred(resultSet.getString("ClasiDestinCred"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setFechaOtorgamiento(resultSet.getString("FechaOtorgamiento"));
					creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					creditosBean.setTasaFija(resultSet.getString("TasaInteres"));
					creditosBean.setDiasAtraso(resultSet.getString("DiasMora"));
					creditosBean.setSaldoInsolutoCartera(resultSet.getString("SaldoInsoluto"));
					creditosBean.setInteresVencido(resultSet.getString("InteresesVencido"));
					creditosBean.setInteresMoratorio(resultSet.getString("InteresMoratorio"));
					creditosBean.setInteresRefinanciado(resultSet.getString("InteresRefinanciado"));
					creditosBean.setMontoCastigo(resultSet.getString("MontoCastigo"));
					creditosBean.setMontoCondonacion(resultSet.getString("MontoCondonacion"));
					creditosBean.setFechaCastigo(resultSet.getString("FechaCastigo"));
					creditosBean.setMontoEPRC(resultSet.getString("MontoEPRC"));
					creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiquida"));
					creditosBean.setFechaInicioRep(resultSet.getString("FechaEncIni"));
					creditosBean.setFechaFinRep(resultSet.getString("FechaEncFin"));

					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte Castigos Quitas CNBV", e);

		}
			return listaResultado;
		}


	public List  consultaCastigosQuitasCNBVCsv(final CreditosBean creditosBean, int tipoLista){



		List listaResultado = null;
		try{

			String query = "call CASTIGOSQUITASCNBVREP(?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteEntero(creditosBean.getSucursal()),
								Utileria.convierteEntero(creditosBean.getMonedaID()),
								Utileria.convierteEntero(creditosBean.getProducCreditoID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								creditosBean.getSexo(),
								Utileria.convierteEntero(creditosBean.getEstadoID()),
								Utileria.convierteEntero(creditosBean.getMunicipioID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.consultaCastigosQuitasCNBVCsv",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CASTIGOSQUITASCNBVREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();

					creditosBean.setRenglon(resultSet.getString("Valor"));


					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en generacion de reporte Castigos Quitas CNBV", e);

		}
			return listaResultado;
		}

	/* Condición del credito */
	public MensajeTransaccionBean condiciona(final CreditosBean creditos) {
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
								String query = "call COMENTARIOSPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setString("Par_Comentario", creditos.getComentarioCond());
								sentenciaStore.setString("Par_Condicionado",creditos.getEstCondicionado());
								sentenciaStore.setInt("Par_Usuario",Utileria.convierteEntero(creditos.getUsuarioAutoriza()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Alta de Comentario del Crédito */
	public MensajeTransaccionBean altaComentarioAltCred(final CreditosBean creditos) {
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

								if(Utileria.convierteEntero(creditos.getSolicitudCreditoID())== 0){
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getCreditoID()));
								}
								else{
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								}
								sentenciaStore.setString("Par_Estatus",creditos.getEstatusCred());
								sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(creditos.getFechaInicio()));
								sentenciaStore.setString("Par_Comentario",creditos.getComentarioAlt());
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



	/* Alta de Comentario del Crédito */
	public MensajeTransaccionBean altaComentarioDesCred(final CreditosBean creditos) {
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
								if(Utileria.convierteEntero(creditos.getSolicitudCreditoID())== 0){
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getCreditoID()));
								}
								else{
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								}
								sentenciaStore.setString("Par_Estatus",creditos.getEstatusCred());
								sentenciaStore.setDate("Par_Fecha", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_Comentario",creditos.getComentarioCred());
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


	/* Alta de Comentario del Crédito */
	public MensajeTransaccionBean altaComentarioAutCred(final CreditosBean creditos) {
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
								if(Utileria.convierteEntero(creditos.getSolicitudCreditoID())== 0){
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getCreditoID()));
								}
								else{
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
								}
								sentenciaStore.setString("Par_Estatus",creditos.getEstatusCred());
								sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(creditos.getFechaAutoriza()));
								sentenciaStore.setString("Par_Comentario",creditos.getComentarioCond());
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


	/* Alta de Creditos que no tienen Solicitud de Crédito */
	public MensajeTransaccionBean altaCreditoSolCero(final CreditosBean creditos,  final String CreditoID) {
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
								String query = "call SOLICITUDESCEROALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_CreditoID",Utileria.convierteEntero(CreditoID));
								sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(creditos.getFechaInicio()));
								sentenciaStore.setInt("Par_UsuarioAut", parametrosAuditoriaBean.getUsuario());
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
	 * alta en el estatu de ESTATUSSOLCREDITOS
	 * @param numeroTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean altaEstSolicitudCred(final CreditosBean creditos , final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call ESTATUSSOLCREDITOSALT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?);";
							String Est_Dispersion="P";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(creditos.getSolicitudCreditoID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
							sentenciaStore.setString("Par_Estatus",Est_Dispersion);

							sentenciaStore.setString("Par_MotivoRechazoID",Constantes.STRING_VACIO );
							sentenciaStore.setString("Par_Comentario", Constantes.STRING_VACIO);

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
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
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta del estatus de Solicitud", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta del estatus de Solicitud", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* AGROPECUARIOS SIMULADOR */
	public List<AmortizacionCreditoBean> recalculoSimPagLibresFecCapAGRO(final CreditosBean creditosBean, String montosMinistraciones) {
		transaccionDAO.generaNumeroTransaccion();
		List<AmortizacionCreditoBean> listaSimPagosLibres = null;
		final List<AmortizacionCreditoBean> listaSimuladorPagosLibres = new ArrayList<AmortizacionCreditoBean>();
		try {
			MinistracionCredAgroBean ministracionCredAgroBean = new MinistracionCredAgroBean();
			ministracionCredAgroBean.setClienteID(creditosBean.getClienteID());
			ministracionCredAgroBean.setProspectoID(creditosBean.getProspectoID());
			ministracionCredAgroBean.setSolicitudCreditoID(creditosBean.getSolicitudCreditoID());
			ministracionCredAgroBean.setCreditoID(creditosBean.getCreditoID());
			MensajeTransaccionBean ministra = ministraCredAgroDAO.grabaDetalle(ministracionCredAgroBean, montosMinistraciones, Utileria.convierteLong(creditosBean.getNumTransacSim()));
			if (ministra.getNumero() == 0) {
				listaSimPagosLibres = (List<AmortizacionCreditoBean>) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call CRERECPAGLIBAGROPRO("
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,	  "
								+ "?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(creditosBean.getMontoCredito()));
						sentenciaStore.setDouble("Par_Tasa", Utileria.convierteDoble(creditosBean.getTasaFija()));
						sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(creditosBean.getProducCreditoID()));
						sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(creditosBean.getClienteID()));
						sentenciaStore.setDouble("Par_ComAper", Utileria.convierteDoble(creditosBean.getMontoComision()));

						sentenciaStore.setString("Par_CobraSeguroCuota", creditosBean.getCobraSeguroCuota());
						sentenciaStore.setString("Par_CobraIVASeguroCuota", creditosBean.getCobraIVASeguroCuota());
						sentenciaStore.setDouble("Par_MontoSeguroCuota", Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
						sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(creditosBean.getSolicitudCreditoID()));
						sentenciaStore.setInt("Par_CreditoID", Utileria.convierteEntero(creditosBean.getCreditoID()));

						sentenciaStore.setDouble("Par_ComAnualLin", Utileria.convierteDoble(creditosBean.getComAnualLin()));
						sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
						sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

						sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
						sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
						sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
						sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.SimPagCrecientes");
						sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

						sentenciaStore.setString("Aud_NumTransaccion", creditosBean.getNumTransacSim());
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
						return sentenciaStore;
					}
				}, new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
						if (callableStatement.execute()) {
							ResultSet resultSet = callableStatement.getResultSet();
							while (resultSet.next()) {

								AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
								try {
									amortizacionCredito.setAmortizacionID(resultSet.getString("Consecutivo"));
									amortizacionCredito.setFechaInicio(resultSet.getString("FechaInicio"));
									amortizacionCredito.setFechaVencim(resultSet.getString("FechaVencim"));
									amortizacionCredito.setFechaExigible(resultSet.getString("FechaExigible"));
									amortizacionCredito.setCapital(resultSet.getString("Capital"));

									amortizacionCredito.setInteres(resultSet.getString("Interes"));
									amortizacionCredito.setIvaInteres(resultSet.getString("Iva"));
									amortizacionCredito.setTotalPago(resultSet.getString("SubTotal"));
									amortizacionCredito.setSaldoInsoluto(resultSet.getString("Insoluto"));
									amortizacionCredito.setDias(resultSet.getString("Dias"));

									amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
									amortizacionCredito.setNumTransaccion(resultSet.getString("Aud_NumTransaccion"));
									amortizacionCredito.setCuotasCapital(resultSet.getString("CuotaCapital"));
									amortizacionCredito.setCuotasInteres(resultSet.getString("CuotaInteres"));
									amortizacionCredito.setCat(resultSet.getString("Var_CAT"));

									amortizacionCredito.setFecUltAmor(resultSet.getString("Par_FechaVenc"));
									amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
									amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
									amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
									amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
									amortizacionCredito.setCodigoError(resultSet.getString("NumErr"));
									amortizacionCredito.setMensajeError(resultSet.getString("ErrMen"));
								} catch (Exception ex) {
									ex.printStackTrace();
									return null;
								}
								listaSimuladorPagosLibres.add(amortizacionCredito);
							}
							return listaSimuladorPagosLibres;
						}
						return listaSimuladorPagosLibres;
					}
				});
			} else {
				throw new Exception(ministra.getDescripcion());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			AmortizacionCreditoBean amortiza = new AmortizacionCreditoBean();
			amortiza.setCodigoError("999");
			amortiza.setMensajeError(ex.getMessage());
			listaSimuladorPagosLibres.add(amortiza);
		}
		return listaSimuladorPagosLibres;
	}

	/* AGROPECUARIOS SIMULADOR REESTRUCTURA */
	public List<AmortizacionCreditoBean> recalculoSimPagLibresFecCapReestAGRO(final CreditosBean creditosBean, String montosMinistraciones) {
		transaccionDAO.generaNumeroTransaccion();
		List<AmortizacionCreditoBean> listaSimPagosLibres = null;
		final List<AmortizacionCreditoBean> listaSimuladorPagosLibres = new ArrayList<AmortizacionCreditoBean>();
		try {

				listaSimPagosLibres = (List<AmortizacionCreditoBean>) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call CRERECPAGLIBAGROPRO("
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,     "
								+ "?,?,?,?,?,	  "
								+ "?);";
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(creditosBean.getMontoCredito()));
						sentenciaStore.setDouble("Par_Tasa", Utileria.convierteDoble(creditosBean.getTasaFija()));
						sentenciaStore.setInt("Par_ProducCreditoID", Utileria.convierteEntero(creditosBean.getProducCreditoID()));
						sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(creditosBean.getClienteID()));
						sentenciaStore.setDouble("Par_ComAper", Utileria.convierteDoble(creditosBean.getMontoComision()));

						sentenciaStore.setString("Par_CobraSeguroCuota", creditosBean.getCobraSeguroCuota());
						sentenciaStore.setString("Par_CobraIVASeguroCuota", creditosBean.getCobraIVASeguroCuota());
						sentenciaStore.setDouble("Par_MontoSeguroCuota", Utileria.convierteDoble(creditosBean.getMontoSeguroCuota()));
						sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(creditosBean.getSolicitudCreditoID()));
						sentenciaStore.setInt("Par_CreditoID", Utileria.convierteEntero(creditosBean.getCreditoID()));

						sentenciaStore.setDouble("Par_ComAnualLin",Utileria.convierteDoble(creditosBean.getComAnualLin()));
						sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

						sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
						sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
						sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
						sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
						sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.SimPagCrecientes");
						sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

						sentenciaStore.setString("Aud_NumTransaccion", creditosBean.getNumTransacSim());
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
						return sentenciaStore;
					}
				}, new CallableStatementCallback() {
					public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
						if (callableStatement.execute()) {
							ResultSet resultSet = callableStatement.getResultSet();
							while (resultSet.next()) {

								AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
								try {
									amortizacionCredito.setAmortizacionID(resultSet.getString("Consecutivo"));
									amortizacionCredito.setFechaInicio(resultSet.getString("FechaInicio"));
									amortizacionCredito.setFechaVencim(resultSet.getString("FechaVencim"));
									amortizacionCredito.setFechaExigible(resultSet.getString("FechaExigible"));
									amortizacionCredito.setCapital(resultSet.getString("Capital"));

									amortizacionCredito.setInteres(resultSet.getString("Interes"));
									amortizacionCredito.setIvaInteres(resultSet.getString("Iva"));
									amortizacionCredito.setTotalPago(resultSet.getString("SubTotal"));
									amortizacionCredito.setSaldoInsoluto(resultSet.getString("Insoluto"));
									amortizacionCredito.setDias(resultSet.getString("Dias"));

									amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
									amortizacionCredito.setNumTransaccion(resultSet.getString("Aud_NumTransaccion"));
									amortizacionCredito.setCuotasCapital(resultSet.getString("CuotaCapital"));
									amortizacionCredito.setCuotasInteres(resultSet.getString("CuotaInteres"));
									amortizacionCredito.setCat(resultSet.getString("Var_CAT"));

									amortizacionCredito.setFecUltAmor(resultSet.getString("Par_FechaVenc"));
									amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
									amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
									amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
									amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
									amortizacionCredito.setCodigoError(resultSet.getString("NumErr"));
									amortizacionCredito.setMensajeError(resultSet.getString("ErrMen"));
								} catch (Exception ex) {
									ex.printStackTrace();
									return null;
								}
								listaSimuladorPagosLibres.add(amortizacionCredito);
							}
							return listaSimuladorPagosLibres;
						}
						return listaSimuladorPagosLibres;
					}
				});

		} catch (Exception ex) {
			ex.printStackTrace();
			AmortizacionCreditoBean amortiza = new AmortizacionCreditoBean();
			amortiza.setCodigoError("999");
			amortiza.setMensajeError(ex.getMessage());
			listaSimuladorPagosLibres.add(amortiza);
		}
		return listaSimuladorPagosLibres;
	}
	public List consultaSimuladorPagosTemporalAgro(final CreditosBean creditosBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call TMPPAGAMORSIMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getNumTransacSim(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.ConTempPagAmort",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
				amortizacionCredito.setAmortizacionID(String.valueOf(resultSet.getInt("Tmp_Consecutivo")));
				amortizacionCredito.setFechaInicio(resultSet.getString("Tmp_FecIni"));
				amortizacionCredito.setFechaVencim(resultSet.getString("Tmp_FecFin"));
				amortizacionCredito.setFechaExigible(resultSet.getString("Tmp_FecVig"));
				amortizacionCredito.setCapital(resultSet.getString("Tmp_Capital"));

				amortizacionCredito.setInteres(resultSet.getString("Tmp_Interes"));
				amortizacionCredito.setIvaInteres(resultSet.getString("Tmp_Iva"));
				amortizacionCredito.setTotalPago(resultSet.getString("Tmp_SubTotal"));
				amortizacionCredito.setSaldoInsoluto(resultSet.getString("Tmp_Insoluto"));
				amortizacionCredito.setCuotasCapital(resultSet.getString("Tmp_CuotasCap"));
				amortizacionCredito.setCat(resultSet.getString("Tmp_Cat"));
				amortizacionCredito.setCobraSeguroCuota(creditosBean.getCobraSeguroCuota());
				amortizacionCredito.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
				amortizacionCredito.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
				amortizacionCredito.setCapitalInteres(resultSet.getString("Tmp_CapInt"));
				amortizacionCredito.setNumTransaccion(resultSet.getString("NumTransaccion"));
				amortizacionCredito.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
				amortizacionCredito.setTotalIVASeguroCuota(resultSet.getString("TotalIVASeguroCuota"));
				return amortizacionCredito;
			}
		});

		return matches;
	}

	public List listaCredConGarSinFondeo(CreditosBean creditosBean, int tipoLista){
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									tipoLista,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"CreditosDAO.listaCredConGarSinFondeo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();

					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCliente(resultSet.getString("NombreCliente"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
					creditosBean.setTipoGarantiaFIRA(resultSet.getString("TipoGarantiaFIRAID"));

					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos vigentes o vencidos", e);
		}
		return listaCredVig;
	}

	/**
	 * Método que da de alta las amortizaciones en la tabla de AMORTICREDITOAGRO
	 * @param creditos	: {@link CreditosBean} Bean con la informacion del crédito
	 * @param tipoActualizacion : Numero de Actualizacion
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean generarAmortizacionesAgro(final CreditosBean creditos, final int tipoActualizacion, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			if (numTransaccion > 0) {
				parametrosAuditoriaBean.setNumeroTransaccion(numTransaccion);
			} else {
				transaccionDAO.generaNumeroTransaccion();
			}
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CREGENAMORTIZAAGROPRO(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setString("Par_FecMinist", Utileria.convierteFecha(creditos.getFechaMinistrado()));
								sentenciaStore.setString("Par_FechaInicioAmor", Utileria.convierteFecha(creditos.getFechaInicioAmor()));
								sentenciaStore.setString("Par_TipoPrepago", creditos.getTipoPrepago());

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								if (callableStatement.execute()) {

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en la grabacion de amortizacion definitiva del credito", e);
					}
					return mensajeBean;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			if(mensaje==null){
				mensaje = new MensajeTransaccionBean();
			}
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion("Error al Grabar el Pagare de Crédito.");

		}
		return mensaje;
	}

	/**
	 * Consulta general cambio fuente fondeo
	 * N°30: Consulta General
	 * @param creditosBean: Bean para realizar la consulta cambio fuente fondeo
	 * @param tipoConsulta: Consulta 30
	 * @return
	 */
	// consulta conceptos catalogo
	public CreditosBean consultaCambioFondeo(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean creditos = null;
		try{
			//Query con el Store Procedure
			String query = "call CREDITOSAGROCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaGeneralesCredito",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSAGROCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				    creditosBean.setCuentaID(resultSet.getString("CuentaID"));

				    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
				    creditosBean.setEstatus(resultSet.getString("Estatus"));
				    creditosBean.setDiasFaltaPago(resultSet.getString("diasFaltaPago"));
				    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				    creditosBean.setSucursal(resultSet.getString("SucursalID"));

				    creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
				    creditosBean.setTasaBase(resultSet.getString("TasaBase"));
				    creditosBean.setSobreTasa(resultSet.getString("SobreTasa"));
				    creditosBean.setPisoTasa(resultSet.getString("PisoTasa"));
				    creditosBean.setTechoTasa(resultSet.getString("TechoTasa"));

				    creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				    creditosBean.setCalcInteresID(resultSet.getString("CalcInteresID"));
				    creditosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
				    creditosBean.setTasaFija(resultSet.getString("TasaFija"));
				    creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));

				    creditosBean.setOrigen(resultSet.getString("Origen"));
				    creditosBean.setInstitFondeoID(resultSet.getString("InstitFondeoID"));
				    creditosBean.setLineaFondeo(resultSet.getString("LineaFondeo"));
				    creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
				    creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
				    creditosBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
					return creditosBean;

				}
			});
			creditos= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de conceptos de inversion fira.", e);
			e.printStackTrace();
		}
	return creditos;
	}

	/**
	 * Método que realiza el proceso del Pagaréde Crédito
	 * @param creditos : {@link CreditosBean} Bean con la información del crédito
	 * @param tipoActualizacion : Tipo de Actualización
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean actualizaCredPagareAgro(final CreditosBean creditos, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final long numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					/* Actualizar los campos del Credito y la Solicitud */
					SolicitudCreditoBean solicitudCredito = new SolicitudCreditoBean();
					solicitudCredito.setCreditoID(creditos.getCreditoID());
					solicitudCredito.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
					solicitudCredito.setCalcInteresID(creditos.getCalcInteresID());
					solicitudCredito.setTasaBase(creditos.getTasaBase());
					solicitudCredito.setTasaFija(creditos.getTasaFija());
					solicitudCredito.setPisoTasa(creditos.getPisoTasa());
					solicitudCredito.setTechoTasa(creditos.getTechoTasa());
					solicitudCredito.setTipoFondeo(creditos.getTipoFondeo());
					solicitudCredito.setInstitutFondID(creditos.getInstitFondeoID());
					solicitudCredito.setLineaFondeoID(creditos.getLineaFondeo());
					solicitudCredito.setNumTransacSim(creditos.getNumTransacSim());

					/*
					 * Se actualiza la información tanto de la solicitud como la
					 * del crédito.
					 */
					mensajeBean = solicitudCreditoDAO.actualizaSolCreditoAgro(solicitudCredito, Enum_Act_SolAgro.pagare, numTransaccion);
					if (mensajeBean == null || mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					/*
					 * Se Actualiza el credito solo si es desde la autorizacion
					 * del pagare
					 */
					if (tipoActualizacion == Enum_Act_Creditos.actCredAgroGenAmort) {
						mensajeBean = autorizaPagImp(creditos, Enum_Act_Creditos.actNumTransacSim, numTransaccion);
						if (mensajeBean == null || mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = generarAmortizacionesAgro(creditos, tipoActualizacion, numTransaccion);
					if (mensajeBean == null || mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					if(mensajeBean == null){
						mensajeBean=new MensajeTransaccionBean();
					}
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al grabar el Pagare del Credito Agropecuario:", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public CreditosBean consultaGralesCreditoAgro(final CreditosBean creditosBean, final int tipoConsulta){
		CreditosBean creditosAgroBean = null;
		try {
			creditosAgroBean = (CreditosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSAGROCON(?,?,?,?,?,	?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CreditoID",creditosBean.getCreditoID());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.consultaGralesCreditoAgro");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							CreditosBean creditosBean = new CreditosBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								creditosBean.setCreditoID(resultadosStore.getString("CreditoID"));
								creditosBean.setClienteID(resultadosStore.getString("ClienteID"));
								creditosBean.setLineaCreditoID(resultadosStore.getString("LineaCreditoID"));
								creditosBean.setProducCreditoID(resultadosStore.getString("ProductoCreditoID"));
								creditosBean.setCuentaID(resultadosStore.getString("CuentaID"));

								creditosBean.setMonedaID(resultadosStore.getString("MonedaID"));
								creditosBean.setEstatus(resultadosStore.getString("Estatus"));
								creditosBean.setDiasFaltaPago(resultadosStore.getString("diasFaltaPago"));
								creditosBean.setGrupoID(resultadosStore.getString("GrupoID"));
								creditosBean.setSucursal(resultadosStore.getString("SucursalID"));

								creditosBean.setFechaInicio(resultadosStore.getString("FechaInicio"));
								creditosBean.setMontoCredito(resultadosStore.getString("montoCredito"));
								creditosBean.setFechaProxPago(resultadosStore.getString("FechaProxPago"));
								creditosBean.setCicloGrupo(resultadosStore.getString("CicloGrupo"));
								creditosBean.setTasaFija(resultadosStore.getString("TasaFija"));

								creditosBean.setTipoPrepago(resultadosStore.getString("TipoPrepago"));
								creditosBean.setOrigen(resultadosStore.getString("Origen"));
								creditosBean.setTasaBase(resultadosStore.getString("TasaBase"));
								creditosBean.setSobreTasa(resultadosStore.getString("SobreTasa"));
								creditosBean.setPisoTasa(resultadosStore.getString("PisoTasa"));

								creditosBean.setTechoTasa(resultadosStore.getString("TechoTasa"));
								creditosBean.setCalcInteresID(resultadosStore.getString("CalcInteresID"));
								creditosBean.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
								creditosBean.setCobraIVASeguroCuota(resultadosStore.getString("CobraIVASeguroCuota"));
								creditosBean.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
								creditosBean.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
								creditosBean.setIdenCreditoCNBV(resultadosStore.getString("IdenCreditoCNBV"));
								creditosBean.setEsAgropecuario(resultadosStore.getString("EsAgropecuario"));
								creditosBean.setEstatusGarantiaFIRA(resultadosStore.getString("EstatusGarantiaFIRA"));
							}
							return creditosBean;
						}
					});
			return creditosAgroBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de creditos agro: ", e);
			return null;
		}
	}

	public CreditosBean consultaLiqAnticipadaAgro(final CreditosBean creditosBean, final int tipoConsulta){
		CreditosBean creditosAgroBean = null;
		try {
			creditosAgroBean = (CreditosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSAGROCON(?,?,?,?,?,	?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CreditoID",creditosBean.getCreditoID());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.consultaLiqAnticipadaAgro");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							CreditosBean creditosBean = new CreditosBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								creditosBean.setSaldoCapVigent(resultadosStore.getString("SaldoCapVigente"));
								creditosBean.setSaldoCapAtrasad(resultadosStore.getString("SaldoCapAtrasa"));
								creditosBean.setSaldoCapVencido(resultadosStore.getString("SaldoCapVencido"));
								creditosBean.setSaldCapVenNoExi(resultadosStore.getString("SaldoCapVenNExi"));
								creditosBean.setSaldoCapContingente(resultadosStore.getString("SaldoCapContingente"));

								creditosBean.setSaldoInterOrdin(resultadosStore.getString("SaldoInteresOrd"));
								creditosBean.setSaldoInterAtras(resultadosStore.getString("SaldoInteresAtr"));
								creditosBean.setSaldoInterVenc(resultadosStore.getString("SaldoInteresVen"));
								creditosBean.setSaldoInterProvi(resultadosStore.getString("SaldoInteresPro"));
								creditosBean.setSaldoIntNoConta(resultadosStore.getString("SaldoIntNoConta"));

								creditosBean.setSaldoIntContingente(resultadosStore.getString("SaldoIntContingente"));
								creditosBean.setSaldoIVAInteres(resultadosStore.getString("SaldoIVAInteres"));
								creditosBean.setSaldoMoratorios(resultadosStore.getString("SaldoMoratorios"));
								creditosBean.setSaldoIVAMorator(resultadosStore.getString("SaldoIVAMorato"));
								creditosBean.setSaldoComFaltPago(resultadosStore.getString("SaldoComFaltaPa"));

								creditosBean.setSalIVAComFalPag(resultadosStore.getString("SaldoIVAComFalP"));
								creditosBean.setSaldoOtrasComis(resultadosStore.getString("SaldoOtrasComis"));
								creditosBean.setSaldoIVAComisi(resultadosStore.getString("SaldoIVAComisi"));

								creditosBean.setTotalCapital(resultadosStore.getString("totalCapital"));
								creditosBean.setTotalInteres(resultadosStore.getString("totalInteres"));
								creditosBean.setTotalComisi(resultadosStore.getString("totalComisi"));
								creditosBean.setTotalIVACom(resultadosStore.getString("totalIVACom"));

								creditosBean.setAdeudoTotal(resultadosStore.getString("adeudoTotal"));
								creditosBean.setSaldoAdmonComis(resultadosStore.getString("ComLiqAntici"));
								creditosBean.setSaldoIVAAdmonComisi(resultadosStore.getString("IVAComLiqAntici"));
								creditosBean.setPermiteFiniquito(resultadosStore.getString("PermiteLiqAnt"));
								creditosBean.setAdeudoTotalSinIVA(resultadosStore.getString("adeudoTotalSinIVA"));

								creditosBean.setSaldoSeguroCuota(resultadosStore.getString("SaldoSeguroCuota"));
								creditosBean.setSaldoIVASeguroCuota(resultadosStore.getString("SaldoIVASeguroCuota"));
								creditosBean.setSaldoComAnual(resultadosStore.getString("SaldoComAnual"));
								creditosBean.setSaldoComAnualIVA(resultadosStore.getString("SaldoComAnualIVA"));
							}
							return creditosBean;
						}
					});
			return creditosAgroBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de creditos agro: ", e);
			return null;
		}
	}

	public CreditosBean consultaExigibleAgro(final CreditosBean creditosBean, final int tipoConsulta){
		CreditosBean creditosAgroBean = null;
		try {
			creditosAgroBean = (CreditosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSAGROCON(?,?,?,?,?,	?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CreditoID",creditosBean.getCreditoID());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.consultaExigibleAgro");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							CreditosBean creditosBean = new CreditosBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								creditosBean.setSaldoCapVigent(resultadosStore.getString("SaldoCapVigente"));
								creditosBean.setSaldoCapAtrasad(resultadosStore.getString("SaldoCapAtrasa"));
								creditosBean.setSaldoCapVencido(resultadosStore.getString("SaldoCapVencido"));
								creditosBean.setSaldCapVenNoExi(resultadosStore.getString("SaldoCapVenNExi"));
								creditosBean.setSaldoCapContingente(resultadosStore.getString("SaldoCapContingente"));
								creditosBean.setSaldoInterOrdin(resultadosStore.getString("SaldoInteresOrd"));

								creditosBean.setSaldoInterAtras(resultadosStore.getString("SaldoInteresAtr"));
								creditosBean.setSaldoInterVenc(resultadosStore.getString("SaldoInteresVen"));
								creditosBean.setSaldoInterProvi(resultadosStore.getString("SaldoInteresPro"));
								creditosBean.setSaldoIntNoConta(resultadosStore.getString("SaldoIntNoConta"));
								creditosBean.setSaldoIntContingente(resultadosStore.getString("SaldoIntContingente"));
								creditosBean.setSaldoIVAInteres(resultadosStore.getString("SaldoIVAInteres"));

								creditosBean.setSaldoMoratorios(resultadosStore.getString("SaldoMoratorios"));
								creditosBean.setSaldoIVAMorator(resultadosStore.getString("SaldoIVAMorato"));
								creditosBean.setSaldoComFaltPago(resultadosStore.getString("SaldoComFaltaPa"));
								creditosBean.setSalIVAComFalPag(resultadosStore.getString("SaldoIVAComFalP"));
								creditosBean.setSaldoOtrasComis(resultadosStore.getString("SaldoOtrasComis"));

								creditosBean.setSaldoIVAComisi(resultadosStore.getString("SaldoIVAComisi"));
								creditosBean.setTotalCapital(resultadosStore.getString("totalCapital"));
								creditosBean.setTotalInteres(resultadosStore.getString("totalInteres"));
								creditosBean.setTotalComisi(resultadosStore.getString("totalComisi"));
								creditosBean.setTotalIVACom(resultadosStore.getString("totalIVACom"));

								creditosBean.setPagoExigible(resultadosStore.getString("adeudoTotal"));
								creditosBean.setTotalCuotaAdelantada(Utileria.convierteDoble((resultadosStore.getString("TotalAdelanto")).replace(",", "")));
								creditosBean.setCuotasAtraso(resultadosStore.getString("CuotasAtraso"));
								creditosBean.setUltCuotaPagada(resultadosStore.getString("UltCuotaPagada"));
								creditosBean.setFechaUltCuota(resultadosStore.getString("FechaUltCuota"));

								creditosBean.setTotalPrimerCuota(resultadosStore.getString("totalPrimerCuota"));
								creditosBean.setSaldoSeguroCuota(resultadosStore.getString("SaldoSeguroCuota"));
								creditosBean.setSaldoIVASeguroCuota(resultadosStore.getString("SaldoIVASeguroCuota"));
								creditosBean.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
								creditosBean.setSaldoComAnual(resultadosStore.getString("SaldoComAnual"));

								creditosBean.setSaldoComAnualIVA(resultadosStore.getString("SaldoComAnualIVA"));
								double totalExigible = Utileria.convierteDoble((resultadosStore.getString("adeudoTotal")).replace(",", ""));
								if (totalExigible > Constantes.DOUBLE_VACIO) {
									creditosBean.setTotalExigibleDia(CalculosyOperaciones.resta(totalExigible, creditosBean.getTotalCuotaAdelantada()));
								} else {
									creditosBean.setTotalExigibleDia(Constantes.DOUBLE_VACIO);
								}
							}
							return creditosBean;
						}
					});
			return creditosAgroBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de creditos agro: ", e);
			return null;
		}
	}

	/*Consulta para generales de credito */
	public CreditosBean consultaSaldos(CreditosBean creditosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaGeneralesCredito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
				try{
				creditosBean.setSaldoInsolutoCartera(resultSet.getString("Var_SaldoInsolCar"));
				creditosBean.setSumatoriaCreditos(resultSet.getString("Var_SumatoriaCred"));


				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	public CreditosBean consultaPagoCreditoAgro(final CreditosBean creditosBean, final int tipoConsulta){
		CreditosBean creditosAgroBean = null;
		try {
			creditosAgroBean = (CreditosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITOSAGROCON(?,?,?,?,?,	?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CreditoID",creditosBean.getCreditoID());
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.consultaPagoCreditoAgro");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							CreditosBean creditosBean = new CreditosBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								creditosBean.setSaldoCapVigent(resultadosStore.getString("SaldoCapVigent"));
								creditosBean.setSaldoCapAtrasad(resultadosStore.getString("SaldoCapAtrasad"));
								creditosBean.setSaldoCapVencido(resultadosStore.getString("SaldoCapVencido"));
								creditosBean.setSaldCapVenNoExi(resultadosStore.getString("SaldCapVenNoExi"));
								creditosBean.setSaldoInterOrdin(resultadosStore.getString("SaldoInterOrdin"));

								creditosBean.setSaldoInterAtras(resultadosStore.getString("SaldoInterAtras"));
								creditosBean.setSaldoInterVenc(resultadosStore.getString("SaldoInterVenc"));
								creditosBean.setSaldoInterProvi(resultadosStore.getString("SaldoInterProvi"));
								creditosBean.setSaldoIntNoConta(resultadosStore.getString("SaldoIntNoConta"));
								creditosBean.setSaldoIVAInteres(resultadosStore.getString("SaldoIVAInteres"));

								creditosBean.setSaldoMoratorios(resultadosStore.getString("SaldoMoratorios"));
								creditosBean.setSaldoIVAMorator(resultadosStore.getString("SaldoIVAMorator"));
								creditosBean.setSaldoComFaltPago(resultadosStore.getString("SaldComFaltPago"));
								creditosBean.setSalIVAComFalPag(resultadosStore.getString("SalIVAComFalPag"));
								creditosBean.setSaldoOtrasComis(resultadosStore.getString("SaldoOtrasComis"));

								creditosBean.setSaldoComAnual(resultadosStore.getString("SaldoComAnual"));
								creditosBean.setSaldoComAnualIVA(resultadosStore.getString("SaldoComAnualIVA"));
								creditosBean.setSaldoIVAComisi(resultadosStore.getString("SaldoIVAComisi"));
								creditosBean.setTotalCapital(resultadosStore.getString("totalCapital"));
								creditosBean.setTotalInteres(resultadosStore.getString("totalInteres"));

								creditosBean.setTotalComisi(resultadosStore.getString("totalComisi"));
								creditosBean.setTotalIVACom(resultadosStore.getString("totalIVACom"));
								creditosBean.setAdeudoTotal(resultadosStore.getString("adeudoTotal"));

							}
							return creditosBean;
						}
					});
			return creditosAgroBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de creditos agro: ", e);
			return null;
		}
	}

	/**
	 * Consulta para aplicacion de garantias AGRO
	 * N°31: Consulta General
	 * @param tipoConsulta: Consulta 31
	 * @return
	 */
	// consulta para aplicacion de garantias AGRO
	public CreditosBean consultaApliGarAgro(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean creditos = null;
		try{
			//Query con el Store Procedure
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaApliGarAgro",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
				    creditosBean.setCuentaID(resultSet.getString("CuentaID"));

				    creditosBean.setMonedaID(resultSet.getString("MonedaID"));
				    creditosBean.setEstatus(resultSet.getString("Estatus"));
				    creditosBean.setDiasFaltaPago(resultSet.getString("diasFaltaPago"));
				    creditosBean.setGrupoID(resultSet.getString("GrupoID"));
				    creditosBean.setSucursal(resultSet.getString("SucursalID"));

				    creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
				    creditosBean.setTasaBase(resultSet.getString("TasaBase"));
				    creditosBean.setSobreTasa(resultSet.getString("SobreTasa"));
				    creditosBean.setPisoTasa(resultSet.getString("PisoTasa"));
				    creditosBean.setTechoTasa(resultSet.getString("TechoTasa"));

				    creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
				    creditosBean.setCalcInteresID(resultSet.getString("CalcInteresID"));
				    creditosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
				    creditosBean.setCicloGrupo(resultSet.getString("CicloGrupo"));
				    creditosBean.setTasaFija(resultSet.getString("TasaFija"));
				    creditosBean.setTipoPrepago(resultSet.getString("TipoPrepago"));

				    creditosBean.setOrigen(resultSet.getString("Origen"));
				    creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
				    creditosBean.setEstatusGarantiaFIRA(resultSet.getString("EstatusGarantiaFIRA"));
				    creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
				    creditosBean.setMontoGarLiq(resultSet.getString("MontoGarLiq"));
				    creditosBean.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
				    creditosBean.setMontoMinisPen(resultSet.getString("MontoMinisPen"));
				    creditosBean.setPorcGarLiq(resultSet.getString("PorcGarLiq"));
				    creditosBean.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
				    creditosBean.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));
					return creditosBean;

				}
			});
			creditos= matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de aplicacion de garantías fira.", e);
			e.printStackTrace();
		}
	return creditos;
	}

	/**
	 * Método que realiza la cancelación de los créditos ya sea grupal o individual
	 * @param creditosBean : Bean con la informacion del crédito a cancelar
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean cancelacionCreditos(final CreditosBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		PolizaBean polizaBean2 = null;
		try {
			transaccionDAO.generaNumeroTransaccion();
			UsuarioBean usuarioBean = new UsuarioBean();
			usuarioBean.setClave(bean.getUsuarioAutoriza());
			if (usuarioBean.getClave().equalsIgnoreCase("")) {
				mensaje.setNumero(4);
				mensaje.setDescripcion("El Usuario de Autorizacion se encuentra vacio.");
				mensaje.setNombreControl("usuarioAutoriza");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
			usuarioBean = usuarioDAO.consultaXClave(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
			// Se genera una contraseña con la clave del usuario y de la contraseña que se reciben desde pantalla.
			String passEnvio = SeguridadRecursosServicio.encriptaPass(bean.getUsuarioAutoriza(), bean.getContrasenia());
			bean.setUsuarioAutoriza(usuarioBean.getUsuarioID());
			if (!usuarioBean.getContrasenia().equals(passEnvio)) {
				mensaje.setNumero(5);
				mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado.");
				mensaje.setNombreControl("contraseniaAutoriza");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
			if (Utileria.convierteEntero(bean.getGrupoID()) > 0) {
				// GRUPAL
				List<CreditosBean> lista = listaCreditosCancel(bean.getDetalleCancelaCred());
				for (int i = 0; i < lista.size(); i++) {
					polizaBean2 = new PolizaBean();
					polizaBean2.setConceptoID(CreditosBean.CANCELACION_CREDITO);
					polizaBean2.setConcepto(CreditosBean.DESCRIPCION_CANCELACION_CRED);
					int contador = 0;
					while (contador <= PolizaBean.numIntentosGeneraPoliza) {
						contador++;
						polizaDAO.generaPolizaIDGenerico(polizaBean2, parametrosAuditoriaBean.getNumeroTransaccion());
						if (Utileria.convierteEntero(polizaBean2.getPolizaID()) > 0) {
							break;
						}
					}

					lista.get(i).setPolizaID(polizaBean2.getPolizaID());
					lista.get(i).setMotivoCancel(bean.getMotivoCancel());
					lista.get(i).setUsuarioAutoriza(bean.getUsuarioAutoriza());
					if (Utileria.convierteEntero(polizaBean2.getPolizaID()) > 0) {
						mensaje = cancelaCredito(lista.get(i));
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}
					} else {
						mensaje.setNumero(999);
						mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
						mensaje.setNombreControl("numeroTransaccion");
						mensaje.setConsecutivoString("0");
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}
					}
				}

			} else {
				//INDIVIDUAL --------------------------------------------------------------------------
				polizaBean2 = new PolizaBean();
				polizaBean2.setConceptoID(CreditosBean.CANCELACION_CREDITO);
				polizaBean2.setConcepto(CreditosBean.DESCRIPCION_CANCELACION_CRED);
				int contador = 0;
				while (contador <= PolizaBean.numIntentosGeneraPoliza) {
					contador++;
					polizaDAO.generaPolizaIDGenerico(polizaBean2, parametrosAuditoriaBean.getNumeroTransaccion());
					if (Utileria.convierteEntero(polizaBean2.getPolizaID()) > 0) {
						break;
					}
				}
				bean.setPolizaID(polizaBean2.getPolizaID());
				if (Utileria.convierteEntero(polizaBean2.getPolizaID()) > 0) {
					mensaje = cancelaCredito(bean);
					if (mensaje.getNumero() != 0) {
						throw new Exception(mensaje.getDescripcion());
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
					if (mensaje.getNumero() != 0) {
						throw new Exception(mensaje.getDescripcion());
					}
				}
			}


		} catch (Exception ex) {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(ex.getMessage());

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Cancelacion de Credito.", ex);
			/* Baja de Poliza en caso de que haya ocurrido un error */
			if (mensaje.getNumero() != 0 && polizaBean2!=null) {
				try {
					if(Utileria.convierteLong(polizaBean2.getPolizaID()) > 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
						bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
						bajaPolizaBean.setDescProceso("CreditosDAO.cancelacionCreditos");
						bajaPolizaBean.setPolizaID(polizaBean2.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error("CreditosDAO.cancelacionCreditos: Credito: " + bean.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
					}
				} catch (Exception exs) {
					exs.printStackTrace();
				}
			}
			/* Fin Baja de la Poliza Contable*/
		}



		return mensaje;
	}

	public List<CreditosBean> listaCreditosCancel(String creditos){
		StringTokenizer tokensBean = new StringTokenizer(creditos, "[");
		String stringCampos;
		String tokensCampos[];
		List<CreditosBean> listaDetalle = new ArrayList<CreditosBean>();
		try {
		while (tokensBean.hasMoreTokens()) {
			CreditosBean detalle = new CreditosBean();
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setCreditoID(tokensCampos[0]);
			detalle.setMontoCredito(tokensCampos[1]);
			detalle.setTotalInteres(tokensCampos[2]);
			detalle.setMontoGLAho(tokensCampos[3]);
			detalle.setMontoComApertura(tokensCampos[4]);
			detalle.setIVAComApertura(tokensCampos[5]);
			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	private MensajeTransaccionBean cancelaCredito(final CreditosBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CANCELACREDITOPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(bean.getCreditoID()));
							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(bean.getPolizaID()));
							sentenciaStore.setDouble("Par_Capital",  Utileria.convierteDoble(bean.getMontoCredito()));
							sentenciaStore.setDouble("Par_Interes",  Utileria.convierteDoble(bean.getTotalInteres()));
							sentenciaStore.setDouble("Par_MontoGarantia",  Utileria.convierteDoble(bean.getMontoGLAho()));
							sentenciaStore.setDouble("Par_MontoComAper",  Utileria.convierteDoble(bean.getMontoComApertura()));
							sentenciaStore.setInt("Par_UsuarioAut",  Utileria.convierteEntero(bean.getUsuarioAutoriza()));
							sentenciaStore.setString("Par_MotivoCancela", bean.getMotivoCancel());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en la Cancelacion del Credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean cobranzaAutxReferencia(final CreditosBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call COBRANZAAUTREFEPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(bean.getFecha()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en la Cobranza Automatica Pago por Referencia.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para el reporte de Pagos por Referencia.
	 * @param creditosBean : {@link CreditosBean} bean con la información para filtrar el reporte
	 * @param tipoLista : {@link int} Tipo de Reporte
	 * @return List<{@link PagosxReferenciaBean}
	 */
	public List<PagosxReferenciaBean> pagosXReferenciaRep(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List listaSaldosTot = null;
		try {
			String query = "call PAGOXREFERENCIAREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?,		"
					+ "?,?)";

			Object[] parametros = {
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaFinal()),
					Utileria.convierteEntero(creditosBean.getSucursal()),
					Utileria.convierteEntero(creditosBean.getProducCreditoID()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.pagosXReferenciaRep",

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PAGOXREFERENCIAREP(  " + Arrays.toString(parametros) + ")");
			List<PagosxReferenciaBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PagosxReferenciaBean creditosBean = new PagosxReferenciaBean();
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setGrupoID(resultSet.getString("GrupoID"));
					creditosBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					creditosBean.setNombreProd(resultSet.getString("NombreProd"));
					creditosBean.setSucursal(resultSet.getString("Sucursal"));
					creditosBean.setCuentaAhoID(resultSet.getString("CuentaID"));
					creditosBean.setSaldoCtaAntesPag(resultSet.getString("SaldoCtaAntesPag"));
					creditosBean.setReferencia(resultSet.getString("Referencia"));
					creditosBean.setFechaApli(resultSet.getString("FechaApli"));
					creditosBean.setSaldoBloqRefere(resultSet.getString("SaldoBloqRefere"));
					creditosBean.setCapitalPag(resultSet.getString("CapitalPag"));
					creditosBean.setInteresPag(resultSet.getString("InteresPag"));
					creditosBean.setMoratoriosPag(resultSet.getString("MoratoriosPag"));
					creditosBean.setComisionesPag(resultSet.getString("ComisionesPag"));
					creditosBean.setiVAPag(resultSet.getString("IVAPag"));
					creditosBean.setTotalPag(resultSet.getString("TotalPag"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setHora(resultSet.getString("Hora"));

					return creditosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte de Pagos por Referencia " + e);
		}
		return listaSaldosTot;
	}


	/**
	 * Método para el reporte de Pagos Anticipados.
	 * @param creditosBean : bean con la información para filtrar el reporte
	 * @param tipoLista : Tipo de Reporte
	 * @return List<CreditosBean>
	 */


	public List<PagosAnticipadosBean> pagosAnticipadosRep(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List listaSaldosTot = null;
		try {
			String query = "call PAGOSANTICIPADOSREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?)";

			Object[] parametros = {
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaFinal()),
					1,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.pagosAnticipadosRep",

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PAGOSANTICIPADOSREP(  " + Arrays.toString(parametros) + ")");
			List<PagosAnticipadosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PagosAnticipadosBean pagosBean = new PagosAnticipadosBean();
					pagosBean.setClienteID(resultSet.getString("ClienteID"));
					pagosBean.setClienteID(resultSet.getString("ClienteID"));
					pagosBean.setNombreCliente(resultSet.getString("NombreCliente"));
					pagosBean.setCreditoID(resultSet.getString("CreditoID"));
					pagosBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
					pagosBean.setNombreInstFon(resultSet.getString("NombreInstitFon"));
					pagosBean.setFechaVencimiento(resultSet.getString("FechaVencim"));
					pagosBean.setFechaDeposito(resultSet.getString("FechaDeposito"));
					pagosBean.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
					pagosBean.setDiasDepAplica(resultSet.getString("DiasDepAplica"));
					pagosBean.setCapital(resultSet.getString("Capital"));
					pagosBean.setInteresOrdinario(resultSet.getString("InteresOrd"));
					pagosBean.setInteresMoratorio(resultSet.getString("InteresMoratorio"));
					pagosBean.setIva(resultSet.getString("IVA"));
					pagosBean.setTotal(resultSet.getString("TotalPagado"));
					pagosBean.setNotasCargo(resultSet.getString("NotasCargo"));
					pagosBean.setIvaNotasCargo(resultSet.getString("IvaNotasCargo"));
					return pagosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte de Pagos por Referencia " + e);
		}
		return listaSaldosTot;
	}

	/* Lista de los Pagos que ha recibido un Crédito Activo de acuerdo a un Crédito Pasivo.*/
	public List listaPagoCreditos(CreditosBean creditosBean, int tipoLista) {
		List listaCredVig = null ;
		try{
			// Query con el Store Procedure
			String query = "call PAGOSCREDITOLIS(?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
									creditosBean.getNombreCliente(),
									creditosBean.getCreditoFondeoID(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"CreditosDAO.listaPagoCreditos",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setFechaPago(resultSet.getString("FechaPago"));
					creditosBean.setTotalPago(resultSet.getString("TotalPagado"));
					creditosBean.setNumTransaccion(resultSet.getString("Transaccion"));


					return creditosBean;
				}
			});

			listaCredVig= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos vigentes o vencidos", e);
		}
		return listaCredVig;
	}


	// Consulta de SPEI para actualizar su Firma
	public SpeiEnvioBean consultaCtaBenOrdSPEI(int tipoConsulta, long numTransaccion) {
		String query = "CALL SPEIENVIOSCON(?,?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
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
				numTransaccion
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL SPEIENVIOSCON("+Arrays.toString(parametros) + ");");
		List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				SpeiEnvioBean speiEnvioBean = new SpeiEnvioBean();

				speiEnvioBean.setFolioSpeiID(resultSet.getString("FolioSpeiID"));
				speiEnvioBean.setCuentaBeneficiario(resultSet.getString("CuentaBeneficiario"));
				speiEnvioBean.setCuentaOrd(resultSet.getString("CuentaOrd"));

				return speiEnvioBean;
			}
		});

		return matches.size() > 0 ? (SpeiEnvioBean)matches.get(0) : null;
	}

	// Actualización de la Firma del SPEI
	public MensajeTransaccionBean actualizarFirmaEnvioSPEI(final SpeiEnvioBean speiEnvioBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
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
									sentenciaStore.setInt("Par_NumAct", Enum_NumActualizacionSPEI.actualizaFirma);

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
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Lista de los Pagos que ha recibido un Crédito Activo de acuerdo a un Crédito Pasivo.*/
	public List listaGuardaValores(CreditosBean creditosBean, int tipoLista) {
		List listaCreditosBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				creditosBean.getCreditoID(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listaGuardaValores",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					creditosBean.setTipoCredito(resultSet.getString("TipoCredito"));
					creditosBean.setMontoCredito(resultSet.getString("Monto"));
					creditosBean.setFechaMinistrado(resultSet.getString("FechaMinistrado"));

					return creditosBean;
				}
			});

			listaCreditosBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para Guarda Valores", e);
		}
		return listaCreditosBean;
	}

	/**
	 * Consulta para Pago de Crédito,Consulta detalle del total de la deuda SCA
	 * N°44: Consulta de Pago de Crédito
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta;44
	 * @return
	 */
	public CreditosBean consultaPagoCreditoCont(CreditosBean creditosBean, int tipoConsulta) {
		try{
		String query = "call CREDITOSAGROCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								creditosBean.getCreditoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagoCredito",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"consultaPagoCreditoCont- call CREDITOSAGROCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CreditosBean creditosBean = new CreditosBean();

					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldCapVenNoExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInterOrdin"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInterAtras"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInterProvi"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorator"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldComFaltPago"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SalIVAComFalPag"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					/*Comision Anual*/
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/*Fin Comision Anual*/
					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));


					creditosBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));

				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;

		} catch(Exception ex){
			ex.printStackTrace();
			return null;
		}
	}

	/**
	 * Consulta detalle exigible con proyeccion
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta;45
	 * @return
	 */
	public CreditosBean consultaPagoCredExigibleCont(CreditosBean creditosBean, int tipoConsulta) {
		try {

		String query = "call CREDITOSAGROCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPagoCredExigible",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "consultaPagoCredExigibleCont - call CREDITOSAGROCON(  " + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldoCapVenNExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInteresOrd"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInteresVen"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInteresPro"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorato"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SaldoIVAComFalP"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));

					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));
					creditosBean.setPagoExigible(resultSet.getString("adeudoTotal"));
					creditosBean.setTotalCuotaAdelantada(Utileria.convierteDoble((resultSet.getString("TotalAdelanto")).replace(",", "")));
					creditosBean.setCuotasAtraso(resultSet.getString("CuotasAtraso"));
					creditosBean.setUltCuotaPagada(resultSet.getString("UltCuotaPagada"));
					creditosBean.setFechaUltCuota(resultSet.getString("FechaUltCuota"));
					creditosBean.setTotalPrimerCuota(resultSet.getString("totalPrimerCuota"));
					//SEGUROS
					creditosBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
					creditosBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));
					creditosBean.setTotalSeguroCuota(resultSet.getString("TotalSeguroCuota"));
					/* Comision Anual */
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/* Fin Comision Anual */

					double totalExigible = Utileria.convierteDoble((resultSet.getString("adeudoTotal")).replace(",", ""));
					if (totalExigible > Constantes.DOUBLE_VACIO) {

						creditosBean.setTotalExigibleDia(CalculosyOperaciones.resta(totalExigible, creditosBean.getTotalCuotaAdelantada()));
					} else {
						creditosBean.setTotalExigibleDia(Constantes.DOUBLE_VACIO);
					}

				return creditosBean;
			}
		});

		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/*Consulta Exigible sin proyectar*/
	public CreditosBean consultaExigibleSinProyCont(CreditosBean creditosBean, int tipoConsulta) {
		try {
		//Query con el Store Procedure
		String query = "call CREDITOSAGROCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaExigibleSinProy",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"consultaExigibleSinProyCont - call CREDITOSAGROCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();

					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigente"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasa"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldoCapVenNExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInteresOrd"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInteresAtr"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInteresVen"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInteresPro"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorato"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldoComFaltaPa"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SaldoIVAComFalP"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					creditosBean.setSaldoSeguroCuota(resultSet.getString("SaldoSeguroCuota"));
					creditosBean.setSaldoIVASeguroCuota(resultSet.getString("SaldoIVASeguroCuota"));

					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));

					creditosBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));
					/* Comision Anual */
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/* Fin Comision Anual */

				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/**
	 * Método para consultar la informacion para el reporte de envío buró de crédito por el covid 19
	 * @author ODIONISIO
	 * @param creditosBean : Clase bean con los parámetros de entrada al SP.
	 * @param tipoLista : Número de lista para generar el reporte de la Cinta de Buró.
	 * @return List : Lista que contiene los registros del reporte.
	 */
	public List listaRepCreditosDiferidos(final CreditosBean creditosBean, int tipoLista){
		List listaResultado = null;
		try{

			String query = "call BUROCREDITOCOVIDREP(?,?,?,?,?,		?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								tipoLista,
								creditosBean.getTipoPersona(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BUROCREDITOCOVIDREP(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean= new CreditosBean();
					creditosBean.setCinta(resultSet.getString("Cinta"));
					creditosBean.setNombreArchivoRepCinta(resultSet.getString("NombreArchivo"));
					return creditosBean ;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultar el reporte de buro de creditos diferidos", e);
		}
		return listaResultado;
	}

	/* Lista de Creditos la cual se requiere Ssupender .*/
	public List listCredSuspension(CreditosBean creditosBean, int tipoLista) {
		List listaCreditosBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				creditosBean.getNombreCliente(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listCredSuspension",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					creditosBean.setNombreProducto(resultSet.getString("Descripcion"));

					return creditosBean;
				}
			});

			listaCreditosBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para Guarda Valores", e);
		}
		return listaCreditosBean;
	}

	/* =============== METODO PARA LA CONSULTA DE INFORMACION DE CREDITO A SUSPENDER ============ */
	public CreditosBean consultaInfoCredSuspencion(CreditosBean creditosBean, int tipoConsulta) {
		tipoConsulta = 44;
		try {
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaInfoCredSuspencion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(resultSet.getString("CreditoID"));
						creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
						creditosBean.setNombreProducto(resultSet.getString("DesProducto"));
						creditosBean.setClienteID(resultSet.getString("ClienteID"));
						creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						creditosBean.setEstatus(resultSet.getString("Estatus"));
						creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
						creditosBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));

						creditosBean.setDesConvenio(resultSet.getString("DesConvenio"));
						creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
						creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
						creditosBean.setDiasAtraso(resultSet.getString("DiasAtraso"));


					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;
				}
			});
			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/**
	 * Método para consultar la informacion para el reporte de operaciones basica de unidad
	 * @author ODIONISIO
	 * @param creditosBean : Clase bean con los parámetros de entrada al SP.
	 * @param tipoLista : Número de lista para generar el reporte de la operaciones basica de unidad
	 * @return List : Lista que contiene los registros del reporte.
	 */
	public List<CreditosBean> listaReporteOperaciones(final CreditosBean creditosBean, int tipoLista){
		List<CreditosBean> listaResultado = null;
		List<CreditosBean> matches = null;
		try{

			String query = "CALL OPERACIONBASICAUNIDADREP(?,?,?,?,?,	?,?,?,?,?,	?,?,?)";

			Object[] parametros ={
								Utileria.convierteFecha(creditosBean.getFechaInicio()),
								Utileria.convierteFecha(creditosBean.getFechaFin()),
								Utileria.convierteEntero(creditosBean.getSucursalID()),
								Utileria.convierteEntero(creditosBean.getCoordinadorID()),
								Utileria.convierteEntero(creditosBean.getPromotorID()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CreditosDAO.listaReporteOperaciones",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL OPERACIONBASICAUNIDADREP(" + Arrays.toString(parametros) + ");");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaFin(resultSet.getString("FechaFin"));
					creditosBean.setTotalClientes(resultSet.getString("TotalClientes"));
					creditosBean.setTotalCtesNuevos(resultSet.getString("TotalCtesNuevos"));
					creditosBean.setTotalCtesCorte(resultSet.getString("TotalCtesCorte"));
					creditosBean.setTotalCtesPagos(resultSet.getString("TotalCtesPagos"));
					creditosBean.setTotalCtesNoPagos(resultSet.getString("TotalCtesNoPagos"));
					creditosBean.setTotalCtesPrepagos(resultSet.getString("TotalCtesPrepagos"));
					creditosBean.setSaldoInicialCaja(resultSet.getString("SaldoInicialCaja"));
					creditosBean.setSaldoEsperadoCartera(resultSet.getString("SaldoEsperadoCartera"));
					creditosBean.setSaldoCartera(resultSet.getString("SaldoCartera"));
					creditosBean.setSaldoRecaudoPrepago(resultSet.getString("SaldoRecaudoPrepago"));
					creditosBean.setPorcentajeRecaudo(resultSet.getString("PorcentajeRecaudo"));
					creditosBean.setPorcentajePretendido(resultSet.getString("PorcentajePretendido"));
					creditosBean.setSaldoTotalCreditos(resultSet.getString("SaldoTotalCreditos"));
					creditosBean.setSaldoGastosDia(resultSet.getString("SaldoGastosDia"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setPromotorID(resultSet.getString("PromotorID"));
					creditosBean.setTipoUsuario(resultSet.getString("TipoUsuario"));
					creditosBean.setTotalCteCreditos(resultSet.getString("TotalCteCreditos"));
					return creditosBean;
				}
			});
			listaResultado = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultar los datos para el reporte de operaciones basica de unidad[listaReporteOperaciones]", e);
		}
		return listaResultado;
	}

	/* =============== METODO PARA LA CONSULTA DE INFORMACION DE CREDITO PARA CARTA LIQUIDACIÓN ============ */
	public CreditosBean consultaInfoCartaLiq(CreditosBean creditosBean, int tipoConsulta) {
		tipoConsulta = 38;
		try {
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.consultaInfoCartaLiq",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					try {
						creditosBean.setCreditoID(resultSet.getString("CreditoID"));
						creditosBean.setClienteID(resultSet.getString("ClienteID"));
						creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
						creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));

					} catch (Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return creditosBean;
				}
			});
			return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/* Lista de Creditos para Carta Liquidación .*/
	public List listCartaLiquidacion(CreditosBean creditosBean, int tipoLista) {
		List listaCreditosBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
//				Constantes.STRING_VACIO,
				creditosBean.getCreditoID(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listCartaLiquidacion",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();

					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));

					return creditosBean;
				}
			});

			listaCreditosBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para Guarda Valores", e);
		}
		return listaCreditosBean;
	}



	//Reporte de Pagos realizados
	public List  consultaRepPagosdeAccesoriosExcel(final CreditosBean creditosBean, int tipoLista){

	List listaResultado = null;
	try{

		String query = "call DETALLEPAGCREPAGACCREP(?,?,?,?,?,		?,?,?,?,?,		?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteFecha(creditosBean.getFechaVencimien()),
							Utileria.convierteEntero(creditosBean.getSucursal()),
							Utileria.convierteEntero(creditosBean.getProducCreditoID()),
							Utileria.convierteEntero(creditosBean.getInstitucionNominaID()),

							Utileria.convierteEntero(creditosBean.getConvenioNominaID()),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),

							"CreditosDAO.consultaRepPagosdeAccesoriosExcel",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPAGCREPAGACCREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteCreditosBean creditosBean= new ReporteCreditosBean();


				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setNombreInstit(resultSet.getString("NombreInstit"));
				creditosBean.setDesConvenio(resultSet.getString("DescripcionConvenio"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

				creditosBean.setProductoCreDescri(resultSet.getString("NombreProducto"));
				creditosBean.setNombreSucursal(resultSet.getString("Sucursal"));
				creditosBean.setFechaPago(resultSet.getString("FechaLiquida"));
				creditosBean.setAmortizacionId(resultSet.getString("AmortizacionID"));
				creditosBean.setAccesoriosId(resultSet.getString("AccesorioID"));

				creditosBean.setDescripcionAccesorios(resultSet.getString("DescripciónAccesorio"));
				creditosBean.setComisiones(resultSet.getString("MontoAccesorio"));
				creditosBean.setMontoIntereses(resultSet.getString("MontoInteres"));
				creditosBean.setIvaMontoIntereses(resultSet.getString("IVAMontoInteres"));
				creditosBean.setIvaComisiones(resultSet.getString("IVAaccesorio"));

				creditosBean.setTotalPagado(resultSet.getString("TotalPagado"));


				return creditosBean ;
			}
		});
		listaResultado = matches;

	} catch (Exception e) {
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reportede pagos realizados", e);
	}
		return listaResultado;
	}
	//Reporte de Servicios Adicionales
	public List  consultaRepServicosAdicioanlesExcel(final ReporteServiciosAdicionalesBean creditosBean, int tipoLista){

	List listaResultado = null;
	try{

		String query = "call SERVICIOSXSOLCREDREPSERREP(?,?,?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(creditosBean.getSucursalID()),
							Utileria.convierteEntero(creditosBean.getProductoCreditoID()),
							Utileria.convierteEntero(creditosBean.getInstitNominaID()),
							Utileria.convierteEntero(creditosBean.getConvenioNominaID()),
							Utileria.convierteEntero(creditosBean.getServiciosId()),
							creditosBean.getEstadoCredito(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditosDAO.consultaRepPagosdeAccesoriosExcel",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSXSOLCREDREPSERREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteServiciosAdicionalesBean creditosBean= new ReporteServiciosAdicionalesBean();


				creditosBean.setCreditoID(resultSet.getString("CreditoID"));
				creditosBean.setServiciosId(resultSet.getString("ServicioID"));
				creditosBean.setDescripcionServicio(resultSet.getString("Descripcion"));
				creditosBean.setNombreInstit(resultSet.getString("NombreInstit"));
				creditosBean.setDesConvenio(resultSet.getString("DescripcionConvenio"));
				creditosBean.setClienteID(resultSet.getString("ClienteID"));
				creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				creditosBean.setProductoCreDescri(resultSet.getString("NombreProducto"));
				creditosBean.setSucursalID(resultSet.getString("Sucursal"));
				creditosBean.setGenero(resultSet.getString("Genero"));
				creditosBean.setRFC(resultSet.getString("RFC"));

				creditosBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				creditosBean.setTipoPersona(resultSet.getString("TipoPersona"));

				creditosBean.setDireccionCliente(resultSet.getString("DireccionCompleta"));
				creditosBean.setCuentaCLABE(resultSet.getString("CuentaCLABE"));
				creditosBean.setTarjeta(resultSet.getString("Tarjeta"));

				return creditosBean ;
			}
		});
		listaResultado = matches;

	} catch (Exception e) {
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reportede pagos realizados", e);
	}
		return listaResultado;
	}


	/* =================== CONSULTA DE LA INFORMACION DEL CREDITO A REALIZAR EL CAMBIO DE FUENTE DE FONDEO ==================== */
	public CreditosBean conCambioFuentFondCred(CreditosBean creditosBean, int tipoConsulta) {
		tipoConsulta = 45;
		try {
		//Query con el Store Procedure
		String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				creditosBean.getCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.conCambioFuentFondCred",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"conCambioFuentFondCred - call CREDITOSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditosBean creditosBean = new CreditosBean();

					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setCuentaID(resultSet.getString("CuentaID"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));

					creditosBean.setNombreProducto(resultSet.getString("Descripcion"));
					creditosBean.setInstitFondeoID(resultSet.getString("InstitFondeoID"));
					creditosBean.setNombreInstitFon(resultSet.getString("NombreInstitFon"));
					creditosBean.setLineaFondeo(resultSet.getString("LineaFondeo"));
					creditosBean.setDescripLinea(resultSet.getString("DescripLinea"));

					creditosBean.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
					creditosBean.setFolioPasivo(resultSet.getString("Folio"));

				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	/* =================== LISTA DE LOS CREDITO A REALIZAR EL CAMBIO DE FUENTE DE FONDEO ==================== */
	public List lisCambioFuentFondCred(CreditosBean creditosBean, int tipoLista) {
		List listaCreditosBean = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CREDITOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				creditosBean.getNombreCliente(),
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.lisCambioFuentFondCred",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CREDITOSLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
					creditosBean.setNombreProducto(resultSet.getString("Descripcion"));

					return creditosBean;
				}
			});

			listaCreditosBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de creditos para Cambio de Fondeo", e);
		}
		return listaCreditosBean;
	}

	/**
	 * Consulta de Prepago cuando el Tipo de Prepago es 'P'
	 * N°49: Consulta para el Pago Cuotas Completas Proyectadas
	 * @param creditosBean: Contiene los datos para realizar la consulta
	 * @param tipoConsulta: Numero de Consulta;
	 * @return
	 */
	public CreditosBean consultaCuotasProyectadas(CreditosBean creditosBean, int tipoConsulta) {
		String query = "call PROYECCUOTASPAGCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	creditosBean.getCreditoID(),
								creditosBean.getCuotasProyectadas(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CreditosDAO.consultaPagoCredito",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROYECCUOTASPAGCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CreditosBean creditosBean = new CreditosBean();
				try{
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldCapVenNoExi"));
					creditosBean.setSaldoInterOrdin(resultSet.getString("SaldoInterOrdin"));

					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInterAtras"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInterProvi"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));

					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorator"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldComFaltPago"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SalIVAComFalPag"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					/*Comision Anual*/
					creditosBean.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					creditosBean.setSaldoComAnualIVA(resultSet.getString("SaldoComAnualIVA"));
					/*Fin Comision Anual*/
					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setTotalCapital(resultSet.getString("totalCapital"));
					creditosBean.setTotalInteres(resultSet.getString("totalInteres"));
					creditosBean.setTotalComisi(resultSet.getString("totalComisi"));
					creditosBean.setTotalIVACom(resultSet.getString("totalIVACom"));


					creditosBean.setAdeudoTotal(resultSet.getString("adeudoTotal"));
				} catch(Exception ex){
					ex.printStackTrace();
					return null;
				}
				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}

	/* Lista de Creditos la cual se requiere Ssupender .*/
	public List listaRazonesNoPago(int tipoLista) {
		List listaRazones = null ;
		try{
			// Query con el Store Procedure
			String query = "CALL CATRAZONIMPAGOLIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.listCredSuspension",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CATRAZONIMPAGOLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					RazonesNoPagoBean razonesNoPagoBean = new RazonesNoPagoBean();
					razonesNoPagoBean.setRazonID(resultSet.getString("CatRazonImpagoCreID"));
					razonesNoPagoBean.setRazonDescripcion(resultSet.getString("Descripcion"));

					return razonesNoPagoBean;
				}
			});

			listaRazones= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el listado de razones de no pago", e);
		}
		return listaRazones;
	}

	//Reporte de Razon no pago
	public List  consultaRepRazonNoPagoExcel(final RazonesNoPagoBean razonesNoPagoBean, int tipoLista){

	List listaResultado = null;
	try{

		String query = "call BITACORAMOVSWSREP(?,?,?,?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(razonesNoPagoBean.getFechaInicio()),
							Utileria.convierteFecha(razonesNoPagoBean.getFechaFin()),
							Utileria.convierteEntero(razonesNoPagoBean.getRazonID()),
							Utileria.convierteLong(razonesNoPagoBean.getCreditoID()),
							Utileria.convierteEntero(razonesNoPagoBean.getClienteID()),
							Utileria.convierteEntero(razonesNoPagoBean.getPromotorID()),
							Utileria.convierteEntero(razonesNoPagoBean.getSucursalID()),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditosDAO.consultaRepRazonNoPagoExcel",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORAMOVSWSREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RazonesNoPagoBean razonesNoPagoBean = new RazonesNoPagoBean();
				razonesNoPagoBean.setNombreCliente(resultSet.getString("NombreCompleto"));
				razonesNoPagoBean.setCreditoID(resultSet.getString("CreditoID"));
				razonesNoPagoBean.setMontoCre(resultSet.getString("MontoCredito"));
				razonesNoPagoBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				razonesNoPagoBean.setFecha(resultSet.getString("Fecha"));
				razonesNoPagoBean.setCapital(resultSet.getString("Capital"));
				razonesNoPagoBean.setRazonDescripcion(resultSet.getString("Descripcion"));
				razonesNoPagoBean.setDiasMora(resultSet.getString("DiasMora"));
				razonesNoPagoBean.setNombrePromotor(resultSet.getString("NombrePromotor"));

				return razonesNoPagoBean ;
			}
		});
		listaResultado = matches;

	} catch (Exception e) {
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reportede pagos realizados", e);
	}
		return listaResultado;
	}


	public CreditosBean consultaCodigoOxxo(CreditosBean creditosBean, int tipoConsulta) {
		String query = "call AMORTIZAINDIVREP(?,?,?,?,?,	?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteLong(creditosBean.getCreditoID()),
							Utileria.convierteEntero(creditosBean.getClienteID()),
							tipoConsulta,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CreditosDAO.consultaRepPagosdeAccesoriosExcel",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTIZAINDIVREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CreditosBean creditosBean = new CreditosBean();
				try{
					creditosBean.setDigVerificador(resultSet.getString("DigVerificador"));

				} catch(Exception ex){
					ex.printStackTrace();
					return null;
				}
				return creditosBean;
			}
		});
		return matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
	}


	/**
	 * Metodo que realiza el listado de pagos conciliados realizados desde la app movil.
	 * @param pagosConciliadoBean
	 * @return
	 */
	public List listaCobranzaConciliado(PagosConciliadoBean pagosConciliadoBean) {
		List listaResultado = null;
		try {
			String query = "call BITACORAPAGOSMOVILLIS(?,?,?,?,?,?,?,?,?,?,?)";

			Object[] parametros = {
					pagosConciliadoBean.getFecha(),
					pagosConciliadoBean.getConciliado(),
					Utileria.convierteEntero(pagosConciliadoBean.getAsesor()),
					1,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREANTSALDOSREP("+ Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						ConciliadoPagBean conciliadoPagBean = new ConciliadoPagBean();
						conciliadoPagBean.setCreditoID(resultSet.getString("CreditoID"));
						conciliadoPagBean.setTransaccion(resultSet.getString("Transaccion"));
						conciliadoPagBean.setMonto(resultSet.getString("Monto"));
						conciliadoPagBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
						conciliadoPagBean.setClaveProm(resultSet.getString("ClaveProm"));
						conciliadoPagBean.setConciliado(resultSet.getString("Conciliado"));
						conciliadoPagBean.setOrigenPago(resultSet.getString("OrigenPago"));

						return conciliadoPagBean;
					}
				});
			listaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reporte de pagos conciliados", e);
		}
		return listaResultado;
	}


	/**
	 * Metodo que realiza el guardado de los datos conciliados por clave de usuario y fecha.
	 * @param pagosConciliadoBean {@link PagosConciliadoBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean guardarDatosConciliados(final PagosConciliadoBean pagosConciliadoBean) {


		UsuarioBean bean = new UsuarioBean();
		bean.setUsuarioID(pagosConciliadoBean.getAsesor());

		final UsuarioBean userBean = usuarioDAO.consultaPrincipal(bean, UsuarioServicio.Enum_Con_Usuario.principal);

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CONCILIACIONPAGOSPRO(?,?,?,?,?,?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_ClaveUsu", (userBean != null) ? userBean.getClave() : "");
								sentenciaStore.setString("Par_FechaConcil", pagosConciliadoBean.getFecha());

   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "guardarDatosConciliados");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){

									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(0);
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

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
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	public CreditosBean creditoParaNotasCargo(CreditosBean creditosBean, int tipoConsulta) {
		CreditosBean registro = null;
		try {
			String query = "CALL CREDITOSCON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),

					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.creditoParaNotasCargo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CREDITOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean resultado = new CreditosBean();
					resultado.setCreditoID(resultSet.getString("CreditoID"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
					resultado.setGrupoID(resultSet.getString("GrupoID"));
					resultado.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					return resultado;
				}
			});
			registro = matches.size() > 0 ? (CreditosBean) matches.get(0) : null;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de credito", e);
		}
		return registro;
	}

	public List<?> listaCreditosParaNotasCargo(int tipoLista, CreditosBean creditosBean) {
		List<?> lista= null;
		try {
			String query = "CALL CREDITOSLIS (?,?,?,?,?,	?,?,?,?,?,	?);";
			Object[] parametros = {
					creditosBean.getCreditoID(),
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.listaCreditosParaNotasCargo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CREDITOSLIS (" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean resultado = new CreditosBean();
					resultado.setCreditoID(resultSet.getString("CreditoID"));
					resultado.setClienteID(resultSet.getString("NombreCompleto"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setFechaInicio(resultSet.getString("FechaInicio"));
					resultado.setFechaVencimien(resultSet.getString("FechaVencimien"));
					resultado.setNombreProducto(resultSet.getString("Descripcion"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de creditos", e);
		}
		return lista;
	}

	public MensajeTransaccionBean actualizaCuentaClabe(final CreditosBean creditos,final int tipoActualizacion) {
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
								String query = "call CREDITOSACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,  ?,?,?,  ?,?,?,?,?,?,?)";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
								sentenciaStore.setLong("Par_NumTransSim",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_FechaAutoriza",Constantes.FECHA_VACIA);
								sentenciaStore.setInt("Par_UsuarioAutoriza",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

								sentenciaStore.setString("Par_FechaInicio",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_FechaVencim",Constantes.FECHA_VACIA);
								sentenciaStore.setDouble("Par_ValorCAT",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_MontoRetDes",Constantes.ENTERO_CERO);
								sentenciaStore.setDouble("Par_FolioDisper",Constantes.ENTERO_CERO);

								sentenciaStore.setString("Par_TipoDisper", Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_TipoPrepago", Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_GrupoID", Constantes.ENTERO_CERO);

   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.actualizaCuentaClabe");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean simulacionPagoGarantiasAgro(final CreditosBean creditosBeans) {
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
								String query = "CALL CRESIMPAGCOMSERGARPRO(?,?,?,?,?," +
																		  "?,?,?,?," +
																		  "?,?,?," +
																		  "?,?,?,?,?,?,?)";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(creditosBeans.getLineaCreditoID()));
								sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(creditosBeans.getSolicitudCreditoID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditosBeans.getCreditoID()));
								sentenciaStore.setInt("Par_MinistracionID", Utileria.convierteEntero(creditosBeans.getMinistracionID()));
								sentenciaStore.setLong("Par_TransaccionID", Utileria.convierteLong(creditosBeans.getTransaccionID()));
								sentenciaStore.setString("Par_FechaVencimiento", creditosBeans.getFechaVencimiento());


								sentenciaStore.registerOutParameter("Par_MontoComisionPago", Types.DECIMAL);
								sentenciaStore.registerOutParameter("Par_PolizaID", Types.BIGINT);
								sentenciaStore.setDouble("Par_MontoCredito", Utileria.convierteDoble(creditosBeans.getMontoCredito()));

   								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CreditosDAO.simulacionPagoGarantiasAgro");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la simulación de pagos de servicios en garantías", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//***************** GETTER Y SETTER **********************
	public SeguroVidaDAO getSeguroVidaDAO() {
		return seguroVidaDAO;
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

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public MinistraCredAgroDAO getMinistraCredAgroDAO() {
		return ministraCredAgroDAO;
	}

	public void setMinistraCredAgroDAO(MinistraCredAgroDAO ministraCredAgroDAO) {
		this.ministraCredAgroDAO = ministraCredAgroDAO;
	}

	public SolicitudCreditoDAO getSolicitudCreditoDAO() {
		return solicitudCreditoDAO;
	}

	public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
		this.solicitudCreditoDAO = solicitudCreditoDAO;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}
}
