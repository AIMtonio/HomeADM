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

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.dao.CajasVentanillaDAO;
import ventanilla.servicio.CajasVentanillaServicio.Enum_Con_CajasVentanilla;
import credito.bean.ReversaPagoCreditoBean;


import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ReversaPagoCreditoDAO extends BaseDAO{
	CajasVentanillaDAO cajasVentanillaDAO;
	ParametrosSesionBean parametrosSesionBean;
	UsuarioServicio usuarioServicio = null;
	public ReversaPagoCreditoDAO(){
		super();
	}
	//********** METODO PARA LA REVERSA DEL PAGO DE CRÉDITO **********
	public MensajeTransaccionBean reversaPagoCredito(final ReversaPagoCreditoBean reversaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REVERSAPAGCREPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,  ?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(reversaBean.getCreditoID()));
									sentenciaStore.setString("Par_UsuarioClave",reversaBean.getUsuarioAutorizaID());
									sentenciaStore.setString("Par_ContraseniaAut",reversaBean.getContraseniaUsuarioAutoriza());
									sentenciaStore.setString("Par_Motivo",reversaBean.getMotivoReversa());
									sentenciaStore.setInt("Par_TranRespaldo",Utileria.convierteEntero(reversaBean.getTranRespaldo()));
									sentenciaStore.setString("Par_FormaPago", reversaBean.getFormaPago());

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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt(1)));
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setCampoGenerico(String.valueOf(numTransaccion));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReversaPagoCreditoDAO.reversaPagoCredito");
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
						throw new Exception(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaPagoCredito");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Pago De Credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean reversaPagoCreditoProceso(final ReversaPagoCreditoBean reversaBean,final List listaIntegrantes ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
				CajasVentanillaBean cajasVentanilla= new CajasVentanillaBean();
				UsuarioBean usuarioBean = new UsuarioBean();
				try {
					// se realiza la reversa del cargo y abono a cuenta, poliza contable, amortizaciones, y saldos del credito
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
			        	presentedPassword = presentedPassword.replace("HD>>", "");
			        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), presentedPassword));
			        	passValidaUser = SeguridadRecursosServicio.generaTokenHuella(reversaBean.getUsuarioAutorizaID());
			        	if(reversaBean.getContraseniaUsuarioAutoriza().equals(passValidaUser)){

			        		reversaBean.setContraseniaUsuarioAutoriza(usuarioBean.getContrasenia());
			        		mensajeBean = reversaPagoCredito(reversaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			        	}else{
			        		mensajeBean = new MensajeTransaccionBean();
			        		mensajeBean.setNumero(405);
			        		mensajeBean.setDescripcion("Token Huella Invalida");
			        	}
			        }else{
			        	reversaBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(reversaBean.getUsuarioAutorizaID(), reversaBean.getContraseniaUsuarioAutoriza()));
						mensajeBean = reversaPagoCredito(reversaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			        }
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					// Se realiza la reversa de los movimientos de caja, saldos de caja y denominaciones si el pago fue por ventanilla
					if(reversaBean.getFormaPago().equalsIgnoreCase("E")){
						mensajeBean = reversaPagoCreditoEfectivo(reversaBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
							// Actualizamos el Saldo de la Caja
						if(parametrosSesionBean.getCajaID() !=null ){
							if (Utileria.convierteEntero(parametrosSesionBean.getCajaID()) >0 ){
								cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
								cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
								cajasVentanilla = cajasVentanillaDAO.consultaSaldosCaja(cajasVentanillaBean, Enum_Con_CajasVentanilla.saldos);
								parametrosSesionBean.setLimiteEfectivoMN(cajasVentanilla.getLimiteEfectivoMN());
								parametrosSesionBean.setSaldoEfecMN(cajasVentanilla.getSaldoEfecMN());
							}
						}
					}

					mensajeBean.setConsecutivoString(reversaBean.getCreditoID() + "-"+parametrosAuditoriaBean.getNumeroTransaccion() );


					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaPagoCredito");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Pago De Credito", e);
				}

				return mensajeBean;
			}
		});
		mensaje.setCampoGenerico(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		return mensaje;
	}

	public MensajeTransaccionBean reversaPagoCreditoEfectivo(final ReversaPagoCreditoBean reversaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REVPAGOCREEFECPRO(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TranRespaldo",Utileria.convierteEntero(reversaBean.getTranRespaldo()));
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

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString()+":::");
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReversaPagoCreditoDAO.reversaPagoCreditoEfectivo");
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
						throw new Exception(Constantes.MSG_ERROR + " .ReversaDesCreditoDAO.reversaPagoCreditoEfectivo");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Reversa de Pago De Credito en efectivo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public CajasVentanillaDAO getCajasVentanillaDAO() {
		return cajasVentanillaDAO;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setCajasVentanillaDAO(CajasVentanillaDAO cajasVentanillaDAO) {
		this.cajasVentanillaDAO = cajasVentanillaDAO;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}
	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}




}
