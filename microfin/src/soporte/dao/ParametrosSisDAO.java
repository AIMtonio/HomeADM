package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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

import soporte.bean.ParametrosSisBean;

public class ParametrosSisDAO extends BaseDAO {

	public ParametrosSisDAO(){
		super();
	}

public MensajeTransaccionBean altaParametrosSis(final ParametrosSisBean parametrosSisBean){
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
					String query = "CALL PARAMETROSSISALT(" +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?,?,?,?,?, ?,?,?,?,?,?," +
							"?,?,?,?,?,	?,?,?,?,?,?," +
							"?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosSisBean.getEmpresaID()));
							sentenciaStore.setInt("Par_SucMatrizID",Utileria.convierteEntero(parametrosSisBean.getSucursalMatrizID()));
							sentenciaStore.setString("Par_TelefonoLocal",parametrosSisBean.getTelefonoLocal());

							sentenciaStore.setString("Par_TelefonoInt",parametrosSisBean.getTelefonoInterior());
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(parametrosSisBean.getInstitucionID()));
							sentenciaStore.setInt("Par_EmpresaDefault",Utileria.convierteEntero(parametrosSisBean.getEmpresaDefault()));
							sentenciaStore.setString("Par_NombreRepre",parametrosSisBean.getNombreRepresentante());
							sentenciaStore.setString("Par_RFCRepre",parametrosSisBean.getRFCRepresentante());

							sentenciaStore.setInt("Par_MonedaBaseID",Utileria.convierteEntero(parametrosSisBean.getMonedaBaseID()));
							sentenciaStore.setInt("Par_MonedaExtID",Utileria.convierteEntero(parametrosSisBean.getMonedaExtrangeraID()));
							sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(parametrosSisBean.getTasaISR()));
							sentenciaStore.setDouble("Par_TasaIDE",Utileria.convierteDoble(parametrosSisBean.getTasaIDE()));
							sentenciaStore.setDouble("Par_MontoExcIDE",Utileria.convierteDoble(parametrosSisBean.getMontoExcIDE()));

							sentenciaStore.setInt("Par_EjercicioVig",Utileria.convierteEntero(parametrosSisBean.getEjercicioVigente()));
							sentenciaStore.setInt("Par_PeriodoVigente",Utileria.convierteEntero(parametrosSisBean.getPeriodoVigente()));
							sentenciaStore.setInt("Par_DiasInversion",Utileria.convierteEntero(parametrosSisBean.getDiasInversion()));
							sentenciaStore.setInt("Par_DiasCredito",Utileria.convierteEntero(parametrosSisBean.getDiasCredito()));
							sentenciaStore.setInt("Par_DiasCambioPass",Utileria.convierteEntero(parametrosSisBean.getDiasCambioPass()));

							sentenciaStore.setString("Par_LonMinCaracPass",parametrosSisBean.getLonMinCaracPass());
							sentenciaStore.setInt("Par_ClienteInst",Utileria.convierteEntero(parametrosSisBean.getClienteInstitucion()));
							sentenciaStore.setInt("Par_CuentaInstituc",Utileria.convierteEntero(parametrosSisBean.getCuentaInstituc()));
							sentenciaStore.setString("Par_ManejaCaptacion",parametrosSisBean.getManejaCaptacion());
							sentenciaStore.setInt("Par_BancoCaptacion",Utileria.convierteEntero(parametrosSisBean.getBancoCaptacion()));

							sentenciaStore.setInt("Par_TipoCuenta",Utileria.convierteEntero(parametrosSisBean.getTipoCuenta()));
							sentenciaStore.setString("Par_RutaArchivos",parametrosSisBean.getRutaArchivos());
							sentenciaStore.setInt("Par_RolTesoreria",Utileria.convierteEntero(parametrosSisBean.getRolTesoreria()));
							sentenciaStore.setInt("Par_RolAdminTeso",Utileria.convierteEntero(parametrosSisBean.getRolAdminTeso()));

							sentenciaStore.setInt("Par_OficialCumID",Utileria.convierteEntero(parametrosSisBean.getOficialCumID()));
							sentenciaStore.setInt("Par_DirGeneralID",Utileria.convierteEntero(parametrosSisBean.getDirGeneralID()));
							sentenciaStore.setInt("Par_DirOperID",Utileria.convierteEntero(parametrosSisBean.getDirOperID()));
							sentenciaStore.setString("Par_VencimAutoSeg",parametrosSisBean.getVencimAutoSeg());
							sentenciaStore.setString("Par_CalifAutoCliente",parametrosSisBean.getCalifAutoCliente());

							sentenciaStore.setString("Par_CenCostCheSBC", parametrosSisBean.getCenCostosChequesSBC()); // Centro de Costos de cheque SBC
							sentenciaStore.setString("Par_TipoContaMora", parametrosSisBean.getTipoContaMora());
							sentenciaStore.setString("Par_DivideIngresoInteres", parametrosSisBean.getDivideIngresoInteres());
							sentenciaStore.setInt("Par_TipoDetRecursos",Utileria.convierteEntero(parametrosSisBean.getTipoDetRecursos()));
							sentenciaStore.setString("Par_CalculaCURPyRFC", parametrosSisBean.getCalculaCURPyRFC());
							sentenciaStore.setString("Par_ManejaCarteraAgro", parametrosSisBean.getManejaCarAgro());
							sentenciaStore.setString("Par_EvaluaRiesgoComun", parametrosSisBean.getEvaluaRiesgoComun());
							sentenciaStore.setString("Par_CapitalContNeto", parametrosSisBean.getCapitalContNeto());
							sentenciaStore.setString("Par_DirectorFinanzas", parametrosSisBean.getDirectorFinanzas());
							sentenciaStore.setInt("Par_NumTratamienCreRees", Utileria.convierteEntero(parametrosSisBean.getNumTratamienCreRees()));
							sentenciaStore.setInt("Par_VecesSalMinVig", Utileria.convierteEntero(parametrosSisBean.getVecesSalMinVig()));

							sentenciaStore.setString("Par_AlerVerificaConvenio", parametrosSisBean.getAlerVerificaConvenio());
							sentenciaStore.setInt("Par_NoDiasAntEnvioCorreo", Utileria.convierteEntero(parametrosSisBean.getNoDiasAntEnvioCorreo()));
							sentenciaStore.setString("Par_CorreoRemitente", parametrosSisBean.getCorreoRemitente());
							sentenciaStore.setString("Par_CorreoAdiDestino", parametrosSisBean.getCorreoAdiDestino());
							sentenciaStore.setInt("Par_RemitenteID", Utileria.convierteEntero(parametrosSisBean.getRemitenteID()));
							sentenciaStore.setString("Par_ClabeInstitBancaria", parametrosSisBean.getClabeInstitBancaria());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()); //-- agregar variable  set y get en bean
							return sentenciaStore;
						} //public sql exception
					} // new CallableStatementCreator
					,new CallableStatementCallback() {
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
						}// public
					}// CallableStatementCallback
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parametros de sistema", e);
			}//catch
			return mensajeBean;
		} //public Object doInTransaction
	}); //men
	return mensaje;
} //public


