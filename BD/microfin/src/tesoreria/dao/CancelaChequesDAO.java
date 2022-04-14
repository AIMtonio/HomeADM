package tesoreria.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import tesoreria.bean.CancelaChequesBean;
import tesoreria.bean.RenovacionOrdenPagoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CancelaChequesDAO extends BaseDAO{

	private final static String salidaPantalla = "S";
	public String conceptoCancelacionCheque="807"; //tabla CONCEPTOSCONTA
	public String conceptoCancelacionChequeDes="CANCELACION DE CHEQUE"; //tabla CONCEPTOSCONTA
	String automatico = "A"; // indica que se trata de una poliza automatica
	PolizaDAO polizaDAO = new PolizaDAO();

	public CancelaChequesDAO(){
		super();
	}

	/*Cancelar Cheque Emitido*/
	public MensajeTransaccionBean cancelacionCheque(final CancelaChequesBean cancelaChequesBean,final long numeroTransaccion) {
		  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call CANCELACIONCHEQUESPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(cancelaChequesBean.getInstitucionID()));
										sentenciaStore.setString("Par_NumCtaInstit", cancelaChequesBean.getNumCtaInstit());
										sentenciaStore.setInt("Par_NumCheque",  Utileria.convierteEntero(cancelaChequesBean.getNumCheque()));
										sentenciaStore.setInt("Par_SucursalEmision", Utileria.convierteEntero(cancelaChequesBean.getSucursalEmision()));
										sentenciaStore.setString("Par_FechaEmision", cancelaChequesBean.getFechaEmision());

										sentenciaStore.setInt("Par_NumReqGasID",  Utileria.convierteEntero(cancelaChequesBean.getNumReqGasID()));
										sentenciaStore.setInt("Par_ProveedorID",  Utileria.convierteEntero(cancelaChequesBean.getProveedorID()));
										sentenciaStore.setString("Par_NumFactura", cancelaChequesBean.getNumFactura());
										sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(cancelaChequesBean.getMonto()));
										sentenciaStore.setString("Par_Beneficiario", cancelaChequesBean.getBeneficiario());

										sentenciaStore.setString("Par_Concepto", cancelaChequesBean.getConcepto());
										sentenciaStore.setInt("Par_MotivoCancela", Utileria.convierteEntero(cancelaChequesBean.getMotivoCancela()));
										sentenciaStore.setString("Par_Comentario", cancelaChequesBean.getComentario());
										sentenciaStore.setInt("Par_TipoCancelacion",Utileria.convierteEntero(cancelaChequesBean.getTipoCancelacion()));
										sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(cancelaChequesBean.getPolizaID()));
										sentenciaStore.setString("Par_TipoChequera", cancelaChequesBean.getTipoChequera());

										sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CancelaChequesDAO.CancelaCheques");
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
								throw new Exception(Constantes.MSG_ERROR + " .CancelaChequesDAO.CancelaCheques");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Cancelacion de Cheque" + e);
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

	public MensajeTransaccionBean cancelarChequeTeso(final CancelaChequesBean cancelaChequesBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();
			polizaBean.setConceptoID(conceptoCancelacionCheque);
			polizaBean.setConcepto(conceptoCancelacionChequeDes);
			int	contador  = 0;
			// no se a dado de alta la poliza se agrega una poliza nueva

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
						String poliza = polizaBean.getPolizaID();
						try {
							cancelaChequesBean.setPolizaID(poliza);
							mensajeBean = cancelacionCheque(cancelaChequesBean, parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en cancelación de cheque", e);
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
						bajaPolizaBean.setDescProceso("CancelaChequesDAO.cancelarChequeTeso");
						bajaPolizaBean.setPolizaID(cancelaChequesBean.getPolizaID());
						MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
						mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
						loggerSAFI.error(" Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
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
			mensaje.setDescripcion("Error al Realizar Cancelación de Cheque.");
			ex.printStackTrace();
		}
		return mensaje;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
