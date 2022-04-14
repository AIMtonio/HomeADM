package ventanilla.dao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguridad.servicio.SeguridadRecursosServicio;
import ventanilla.bean.CancelacionChequesBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CancelacionChequesDAO extends BaseDAO{

private final static String salidaPantalla = "S";

	public CancelacionChequesDAO(){
		super();
	}

	public static interface Enum_Tra_Movs{
		int procesa	= 1;
	}

	  /*Cancelar Cheque Emitido*/
		public MensajeTransaccionBean cancelarCheque(final CancelacionChequesBean cancelacionChequesBean,final int tipoTransaccion) {
			  MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

						try {
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call CANCELACHEQUESPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?, ?,?,?,?,?,?,?,?,?);";
											cancelacionChequesBean.setPasswdAutoriza(SeguridadRecursosServicio.encriptaPass(cancelacionChequesBean.getUsuarioAutoriza(), cancelacionChequesBean.getPasswdAutoriza()));//Encriptando la contraseña de quien autoriza
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_InstitucionIDCan", Utileria.convierteEntero(cancelacionChequesBean.getInstitucionIDCan()));
											sentenciaStore.setString("Par_NumCtaInstitCan", cancelacionChequesBean.getNumCtaBancariaCan());
											sentenciaStore.setString("Par_NumChequeCan", cancelacionChequesBean.getNumChequeCan());
											sentenciaStore.setString("Par_InstitucionID", cancelacionChequesBean.getInstitucionID());
											sentenciaStore.setString("Par_NumCtaInstit", cancelacionChequesBean.getNumCtaBancaria());

											sentenciaStore.setString("Par_NumCheque", cancelacionChequesBean.getNumCheque());
											sentenciaStore.setString("Par_Beneficiario", cancelacionChequesBean.getBeneficiario());
											sentenciaStore.setString("Par_UsuarioAutoriza", cancelacionChequesBean.getUsuarioAutoriza());
											sentenciaStore.setString("Par_Password", cancelacionChequesBean.getPasswdAutoriza());
											sentenciaStore.setString("Par_MotivoCancela", cancelacionChequesBean.getMotivoCancela());

											sentenciaStore.setInt("Par_TipoTransaccion", tipoTransaccion);
											sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(cancelacionChequesBean.getSucursalID()));
											sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(cancelacionChequesBean.getCajaID()));
											sentenciaStore.setString("Par_TipoChequeraCan", cancelacionChequesBean.getTipoChequeraCan());
											sentenciaStore.setString("Par_TipoChequera", cancelacionChequesBean.getTipoChequera());

											sentenciaStore.setString("Par_Salida",salidaPantalla);
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
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CancelacionChequesDAO.CancelacionCheques");
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
									throw new Exception(Constantes.MSG_ERROR + " .CancelacionChequesDAO.CancelacionCheques");
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


	}

