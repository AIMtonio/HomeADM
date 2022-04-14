package fondeador.dao;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.bean.RepAnaliticoCarteraPasBean;
import fondeador.bean.RepVencimiPasBean;
import fondeador.beanWS.request.ListaCreditoFondeoBERequest;
import fondeador.servicio.CreditoFondeoServicio.Enum_Sim_PagAmortizacionesFondeo;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

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

import java.sql.ResultSetMetaData;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

/**
 * @author abigail
 *
 */
public class CreditoFondeoDAO extends BaseDAO{

	AmortizaFondeoDAO amortizaFondeoDAO = new AmortizaFondeoDAO();
	PolizaDAO polizaDAO = null;

	public CreditoFondeoDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	/* Alta de credito de Fondeo  */
	public MensajeTransaccionBean alta(final CreditoFondeoBean creditoFondeoBean) {
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
							String query = "call CREDITOFONDEOALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?," +
										"?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
							sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
							sentenciaStore.setString("Par_Folio",creditoFondeoBean.getFolio());
							sentenciaStore.setInt("Par_TipoCalInteres",Utileria.convierteEntero(creditoFondeoBean.getTipoCalInteres()));
							sentenciaStore.setInt("Par_CalcInteresID",Utileria.convierteEntero(creditoFondeoBean.getCalcInteresID()));

							sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditoFondeoBean.getTasaBase()));
							sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditoFondeoBean.getSobreTasa()));
							sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
							sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditoFondeoBean.getPisoTasa()));
							sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditoFondeoBean.getTechoTasa()));

							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditoFondeoBean.getFactorMora()));
							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditoFondeoBean.getMonedaID()));
							sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(creditoFondeoBean.getFechaInicio()));
							sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(creditoFondeoBean.getFechaVencimien()));

							sentenciaStore.setString("Par_TipoPagoCap",creditoFondeoBean.getTipoPagoCapital());
							sentenciaStore.setString("Par_FrecuenciaCap",creditoFondeoBean.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodicidadCap",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
							sentenciaStore.setInt("Par_NumAmortizacion",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));
							sentenciaStore.setString("Par_FrecuenciaInt",creditoFondeoBean.getFrecuenciaInt());

							sentenciaStore.setInt("Par_PeriodicidadInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
							sentenciaStore.setInt("Par_NumAmortInteres",Utileria.convierteEntero(creditoFondeoBean.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditoFondeoBean.getMontoCuota()));
							sentenciaStore.setString("Par_FechaInhabil",creditoFondeoBean.getFechaInhabil());
							sentenciaStore.setString("Par_CalendIrregular",creditoFondeoBean.getCalendIrregular());

							sentenciaStore.setString("Par_DiaPagoCapital",creditoFondeoBean.getDiaPagoCapital());
							sentenciaStore.setString("Par_DiaPagoInteres",creditoFondeoBean.getDiaPagoInteres());
							sentenciaStore.setInt("Par_DiaMesInteres",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCapital",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
							sentenciaStore.setString("Par_AjusFecUlVenAmo",creditoFondeoBean.getAjusFecUlVenAmo());

							sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
							sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteLong(creditoFondeoBean.getNumTransacSim()));
							sentenciaStore.setString("Par_PlazoID",creditoFondeoBean.getPlazoID());
							sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());
							sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));

							sentenciaStore.setDouble("Par_MargenPag",Utileria.convierteDoble(creditoFondeoBean.getMargenPagIguales()));
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(creditoFondeoBean.getInstitucionID()));
							sentenciaStore.setString("Par_CuentaClabe",creditoFondeoBean.getCuentaClabe());
							sentenciaStore.setString("Par_NumCtaInstit",creditoFondeoBean.getNumCtaInstit());
							sentenciaStore.setString("Par_PlazoContable",creditoFondeoBean.getPlazoContable());

							sentenciaStore.setInt("Par_TipoInstitID",Utileria.convierteEntero(creditoFondeoBean.getTipoInstitID()));
							sentenciaStore.setString("Par_NacionalidadIns",creditoFondeoBean.getNacionalidadIns());
							sentenciaStore.setDate("Par_FechaContable",OperacionesFechas.conversionStrDate(creditoFondeoBean.getFechaContable()));
							sentenciaStore.setDouble("Par_ComDispos",Utileria.convierteDoble(creditoFondeoBean.getComDispos()));
							sentenciaStore.setDouble("Par_IvaComDispos",Utileria.convierteDoble(creditoFondeoBean.getIvaComDispos()));

							sentenciaStore.setString("Par_CobraISR",creditoFondeoBean.getCobraISR());
							sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(creditoFondeoBean.getTasaISR()));
							sentenciaStore.setInt("Par_MargenPriCuota",Utileria.convierteEntero(creditoFondeoBean.getMargenPriCuota()));
							sentenciaStore.setString("Par_CapitalizaInteres",creditoFondeoBean.getCapitalizaInteres());
							sentenciaStore.setString("Par_PagosParciales",creditoFondeoBean.getPagosParciales());

							sentenciaStore.setString("Par_TipoFondeador",creditoFondeoBean.getTipoFondeador());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								java.sql.ResultSetMetaData metaDatos;

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								metaDatos = resultadosStore.getMetaData();
								loggerSAFI.info("MetaDatos con "+metaDatos.getColumnCount());

								if(metaDatos.getColumnCount()== 5){
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA
								}else{
									mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
								}
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CreditoFondeoDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de credito de Fondeo" + e);
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

	/* Modificacion de  Credito Fondeador*/
	public MensajeTransaccionBean modifica(final CreditoFondeoBean creditoFondeoBean) {
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
							String query = "call CREDITOFONDEOMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(creditoFondeoBean.getCreditoFondeoID()));
							sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
							sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
							sentenciaStore.setString("Par_Folio",creditoFondeoBean.getFolio());
							sentenciaStore.setInt("Par_TipoCalInteres",Utileria.convierteEntero(creditoFondeoBean.getTipoCalInteres()));

							sentenciaStore.setInt("Par_CalcInteresID",Utileria.convierteEntero(creditoFondeoBean.getCalcInteresID()));
							sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(creditoFondeoBean.getTasaBase()));
							sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(creditoFondeoBean.getSobreTasa()));
							sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
							sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(creditoFondeoBean.getPisoTasa()));

							sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(creditoFondeoBean.getTechoTasa()));
							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(creditoFondeoBean.getFactorMora()));
							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditoFondeoBean.getMonedaID()));
							sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(creditoFondeoBean.getFechaInicio()));

							sentenciaStore.setDate("Par_FechaVencim",OperacionesFechas.conversionStrDate(creditoFondeoBean.getFechaVencimien()));
							sentenciaStore.setString("Par_TipoPagoCap",creditoFondeoBean.getTipoPagoCapital());
							sentenciaStore.setString("Par_FrecuenciaCap",creditoFondeoBean.getFrecuenciaCap());
							sentenciaStore.setInt("Par_PeriodicidadCap",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
							sentenciaStore.setInt("Par_NumAmortizacion",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));

							sentenciaStore.setString("Par_FrecuenciaInt",creditoFondeoBean.getFrecuenciaInt());
							sentenciaStore.setInt("Par_PeriodicidadInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
							sentenciaStore.setInt("Par_NumAmortInteres",Utileria.convierteEntero(creditoFondeoBean.getNumAmortInteres()));
							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(creditoFondeoBean.getMontoCuota()));
							sentenciaStore.setString("Par_FechaInhabil",creditoFondeoBean.getFechaInhabil());

							sentenciaStore.setString("Par_CalendIrregular",creditoFondeoBean.getCalendIrregular());
							sentenciaStore.setString("Par_DiaPagoCapital",creditoFondeoBean.getDiaPagoCapital());
							sentenciaStore.setString("Par_DiaPagoInteres",creditoFondeoBean.getDiaPagoInteres());
							sentenciaStore.setInt("Par_DiaMesInteres",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));
							sentenciaStore.setInt("Par_DiaMesCapital",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));

							sentenciaStore.setString("Par_AjusFecUlVenAmo",creditoFondeoBean.getAjusFecUlVenAmo());
							sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
							sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteLong(creditoFondeoBean.getNumTransacSim()));
							sentenciaStore.setString("Par_PlazoID",creditoFondeoBean.getPlazoID());
							sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());

							sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));
							sentenciaStore.setDouble("Par_MargenPag",Utileria.convierteDoble(creditoFondeoBean.getMargenPagIguales()));
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(creditoFondeoBean.getInstitucionID()));
							sentenciaStore.setString("Par_CuentaClabe",creditoFondeoBean.getCuentaClabe());
							sentenciaStore.setString("Par_NumCtaInstit",creditoFondeoBean.getNumCtaInstit());

							sentenciaStore.setString("Par_PlazoContable",creditoFondeoBean.getPlazoContable());
							sentenciaStore.setString("Par_CapitalizaInteres",creditoFondeoBean.getCapitalizaInteres());
							sentenciaStore.setString("Par_PagosParciales",creditoFondeoBean.getPagosParciales());
							sentenciaStore.setString("Par_TipoFondeador",creditoFondeoBean.getTipoFondeador());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CreditoFondeoDAO.modificacion");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de credito de Fondeo" + e);
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

	/* Pago  de credito de Fondeo  */
	public MensajeTransaccionBean pagoCreditoPasivo(final CreditoFondeoBean creditoFondeoBean) {
		creditoFondeoBean.setMontoPagar(creditoFondeoBean.getMontoPagar().replaceAll("[,]","").replaceAll("[$]",""));
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
							String query = "call PAGOCREDITOFONPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoFonID",Utileria.convierteLong(creditoFondeoBean.getCreditoFondeoID()));
							sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditoFondeoBean.getMontoPagar()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditoFondeoBean.getMonedaID()));
							sentenciaStore.setString("Par_Finiquito",creditoFondeoBean.getFiniquito());
							sentenciaStore.setString("Par_AltaEncPoliza","S");

							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(creditoFondeoBean.getInstitucionID()));
							sentenciaStore.setString("Par_NumCtaInstit",creditoFondeoBean.getNumCtaInstit());
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);
							sentenciaStore.registerOutParameter("Var_Poliza", Types.BIGINT);

							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								java.sql.ResultSetMetaData metaDatos;

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								metaDatos = resultadosStore.getMetaData();
								loggerSAFI.info("MetaDatos con "+metaDatos.getColumnCount());
								if(metaDatos.getColumnCount()== 5){
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA
								}else{
									mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
								}
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CreditoFondeoDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " LineaFondeadorDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en pago  de credito de Fondeo" + e);
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
	 * Método que ejecuta el proceso de prepago de crédito.
	 * @param creditos : Clase bean con los valores de entrada al SP-PREPAGOCREDPASPRO.
	 * @param numeroTransaccion : Número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean prepagoCredito(final CreditoFondeoBean creditos, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PREPAGOCREDPASPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoFonID",Utileria.convierteLong(creditos.getCreditoFondeoID()));
									sentenciaStore.setDouble("Par_MontoPagar",Utileria.convierteDoble(creditos.getMontoPagar()));
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditos.getMonedaID()));
									sentenciaStore.setString("Par_Finiquito",creditos.getFiniquito());
									sentenciaStore.setString("Par_AltaEncPoliza",Constantes.STRING_NO);

									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(creditos.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",creditos.getNumCtaInstit());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_MontoPago",Types.INTEGER);
									sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(creditos.getPolizaID()));

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString("Consecutivo")));
										mensajeTransaccion.setCampoGenerico(String.valueOf(resultadosStore.getString("PolizaID")));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										mensajeTransaccion.setNombreControl("polizaID");
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en prepago de crédito pasivo: ", e);
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
}


	/**
	 * Método de Actualización
	 * Actualiza el número del crédito activo relacionado al crédito pasivo
	 * Aactualiza el número de transacción del pago del crédito activo relacionado al crédito pasivo
	 * @param creditos
	 * @return
	 */
	public MensajeTransaccionBean actualizaDetallePago(final CreditoFondeoBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if(creditos.getNumeroTransaccion() == 0){
			System.out.println("Entra Pago Credito");
			creditos.setNumeroTransaccion(parametrosAuditoriaBean.getNumeroTransaccion());
		}
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {

								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREDITOSFONDACT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(creditos.getCreditoID()));
									sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(creditos.getCreditoFondeoID()));
									sentenciaStore.setLong("Par_FolioPagoActivo", Utileria.convierteLong(creditos.getFolioPagoActivo()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",creditos.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("Par_NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getString("consecutivo")));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										mensajeTransaccion.setNombreControl("polizaID");
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualización de crédito pasivo: ", e);
					transaction.setRollbackOnly();
				}

				return mensajeBean;
			}

		});
		return mensaje;
}

	/**
	 * Prepago de Crédito Pasivo con Cargo a Cuenta.
	 * @param creditos : Clase bean con los parámetros de entrada al SP-PREPAGOPASIVOSIGCPRO.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean prepagoCreditoPasivo(final CreditoFondeoBean creditos) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(CreditoFondeoBean.conceptoPagoCredito);
		polizaBean.setConcepto(CreditoFondeoBean.descripcionPagoCredito);

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
						String numeroCredito = creditos.getCreditoID();
						creditos.setNumeroTransaccion(parametrosAuditoriaBean.getNumeroTransaccion());

						mensajeBean=prepagoCredito(creditos,parametrosAuditoriaBean.getNumeroTransaccion());
						if((mensajeBean.getNumero() == 0 || mensajeBean.getNumero() == 000) && numeroCredito != ""){

							 actualizaDetallePago(creditos);
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en prepago de credito pasivo: ", e);
					}
					return mensajeBean;
				}
			});

			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(creditos.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}

		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	/* Consuta Credito PASIVO  por Llave Principal */
	public CreditoFondeoBean consultaPrincipal(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON( " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
				creditoFondeo.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
				creditoFondeo.setLineaFondeoID(resultSet.getString("LineaFondeoID"));
				creditoFondeo.setInstitutFondID(resultSet.getString("InstitutFondID"));
				creditoFondeo.setFolio(resultSet.getString("Folio"));
				creditoFondeo.setTipoCalInteres(resultSet.getString("TipoCalInteres"));

				creditoFondeo.setCalcInteresID(resultSet.getString("CalcInteresID"));
				creditoFondeo.setTasaBase(resultSet.getString("TasaBase"));
				creditoFondeo.setSobreTasa(resultSet.getString("SobreTasa"));
				creditoFondeo.setTasaFija(resultSet.getString("TasaFija"));
				creditoFondeo.setPisoTasa(resultSet.getString("PisoTasa"));

				creditoFondeo.setTechoTasa(resultSet.getString("TechoTasa"));
				creditoFondeo.setFactorMora(resultSet.getString("FactorMora"));
				creditoFondeo.setMonto(resultSet.getString("Monto"));
				creditoFondeo.setMonedaID(resultSet.getString("MonedaID"));
				creditoFondeo.setPlazoContable(resultSet.getString("PlazoContable"));

				creditoFondeo.setFechaContable(resultSet.getString("FechaContable"));
				creditoFondeo.setFechaInicio(resultSet.getString("FechaInicio"));
				creditoFondeo.setFechaVencimien(resultSet.getString("FechaVencimien"));
				creditoFondeo.setFechaTerminaci(resultSet.getString("FechaTerminaci"));
				creditoFondeo.setEstatus(resultSet.getString("Estatus"));

				creditoFondeo.setTipoPagoCapital(resultSet.getString("TipoPagoCapital"));
				creditoFondeo.setFrecuenciaCap(resultSet.getString("FrecuenciaCap"));
				creditoFondeo.setPeriodicidadCap(resultSet.getString("PeriodicidadCap"));
				creditoFondeo.setNumAmortizacion(resultSet.getString("NumAmortizacion"));
				creditoFondeo.setFrecuenciaInt(resultSet.getString("FrecuenciaInt"));

				creditoFondeo.setPeriodicidadInt(resultSet.getString("PeriodicidadInt"));
				creditoFondeo.setNumAmortInteres(resultSet.getString("NumAmortInteres"));
				creditoFondeo.setMontoCuota(resultSet.getString("MontoCuota"));
				creditoFondeo.setFechaInhabil(resultSet.getString("FechaInhabil"));
				creditoFondeo.setCalendIrregular(resultSet.getString("CalendIrregular"));

				creditoFondeo.setDiaPagoInteres(resultSet.getString("DiaPagoInteres"));
				creditoFondeo.setDiaPagoCapital(resultSet.getString("DiaPagoCapital"));
				creditoFondeo.setDiaMesInteres(resultSet.getString("DiaMesInteres"));
				creditoFondeo.setDiaMesCapital(resultSet.getString("DiaMesCapital"));
				creditoFondeo.setAjusFecUlVenAmo(resultSet.getString("AjusFecUlVenAmo"));

				creditoFondeo.setAjusFecExiVen(resultSet.getString("AjusFecExiVen"));
				creditoFondeo.setNumTransacSim(resultSet.getString("NumTransacSim"));
				creditoFondeo.setPlazoID(resultSet.getString("PlazoID"));
				creditoFondeo.setPagaIva(resultSet.getString("PagaIva"));
				creditoFondeo.setIva(resultSet.getString("PorcentanjeIVA"));

				creditoFondeo.setMargenPagIguales(resultSet.getString("MargenPagIgual"));
				creditoFondeo.setInstitucionID(resultSet.getString("InstitucionID"));
				creditoFondeo.setCuentaClabe(resultSet.getString("CuentaClabe"));
				creditoFondeo.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				creditoFondeo.setTipoInstitID(resultSet.getString("TipoInstitID"));

				creditoFondeo.setNacionalidadIns(resultSet.getString("NacionalidadIns"));
				creditoFondeo.setComDispos(resultSet.getString("ComDispos"));
				creditoFondeo.setIvaComDispos(resultSet.getString("IvaComDispos"));
				creditoFondeo.setCapitalizaInteres(resultSet.getString("CapitalizaInteres"));
				creditoFondeo.setTipoFondeador(resultSet.getString("TipoFondeador"));
				creditoFondeo.setPagosParciales(resultSet.getString("PagosParciales"));
				creditoFondeo.setRefinancia(resultSet.getString("Refinancia"));
				creditoFondeo.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
				creditoFondeo.setTipoCancelacion(resultSet.getString("TipoCancelacion"));

				return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}

/* Consuta Credito PASIVO  foranea */
	public CreditoFondeoBean consultaForanea(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON( " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
			    creditoFondeo.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
			    creditoFondeo.setLineaFondeoID(resultSet.getString("LineaFondeoID"));
			    creditoFondeo.setInstitutFondID(resultSet.getString("InstitutFondID"));
			    creditoFondeo.setMonto(resultSet.getString("Monto"));
			    creditoFondeo.setSaldoCredito(resultSet.getString("SaldoCredito"));
			    creditoFondeo.setFechaInicio(resultSet.getString("FechaInicio"));
			    return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}
	/* Consuta Credito PASIVO  Ajuste Movimientos */
	public CreditoFondeoBean consultaAjusteMovimientos(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		CreditoFondeoBean consultaBean = null;
		try{
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON( " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
			    creditoFondeo.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
			    creditoFondeo.setLineaFondeoID(resultSet.getString("LineaFondeoID"));
			    creditoFondeo.setInstitutFondID(resultSet.getString("InstitutFondID"));
			    creditoFondeo.setMonto(resultSet.getString("Monto"));
			    creditoFondeo.setMonedaID(resultSet.getString("MonedaID"));
			    creditoFondeo.setFechaInicio(resultSet.getString("FechaInicio"));
			    creditoFondeo.setFechaVencimien(resultSet.getString("FechaVencimien"));
			    creditoFondeo.setEstatus(resultSet.getString("Estatus"));
			    creditoFondeo.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
			    creditoFondeo.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
			    creditoFondeo.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
			    creditoFondeo.setSaldoInteres(resultSet.getString("SaldoInteresPro"));
			    creditoFondeo.setProvisionAcum(resultSet.getString("ProvisionAcum"));
			    creditoFondeo.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
			    creditoFondeo.setSaldoMoratorio(resultSet.getString("SaldoMoratorios"));
			    creditoFondeo.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));
			    creditoFondeo.setSaldoComFaltPag(resultSet.getString("SaldoComFaltaPa"));
			    creditoFondeo.setSaldoIVAComFal(resultSet.getString("SaldoIVAComFalP"));
			    creditoFondeo.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
			    creditoFondeo.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
			    creditoFondeo.setTotalCapital(resultSet.getString("totalCapital"));
			    creditoFondeo.setTotalInteres(resultSet.getString("totalInteres"));
			    creditoFondeo.setTotalComisi(resultSet.getString("totalComisi"));
			    creditoFondeo.setTotalIVACom(resultSet.getString("totalIVACom"));
			    creditoFondeo.setPagaIva(resultSet.getString("PagaIva"));
			    creditoFondeo.setPorcentanjeIVA(resultSet.getString("PorcentanjeIVA"));
			    creditoFondeo.setCobraISR(resultSet.getString("CobraISR"));
			    creditoFondeo.setTasaISR(resultSet.getString("TasaISR"));
			    creditoFondeo.setAdeudoTotal(resultSet.getString("AdeudoTotal"));
			    creditoFondeo.setSaldoRetencion(resultSet.getString("SaldoRetencion"));
			    return creditoFondeo;
			}
		});
		consultaBean= matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta Ajuste de Movimientos", e);
		}
		return consultaBean;
	}

	/* Consulta Pago Exigible de Credito Pasivo*/
	public CreditoFondeoBean consultaExigible(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON( " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
				creditoFondeo.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
				creditoFondeo.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
				creditoFondeo.setSaldoInteres(resultSet.getString("SaldoInteresPro"));
				creditoFondeo.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
				creditoFondeo.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
				creditoFondeo.setSaldoMoratorio(resultSet.getString("SaldoMoratorios"));
				creditoFondeo.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));
				creditoFondeo.setSaldoComFaltPag(resultSet.getString("SaldoComFaltaPa"));
				creditoFondeo.setSaldoIVAComFal(resultSet.getString("SaldoIVAComFalP"));
				creditoFondeo.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
				creditoFondeo.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
				creditoFondeo.setTotalCapital(resultSet.getString("TotalCapital"));
				creditoFondeo.setTotalInteres(resultSet.getString("TotalInteres"));
				creditoFondeo.setTotalComisi(resultSet.getString("TotalComisi"));
				creditoFondeo.setTotalIVACom(resultSet.getString("TotalIVACom"));
				creditoFondeo.setPagoExigible(resultSet.getString("TotalExigible"));
				creditoFondeo.setSaldoRetencion(resultSet.getString("SaldoRetencion"));
				return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}

	/**
	 * Consulta Prepago de Crédito Pasivo.
	 * @param CreditoFondeoBean : Clase bean con los parámetros de entrada al SP-CREDITOFONDEOCON.
	 * @param tipoConsulta : No. de consulta 6.
	 * @return {@link CreditoFondeoBean} con el resultado de la consulta.
	 * @author avelasco
	 */
	public CreditoFondeoBean consultaPrepago(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
			    creditoFondeo.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
			    creditoFondeo.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
			    creditoFondeo.setSaldoInteres(resultSet.getString("SaldoInteresPro"));
			    creditoFondeo.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
			    creditoFondeo.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
			    creditoFondeo.setSaldoMoratorio(resultSet.getString("SaldoMoratorios"));
			    creditoFondeo.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));
			    creditoFondeo.setSaldoComFaltPag(resultSet.getString("SaldoComFaltaPa"));
			    creditoFondeo.setSaldoIVAComFal(resultSet.getString("SaldoIVAComFalP"));
			    creditoFondeo.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
			    creditoFondeo.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
			    creditoFondeo.setTotalCapital(resultSet.getString("TotalCapital"));
			    creditoFondeo.setTotalInteres(resultSet.getString("TotalInteres"));
			    creditoFondeo.setTotalComisi(resultSet.getString("TotalComisi"));
			    creditoFondeo.setTotalIVACom(resultSet.getString("TotalIVACom"));
			    creditoFondeo.setPagoExigible(resultSet.getString("TotalExigible"));
			    creditoFondeo.setSaldoRetencion(resultSet.getString("SaldoRetencion"));
			    creditoFondeo.setExisteAtraso(resultSet.getString("ExisteAtraso"));
			    return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}

	/**
	 * Consulta para saber si un crédito pasivo se generó de manera automática por las siguientes opciones:
	 * -- Fue fondeado en el desembolso del crédito activo.
	 * -- Se originó por el cambio de fuente de fondeo
	 * -- Se originó por la afectación de garantías FEGA/FONAGA
	 * @param CreditoFondeoBean: Clase bean con los parámetros de entrada al SP-CREDITOFONDEOCON
	 * @param tipoConsulta: No. de Consulta 7.
	 * @return CreditoFondeoBean con el resultado de la consulta
	 */
	public CreditoFondeoBean consultaRelacionCred(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();
			    creditoFondeo.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));

			    return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}
	/* Consuta Creditos fondeo para pantalla de banca en linea */
	public CreditoFondeoBean consultaCreditodFondeoWS(CreditoFondeoBean CreditoFondeoBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call CREDITOFONDEOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(CreditoFondeoBean.getCreditoFondeoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOCON( " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditoFondeoBean creditoFondeo = new CreditoFondeoBean();

				creditoFondeo.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
				creditoFondeo.setTasaFija(resultSet.getString("Tasa"));
			    creditoFondeo.setMonedaID(resultSet.getString("Moneda"));
			    creditoFondeo.setFechaInicio(resultSet.getString("FecInicio"));
			    creditoFondeo.setFechaVencimien(resultSet.getString("FecVencimiento"));
			    creditoFondeo.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
			    creditoFondeo.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
			    creditoFondeo.setSaldoInteres(resultSet.getString("SaldoInteresPro"));
			    creditoFondeo.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
			    creditoFondeo.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
			    creditoFondeo.setSaldoMoratorio(resultSet.getString("SaldoMoratorios"));
			    creditoFondeo.setSaldoIVAMora(resultSet.getString("SaldoIVAMora"));
			    creditoFondeo.setSaldoComFaltPag(resultSet.getString("SaldoComFaltaPa"));
			    creditoFondeo.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
			    creditoFondeo.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
			    creditoFondeo.setSaldoRetencion(resultSet.getString("SaldoRetencion"));
			    creditoFondeo.setSaldoIVAComFal(resultSet.getString("SaldoIVAComFalP"));
			    creditoFondeo.setInstitutFondID(resultSet.getString("InstitutFondID"));
			    creditoFondeo.setLineaFondeoID(resultSet.getString("LineaFondeoID"));
			    return creditoFondeo;
			}
		});
		return matches.size() > 0 ? (CreditoFondeoBean) matches.get(0) : null;
	}

	/* lista principal de creditos de fondeo*/
	public List listaPrincipal(final CreditoFondeoBean creditoFondeoBean, final int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CREDITOFONDEOLIS(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_DesLinFondeo",creditoFondeoBean.getNombreInstitFon());
				sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
				sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
				sentenciaStore.setInt("Par_NumLis",tipoLista);
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
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						CreditoFondeoBean	creditoFondeo	=new CreditoFondeoBean();
						creditoFondeo.setCreditoFondeoID(resultadosStore.getString("CreditoFondeoID"));
						creditoFondeo.setFolio(resultadosStore.getString("Folio"));
						creditoFondeo.setNombreInstitFon(resultadosStore.getString("NombreInstitFon"));
						matches2.add(creditoFondeo);
					}
				}
				return matches2;
			}
		});
		return matches;
	}

	/* lista principal de creditos de fondeo*/
	public List listaForanea(final CreditoFondeoBean creditoFondeoBean, final int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CREDITOFONDEOLIS(" +
						"?,?,?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);

        		sentenciaStore.setString("Par_DesLinFondeo",Constantes.STRING_VACIO);
				sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
				sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
				sentenciaStore.setInt("Par_NumLis",tipoLista);
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
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						CreditoFondeoBean	creditoFondeo	=new CreditoFondeoBean();
						creditoFondeo.setCreditoFondeoID(resultadosStore.getString("CreditoFondeoID"));
						creditoFondeo.setFolio(resultadosStore.getString("Folio"));
						creditoFondeo.setNombreInstitFon(resultadosStore.getString("NombreInstitFon"));
						matches2.add(creditoFondeo);
					}
				}
				return matches2;
			}
		});
		return matches;
	}


	/* lista principal de creditos de fondeo*/
	public List listaDetalleLinFon(final CreditoFondeoBean creditoFondeoBean, final int tipoLista){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call CREDITOFONDEOLIS(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_DesLinFondeo",creditoFondeoBean.getNombreInstitFon());
				sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
				sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
				sentenciaStore.setInt("Par_NumLis",tipoLista);
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
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						CreditoFondeoBean	creditoFondeo	=new CreditoFondeoBean();
						creditoFondeo.setCreditoFondeoID(resultadosStore.getString("CreditoFondeoID"));
						creditoFondeo.setFolio(resultadosStore.getString("Folio"));
						matches2.add(creditoFondeo);
					}
				}
				return matches2;
			}
		});
		return matches;
	}
	/* SIMULADOR DE PAGOS CRECIENTES CON TASA FIJA */
	public List simPagCrecientesFondeo (final CreditoFondeoBean creditoFondeoBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		AmortizaFondeoBean amortizacionFond = null;
		final AmortizaFondeoBean amortizaFondeo = new AmortizaFondeoBean();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONPAGCRECAMORPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
				sentenciaStore.setString("Par_PagoCuota",creditoFondeoBean.getFrecuenciaCap());
				sentenciaStore.setString("Par_PagoFinAni",creditoFondeoBean.getDiaPagoCapital());

				sentenciaStore.setInt("Par_DiaMes",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
				sentenciaStore.setString("Par_FechaInicio",(creditoFondeoBean.getFechaInicio()));
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));
				sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());
				sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));

				sentenciaStore.setString("Par_DiaHabilSig",creditoFondeoBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditoFondeoBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.setDouble("Par_MargenPag",Utileria.convierteDoble(creditoFondeoBean.getMargenPagIguales()));

				sentenciaStore.setString("Par_CobraISR",creditoFondeoBean.getCobraISR());
				sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(creditoFondeoBean.getTasaISR()));
				sentenciaStore.setInt("Par_MargenPriCuota",Utileria.convierteEntero(creditoFondeoBean.getMargenPriCuota()));
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

				sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);
				sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
					AmortizaFondeoBean	amortizaFondeoBean	=new AmortizaFondeoBean();
					amortizaFondeoBean.setAmortizacionID(resultadosStore.getString(1));
					amortizaFondeoBean.setFechaInicio(resultadosStore.getString(2));
					amortizaFondeoBean.setFechaVencim(resultadosStore.getString(3));
					amortizaFondeoBean.setFechaExigible(resultadosStore.getString(4));
					amortizaFondeoBean.setCapital(resultadosStore.getString(5));
					amortizaFondeoBean.setInteres(resultadosStore.getString(6));
					amortizaFondeoBean.setIvaInteres(resultadosStore.getString(7));
					amortizaFondeoBean.setTotalPago(resultadosStore.getString(8));
					amortizaFondeoBean.setSaldoInsoluto(resultadosStore.getString(9));
					amortizaFondeoBean.setDias(resultadosStore.getString(10));
					amortizaFondeoBean.setCuotasCapital(resultadosStore.getString(11));
					amortizaFondeoBean.setNumTransaccion(resultadosStore.getString(12));
					amortizaFondeoBean.setFecUltAmor(resultadosStore.getString(13));
					amortizaFondeoBean.setFecInicioAmor(resultadosStore.getString(14));
					amortizaFondeoBean.setMontoCuota(resultadosStore.getString(15));
					amortizaFondeoBean.setRetencion(resultadosStore.getString(16));
					matches2.add(amortizaFondeoBean);
					}
				}
				return matches2;
			}
		});
		CreditoFondeoBean creditoFondeo = new  CreditoFondeoBean();
		creditoFondeo.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		bajaEnTemporalSimuladorFondeo(creditoFondeo);
		return matches;
	}

	/* SIMULADOR DE PAGOS IGUALES CON TASA FIJA */
	public List simPagIgualesFondeo (final CreditoFondeoBean creditoFondeoBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONPAGIGUAMORPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?,	?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
				sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
				sentenciaStore.setString("Par_PagoCuota",creditoFondeoBean.getFrecuenciaCap());

				sentenciaStore.setString("Par_PagoInter",creditoFondeoBean.getFrecuenciaInt());
				sentenciaStore.setString("Par_PagoFinAni",creditoFondeoBean.getDiaPagoCapital());
				sentenciaStore.setString("Par_PagoFinAniInt",creditoFondeoBean.getDiaPagoInteres());
				sentenciaStore.setString("Par_FechaInicio",(creditoFondeoBean.getFechaInicio()));
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));

				sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditoFondeoBean.getNumAmortInteres()));
				sentenciaStore.setString("Par_DiaHabilSig",creditoFondeoBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditoFondeoBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
				sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));

				sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
				sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());
				sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));
				sentenciaStore.setString("Par_CobraISR",creditoFondeoBean.getCobraISR());
				sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(creditoFondeoBean.getTasaISR()));

				sentenciaStore.setInt("Par_MargenPriCuota",Utileria.convierteEntero(creditoFondeoBean.getMargenPriCuota()));
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);

				sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_CuotasInt", Types.INTEGER);
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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						AmortizaFondeoBean	amortizaFondeoBean	=new AmortizaFondeoBean();
						amortizaFondeoBean.setAmortizacionID(resultadosStore.getString(1));
						amortizaFondeoBean.setFechaInicio(resultadosStore.getString(2));
						amortizaFondeoBean.setFechaVencim(resultadosStore.getString(3));
						amortizaFondeoBean.setFechaExigible(resultadosStore.getString(4));
						amortizaFondeoBean.setCapital(resultadosStore.getString(5));
						amortizaFondeoBean.setInteres(resultadosStore.getString(6));
						amortizaFondeoBean.setIvaInteres(resultadosStore.getString(7));
						amortizaFondeoBean.setTotalPago(resultadosStore.getString(8));
						amortizaFondeoBean.setSaldoInsoluto(resultadosStore.getString(9));
						amortizaFondeoBean.setDias(resultadosStore.getString(10));
						amortizaFondeoBean.setCapitalInteres(resultadosStore.getString(11));
						amortizaFondeoBean.setCuotasCapital(resultadosStore.getString(12));
						amortizaFondeoBean.setCuotasInteres(resultadosStore.getString(13));
						amortizaFondeoBean.setNumTransaccion(resultadosStore.getString(14));
						amortizaFondeoBean.setFecUltAmor(resultadosStore.getString(15));
						amortizaFondeoBean.setFecInicioAmor(resultadosStore.getString(16));
						amortizaFondeoBean.setMontoCuota(resultadosStore.getString(17));
						amortizaFondeoBean.setRetencion(resultadosStore.getString(18));
						matches2.add(amortizaFondeoBean);
					}
				}
				return matches2;
			}
		});
		CreditoFondeoBean creditoFondeo = new  CreditoFondeoBean();
		creditoFondeo.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		bajaEnTemporalSimuladorFondeo(creditoFondeo);
		return matches;
	}

	/* SIMULADOR DE PAGOS IGUALES CON TASA FIJA y CAPITALIZACION*/
	public List simPagIgualesConCapitalizacionFondeo (final CreditoFondeoBean creditoFondeoBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONCAPCAPAMORPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
				sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
				sentenciaStore.setString("Par_PagoCuota",creditoFondeoBean.getFrecuenciaCap());

				sentenciaStore.setString("Par_PagoInter",creditoFondeoBean.getFrecuenciaInt());
				sentenciaStore.setString("Par_PagoFinAni",creditoFondeoBean.getDiaPagoCapital());
				sentenciaStore.setString("Par_PagoFinAniInt",creditoFondeoBean.getDiaPagoInteres());
				sentenciaStore.setString("Par_FechaInicio",(creditoFondeoBean.getFechaInicio()));
				// sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));

				sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditoFondeoBean.getNumAmortInteres()));
				sentenciaStore.setString("Par_DiaHabilSig",creditoFondeoBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditoFondeoBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
				sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));

				sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
				sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());
				sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));
				sentenciaStore.setString("Par_CobraISR",creditoFondeoBean.getCobraISR());
				sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(creditoFondeoBean.getTasaISR()));

				sentenciaStore.setInt("Par_MargenPriCuota",Utileria.convierteEntero(creditoFondeoBean.getMargenPriCuota()));
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.registerOutParameter("Par_NumTran", Types.CHAR);

				sentenciaStore.registerOutParameter("Par_Cuotas", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_CuotasInt", Types.INTEGER);
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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						AmortizaFondeoBean	amortizaFondeoBean	=new AmortizaFondeoBean();
						amortizaFondeoBean.setAmortizacionID(resultadosStore.getString(1));
						amortizaFondeoBean.setFechaInicio(resultadosStore.getString(2));
						amortizaFondeoBean.setFechaVencim(resultadosStore.getString(3));
						amortizaFondeoBean.setFechaExigible(resultadosStore.getString(4));
						amortizaFondeoBean.setCapital(resultadosStore.getString(5));
						amortizaFondeoBean.setInteres(resultadosStore.getString(6));
						amortizaFondeoBean.setIvaInteres(resultadosStore.getString(7));
						amortizaFondeoBean.setTotalPago(resultadosStore.getString(8));
						amortizaFondeoBean.setSaldoInsoluto(resultadosStore.getString(9));
						amortizaFondeoBean.setDias(resultadosStore.getString(10));
						amortizaFondeoBean.setCapitalInteres(resultadosStore.getString(11));
						amortizaFondeoBean.setCuotasCapital(resultadosStore.getString(12));
						amortizaFondeoBean.setCuotasInteres(resultadosStore.getString(13));
						amortizaFondeoBean.setNumTransaccion(resultadosStore.getString(14));
						amortizaFondeoBean.setFecUltAmor(resultadosStore.getString(15));
						amortizaFondeoBean.setFecInicioAmor(resultadosStore.getString(16));
						amortizaFondeoBean.setMontoCuota(resultadosStore.getString(17));
						amortizaFondeoBean.setRetencion(resultadosStore.getString(18));
						matches2.add(amortizaFondeoBean);
					}
				}
				return matches2;
			}
		});
		CreditoFondeoBean creditoFondeo = new  CreditoFondeoBean();
		creditoFondeo.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		bajaEnTemporalSimuladorFondeo(creditoFondeo);
		return matches;
	}

	public void bajaEnTemporalSimuladorFondeo(final CreditoFondeoBean creditoFondeoBean){
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
									sentenciaStore.setLong("Par_NumTranSim",Utileria.convierteLong(creditoFondeoBean.getNumTransacSim()));
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

	/* SIMULADOR DE PAGOS IGUALES CON TASA VARIABLE */
	public List simPagTasaVarFondeo(final CreditoFondeoBean creditoFondeoBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONTASVARAMORPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
				sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
				sentenciaStore.setString("Par_PagoCuota",creditoFondeoBean.getFrecuenciaCap());
				sentenciaStore.setString("Par_PagoInter",creditoFondeoBean.getFrecuenciaInt());

				sentenciaStore.setString("Par_PagoFinAni",creditoFondeoBean.getDiaPagoCapital());
				sentenciaStore.setString("Par_PagoFinAniInt",creditoFondeoBean.getDiaPagoInteres());
				sentenciaStore.setString("Par_FechaInicio",(creditoFondeoBean.getFechaInicio()));
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));
				sentenciaStore.setInt("Par_NumCuotasInt",Utileria.convierteEntero(creditoFondeoBean.getNumAmortInteres()));

				sentenciaStore.setString("Par_DiaHabilSig",creditoFondeoBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditoFondeoBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
				sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));
				sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
				sentenciaStore.setDouble("Par_Tasa", Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));

				sentenciaStore.setString("Par_PagaIVA", creditoFondeoBean.getPagaIva());
				sentenciaStore.setDouble("Par_TasaISR", Utileria.convierteDoble(creditoFondeoBean.getTasaISR()));
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
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONTASVARAMORPRO( "+sentenciaStore.toString()+")");

				return sentenciaStore;
			}
		},new CallableStatementCallback() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						AmortizaFondeoBean	amortizaFondeo	=new AmortizaFondeoBean();
						amortizaFondeo.setAmortizacionID(resultadosStore.getString(1));
						amortizaFondeo.setFechaInicio(resultadosStore.getString(2));
						amortizaFondeo.setFechaVencim(resultadosStore.getString(3));
						amortizaFondeo.setFechaExigible(resultadosStore.getString(4));
						amortizaFondeo.setCapital(resultadosStore.getString(5));
						amortizaFondeo.setSaldoInsoluto(resultadosStore.getString(6));
						amortizaFondeo.setDias(resultadosStore.getString(7));
						amortizaFondeo.setCapitalInteres(resultadosStore.getString(8));
						amortizaFondeo.setCuotasCapital(resultadosStore.getString(9));
						amortizaFondeo.setCuotasInteres(resultadosStore.getString(10));
						amortizaFondeo.setNumTransaccion(resultadosStore.getString(11));
						amortizaFondeo.setFecUltAmor(resultadosStore.getString(12));
						amortizaFondeo.setFecInicioAmor(resultadosStore.getString(13));
						amortizaFondeo.setMontoCuota(resultadosStore.getString(14));
						amortizaFondeo.setInteres(resultadosStore.getString(15));
						amortizaFondeo.setIvaInteres(resultadosStore.getString(16));
						amortizaFondeo.setRetencion(resultadosStore.getString(17));
						amortizaFondeo.setTotalPago(resultadosStore.getString(18));
						matches2.add(amortizaFondeo);
					}
				}
				return matches2;
			}
		});
		CreditoFondeoBean creditoFondeo = new  CreditoFondeoBean();
		creditoFondeo.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		bajaEnTemporalSimuladorFondeo(creditoFondeo);
		return matches;
	}

	/* SIMULADOR DE PAGOS LIBRES CON TASA FIJA SOLO MUESTRA LAS FECHAS */
	public List simPagLibresFondeo(final CreditoFondeoBean creditoFondeoBean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONPAGLIBAMORPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setInt("Par_Frecu",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadCap()));
				sentenciaStore.setInt("Par_FrecuInt",Utileria.convierteEntero(creditoFondeoBean.getPeriodicidadInt()));
				sentenciaStore.setString("Par_PagoCuota",creditoFondeoBean.getFrecuenciaCap());
				sentenciaStore.setString("Par_PagoInter",creditoFondeoBean.getFrecuenciaInt());
				sentenciaStore.setString("Par_PagoFinAni",creditoFondeoBean.getDiaPagoCapital());
				sentenciaStore.setString("Par_PagoFinAniInt",creditoFondeoBean.getDiaPagoInteres());
				sentenciaStore.setString("Par_FechaInicio",(creditoFondeoBean.getFechaInicio()));
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(creditoFondeoBean.getNumAmortizacion()));
				sentenciaStore.setString("Par_DiaHabilSig",creditoFondeoBean.getFechaInhabil());
				sentenciaStore.setString("Par_AjustaFecAmo",creditoFondeoBean.getAjusFecUlVenAmo());
				sentenciaStore.setString("Par_AjusFecExiVen",creditoFondeoBean.getAjusFecExiVen());
				sentenciaStore.setInt("Par_DiaMesInt",Utileria.convierteEntero(creditoFondeoBean.getDiaMesInteres()));
				sentenciaStore.setInt("Par_DiaMesCap",Utileria.convierteEntero(creditoFondeoBean.getDiaMesCapital()));
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
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						AmortizaFondeoBean	amortizaFondeo	=new AmortizaFondeoBean();
						amortizaFondeo.setAmortizacionID(resultadosStore.getString(1));
						amortizaFondeo.setFechaInicio(resultadosStore.getString(2));
						amortizaFondeo.setFechaVencim(resultadosStore.getString(3));
						amortizaFondeo.setFechaExigible(resultadosStore.getString(4));
						amortizaFondeo.setCapital(resultadosStore.getString(5));
						amortizaFondeo.setInteres(resultadosStore.getString(6));
						amortizaFondeo.setIvaInteres(resultadosStore.getString(7));
						amortizaFondeo.setTotalPago(resultadosStore.getString(8));
						amortizaFondeo.setSaldoInsoluto(resultadosStore.getString(9));
						amortizaFondeo.setDias(resultadosStore.getString(10));
						amortizaFondeo.setCapitalInteres(resultadosStore.getString(11));
						amortizaFondeo.setCuotasCapital(resultadosStore.getString(12));
						amortizaFondeo.setCuotasInteres(resultadosStore.getString(13));
						amortizaFondeo.setNumTransaccion(resultadosStore.getString(14));
						amortizaFondeo.setFecUltAmor(resultadosStore.getString(15));
						amortizaFondeo.setFecInicioAmor(resultadosStore.getString(16));
						matches2.add(amortizaFondeo);
					}
				}
				return matches2;
			}
		});
		return matches;
	}

	/* Modificacion de  Linea Fondeador*/
	public List recalculoSimPagLibresFondeo(final CreditoFondeoBean creditoFondeoBean) {
		//transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call FONRECPAGLIBPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditoFondeoBean.getMonto()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(creditoFondeoBean.getTasaFija()));
				sentenciaStore.setString("Par_PagaIVA",creditoFondeoBean.getPagaIva());
				sentenciaStore.setDouble("Par_IVA",Utileria.convierteDoble(creditoFondeoBean.getIva()));
				sentenciaStore.setDouble("Par_ComAnualLin", Constantes.ENTERO_CERO);
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
						AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
						amortizaFondeoBean.setAmortizacionID(resultadosStore.getString(1));
						amortizaFondeoBean.setFechaInicio(resultadosStore.getString(2));
						amortizaFondeoBean.setFechaVencim(resultadosStore.getString(3));
						amortizaFondeoBean.setFechaExigible(resultadosStore.getString(4));
						amortizaFondeoBean.setCapital(resultadosStore.getString(5));
						amortizaFondeoBean.setInteres(resultadosStore.getString(6));
						amortizaFondeoBean.setIvaInteres(resultadosStore.getString(7));
						amortizaFondeoBean.setTotalPago(resultadosStore.getString(8));
						amortizaFondeoBean.setSaldoInsoluto(resultadosStore.getString(9));
						amortizaFondeoBean.setDias(resultadosStore.getString(10));
						amortizaFondeoBean.setCapitalInteres(resultadosStore.getString(11));
						amortizaFondeoBean.setNumTransaccion(resultadosStore.getString(12));
						amortizaFondeoBean.setCuotasCapital(resultadosStore.getString(13));
						amortizaFondeoBean.setCuotasInteres(resultadosStore.getString(14));
						amortizaFondeoBean.setFechaVencimiento(resultadosStore.getString("Par_FechaVenc"));
						matches2.add(amortizaFondeoBean);
					}
				}
				return matches2;
			}
		});
		return matches;
	}

	/* consulta de amortizaciones temporales   TEMPPAGAMORSIM*/
	public List conTempPagAmortFondeo(CreditoFondeoBean creditoFondeoBean,int tipoLista) {
		//Query con el Store Procedure
		String query = "call TMPPAGAMORSIMLIS(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				creditoFondeoBean.getNumTransacSim(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CreditosDAO.ConTempPagAmort",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.STRING_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPAGAMORSIMLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
				try {
				amortizaFondeoBean.setAmortizacionID(String.valueOf(resultSet.getInt(1)));
				amortizaFondeoBean.setFechaInicio(resultSet.getString(2));
				amortizaFondeoBean.setFechaVencim(resultSet.getString(3));
				amortizaFondeoBean.setFechaExigible(resultSet.getString(4));
				amortizaFondeoBean.setCapital(resultSet.getString(5));
				amortizaFondeoBean.setInteres(resultSet.getString(6));
				amortizaFondeoBean.setIvaInteres(resultSet.getString(7));
				amortizaFondeoBean.setTotalPago(resultSet.getString(8));
				amortizaFondeoBean.setSaldoInsoluto(resultSet.getString(9));
				amortizaFondeoBean.setCuotasCapital(resultSet.getString(10));
				amortizaFondeoBean.setCapitalInteres(resultSet.getString(11));
				amortizaFondeoBean.setNumTransaccion(resultSet.getString(12));
				}catch(Exception ex) {
					ex.printStackTrace();
				}
				return amortizaFondeoBean;
			}
		});
		return matches;
	}


	//para grabar los montos de capital para generar el simulador de pagos libres de credito de fondeo
	public MensajeTransaccionBean grabaListaSimPagLibFondeo(final CreditoFondeoBean creditoFondeoBean, final List<AmortizaFondeoBean> listaSimPagLib, final int tipoActualizacion,final String diaHabil) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				List listaCreditosSimPagLib = null;
				try {
					AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
					amortizaFondeoBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					if (tipoActualizacion == Enum_Sim_PagAmortizacionesFondeo.actPagLibFecCap){
						transaccionDAO.generaNumeroTransaccion();
						creditoFondeoBean.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						creditoFondeoBean.setNumTransaccion(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					}
					for (int i = 0; i < listaSimPagLib.size(); i++) {
						amortizaFondeoBean = listaSimPagLib.get(i);
						if (tipoActualizacion == Enum_Sim_PagAmortizacionesFondeo.actPagLib ){
							mensajeBean = amortizaFondeoDAO.actualizacionSimuladorCapitalFondeo(amortizaFondeoBean);
						}else{
							mensajeBean = amortizaFondeoDAO.altaSimuladorFechaCapitalFondeo(amortizaFondeoBean, diaHabil);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en grabacion de los montos del capital fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// reporte de vencimientos pasivos 2013-01-20
	public List consultaRepVencimientosPasivos(final CreditoFondeoBean creditosBean, int tipoLista){
		List ListaResultado=null;
		try{
		String query = "call CARPASVENCIMREP(?,?,?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(creditosBean.getFechaInicio()),
							Utileria.convierteFecha(creditosBean.getFechaVencimien()),
							Utileria.convierteEntero(creditosBean.getInstitutFondID()),
							creditosBean.getCalculoInteres(),



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
				RepVencimiPasBean repVencimiBean= new RepVencimiPasBean();
				//CreditoID	ClienteID	NombreCompleto	MontoCredito	FechaInicio
				repVencimiBean.setInstitucionFondeo(resultSet.getString("NombreInstitucion"));
				repVencimiBean.setCreditoID(resultSet.getString("CreditoFondeoID"));

				repVencimiBean.setMontoCredito(resultSet.getString("Monto"));
				repVencimiBean.setFechaInicio(resultSet.getString("FechaInicio"));
				repVencimiBean.setFechaVencimien(resultSet.getString("FechaVencimien"));
				repVencimiBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
				repVencimiBean.setEstatus(resultSet.getString("EstatusCredito"));
				repVencimiBean.setFechaVencim(resultSet.getString("FechaExigible"));
				repVencimiBean.setCapital(resultSet.getString("Capital"));
				repVencimiBean.setInteres(resultSet.getString("InteresGenerado"));
				repVencimiBean.setMoratorios(resultSet.getString("Moratorios"));
				repVencimiBean.setComisiones(resultSet.getString("Comisiones"));
				//Cargos	AmortizacionID	IVATotal
				repVencimiBean.setCargos(resultSet.getString("Cargos"));
				repVencimiBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				repVencimiBean.setIVATotal(resultSet.getString("IVA"));
				repVencimiBean.setISR(resultSet.getString("Retencion"));
				// 	ProductoCreditoID
				repVencimiBean.setTotalCuota(resultSet.getString("TotCuota"));
				repVencimiBean.setCapitalP(resultSet.getString("CapitalPagado"));
				repVencimiBean.setInteresP(resultSet.getString("InteresPagado"));
				repVencimiBean.setISRR(resultSet.getString("ISRRetenido"));

				repVencimiBean.setMoratorioPagado(resultSet.getString("MoraComPagado"));
				repVencimiBean.setIvaPagado(resultSet.getString("IVAPagado"));

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
				repVencimiBean.setInstitutFondID(resultSet.getString("InstitutFondID"));
				repVencimiBean.setHora(resultSet.getString("HoraEmision"));
				repVencimiBean.setNomMoneda(resultSet.getString("NomMoneda"));
				repVencimiBean.setValorDivisa(resultSet.getString("ValorDivisa"));
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

	public List consultaRepAnaliticoCarteraPas(final CreditoFondeoBean creditosBean, int tipoLista) {
		List ListaResultado = null;
		try {
			String query = "call ANALITICOFONDEOREP(?,?, ?,?,?,?,?,?,?)";

			Object[] parametros = {Utileria.convierteFecha(creditosBean.getFechaACP()), Utileria.convierteEntero(creditosBean.getInstitutFondID()),

			parametrosAuditoriaBean.getEmpresaID(), parametrosAuditoriaBean.getUsuario(), parametrosAuditoriaBean.getFecha(), parametrosAuditoriaBean.getDireccionIP(), parametrosAuditoriaBean.getNombrePrograma(), parametrosAuditoriaBean.getSucursal(), Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call ANALITICOFONDEOREP(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RepAnaliticoCarteraPasBean repAnaliticoCarteraPas = new RepAnaliticoCarteraPasBean();

					repAnaliticoCarteraPas.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
					repAnaliticoCarteraPas.setInstitutFondID(resultSet.getString("InstitutFondID"));
					repAnaliticoCarteraPas.setNombreInstitFon(resultSet.getString("NombreInstitFon"));
					repAnaliticoCarteraPas.setLineaFondeoID(resultSet.getString("LineaFondeoID"));
					repAnaliticoCarteraPas.setDescripLinea(resultSet.getString("DescripLinea"));
					repAnaliticoCarteraPas.setMonedaID(resultSet.getString("MonedaID"));
					repAnaliticoCarteraPas.setEstatusCredito(resultSet.getString("EstatusCredito"));
					repAnaliticoCarteraPas.setMontoCredito(resultSet.getString("MontoCredito"));
					repAnaliticoCarteraPas.setNumAmortizacion(resultSet.getString("NumAmortizacion"));
					repAnaliticoCarteraPas.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
					repAnaliticoCarteraPas.setSaldoCapAtras(resultSet.getString("SaldoCapAtrasad"));
					repAnaliticoCarteraPas.setSaldoInteresPro(resultSet.getString("SaldoInteresPro"));
					repAnaliticoCarteraPas.setSaldoInteresAtra(resultSet.getString("SaldoInteresAtra"));
					repAnaliticoCarteraPas.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					repAnaliticoCarteraPas.setSaldoComFaltaPa(resultSet.getString("SaldoComFaltaPa"));
					repAnaliticoCarteraPas.setSaldoOtrasCom(resultSet.getString("SaldoOtrasComis"));
					repAnaliticoCarteraPas.setSalIVAInteres(resultSet.getString("SalIVAInteres"));
					repAnaliticoCarteraPas.setSalIVAMoratorios(resultSet.getString("SalIVAMoratorios"));
					repAnaliticoCarteraPas.setSalIVAComFalPago(resultSet.getString("SalIVAComFalPago"));
					repAnaliticoCarteraPas.setSalIVACom(resultSet.getString("SalIVAComisi"));
					repAnaliticoCarteraPas.setSalRetencion(resultSet.getString("SalRetencion"));
					repAnaliticoCarteraPas.setPasoCapAtraDia(resultSet.getString("PasoCapAtraDia"));
					repAnaliticoCarteraPas.setPasoIntAtraDia(resultSet.getString("PasoIntAtraDia"));
					repAnaliticoCarteraPas.setIntOrdDevengado(resultSet.getString("IntOrdDevengado"));
					repAnaliticoCarteraPas.setIntMorDevengado(resultSet.getString("IntMorDevengado"));
					repAnaliticoCarteraPas.setComisiDevengado(resultSet.getString("ComisiDevengado"));
					repAnaliticoCarteraPas.setPagoCapVigDia(resultSet.getString("PagoCapVigDia"));
					repAnaliticoCarteraPas.setPagoCapAtrDia(resultSet.getString("PagoCapAtrDia"));
					repAnaliticoCarteraPas.setPagoIntOrdDia(resultSet.getString("PagoIntOrdDia"));
					repAnaliticoCarteraPas.setPagoIntAtrDia(resultSet.getString("PagoIntAtrDia"));
					repAnaliticoCarteraPas.setPagoComisiDia(resultSet.getString("PagoComisiDia"));
					repAnaliticoCarteraPas.setPagoMoratorios(resultSet.getString("PagoMoratorios"));
					repAnaliticoCarteraPas.setPagoIvaDia(resultSet.getString("PagoIvaDia"));
					repAnaliticoCarteraPas.setISRDelDia(resultSet.getString("ISRDelDia"));
					repAnaliticoCarteraPas.setDiasAtraso(resultSet.getString("DiasAtraso"));
					repAnaliticoCarteraPas.setHoraEmision(resultSet.getString("HoraEmision"));

					repAnaliticoCarteraPas.setCreditoID(resultSet.getString("CreditoID"));
					repAnaliticoCarteraPas.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repAnaliticoCarteraPas.setFechaMinistrado(resultSet.getString("FechaMinistrado"));
					repAnaliticoCarteraPas.setFechaProxPag(resultSet.getString("FechaProxPag"));
					repAnaliticoCarteraPas.setMontoProx(resultSet.getString("MontoProx"));
					repAnaliticoCarteraPas.setFechaUltVenc(resultSet.getString("FechaUltVenc"));
					repAnaliticoCarteraPas.setTasaFija(resultSet.getString("TasaFija"));
					repAnaliticoCarteraPas.setNumSocios(resultSet.getString("NumSocios"));
					repAnaliticoCarteraPas.setManejaCarteraAgro(resultSet.getString("ManejaCarteraAgro"));
					repAnaliticoCarteraPas.setValoMoneda(resultSet.getString("TipCamDof"));
					repAnaliticoCarteraPas.setDescMoneda(resultSet.getString("DesMoneda"));

					return repAnaliticoCarteraPas;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reporte de analitico cartera pasiva", e);
		}
		return ListaResultado;
	}

	public List consultaRepCreditoFondeoMovs(final CreditoFondeoBean creditosBean, int tipoLista) {
		List ListaResultado = null;
		try {
			String query = "call CREDITOFONDMOVSREP(?,?, ?,?,?,?,?,?,?)";

			Object[] parametros = {creditosBean.getCreditoFondeoID(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDITOFONDMOVSREP(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CreditoFondeoBean creditoFondeoBean = new CreditoFondeoBean();
					creditoFondeoBean.setNumAmortizacion(resultSet.getString("AmortizacionID"));
					creditoFondeoBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
					creditoFondeoBean.setDescripcion(resultSet.getString("Descripcion"));
					creditoFondeoBean.setDescripTipMov(resultSet.getString("DescripTipMov"));
					creditoFondeoBean.setNatMovimientoDes(resultSet.getString("NatMovimientoDes"));
					creditoFondeoBean.setCantidad(resultSet.getString("Cantidad"));

					return creditoFondeoBean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reporte de analitico cartera pasiva", e);
		}
		return ListaResultado;
	}

/* lista creditos de fondeo vigentes para ws*/
public List creditosFondeo(ListaCreditoFondeoBERequest listaCreditoFondeoBERequest,int tipoLista) {
	//Query con el Store Procedure
	String query = "call CREDITOFONDEOLIS(" +
			"?,?,?,?,   ?,?,?,?,?,?,?);";
	Object[] parametros = {
			Constantes.STRING_VACIO,
			Constantes.ENTERO_CERO,
			Utileria.convierteEntero(listaCreditoFondeoBERequest.getClienteID()),
			tipoLista,


			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"CreditosDAO.ConTempPagAmort",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.STRING_CERO
	};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOFONDEOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CreditoFondeoBean creditoFondeoBean = new CreditoFondeoBean();
			creditoFondeoBean.setCreditoFondeoID(String.valueOf(resultSet.getLong("CreditoFondeoID")));
			creditoFondeoBean.setFechaTerminaci(resultSet.getString("FecVencim"));
			creditoFondeoBean.setMonto(resultSet.getString("MontoFondeo"));

			return creditoFondeoBean;
		}
	});
	return matches;
}

/* lista de creditos de fondeo pendiente de pago */
public List folioPasFondeo(final CreditoFondeoBean creditoFondeoBean, final int tipoLista){
	transaccionDAO.generaNumeroTransaccion();
	List matches =new  ArrayList();
	final List matches2 =new  ArrayList();
	matches =(List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
		public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
			String query = "call CREDITOFONDEOLIS(" +
					"?,?,?,?,?,?,?, ?,?,?,?);";
			CallableStatement sentenciaStore = arg0.prepareCall(query);

    		sentenciaStore.setString("Par_DesLinFondeo",creditoFondeoBean.getNombreLineaFon());
			sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditoFondeoBean.getLineaFondeoID()));
			sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
			sentenciaStore.setInt("Par_NumLis",tipoLista);
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
			if(callableStatement.execute()){
				ResultSet resultadosStore = callableStatement.getResultSet();
				while (resultadosStore.next()) {
					CreditoFondeoBean	creditoFondeo	=new CreditoFondeoBean();
					creditoFondeo.setCreditoFondeoID(resultadosStore.getString("CreditoFondeoID"));
					creditoFondeo.setFolio(resultadosStore.getString("Folio"));
					creditoFondeo.setNombreInstitFon(resultadosStore.getString("NombreInstitFon"));
					matches2.add(creditoFondeo);
				}
			}
			return matches2;
		}
	});
	return matches;
}



	public AmortizaFondeoDAO getAmortizaFondeoDAO() {
		return amortizaFondeoDAO;
	}

	public void setAmortizaFondeoDAO(AmortizaFondeoDAO amortizaFondeoDAO) {
		this.amortizaFondeoDAO = amortizaFondeoDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}