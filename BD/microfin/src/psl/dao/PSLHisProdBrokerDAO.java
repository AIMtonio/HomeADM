package psl.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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

import psl.bean.PSLHisProdBrokerBean;
import soporte.bean.EdoCtaEnvioCorreoBean;

public class PSLHisProdBrokerDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public MensajeTransaccionBean paseHistoricoProductosBroker(final int tipoProceso, final PSLHisProdBrokerBean pslHisProdBrokerBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL PSLHISPRODBROKERPRO(?,?,?,?,?,?,?,?,?,?,?,?,   ?,   ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_FechaPaseHis", pslHisProdBrokerBean.getFechaPaseHis() );
									sentenciaStore.setString("Par_FechaCatalogo", Constantes.FECHA_VACIA);
									sentenciaStore.setInt("Par_ServicioID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Servicio", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_TipoServicio", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_ProductoID", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Producto", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_TipoFront", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_DigVerificador", Constantes.STRING_VACIO);
									sentenciaStore.setDouble("Par_Precio", Constantes.DOUBLE_VACIO);
									sentenciaStore.setString("Par_ShowAyuda", Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_TipoReferencia", Constantes.STRING_VACIO);

									sentenciaStore.setInt("Par_NumPro", tipoProceso);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Par_ProgramaID", "PSLHisProdBrokerDAO.paseHistoricoProductosBroker");
									sentenciaStore.setInt("Par_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Par_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PSLHisProdBrokerDAO.paseHistoricoProductosBroker");
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
						throw new Exception(Constantes.MSG_ERROR + " .EdoCtaEnvioCorreoDAO.altaEdoCtaEnvioCorreo");
					}
					else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar el pase a historico de los productos actuales " + e);
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

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
