package ventanilla.dao;

import java.math.BigInteger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cardinal.seguridad.mars.Encryptor20;
import contabilidad.dao.PolizaDAO;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.dao.BloqueoSaldoDAO;
import cuentas.servicio.BloqueoSaldoServicio;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.servicio.IngresosOperacionesServicio;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Tra_Ventanilla;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.SistemaLogging;
import herramientas.Utileria;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.UsuarioServicio;
import ventanilla.bean.SpeiEnvioBean;
import ventanilla.dao.IngresosOperacionesDAO;

	import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

public class SpeiEnvioDAO extends BaseDAO {

	ParametrosSesionBean 	parametrosSesionBean;
	PolizaDAO				polizaDAO				= null;

	private final static int areaBanco = 8;
	private final static String origenOperacion = "V";
	private static interface Enum_NumActualizacionSPEI {
		int actualizaFirma = 504;
	}

	public MensajeTransaccionBean altaSPEI(final SpeiEnvioBean speiEnvioBean, final long numTransaccion){
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		Long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
		String folioSpeiID = "";
		int numErr = 0;
		String errMen = "";
		String control = "";
		String campoGenerico = "";

		try{
			mensajeResultado = altaEnviosSPEI(speiEnvioBean, numeroTransaccion);

			if (mensajeResultado.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				throw new Exception(mensajeResultado.getDescripcion());
			}

			folioSpeiID = mensajeResultado.getConsecutivoString();
			numErr = mensajeResultado.getNumero();
			errMen = mensajeResultado.getDescripcion();
			control = mensajeResultado.getNombreControl();
			campoGenerico = mensajeResultado.getCampoGenerico();

			try {
				Encryptor20 encryptor = new Encryptor20();
				String firmaSAFI = "";

	        	firmaSAFI = folioSpeiID + speiEnvioBean.getCuentaBeneficiario() + speiEnvioBean.getCuentaOrd();

	        	firmaSAFI = encryptor.generaFirmaStrong(firmaSAFI);

	        	speiEnvioBean.setFolioSpeiID(folioSpeiID);
	        	speiEnvioBean.setFirma(firmaSAFI);
			} catch (Exception e) {
				mensajeResultado.setNumero(999);
				throw new Exception("Ha ocurrido un error al generar la Firma del SPEI.");
			}

			mensajeResultado = actualizarFirmaEnvioSPEI(speiEnvioBean, numeroTransaccion);

			if (mensajeResultado.getNumero() != Constantes.CODIGO_SIN_ERROR) {
				throw new Exception(mensajeResultado.getDescripcion());
			}

			mensajeResultado.setNumero(numErr);
			mensajeResultado.setDescripcion(errMen);
			mensajeResultado.setConsecutivoString(folioSpeiID);
			mensajeResultado.setConsecutivoInt(folioSpeiID);
			mensajeResultado.setNombreControl(control);
			mensajeResultado.setCampoGenerico(campoGenerico);
			mensajeResultado.setNumerTransaccin(numeroTransaccion);
		}catch(Exception excepcion){
			excepcion.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al procesar la Carga de las recepciones SPEI", excepcion);
			if(mensajeResultado.getNumero()==0){
				mensajeResultado.setNumero(999);
			}
			mensajeResultado.setDescripcion(excepcion.getMessage());
		}

		return mensajeResultado;
	}

	public MensajeTransaccionBean altaEnviosSPEI(final SpeiEnvioBean speiEnvioBean, final long numTransaccion){
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
							String query = "call SPEIENVIOSPRO(?,?,?,?,?, ?,?,?,?,?,"
														   	 +"?,?,?,?,?, ?,?,?,?,?,"
														   	 +"?,?,?,?,?, ?,?,?,?,?,"
														   	 +"?, ?,?,?,"
														   	 +"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.registerOutParameter("Par_Folio", Types.CHAR);
							sentenciaStore.registerOutParameter("Par_ClaveRas", Types.VARCHAR);
							sentenciaStore.setInt("Par_TipoPago",Utileria.convierteEntero(speiEnvioBean.getTipoPago()));
							sentenciaStore.setLong("Par_CuentaAho",Utileria.convierteLong(speiEnvioBean.getCuentaAhoID()));
							sentenciaStore.setLong("Par_TipoCuentaOrd",Utileria.convierteLong(speiEnvioBean.getTipoCuentaOrd()));
							sentenciaStore.setString("Par_CuentaOrd",speiEnvioBean.getCuentaOrd());
							sentenciaStore.setString("Par_NombreOrd",speiEnvioBean.getNombreOrd());

							sentenciaStore.setString("Par_RFCOrd",speiEnvioBean.getOrdRFC());
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(speiEnvioBean.getMonedaID()));
							sentenciaStore.setInt("Par_TipoOperacion",Constantes.ENTERO_CERO);
							sentenciaStore.setDouble("Par_MontoTransferir",Utileria.convierteDoble(speiEnvioBean.getMontoTransferir()));
							sentenciaStore.setDouble("Par_IVAPorPagar",Utileria.convierteDoble(speiEnvioBean.getPagarIVA()));

							sentenciaStore.setDouble("Par_ComisionTrans",Utileria.convierteDoble(speiEnvioBean.getComisionTrans()));
							sentenciaStore.setDouble("Par_IVAComision",Utileria.convierteDoble(speiEnvioBean.getComisionIVA()));
							sentenciaStore.setDouble("Par_TotalCargoCuenta",Utileria.convierteDoble(speiEnvioBean.getTotalCargoCuenta()));
							sentenciaStore.setInt("Par_InstiReceptora",Utileria.convierteEntero(speiEnvioBean.getInstiReceptora()));
							sentenciaStore.setString("Par_CuentaBeneficiario",speiEnvioBean.getCuentaBeneficiario());

							sentenciaStore.setString("Par_NombreBeneficiario",speiEnvioBean.getNombreBeneficiario());
							sentenciaStore.setString("Par_RFCBeneficiario",speiEnvioBean.getBeneficiarioRFC());
							sentenciaStore.setInt("Par_TipoCuentaBen",Utileria.convierteEntero(speiEnvioBean.getTipoCuentaBen()));
							sentenciaStore.setString("Par_ConceptoPago",speiEnvioBean.getConceptoPago());
							sentenciaStore.setInt("Par_CuentaBenefiDos",Constantes.ENTERO_CERO);

							sentenciaStore.setString("Par_NombreBenefiDos",Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_RFCBenefiDos",Constantes.STRING_VACIO);
							sentenciaStore.setInt("Par_TipoCuentaBenDos",Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ConceptoPagoDos",Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_ReferenciaCobranza",Constantes.STRING_VACIO);

							sentenciaStore.setInt("Par_ReferenciaNum",Utileria.convierteEntero(speiEnvioBean.getReferenciaNum()));
							sentenciaStore.setString("Par_UsuarioEnvio",speiEnvioBean.getUsuarioEnvio());
							sentenciaStore.setInt("Par_AreaEmiteID",areaBanco);
							sentenciaStore.setString("Par_OrigenOperacion",origenOperacion);

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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transferencia spei", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

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
	//--------------------------getter y setter-----------------


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

}
