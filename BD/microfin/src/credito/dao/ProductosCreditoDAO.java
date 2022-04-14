package credito.dao;
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

import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ListaProdCreditoRequest;

public class ProductosCreditoDAO extends BaseDAO {

	public ProductosCreditoDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	public MensajeTransaccionBean alta(final ProductosCreditoBean productosCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PRODUCTOSCREDITOALT("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,? 	," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?,?,?	," +
										"?,?,?,?);";
								
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(productosCredito.getProducCreditoID()));
								sentenciaStore.setString("Par_Descripcion", productosCredito.getDescripcion());
								sentenciaStore.setString("Par_Caracteristicas", productosCredito.getCaracteristicas());
								sentenciaStore.setString("Par_CobraIVAInteres", productosCredito.getCobraIVAInteres());
								sentenciaStore.setString("Par_CobraIVAMora", productosCredito.getCobraIVAMora());

								sentenciaStore.setString("Par_CobraFaltaPago", productosCredito.getCobraFaltaPago());
								sentenciaStore.setString("Par_CobraMora", productosCredito.getCobraMora());
								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(productosCredito.getFactorMora()));
								sentenciaStore.setString("Par_TipoPersona",productosCredito.getTipoPersona());
								sentenciaStore.setString("Par_ManejaLinea",productosCredito.getManejaLinea());

								sentenciaStore.setString( "Par_ReqObligadosSolidarios" ,productosCredito.getRequiereObligadosSolidarios() );
								sentenciaStore.setString( "Par_PerObligadosCruzados" ,productosCredito.getPermObligadosCruzados() );
								sentenciaStore.setString("Par_ReqConsultaSIC",productosCredito.getReqConsultaSIC());


								sentenciaStore.setString("Par_EsRevolvente",productosCredito.getEsRevolvente());
								sentenciaStore.setString("Par_EsGrupal",productosCredito.getEsGrupal());
								sentenciaStore.setString("Par_RequiereGarantia",productosCredito.getRequiereGarantia());
								sentenciaStore.setString("Par_RequiereAvales",productosCredito.getRequiereAvales());
								sentenciaStore.setInt("Par_GraciaFaltaPago",Utileria.convierteEntero(productosCredito.getGraciaFaltaPago()));

								sentenciaStore.setInt("Par_GraciaMoratorios", Utileria.convierteEntero(productosCredito.getGraciaMoratorios()) );
								sentenciaStore.setDouble("Par_MontoMinimo", Utileria.convierteDoble(productosCredito.getMontoMinimo()));
								sentenciaStore.setDouble("Par_MontoMaximo", Utileria.convierteDoble(productosCredito.getMontoMaximo()));
								sentenciaStore.setInt("Par_DiasSuspesion", Utileria.convierteEntero(productosCredito.getDiasSuspesion()));
								sentenciaStore.setString("Par_EsReestructura", productosCredito.getEsReestructura());

								sentenciaStore.setString("Par_EsAutomatico" ,productosCredito.getEsAutomatico());
								sentenciaStore.setInt("Par_Clasificacion" ,Utileria.convierteEntero(productosCredito.getClasificacion()));
								sentenciaStore.setInt("Par_MargenPagIgual" ,Utileria.convierteEntero(productosCredito.getMargenPagIgual()));
								sentenciaStore.setString("Par_TipComXaper" ,productosCredito.getTipoComXapert());
								sentenciaStore.setDouble("Par_MonComXaper" ,Utileria.convierteDoble(productosCredito.getMontoComXapert()));

								sentenciaStore.setString("Par_AhoVoluntario" ,productosCredito.getAhoVoluntario());
								sentenciaStore.setDouble("Par_PorcAhoVol" ,Utileria.convierteDoble(productosCredito.getPorAhoVol()));
								sentenciaStore.setString("Par_Tipo" ,productosCredito.getTipo());
								sentenciaStore.setString("Par_FormaComAper" ,productosCredito.getFormaComApertura());
								sentenciaStore.setString("Par_CalcInter" ,productosCredito.getCalcInteres());

								sentenciaStore.setString("Par_TipoContratoBC" ,productosCredito.getTipoContratoBCID());
								sentenciaStore.setInt("Par_TipoCalInt" ,Utileria.convierteEntero(productosCredito.getTipoCalInteres()));
								sentenciaStore.setString("Par_TipoGeneraInteres" , productosCredito.getTipoGeneraInteres());
								sentenciaStore.setInt("Par_InstitutFondID" ,Utileria.convierteEntero(productosCredito.getInstitutFondID()));
								sentenciaStore.setInt("Par_MaxIntegrantes" ,Utileria.convierteEntero(productosCredito.getMaxIntegrantes()));
								sentenciaStore.setInt("Par_MinIntegrantes" ,Utileria.convierteEntero(productosCredito.getMinIntegrantes()));

								sentenciaStore.setString("Par_PerRomGrup" ,productosCredito.getPerRompimGrup());
								sentenciaStore.setInt("Par_RIniCicGrup" ,Utileria.convierteEntero(productosCredito.getRaIniCicloGrup()));
								sentenciaStore.setInt("Par_RFinCicGrup" ,Utileria.convierteEntero(productosCredito.getRaFinCicloGrup()));
								sentenciaStore.setDouble("Par_RelGaraCred" ,Utileria.convierteDoble(productosCredito.getRelGarantCred()));
								sentenciaStore.setString("Par_PerAvaCruz" ,productosCredito.getPerAvaCruzados());

								sentenciaStore.setString("Par_PerGarCruz" ,productosCredito.getPerGarCruzadas() );
								sentenciaStore.setString("Par_RegRECA" ,productosCredito.getRegistroRECA() );
								sentenciaStore.setDate( "Par_FechaIns" ,OperacionesFechas.conversionStrDate(productosCredito.getFechaInscripcion()) );
								sentenciaStore.setString( "Par_NomCom" ,productosCredito.getNombreComercial() );
								sentenciaStore.setString( "Par_TipoCred" ,productosCredito.getTipoCredito() );

								sentenciaStore.setInt( "Par_MinMujSol" ,Utileria.convierteEntero(productosCredito.getMinMujeresSol()) );
								sentenciaStore.setInt( "Par_MaxMujSol" ,Utileria.convierteEntero(productosCredito.getMaxMujeresSol()) );
								sentenciaStore.setInt( "Par_MinMuj" ,Utileria.convierteEntero(productosCredito.getMinMujeres()) );
								sentenciaStore.setInt( "Par_MaxMuj" ,Utileria.convierteEntero(productosCredito.getMaxMujeres()) );
								sentenciaStore.setInt( "Par_MinHom" ,Utileria.convierteEntero(productosCredito.getMinHombres()) );