/* Modificacion de parametros del sistema */
public MensajeTransaccionBean modificaParametrosSis(final ParametrosSisBean parametrosSisBean) {
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
							parametrosSisBean.setTelefonoLocal(parametrosSisBean.getTelefonoLocal().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							parametrosSisBean.setTelefonoInterior(parametrosSisBean.getTelefonoInterior().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
							String query = "CALL PARAMETROSSISMOD(" +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?,	?,?,?,?,?," +

														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?,	?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?,	?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?,	?,?,?,?,?," +
														"?,?,?,?,?,	?,?,?,?,?," +
														"?,?,?,?,"+
														"?,?,?,?,?,?,?  );";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_EmpresaID",Utileria.convierteEntero(parametrosSisBean.getEmpresaID()));
							sentenciaStore.setInt("Par_SucMatrizID",Utileria.convierteEntero(parametrosSisBean.getSucursalMatrizID()));
							sentenciaStore.setString("Par_TelefonoLocal",parametrosSisBean.getTelefonoLocal());
							sentenciaStore.setString("Par_TelefonoInt",parametrosSisBean.getTelefonoInterior());
							sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(parametrosSisBean.getInstitucionID()));
							sentenciaStore.setInt("Par_EmpresaDefault",Utileria.convierteEntero(parametrosSisBean.getEmpresaDefault()));
							sentenciaStore.setString("Par_NombreRepre",parametrosSisBean.getNombreRepresentante());
							sentenciaStore.setString("Par_RFCRepre",parametrosSisBean.getRFCRepresentante());
							sentenciaStore.setInt("Par_MonedaBaseID",Utileria.convierteEntero(parametrosSisBean.getMonedaBaseID()));
							sentenciaStore.setInt("Par_MonedaExtID",Utileria.convierteEntero(parametrosSisBean.getMonedaExtrangeraID()));

							sentenciaStore.setDouble("Par_TasaISR",Utileria.convierteDoble(parametrosSisBean.getTasaISR()));
							sentenciaStore.setDouble("Par_TasaIDE",Utileria.convierteDoble(parametrosSisBean.getTasaIDE()));
							sentenciaStore.setDouble("Par_MontoExcIDE",Utileria.convierteDoble(parametrosSisBean.getMontoExcIDE()));
							sentenciaStore.setInt("Par_EjercicioVig",Utileria.convierteEntero(parametrosSisBean.getEjercicioVigente()));
							sentenciaStore.setInt("Par_PeriodoVigente",Utileria.convierteEntero(parametrosSisBean.getPeriodoVigente()));
							sentenciaStore.setInt("Par_DiasInversion",Utileria.convierteEntero(parametrosSisBean.getDiasInversion()));
							sentenciaStore.setInt("Par_DiasCredito",Utileria.convierteEntero(parametrosSisBean.getDiasCredito()));
							sentenciaStore.setInt("Par_DiasCambioPass",Utileria.convierteEntero(parametrosSisBean.getDiasCambioPass()));
							sentenciaStore.setString("Par_LonMinCaracPass",parametrosSisBean.getLonMinCaracPass());
							sentenciaStore.setInt("Par_ClienteInst",Utileria.convierteEntero(parametrosSisBean.getClienteInstitucion()));

							sentenciaStore.setLong("Par_CuentaInstituc",Utileria.convierteLong(parametrosSisBean.getCuentaInstituc()));
							sentenciaStore.setString("Par_ManejaCaptacion",parametrosSisBean.getManejaCaptacion());
							sentenciaStore.setInt("Par_BancoCaptacion",Utileria.convierteEntero(parametrosSisBean.getBancoCaptacion()));
							sentenciaStore.setInt("Par_TipoCuenta",Utileria.convierteEntero(parametrosSisBean.getTipoCuenta()));
							sentenciaStore.setString("Par_RutaArchivos",parametrosSisBean.getRutaArchivos());
							sentenciaStore.setInt("Par_RolTesoreria",Utileria.convierteEntero(parametrosSisBean.getRolTesoreria()));
							sentenciaStore.setInt("Par_RolAdminTeso",Utileria.convierteEntero(parametrosSisBean.getRolAdminTeso()));
							sentenciaStore.setInt("Par_OficialCumID",Utileria.convierteEntero(parametrosSisBean.getOficialCumID()));
							sentenciaStore.setInt("Par_DirGeneralID",Utileria.convierteEntero(parametrosSisBean.getDirGeneralID()));
							sentenciaStore.setInt("Par_DirOperID",Utileria.convierteEntero(parametrosSisBean.getDirOperID()));

							sentenciaStore.setString("Par_JefeCobranza",parametrosSisBean.getNombreJefeCobranza());
							sentenciaStore.setString("Par_JefeOperayPromo",parametrosSisBean.getNomJefeOperayPromo());
							sentenciaStore.setInt("Par_TipoCtaGLAdi",Utileria.convierteEntero(parametrosSisBean.getTipoCtaGLAdi()));
							sentenciaStore.setString("Par_RutaArchivosPLD",parametrosSisBean.getRutaArchivosPLD());
							sentenciaStore.setString("Par_Remitente",parametrosSisBean.getRemitente());
							sentenciaStore.setString("Par_ServidorCorreo",parametrosSisBean.getServidorCorreo());
							sentenciaStore.setString("Par_Puerto",parametrosSisBean.getPuerto());
							sentenciaStore.setString("Par_UsuarioCorreo",parametrosSisBean.getUsuarioCorreo());
							sentenciaStore.setString("Par_Contrasenia",parametrosSisBean.getContrasenia());
							sentenciaStore.setString("Par_CtaIniGastoEmp",parametrosSisBean.getCtaIniGastoEmp());

							sentenciaStore.setString("Par_CtaFinGastoEmp",parametrosSisBean.getCtaFinGastoEmp());
							sentenciaStore.setString("Par_ImpTicket",parametrosSisBean.getImpTicket());
							sentenciaStore.setString("Par_TipoImpTicket",parametrosSisBean.getTipoImpTicket());
							sentenciaStore.setDouble("Par_MontoAportacion",Utileria.convierteDoble(parametrosSisBean.getMontoAportacion()));
							sentenciaStore.setString("Par_ReqAportacionSo",parametrosSisBean.getReqAportacionSo());
							sentenciaStore.setDouble("Par_MontoPolizaSegA",Utileria.convierteDoble(parametrosSisBean.getMontoPolizaSegA()));
							sentenciaStore.setDouble("Par_MontoSegAyuda",Utileria.convierteDoble(parametrosSisBean.getMontoSegAyuda()));
							sentenciaStore.setString("Par_CuentasCapConta",parametrosSisBean.getCuentasCapConta());
							sentenciaStore.setDouble("Par_LonMinPagRemesa",Utileria.convierteDoble(parametrosSisBean.getLonMinPagRemesa()));
							sentenciaStore.setDouble("Par_LonMaxPagRemesa",Utileria.convierteDoble(parametrosSisBean.getLonMaxPagRemesa()));

							sentenciaStore.setDouble("Par_LonMinPagOport",Utileria.convierteDoble(parametrosSisBean.getLonMinPagOport()));
							sentenciaStore.setDouble("Par_LonMaxPagOport",Utileria.convierteDoble(parametrosSisBean.getLonMaxPagOport()));
							sentenciaStore.setDouble("Par_SalMinDF",Utileria.convierteDoble(parametrosSisBean.getSalMinDF()));
							sentenciaStore.setString("Par_ImpSaldoCred",parametrosSisBean.getImpSaldoCred());
							sentenciaStore.setString("Par_ImpSaldoCta",parametrosSisBean.getImpSaldoCta());
							sentenciaStore.setString("Par_GenrenteGral",parametrosSisBean.getGerenteGeneral());
							sentenciaStore.setString("Par_PresiConsejo",parametrosSisBean.getPresidenteConsejo());
							sentenciaStore.setString("Par_JefeContabil",parametrosSisBean.getJefeContabilidad());
							sentenciaStore.setString("Par_VigDiasSeguro", parametrosSisBean.getVigDiasSeguro());
							sentenciaStore.setString("Par_VencimAutoSeg",parametrosSisBean.getVencimAutoSeg());

							sentenciaStore.setString("Par_AplCobPenCieDia",parametrosSisBean.getAplCobPenCieDia());
							sentenciaStore.setString("Par_FecUltConsejoAdmon",parametrosSisBean.getFechaUltimoComite());
							sentenciaStore.setString("Par_FoliosActasComite",parametrosSisBean.getFoliosAutActaComite());
							sentenciaStore.setInt("Par_ServReactivaCte",Utileria.convierteEntero(parametrosSisBean.getServReactivaCliID()));
							sentenciaStore.setString("Par_CtaContaSobrante",parametrosSisBean.getCtaContaSobrante());
							sentenciaStore.setString("Par_CtaContaFaltante",parametrosSisBean.getCtaContaFaltante());
							sentenciaStore.setString("Par_CalifAutoCliente",parametrosSisBean.getCalifAutoCliente());
							sentenciaStore.setString("Par_CtaContaDocSBCD",parametrosSisBean.getCtaContaDocSBCD());
							sentenciaStore.setString("Par_CtaContaDocSBCA",parametrosSisBean.getCtaContaDocSBCA());
							sentenciaStore.setString("Par_AfectaContaRecSBC",parametrosSisBean.getAfectaContaRecSBC());

							sentenciaStore.setString("Par_ContabilidadGL",parametrosSisBean.getContabilidadGL());
							sentenciaStore.setString("Par_CenCostosCheSBC",parametrosSisBean.getCenCostosChequesSBC()); // Centro de costos de cheque SBC
							sentenciaStore.setString("Par_MostSaldoDispCta",parametrosSisBean.getMostrarSaldDisCtaYSbc()); // Mostrar saldo disponible cuenta
							sentenciaStore.setInt("Par_DiasVigBC",Utileria.convierteEntero(parametrosSisBean.getDiasVigenciaBC()));
							sentenciaStore.setString("Par_ValidaAutComite",parametrosSisBean.getValidaAutComite()); // Mostrar saldo disponible cuenta
							sentenciaStore.setString("Par_TipoContaMora", parametrosSisBean.getTipoContaMora());
							sentenciaStore.setString("Par_DivideIngresoInteres", parametrosSisBean.getDivideIngresoInteres());
							sentenciaStore.setString("Par_ExtTelefonoLocal",parametrosSisBean.getExtTelefonoLocal());
							sentenciaStore.setString("Par_ExtTelefonoInt",parametrosSisBean.getExtTelefonoInt());
							sentenciaStore.setString("Par_EstCreAltInvGar",parametrosSisBean.getEstCreAltInvGar());

							sentenciaStore.setString("Par_FuncionHuella",parametrosSisBean.getFuncionHuella());
							sentenciaStore.setString("Par_ReqHuellaProductos",parametrosSisBean.getReqhuellaProductos());
							sentenciaStore.setString("Par_CancelaAutMenor", parametrosSisBean.getCancelaAutMenor());
							sentenciaStore.setInt("Par_PerfilWsVbc", Utileria.convierteEntero(parametrosSisBean.getPerfilWsVbc()));
							sentenciaStore.setString("Par_ZonaHoraria", parametrosSisBean.getZonaHoraria());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							// Parámetros para facturación electronica
							sentenciaStore.setString("Par_EstadoEmpresa", parametrosSisBean.getEstadoEmpresa());
							sentenciaStore.setString("Par_MunicipioEmpresa",parametrosSisBean.getMunicipioEmpresa());
							sentenciaStore.setString("Par_LocalidadEmpresa", parametrosSisBean.getLocalidadEmpresa());

							sentenciaStore.setString("Par_ColoniaEmpresa", parametrosSisBean.getColoniaEmpresa());
							sentenciaStore.setString("Par_CalleEmpresa", parametrosSisBean.getCalleEmpresa());
							sentenciaStore.setString("Par_NumIntEmpresa", parametrosSisBean.getNumIntEmpresa());
							sentenciaStore.setString("Par_NumExtEmpresa", parametrosSisBean.getNumExtEmpresa());
							sentenciaStore.setString("Par_CPEmpresa", parametrosSisBean.getCPEmpresa());
							sentenciaStore.setString("Par_DirFiscal", parametrosSisBean.getDirFiscal());
							sentenciaStore.setString("Par_RFCEmp", parametrosSisBean.getRfcEmpresa());
							sentenciaStore.setString("Par_TimbraEdoCta",parametrosSisBean.getTimbraEdoCta());
							sentenciaStore.setString("Par_GeneraCFDINoReg",parametrosSisBean.getGeneraCFDINoReg());
							sentenciaStore.setString("Par_GeneraEdoCtaAuto",parametrosSisBean.getGeneraEdoCtaAuto());

							sentenciaStore.setString("Par_ConBuroCreDefaut",parametrosSisBean.getConBuroCreDefaut());
							sentenciaStore.setString("Par_AbreviaturaCirculo",parametrosSisBean.getAbreviaturaCirculo());
							sentenciaStore.setString("Par_CambiaPromotor", parametrosSisBean.getCambiaPromotor());
							sentenciaStore.setString("Par_MostrarPrefijo", parametrosSisBean.getMostrarPrefijo());
							sentenciaStore.setString("Par_ChecListCte", parametrosSisBean.getChecListCte());
							sentenciaStore.setString("Par_TarjetaIdentiSocio", parametrosSisBean.getTarjetaIdentiSocio());
							sentenciaStore.setString("Par_CancelaAutSolCre", parametrosSisBean.getCancelaAutSolCre());
							sentenciaStore.setString("Par_DiasCancelaAutSolCre", parametrosSisBean.getDiasCancelaAutSolCre());
							sentenciaStore.setInt("Par_NumTratamienCre", Utileria.convierteEntero(parametrosSisBean.getNumTratamienCre()));
							sentenciaStore.setDouble("Par_CapitalCubierto", Utileria.convierteDoble(parametrosSisBean.getCapitalCubierto()));

							sentenciaStore.setString("Par_PagoIntVertical", parametrosSisBean.getPagoIntVertical());
							sentenciaStore.setInt("Par_NumMaxDiasMora", Utileria.convierteEntero(parametrosSisBean.getNumMaxDiasMora()));
							sentenciaStore.setString("Par_ImpFomatosInd", parametrosSisBean.getImpFomatosInd());
							sentenciaStore.setString("Par_ReqValidaCred", parametrosSisBean.getReqValidaCred());
							sentenciaStore.setString("Par_SistemasID", parametrosSisBean.getSistemasID());
							sentenciaStore.setString("Par_RutaNotifiCobranza", parametrosSisBean.getRutaNotifiCobranza());
							sentenciaStore.setString("Par_CobraSeguroCuota", parametrosSisBean.getCobraSeguroCuota());
							sentenciaStore.setInt("Par_TipoDocumentoFirma", Utileria.convierteEntero(parametrosSisBean.getTipoDocumentoID()));
							sentenciaStore.setString("Par_ReestCalendarioVen", parametrosSisBean.getReestCalendarioVen());
							sentenciaStore.setString("Par_EstatusValidaReest", parametrosSisBean.getValidaEstatusRees());

							sentenciaStore.setInt("Par_TipoDetRecursos",Utileria.convierteEntero(parametrosSisBean.getTipoDetRecursos()));
							sentenciaStore.setString("Par_CalculaCURPyRFC", parametrosSisBean.getCalculaCURPyRFC());
							sentenciaStore.setString("Par_ManejaCarteraAgro", parametrosSisBean.getManejaCarAgro());
							sentenciaStore.setDouble("Par_SalMinDFReal",Utileria.convierteDoble(parametrosSisBean.getSalMinDFReal()));
							sentenciaStore.setString("Par_EvaluacionMatriz", parametrosSisBean.getEvaluacionMatriz());
							sentenciaStore.setInt("Par_FrecuenciaMensual", Utileria.convierteEntero(parametrosSisBean.getFrecuenciaMensual()));

							sentenciaStore.setString("Par_EvaluaRiesgoComun", parametrosSisBean.getEvaluaRiesgoComun());
							sentenciaStore.setString("Par_CapitalContNeto", parametrosSisBean.getCapitalContNeto());

							sentenciaStore.setString("Par_CobranzaAutCie", parametrosSisBean.getCobranzaAutCie());
							sentenciaStore.setString("Par_CobroCompletoAut", parametrosSisBean.getCobroCompletoAut());
							sentenciaStore.setString("Par_CapitalCubiertoReac", parametrosSisBean.getCapitalCubiertoReac());
							sentenciaStore.setString("Par_PorcPersonaFisica", parametrosSisBean.getPorcPersonaFisica());
							sentenciaStore.setString("Par_PorcPersonaMoral", parametrosSisBean.getPorcPersonaMoral());

							sentenciaStore.setString("Par_PermitirMultDisp",parametrosSisBean.getPermitirMultDisp());
							sentenciaStore.setString("Par_FechaConsDisp", parametrosSisBean.getFechaConsDisp());
							sentenciaStore.setString("Par_InvPagoPeriodico", parametrosSisBean.getInvPagoPeriodico());
							//aportaciones
							sentenciaStore.setInt("Par_PerfilAutEspAport", Utileria.convierteEntero(parametrosSisBean.getPerfilAutEspAport()));
							// perfil que puede hacer cambios en las cartas de liquidacion
							sentenciaStore.setInt("Par_PerfilCamCarLiqui", Utileria.convierteEntero(parametrosSisBean.getPerfilCamCarLiqui()));
							// Circulo de Credito
							sentenciaStore.setString("Par_InstitucionCirculoCredito", parametrosSisBean.getInstitucionCirculoCredito());
							sentenciaStore.setInt("Par_ClaveEntidadCirculo", Utileria.convierteEntero(parametrosSisBean.getClaveEntidadCirculo()));
							sentenciaStore.setString("Par_ReportarTotalIntegrantes", parametrosSisBean.getReportarTotalIntegrantes());

							sentenciaStore.setString("Par_DirectorFinanzas",parametrosSisBean.getDirectorFinanzas());
							sentenciaStore.setString("Par_ValidaFactura", parametrosSisBean.getValidaFactura());
							sentenciaStore.setString("Par_ValidaFacturaURL", parametrosSisBean.getValidaFacturaURL());
							sentenciaStore.setInt("Par_TiempoEsperaWS", Utileria.convierteEntero(parametrosSisBean.getTiempoEsperaWS()));
							sentenciaStore.setInt("Par_NumTratamienCreRees", Utileria.convierteEntero(parametrosSisBean.getNumTratamienCreRees()));
							sentenciaStore.setString("Par_RestringeReporte", parametrosSisBean.getRestringeReporte());
							sentenciaStore.setString("Par_CamFuenFonGarFira", parametrosSisBean.getCamFuenFonGarFira());
							sentenciaStore.setString("Par_PersonNoDeseadas", parametrosSisBean.getPersonNoDeseadas());

							sentenciaStore.setString("Par_OcultaBtnRechazoSol", parametrosSisBean.getOcultaBtnRechazoSol());
							sentenciaStore.setString("Par_RestringebtnLiberacionSol", parametrosSisBean.getRestringebtnLiberacionSol());
							sentenciaStore.setInt("Par_PrimerRolFlujoSolID", Utileria.convierteEntero(parametrosSisBean.getPrimerRolFlujoSolID()));
							sentenciaStore.setInt("Par_SegundoRolFlujoSolID", Utileria.convierteEntero(parametrosSisBean.getSegundoRolFlujoSolID()));

							sentenciaStore.setInt("Par_VecesSalMinVig", Utileria.convierteEntero(parametrosSisBean.getVecesSalMinVig()));
							// Seccion de parametros  de configuracion de contraseña
							sentenciaStore.setInt("Par_CaracterMinimo", Utileria.convierteEntero(parametrosSisBean.getCaracterMinimo()));
							sentenciaStore.setString("Par_ReqCaracterMayus", parametrosSisBean.getReqCaracterMayus());
							sentenciaStore.setInt("Par_CaracterMayus", Utileria.convierteEntero(parametrosSisBean.getCaracterMayus()));
							sentenciaStore.setString("Par_ReqCaracterMinus", parametrosSisBean.getReqCaracterMinus());
							sentenciaStore.setInt("Par_CaracterMinus", Utileria.convierteEntero(parametrosSisBean.getCaracterMinus()));

							sentenciaStore.setString("Par_ReqCaracterNumerico", parametrosSisBean.getReqCaracterNumerico());
							sentenciaStore.setInt("Par_CaracterNumerico", Utileria.convierteEntero(parametrosSisBean.getCaracterNumerico()));
							sentenciaStore.setString("Par_ReqCaracterEspecial", parametrosSisBean.getReqCaracterEspecial());
							sentenciaStore.setInt("Par_CaracterEspecial", Utileria.convierteEntero(parametrosSisBean.getCaracterEspecial()));
							sentenciaStore.setInt("Par_UltimasContra", Utileria.convierteEntero(parametrosSisBean.getUltimasContra()));

							sentenciaStore.setInt("Par_DiaMaxCamContra", Utileria.convierteEntero(parametrosSisBean.getDiaMaxCamContra()));
							sentenciaStore.setInt("Par_DiaMaxInterSesion", Utileria.convierteEntero(parametrosSisBean.getDiaMaxInterSesion()));
							sentenciaStore.setInt("Par_NumIntentos", Utileria.convierteEntero(parametrosSisBean.getNumIntentos()));
							sentenciaStore.setInt("Par_NumDiaBloq", Utileria.convierteEntero(parametrosSisBean.getNumDiaBloq()));

							sentenciaStore.setString("Par_AlerVerificaConvenio", parametrosSisBean.getAlerVerificaConvenio());
							sentenciaStore.setInt("Par_NoDiasAntEnvioCorreo", Utileria.convierteEntero(parametrosSisBean.getNoDiasAntEnvioCorreo()));
							sentenciaStore.setString("Par_CorreoRemitente", parametrosSisBean.getCorreoRemitente());
							sentenciaStore.setString("Par_CorreoAdiDestino", parametrosSisBean.getCorreoAdiDestino());
							sentenciaStore.setInt("Par_RemitenteID", Utileria.convierteEntero(parametrosSisBean.getRemitenteID()));

							sentenciaStore.setString("Par_ClabeInstitBancaria", parametrosSisBean.getClabeInstitBancaria());
							sentenciaStore.setString("Par_ValidarEtiqCambFond", parametrosSisBean.getValidarEtiqCambFond());
							sentenciaStore.setInt("Par_RemCierreID", Utileria.convierteEntero(parametrosSisBean.getRemitenteCierreID()));
							sentenciaStore.setString("Par_CorreoRemCierre", parametrosSisBean.getCorreoRemitenteCierre());
							sentenciaStore.setString("Par_EjecDepreAmortiAut", parametrosSisBean.getEjecDepreAmortiAut());
							sentenciaStore.setString("Par_ValidaReferencia", parametrosSisBean.getValidaRef());
							sentenciaStore.setString("Par_AplicaGarAdiPagoCre", parametrosSisBean.getAplicaGarAdiPagoCre());
							sentenciaStore.setString("Par_ValidaCapitalConta", parametrosSisBean.getValidaCapitalConta());
							sentenciaStore.setString("Par_PorMaximoDeposito", parametrosSisBean.getPorMaximoDeposito());

							sentenciaStore.setString("Par_MostrarBtnResumen", parametrosSisBean.getMostrarBtnResumen());
							sentenciaStore.setString("Par_ValidaCicloGrupo", parametrosSisBean.getValidaCicloGrupo());

							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISMOD(" + sentenciaStore.toString() + ")");
							return sentenciaStore;
						} //public sql exception
					} // new CallableStatementCreator
					,new CallableStatementCallback<Object>() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}// public
					}// CallableStatementCallback
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
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica parametros de sistema", e);
			mensajeBean.setDescripcion(e.getMessage());
			transaction.setRollbackOnly();

			}
			return mensajeBean;
		}
	});
	return mensaje;
}
/* Consuta por Llave Principal */
public ParametrosSisBean consultaPrincipalExterna(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		//Query con el Store Procedure
		String query = "call PARAMETROSSISCON(" +
				"?,?,?,?,?, ?,?,?,?);";

		Object[] parametros = { parametrosSis.getEmpresaID(),
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion

loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosSis.getRutaArchivos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setEmpresaID(resultSet.getString("EmpresaID"));
				parametrosSisBean.setFechaSistema(resultSet.getString("FechaSistema"));
				parametrosSisBean.setSucursalMatrizID(resultSet.getString("SucursalMatrizID"));
				parametrosSisBean.setTelefonoLocal(resultSet.getString("TelefonoLocal"));
				parametrosSisBean.setTelefonoInterior(resultSet.getString("TelefonoInterior"));

				parametrosSisBean.setInstitucionID(resultSet.getString("InstitucionID"));
				parametrosSisBean.setEmpresaDefault(resultSet.getString("EmpresaDefault"));
				parametrosSisBean.setNombreRepresentante(resultSet.getString("NombreRepresentante"));
				parametrosSisBean.setRFCRepresentante(resultSet.getString("RFCRepresentante"));
				parametrosSisBean.setMonedaBaseID(resultSet.getString("MonedaBaseID"));

				parametrosSisBean.setMonedaExtrangeraID(resultSet.getString("MonedaExtrangeraID"));
				parametrosSisBean.setTasaISR(resultSet.getString("TasaISR"));
				parametrosSisBean.setTasaIDE(resultSet.getString("TasaIDE"));
				parametrosSisBean.setMontoExcIDE(resultSet.getString("MontoExcIDE"));
				parametrosSisBean.setEjercicioVigente(resultSet.getString("EjercicioVigente"));

				parametrosSisBean.setPeriodoVigente(resultSet.getString("PeriodoVigente"));
				parametrosSisBean.setDiasInversion(resultSet.getString("DiasInversion"));
				parametrosSisBean.setDiasCredito(resultSet.getString("DiasCredito"));
				parametrosSisBean.setDiasCambioPass(resultSet.getString("DiasCambioPass"));
				parametrosSisBean.setLonMinCaracPass(resultSet.getString("LonMinCaracPass"));

				parametrosSisBean.setClienteInstitucion(resultSet.getString("ClienteInstitucion"));
				parametrosSisBean.setCuentaInstituc(resultSet.getString("CuentaInstituc"));
				parametrosSisBean.setManejaCaptacion(resultSet.getString("ManejaCaptacion"));
				parametrosSisBean.setBancoCaptacion(resultSet.getString("BancoCaptacion"));
				parametrosSisBean.setTipoCuenta(resultSet.getString("TipoCuenta"));

				parametrosSisBean.setRutaArchivos(resultSet.getString("RutaArchivos"));
				parametrosSisBean.setRolTesoreria(resultSet.getString("RolTesoreria"));
				parametrosSisBean.setRolAdminTeso(resultSet.getString("RolAdminTeso"));
				parametrosSisBean.setOficialCumID(resultSet.getString("OficialCumID"));
				parametrosSisBean.setDirGeneralID(resultSet.getString("DirGeneralID"));

				parametrosSisBean.setDirOperID(resultSet.getString("DirOperID"));
				parametrosSisBean.setTipoCtaGLAdi(resultSet.getString("TipoCtaGLAdi"));
				parametrosSisBean.setRutaArchivosPLD(resultSet.getString("RutaArchivosPLD"));
				parametrosSisBean.setRemitente(resultSet.getString("Remitente"));
				parametrosSisBean.setServidorCorreo(resultSet.getString("ServidorCorreo"));

				parametrosSisBean.setPuerto(resultSet.getString("Puerto"));
				parametrosSisBean.setUsuarioCorreo(resultSet.getString("UsuarioCorreo"));
				parametrosSisBean.setContrasenia(resultSet.getString("Contrasenia"));
				parametrosSisBean.setCtaIniGastoEmp(resultSet.getString("CtaIniGastoEmp"));
				parametrosSisBean.setCtaFinGastoEmp(resultSet.getString("CtaFinGastoEmp"));

				parametrosSisBean.setImpTicket(resultSet.getString("ImpTicket"));
				parametrosSisBean.setTipoImpTicket(resultSet.getString("TipoImpTicket"));
				parametrosSisBean.setMontoAportacion(resultSet.getString("MontoAportacion"));
				parametrosSisBean.setReqAportacionSo(resultSet.getString("ReqAportacionSo"));
				parametrosSisBean.setMontoPolizaSegA(resultSet.getString("MontoPolizaSegA"));

				parametrosSisBean.setMontoSegAyuda(resultSet.getString("MontoSegAyuda"));
				parametrosSisBean.setCuentasCapConta(resultSet.getString("CuentasCapConta"));
				parametrosSisBean.setLonMinPagRemesa(resultSet.getString("LonMinPagRemesa"));
				parametrosSisBean.setLonMaxPagRemesa(resultSet.getString("LonMaxPagRemesa"));
				parametrosSisBean.setLonMinPagOport(resultSet.getString("LonMinPagOport"));

				parametrosSisBean.setLonMaxPagOport(resultSet.getString("LonMaxPagOport"));
				parametrosSisBean.setSalMinDF(resultSet.getString("SalMinDF"));
				parametrosSisBean.setImpSaldoCred(resultSet.getString("ImpSaldoCred"));
				parametrosSisBean.setImpSaldoCta(resultSet.getString("ImpSaldoCta"));
				parametrosSisBean.setNombreJefeCobranza(resultSet.getString("NombreJefeCobranza"));

				parametrosSisBean.setNomJefeOperayPromo(resultSet.getString("NomJefeOperayPromo"));
				parametrosSisBean.setGerenteGeneral(resultSet.getString("GerenteGeneral"));
				parametrosSisBean.setPresidenteConsejo(resultSet.getString("PresidenteConsejo"));
				parametrosSisBean.setJefeContabilidad(resultSet.getString("JefeContabilidad"));

				parametrosSisBean.setVigDiasSeguro(resultSet.getString("VigDiasSeguro"));
				parametrosSisBean.setVencimAutoSeg(resultSet.getString("VencimAutoSeg"));
				parametrosSisBean.setEstadoEmpresa(resultSet.getString("EstadoEmpresa"));
				parametrosSisBean.setMunicipioEmpresa(resultSet.getString("MunicipioEmpresa"));
				parametrosSisBean.setLocalidadEmpresa(resultSet.getString("LocalidadEmpresa"));

				// Parametros de facturacion electronica obtenidos de la BD
				parametrosSisBean.setColoniaEmpresa(resultSet.getString("ColoniaEmpresa"));
				parametrosSisBean.setCalleEmpresa(resultSet.getString("CalleEmpresa"));
				parametrosSisBean.setNumIntEmpresa(resultSet.getString("NumIntEmpresa"));
				parametrosSisBean.setNumExtEmpresa(resultSet.getString("NumExtEmpresa"));
				parametrosSisBean.setCPEmpresa(resultSet.getString("CPEmpresa"));

				parametrosSisBean.setDirFiscal(resultSet.getString("DirFiscal"));
				parametrosSisBean.setRfcEmpresa(resultSet.getString("RFC"));
				parametrosSisBean.setTimbraEdoCta(resultSet.getString("TimbraEdoCta"));
				parametrosSisBean.setGeneraCFDINoReg(resultSet.getString("GeneraCFDINoReg"));
				parametrosSisBean.setGeneraEdoCtaAuto(resultSet.getString("GeneraEdoCtaAuto"));

				parametrosSisBean.setAplCobPenCieDia(resultSet.getString("AplCobPenCieDia"));
				parametrosSisBean.setFechaUltimoComite(resultSet.getString("FecUltConsejoAdmon"));
				parametrosSisBean.setFoliosAutActaComite(resultSet.getString("FoliosActasComite"));
				parametrosSisBean.setServReactivaCliID(resultSet.getString("ServReactivaCte"));// Servicio de reactivacion de cliente
				parametrosSisBean.setCtaContaSobrante(resultSet.getString("CtaContaSobrante"));
				parametrosSisBean.setCtaContaFaltante(resultSet.getString("CtaContaFaltante"));

				parametrosSisBean.setCalifAutoCliente(resultSet.getString("CalifAutoCliente"));
				parametrosSisBean.setCtaContaDocSBCA(resultSet.getString("CtaContaDocSBCA"));
				parametrosSisBean.setCtaContaDocSBCD(resultSet.getString("CtaContaDocSBCD"));
				parametrosSisBean.setAfectaContaRecSBC(resultSet.getString("AfectaContaRecSBC"));
				parametrosSisBean.setContabilidadGL(resultSet.getString("ContabilidadGL"));
				parametrosSisBean.setDiasVigenciaBC(resultSet.getString("DiasVigenciaBC"));
				parametrosSisBean.setCenCostosChequesSBC(resultSet.getString("CenCostosChequeSBC")); // consulta el centro de costos de cheque SBC
				parametrosSisBean.setMostrarSaldDisCtaYSbc(resultSet.getString("MostrarSaldDisCtaYSbc"));
				parametrosSisBean.setValidaAutComite(resultSet.getString("ValidaAutComite"));

				parametrosSisBean.setExtTelefonoLocal(resultSet.getString("ExtTelefonoLocal"));
				parametrosSisBean.setExtTelefonoInt(resultSet.getString("ExtTelefonoInt"));

				parametrosSisBean.setTipoContaMora(resultSet.getString("TipoContaMora"));
				parametrosSisBean.setDivideIngresoInteres(resultSet.getString("DivideIngresoInteres"));
				parametrosSisBean.setEstCreAltInvGar(resultSet.getString("EstCreAltInvGar"));
				parametrosSisBean.setFuncionHuella(resultSet.getString("FuncionHuella"));
				parametrosSisBean.setConBuroCreDefaut(resultSet.getString("ConBuroCreDefaut"));
				parametrosSisBean.setAbreviaturaCirculo(resultSet.getString("AbreviaturaCirculo"));
				parametrosSisBean.setReqhuellaProductos(resultSet.getString("ReqHuellaProductos"));
				parametrosSisBean.setCancelaAutMenor(resultSet.getString("CancelaAutMenor"));
				parametrosSisBean.setActivaPromotorCapta(resultSet.getString("ActivaPromotorCapta"));
				parametrosSisBean.setCambiaPromotor(resultSet.getString("CambiaPromotor"));
				parametrosSisBean.setMostrarPrefijo(resultSet.getString("MostrarPrefijo"));
				parametrosSisBean.setDirectorFinanzas(resultSet.getString("DirectorFinanzas"));

				return parametrosSisBean;

			}// trows ecexeption
		});//lista



		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros de sistema", e);
	}
	return parametrosSisBean;
}// consultaPrincipal



	/* Consuta por Llave Principal */
	public ParametrosSisBean consultaPrincipal(ParametrosSisBean parametrosSis, int tipoConsulta) {
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		try {
			//Query con el Store Procedure
			String query = "call PARAMETROSSISCON(?,?,?," + "?,?,?," + "?,?,?);";

			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,//aud_usuario
					Constantes.FECHA_VACIA, //fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO, //programaID
					Constantes.ENTERO_CERO,// sucursal
					Constantes.ENTERO_CERO
			};//numTransaccion

			if(parametrosAuditoriaBean.getOrigenDatos() == null) {
				parametrosAuditoriaBean.setOrigenDatos("microfin");
			}

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setEmpresaID(resultSet.getString("EmpresaID"));
					parametrosSisBean.setFechaSistema(resultSet.getString("FechaSistema"));
					parametrosSisBean.setSucursalMatrizID(resultSet.getString("SucursalMatrizID"));
					parametrosSisBean.setTelefonoLocal(resultSet.getString("TelefonoLocal"));
					parametrosSisBean.setTelefonoInterior(resultSet.getString("TelefonoInterior"));

					parametrosSisBean.setInstitucionID(resultSet.getString("InstitucionID"));
					parametrosSisBean.setEmpresaDefault(resultSet.getString("EmpresaDefault"));
					parametrosSisBean.setNombreRepresentante(resultSet.getString("NombreRepresentante"));
					parametrosSisBean.setRFCRepresentante(resultSet.getString("RFCRepresentante"));
					parametrosSisBean.setMonedaBaseID(resultSet.getString("MonedaBaseID"));

					parametrosSisBean.setMonedaExtrangeraID(resultSet.getString("MonedaExtrangeraID"));
					parametrosSisBean.setTasaISR(resultSet.getString("TasaISR"));
					parametrosSisBean.setTasaIDE(resultSet.getString("TasaIDE"));
					parametrosSisBean.setMontoExcIDE(resultSet.getString("MontoExcIDE"));
					parametrosSisBean.setEjercicioVigente(resultSet.getString("EjercicioVigente"));

					parametrosSisBean.setPeriodoVigente(resultSet.getString("PeriodoVigente"));
					parametrosSisBean.setDiasInversion(resultSet.getString("DiasInversion"));
					parametrosSisBean.setDiasCredito(resultSet.getString("DiasCredito"));
					parametrosSisBean.setDiasCambioPass(resultSet.getString("DiasCambioPass"));
					parametrosSisBean.setLonMinCaracPass(resultSet.getString("LonMinCaracPass"));

					parametrosSisBean.setClienteInstitucion(resultSet.getString("ClienteInstitucion"));
					parametrosSisBean.setCuentaInstituc(resultSet.getString("CuentaInstituc"));
					parametrosSisBean.setManejaCaptacion(resultSet.getString("ManejaCaptacion"));
					parametrosSisBean.setBancoCaptacion(resultSet.getString("BancoCaptacion"));
					parametrosSisBean.setTipoCuenta(resultSet.getString("TipoCuenta"));

					parametrosSisBean.setRutaArchivos(resultSet.getString("RutaArchivos"));
					parametrosSisBean.setRolTesoreria(resultSet.getString("RolTesoreria"));
					parametrosSisBean.setRolAdminTeso(resultSet.getString("RolAdminTeso"));
					parametrosSisBean.setOficialCumID(resultSet.getString("OficialCumID"));
					parametrosSisBean.setDirGeneralID(resultSet.getString("DirGeneralID"));

					parametrosSisBean.setDirOperID(resultSet.getString("DirOperID"));
					parametrosSisBean.setTipoCtaGLAdi(resultSet.getString("TipoCtaGLAdi"));
					parametrosSisBean.setRutaArchivosPLD(resultSet.getString("RutaArchivosPLD"));
					parametrosSisBean.setRemitente(resultSet.getString("Remitente"));
					parametrosSisBean.setServidorCorreo(resultSet.getString("ServidorCorreo"));

					parametrosSisBean.setPuerto(resultSet.getString("Puerto"));
					parametrosSisBean.setUsuarioCorreo(resultSet.getString("UsuarioCorreo"));
					parametrosSisBean.setContrasenia(resultSet.getString("Contrasenia"));
					parametrosSisBean.setCtaIniGastoEmp(resultSet.getString("CtaIniGastoEmp"));
					parametrosSisBean.setCtaFinGastoEmp(resultSet.getString("CtaFinGastoEmp"));

					parametrosSisBean.setImpTicket(resultSet.getString("ImpTicket"));
					parametrosSisBean.setTipoImpTicket(resultSet.getString("TipoImpTicket"));
					parametrosSisBean.setMontoAportacion(resultSet.getString("MontoAportacion"));
					parametrosSisBean.setReqAportacionSo(resultSet.getString("ReqAportacionSo"));
					parametrosSisBean.setMontoPolizaSegA(resultSet.getString("MontoPolizaSegA"));

					parametrosSisBean.setMontoSegAyuda(resultSet.getString("MontoSegAyuda"));
					parametrosSisBean.setCuentasCapConta(resultSet.getString("CuentasCapConta"));
					parametrosSisBean.setLonMinPagRemesa(resultSet.getString("LonMinPagRemesa"));
					parametrosSisBean.setLonMaxPagRemesa(resultSet.getString("LonMaxPagRemesa"));
					parametrosSisBean.setLonMinPagOport(resultSet.getString("LonMinPagOport"));

					parametrosSisBean.setLonMaxPagOport(resultSet.getString("LonMaxPagOport"));
					parametrosSisBean.setSalMinDF(resultSet.getString("SalMinDF"));
					parametrosSisBean.setImpSaldoCred(resultSet.getString("ImpSaldoCred"));
					parametrosSisBean.setImpSaldoCta(resultSet.getString("ImpSaldoCta"));
					parametrosSisBean.setNombreJefeCobranza(resultSet.getString("NombreJefeCobranza"));

					parametrosSisBean.setNomJefeOperayPromo(resultSet.getString("NomJefeOperayPromo"));
					parametrosSisBean.setGerenteGeneral(resultSet.getString("GerenteGeneral"));
					parametrosSisBean.setPresidenteConsejo(resultSet.getString("PresidenteConsejo"));
					parametrosSisBean.setJefeContabilidad(resultSet.getString("JefeContabilidad"));

					parametrosSisBean.setVigDiasSeguro(resultSet.getString("VigDiasSeguro"));
					parametrosSisBean.setVencimAutoSeg(resultSet.getString("VencimAutoSeg"));
					parametrosSisBean.setEstadoEmpresa(resultSet.getString("EstadoEmpresa"));
					parametrosSisBean.setMunicipioEmpresa(resultSet.getString("MunicipioEmpresa"));
					parametrosSisBean.setLocalidadEmpresa(resultSet.getString("LocalidadEmpresa"));

					// Parametros de facturacion electronica obtenidos de la BD
					parametrosSisBean.setColoniaEmpresa(resultSet.getString("ColoniaEmpresa"));
					parametrosSisBean.setCalleEmpresa(resultSet.getString("CalleEmpresa"));
					parametrosSisBean.setNumIntEmpresa(resultSet.getString("NumIntEmpresa"));
					parametrosSisBean.setNumExtEmpresa(resultSet.getString("NumExtEmpresa"));
					parametrosSisBean.setCPEmpresa(resultSet.getString("CPEmpresa"));

					parametrosSisBean.setDirFiscal(resultSet.getString("DirFiscal"));
					parametrosSisBean.setRfcEmpresa(resultSet.getString("RFC"));
					parametrosSisBean.setTimbraEdoCta(resultSet.getString("TimbraEdoCta"));
					parametrosSisBean.setGeneraCFDINoReg(resultSet.getString("GeneraCFDINoReg"));
					parametrosSisBean.setGeneraEdoCtaAuto(resultSet.getString("GeneraEdoCtaAuto"));

					parametrosSisBean.setAplCobPenCieDia(resultSet.getString("AplCobPenCieDia"));
					parametrosSisBean.setFechaUltimoComite(resultSet.getString("FecUltConsejoAdmon"));
					parametrosSisBean.setFoliosAutActaComite(resultSet.getString("FoliosActasComite"));
					parametrosSisBean.setServReactivaCliID(resultSet.getString("ServReactivaCte"));// Servicio de reactivacion de cliente
					parametrosSisBean.setCtaContaSobrante(resultSet.getString("CtaContaSobrante"));
					parametrosSisBean.setCtaContaFaltante(resultSet.getString("CtaContaFaltante"));

					parametrosSisBean.setCalifAutoCliente(resultSet.getString("CalifAutoCliente"));
					parametrosSisBean.setCtaContaDocSBCA(resultSet.getString("CtaContaDocSBCA"));
					parametrosSisBean.setCtaContaDocSBCD(resultSet.getString("CtaContaDocSBCD"));
					parametrosSisBean.setAfectaContaRecSBC(resultSet.getString("AfectaContaRecSBC"));
					parametrosSisBean.setContabilidadGL(resultSet.getString("ContabilidadGL"));
					parametrosSisBean.setDiasVigenciaBC(resultSet.getString("DiasVigenciaBC"));
					parametrosSisBean.setCenCostosChequesSBC(resultSet.getString("CenCostosChequeSBC")); // consulta el centro de costos de cheque SBC
					parametrosSisBean.setMostrarSaldDisCtaYSbc(resultSet.getString("MostrarSaldDisCtaYSbc"));
					parametrosSisBean.setValidaAutComite(resultSet.getString("ValidaAutComite"));

					parametrosSisBean.setExtTelefonoLocal(resultSet.getString("ExtTelefonoLocal"));
					parametrosSisBean.setExtTelefonoInt(resultSet.getString("ExtTelefonoInt"));

					parametrosSisBean.setTipoContaMora(resultSet.getString("TipoContaMora"));
					parametrosSisBean.setDivideIngresoInteres(resultSet.getString("DivideIngresoInteres"));
					parametrosSisBean.setEstCreAltInvGar(resultSet.getString("EstCreAltInvGar"));
					parametrosSisBean.setFuncionHuella(resultSet.getString("FuncionHuella"));
					parametrosSisBean.setConBuroCreDefaut(resultSet.getString("ConBuroCreDefaut"));
					parametrosSisBean.setAbreviaturaCirculo(resultSet.getString("AbreviaturaCirculo"));
					parametrosSisBean.setReqhuellaProductos(resultSet.getString("ReqHuellaProductos"));
					parametrosSisBean.setCancelaAutMenor(resultSet.getString("CancelaAutMenor"));
					parametrosSisBean.setActivaPromotorCapta(resultSet.getString("ActivaPromotorCapta"));
					parametrosSisBean.setCambiaPromotor(resultSet.getString("CambiaPromotor"));
					parametrosSisBean.setMostrarPrefijo(resultSet.getString("MostrarPrefijo"));
					parametrosSisBean.setTesoMovsCieMes(resultSet.getString("TesoMovsCieMes"));
					parametrosSisBean.setChecListCte(resultSet.getString("ChecListCte"));
					parametrosSisBean.setTarjetaIdentiSocio(resultSet.getString("TarjetaIdentiSocio"));
					parametrosSisBean.setCancelaAutSolCre(resultSet.getString("CancelaAutSolCre"));
					parametrosSisBean.setDiasCancelaAutSolCre(resultSet.getString("DiasCancelaAutSolCre"));
					parametrosSisBean.setNumTratamienCre(resultSet.getString("NumTratamienCre"));
					parametrosSisBean.setCapitalCubierto(resultSet.getString("CapitalCubierto"));
					parametrosSisBean.setPagoIntVertical(resultSet.getString("PagoIntVertical"));
					parametrosSisBean.setNumMaxDiasMora(resultSet.getString("NumMaxDiasMora"));
					parametrosSisBean.setImpFomatosInd(resultSet.getString("ImpFomatosInd"));
					parametrosSisBean.setSistemasID(resultSet.getString("SistemasID"));
					parametrosSisBean.setRutaNotifiCobranza(resultSet.getString("RutaNotifiCobranza"));
					parametrosSisBean.setReqValidaCred(resultSet.getString("ReqValidaCred"));
					parametrosSisBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
					parametrosSisBean.setTipoDocumentoID(resultSet.getString("TipoDocumentoFirma"));
					parametrosSisBean.setPerfilWsVbc(resultSet.getString("PerfilWsVbc"));
					parametrosSisBean.setReestCalendarioVen(resultSet.getString("ReestCalVenc"));
					parametrosSisBean.setValidaEstatusRees(resultSet.getString("EstValReest"));
					parametrosSisBean.setTipoDetRecursos(resultSet.getString("TipoDetRecursos"));
					parametrosSisBean.setCalculaCURPyRFC(resultSet.getString("CalculaCURPyRFC"));
					parametrosSisBean.setManejaCarAgro(resultSet.getString("ManejaCarteraAgro"));
					parametrosSisBean.setSalMinDFReal(resultSet.getString("SalMinDFReal"));


					parametrosSisBean.setEvaluacionMatriz(resultSet.getString("EvaluacionMatriz"));
					parametrosSisBean.setFrecuenciaMensual(resultSet.getString("FrecuenciaMensual"));

					parametrosSisBean.setEvaluaRiesgoComun(resultSet.getString("EvaluaRiesgoComun"));
					parametrosSisBean.setCapitalContNeto(resultSet.getString("CapitalContableNeto"));
					parametrosSisBean.setFechaEvaluacionMatriz(resultSet.getString("FechaEvaluacionMatriz"));
					parametrosSisBean.setActPerfilTransOpe(resultSet.getString("ActPerfilTransOpe"));
					parametrosSisBean.setFrecuenciaMensPerf(resultSet.getString("FrecuenciaMensPerf"));
					parametrosSisBean.setFechaActPerfil(resultSet.getString("FechaActPerfil"));
					parametrosSisBean.setPorcCoincidencias(resultSet.getString("PorcCoincidencias"));
					parametrosSisBean.setValidarVigDomi(resultSet.getString("ValidarVigDomi"));
					parametrosSisBean.setTipoDocDomID(resultSet.getString("TipoDocDomID"));
					parametrosSisBean.setFecVigenDomicilio(resultSet.getString("FecVigenDomicilio"));
					parametrosSisBean.setModNivelRiesgo(resultSet.getString("ModNivelRiesgo"));
					parametrosSisBean.setCobranzaAutCie(resultSet.getString("CobranzaAutCierre"));
					parametrosSisBean.setCobroCompletoAut(resultSet.getString("CobroCompletoAut"));
					parametrosSisBean.setCapitalCubiertoReac(resultSet.getString("CapitalCubiertoReac"));
					parametrosSisBean.setPorcPersonaFisica(resultSet.getString("PorcPersonaFisica"));
					parametrosSisBean.setPorcPersonaMoral(resultSet.getString("PorcPersonaMoral"));
					parametrosSisBean.setPermitirMultDisp(resultSet.getString("PermitirMultDisp"));
					parametrosSisBean.setCobranzaxReferencia(resultSet.getString("CobranzaxReferencia"));

					parametrosSisBean.setFechaConsDisp(resultSet.getString("FechaConsDisp"));
					parametrosSisBean.setActPerfilTransOpeMas(resultSet.getString("ActPerfilTransOpeMas"));
					parametrosSisBean.setNumEvalPerfilTrans(resultSet.getString("NumEvalPerfilTrans"));
					parametrosSisBean.setInvPagoPeriodico(resultSet.getString("InvPagoPeriodico"));

					//aportaciones
					parametrosSisBean.setPerfilAutEspAport(resultSet.getString("PerfilAutEspAport"));
					//cambios en carta de liquidacion
					parametrosSisBean.setPerfilCamCarLiqui(resultSet.getString("PerfilCamCarLiqui"));
					// Círculo y Buró de Crédito
					parametrosSisBean.setInstitucionCirculoCredito(resultSet.getString("InstitucionCirculoCredito"));
					parametrosSisBean.setClaveEntidadCirculo(resultSet.getString("ClaveEntidadCirculo"));
					parametrosSisBean.setReportarTotalIntegrantes(resultSet.getString("ReportarTotalIntegrantes"));

					parametrosSisBean.setDirectorFinanzas(resultSet.getString("DirectorFinanzas"));
					parametrosSisBean.setValidaFactura(resultSet.getString("ValidaFactura"));
					parametrosSisBean.setValidaFacturaURL(resultSet.getString("ValidaFacturaURL"));
					parametrosSisBean.setTiempoEsperaWS(resultSet.getString("TiempoEsperaWS"));
					parametrosSisBean.setNumTratamienCreRees(resultSet.getString("NumTratamienCreRees"));
					parametrosSisBean.setRestringeReporte(resultSet.getString("RestringeReporte"));
					parametrosSisBean.setCamFuenFonGarFira(resultSet.getString("CamFuenFonGarFira"));
					parametrosSisBean.setPersonNoDeseadas(resultSet.getString("PersonNoDeseadas"));
					parametrosSisBean.setOcultaBtnRechazoSol(resultSet.getString("OcultaBtnRechazoSol"));
					parametrosSisBean.setRestringebtnLiberacionSol(resultSet.getString("RestringebtnLiberacionSol"));
					parametrosSisBean.setPrimerRolFlujoSolID(resultSet.getString("PrimerRolFlujoSolID"));
					parametrosSisBean.setSegundoRolFlujoSolID(resultSet.getString("SegundoRolFlujoSolID"));
					parametrosSisBean.setVecesSalMinVig(resultSet.getString("VecesSalMinVig"));

					// Param Config Contrasenia
					parametrosSisBean.setCaracterMinimo(resultSet.getString("CaracterMinimo"));
					parametrosSisBean.setCaracterMayus(resultSet.getString("CaracterMayus"));
					parametrosSisBean.setCaracterMinus(resultSet.getString("CaracterMinus"));
					parametrosSisBean.setCaracterNumerico(resultSet.getString("CaracterNumerico"));
					parametrosSisBean.setCaracterEspecial(resultSet.getString("CaracterEspecial"));
					parametrosSisBean.setUltimasContra(resultSet.getString("UltimasContra"));
					parametrosSisBean.setDiaMaxCamContra(resultSet.getString("DiaMaxCamContra"));
					parametrosSisBean.setDiaMaxInterSesion(resultSet.getString("DiaMaxInterSesion"));
					parametrosSisBean.setNumIntentos(resultSet.getString("NumIntentos"));
					parametrosSisBean.setNumDiaBloq(resultSet.getString("NumDiaBloq"));
					parametrosSisBean.setReqCaracterMayus(resultSet.getString("ReqCaracterMayus"));
					parametrosSisBean.setReqCaracterMinus(resultSet.getString("ReqCaracterMinus"));
					parametrosSisBean.setReqCaracterNumerico(resultSet.getString("ReqCaracterNumerico"));
					parametrosSisBean.setReqCaracterEspecial(resultSet.getString("ReqCaracterEspecial"));
					parametrosSisBean.setHabilitaConfPass(resultSet.getString("HabilitaConfPass"));

					//PARAMETROS DE CONFIGURACION DE CORREO
					parametrosSisBean.setAlerVerificaConvenio(resultSet.getString("AlerVerificaConvenio"));
					parametrosSisBean.setNoDiasAntEnvioCorreo(resultSet.getString("NoDiasAntEnvioCorreo"));
					parametrosSisBean.setCorreoRemitente(resultSet.getString("CorreoRemitente"));
					parametrosSisBean.setCorreoAdiDestino(resultSet.getString("CorreoAdiDestino"));
					parametrosSisBean.setRemitenteID(resultSet.getString("RemitenteID"));
					parametrosSisBean.setClabeInstitBancaria(resultSet.getString("ClabeInstitBancaria"));

					parametrosSisBean.setValidarEtiqCambFond(resultSet.getString("ValidarEtiqCambFond"));
					parametrosSisBean.setUnificaCI(resultSet.getString("UnificaCI"));
					parametrosSisBean.setOrigenReplica(resultSet.getString("OrigenReplica"));
					parametrosSisBean.setReplicaAct(resultSet.getString("ReplicaAct"));
					parametrosSisBean.setRemitenteCierreID(resultSet.getString("RemitenteCierreID"));
					parametrosSisBean.setCorreoRemitenteCierre(resultSet.getString("CorreoRemCierre"));
					parametrosSisBean.setZonaHoraria(resultSet.getString("ZonaHoraria"));
					parametrosSisBean.setEjecDepreAmortiAut(resultSet.getString("EjecDepreAmortiAut"));
					parametrosSisBean.setValidaRef(resultSet.getString("ValidaReferencia"));
					parametrosSisBean.setAplicaGarAdiPagoCre(resultSet.getString("AplicaGarAdiPagoCre"));
					parametrosSisBean.setValidaCapitalConta(resultSet.getString("ValidaCapitalConta"));
					parametrosSisBean.setPorMaximoDeposito(resultSet.getString("PorMaximoDeposito"));
					parametrosSisBean.setMostrarBtnResumen(resultSet.getString("MostrarBtnResumen"));
					parametrosSisBean.setValidaCicloGrupo(resultSet.getString("ValidaCicloGrupo"));
					return parametrosSisBean;

				}// trows ecexeption
			});//lista

			parametrosSisBean = matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de parametros de sistema", e);
		}
		return parametrosSisBean;
	}// consultaPrincipal

