package fira.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.apache.log4j.Logger;
import org.springframework.transaction.TransactionStatus;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.SolicitudCreditoBean;
import originacion.dao.SolicitudCreditoDAO;
import originacion.servicio.SolicitudCreditoServicio.Enum_Act_SolAgro;

import java.sql.ResultSetMetaData;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;

public class CambioFondeadorAgroDAO extends BaseDAO{

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	PolizaDAO  polizaDAO  = null;
	UsuarioDAO usuarioDAO = null;
	SolicitudCreditoDAO solicitudCreditoDAO = null;

	public CambioFondeadorAgroDAO() {
		// TODO Auto-generated constructor stub
		super();
	}

	// VALIDACION SI EL USUARIO QUE AUTORIZA EXISTE Y SU CONTRASEÑA ES CORRECTA
	public MensajeTransaccionBean validaUsuario(CreditosBean creditosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
			String contraEncrip = "";
			UsuarioBean usuarioBean = new UsuarioBean();
			UsuarioBean usuarioCon = null;

			int conClave = 6;
			contraEncrip = SeguridadRecursosServicio.encriptaPass(creditosBean.getUsuarioAutoriza(), creditosBean.getContrasenia());

			if(creditosBean.getUsuarioID().trim().isEmpty()){
				mensaje.setNumero(999);
				mensaje.setNombreControl("usuarioAutoriza");
				mensaje.setDescripcion("El Usuario no Existe");
				throw new Exception(mensaje.getDescripcion());
			}
			usuarioBean.setUsuarioID(creditosBean.getUsuarioID());
			usuarioBean.setContrasenia(contraEncrip);

			usuarioCon = usuarioDAO.consultaContraseniaUsuario(usuarioBean, conClave);
			if(usuarioCon == null){
				mensaje.setNumero(999);
				mensaje.setNombreControl("usuarioAutoriza");
				mensaje.setDescripcion("El Usuario no Existe");
				throw new Exception(mensaje.getDescripcion());
			}

			if(!contraEncrip.equals(usuarioCon.getContrasenia())){
				mensaje.setNumero(999);
				mensaje.setNombreControl("contrasenia");
				mensaje.setDescripcion("La Contraseña es Incorrecta");
				throw new Exception(mensaje.getDescripcion());
			}
			mensaje.setNumero(0);
			mensaje.setDescripcion("Validación Exitosa");

		}catch(Exception e){
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en la validacion de usuario en Cambio de Fondeador ", e);
		}
			return mensaje;
	}

	// Cambio Fuente de Fondeo
	public MensajeTransaccionBean cambioFuenteFondeo(final CreditosBean creditosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(creditosBean.cambioFondeo);
		polizaBean.setConcepto(creditosBean.desCambioFondeo);
		final Long transaccion = parametrosAuditoriaBean.getNumeroTransaccion();

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			mensaje =  polizaDAO.generaPolizaIDGenerico(polizaBean,transaccion);
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
							// Actualización de la tasa pasiva.
							mensajeBean = actualizaCreditoAgro(creditosBean,transaccion);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							creditosBean.setPolizaID(poliza);
							mensajeBean = procesoCambioFondeo(creditosBean,transaccion);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

					 catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Condonaciones de Credito", e);
					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(creditosBean.getPolizaID());
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


	public MensajeTransaccionBean procesoCambioFondeo(final CreditosBean creditosBean,final Long transaccion) {
		final String origenOperacionFondeo = "F";
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CAMBIOFONDEADORAGROPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(creditosBean.getCreditoID()));
								sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(creditosBean.getFecha()));
								sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(creditosBean.getLineaFondeo()));
								sentenciaStore.setInt("Par_InstitutFondID",Utileria.convierteEntero(creditosBean.getInstitFondeoID()));
								sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(creditosBean.getPolizaID()));

								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(creditosBean.getAdeudoTotal()));
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(creditosBean.getUsuarioID()));
								sentenciaStore.setInt("Par_LineaFondeoIDAnt",Utileria.convierteEntero(creditosBean.getLineaFondeoN()));
								sentenciaStore.setInt("Par_InstitutFondIDAnt",Utileria.convierteEntero(creditosBean.getInstitFondeoIDN()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(creditosBean.getMonedaID()));

								sentenciaStore.setString("Par_OrigenOperacion", origenOperacionFondeo);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",transaccion);

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
									ResultSetMetaData metaDatos;

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									metaDatos = (ResultSetMetaData) resultadosStore.getMetaData();

									if(metaDatos.getColumnCount()== 5){
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL NUMERO DE LA POLIZA
									}else{
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);// PARA OBTENER EL NUMERO DE LA POLIZA
									}

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " error en cambio de fondeador");
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
						throw new Exception(Constantes.MSG_ERROR + " .CambioFondeo.procesoCambioFondeo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en cambio de fondeador " + e);
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
	 * Método para Actualizar los campos de Créditos Agropecuarios.
	 * @param creditos : {@link CreditosBean} con la información del crédito.
	 * @param tipoActualizacion : Tipo de Actualización.
	 * @param numeroTransaccion : Número de transacción.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean actualizaCreditoAgro(final CreditosBean creditos, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		SolicitudCreditoBean solicitudCredito=new SolicitudCreditoBean();
		solicitudCredito.setSolicitudCreditoID(creditos.getSolicitudCreditoID());
		solicitudCredito.setCreditoID(creditos.getCreditoID());
		solicitudCredito.setTasaPasiva(creditos.getTasaPasiva());
		solicitudCredito.setAcreditadoIDFIRA(creditos.getAcreditadoIDFIRA());
		solicitudCredito.setCreditoIDFIRA(creditos.getCreditoIDFIRA());

		mensaje = solicitudCreditoDAO.actualizaSolCreditoAgro(solicitudCredito, Enum_Act_SolAgro.cambioFondeo, numeroTransaccion);

		return mensaje;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

	public SolicitudCreditoDAO getSolicitudCreditoDAO() {
		return solicitudCreditoDAO;
	}

	public void setSolicitudCreditoDAO(SolicitudCreditoDAO solicitudCreditoDAO) {
		this.solicitudCreditoDAO = solicitudCreditoDAO;
	}

}