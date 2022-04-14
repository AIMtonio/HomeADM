package fondeador.dao;
import fondeador.bean.AjusteMovimientosBean;
import fondeador.bean.AmortizaFondeoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class AjusteMovimientosDAO extends BaseDAO{

	PolizaDAO polizaDAO = new PolizaDAO();

	public AjusteMovimientosDAO() {
		super();
	}

	/* Ajuste de movimientos */
	public MensajeTransaccionBean ajuste(final AmortizaFondeoBean detalleAjuste, final AjusteMovimientosBean ajusteMovimientosBean,
											final long numeroTransaccion, final String numeroPoliza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CREFONAJUSTEMOVPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitutFondeoID",Utileria.convierteEntero(ajusteMovimientosBean.getInstitutFondID()));
									sentenciaStore.setInt("Par_LineaFondeoID",Utileria.convierteEntero(ajusteMovimientosBean.getLineaFondeoID()));
									sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(ajusteMovimientosBean.getCreditoFondeoID()));
									sentenciaStore.setInt("Par_AmortizacionID",Utileria.convierteEntero(detalleAjuste.getAmortizacionID()));
									sentenciaStore.setString("Par_EstatusAmortiza",detalleAjuste.getEstatusAmortiza());

									sentenciaStore.setDouble("Par_SaldoInteres",Utileria.convierteDoble(detalleAjuste.getSaldoInteres()));
									sentenciaStore.setDouble("Par_SaldoMora",Utileria.convierteDoble(detalleAjuste.getSaldoMoratorios()));
									sentenciaStore.setDouble("Par_SaldoComFalPag",Utileria.convierteDoble(detalleAjuste.getSaldoComFaltaPago()));
									sentenciaStore.setDouble("Par_SaldoOtrasComisi",Utileria.convierteDoble(detalleAjuste.getSaldoOtrasComisiones()));
									sentenciaStore.setString("Par_AltaEncPoliza",detalleAjuste.getAltaEncPoliza());

									sentenciaStore.setLong("Par_PolizaID",Utileria.convierteLong(numeroPoliza));
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " AjusteMovimientosDAO.ajuste");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " AjusteMovimientosDAO.ajuste");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Ajuste de Movimiento de Creditos de Fondeo" + e);
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

	/* se recorre la lista que se recibe de pantalla para aplicar el ajuste de movimientos  operativos y contables.*/
	public MensajeTransaccionBean grabaListaAjuste(final AjusteMovimientosBean ajusteMovimientosBean, final List listaDetalle , final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// se da de alta el encabezado de la poliza que ocupara el proceso de quitas
					PolizaBean polizaBean = new PolizaBean();
					String numeroPoliza = "";

					polizaBean.setConceptoID(ajusteMovimientosBean.conceptoCondonaCrePas);
					polizaBean.setConcepto(ajusteMovimientosBean.desConceptoConCarteraPas);
					polizaBean.setTipo(ajusteMovimientosBean.automatico);
					polizaBean.setFecha(parametrosAuditoriaBean.getFecha().toString());
					mensajeBean = polizaDAO.altaPoliza(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());

					numeroPoliza= mensajeBean.getConsecutivoString();

					AmortizaFondeoBean detalleAjuste = new AmortizaFondeoBean();

					String consecutivo= mensajeBean.getConsecutivoString();
					for(int i=0; i<listaDetalle.size(); i++){
						detalleAjuste = (AmortizaFondeoBean)listaDetalle.get(i);
						mensajeBean = ajuste(detalleAjuste, ajusteMovimientosBean,parametrosAuditoriaBean.getNumeroTransaccion(), numeroPoliza);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Ajuste Agregado.");
					mensajeBean.setNombreControl("creditoFondeoID");
					mensajeBean.setConsecutivoString(consecutivo);
					mensajeBean.setCampoGenerico(numeroPoliza);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Ajuste de Movimientos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


}