public ParametrosSisBean consultaPrincipalWS(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		//Query con el Store Procedure
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";

		Object[] parametros = { parametrosSis.getEmpresaID(),
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion

loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setEmpresaID(resultSet.getString("EmpresaID"));
				parametrosSisBean.setFechaSistema(resultSet.getString("FechaSistema"));
				parametrosSisBean.setSucursalMatrizID(resultSet.getString("SucursalMatrizID"));
				parametrosSisBean.setTelefonoLocal(resultSet.getString("TelefonoLocal"));
				parametrosSisBean.setTelefonoInterior(resultSet.getString("TelefonoInterior"));

				parametrosSisBean.setInstitucionID(resultSet.getString("InstitucionID"));
				parametrosSisBean.setEmpresaDefault(resultSet.getString("EmpresaDefault"));
				parametrosSisBean.setNombreRepresentante(resultSet.getString("NombreRepresentante"));
				parametrosSisBean.setRFCRepresentante(resultSet.getString("RFCRepresentante"));
				parametrosSisBean.setMonedaBaseID(resultSet.getString("MonedaBaseID"));

				parametrosSisBean.setMonedaExtrangeraID(resultSet.getString("MonedaExtrangeraID"));
				parametrosSisBean.setTasaISR(resultSet.getString("TasaISR"));
				parametrosSisBean.setTasaIDE(resultSet.getString("TasaIDE"));
				parametrosSisBean.setMontoExcIDE(resultSet.getString("MontoExcIDE"));
				parametrosSisBean.setEjercicioVigente(resultSet.getString("EjercicioVigente"));

				parametrosSisBean.setPeriodoVigente(resultSet.getString("PeriodoVigente"));
				parametrosSisBean.setDiasInversion(resultSet.getString("DiasInversion"));
				parametrosSisBean.setDiasCredito(resultSet.getString("DiasCredito"));
				parametrosSisBean.setDiasCambioPass(resultSet.getString("DiasCambioPass"));
				parametrosSisBean.setLonMinCaracPass(resultSet.getString("LonMinCaracPass"));

				parametrosSisBean.setClienteInstitucion(resultSet.getString("ClienteInstitucion"));
				parametrosSisBean.setCuentaInstituc(resultSet.getString("CuentaInstituc"));
				parametrosSisBean.setManejaCaptacion(resultSet.getString("ManejaCaptacion"));
				parametrosSisBean.setBancoCaptacion(resultSet.getString("BancoCaptacion"));
				parametrosSisBean.setTipoCuenta(resultSet.getString("TipoCuenta"));

				parametrosSisBean.setRutaArchivos(resultSet.getString("RutaArchivos"));
				parametrosSisBean.setRolTesoreria(resultSet.getString("RolTesoreria"));
				parametrosSisBean.setRolAdminTeso(resultSet.getString("RolAdminTeso"));
				parametrosSisBean.setOficialCumID(resultSet.getString("OficialCumID"));
				parametrosSisBean.setDirGeneralID(resultSet.getString("DirGeneralID"));

				parametrosSisBean.setDirOperID(resultSet.getString("DirOperID"));
				parametrosSisBean.setTipoCtaGLAdi(resultSet.getString("TipoCtaGLAdi"));
				parametrosSisBean.setRutaArchivosPLD(resultSet.getString("RutaArchivosPLD"));
				parametrosSisBean.setRemitente(resultSet.getString("Remitente"));
				parametrosSisBean.setServidorCorreo(resultSet.getString("ServidorCorreo"));

				parametrosSisBean.setPuerto(resultSet.getString("Puerto"));
				parametrosSisBean.setUsuarioCorreo(resultSet.getString("UsuarioCorreo"));
				parametrosSisBean.setContrasenia(resultSet.getString("Contrasenia"));
				parametrosSisBean.setCtaIniGastoEmp(resultSet.getString("CtaIniGastoEmp"));
				parametrosSisBean.setCtaFinGastoEmp(resultSet.getString("CtaFinGastoEmp"));

				parametrosSisBean.setImpTicket(resultSet.getString("ImpTicket"));
				parametrosSisBean.setTipoImpTicket(resultSet.getString("TipoImpTicket"));
				parametrosSisBean.setMontoAportacion(resultSet.getString("MontoAportacion"));
				parametrosSisBean.setReqAportacionSo(resultSet.getString("ReqAportacionSo"));
				parametrosSisBean.setMontoPolizaSegA(resultSet.getString("MontoPolizaSegA"));

				parametrosSisBean.setMontoSegAyuda(resultSet.getString("MontoSegAyuda"));
				parametrosSisBean.setCuentasCapConta(resultSet.getString("CuentasCapConta"));
				parametrosSisBean.setLonMinPagRemesa(resultSet.getString("LonMinPagRemesa"));
				parametrosSisBean.setLonMaxPagRemesa(resultSet.getString("LonMaxPagRemesa"));
				parametrosSisBean.setLonMinPagOport(resultSet.getString("LonMinPagOport"));

				parametrosSisBean.setLonMaxPagOport(resultSet.getString("LonMaxPagOport"));
				parametrosSisBean.setSalMinDF(resultSet.getString("SalMinDF"));
				parametrosSisBean.setImpSaldoCred(resultSet.getString("ImpSaldoCred"));
				parametrosSisBean.setImpSaldoCta(resultSet.getString("ImpSaldoCta"));
				parametrosSisBean.setNombreJefeCobranza(resultSet.getString("NombreJefeCobranza"));

				parametrosSisBean.setNomJefeOperayPromo(resultSet.getString("NomJefeOperayPromo"));
				parametrosSisBean.setGerenteGeneral(resultSet.getString("GerenteGeneral"));
				parametrosSisBean.setPresidenteConsejo(resultSet.getString("PresidenteConsejo"));
				parametrosSisBean.setJefeContabilidad(resultSet.getString("JefeContabilidad"));

				parametrosSisBean.setVigDiasSeguro(resultSet.getString("VigDiasSeguro"));
				parametrosSisBean.setVencimAutoSeg(resultSet.getString("VencimAutoSeg"));
				parametrosSisBean.setEstadoEmpresa(resultSet.getString("EstadoEmpresa"));
				parametrosSisBean.setMunicipioEmpresa(resultSet.getString("MunicipioEmpresa"));
				parametrosSisBean.setLocalidadEmpresa(resultSet.getString("LocalidadEmpresa"));

				// Parametros de facturacion electronica obtenidos de la BD
				parametrosSisBean.setColoniaEmpresa(resultSet.getString("ColoniaEmpresa"));
				parametrosSisBean.setCalleEmpresa(resultSet.getString("CalleEmpresa"));
				parametrosSisBean.setNumIntEmpresa(resultSet.getString("NumIntEmpresa"));
				parametrosSisBean.setNumExtEmpresa(resultSet.getString("NumExtEmpresa"));
				parametrosSisBean.setCPEmpresa(resultSet.getString("CPEmpresa"));

				parametrosSisBean.setDirFiscal(resultSet.getString("DirFiscal"));
				parametrosSisBean.setRfcEmpresa(resultSet.getString("RFC"));
				parametrosSisBean.setTimbraEdoCta(resultSet.getString("TimbraEdoCta"));
				parametrosSisBean.setGeneraCFDINoReg(resultSet.getString("GeneraCFDINoReg"));
				parametrosSisBean.setGeneraEdoCtaAuto(resultSet.getString("GeneraEdoCtaAuto"));

				parametrosSisBean.setAplCobPenCieDia(resultSet.getString("AplCobPenCieDia"));
				parametrosSisBean.setFechaUltimoComite(resultSet.getString("FecUltConsejoAdmon"));
				parametrosSisBean.setFoliosAutActaComite(resultSet.getString("FoliosActasComite"));
				parametrosSisBean.setServReactivaCliID(resultSet.getString("ServReactivaCte"));// Servicio de reactivacion de cliente
				parametrosSisBean.setCtaContaSobrante(resultSet.getString("CtaContaSobrante"));
				parametrosSisBean.setCtaContaFaltante(resultSet.getString("CtaContaFaltante"));

				parametrosSisBean.setCalifAutoCliente(resultSet.getString("CalifAutoCliente"));
				parametrosSisBean.setCtaContaDocSBCA(resultSet.getString("CtaContaDocSBCA"));
				parametrosSisBean.setCtaContaDocSBCD(resultSet.getString("CtaContaDocSBCD"));
				parametrosSisBean.setAfectaContaRecSBC(resultSet.getString("AfectaContaRecSBC"));
				parametrosSisBean.setContabilidadGL(resultSet.getString("ContabilidadGL"));
				parametrosSisBean.setDiasVigenciaBC(resultSet.getString("DiasVigenciaBC"));
				parametrosSisBean.setCenCostosChequesSBC(resultSet.getString("CenCostosChequeSBC")); // consulta el centro de costos de cheque SBC
				parametrosSisBean.setMostrarSaldDisCtaYSbc(resultSet.getString("MostrarSaldDisCtaYSbc"));
				parametrosSisBean.setValidaAutComite(resultSet.getString("ValidaAutComite"));

				parametrosSisBean.setExtTelefonoLocal(resultSet.getString("ExtTelefonoLocal"));
				parametrosSisBean.setExtTelefonoInt(resultSet.getString("ExtTelefonoInt"));

				parametrosSisBean.setTipoContaMora(resultSet.getString("TipoContaMora"));
				parametrosSisBean.setDivideIngresoInteres(resultSet.getString("DivideIngresoInteres"));
				parametrosSisBean.setEstCreAltInvGar(resultSet.getString("EstCreAltInvGar"));
				parametrosSisBean.setFuncionHuella(resultSet.getString("FuncionHuella"));
				parametrosSisBean.setConBuroCreDefaut(resultSet.getString("ConBuroCreDefaut"));
				parametrosSisBean.setAbreviaturaCirculo(resultSet.getString("AbreviaturaCirculo"));
				parametrosSisBean.setReqhuellaProductos(resultSet.getString("ReqHuellaProductos"));
				parametrosSisBean.setCancelaAutMenor(resultSet.getString("CancelaAutMenor"));
				parametrosSisBean.setActivaPromotorCapta(resultSet.getString("ActivaPromotorCapta"));
				parametrosSisBean.setCambiaPromotor(resultSet.getString("CambiaPromotor"));
				parametrosSisBean.setMostrarPrefijo(resultSet.getString("MostrarPrefijo"));
				parametrosSisBean.setClaveNivInstitucion(resultSet.getString("ClaveNivInstitucion"));

				return parametrosSisBean;

			}// trows ecexeption
		});//lista



		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros de sistema", e);
	}
	return parametrosSisBean;
}// consultaPrincipal