								sentenciaStore.setInt( "Par_MaxHom" ,Utileria.convierteEntero(productosCredito.getMaxHombres()) );
								sentenciaStore.setString( "Par_TasPonGru" ,productosCredito.getTasaPonderaGru() );
								sentenciaStore.setString( "Par_reqSeguroVida" ,productosCredito.getReqSeguroVida() );
								sentenciaStore.setDouble( "Par_factorRiesgoSeg" ,Utileria.convierteDoble(productosCredito.getFactorRiesgoSeguro()) );
								sentenciaStore.setString( "Par_tipoPagoSeguro" ,productosCredito.getTipoPagoSeguro() );

								sentenciaStore.setDouble( "Par_descuentoSeguro" ,Utileria.convierteDoble(productosCredito.getDescuentoSeguro()) );
								sentenciaStore.setDouble( "Par_montoPolSegVida" ,Utileria.convierteDoble(productosCredito.getMontoPolSegVida()) );
								sentenciaStore.setString( "Par_TipCobComMorato" ,(productosCredito.getTipCobComMorato()) );
								sentenciaStore.setDouble( "Par_DiasPasoAtraso" ,Utileria.convierteDoble(productosCredito.getDiasPasoAtraso()) );
								sentenciaStore.setString( "Par_ValidaCapConta" ,productosCredito.getValidaCapConta() );

								sentenciaStore.setDouble( "Par_PorcMaxCapConta" ,Utileria.convierteDoble(productosCredito.getPorcMaxCapConta()) );
								sentenciaStore.setString( "Par_ProrrateoPago" ,(productosCredito.getProrrateoPago()) );
								sentenciaStore.setString( "Par_ProyInteresPagAde" ,(productosCredito.getProyInteresPagAde()) );
								sentenciaStore.setString( "Par_PermitePrepago" ,productosCredito.getPermitePrepago() );
								sentenciaStore.setString( "Par_ProductoNomina" ,productosCredito.getProductoNomina() );

								sentenciaStore.setString( "Par_ModificarPrepago",productosCredito.getModificarPrepago() );
								sentenciaStore.setString( "Par_TipoPrepago" ,productosCredito.getTipoPrepago() );
								sentenciaStore.setString( "Par_AutorizaComite" ,productosCredito.getAutorizaComite() );
								sentenciaStore.setString( "Par_TipoContratoCCID" ,productosCredito.getTipoContratoCCID() );
								sentenciaStore.setString( "Par_CalculoRatios" ,productosCredito.getCalculoRatios() );

								sentenciaStore.setString( "Par_AfectaContable" ,productosCredito.getAfectacionContable() );
								sentenciaStore.setString( "Par_InicioAfuturo" ,productosCredito.getInicioAfuturo() );
								sentenciaStore.setInt( "Par_DiasMaximo" ,Utileria.convierteEntero(productosCredito.getDiasMaximo()) );
								sentenciaStore.setString( "Par_Modalidad" ,productosCredito.getModalidad() );
								sentenciaStore.setInt( "Par_CantidadAvales" ,Utileria.convierteEntero(productosCredito.getCantidadAvales()) );

								sentenciaStore.setString( "Par_IntercambiaAvales" ,productosCredito.getIntercambioAvalesRatio() );
								sentenciaStore.setString( "Par_PermiteAutSolPros" ,productosCredito.getPermiteAutSolPros());
								sentenciaStore.setString( "Par_RequiereReferencias" ,productosCredito.getRequiereReferencias());
								sentenciaStore.setInt( "Par_MinReferencias" ,Utileria.convierteEntero(productosCredito.getMinReferencias()));
								sentenciaStore.setString( "Par_CobraSeguroCuota" ,productosCredito.getCobraSeguroCuota());

								sentenciaStore.setString( "Par_CobraIVASeguroCuota" ,productosCredito.getCobraIVASeguroCuota());
								sentenciaStore.setString( "Par_ClaveRiesgo" ,productosCredito.getClaveRiesgo());
								sentenciaStore.setString( "Par_ClaveCNBV" ,productosCredito.getClaveCNBV());
								sentenciaStore.setString("Par_RequiereCheckList" ,productosCredito.getRequiereCheckList());
								sentenciaStore.setString("Par_PermiteConsolidacion" ,productosCredito.getPermiteConsolidacion());
								sentenciaStore.setString("Par_InstruDispersion" ,productosCredito.getInstruDispersion());

								sentenciaStore.setString("Par_TipoAutomatico" ,productosCredito.getTipoAutomatico());

								sentenciaStore.setDouble("Par_PorcMaximo" ,Utileria.convierteDoble(productosCredito.getPorcMaximo()));
								sentenciaStore.setString("Par_FinanciamientoRural" ,productosCredito.getFinanciamientoRural());
								sentenciaStore.setString("Par_ParticipaSpei" ,productosCredito.getParticipaSpei());
								sentenciaStore.setString("Par_ProductoClabe" ,productosCredito.getProductoClabe());
								sentenciaStore.setInt("Par_DiasAtrasoMin" ,Utileria.convierteEntero(productosCredito.getDiasAtrasoMin()));

								sentenciaStore.setString("Par_CobraAccesorios",productosCredito.getCobraAccesorios());
								sentenciaStore.setString("Par_CobraComAnual", productosCredito.getCobraComAnual());
								sentenciaStore.setString("Par_TipoComAnual", productosCredito.getTipoComAnual());
								sentenciaStore.setDouble("Par_ValorComAnual", Utileria.convierteDoble(productosCredito.getValorComAnual()));
								sentenciaStore.setString("Par_RequiereAnalisiCre", productosCredito.getRequiereAnalisiCre());

