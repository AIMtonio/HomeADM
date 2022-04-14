package pld.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.IdentidadClienteBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class IdentidadClienteDAO extends BaseDAO{

	public IdentidadClienteDAO(){
		super();
	}

	public MensajeTransaccionBean agregaIdentidad(final IdentidadClienteBean identidadClienteBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(
												parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(
																		parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLDIDENTIDADCTEALT("+
										"?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(identidadClienteBean.getClienteID()));
								sentenciaStore.setString("Par_AplicaCuest", identidadClienteBean.getAplicaCuest());
								sentenciaStore.setString("Par_OtroAplDetalle", identidadClienteBean.getOtroAplDetalle());
								sentenciaStore.setString("Par_RealizadoOp", identidadClienteBean.getRealizadoOp());
								sentenciaStore.setString("Par_FuenteRecursos", identidadClienteBean.getFuenteRecursos());
								sentenciaStore.setString("Par_FuenteOtraDet", identidadClienteBean.getFuenteOtraDet());
								sentenciaStore.setString("Par_ObservacionesEjec", identidadClienteBean.getObservacionesEjec());
								sentenciaStore.setString("Par_NegocioPersona", identidadClienteBean.getNegocioPersona());
								sentenciaStore.setString("Par_TipoNegocio", identidadClienteBean.getTipoNegocio());
								sentenciaStore.setString("Par_TipoOtroNegocio", identidadClienteBean.getTipoOtroNegocio());

								sentenciaStore.setString("Par_GiroNegocio", identidadClienteBean.getGiroNegocio());
								sentenciaStore.setInt("Par_AniosAntig" , Utileria.convierteEntero(identidadClienteBean.getAniosAntig()));
								sentenciaStore.setInt("Par_MesesAntig" , Utileria.convierteEntero(identidadClienteBean.getMesesAntig()));
								sentenciaStore.setString("Par_UbicacNegocio", identidadClienteBean.getUbicacNegocio());
								sentenciaStore.setString("Par_EsNegocioPropio", identidadClienteBean.getEsNegocioPropio());
								sentenciaStore.setString("Par_EspecificarNegocio", identidadClienteBean.getEspecificarNegocio());
								sentenciaStore.setString("Par_TipoProducto", identidadClienteBean.getTipoProducto());
								sentenciaStore.setString("Par_MercadoDeProducto", identidadClienteBean.getMercadoDeProducto());
								sentenciaStore.setDouble("Par_IngresosMensuales", Utileria.convierteDoble(identidadClienteBean.getIngresosMensuales()));
								sentenciaStore.setInt("Par_DependientesEcon", Utileria.convierteEntero(identidadClienteBean.getDependientesEcon()));

								sentenciaStore.setInt("Par_DependienteHijo", Utileria.convierteEntero(identidadClienteBean.getDependienteHijo()));
								sentenciaStore.setInt("Par_DependienteOtro", Utileria.convierteEntero(identidadClienteBean.getDependienteOtro()));
								sentenciaStore.setString("Par_TipoNuevoNegocio", identidadClienteBean.getTipoNuevoNegocio());
								sentenciaStore.setString("Par_TipoOtroNuevoNegocio", identidadClienteBean.getTipoOtroNuevoNegocio());
								sentenciaStore.setString("Par_FteNuevosIngresos", identidadClienteBean.getFteNuevosIngresos());
								sentenciaStore.setString("Par_ParentescoApert", identidadClienteBean.getParentescoApert());
								sentenciaStore.setString("Par_ParentescoOtroDet", identidadClienteBean.getParentesOtroDet());
								sentenciaStore.setString("Par_TiempoEnvio", identidadClienteBean.getTiempoEnvio());
								sentenciaStore.setDouble("Par_CuantoEnvio", Utileria.convierteDoble(identidadClienteBean.getCuantoEnvio()));
								sentenciaStore.setString("Par_TrabajoActual", identidadClienteBean.getTrabajoActual());

								sentenciaStore.setString("Par_LugarTrabajoAct", identidadClienteBean.getTrabajoActual());
								sentenciaStore.setString("Par_CargoTrabajo", identidadClienteBean.getCargoTrabajo());
								sentenciaStore.setString("Par_PeriodoDePago", identidadClienteBean.getPeriodoDePago());
								sentenciaStore.setDouble("Par_MontoPeriodoPago", Utileria.convierteDoble(identidadClienteBean.getMontoPeriodoPago()));
								sentenciaStore.setString("Par_TiempoNuevoNeg", identidadClienteBean.getTiempoNuevoNeg());
								sentenciaStore.setString("Par_TiempoLaborado",identidadClienteBean.getTiempoLaborado());
								sentenciaStore.setInt("Par_DependienteEconSA", Utileria.convierteEntero(identidadClienteBean.getDependientesEconSA()));
								sentenciaStore.setInt("Par_DependienteHijoSA", Utileria.convierteEntero(identidadClienteBean.getDependienteHijoSA()));
								sentenciaStore.setInt("Par_DependienteOtroSA", Utileria.convierteEntero(identidadClienteBean.getDependienteOtroSA()));
								sentenciaStore.setString("Par_ProveedRecursos", identidadClienteBean.getProveedRecursos());

								sentenciaStore.setString("Par_TipoProvRecursos", identidadClienteBean.getTipoProvRecursos());
								sentenciaStore.setString("Par_NombreCompProv", identidadClienteBean.getNombreCompProv());
								sentenciaStore.setString("Par_DomicilioProv", identidadClienteBean.getDomicilioProv());
								sentenciaStore.setString("Par_FechaNacProv", (!identidadClienteBean.getFechaNacProv().equals("")?identidadClienteBean.getFechaNacProv() : "1900-01-01"));
								sentenciaStore.setString("Par_NacionalidadProv", identidadClienteBean.getNacionalidProv());
								sentenciaStore.setString("Par_RfcProv", identidadClienteBean.getRfcProv());
								sentenciaStore.setString("Par_RazonSocialProvB", identidadClienteBean.getRazonSocialProvB());
								sentenciaStore.setString("Par_NacionalidProvB", identidadClienteBean.getNacionalidProvB());
								sentenciaStore.setString("Par_RfcProvB", identidadClienteBean.getRfcProvB());
								sentenciaStore.setString("Par_DomicilioProvB", identidadClienteBean.getDomicilioProvB());

								sentenciaStore.setString("Par_PropietarioDinero", identidadClienteBean.getPropietarioDinero());
								sentenciaStore.setString("Par_PropietarioOtroDet", identidadClienteBean.getPropietarioOtroDet());
								sentenciaStore.setString("Par_PropietarioNombreCom", identidadClienteBean.getPropietarioNombreCom());
								sentenciaStore.setString("Par_PropietarioDomicilio", identidadClienteBean.getPropietarioDomici());
								sentenciaStore.setString("Par_PropietarioNacio", identidadClienteBean.getPropietarioNacio());
								sentenciaStore.setString("Par_PropietarioCurp", identidadClienteBean.getPropietarioCurp());
								sentenciaStore.setString("Par_PropietarioRfc", identidadClienteBean.getPropietarioRfc());
								sentenciaStore.setString("Par_PropietarioGener", identidadClienteBean.getPropietarioGener());
								sentenciaStore.setString("Par_PropietarioOcupac", identidadClienteBean.getPropietarioOcupac());
								sentenciaStore.setString("Par_PropietarioFecha", (!identidadClienteBean.getPropietarioFecha().equals("") ? identidadClienteBean.getPropietarioFecha() : "1900-01-01"));

								sentenciaStore.setString("Par_PropietarioLugarNac", identidadClienteBean.getPropietarioLugarNac());
								sentenciaStore.setString("Par_PropietarioEntid", identidadClienteBean.getPropietarioEntid());
								sentenciaStore.setString("Par_PropietarioPais", identidadClienteBean.getPropietarioPais());
								sentenciaStore.setString("Par_CargoPubPEP", identidadClienteBean.getCargoPubPEP());
								sentenciaStore.setString("Par_CargoPubPEPDet", identidadClienteBean.getCargoPubPEPDet());
								sentenciaStore.setString("Par_NivelCargoPEP", identidadClienteBean.getNivelCargoPEP());
								sentenciaStore.setString("Par_Periodo1PEP", identidadClienteBean.getPeriodo1PEP());
								sentenciaStore.setString("Par_Periodo2PEP", identidadClienteBean.getPeriodo2PEP());
								sentenciaStore.setDouble("Par_IngresosMenPEP",Utileria.convierteDoble(identidadClienteBean.getIngresosMenPEP()));
								sentenciaStore.setString("Par_FamEnCargoPEP", identidadClienteBean.getFamEnCargoPEP());

								sentenciaStore.setString("Par_ParentescoPEP", identidadClienteBean.getParentescoPEP());
								sentenciaStore.setString("Par_NombreCompletoPEP", identidadClienteBean.getNombreCompletoPEP());
								sentenciaStore.setString("Par_ParentescoPEPDet", identidadClienteBean.getParentescoPEPDet());
								sentenciaStore.setString("Par_CargoPubPEPDetFam", identidadClienteBean.getCargoPubPEPDetFam());
								sentenciaStore.setString("Par_NivelCargoPEPFam", identidadClienteBean.getNivelCargoPEPFam());
								sentenciaStore.setString("Par_Periodo1PEPFam", identidadClienteBean.getPeriodo1PEPFam());
								sentenciaStore.setString("Par_Periodo2PEPFam", identidadClienteBean.getPeriodo2PEPFam());
								sentenciaStore.setString("Par_ParentescoPEPFam", identidadClienteBean.getParentescoPEPFam());
								sentenciaStore.setString("Par_NombreCtoPEPFam", identidadClienteBean.getNombreCtoPEPFam());

								sentenciaStore.setString("Par_RelacionPEP", identidadClienteBean.getRelacionPEP());
								sentenciaStore.setString("Par_NombreRelacionPEP", identidadClienteBean.getNombreRelacionPEP());
								sentenciaStore.setString("Par_IngresoAdici", identidadClienteBean.getIngresoAdici());
								sentenciaStore.setString("Par_FuenteIngreOS", identidadClienteBean.getFuenteIngreOS());
								sentenciaStore.setString("Par_UbicFteIngreOS", identidadClienteBean.getUbicFteIngreOS());
								sentenciaStore.setString("Par_EsPropioFteIng", identidadClienteBean.getEsPropioFteIng());
								sentenciaStore.setString("Par_EsPropioFteDet", identidadClienteBean.getEsPropioFteDet());
								sentenciaStore.setDouble("Par_IngMensualesOS",Utileria.convierteDoble(identidadClienteBean.getIngMensualesOS()));
								sentenciaStore.setString("Par_TipoProdTN", identidadClienteBean.getTipoProdTipoNeg());
								sentenciaStore.setString("Par_MercadoDeProdTN", identidadClienteBean.getMercadoDeProdTipoNeg());

								sentenciaStore.setDouble("Par_IngresosMensTN", Utileria.convierteDoble(identidadClienteBean.getIngresosMensTipoNeg()));
								sentenciaStore.setInt("Par_DependEconTN", Utileria.convierteEntero(identidadClienteBean.getDependientesEconTipoNeg()));
								sentenciaStore.setInt("Par_DependHijoTN", Utileria.convierteEntero(identidadClienteBean.getDependienteHijoTipoNeg()));
								sentenciaStore.setInt("Par_DependOtroTN", Utileria.convierteEntero(identidadClienteBean.getDependienteOtroTipoNeg()));

								sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "PromotoresDAO.agregaIdentidad" );
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
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
				}catch(Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Identidad de Cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaIdentidad(final IdentidadClienteBean identidadClienteBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(
												parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(
														parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLDIDENTIDADCTEMOD("+
										"?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?, 		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?,		?,?,?,?,?, "+
										"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(identidadClienteBean.getClienteID()));
								sentenciaStore.setString("Par_AplicaCuest", identidadClienteBean.getAplicaCuest());
								sentenciaStore.setString("Par_OtroAplDetalle", identidadClienteBean.getOtroAplDetalle());
								sentenciaStore.setString("Par_RealizadoOp", identidadClienteBean.getRealizadoOp());
								sentenciaStore.setString("Par_FuenteRecursos", identidadClienteBean.getFuenteRecursos());
								sentenciaStore.setString("Par_FuenteOtraDet", identidadClienteBean.getFuenteOtraDet());
								sentenciaStore.setString("Par_ObservacionesEjec", identidadClienteBean.getObservacionesEjec());
								sentenciaStore.setString("Par_NegocioPersona", identidadClienteBean.getNegocioPersona());
								sentenciaStore.setString("Par_TipoNegocio", identidadClienteBean.getTipoNegocio());
								sentenciaStore.setString("Par_TipoOtroNegocio", identidadClienteBean.getTipoOtroNegocio());

								sentenciaStore.setString("Par_GiroNegocio", identidadClienteBean.getGiroNegocio());
								sentenciaStore.setInt("Par_AniosAntig" , Utileria.convierteEntero(identidadClienteBean.getAniosAntig()));
								sentenciaStore.setInt("Par_MesesAntig" , Utileria.convierteEntero(identidadClienteBean.getMesesAntig()));
								sentenciaStore.setString("Par_UbicacNegocio", identidadClienteBean.getUbicacNegocio());
								sentenciaStore.setString("Par_EsNegocioPropio", identidadClienteBean.getEsNegocioPropio());
								sentenciaStore.setString("Par_EspecificarNegocio", identidadClienteBean.getEspecificarNegocio());
								sentenciaStore.setString("Par_TipoProducto", identidadClienteBean.getTipoProducto());
								sentenciaStore.setString("Par_MercadoDeProducto", identidadClienteBean.getMercadoDeProducto());
								sentenciaStore.setDouble("Par_IngresosMensuales", Utileria.convierteDoble(identidadClienteBean.getIngresosMensuales()));
								sentenciaStore.setInt("Par_DependientesEcon", Utileria.convierteEntero(identidadClienteBean.getDependientesEcon()));

								sentenciaStore.setInt("Par_DependienteHijo", Utileria.convierteEntero(identidadClienteBean.getDependienteHijo()));
								sentenciaStore.setInt("Par_DependienteOtro", Utileria.convierteEntero(identidadClienteBean.getDependienteOtro()));
								sentenciaStore.setString("Par_TipoNuevoNegocio", identidadClienteBean.getTipoNuevoNegocio());
								sentenciaStore.setString("Par_TipoOtroNuevoNegocio", identidadClienteBean.getTipoOtroNuevoNegocio());
								sentenciaStore.setString("Par_FteNuevosIngresos", identidadClienteBean.getFteNuevosIngresos());
								sentenciaStore.setString("Par_ParentescoApert", identidadClienteBean.getParentescoApert());
								sentenciaStore.setString("Par_ParentescoOtroDet", identidadClienteBean.getParentesOtroDet());
								sentenciaStore.setString("Par_TiempoEnvio", identidadClienteBean.getTiempoEnvio());
								sentenciaStore.setDouble("Par_CuantoEnvio", Utileria.convierteDoble(identidadClienteBean.getCuantoEnvio()));
								sentenciaStore.setString("Par_TrabajoActual", identidadClienteBean.getTrabajoActual());

								sentenciaStore.setString("Par_LugarTrabajoAct", identidadClienteBean.getTrabajoActual());
								sentenciaStore.setString("Par_CargoTrabajo", identidadClienteBean.getCargoTrabajo());
								sentenciaStore.setString("Par_PeriodoDePago", identidadClienteBean.getPeriodoDePago());
								sentenciaStore.setDouble("Par_MontoPeriodoPago", Utileria.convierteDoble(identidadClienteBean.getMontoPeriodoPago()));
								sentenciaStore.setString("Par_TiempoNuevoNeg", identidadClienteBean.getTiempoNuevoNeg());
								sentenciaStore.setString("Par_TiempoLaborado",	identidadClienteBean.getTiempoLaborado());
								sentenciaStore.setInt("Par_DependienteEconSA", Utileria.convierteEntero(identidadClienteBean.getDependientesEconSA()));
								sentenciaStore.setInt("Par_DependienteHijoSA", Utileria.convierteEntero(identidadClienteBean.getDependienteHijoSA()));
								sentenciaStore.setInt("Par_DependienteOtroSA", Utileria.convierteEntero(identidadClienteBean.getDependienteOtroSA()));
								sentenciaStore.setString("Par_ProveedRecursos", identidadClienteBean.getProveedRecursos());

								sentenciaStore.setString("Par_TipoProvRecursos", identidadClienteBean.getTipoProvRecursos());
								sentenciaStore.setString("Par_NombreCompProv", identidadClienteBean.getNombreCompProv());
								sentenciaStore.setString("Par_DomicilioProv", identidadClienteBean.getDomicilioProv());
								sentenciaStore.setString("Par_FechaNacProv", (!identidadClienteBean.getFechaNacProv().equals("")?identidadClienteBean.getFechaNacProv() : "1900-01-01"));
								sentenciaStore.setString("Par_NacionalidadProv", identidadClienteBean.getNacionalidProv());
								sentenciaStore.setString("Par_RfcProv", identidadClienteBean.getRfcProv());
								sentenciaStore.setString("Par_RazonSocialProvB", identidadClienteBean.getRazonSocialProvB());
								sentenciaStore.setString("Par_NacionalidProvB", identidadClienteBean.getNacionalidProvB());
								sentenciaStore.setString("Par_RfcProvB", identidadClienteBean.getRfcProvB());
								sentenciaStore.setString("Par_DomicilioProvB", identidadClienteBean.getDomicilioProvB());

								sentenciaStore.setString("Par_PropietarioDinero", identidadClienteBean.getPropietarioDinero());
								sentenciaStore.setString("Par_PropietarioOtroDet", identidadClienteBean.getPropietarioOtroDet());
								sentenciaStore.setString("Par_PropietarioNombreCom", identidadClienteBean.getPropietarioNombreCom());
								sentenciaStore.setString("Par_PropietarioDomicilio", identidadClienteBean.getPropietarioDomici());
								sentenciaStore.setString("Par_PropietarioNacio", identidadClienteBean.getPropietarioNacio());
								sentenciaStore.setString("Par_PropietarioCurp", identidadClienteBean.getPropietarioCurp());
								sentenciaStore.setString("Par_PropietarioRfc", identidadClienteBean.getPropietarioRfc());
								sentenciaStore.setString("Par_PropietarioGener", identidadClienteBean.getPropietarioGener());
								sentenciaStore.setString("Par_PropietarioOcupac", identidadClienteBean.getPropietarioOcupac());
								sentenciaStore.setString("Par_PropietarioFecha", (!identidadClienteBean.getPropietarioFecha().equals("") ? identidadClienteBean.getPropietarioFecha() : "1900-01-01"));

								sentenciaStore.setString("Par_PropietarioLugarNac", identidadClienteBean.getPropietarioLugarNac());
								sentenciaStore.setString("Par_PropietarioEntid", identidadClienteBean.getPropietarioEntid());
								sentenciaStore.setString("Par_PropietarioPais", identidadClienteBean.getPropietarioPais());
								sentenciaStore.setString("Par_CargoPubPEP", identidadClienteBean.getCargoPubPEP());
								sentenciaStore.setString("Par_CargoPubPEPDet", identidadClienteBean.getCargoPubPEPDet());
								sentenciaStore.setString("Par_NivelCargoPEP", identidadClienteBean.getNivelCargoPEP());
								sentenciaStore.setString("Par_Periodo1PEP", identidadClienteBean.getPeriodo1PEP());
								sentenciaStore.setString("Par_Periodo2PEP", identidadClienteBean.getPeriodo2PEP());
								sentenciaStore.setDouble("Par_IngresosMenPEP",Utileria.convierteDoble(identidadClienteBean.getIngresosMenPEP()));
								sentenciaStore.setString("Par_FamEnCargoPEP", identidadClienteBean.getFamEnCargoPEP());

								sentenciaStore.setString("Par_ParentescoPEP", identidadClienteBean.getParentescoPEP());
								sentenciaStore.setString("Par_NombreCompletoPEP", identidadClienteBean.getNombreCompletoPEP());
								sentenciaStore.setString("Par_ParentescoPEPDet", identidadClienteBean.getParentescoPEPDet());
								sentenciaStore.setString("Par_CargoPubPEPDetFam", identidadClienteBean.getCargoPubPEPDetFam());
								sentenciaStore.setString("Par_NivelCargoPEPFam", identidadClienteBean.getNivelCargoPEPFam());
								sentenciaStore.setString("Par_Periodo1PEPFam", identidadClienteBean.getPeriodo1PEPFam());
								sentenciaStore.setString("Par_Periodo2PEPFam", identidadClienteBean.getPeriodo2PEPFam());
								sentenciaStore.setString("Par_ParentescoPEPFam", identidadClienteBean.getParentescoPEPFam());
								sentenciaStore.setString("Par_NombreCtoPEPFam", identidadClienteBean.getNombreCtoPEPFam());

								sentenciaStore.setString("Par_RelacionPEP", identidadClienteBean.getRelacionPEP());
								sentenciaStore.setString("Par_NombreRelacionPEP", identidadClienteBean.getNombreRelacionPEP());
								sentenciaStore.setString("Par_IngresoAdici", identidadClienteBean.getIngresoAdici());
								sentenciaStore.setString("Par_FuenteIngreOS", identidadClienteBean.getFuenteIngreOS());
								sentenciaStore.setString("Par_UbicFteIngreOS", identidadClienteBean.getUbicFteIngreOS());
								sentenciaStore.setString("Par_EsPropioFteIng", identidadClienteBean.getEsPropioFteIng());
								sentenciaStore.setString("Par_EsPropioFteDet", identidadClienteBean.getEsPropioFteDet());
								sentenciaStore.setDouble("Par_IngMensualesOS",Utileria.convierteDoble(identidadClienteBean.getIngMensualesOS()));
								sentenciaStore.setString("Par_TipoProdTN", identidadClienteBean.getTipoProdTipoNeg());
								sentenciaStore.setString("Par_MercadoDeProdTN", identidadClienteBean.getMercadoDeProdTipoNeg());

								sentenciaStore.setDouble("Par_IngresosMensTN", Utileria.convierteDoble(identidadClienteBean.getIngresosMensTipoNeg()));
								sentenciaStore.setInt("Par_DependEconTN", Utileria.convierteEntero(identidadClienteBean.getDependientesEconTipoNeg()));
								sentenciaStore.setInt("Par_DependHijoTN", Utileria.convierteEntero(identidadClienteBean.getDependienteHijoTipoNeg()));
								sentenciaStore.setInt("Par_DependOtroTN", Utileria.convierteEntero(identidadClienteBean.getDependienteOtroTipoNeg()));

								sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "PromotoresDAO.agregaIdentidad" );
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
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
				}catch(Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificación de Identidad de Cliente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public IdentidadClienteBean consultaPrincipal(IdentidadClienteBean identidadCliente, int tipoConsulta){
		IdentidadClienteBean identidadClienteBean= new IdentidadClienteBean();
		try{
			String query = "CALL PLDIDENTIDADCTECON(?,?,?,?,?,		?,?,?,?)";
			Object [] parametros = {
						Utileria.convierteEntero(identidadCliente.getClienteID()),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDIDENTIDADCTECON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(
																	query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					IdentidadClienteBean identClienteBean = new IdentidadClienteBean();

						identClienteBean.setClienteID(resultSet.getString("ClienteID"));
						identClienteBean.setAplicaCuest(resultSet.getString("AplicaCuest"));
						identClienteBean.setOtroAplDetalle(resultSet.getString("OtroAplDetalle"));
						identClienteBean.setRealizadoOp(resultSet.getString("RealizadoOp"));
						identClienteBean.setFuenteRecursos(resultSet.getString("FuenteRecursos"));
						identClienteBean.setFuenteOtraDet(resultSet.getString("FuenteOtraDet"));
						identClienteBean.setObservacionesEjec(resultSet.getString("ObservacionesEjec"));
						identClienteBean.setNegocioPersona(resultSet.getString("NegocioPersona"));
						identClienteBean.setTipoNegocio(resultSet.getString("TipoNegocio"));
						identClienteBean.setTipoOtroNegocio(resultSet.getString("TipoOtroNegocio"));

						identClienteBean.setGiroNegocio(resultSet.getString("GiroNegocio"));
						identClienteBean.setAniosAntig(resultSet.getString("AniosAntig"));
						identClienteBean.setMesesAntig(resultSet.getString("MesesAntig"));
						identClienteBean.setUbicacNegocio(resultSet.getString("UbicacNegocio"));
						identClienteBean.setEsNegocioPropio(resultSet.getString("EsNegocioPropio"));
						identClienteBean.setEspecificarNegocio(resultSet.getString("EspecificarNegocio"));
						identClienteBean.setTipoProducto(resultSet.getString("TipoProducto"));
						identClienteBean.setMercadoDeProducto(resultSet.getString("MercadoDeProducto"));
						identClienteBean.setIngresosMensuales(resultSet.getString("IngresosMensuales"));

						identClienteBean.setDependientesEcon(resultSet.getString("DependientesEcon"));
						identClienteBean.setDependienteHijo(resultSet.getString("DependienteHijo"));
						identClienteBean.setDependienteOtro(resultSet.getString("DependienteOtro"));
						identClienteBean.setTipoNuevoNegocio(resultSet.getString("TipoNuevoNegocio"));
						identClienteBean.setTipoOtroNuevoNegocio(resultSet.getString("TipoOtroNuevoNegocio"));
						identClienteBean.setFteNuevosIngresos(resultSet.getString("FteNuevosIngresos"));
						identClienteBean.setParentescoApert(resultSet.getString("ParentescoApert"));
						identClienteBean.setParentesOtroDet(resultSet.getString("ParentescoOtroDet"));
						identClienteBean.setTiempoEnvio(resultSet.getString("TiempoEnvio"));
						identClienteBean.setCuantoEnvio(resultSet.getString("CuantoEnvio"));

						identClienteBean.setTrabajoActual(resultSet.getString("TrabajoActual"));
						identClienteBean.setLugarTrabajoAct(resultSet.getString("LugarTrabajoAct"));
						identClienteBean.setCargoTrabajo(resultSet.getString("CargoTrabajo"));
						identClienteBean.setPeriodoDePago(resultSet.getString("PeriodoDePago"));
						identClienteBean.setMontoPeriodoPago(resultSet.getString("MontoPeriodoPago"));
						identClienteBean.setTiempoNuevoNeg(resultSet.getString("TiempoNuevoNeg"));
						identClienteBean.setTiempoLaborado(resultSet.getString("TiempoLaborado"));
						identClienteBean.setDependientesEconSA(resultSet.getString("DependienteEconSA"));
						identClienteBean.setDependienteHijoSA(resultSet.getString("DependienteHijoSA"));
						identClienteBean.setDependienteOtroSA(resultSet.getString("DependienteOtroSA"));

						identClienteBean.setProveedRecursos(resultSet.getString("ProveedRecursos"));
						identClienteBean.setTipoProvRecursos(resultSet.getString("TipoProvRecursos"));
						identClienteBean.setNombreCompProv(resultSet.getString("NombreCompProv"));
						identClienteBean.setDomicilioProv(resultSet.getString("DomicilioProv"));
						identClienteBean.setFechaNacProv(resultSet.getString("FechaNacProv"));
						identClienteBean.setNacionalidProv(resultSet.getString("NacionalidadProv"));
						identClienteBean.setRfcProv(resultSet.getString("RfcProv"));
						identClienteBean.setRazonSocialProvB(resultSet.getString("RazonSocialProvB"));
						identClienteBean.setNacionalidProvB(resultSet.getString("NacionalidProvB"));
						identClienteBean.setRfcProvB(resultSet.getString("RfcProvB"));

						identClienteBean.setDomicilioProvB(resultSet.getString("DomicilioProvB"));
						identClienteBean.setPropietarioDinero(resultSet.getString("PropietarioDinero"));
						identClienteBean.setPropietarioOtroDet(resultSet.getString("PropietarioOtroDet"));
						identClienteBean.setPropietarioNombreCom(resultSet.getString("PropietarioNombreCom"));
						identClienteBean.setPropietarioDomici(resultSet.getString("PropietarioDomicilio"));
						identClienteBean.setPropietarioNacio(resultSet.getString("PropietarioNacio"));
						identClienteBean.setPropietarioCurp(resultSet.getString("PropietarioCurp"));
						identClienteBean.setPropietarioRfc(resultSet.getString("PropietarioRfc"));
						identClienteBean.setPropietarioGener(resultSet.getString("PropietarioGener"));
						identClienteBean.setPropietarioOcupac(resultSet.getString("PropietarioOcupac"));

						identClienteBean.setPropietarioFecha(resultSet.getString("PropietarioFecha"));
						identClienteBean.setPropietarioLugarNac(resultSet.getString("PropietarioLugarNac"));
						identClienteBean.setPropietarioEntid(resultSet.getString("PropietarioEntid"));
						identClienteBean.setPropietarioPais(resultSet.getString("PropietarioPais"));
						identClienteBean.setCargoPubPEP(resultSet.getString("CargoPubPEP"));
						identClienteBean.setCargoPubPEPDet(resultSet.getString("CargoPubPEPDet"));
						identClienteBean.setNivelCargoPEP(resultSet.getString("NivelCargoPEP"));
						identClienteBean.setPeriodo1PEP(resultSet.getString("Periodo1PEP"));
						identClienteBean.setPeriodo2PEP(resultSet.getString("Periodo2PEP"));
						identClienteBean.setIngresosMenPEP(resultSet.getString("IngresosMenPEP"));

						identClienteBean.setFamEnCargoPEP(resultSet.getString("FamEnCargoPEP"));
						identClienteBean.setParentescoPEP(resultSet.getString("ParentescoPEP"));
						identClienteBean.setNombreCompletoPEP(resultSet.getString("NombreCompletoPEP"));
						identClienteBean.setParentescoPEPDet(resultSet.getString("ParentescoPEPDet"));
						identClienteBean.setCargoPubPEPDetFam(resultSet.getString("CargoPubPEPDetFam"));
						identClienteBean.setNivelCargoPEPFam(resultSet.getString("NivelCargoPEPFam"));
						identClienteBean.setPeriodo1PEPFam(resultSet.getString("Periodo1PEPFam"));
						identClienteBean.setPeriodo2PEPFam(resultSet.getString("Periodo2PEPFam"));
						identClienteBean.setParentescoPEPFam(resultSet.getString("ParentescoPEPFam"));

						identClienteBean.setNombreCtoPEPFam(resultSet.getString("NombreCtoPEPFam"));
						identClienteBean.setRelacionPEP(resultSet.getString("RelacionPEP"));
						identClienteBean.setNombreRelacionPEP(resultSet.getString("NombreRelacionPEP"));
						identClienteBean.setIngresoAdici(resultSet.getString("IngresoAdici"));
						identClienteBean.setFuenteIngreOS(resultSet.getString("FuenteIngreOS"));
						identClienteBean.setUbicFteIngreOS(resultSet.getString("UbicFteIngreOS"));
						identClienteBean.setEsPropioFteIng(resultSet.getString("EsPropioFteIng"));

						identClienteBean.setEsPropioFteDet(resultSet.getString("EsPropioFteDet"));
						identClienteBean.setIngMensualesOS(resultSet.getString("IngMensualesOS"));
						identClienteBean.setTipoProdTipoNeg(resultSet.getString("TipoProdTN"));
						identClienteBean.setMercadoDeProdTipoNeg(resultSet.getString("MercadoDeProdTN"));
						identClienteBean.setIngresosMensTipoNeg(resultSet.getString("IngresosMensTN"));
						identClienteBean.setDependientesEconTipoNeg(resultSet.getString("DependEconTN"));
						identClienteBean.setDependienteHijoTipoNeg(resultSet.getString("DependHijoTN"));
						identClienteBean.setDependienteOtroTipoNeg(resultSet.getString("DependOtroTN"));
					return identClienteBean;
				}
			});
			identidadClienteBean = matches.size() > 0 ? (IdentidadClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
		}
		return identidadClienteBean;
	}
}