/* Consuta parametros de Estado de Cuenta y Constancias de Retenciones */
public ParametrosSisBean consultaEdoCtaCons(ParametrosSisBean parametrosSis, int tipoConsulta) {
	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		//Query con el Store Procedure
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";

		Object[] parametros = { Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setEmpresaID(resultSet.getString("EmpresaID"));
				parametrosSisBean.setUsuarioFactElect(resultSet.getString("UsuarioFactElec"));
				parametrosSisBean.setPassFactElec(resultSet.getString("PassFactElec"));
				parametrosSisBean.setInstitucionID(resultSet.getString("InstitucionID"));
				parametrosSisBean.setRfcEmpresa(resultSet.getString("RFC"));
				parametrosSisBean.setTimbraEdoCta(resultSet.getString("TimbraEdoCta"));
				parametrosSisBean.setUrlWSDLFactElec(resultSet.getString("RutaWSDL"));
				parametrosSisBean.setTimbraConsRet(resultSet.getString("TimbraConsRet"));
				parametrosSisBean.setProveedorTimbrado(resultSet.getString("ProveedorTimbrado"));
				return parametrosSisBean;
			}
		});

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de parametros de estado de Cuenta en ParametrosSisCon", e);
	}
	return parametrosSisBean;
}


/* Consuta por Llave Principal */
public ParametrosSisBean verTimbrado(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		//Query con el Store Procedure
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { parametrosSis.getEmpresaID(),
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setTimbraEdoCta(resultSet.getString("TimbraEdoCta"));
				return parametrosSisBean;

			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de parametros de sistema", e);
	}
	return parametrosSisBean;
}// consultaPrincipal