								sentenciaStore.setString("Par_ReqConsolidacionAgro", productosCredito.getReqConsolidacionAgro());
								sentenciaStore.setString("Par_FechaDesembolso", productosCredito.getFechaDesembolso());
								sentenciaStore.setString("Par_ValidaConyuge", productosCredito.getValidacionConyuge());
								
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
								loggerSAFI.info(sentenciaStore.toString());
								return sentenciaStore;
								} catch(Exception ex){
									ex.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}

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
					loggerSAFI.error("error en alta de Producto de Crédito", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	/**
	 * Metodo de alta de productos de crédito Agro. Se registra desde el método de alta y después se actualizan los campos de productos
	 * Agro.
	 * @param productoCredBean : Clase bean con los valores de los parámetros de entrada a los SPS PRODUCTOSCREDITOALT y PRODUCTOSCREDITOACT.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean altaProdAgro(final ProductosCreditoBean productoCredBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = alta(productoCredBean);
					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					int TipoAgro = 3;
					String productoCredID = productoCredBean.getProducCreditoID();

					mensajeBean = actualizar(productoCredBean, TipoAgro);
					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion("Producto de Credito Agro Agregado Exitosamente: "+productoCredID);

				} catch (Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("error en alta de Producto de Crédito Agro: ", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final ProductosCreditoBean productosCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PRODUCTOSCREDITOMOD("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,? 	," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?,?,?	," +
										"?,?,?,?,?);";


								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(productosCredito.getProducCreditoID()));
								sentenciaStore.setString("Par_Descripcion", productosCredito.getDescripcion());
								sentenciaStore.setString("Par_Caracteristicas", productosCredito.getCaracteristicas());
								sentenciaStore.setString("Par_CobraIVAInteres", productosCredito.getCobraIVAInteres());
								sentenciaStore.setString("Par_CobraIVAMora", productosCredito.getCobraIVAMora());

								sentenciaStore.setString( "Par_ReqObligadosSolidarios" ,productosCredito.getRequiereObligadosSolidarios() );
								sentenciaStore.setString( "Par_PerObligadosCruzados" ,productosCredito.getPermObligadosCruzados() );
								sentenciaStore.setString("Par_ReqConsultaSIC",productosCredito.getReqConsultaSIC());
								sentenciaStore.setString("Par_CobraFaltaPago", productosCredito.getCobraFaltaPago());
								sentenciaStore.setString("Par_CobraMora", productosCredito.getCobraMora());

								sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(productosCredito.getFactorMora()));
								sentenciaStore.setString("Par_TipoPersona",productosCredito.getTipoPersona());
								sentenciaStore.setString("Par_ManejaLinea",productosCredito.getManejaLinea());
								sentenciaStore.setString("Par_EsRevolvente",productosCredito.getEsRevolvente());
								sentenciaStore.setString("Par_EsGrupal",productosCredito.getEsGrupal());

								sentenciaStore.setString("Par_RequiereGarantia",productosCredito.getRequiereGarantia());
								sentenciaStore.setString("Par_RequiereAvales",productosCredito.getRequiereAvales());
								sentenciaStore.setInt("Par_GraciaFaltaPago",Utileria.convierteEntero(productosCredito.getGraciaFaltaPago()));
								sentenciaStore.setInt("Par_GraciaMoratorios", Utileria.convierteEntero(productosCredito.getGraciaMoratorios()) );
								sentenciaStore.setDouble("Par_MontoMinimo", Utileria.convierteDoble(productosCredito.getMontoMinimo()));

								sentenciaStore.setDouble("Par_MontoMaximo", Utileria.convierteDoble(productosCredito.getMontoMaximo()));
								sentenciaStore.setInt("Par_DiasSuspesion", Utileria.convierteEntero(productosCredito.getDiasSuspesion()));
								sentenciaStore.setString("Par_EsReestructura", productosCredito.getEsReestructura());
								sentenciaStore.setString("Par_EsAutomatico" ,productosCredito.getEsAutomatico());
								sentenciaStore.setInt("Par_Clasificacion" ,Utileria.convierteEntero(productosCredito.getClasificacion()));

								sentenciaStore.setInt("Par_MargenPagIgual" ,Utileria.convierteEntero(productosCredito.getMargenPagIgual()));
								sentenciaStore.setString("Par_TipComXaper" ,productosCredito.getTipoComXapert());
								sentenciaStore.setDouble("Par_MonComXaper" ,Utileria.convierteDoble(productosCredito.getMontoComXapert()));
								sentenciaStore.setString("Par_AhoVoluntario" ,productosCredito.getAhoVoluntario());
								sentenciaStore.setDouble("Par_PorcAhoVol" ,Utileria.convierteDoble(productosCredito.getPorAhoVol()));

								sentenciaStore.setString("Par_Tipo" ,productosCredito.getTipo());
								sentenciaStore.setString("Par_FormaComAper" ,productosCredito.getFormaComApertura());
								sentenciaStore.setString("Par_CalcInter" ,productosCredito.getCalcInteres());
								sentenciaStore.setString("Par_TipoContratoBC" ,productosCredito.getTipoContratoBCID());
								sentenciaStore.setInt("Par_TipoCalInt" ,Utileria.convierteEntero(productosCredito.getTipoCalInteres()));
								sentenciaStore.setString("Par_TipoGeneraInteres" , productosCredito.getTipoGeneraInteres());

								sentenciaStore.setInt("Par_InstitutFondID" ,Utileria.convierteEntero(productosCredito.getInstitutFondID()));
								sentenciaStore.setInt("Par_MaxIntegrantes" ,Utileria.convierteEntero(productosCredito.getMaxIntegrantes()));
								sentenciaStore.setInt("Par_MinIntegrantes" ,Utileria.convierteEntero(productosCredito.getMinIntegrantes()));
								sentenciaStore.setString("Par_PerRomGrup" ,productosCredito.getPerRompimGrup());
								sentenciaStore.setInt("Par_RIniCicGrup" ,Utileria.convierteEntero(productosCredito.getRaIniCicloGrup()));

								sentenciaStore.setInt("Par_RFinCicGrup" ,Utileria.convierteEntero(productosCredito.getRaFinCicloGrup()));
								sentenciaStore.setDouble("Par_RelGaraCred" ,Utileria.convierteDoble(productosCredito.getRelGarantCred()));
								sentenciaStore.setString("Par_PerAvaCruz" ,productosCredito.getPerAvaCruzados());
								sentenciaStore.setString("Par_PerGarCruz" ,productosCredito.getPerGarCruzadas() );
								sentenciaStore.setString("Par_RegRECA" ,productosCredito.getRegistroRECA() );

								sentenciaStore.setDate( "Par_FechaIns" ,OperacionesFechas.conversionStrDate(productosCredito.getFechaInscripcion()) );
								sentenciaStore.setString( "Par_NomCom" ,productosCredito.getNombreComercial() );
								sentenciaStore.setString( "Par_TipoCred" ,productosCredito.getTipoCredito() );
								sentenciaStore.setInt( "Par_MinMujSol" ,Utileria.convierteEntero(productosCredito.getMinMujeresSol()) );
								sentenciaStore.setInt( "Par_MaxMujSol" ,Utileria.convierteEntero(productosCredito.getMaxMujeresSol()) );

								sentenciaStore.setInt( "Par_MinMuj" ,Utileria.convierteEntero(productosCredito.getMinMujeres()) );
								sentenciaStore.setInt( "Par_MaxMuj" ,Utileria.convierteEntero(productosCredito.getMaxMujeres()) );
								sentenciaStore.setInt( "Par_MinHom" ,Utileria.convierteEntero(productosCredito.getMinHombres()) );
								sentenciaStore.setInt( "Par_MaxHom" ,Utileria.convierteEntero(productosCredito.getMaxHombres()) );
								sentenciaStore.setString( "Par_TasPonGru" ,productosCredito.getTasaPonderaGru() );

								sentenciaStore.setString( "Par_reqSeguroVida" ,productosCredito.getReqSeguroVida() );
								sentenciaStore.setDouble( "Par_factorRiesgoSeg" ,Utileria.convierteDoble(productosCredito.getFactorRiesgoSeguro()) );
								sentenciaStore.setString( "Par_tipoPagoSeguro" ,productosCredito.getTipoPagoSeguro() );
								sentenciaStore.setDouble( "Par_descuentoSeguro" ,Utileria.convierteDoble(productosCredito.getDescuentoSeguro()) );
								sentenciaStore.setDouble( "Par_montoPolSegVida" ,Utileria.convierteDoble(productosCredito.getMontoPolSegVida()) );

								sentenciaStore.setString( "Par_TipCobComMorato" ,(productosCredito.getTipCobComMorato()) );
								sentenciaStore.setDouble( "Par_DiasPasoAtraso" ,Utileria.convierteDoble(productosCredito.getDiasPasoAtraso()) );
								sentenciaStore.setString( "Par_ValidaCapConta" ,productosCredito.getValidaCapConta() );
								sentenciaStore.setDouble( "Par_PorcMaxCapConta" ,Utileria.convierteDoble(productosCredito.getPorcMaxCapConta()) );
								sentenciaStore.setString( "Par_ProrrateoPago" ,(productosCredito.getProrrateoPago()) );

								sentenciaStore.setString( "Par_ProyInteresPagAde" ,(productosCredito.getProyInteresPagAde()) );
								sentenciaStore.setString( "Par_PermitePrepago" ,productosCredito.getPermitePrepago() );
								sentenciaStore.setString( "Par_ProductoNomina" ,productosCredito.getProductoNomina() );
								sentenciaStore.setString( "Par_ModificarPrepago",productosCredito.getModificarPrepago() );
								sentenciaStore.setString( "Par_TipoPrepago" ,productosCredito.getTipoPrepago() );

								sentenciaStore.setString( "Par_AutorizaComite" ,productosCredito.getAutorizaComite() );
								sentenciaStore.setString( "Par_TipoContratoCCID" ,productosCredito.getTipoContratoCCID() );
								sentenciaStore.setString( "Par_CalculoRatios" ,productosCredito.getCalculoRatios() );
								sentenciaStore.setString( "Par_AfectaContable" ,productosCredito.getAfectacionContable() );
								sentenciaStore.setString( "Par_InicioAfuturo" ,productosCredito.getInicioAfuturo() );

								sentenciaStore.setInt( "Par_DiasMaximo" ,Utileria.convierteEntero(productosCredito.getDiasMaximo()) );
								sentenciaStore.setString( "Par_Modalidad" ,productosCredito.getModalidad() );
								sentenciaStore.setString("Par_EsquemaSeguroID", productosCredito.getEsquemaSeguroID());
								sentenciaStore.setInt( "Par_CantidadAvales" ,Utileria.convierteEntero(productosCredito.getCantidadAvales()) );
								sentenciaStore.setString( "Par_IntercambiaAvales" ,productosCredito.getIntercambioAvalesRatio() );

								sentenciaStore.setString( "Par_PermiteAutSolPros" ,productosCredito.getPermiteAutSolPros());
								sentenciaStore.setString( "Par_RequiereReferencias" ,productosCredito.getRequiereReferencias());
								sentenciaStore.setInt( "Par_MinReferencias" ,Utileria.convierteEntero(productosCredito.getMinReferencias()));
								sentenciaStore.setString( "Par_CobraSeguroCuota" ,productosCredito.getCobraSeguroCuota());
								sentenciaStore.setString( "Par_CobraIVASeguroCuota" ,productosCredito.getCobraIVASeguroCuota());

								sentenciaStore.setString("Par_ClaveRiesgo" ,productosCredito.getClaveRiesgo());
								sentenciaStore.setString( "Par_ClaveCNBV" ,productosCredito.getClaveCNBV());
								sentenciaStore.setString("Par_RequiereCheckList" ,productosCredito.getRequiereCheckList());
								sentenciaStore.setString("Par_PermiteConsolidacion" ,productosCredito.getPermiteConsolidacion());
								sentenciaStore.setString("Par_InstruDispersion" ,productosCredito.getInstruDispersion());

								sentenciaStore.setString("Par_TipoAutomatico" ,productosCredito.getTipoAutomatico());
								sentenciaStore.setString("Par_PorcMaximo" ,productosCredito.getPorcMaximo());

								sentenciaStore.setString("Par_FinanciamientoRural" ,productosCredito.getFinanciamientoRural());
								sentenciaStore.setString("Par_ParticipaSpei" ,productosCredito.getParticipaSpei());
								sentenciaStore.setString("Par_ProductoClabe" ,productosCredito.getProductoClabe());
								sentenciaStore.setInt("Par_DiasAtrasoMin" ,Utileria.convierteEntero(productosCredito.getDiasAtrasoMin()));
								sentenciaStore.setString("Par_CobraAccesorios",productosCredito.getCobraAccesorios());

								sentenciaStore.setString("Par_CobraComAnual", productosCredito.getCobraComAnual());
								sentenciaStore.setString("Par_TipoComAnual", productosCredito.getTipoComAnual());
								sentenciaStore.setDouble("Par_ValorComAnual", Utileria.convierteDoble(productosCredito.getValorComAnual()));
								sentenciaStore.setString("Par_RequiereAnalisiCre", productosCredito.getRequiereAnalisiCre());
								sentenciaStore.setString("Par_ReqConsolidacionAgro", productosCredito.getReqConsolidacionAgro());

								sentenciaStore.setString("Par_FechaDesembolso", productosCredito.getFechaDesembolso());
								sentenciaStore.setString("Par_ValidaConyuge", productosCredito.getValidacionConyuge());

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
								}catch(Exception ex){
									ex.printStackTrace();
								}

							    loggerSAFI.info(sentenciaStore.toString());


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
					loggerSAFI.error("error en alta de Producto de Crédito", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	/**
	 * Metodo de modificación de productos de crédito Agro. Se actualiza desde el método de modifica y después se actualizan únicamente
	 * los campos de productos Agro.
	 * @param productoCredBean : Clase bean con los valores de los parámetros de entrada a los SPS PRODUCTOSCREDITOMOD y PRODUCTOSCREDITOACT.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean modificaProdAgro(final ProductosCreditoBean productoCredBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = modifica(productoCredBean);
					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					int TipoAgro = 3;
					String productoCredID = productoCredBean.getProducCreditoID();

					mensajeBean = actualizar(productoCredBean, TipoAgro);
					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setDescripcion("Producto de Credito Agro Modificado Exitosamente: "+productoCredID);

				} catch (Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("error en modificación de Producto de Crédito Agro: ", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//consulta Principal
	public ProductosCreditoBean consultaPrincipal(ProductosCreditoBean productosCredito, int tipoConsulta) {

		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			//Query con el Store Procedure
			String query = "call PRODUCTOSCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ProductosCreditoBean productosCredito = new ProductosCreditoBean();

					productosCredito.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					productosCredito.setDescripcion(resultSet.getString("Descripcion"));
					productosCredito.setCaracteristicas(resultSet.getString("Caracteristicas"));
					productosCredito.setCobraIVAInteres(resultSet.getString("CobraIVAInteres"));
					productosCredito.setCobraIVAMora(resultSet.getString("CobraIVAMora"));
					productosCredito.setCobraFaltaPago(resultSet.getString("CobraFaltaPago"));
					productosCredito.setCobraMora(resultSet.getString("CobraMora"));
					productosCredito.setFactorMora(String.valueOf(resultSet.getDouble("FactorMora")));
					productosCredito.setTipoPersona(resultSet.getString("TipoPersona"));
					productosCredito.setManejaLinea(resultSet.getString("ManejaLinea"));

					productosCredito.setEsRevolvente(resultSet.getString("EsRevolvente"));
					productosCredito.setEsGrupal(resultSet.getString("EsGrupal"));
					productosCredito.setRequiereGarantia(resultSet.getString("RequiereGarantia"));
					productosCredito.setRequiereAvales(resultSet.getString("RequiereAvales"));
					productosCredito.setGraciaFaltaPago(String.valueOf(resultSet.getInt("GraciaFaltaPago")));
					productosCredito.setGraciaMoratorios(String.valueOf(resultSet.getInt("GraciaMoratorios")));
					productosCredito.setGarantizado(resultSet.getString("Garantizado"));
					productosCredito.setMontoMinimo(resultSet.getString("MontoMinimo"));
					productosCredito.setMontoMaximo(resultSet.getString("MontoMaximo"));

					productosCredito.setDiasSuspesion(String.valueOf(resultSet.getInt("DiasSuspesion")));
					productosCredito.setEsReestructura(resultSet.getString("EsReestructura"));
					productosCredito.setEsAutomatico(resultSet.getString("EsAutomatico"));
					productosCredito.setMargenPagIgual(String.valueOf(resultSet.getInt(("MargenPagIgual"))));
					productosCredito.setTipoComXapert(resultSet.getString("TipoComXapert"));
					productosCredito.setMontoComXapert(resultSet.getString("MontoComXapert"));
					productosCredito.setAhoVoluntario(resultSet.getString("AhoVoluntario"));
					productosCredito.setPorAhoVol(String.valueOf(resultSet.getDouble("PorcAhoVol")));
					productosCredito.setClasificacion(String.valueOf(resultSet.getInt("ClasifRegID")));
					productosCredito.setTipo(resultSet.getString("Tipo"));

					productosCredito.setFormaComApertura(resultSet.getString("ForCobroComAper"));
					productosCredito.setCalcInteres(resultSet.getString("CalcInteres"));
					productosCredito.setTipoContratoBCID(resultSet.getString("TipoContratoBCID"));
					productosCredito.setTipoCalInteres(String.valueOf(resultSet.getInt("TipoCalInteres")));
					productosCredito.setTipoGeneraInteres(resultSet.getString("TipoGeneraInteres"));

					productosCredito.setInstitutFondID(String.valueOf(resultSet.getInt("InstitutFondID")));
					productosCredito.setMaxIntegrantes(resultSet.getString("MaxIntegrantes"));
					productosCredito.setMinIntegrantes(resultSet.getString("MinIntegrantes"));
					productosCredito.setPerRompimGrup(resultSet.getString("PerRompimGrup"));
					productosCredito.setRaIniCicloGrup(String.valueOf(resultSet.getInt(("RaIniCicloGrup"))));

					productosCredito.setRaFinCicloGrup(String.valueOf(resultSet.getInt(("RaFinCicloGrup"))));
					productosCredito.setRelGarantCred(String.valueOf(resultSet.getDouble("RelGarantCred")));
					productosCredito.setPerAvaCruzados(resultSet.getString("PerAvaCruzados"));
					productosCredito.setPerGarCruzadas(resultSet.getString("PerGarCruzadas"));
					productosCredito.setCriterioComFalPag(resultSet.getString("CriterioComFalPag"));
					productosCredito.setMontoMinComFalPag(resultSet.getString("MontoMinComFalPag"));
					// parametros de RECA condusef
					productosCredito.setRegistroRECA(resultSet.getString("RegistroRECA"));
					productosCredito.setFechaInscripcion(resultSet.getString("FechaInscripcion"));
					productosCredito.setNombreComercial(resultSet.getString("NombreComercial"));
					productosCredito.setTipoCredito(resultSet.getString("TipoCredito"));
					// parametros de grupales
					productosCredito.setMinMujeresSol(String.valueOf(resultSet.getInt(("MinMujeresSol"))));
					productosCredito.setMaxMujeresSol(String.valueOf(resultSet.getInt(("MaxMujeresSol"))));
					productosCredito.setMinMujeres(String.valueOf(resultSet.getInt(("MinMujeres"))));
					productosCredito.setMaxMujeres(String.valueOf(resultSet.getInt(("MaxMujeres"))));
					productosCredito.setMinHombres(String.valueOf(resultSet.getInt(("MinHombres"))));
					productosCredito.setMaxHombres(String.valueOf(resultSet.getInt(("MaxHombres"))));
					productosCredito.setTasaPonderaGru(resultSet.getString(("TasaPonderaGru")));

					productosCredito.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					productosCredito.setReqSeguroVida(resultSet.getString("ReqSeguroVida"));
					productosCredito.setFactorRiesgoSeguro(resultSet.getString("FactorRiesgoSeguro"));
					productosCredito.setMontoPolSegVida(resultSet.getString("MontoPolSegVida"));
					productosCredito.setDescuentoSeguro(resultSet.getString("DescuentoSeguro"));

					productosCredito.setValidaCapConta(resultSet.getString("ValidaCapConta"));
					productosCredito.setPorcMaxCapConta(String.valueOf(resultSet.getDouble("PorcMaxCapConta")));
					productosCredito.setProrrateoPago(resultSet.getString("ProrrateoPago"));

					productosCredito.setDiasPasoAtraso(resultSet.getString("DiasPasoAtraso"));
					productosCredito.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
					productosCredito.setProyInteresPagAde(resultSet.getString("ProyInteresPagAde"));

					productosCredito.setTipCobComFalPago(resultSet.getString("TipCobComFalPago"));
					productosCredito.setPerCobComFalPag(resultSet.getString("PerCobComFalPag"));
					productosCredito.setProrrateoComFalPag(resultSet.getString("ProrrateoComFalPag"));
					productosCredito.setPermitePrepago(resultSet.getString("PermitePrepago"));
					productosCredito.setProductoNomina(resultSet.getString("ProductoNomina"));
					productosCredito.setModificarPrepago(resultSet.getString("ModificarPrepago"));
					productosCredito.setTipoPrepago(resultSet.getString("TipoPrepago"));
					productosCredito.setAutorizaComite(resultSet.getString("AutorizaComite"));
					productosCredito.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
					productosCredito.setCalculoRatios(resultSet.getString("CalculoRatios"));
					productosCredito.setAfectacionContable(resultSet.getString("AfectacionContable"));
					productosCredito.setInicioAfuturo(resultSet.getString("InicioAfuturo"));
					productosCredito.setDiasMaximo(resultSet.getString("DiasMaximo"));
					productosCredito.setModalidad(resultSet.getString("Modalidad"));
					productosCredito.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					productosCredito.setTipoPagoComFalPago(resultSet.getString("TipoPagoComFalPago"));

					productosCredito.setCantidadAvales(resultSet.getString(("CantidadAvales")));
					productosCredito.setIntercambioAvalesRatio(resultSet.getString("IntercambiaAvales"));
					productosCredito.setPermiteAutSolPros(resultSet.getString("PermiteAutSolPros"));
					productosCredito.setRequiereReferencias((resultSet.getString("RequiereReferencias")));
					productosCredito.setMinReferencias((resultSet.getString("MinReferencias")));

					productosCredito.setCobraSeguroCuota((resultSet.getString("CobraSeguroCuota")));
					productosCredito.setCobraIVASeguroCuota((resultSet.getString("CobraIVASeguroCuota")));
					productosCredito.setClaveRiesgo(resultSet.getString("ClaveRiesgo"));
					productosCredito.setClaveCNBV(resultSet.getString("ClaveCNBV"));
					productosCredito.setRequiereCheckList((resultSet.getString("RequiereCheckList")));

					productosCredito.setPermiteConsolidacion((resultSet.getString("PerConsolidacion")));
					productosCredito.setInstruDispersion((resultSet.getString("ReqInsDispersion")));
					productosCredito.setRequiereAnalisiCre((resultSet.getString("RequiereAnalisiCre")));

					productosCredito.setEsAgropecuario(resultSet.getString("EsAgropecuario"));
					productosCredito.setRefinanciamiento(resultSet.getString("Refinanciamiento"));
					productosCredito.setTipoAutomatico(resultSet.getString("TipoAutomatico"));
					productosCredito.setPorcMaximo(resultSet.getString("PorcentajeMaximo"));
					productosCredito.setFinanciamientoRural(resultSet.getString("FinanciamientoRural"));
					productosCredito.setParticipaSpei(resultSet.getString("ParticipaSpei"));
					productosCredito.setProductoClabe(resultSet.getString("ProductoCLABE"));
					productosCredito.setDiasAtrasoMin(resultSet.getString("DiasAtrasoMin"));

					productosCredito.setRequiereObligadosSolidarios(resultSet.getString("ReqObligadosSolidarios"));
					productosCredito.setPermObligadosCruzados(resultSet.getString("PerObligadosCruzados"));
					productosCredito.setReqConsultaSIC(resultSet.getString("ReqConsultaSIC"));
					productosCredito.setCobraAccesorios(resultSet.getString("CobraAccesorios"));

					productosCredito.setCobraComAnual(resultSet.getString("CobraComAnual"));
					productosCredito.setTipoComAnual(resultSet.getString("TipoComAnual"));
					productosCredito.setValorComAnual(resultSet.getString("ValorComAnual"));
					productosCredito.setReqConsolidacionAgro(resultSet.getString("ReqConsolidacionAgro"));
					productosCredito.setFechaDesembolso(resultSet.getString("FechaDesembolso"));
					productosCredito.setEstatus(resultSet.getString("Estatus"));
					productosCredito.setValidacionConyuge(resultSet.getString("ValidaConyuge"));
					return productosCredito;
				}
			});
			productosCreditoConsulta= matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal", e);
		}
		return productosCreditoConsulta;
	}

	//consulta de Productos de credito
	public ProductosCreditoBean consultaForanea(ProductosCreditoBean productosCredito, int tipoConsulta) {
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			//Query con el Store Procedure
			String query = "call PRODUCTOSCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProductosCreditoBean productosCredito = new ProductosCreditoBean();
					productosCredito.setProducCreditoID(resultSet.getString(1));
					productosCredito.setDescripcion(resultSet.getString(2));
					productosCredito.setAhoVoluntario(resultSet.getString("AhoVoluntario"));
					productosCredito.setPorAhoVol(resultSet.getString("PorcAhoVol"));
					productosCredito.setProrrateoPago(resultSet.getString("ProrrateoPago"));
					productosCredito.setManejaLinea(resultSet.getString("ManejaLinea"));
					productosCredito.setEsGrupal(resultSet.getString("EsGrupal"));
					productosCredito.setPermitePrepago(resultSet.getString("PermitePrepago"));
					productosCredito.setModificarPrepago(resultSet.getString("ModificarPrepago"));
					productosCredito.setTipoContratoCCID(resultSet.getString("TipoContratoCCID"));
					productosCredito.setMontoMinimo(resultSet.getString("MontoMinimo"));
					productosCredito.setMontoMaximo(resultSet.getString("MontoMaximo"));
					productosCredito.setModalidad(resultSet.getString("Modalidad"));
					productosCredito.setEsquemaSeguroID(resultSet.getString("EsquemaSeguroID"));
					productosCredito.setRequiereAnalisiCre(resultSet.getString("RequiereAnalisiCre"));
					productosCredito.setEstatus(resultSet.getString("Estatus"));




					return productosCredito;
				}
			});
			productosCreditoConsulta =  matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return productosCreditoConsulta;
	}

	//consulta de Productos de grupo
	public ProductosCreditoBean consultaGrupal(ProductosCreditoBean productosCredito, int tipoConsulta) {
		//Query con el Store Procedure
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			//Query con el Store Procedure
			String query = "call PRODUCTOSCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaGrupal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ProductosCreditoBean productosCredito = new ProductosCreditoBean();

					productosCredito.setProducCreditoID(String.valueOf("ProducCreditoID"));
					productosCredito.setEsGrupal(resultSet.getString("EsGrupal"));
					productosCredito.setPerRompimGrup(resultSet.getString("PerRompimGrup"));
					productosCredito.setRaIniCicloGrup(String.valueOf(resultSet.getInt(("RaIniCicloGrup"))));
					productosCredito.setRaFinCicloGrup(String.valueOf(resultSet.getInt(("RaFinCicloGrup"))));


					//parametros de RECA condusef
					productosCredito.setRegistroRECA(resultSet.getString("RegistroRECA"));
					productosCredito.setFechaInscripcion(resultSet.getString("FechaInscripcion"));
					productosCredito.setNombreComercial(resultSet.getString("NombreComercial"));
					productosCredito.setTipoCredito(resultSet.getString("TipoCredito"));
					//parametros de grupales
					productosCredito.setMinMujeresSol(String.valueOf(resultSet.getInt(("MinMujeresSol"))));
					productosCredito.setMaxMujeresSol(String.valueOf(resultSet.getInt(("MaxMujeresSol"))));
					productosCredito.setMinMujeres(String.valueOf(resultSet.getInt(("MinMujeres"))));
					productosCredito.setMaxMujeres(String.valueOf(resultSet.getInt(("MaxMujeres"))));
					productosCredito.setMinHombres(String.valueOf(resultSet.getInt(("MinHombres"))));
					productosCredito.setMaxHombres(String.valueOf(resultSet.getInt(("MaxHombres"))));
					productosCredito.setMaxIntegrantes(String.valueOf(resultSet.getInt(("MaxIntegrantes"))));
					productosCredito.setMinIntegrantes(String.valueOf(resultSet.getInt(("MinIntegrantes"))));
					productosCredito.setTasaPonderaGru(resultSet.getString(("TasaPonderaGru")));

					return productosCredito;
				}
			});
			productosCreditoConsulta= matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de grupo", e);
		}
		return productosCreditoConsulta;
	}

	public List listaProductosCredito(ProductosCreditoBean productosCredito, int tipoLista){
		String query = "call PRODUCTOSCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					productosCredito.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProductosCreditoDAO.listaProductosCredito",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean productosCredito = new ProductosCreditoBean();
				productosCredito.setProducCreditoID(resultSet.getString(1));
				productosCredito.setDescripcion(resultSet.getString(2));
				return productosCredito;
			}
		});
		return matches;
	}

	// lista que muestra los productos de credito que permiten reestructura
	public List listaProductosCreditoReestructura(ProductosCreditoBean productosCredito, int tipoLista){
		String query = "call PRODUCTOSCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					productosCredito.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProductosCreditoDAO.listaProductosCredito",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean productosCredito = new ProductosCreditoBean();
				productosCredito.setProducCreditoID(resultSet.getString(1));
				productosCredito.setDescripcion(resultSet.getString(2));
				return productosCredito;
			}
		});
		return matches;
	}

	public List listaProductos(int tipoLista) {
		//Query con el Store Procedure
		String query = "call PRODUCTOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProductosCreditoDAO.listaProductos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean productos = new ProductosCreditoBean();
				productos.setProducCreditoID(resultSet.getString(1));
				productos.setDescripcion(resultSet.getString(2));
				return productos;
			}
		});

		return matches;
	}
	 //lista de productos de credito cuando no maneja linea en pantalla alta de credito o cuando si maneja para pantalla de alta de linea
	public List listaProductosAltaCred(ProductosCreditoBean productosCredito, int tipoLista){
		String query = "call PRODUCTOSCREDITOLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					productosCredito.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProductosCreditoDAO.listaProductosAltaCred",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean productosCredito = new ProductosCreditoBean();
				productosCredito.setProducCreditoID(resultSet.getString(1));
				productosCredito.setDescripcion(resultSet.getString(2));
				return productosCredito;
			}
		});
		return matches;
	}

	/**
	 * Método que actualiza los productos de crédito.
	 * @author avelasco
	 * @param productosCreditoBean : Clase bean con valores para los parámetros de entrada al SP.
	 * @param tipoAct : Número de actualización a la tabla de PRODUCTOSCREDITO.
	 * @return MensajeTransaccionBean : Resultado de la transacción.
	 */
	public MensajeTransaccionBean actualizar(final ProductosCreditoBean productosCreditoBean, final int tipoAct) {
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
								String query = "call PRODUCTOSCREDITOACT(?,?,?,?,?," +
																"		?,?,?,?,?," +
																"		?,?,?,?,?," +
																"		?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(productosCreditoBean.getProducCreditoID()));
								sentenciaStore.setInt("Par_TipoAct", tipoAct);
								sentenciaStore.setString("Par_CriterComFalPag",productosCreditoBean.getCriterioComFalPag());
								sentenciaStore.setDouble("Par_MontoMinFalPag",Utileria.convierteDoble(productosCreditoBean.getMontoMinComFalPag()));
								sentenciaStore.setString("Par_PerCobComFalPag",productosCreditoBean.getPerCobComFalPag());

								sentenciaStore.setString("Par_TipCobComFalPago",productosCreditoBean.getTipCobComFalPago());
								sentenciaStore.setString("Par_ProrrateoComFalPag",productosCreditoBean.getProrrateoComFalPag());
								sentenciaStore.setString("Par_TipoPagoComFalPago",productosCreditoBean.getTipoPagoComFalPago());
								sentenciaStore.setString("Par_Refinanciamiento", productosCreditoBean.getRefinanciamiento());
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar productos de credito", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public ProductosCreditoBean consultaBanca(ProductosCreditoBean productosCredito, int tipoConsulta) {
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			//Query con el Store Procedure
			String query = "call PRODUCTOSCREDITOWSCON(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									Utileria.convierteEntero(productosCredito.getPerfilID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaBanca",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOWSCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProductosCreditoBean productosCredito = new ProductosCreditoBean();

					productosCredito.setDescripcion(resultSet.getString("Descripcion"));
					productosCredito.setFormaComApertura(resultSet.getString("ForCobroComAper"));
					productosCredito.setMontoComXapert(String.valueOf(resultSet.getDouble("MontoComXapert")));
					productosCredito.setFactorMora(String.valueOf(resultSet.getDouble("FactorMora")));
					productosCredito.setDestinoCredID(String.valueOf(resultSet.getInt("DestinoCreditoID")));
					productosCredito.setClasificacion(resultSet.getString("ClasificacionDestino"));

					return productosCredito;
				}
			});
			productosCreditoConsulta =  matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return productosCreditoConsulta;
	}

	/**Realiza la consulta de productos de crédito, tasa fija, tipo y monto de comisión por apertura,
	 * monto inferior y superior del esquema de tasas, plazos y frecuencias del calendario por producto.
	 * @author avelasco
	 * @param productosCredito : Clase bean que contiene los valores de los parametros de entrada
	 * @param tipoConsulta : Tipo de consulta
	 * @return Clase bean con la respuesta del SP
	 */
	public ProductosCreditoBean consultaWS(ProductosCreditoBean productosCredito, int tipoConsulta) {
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		transaccionDAO.generaNumeroTransaccion();
		try{
			//Query con el Store Procedure
			String query = "call PRODCREDITOWSCON(?,?,?,?,?,	?,?,?,?,?,	?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									Utileria.convierteEntero(productosCredito.getEmpresaID()),
									Utileria.convierteEntero(productosCredito.getSucursal()),
									tipoConsulta,
									Constantes.ENTERO_CERO,

									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaWS",
									Constantes.ENTERO_CERO,

									parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODCREDITOWSCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProductosCreditoBean productosCredito = new ProductosCreditoBean();
					productosCredito.setCodigoRespuesta(resultSet.getString("CodigoRespuesta"));
					productosCredito.setMensajeRespuesta(resultSet.getString("MensajeRespuesta"));
					productosCredito.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					productosCredito.setTipoComXapert(resultSet.getString("TipoComXapert"));
					productosCredito.setMontoComXapert(resultSet.getString("MontoComXapert"));
					productosCredito.setTasaFija(resultSet.getString("TasaFija"));
					productosCredito.setMontoMinimo(resultSet.getString("MontoInferior"));
					productosCredito.setMontoMaximo(resultSet.getString("MontoSuperior"));
					productosCredito.setFrecuencias(resultSet.getString("Frecuencias"));
					productosCredito.setPlazoID(resultSet.getString("PlazoID"));
					return productosCredito;
				}
			});
			productosCreditoConsulta =  matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return productosCreditoConsulta;
	}

	/* consulta los datos de garantia liquida para un producto de credito */
	public ProductosCreditoBean consultaDatosGarantiaLiq(ProductosCreditoBean productosCredito, int tipoConsulta) {
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			String query = "call PRODUCTOSCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaDatosGarantiaLiq",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProductosCreditoBean productosCredito = new ProductosCreditoBean();

					productosCredito.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					productosCredito.setRequiereGarantia(resultSet.getString("RequiereGarantia"));
					productosCredito.setLiberarGaranLiq(resultSet.getString("LiberarGaranLiq"));
					productosCredito.setBonificacionFOGA(resultSet.getString("BonificacionFOGA"));
					productosCredito.setDesbloqAutFOGA(resultSet.getString("DesbloqAutFOGA"));
					productosCredito.setGarantiaFOGAFI(resultSet.getString("RequiereGarFOGAFI"));
					productosCredito.setModalidadFOGAFI(resultSet.getString("ModalidadFOGAFI"));
					productosCredito.setBonificacionFOGAFI(resultSet.getString("BonificacionFOGAFI"));
					productosCredito.setDesbloqAutFOGAFI(resultSet.getString("DesbloqAutFOGAFI"));

					return productosCredito;
				}
			});
			productosCreditoConsulta =  matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return productosCreditoConsulta;
	}// fin de consulta

	/* consulta existencia de un producto de credito alta solicitud credito grupal para sana tus finanzas*/
	public ProductosCreditoBean consultaExistencia(ProductosCreditoBean productosCredito, int tipoConsulta) {
		ProductosCreditoBean productosCreditoConsulta = new ProductosCreditoBean();
		try{
			String query = "call PRODUCTOSCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(productosCredito.getProducCreditoID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ProductosCreditoDAO.consultaExistencia",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOCON(  " + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ProductosCreditoBean productosCredito = new ProductosCreditoBean();

					productosCredito.setProducCreditoID(resultSet.getString("ProducCreditoID"));

					return productosCredito;
				}
			});
			productosCreditoConsulta =  matches.size() > 0 ? (ProductosCreditoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return productosCreditoConsulta;
	}



	/* ****************************METODOS DE BANCA EN LINEA   */
	public List listaProdCreditoWS(ListaProdCreditoRequest listaProductos, int tipoLista){

		String query = "call PRODUCTOSCREDITOBELIS(?,?,? ,?,?,?,?,?,?,?);";

		Object[] parametros = {
				Constantes.STRING_VACIO,
				Utileria.convierteEntero(listaProductos.getPerfilID()),
				Utileria.convierteEntero(listaProductos.getNumeroLista()),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProductosCreditoDAO.listaProductosBE",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOBELIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean listaProducto = new ProductosCreditoBean();
				listaProducto.setProducCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				listaProducto.setDescripcion(resultSet.getString("Descripcion"));

					return listaProducto;

			}
		});
		return matches;

	}
	/*Lista Combo de los Productos de Créditos de Nomina*/
	public List listaProductosNomina(int tipoLista) {
		//Query con el Store Procedure
		String query = "call PRODUCTOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProductosCreditoDAO.listaProductosNomina",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProductosCreditoBean productos = new ProductosCreditoBean();
				productos.setProducCreditoID(resultSet.getString("ProducCreditoID"));
				productos.setDescripcion(resultSet.getString("Descripcion"));
				return productos;
			}
		});

		return matches;
	}

}
