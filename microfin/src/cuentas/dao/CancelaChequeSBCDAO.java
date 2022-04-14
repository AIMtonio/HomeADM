package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cuentas.bean.CancelaChequeSBCBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.DesbloqueoMasCtaBean;
import cuentas.beanWS.request.ConsultaCuentasPorClienteRequest;
import cuentas.beanWS.request.ConsultaDisponiblePorClienteRequest;
import cuentas.beanWS.response.ConsultaCuentasPorClienteResponse;
import cuentas.beanWS.response.ConsultaDisponiblePorClienteResponse;

public class CancelaChequeSBCDAO extends BaseDAO  {

	public CancelaChequeSBCDAO() {
		super();
	}

//------------PROCESO DONDE SE ACTUALIZAN DATOS DE UNA CUENTA DE AHORRO
//............AL IGUAL QUE EL ESTATUS DE UN CHEQUE CANCELADO ----------------O------M------A------R-------
	public MensajeTransaccionBean cancelaCheque(final CancelaChequeSBCBean cancelaChequeSBCBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		//transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CANCELACHEQUESBCPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cancelaChequeSBCBean.getCuentaAhoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cancelaChequeSBCBean.getClienteID()));
								sentenciaStore.setDouble("Par_MontoComision",Utileria.convierteDoble(cancelaChequeSBCBean.getComFalsoCobro()));
								sentenciaStore.setDouble("Par_MontoIVAComision",Utileria.convierteDoble(cancelaChequeSBCBean.getMontoIva()));
								sentenciaStore.setDouble("Par_MontoCheque",Utileria.convierteDoble(cancelaChequeSBCBean.getMontoCheque()));
								sentenciaStore.setInt("Par_BancoEmisor",Utileria.convierteEntero(cancelaChequeSBCBean.getBancoEmisor()));
								sentenciaStore.setString("Par_CuentaEmisor",cancelaChequeSBCBean.getCuentaEmisor());
								sentenciaStore.setInt("Par_ChequeSBCID",Utileria.convierteEntero(cancelaChequeSBCBean.getChequeSBCID()));
								sentenciaStore.setString("Par_NombreEmisor",cancelaChequeSBCBean.getNombreEmisor());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getSucursal());

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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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

				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(0);
				mensajeBean.setDescripcion("Cheque Cancelado Exitosamente.");
				mensajeBean.setNombreControl("cuentaAhoID");

				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cargo de abono en cuenta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


}
