/* Consuta por Llave Principal */
public ParametrosSisBean consultaFechaHoraWS(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setFechaSistema(resultSet.getString("FechaSistema"));
				return parametrosSisBean;

			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
	}
	return parametrosSisBean;
}// fin de consulta


/* Consuta por Llave Principal */
public ParametrosSisBean consultaRepresentanteLegal(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setNombreRepresentante(resultSet.getString("NombreRepresentante"));
				parametrosSisBean.setRFCRepresentante(resultSet.getString("RFCRepresentante"));
				parametrosSisBean.setRazonSocial(resultSet.getString("Nombre"));
				parametrosSisBean.setRfcInstitucion(resultSet.getString("RFC"));
				return parametrosSisBean;

			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
	}
	return parametrosSisBean;
}// fin de consulta



/* Consuta parametros Validacion CFDI */
public ParametrosSisBean consultaParametroValidaCFDI(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { parametrosSis.getEmpresaID(),
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setValidaFactura(resultSet.getString("ValidaFactura"));
				parametrosSisBean.setValidaFacturaURL(resultSet.getString("ValidaFacturaURL"));
				parametrosSisBean.setTiempoEsperaWS(resultSet.getString("TiempoEsperaWS"));
				return parametrosSisBean;

			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
	}
	return parametrosSisBean;
}// fin de consulta

	/* Lista de parametros EmpresaID y InstitucionID */
	public List listaPrincipal(ParametrosSisBean parametrosSisBean, int tipoLista) {
		//Query con el Store Procedure

		String query = "call PARAMETROSSISLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	parametrosSisBean.getEmpresaID(),
								parametrosSisBean.getNombreInstitucion(),
								tipoLista,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSisBean parametrosSisbean = new ParametrosSisBean();
				parametrosSisbean.setEmpresaID(resultSet.getString("EmpresaID"));
				parametrosSisbean.setNombreInstitucion(resultSet.getString("Nombre"));
				return parametrosSisbean;
			}
		});
		return matches;
	}


	/* Lista de parametros EmpresaID y InstitucionID */
	public List listaRepresentLegal(ParametrosSisBean parametrosSisBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PARAMETROSSISLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	parametrosSisBean.getEmpresaID(),
								parametrosSisBean.getNombreRepresentante(),
								tipoLista,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSisBean parametrosSisbean = new ParametrosSisBean();
				parametrosSisbean.setNombreRepresentante(resultSet.getString("NombreRepresentante"));
				parametrosSisbean.setNombreInstitucion(resultSet.getString("NombreCorto"));
				return parametrosSisbean;
			}
		});
		return matches;
	}

	public ParametrosSisBean consultaFechaAnterior(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = { Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setFechaSistema(resultSet.getString("FechaSistema"));
					parametrosSisBean.setHoraSistema(resultSet.getString("HoraSistema"));
					return parametrosSisBean;

				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
		}
		return parametrosSisBean;
	}// fin de consulta


	public ParametrosSisBean consultaDatosCte(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = { Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setValidaClaveKey(resultSet.getString(1));
					parametrosSisBean.setNombreCortoInst(resultSet.getString(2));
					parametrosSisBean.setNombreInstitucion(resultSet.getString(3));
					return parametrosSisBean;
				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos de validacion claves sistema", e);
		}
		return parametrosSisBean;
	}// fin de consulta


	public ParametrosSisBean consultaDatosCteExterna(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = { Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosSis.getRutaArchivos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setValidaClaveKey(resultSet.getString(1));
					parametrosSisBean.setNombreCortoInst(resultSet.getString(2));
					parametrosSisBean.setNombreInstitucion(resultSet.getString(3));
					return parametrosSisBean;
				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos de validacion claves sistema", e);
		}
		return parametrosSisBean;
	}// fin de consulta






