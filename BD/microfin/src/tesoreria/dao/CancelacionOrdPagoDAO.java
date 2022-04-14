package tesoreria.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

import tesoreria.bean.CancelacionOrdPagoBean;

public class CancelacionOrdPagoDAO extends BaseDAO {

	java.sql.Date fecha = null;

	public CancelacionOrdPagoDAO(){
		super();
	}

	private final static String salidaPantalla = "S";


	/**
	 * Cancelacion de ordenes de pago
	 * @param cancelacionOrdPagoBean
	 * @param NumeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean cancelacionOrdPago(final CancelacionOrdPagoBean cancelacionOrdPagoBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CANCELACIONORDPAGPRO(?,?,?,?,?,"
																		   + "?,?,?,?,?,"
																		   + "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_FolioOperacion", cancelacionOrdPagoBean.getFolioDispersion());
									sentenciaStore.setString("Par_ClaveDispMov", cancelacionOrdPagoBean.getClaveDisMov());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CancelacionOrdPagoDAO.cancelacionOrdPago");
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
						throw new Exception(Constantes.MSG_ERROR + " .CancelacionOrdPagoDAO.cancelacionOrdPago.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de orden de pago: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método que lista los Accesorios de un crédito
	 * @param paisesBean
	 * @param tipoLista
	 * @return
	 */
	public List<CancelacionOrdPagoBean> lista(CancelacionOrdPagoBean paisesBean, int tipoLista) {
		List<CancelacionOrdPagoBean> lista=new ArrayList<CancelacionOrdPagoBean>();
		String query = "CALL ORDENESPAGOCANLIS(?,?,?,?,?,   " +
											 "?,?,?);";
		Object[] parametros = {
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OtrosAccesoriosDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call ORDENESPAGOCANLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<CancelacionOrdPagoBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CancelacionOrdPagoBean parametro = new CancelacionOrdPagoBean();
					parametro.setClaveDisMov(resultSet.getString("ClaveDispMov"));
					parametro.setFolioDispersion((resultSet.getString("FolioDispersion")));
					parametro.setSolicitudCreditoID(resultSet.getString("NombreCorto"));
					parametro.setCreditoID(resultSet.getString("CreditoID"));
					parametro.setReferencia(resultSet.getString("Referencia"));
					parametro.setEstatus(resultSet.getString("Estatus"));
					parametro.setClienteID(resultSet.getString("ClienteID"));
					parametro.setNombreCliente(resultSet.getString("NombreCliente"));
					parametro.setMonto(resultSet.getString("Monto"));

					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en CancelacionOrdPagoDAO.lista: "+ex.getMessage());
		}
		return lista;
	}


	/**
	 * Método que da cancela las ordenes de pago
	 * @param cancelacionOrdPagoBean
	 * @param listaDetalle: Lista Ordenes de pago
	 * @return
	 */
	public MensajeTransaccionBean grabaDetalle(final CancelacionOrdPagoBean cancelacionOrdPagoBean,final List<CancelacionOrdPagoBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					for(CancelacionOrdPagoBean detalle : listaDetalle){

						mensajeBean = cancelacionOrdPago(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Cancelacion de Orden de Pago: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

}