package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;

import credito.bean.IntegraGruposBean;
import credito.bean.ReversaDesCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


public class ReversaDesCreditoDAO extends BaseDAO {
	PolizaDAO polizaDAO	= null;
	PolizaBean polizaBean;
	UsuarioServicio usuarioServicio = null;
	private final static String altaEnPolizaNo = "N";

	public ReversaDesCreditoDAO() {
		super();
	}

	/* METODO PARA LA REVERSA DEL DESEMBOLSO  */
	public MensajeTransaccionBean reversaDesembolso(final ReversaDesCreditoBean reversaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();

		polizaBean.setConceptoID(ReversaDesCreditoBean.reversaDesembolso);
		polizaBean.setConcepto(ReversaDesCreditoBean.desReversaDesembolso);

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
				try {
					String poliza =polizaBean.getPolizaID();
					reversaBean.setPolizaID(poliza);
					mensajeBean=reversaDesembolsoCredito(reversaBean,parametrosAuditoriaBean.getNumeroTransaccion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Desembolso De Credito", e);
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
	//********** METODO PARA LA REVERSA DEL DESEMBOLSO  **********
	public MensajeTransaccionBean reversaDesembolsoCredito(final ReversaDesCreditoBean reversaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call REVDESEMCREDITOPRO(?,?,?,?,?,?,  ?,?,?, ?,?,?, ?,?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(reversaBean.getCreditoID()));
					sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(reversaBean.getPolizaID()));
					sentenciaStore.setString("Par_AltaEncPoliza",altaEnPolizaNo);
					sentenciaStore.setString("Par_UsuarioClave",reversaBean.getUsuarioAutorizaID());
					sentenciaStore.setString("Par_ContraseniaAut",reversaBean.getContraseniaUsuarioAutoriza());
					sentenciaStore.setString("Par_Motivo",reversaBean.getMotivoReversa());

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					//Parametros de OutPut
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
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
						mensajeTransaccion.setCampoGenerico(String.valueOf(numTransaccion));

					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaDesembolso");
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
				throw new Exception(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaDesembolso");
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
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Desembolso De Credito", e);
		}
		return mensajeBean;
			}
		});
	return mensaje;
	}

	public MensajeTransaccionBean reversaDesembolsoProceso(final ReversaDesCreditoBean reversaBean,final List listaIntegrantes ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				UsuarioBean usuarioBean = new UsuarioBean();
				try {
					IntegraGruposBean integraGrupo 	= null;
					//List listaIntegrantes = null;

					if(reversaBean.getGrupoID() != null && !reversaBean.getGrupoID().equalsIgnoreCase(Constantes.STRING_CERO)){
						//Reversa de un Credito Grupal
						integraGrupo = new IntegraGruposBean();
						integraGrupo.setGrupoID(reversaBean.getGrupoID());

						if(listaIntegrantes!= null && listaIntegrantes.size()>0) {
							ReversaDesCreditoBean reversaIntegraBean = null;
							String passValidaUser = null;
							String presentedPassword = reversaBean.getContraseniaUsuarioAutoriza();
							/* -- -----------------------------------------------------------------
							 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
							 * -- -----------------------------------------------------------------
							 */
							usuarioBean.setClave(reversaBean.getUsuarioAutorizaID());
							usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
							if(usuarioBean == null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(404);
								mensajeBean.setDescripcion("Usuario Invalido");
								return mensajeBean;
							}
							reversaBean.setUsuarioAutorizaID(usuarioBean.getClave());
							if(presentedPassword.contains("HD>>")){
								loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Inicia Validacion de Token de Huella [ReversaDesCreditoDAO.reversaDesembolsoProceso]");
					        	presentedPassword = presentedPassword.replace("HD>>", "");
					        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), presentedPassword));
					        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(reversaBean.getUsuarioAutorizaID());
					        	if(reversaBean.getContraseniaUsuarioAutoriza().equals(passValidaUser)){

					        		reversaBean.setContraseniaUsuarioAutoriza(usuarioBean.getContrasenia());

					        	}else{
					        		mensajeBean = new MensajeTransaccionBean();
					        		mensajeBean.setNumero(405);
					        		mensajeBean.setDescripcion("Token Huella Invalida");
					        		return mensajeBean;
					        	}
					        	loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Fin Validacion de Token de Huella [ReversaDesCreditoDAO.reversaDesembolsoProceso]");

					        }else{
					        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), reversaBean.getContraseniaUsuarioAutoriza()));
					        }

							for(int i = 0; i<listaIntegrantes.size(); i++){
								integraGrupo = (IntegraGruposBean)listaIntegrantes.get(i);
								reversaIntegraBean = new ReversaDesCreditoBean();
								reversaIntegraBean.setCreditoID(integraGrupo.getCreditoID());
								reversaIntegraBean.setUsuarioAutorizaID(reversaBean.getUsuarioAutorizaID());
								reversaIntegraBean.setContraseniaUsuarioAutoriza(reversaBean.getContraseniaUsuarioAutoriza());
								reversaIntegraBean.setMotivoReversa(reversaBean.getMotivoReversa());

								// llama al metodo que hace el desembolso
								mensajeBean = reversaDesembolso(reversaIntegraBean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

					}else{
						//Reversa de transaccionDAO.generaNumeroTransaccion();un Credito Individual
						String passValidaUser = null;
						String presentedPassword = reversaBean.getContraseniaUsuarioAutoriza();
						/* -- -----------------------------------------------------------------
						 *  Consulta para otener la clave del usuario sin importar si es mayuscula o minuscula
						 * -- -----------------------------------------------------------------
						 */
						usuarioBean.setClave(reversaBean.getUsuarioAutorizaID());
						usuarioBean= usuarioServicio.consulta(Enum_Con_Usuario.clave,usuarioBean);
						if(usuarioBean == null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(404);
							mensajeBean.setDescripcion("Usuario Invalido");
							return mensajeBean;
						}
						reversaBean.setUsuarioAutorizaID(usuarioBean.getClave());

				        if(presentedPassword.contains("HD>>")){
				        	loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Inicia Validacion de Token de Huella [ReversaDesCreditoDAO.reversaDesembolsoProceso-268]");
				        	presentedPassword = presentedPassword.replace("HD>>", "");
				        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), presentedPassword));
				        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(reversaBean.getUsuarioAutorizaID());
				        	if(reversaBean.getContraseniaUsuarioAutoriza().equals(passValidaUser)){

				        		reversaBean.setContraseniaUsuarioAutoriza(usuarioBean.getContrasenia());
				        		mensajeBean = reversaDesembolso(reversaBean);

				        	}else{
				        		mensajeBean = new MensajeTransaccionBean();
				        		mensajeBean.setNumero(405);
				        		mensajeBean.setDescripcion("Token Huella Invalida");
				        		return mensajeBean;
				        	}
				        	loggerSAFI.info("SAFIHUELLAS: "+reversaBean.getUsuarioAutorizaID()+"-  Fin Validacion de Token de Huella [ReversaDesCreditoDAO.reversaDesembolsoProceso-268]");
				        }else{
				        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), reversaBean.getContraseniaUsuarioAutoriza()));
				        	mensajeBean = reversaDesembolso(reversaBean);
				        }
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaDesembolso");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					return mensajeBean;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Desembolso De Credito", e);
				}
				return mensajeBean;
			}
		});
	return mensaje;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