/* Consuta si se cambia el promotor en solicitud de credito */
public ParametrosSisBean consultaCambiaPromotor(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
				parametrosSisBean.setCambiaPromotor(resultSet.getString("CambiaPromotor"));
				return parametrosSisBean;

			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
	}
	return parametrosSisBean;
  }// fin de consulta

	/* Consulta el tipo de institucion financiera */
	public ParametrosSisBean consultaTipoInstFin(ParametrosSisBean parametrosSis,int tipoConsulta) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?,?,?," +
												"?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,	// aud_usuario
					Constantes.FECHA_VACIA, // fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO,// programaID
					Constantes.ENTERO_CERO,	// sucursal
					Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setTipoInstitID(resultSet.getString("TipoInstitID"));
					parametrosSisBean.setNombreCortoInst(resultSet.getString("NombreCorto"));
					return parametrosSisBean;
				}
			});
			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
		}
		return parametrosSisBean;
	}// fin de consulta

	/**
	 * Consulta para traer los parametros que habilitan secciones especificas
	 * @param parametrosSis es el bean ParametrosSisBean
	 * @param tipoConsulta solo consulta 16
	 * @return
	 */
	public ParametrosSisBean consultaParamSeccionEsp(ParametrosSisBean parametrosSis,int tipoConsulta) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?,?,?," +
												"?,?,?,?);";
			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,	// aud_usuario
					Constantes.FECHA_VACIA, // fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO,// programaID
					Constantes.ENTERO_CERO,	// sucursal
					Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
					return parametrosSisBean;
				}
			});
			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de fecha y hora del sistema", e);
		}
		return parametrosSisBean;
	}// fin de consulta

	/**
	 * Consulta para saber si se mostraran los botones de calcular CURP y RFC
	 * @param parametrosSis es el bean ParametrosSisBean
	 * @param tipoConsulta solo consulta 17
	 * @return
	 */
	public ParametrosSisBean consultaCalculaCURPyRFC(ParametrosSisBean parametrosSis,int tipoConsulta) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?,?,?," +
												"?,?,?,?);";
			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,	// aud_usuario
					Constantes.FECHA_VACIA, // fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO,// programaID
					Constantes.ENTERO_CERO,	// sucursal
					Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setCalculaCURPyRFC(resultSet.getString("CalculaCURPyRFC"));
					return parametrosSisBean;
				}
			});
			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta parametros calcular CURP y RFC", e);
		}
		return parametrosSisBean;
	}// fin de consulta

	/**
	 * Método que realiza la actualizacion de los parametros PLD
	 * @param parametrosSisBean : {@link ParametrosSisBean} Bean con la informacion de pantalla
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean actualizacionPLD(final ParametrosSisBean parametrosSisBean, final int numActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSPLDACT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NumAct", numActualizacion);
							sentenciaStore.setInt("Par_EmpresaID", Utileria.convierteEntero(parametrosSisBean.getEmpresaID()));
							sentenciaStore.setString("Par_EvaluacionMatriz", parametrosSisBean.getEvaluacionMatriz());
							sentenciaStore.setInt("Par_FrecuenciaMensual", Utileria.convierteEntero(parametrosSisBean.getFrecuenciaMensual()));
							sentenciaStore.setString("Par_ActPerfilTransOpe", parametrosSisBean.getActPerfilTransOpe());
							sentenciaStore.setInt("Par_FrecuenciaMensPerf", Utileria.convierteEntero(parametrosSisBean.getFrecuenciaMensPerf()));

							sentenciaStore.setDouble("Par_PorcCoincidencias", Utileria.convierteDoble(parametrosSisBean.getPorcCoincidencias()));
							sentenciaStore.setString("Par_ValidarVigDomi", parametrosSisBean.getValidarVigDomi());
							sentenciaStore.setInt("Par_FecVigenDomicilio", Utileria.convierteEntero(parametrosSisBean.getFecVigenDomicilio()));
							sentenciaStore.setInt("Par_TipoDocDomID", Utileria.convierteEntero(parametrosSisBean.getTipoDocDomID()));
							sentenciaStore.setString("Par_ModNivelRiesgo", parametrosSisBean.getModNivelRiesgo());
							sentenciaStore.setString("Par_ActPerfilTransOpeMas", parametrosSisBean.getActPerfilTransOpeMas());
							sentenciaStore.setInt("Par_NumEvalPerfilTrans", Utileria.convierteEntero(parametrosSisBean.getNumEvalPerfilTrans()));

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

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PARAMETROSPLDACT(" + sentenciaStore.toString() + ")");
							return sentenciaStore;
						} //public sql exception
					} // new CallableStatementCreator
					, new CallableStatementCallback() {
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
						}// public
					}// CallableStatementCallback
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al actualizar los parametros de sistema.", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public ParametrosSisBean consultaFechaConsultaDisp(ParametrosSisBean parametrosSis,int tipoConsulta) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?,?,?," +
												"?,?,?,?);";
			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,	// aud_usuario
					Constantes.FECHA_VACIA, // fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO,// programaID
					Constantes.ENTERO_CERO,	// sucursal
					Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setFechaConsDisp(resultSet.getString("FechaConsDisp"));
					return parametrosSisBean;
				}
			});
			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta parametros Fecha de consulta disponible", e);
		}
		return parametrosSisBean;
	}


	public ParametrosSisBean consultaOficialCumplimiento(ParametrosSisBean parametrosSis,int tipoConsulta) {
		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?,?,?," +
												"?,?,?,?);";
			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,	// aud_usuario
					Constantes.FECHA_VACIA, // fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO,// programaID
					Constantes.ENTERO_CERO,	// sucursal
					Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ");");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setOficialCumID(resultSet.getString("OficialCumID"));
					return parametrosSisBean;
				}
			});
			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta parametros Oficial de Cumplimiento", e);
		}
		return parametrosSisBean;
	}

	/* Consuta parametros Validacion De roles que libera y rechaza en el flujo d esolicitud de credito */
	public ParametrosSisBean consultaValRolFlujoSol(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = { parametrosSis.getEmpresaID(),
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean.setOcultaBtnRechazoSol(resultSet.getString("OcultaBtnRechazoSol"));
					parametrosSisBean.setRestringebtnLiberacionSol(resultSet.getString("RestringebtnLiberacionSol"));
					parametrosSisBean.setPrimerRolFlujoSolID(resultSet.getString("PrimerRolFlujoSolID"));
					parametrosSisBean.setSegundoRolFlujoSolID(resultSet.getString("SegundoRolFlujoSolID"));
					return parametrosSisBean;

				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de roles de flujo solicitud", e);
		}
		return parametrosSisBean;
	}// fin de consulta

	/* Consuta parametros Validacion de Contraseña */
public ParametrosSisBean consultaParamConfigContra(ParametrosSisBean parametrosSis,int tipoConsulta) {

	ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
	try{
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { parametrosSis.getEmpresaID(),
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								Constantes.ENTERO_CERO,// sucursal
								Constantes.ENTERO_CERO };//numTransaccion
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSisBean parametrosSisBean = new ParametrosSisBean();

				parametrosSisBean.setCaracterMinimo(resultSet.getString("CaracterMinimo"));
				parametrosSisBean.setCaracterMayus(resultSet.getString("CaracterMayus"));
				parametrosSisBean.setCaracterMinus(resultSet.getString("CaracterMinus"));
				parametrosSisBean.setCaracterNumerico(resultSet.getString("CaracterNumerico"));
				parametrosSisBean.setCaracterEspecial(resultSet.getString("CaracterEspecial"));

				parametrosSisBean.setUltimasContra(resultSet.getString("UltimasContra"));
				parametrosSisBean.setDiaMaxCamContra(resultSet.getString("DiaMaxCamContra"));
				parametrosSisBean.setDiaMaxInterSesion(resultSet.getString("DiaMaxInterSesion"));
				parametrosSisBean.setNumIntentos(resultSet.getString("NumIntentos"));
				parametrosSisBean.setNumDiaBloq(resultSet.getString("NumDiaBloq"));

				parametrosSisBean.setReqCaracterMayus(resultSet.getString("ReqCaracterMayus"));
				parametrosSisBean.setReqCaracterMinus(resultSet.getString("ReqCaracterMinus"));
				parametrosSisBean.setReqCaracterNumerico(resultSet.getString("ReqCaracterNumerico"));
				parametrosSisBean.setReqCaracterEspecial(resultSet.getString("ReqCaracterEspecial"));
				parametrosSisBean.setHabilitaConfPass(resultSet.getString("HabilitaConfPass"));

				return parametrosSisBean;


			}// trows ecexeption
		});//lista

		parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Parametros de configuracion de contraseña", e);
	}
	return parametrosSisBean;
}// fin de consulta

	public ParametrosSisBean consultaCierreAutomatico(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = { parametrosSis.getEmpresaID(),
									Constantes.STRING_VACIO,
									tipoConsulta,
									Constantes.ENTERO_CERO,//aud_usuario
									Constantes.FECHA_VACIA, //fechaActual
									Constantes.STRING_VACIO,// direccionIP
									Constantes.STRING_VACIO, //programaID
									Constantes.ENTERO_CERO,// sucursal
									Constantes.ENTERO_CERO };//numTransaccion
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();

					parametrosSisBean.setCierreAutomatico(resultSet.getString("CierreAutomatico"));

					return parametrosSisBean;


				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Parametros de configuracion de contraseña", e);
		}
		return parametrosSisBean;
	}// fin de consulta

	public ParametrosSisBean consultaCargaLayoutXLSDepRef(ParametrosSisBean parametrosSis,int tipoConsulta) {

		ParametrosSisBean parametrosSisBean= new ParametrosSisBean();
		try{
			String query = "call PARAMETROSSISCON(?,?,?," +
													"?,?,?," +
													"?,?,?);";
			Object[] parametros = {
					parametrosSis.getEmpresaID(),
					Constantes.STRING_VACIO,
					tipoConsulta,
					Constantes.ENTERO_CERO,//aud_usuario
					Constantes.FECHA_VACIA, //fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO, //programaID
					Constantes.ENTERO_CERO,// sucursal
					Constantes.ENTERO_CERO };//numTransaccion

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();

					parametrosSisBean.setCargaLayoutXLSDepRef(resultSet.getString("CargaLayoutXLSDepRef"));

					return parametrosSisBean;


				}// trows ecexeption
			});//lista

			parametrosSisBean= matches.size() > 0 ? (ParametrosSisBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Parametros de configuracion de contraseña", e);
		}
		return parametrosSisBean;
	}// fin de consulta

}//class